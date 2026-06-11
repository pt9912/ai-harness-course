# Lösung — Modul 12: Replay und Evaluierung

Zugehöriges Modul: [Modul 12 — Replay und Evaluierung](../04-qualitaet/modul-12-replay-evaluierung.md).

## Selbstcheck-Antworten

### (Erinnern) Welche drei Felder muss ein Replay-Manifest mindestens festhalten?

1. **Modellversion** (konkrete API-Version oder Snapshot, nicht nur Familie).
2. **Seed** (falls der Provider Seed-Parameter unterstützt).
3. **Eingaben** als referenzierter Datensatz (Hash + Pfad), nicht inline-Text.

Pflichtfelder #4 und #5 in jedem ernsten Setup, wie im Modul-Abschnitt
[Begriff: Image-Hash](../04-qualitaet/modul-12-replay-evaluierung.md#begriff-image-hash-vorgriff-aus-modul-14)
erklärt:

4. **Image-Hash** der Toolchain — sonst lässt sich Modell-Drift nicht
   von Toolchain-Drift trennen.
5. **Aufnahme-Zeitpunkt** — damit spätere Läufe ihren Diff datieren
   können.

Wer nur Modell + Seed pinnt, pinnt eine *einzige* von mehreren
Drift-Quellen (siehe Modul 12 §"Typische Fehlvorstellungen"):
Modellversion, Sampling-Parameter, Tool-Umgebung und Prompt-Kontext
driften unabhängig davon weiter — und erscheinen dann als diffuse
Drift, die niemand klar zuordnen kann.

### Was muss ein Replay festhalten, damit er deterministisch ist?

Mindestens diese Inputs eines Agentenlaufs:

- **Modell-ID und Version** (`claude-opus-4-7@2026-06-01` reicht nicht — auch der Release-Snapshot oder die API-Version).
- **Eingabe-Prompt** wörtlich, inklusive System-Prompt und aller injizierten Kontext-Stücke (AGENTS.md, ADRs, Spec).
- **Tool-Definitionen** wörtlich (Name, Schema, Allowlist-Stand).
- **Temperature, Top-P, Seed**, falls API das unterstützt.
- **Externe Antworten**, die der Agent während des Laufs erhielt: Tool-Results, HTTP-Antworten, Dateiinhalte. Diese werden für den Replay *gemockt*, nicht neu abgerufen — sonst ist der Replay kein Replay.

Was *nicht* in den Replay gehört, sondern aufgezeichnet wird:

- Aktueller Output des Agenten.
- Aktuelle Tool-Calls.
- Aktuelle Tokens-Verbrauch.

Wenn ein Replay nicht deterministisch ist, ist meist eine externe
Antwort *nicht* gemockt — der Agent ruft die Realität an, die sich
geändert hat. Häufiger Übeltäter: Filesystem-Stand oder Datums-Funktion.

Merksatz aus der Fehlvorstellung "Determinismus = Reproduzierbarkeit":
der Seed pinnt nur *eine* von mehreren Drift-Quellen. Tool-Subversions,
lokale Zeit, Netz-Latenz, Modell-Routing innerhalb derselben Version
und der Prompt-Kontext driften unabhängig weiter — Determinismus
entsteht erst, wenn *alle* Quellen gepinnt oder gemockt sind.

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
(Toolchain → Modell-Routing → Erwartung → echte Regression) — sie sagt,
*wie viel* driftet, die Reihenfolge sagt, *was* driftet.

### (Bewerten — aktiviert LZ 4, Bewerten-Hälfte) Wann wird ein Golden Set giftig (überfittet)?

Drei Symptome:

1. **Golden grün, Realität rot**: Du fügst Replays aus echten User-Beschwerden hinzu und siehst, dass Golden weiterhin grün, aber Fehler in Produktion auftreten. Das Golden Set kennt die Realität nicht mehr.
2. **Golden grün nur mit ein-Modell**: Du wechselst das Modell und alles ist rot. Das Set hat sich an Modell-Idiosynkrasien gewöhnt (Wort-Wahl, Reihenfolge der Tool-Calls).
3. **Golden wird selten erweitert**: Über Wochen keine neuen Einträge. → Steering Loop läuft nicht, jedes Versagen sollte ein neues Golden-Set-Item erzeugen.

Gegenmittel:

- Rotieren: alte Golden-Items, deren Klasse durch andere abgedeckt ist, retiren.
- Mischformen: semantische Bewertungsmetrik *zusätzlich* zur Exact-Match. Modelle ändern Formulierung, ohne Inhalt zu ändern.
- Mindestens eine Welle pro Quartal: "Golden-Set-Audit", wer hat zuletzt was eingespeist, was wurde nie getriggert?

### (Erschaffen — aktiviert LZ 4, Erschaffens-Hälfte) Rotations- und Sampling-Plan für ein überfittetes Golden Set

Ausgangslage laut Frage: seit 14 Wochen 100 % grün im Replay, neue
Eingabe-Klassen tauchen nur in Produktion auf — das Set ist zum
Eintrainierten-Set geworden. Ein konkreter Plan:

1. **Rotations-Anteil pro Welle:** 20 % der *ältesten* Fälle pro Welle
   raus (bei 20 Fällen: 4). Kriterium fürs Retiren: die Fehlerklasse
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
3. **Re-Baseline nach jeder Rotation:** `make replay` gegen das
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
Manifest schärfen, nicht Modell tauschen) — die Unsicherheit kommt
dann später, in Produktion.

