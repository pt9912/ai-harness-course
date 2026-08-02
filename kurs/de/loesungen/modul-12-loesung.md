# Lösung — Modul 12: Replay und Evaluierung

Zugehöriges Modul: [Modul 12 — Replay und Evaluierung](../04-qualitaet/modul-12-replay-evaluierung.md).

## Selbstcheck-Antworten

### (Erinnern) Welche drei Positionen muss ein Replay-Manifest mindestens festhalten — und welche davon ist keine einzelne Zeile?

1. **Eingaben** als referenzierter Datensatz (Hash + Pfad), nicht inline-Text.
2. **Aufnahme-Zeitpunkt** — damit spätere Läufe ihren Diff datieren können.
3. **Je ein Feld pro Zufallsquelle des Laufs** — beim Domänen-Modell der
   Seed samt Ableitungsregel, dazu die Entscheidungsregeln (Tie-Break,
   Sortierstabilität, Grenzwerte) in einem `determinism:`-Block.

Die dritte ist die gesuchte: eine *Familie*, keine Zeile. Wie viele Felder
sie umfasst, entscheidet der Lauf, nicht die Vorlage — hat er zwei
Zufallsquellen, sind es zwei Einträge. Genau daran scheitert das Auswendiglernen
einer festen Feldliste.

Zwei weitere trennen ernsthaftes von symbolischem Replay, wie im Modul-Abschnitt
[Begriff: Image-Hash](../04-qualitaet/modul-12-replay-evaluierung.md#begriff-image-hash-vorgriff-aus-modul-14)
erklärt:

4. **Image-Hash** der Toolchain — sonst lässt sich Modell-Drift nicht
   von Toolchain-Drift trennen.
5. **Modellversion** — die konkrete Kennung, nicht die Familie.

Welches Feld *trägt*, hängt von der Art des Kerns ab: beim
Domänen-Modell ist der Seed der Hauptanker und die Version nachgeordnet;
beim Inferenz-Modell ist es umgekehrt — dort entfällt der Seed oft ganz
(die Anthropic Messages API bietet Stand 2026-08 keinen Seed-Parameter),
und an seine
Stelle tritt der Prompt-Kontext.

Wer nur eine Quelle pinnt, pinnt eine *einzige* von mehreren
Drift-Quellen (siehe Modul 12 §"Typische Fehlvorstellungen"): die
übrigen driften unabhängig weiter — und erscheinen dann als diffuse
Drift, die niemand klar zuordnen kann.

### Was muss ein Replay festhalten, damit er deterministisch ist?

**Fall Domänen-Modell** (der Regelfall) — mindestens:

- **Zufallsquelle:** Seed *und* die Regel, wie daraus Sub-Ströme abgeleitet werden. Ein Seed ohne Ableitungsregel ist nur reproduzierbar, solange niemand die Aufrufreihenfolge ändert.
- **Entscheidungsregeln bei Gleichstand:** Tie-Break, Sortierstabilität, Grenzwerte. Die häufigste stille Drift-Quelle, weil sie kein Versionsfeld haben.
- **Version der Komponente**, die den Kern implementiert.
- **Umgebungszustand:** Zeit, Locale (bestimmt die Sortierreihenfolge!), sichtbare CPU-Zahl bei Thread-Pools.
- **Externe Antworten**, die der Lauf erhielt: Tool-Results, HTTP-Antworten, Dateiinhalte. Diese werden für den Replay *gemockt*, nicht neu abgerufen — sonst ist der Replay kein Replay.

**Fall Inferenz-Modell** (Variante) — an die Stelle des Seeds tritt:

- **Modell-ID und Version** — die konkrete Kennung ohne gleitenden Alias.
- **Eingabe-Prompt** wörtlich, inklusive System-Prompt und aller injizierten Kontext-Stücke (AGENTS.md, ADRs, Spec).
- **Tool-Definitionen** wörtlich (Name, Schema, Reihenfolge, Allowlist-Stand).
- **Sampling-Parameter**, *falls* die API sie anbietet — auf den aktuellen Anthropic-Modellen sind `temperature`/`top_p`/`top_k` entfernt, und einen Seed-Parameter gibt es nicht (Stand 2026-08; datierte Beobachtung, keine Konstante). Dann ist der Prompt-Kontext der einzige verbleibende Anker.
- **Externe Antworten** wie oben, gemockt.

Was *nicht* in den Replay gehört, sondern aufgezeichnet wird:

- Aktueller Output des Agenten.
- Aktuelle Tool-Calls.
- Aktuelle Tokens-Verbrauch.

Wenn ein Replay nicht deterministisch ist, ist meist eine externe
Antwort *nicht* gemockt — der Agent ruft die Realität an, die sich
geändert hat. Häufiger Übeltäter: Filesystem-Stand oder Datums-Funktion.

Merksatz aus der Fehlvorstellung "Determinismus = Reproduzierbarkeit":
der Seed pinnt nur *eine* von mehreren Drift-Quellen. Tool-Subversions,
lokale Zeit, Locale und Sortierreihenfolge, sichtbare CPU-Zahl,
Netz-Latenz — bei Inferenz-Modellen zusätzlich Modell-Routing innerhalb
derselben Version und der Prompt-Kontext — driften unabhängig weiter.
Determinismus entsteht erst, wenn *alle* Quellen gepinnt oder gemockt
sind.

### (Analysieren — aktiviert LZ 3) Drift quantifizieren — 3 von 20 rot

Die **Drift-Rate** = rote Fälle ÷ Gesamt-Fälle = 3 ÷ 20 = **15 %**.

Was die Zahl sichtbar macht, das "drei rot" allein verbirgt:

- **Trend über Modellversionen.** Steigt die Rate über mehrere Wechsel
  (5 % → 10 % → 15 %), ist der *Modellpfad selbst* der Verdächtige, nicht
  ein Einzelfall — eine ordinale Notiz lässt sich zwischen Läufen nicht
  vergleichen, ein Prozentwert schon.
- **Steering-Loop-Schwelle.** Eine Zahl erlaubt eine *Regel* ("ab
  Drift-Rate > 10 % Carveout-Pflicht + Erwartungs-Update-Slice"). "Ein
  paar rot" ist keine Schwelle, an der ein Sensor auslösen kann.

Wichtig: Die Rate ersetzt nicht die Diagnose-Reihenfolge aus Schritt 6
(Toolchain → Modell-Drift → Erwartung → echte Regression) — sie sagt,
*wie viel* driftet, die Reihenfolge sagt, *was* driftet.

### (Bewerten — aktiviert LZ 4, Bewerten-Hälfte) Wann wird ein Golden Set giftig (überfittet)?

Drei Symptome:

1. **Golden grün, Realität rot**: Du fügst Replays aus echten User-Beschwerden hinzu und siehst, dass Golden weiterhin grün, aber Fehler in Produktion auftreten. Das Golden Set kennt die Realität nicht mehr.
2. **Golden grün nur mit ein-Modell**: Du wechselst das Modell und alles ist rot. Das Set hat sich an Modell-Idiosynkrasien gewöhnt (Wort-Wahl, Reihenfolge der Tool-Calls).
3. **Golden wird selten erweitert**: Über Wochen keine neuen Einträge. → Steering Loop läuft nicht, jedes Versagen sollte ein neues Golden-Set-Item erzeugen.

Gegenmittel:

- Rotieren: alte Golden-Items, deren Klasse durch andere abgedeckt ist, retiren.
- Mischformen: semantische Bewertungsmetrik *zusätzlich* zur Exact-Match. Inferenz-Modelle ändern Formulierung, ohne Inhalt zu ändern.
- Mindestens einmal pro Quartal ein "Golden-Set-Audit" als eigener Slice: wer hat zuletzt was eingespeist, was wurde nie getriggert?

### (Erschaffen — aktiviert LZ 4, Erschaffens-Hälfte) Rotations- und Sampling-Plan für ein überfittetes Golden Set

Ausgangslage laut Frage: seit 14 Wochen 100 % grün im Replay, neue
Eingabe-Klassen tauchen nur in Produktion auf — das Set ist zum
Eintrainierten-Set geworden. Ein konkreter Plan:

1. **Rotations-Anteil pro Closure:** 20 % der *ältesten* Fälle je
   Closure raus — Slice oder Welle, je nachdem, was dein Repo führt (bei
   20 Fällen: 4). Kriterium fürs Retiren: die Fehlerklasse
   des Falls ist durch einen anderen Fall abgedeckt *oder* der Fall hat
   seit drei Rotationen nie ein Rot erzeugt (er misst nichts mehr).
2. **Quellen der neuen Fälle** — zwei, in dieser Priorität:
   - **Produktions-Traces:** genau die Eingabe-Klassen, die bisher nur
     in Produktion auftauchen — jede User-Beschwerde und jeder
     Produktions-Fehler wird als Fall mit Erwartung-als-Verhalten
     kuratiert (nicht roh kopiert).
   - **Adversarial-Beispiele aus Steering-Loop-Einträgen:** Muster aus
     der Reflexionsvorlage ("dieselbe Halluzination dreimal") werden
     als Negative-Fälle eingespeist.
3. **Re-Baseline nach jeder Rotation:** Replay-Lauf gegen das
   rotierte Set, neues Manifest-Datum, CHANGELOG-Eintrag (Worked
   Example Schritt 7) — sonst ist nicht unterscheidbar, ob spätere
   Rötung von der Rotation oder vom Modell kommt.
4. **Stopp-Kriterium gegen Über-Rotation:** ein **stabiler
   Regressions-Kern** von Anker-Fällen (z. B. 30 % des Sets), die *nie*
   rotieren — pro Kern-Fehlerklasse (Happy/Boundary/Negative je
   kritischem Tool) mindestens ein Anker. Wer alles rotiert, verliert
   die Regressions-Funktion: ein Set, das sich schneller ändert als
   das Modell, kann keinen Modell-Drift mehr messen.

Begründung der Konstruktion: Der Plan bekämpft beide Gift-Symptome
getrennt — Rotation entfernt totes Gewicht, Sampling holt die fehlende
Realität herein — und sichert mit dem Anker-Kern die Vergleichbarkeit.
Vorhersage als Erfolgs-Test: nach der ersten Rotation *steigt* die
Failure-Rate kurzfristig. Das ist Erfolg, nicht Defekt — das Set misst
wieder etwas. Bleibt es bei 100 % grün, war die Rotation kosmetisch.

### (Anwenden) Zwei Drift-Quellen — welche zuerst messen?

In der ersten Woche zwei konkrete:

1. **Modellversion-/Routing-Drift.** Der Provider routet "gleicher Tag"
   intern auf verschiedene Subversions — der API-Tag bleibt stabil, das
   Verhalten driftet. Sensor: zwei Replays desselben Manifests im Abstand
   von Tagen vergleichen, Diff betrachten.
2. **Toolchain-Drift.** Tool-Subversion oder Image-Hash anders als im
   Manifest — Test-Library aktualisiert, Linter strenger, Compiler
   anders. Sensor: Image-Hash-Vergleich zwischen Manifest und aktuellem
   Build.

Warum *diese* beiden zuerst:

- Beide haben einen *sofortigen* Sensor (Manifest-Vergleich).
- Beide sind in einer Woche messbar (drei Läufe reichen für ein Signal).
- Beide sind *Voraussetzungen* für andere Messungen. Eingabe-Distribution
  oder Cache-Verhalten zu messen, *bevor* Modell und Toolchain stabil
  sind, misst Rauschen.

Die Reihenfolge ist nicht beliebig. Wer zuerst Eingabe-Distribution
analysiert, sieht Drift — aber ohne Toolchain-Pinning kann er nicht
sagen, ob das an der Distribution oder am Linter liegt.

### (Erschaffens-Prozess) Welcher Schritt beim Replay-Manifest war der unsicherste?

Hier gibt es keine "richtige" Antwort — der Maßstab ist, dass ein
*konkreter* Schritt benannt wird **mit Begründung**, nicht "Schritt 3
war schwer". Zwei erfahrungsgemäß häufige Kandidaten:

- **Schritt 3 (Erwartungen als Verhalten, nicht als Wortlaut)** — die
  häufigste Bruchstelle. Die Unsicherheit liegt in der Frage, was
  *semantisch gleich genug* ist: zu enge Erwartungen (Exact-Match auf
  Fließtext) brechen beim ersten Modellwechsel, zu weite
  (`must_include: ["ok"]`) lassen echte Regressionen durch. Die
  Entscheidung ist eine Spec-Entscheidung, kein Tooling-Detail.
- **Schritt 6 (Drift-Diagnose-Reihenfolge)** — die zweithäufigste. Wer
  ohne feste Reihenfolge testet, klassifiziert echte Regressionen als
  Toolchain-Drift und umgekehrt; die Unsicherheit zeigt sich daran,
  dass man bei der ersten Rötung nicht weiß, *welchen* Verdächtigen
  man zuerst ausschließt.

Anti-Antwort: "Keiner war unsicher, hat alles geklappt." Wenn beim
ersten Manifest-Aufbau kein Schritt Unsicherheit erzeugt hat, wurden
die Erwartungen vermutlich nie bewusst gebrochen (Schritt 4: erst
Manifest schärfen, nicht die Implementierung anfassen) — die Unsicherheit kommt
dann später, in Produktion.

## Übungshinweise

### Reproduzierbare Testläufe gegen ein Golden Set

Maßstab:

- Pro Run wird ein Run-Manifest erzeugt: Modell, Seed, alle Input-Hashes, alle gemockten Antworten, Output-Hashes.
- Zwei aufeinanderfolgende Runs derselben Eingabe erzeugen identische Manifest-Hashes (im Output). Nur wo Fließtext im Spiel ist, tritt an die Stelle des Hash-Vergleichs ein semantischer Vergleicher, der "Outputs sind äquivalent" mit Begründung meldet.
- Replay-Lauf hat keinen Netzzugriff — alles aus Mock-Files.

### (Erschaffen + Bewerten — aktiviert LZ 2) Mini-Golden-Set für die Ranking-Stufe entwerfen

Szenario: Zu einer Anfrage liefert die Suche die besten Treffer; bei
Punktgleichstand entscheidet die Tie-Break-Regel. Beispiel-Set mit drei
Fällen — Erwartungen *als Verhalten, nicht als Wortlaut*
(Worked Example A Schritt 3):

**Fall 1 — Happy:** Anfrage mit einem eindeutig besten Treffer.

```json
{
  "top_doc_path": "docs/handbuch/kapitel-03.md",
  "top_score_min": 0.72,
  "result_count_min": 1
}
```

*Auswahlkriterium:* fängt die Grundfunktions-Regression — findet die
Stufe den offensichtlichen Treffer überhaupt noch, und hält sein Score
die Untergrenze?

**Fall 2 — Boundary:** Anfrage, bei der zwei Dokumente denselben Score
erreichen.

```json
{
  "top_doc_path": "docs/handbuch/kapitel-03.md",
  "tied_with": ["docs/anhang/kapitel-03.md"],
  "tie_break_stable": true
}
```

*Auswahlkriterium:* fängt den Tie-Break — die Fehlerklasse aus der
Engage-Situation und die einzige, die kein anderer Fall sieht. Fall 1
kann sie nicht fangen, weil dort gar kein Gleichstand entsteht. Dass
hier die *Reihenfolge* zugesichert wird, ist kein Rückfall in den
Wortlaut: Bei Gleichstand **ist** die Reihenfolge die Zusage.

**Fall 3 — Negative:** Anfrage, zu der nichts über der Score-Schwelle
liegt.

```json
{
  "result_count": 0,
  "max_score_below": 0.30,
  "fallback_used": false
}
```

*Auswahlkriterium:* fängt das Fail-open-Verhalten — die Stufe muss die
leere Menge zurückgeben, statt die Schwelle still zu senken oder auf
einen Fallback auszuweichen. Die beiden anderen Fälle erreichen diesen
Pfad nie.

Begründung der Konstruktion: Jeder Fall fängt eine eigene Fehlerklasse
(Grundfunktion · Gleichstand · Fail-open), und keine Erwartung hängt an
einer kopierten Trefferliste — Schwellen und Invarianten überleben eine
Score-Verschiebung in der vierten Nachkommastelle, ein wörtlich
übernommenes Ergebnis-Array nicht. Exact-Match auf den *Feldern* ist
hier dagegen richtig: Die Stufe ist deterministisch, die Falle ist die
umgekehrte — eine zu weiche Erwartung, die eine echte Abweichung
durchwinkt. Struktur-Vergleich: das Lab-Set
`lab/example/evals/golden/welle-1-baseline/` (drei Cases
Happy/Boundary/Negative je LH-FA-02) nutzt dasselbe Schema für einen
gemischten Fall, in dem zusätzlich ein Embedding-Modell mitläuft.

Anti-Antwort: drei Anfragen mit jeweils eindeutigem Treffer (kurze
Anfrage, lange Anfrage, englische Anfrage) — das ist ein Demo-Set, kein
Golden Set: alle drei fangen dieselbe Fehlerklasse, Gleichstand und
Fehlerpfad bleiben unbeobachtet.

### (Analysieren — aktiviert LZ 3) Drift quantifizieren

**Wo das läuft:** im eigenen Repo mit echtem Replay-Runner. Das Lab-Target
`make replay` validiert nur die Struktur des Fixtures und führt keinen Lauf
aus — es kann keinen roten Fall erzeugen. Ohne eigenen Runner: an der
Selbstcheck-Vorgabe (3 von 20 rot) rechnen.

Vorgehen:

1. Baseline-Lauf gegen den eingefrorenen Stand → grün.
2. *Eine* Quelle ändern — Tie-Break-Regel, Seed-Ableitung oder
   Modellversion — und erneut laufen: was wird rot?
3. **Quantifizieren:** Drift-Rate = rote ÷ gesamte Fälle als Zahl
   festhalten (z. B. 3/20 = 15 %), nicht "ein paar rot" — nur die Zahl
   ist zwischen Läufen vergleichbar und kann eine
   Steering-Loop-Schwelle treiben.
4. **Der Diagnose-Reihenfolge aus Schritt 6 zuordnen** — in dieser
   Reihenfolge, nicht nach Bauchgefühl: Toolchain (Image-Hash
   identisch?) → Modell-Drift (`model.version` · `model.seed` ·
   `determinism:` verglichen; bei Inferenz-Modellen zusätzlich der
   Provider-Status) → Erwartungs-Drift (Erwartung zu eng formuliert?) →
   echte Regression (alles oben ausgeschlossen).
5. Klassifiziere die verbleibenden echten roten Fälle: Format-Drift
   (Reihenfolge, Rundung), inhaltliche Verschiebung, neue Fehler —
   welche Klasse ist akzeptabel, welche ist Show-Stopper?

Diese Übung ist gleichzeitig die Probe für jede Änderung am Kern: In
Produktion bedeutet ein Austausch der Tie-Break-Regel, der Zufallsquelle
oder der Modellversion genau diesen Lauf — vorher.
Häufiger Fehler: bei der ersten Rötung direkt "echte Regression"
rufen und einen Carveout an der falschen Stelle einbauen — die
Diagnose-Reihenfolge existiert genau dagegen.

### (Analysieren + Anwenden — aktiviert LZ 1) Zeige, dass der Lab-Sensor den Modellwechsel nicht sieht

Erwartetes Ergebnis — **dreimal grün**:

```
cp -r evals/golden/welle-1-baseline evals/golden/drift-test
make replay RUN=drift-test                     -> replay set ok (3 cases)
# model.name + model.version im Manifest aendern
make replay RUN=drift-test                     -> replay set ok (3 cases)
# zusaetzlich top_doc_path + top_score_min verfaelschen
make replay RUN=drift-test                     -> replay set ok (3 cases)
```

Wer hier eine Rötung erwartet hat, hat die Zusage des Targets mit seiner
Prüfung verwechselt. Das Target prüft *Existenz und Form*: Manifest da,
`model:`- und `runtime:`-Block da, mindestens drei Fälle, `inputs` und
`expectations` gleich lang. Es liest keinen Wert *innerhalb* der Blöcke.

**Was ein Runner vergleichen müsste** — alle drei Felder stehen bereits im
Manifest, keines wird eingelöst:

| Feld | wogegen | fängt |
|---|---|---|
| `runtime.image_hash` | Hash des Vorlaufs | Toolchain-Drift |
| `model.name` + `model.version` | Manifest des Vorlaufs | Modell-Wechsel |
| `verification.per_case_hash` | Hash je Case über zwei Läufe | Nicht-Determinismus |

Die Reihenfolge ist die Diagnose-Reihenfolge aus Schritt 6 — kein Zufall:
Ein Runner, der `image_hash` nicht vergleicht, kann Toolchain-Drift nie
ausschließen und meldet ihn als Modell-Regression.

**Die eigentliche Pointe** ist keine Replay-Pointe, sondern eine
Gate-Pointe: Das Manifest sagt *„Hash-Vergleich pro Case in CI
verpflichtend"*, und kein Target löst das ein. Eine Zusage ohne Deckung ist
kein Gate, sondern ein Vorschlag — dieselbe Fehlvorstellung, die
[Modul 13](../04-qualitaet/modul-13-quality-gates.md#typische-fehlvorstellungen)
unter *„Wenn ein Gate manchmal rot sein darf, ist das pragmatisch"* führt.
Im Lab ist das eine deklarierte Grenze; in deinem Repo wäre es ein Befund.

## Häufige Fehler

- **Replay-Tests laufen mit echtem Netz**. → Kein Replay, sondern Live-Test mit alten Erwartungen. Wird flaky.
- **Exact-Match als einziges Erfolgskriterium — dort, wo die Ausgabe variabel ist.** → Erzeugt ein Inferenz-Modell Fließtext, produziert schon minimaler Format-Drift False-Positive-Failures; dort gehört mindestens *eine* semantische Metrik dazu. Bei einem deterministischen Domänen-Modell ist Exact-Match dagegen genau richtig — die Falle ist dort die umgekehrte: eine zu weiche Metrik, die echte Abweichungen durchwinkt.
- **Golden Set wird in einem CSV gepflegt**, das niemand reviewt. → Wenn Golden-Set-Änderungen nicht durch denselben Slice-Lifecycle laufen wie Code, driften sie.

## Verweise

- Test-Diversität (Determinism/Replay/Fault): [Modul 12](../04-qualitaet/modul-12-replay-evaluierung.md)
- grid-gym als reales Beispiel: [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
- Vorherige Lösung: [Modul 11](modul-11-loesung.md)
- Nächste Lösung: [Modul 13](modul-13-loesung.md)