## Übungshinweise

### Reproduzierbare Testläufe gegen ein Golden Set

Maßstab:

- Pro Run wird ein Run-Manifest erzeugt: Modell, Seed, alle Input-Hashes, alle gemockten Antworten, Output-Hashes.
- Zwei aufeinanderfolgende Runs derselben Eingabe erzeugen identische Manifest-Hashes (im Output) — *oder* ein semantischer Vergleicher meldet "Outputs sind äquivalent" (mit Begründung).
- Replay-Lauf hat keinen Netzzugriff — alles aus Mock-Files.

### (Erschaffen + Bewerten — aktiviert LZ 2) Mini-Golden-Set für `summarize_doc` entwerfen

Szenario: ein Agenten-Tool, das zu einer Markdown-Datei eine
Drei-Satz-Zusammenfassung mit Quellen-Anker liefert. Beispiel-Set mit
drei Fällen — Erwartungen *als Verhalten, nicht als Wortlaut*
(Worked Example Schritt 3):

**Fall 1 — Happy:** normale Doku-Datei (~3 Seiten, klare Abschnitte).

```yaml
# expectations/case-001.json
{
  "must_include_count": {"satzendezeichen": 3},
  "must_include": ["#"],            # mindestens ein Quellen-Anker
  "must_not_include": ["error", "traceback"],
  "tool_calls": {"read_file": {"min": 1, "max": 1}}
}
```

*Auswahlkriterium:* fängt die Grundfunktions-Regression — liefert das
Tool überhaupt drei Sätze plus Anker für den Normalfall, ohne die
Datei mehrfach zu lesen?

**Fall 2 — Boundary:** Datei mit *genau einem* Satz Inhalt (weniger
Stoff, als die Zusammenfassung verlangt).

```yaml
# expectations/case-002.json
{
  "must_include": ["#"],
  "must_not_include": ["Lorem", "erfunden"],   # kein aufgefüllter Inhalt
  "max_sentences": 3,
  "source_anchors_subset_of_input": true
}
```

*Auswahlkriterium:* fängt die Auffüll-Halluzination — bei zu wenig
Stoff darf das Tool kürzen, aber nicht erfinden; jeder Anker muss auf
eine existierende Stelle zeigen. Fall 1 fängt das nicht, weil dort
genug Stoff da ist.

**Fall 3 — Negative:** Eingabe ist keine Markdown-Datei (Binärdatei
oder nicht existierender Pfad).

```yaml
# expectations/case-003.json
{
  "must_include": ["nicht lesbar"],            # erwartete Ablehnung
  "must_not_include": ["Zusammenfassung:"],
  "tool_calls": {"read_file": {"min": 1, "max": 2}}
}
```

*Auswahlkriterium:* fängt das Fail-open-Verhalten — das Tool muss den
Fehlerfall *benennen* statt eine Zusammenfassung von Nichts zu
liefern oder endlos zu retryen. Die beiden anderen Fälle erreichen
diesen Pfad nie.

Begründung der Konstruktion: Jeder Fall fängt eine eigene
Fehlerklasse (Grundfunktion · Halluzination bei dünnem Input ·
Fehlerpfad), und keine Erwartung hängt am Wortlaut — `must_include` /
`must_not_include` / `tool_calls`-Grenzen überleben einen
Modellwechsel, Exact-Match auf Fließtext nicht. Struktur-Vergleich:
das Lab-Set `lab/example/evals/golden/welle-1-baseline/` (drei Cases
Happy/Boundary/Negative je LH-FA-02) nutzt dasselbe Schema für ein
Retrieval-Replay.

Anti-Antwort: drei Happy-Path-Varianten (kurze Datei, lange Datei,
englische Datei) — das ist ein Demo-Set, kein Golden Set: alle drei
fangen dieselbe Fehlerklasse, und Halluzinations- wie Fehlerpfad
bleiben unbeobachtet.

### (Analysieren — aktiviert LZ 3) Erzeuge eine Regression durch Modellwechsel und quantifiziere den Drift

Vorgehen:

1. Replay-Lauf mit Modell A → grün (Baseline).
2. Wechsel auf Modell B → was wird rot?
3. **Quantifizieren:** Drift-Rate = rote ÷ gesamte Fälle als Zahl
   festhalten (z. B. 3/20 = 15 %), nicht "ein paar rot" — nur die Zahl
   ist zwischen Läufen vergleichbar und kann eine
   Steering-Loop-Schwelle treiben.
4. **Der Diagnose-Reihenfolge aus Schritt 6 zuordnen** — in dieser
   Reihenfolge, nicht nach Bauchgefühl: Toolchain (Image-Hash
   identisch?) → Modell-Routing (`model.version` + Provider-Status) →
   Erwartungs-Drift (Erwartung zu eng formuliert?) → echte Regression
   (alles oben ausgeschlossen).
5. Klassifiziere die verbleibenden echten roten Fälle: Format-Drift
   (Reihenfolge, Tokens), semantische Verschiebung, neue Fehler —
   welche Klasse ist akzeptabel, welche ist Show-Stopper?

Diese Übung ist gleichzeitig eine Modell-Migrations-Probe. In
Produktion bedeutet ein Modell-Update genau diesen Lauf — vorher.
Häufiger Fehler: bei der ersten Rötung direkt "echte Regression"
rufen und einen Carveout an der falschen Stelle einbauen — die
Diagnose-Reihenfolge existiert genau dagegen.

## Häufige Fehler

- **Replay-Tests laufen mit echtem Netz**. → Kein Replay, sondern Live-Test mit alten Erwartungen. Wird flaky.
- **Exact-Match als einziges Erfolgskriterium.** → Modelle sind variabel; minimaler Format-Drift erzeugt False-Positive-Failures. Mindestens *eine* semantische Metrik dazu.
- **Golden Set wird in einem CSV gepflegt**, das niemand reviewt. → Wenn Golden-Set-Änderungen nicht durch denselben Slice-Lifecycle laufen wie Code, driften sie.

## Verweise

- Test-Diversität (Determinism/Replay/Fault): [Modul 12](../04-qualitaet/modul-12-replay-evaluierung.md)
- grid-gym als reales Beispiel: [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
- Vorherige Lösung: [Modul 11](modul-11-loesung.md)
- Nächste Lösung: [Modul 13](modul-13-loesung.md)
