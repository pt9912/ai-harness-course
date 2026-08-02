# Modul 12 — Replay und Evaluierung

> **Aufwand:** ca. 75 Min Lesen · 90 Min Übung.

## Mini-Glossar für dieses Modul

Vier neue Begriffe — Volldefinitionen in
[`begriffe.md`](../grundlagen/begriffe.md#kernbegriffe).
Den Image-Hash erklärt der Vorgriff-Block weiter unten.

**Wovon dieses Modul spricht, wenn es „Modell" sagt:** vom
*nicht-deterministischen Kern* deines Produkts — der Komponente, die auf
dieselbe Eingabe nicht garantiert dieselbe Ausgabe liefert. Im Regelfall
ist das dein **Domänen-Modell**: Simulation, Optimierer, Ranking,
Scoring — samt seiner Zufallsquelle und seiner Entscheidungsregeln. Ein
Inferenz-Modell (Embedding-Modell, LLM) ist derselbe Fall mit anderen
Drift-Quellen und läuft an den passenden Stellen als Variante mit. Hat
dein Repo beides, gilt das Verfahren für beide getrennt.

| Begriff | Ein-Satz-Definition | Bild im Kopf |
|---|---|---|
| **Replay** | Deterministisch wiederholbarer Lauf gegen fixierte Inputs. | Tonbandaufnahme, die man identisch noch einmal abspielt. |
| **Golden Set** | Kuratiertes Eingabe/Erwartungs-Paar für Regressionstests. | das Lehrbuch, gegen das jeder neue Lauf abgleicht. |
| **Drift** | Abweichung des Verhaltens zwischen zwei Läufen, deren Manifeste eigentlich übereinstimmen sollten. | Schiff, das vom Kurs abkommt, ohne dass jemand das Steuer berührt. |
| **Determinismus** | Gleiche Eingabe → gleiche Ausgabe; setzt voraus, dass *jede* Zufalls- und Umgebungsquelle des Laufs gepinnt ist — Seed, Modellversion, Toolchain, Umgebungszustand. | derselbe Wurf eines gezinkten Würfels: vorhersagbar, nicht zufällig. |

## Engage

Der Agent tauscht eine Sortier-Bibliothek und zieht dabei die
Tie-Break-Regel deines Rankings mit. Acht von zehn typischen Anfragen
liefern identische Treffer — du gehst live. Zwei Wochen später
beschwert sich ein Nutzer über ein Ergebnis, das *früher* oben stand.
Dein Replay-Set deckte das Muster nicht ab. Schlimmer: dein Golden Set
ist über die Zeit zur heimlichen *Spec* geworden — es beschreibt nicht
mehr die Realität, sondern nur noch sich selbst. Replay grün, Realität
rot. Wie bekommt man das Drift-Symptom in den Griff?

## Lernziele

Nach diesem Modul kannst du:

* einen Replay-Lauf *einrichten*, der unter Beibehaltung aller deklarierten Zufalls- und Umgebungsquellen deterministisch wiederholbar ist (Anwenden · prozedural),
* ein Golden Set *aufbauen* und Auswahlkriterien *begründen* (Erschaffen + Bewerten · prozedural),
* eine Regression nach einer Änderung am Modell *messen* und einen Drift *quantifizieren* (Analysieren · prozedural),
* Symptome von Golden-Set-Überfitting *erkennen* und Gegenmaßnahmen (Rotation, Sampling) *entwerfen* (Bewerten + Erschaffen · konzeptuell+prozedural).

## Lab-Bezug

* [`../../../lab/example/evals/golden/`](../../../lab/example/evals/golden/)
* [`../../../lab/example/Makefile`](../../../lab/example/Makefile), Target `make replay RUN=welle-1-baseline`

## Themen

* Replay (Inputs · Seed · Modellversion)
* Golden Sets
* Regressionstests
* Bewertungsmetriken: Exact-Match · Toleranz und Schwellen · Invarianten (Reihenfolge, Monotonie) · semantische bzw. rubric-basierte Bewertung, wo Fließtext im Spiel ist
* Abgrenzung: Wird aus dem Replay-Set ein *durchgesetztes* Gate (`test-determinism`, `test-replay`, `test-fault` als eigene Make-Targets), ist das [Modul 13](modul-13-quality-gates.md). Dieses Modul baut das Set, jenes setzt es durch.

## Begriff: Image-Hash (Vorgriff aus Modul 14)

Dieses Modul referenziert mehrfach den *Image-Hash* — das volle Bild
liegt in [Modul 14 (Docker-Harness)](../05-betrieb/modul-14-docker-harness.md),
hier reicht eine operative Kurzdefinition:

Der Image-Hash (typischerweise ein SHA-256 wie `sha256:9c7f…`) ist die
**byte-genaue Adresse eines Container-Images**. Gleicher Hash heißt:
identische Toolchain, identische Python-/Go-/.NET-Version, identische
System-Bibliotheken — und damit identischer Replay-Lauf. Anders als ein
Tag (`my-image:latest`), der sich überschreiben lässt, ist ein Hash
**unveränderlich**. Wer einen Replay-Lauf festhalten will, fixiert nicht
"das Image", sondern *den Hash dieses Images*.

Praktisch heißt das: Im Replay-Manifest wird neben Modellversion und
Seed auch der Image-Hash mitprotokolliert. Drift zwischen zwei Läufen
mit identischem Hash ⇒ liegt am Modell oder an Eingaben, nicht an der
Toolchain. Drift mit unterschiedlichem Hash ⇒ Toolchain-Verdacht zuerst.

## Kernidee

Ohne Replay ist jeder Lauf ein einmaliges Experiment. Mit Replay wird er
zur Messung — und damit zum Sensor, der merkt, wenn eine schnell
gemachte Änderung das *Verhalten* gedreht hat, nicht nur die Signatur.

## Typische Fehlvorstellungen

- **"Wenn der Replay grün ist, ist das Modell gut."** — Replay grün heißt: das Modell hat das wiederholt, was *im Golden Set steht*. Ob das Golden Set noch die Realität abbildet, ist eine andere Frage.
- **"Golden Set ist statisch."** — Statische Golden Sets überfitten. Rotation und neues Sampling sind Pflicht, nicht Kür.
- **"Determinismus = Reproduzierbarkeit."** — Determinismus erfordert, dass *jede* Quelle gepinnt ist: Inputs, die Zufallsquelle (Seed **und** ihre Ableitungsregel), die Modellversion, die Tool-Versionen, der Umgebungszustand des Containers (Zeit, Locale, Env-Variablen, Netz, sichtbare CPU-Zahl) und die Zeitstempel-Maskierung. Wer nur den Seed pinnt, pinnt eine *einzige* davon — die übrigen driften unabhängig weiter.

## Worked Example A: ein Replay-Manifest für ein Domänen-Modell

> **Wenn du Replay-Manifeste mit gepinnten Zufallsquellen, Image-Hash und Golden Set bereits pflegst, springe zu [§Übungen](#übungen).** Worked Examples helfen beim Aufbau des Schemas; ist es da, kostet das Mitlesen Last (Expertise-Reversal).

**Ausgangssituation:** Slice `SL-024` hat die Ranking-Stufe deiner Suche
geliefert. Sie wählt aus den Kandidaten stochastisch aus und entscheidet
bei Punktgleichstand über eine feste Tie-Break-Regel. Beides willst du
festhalten, bevor der nächste Slice sie anfasst.

**Schritt 1 — Pfad und Skelett anlegen.**

```
evals/golden/ranking-baseline/
├── manifest.yaml
├── inputs/
│   ├── case-001.json     # Happy: ein eindeutig bester Treffer
│   ├── case-002.json     # Boundary: zwei Dokumente, identischer Score
│   └── case-003.json     # Negative: nichts über der Schwelle
└── expectations/
    ├── case-001.json
    └── ...
```

Drei Fälle ist das Minimum: Happy / Boundary / Negative — dieselbe
Spec-Disziplin wie bei Akzeptanzkriterien
([Modul 3](../01-spec-und-architektur/modul-03-spec.md)). Ein Replay mit
einem Fall ist eine Demo, kein Replay. Case-002 ist hier der wichtigste:
Er ist der einzige, der die Tie-Break-Regel überhaupt auslöst.

**Schritt 2 — Pflichtfelder im Manifest fixieren.**

```yaml
# evals/golden/ranking-baseline/manifest.yaml
slice: SL-024
recorded_at: 2026-06-15T10:31:00Z
model:                     # die gemessene Stufe
  name: ranking
  version: "2.1.0"
  seed: 42
determinism:               # Regeln ohne eigenes Versionsfeld
  tie_break_strategy: sort_stable_then_doc_path_then_section_index
  score_threshold: 0.30
  max_topk: 100
runtime:
  image_hash: sha256:9c7f4a...   # siehe Vorgriff-Block oben
inputs_ref: inputs/
expectations_ref: expectations/
```

Messgegenstand ist die Ranking-Stufe — sie steht im `model:`-Block, weil
sie das ist, worüber dieser Replay eine Zusage macht. Daneben trägt
`determinism:` die Regeln, die ihr Ergebnis mitbestimmen, ohne selbst
eine Version zu haben. Genau die driften still: Niemand bemerkt einen
Tie-Break-Wechsel an einer Versionsnummer.

Was *vorgelagert* ist, fehlt hier bewusst. Die Vektoren, mit denen die
Stufe rechnet, liegen fertig in `inputs/`; ein eingefrorener Vorlauf ist
keine Drift-Quelle mehr. Ins Manifest gehört nur, was der Lauf selbst
noch tut — sonst behauptest du eine Abhängigkeit, die im Replay gar
nicht mehr wirkt.

Drei Felder sind im Selbstcheck Pflicht: `inputs_ref`, `recorded_at` und
**je ein Feld pro Zufallsquelle des Laufs** — hier `model.seed` für die
stochastische Auswahl und der `determinism:`-Block für die
Entscheidungsregeln. Zwei weitere unterscheiden ernsthaftes von
symbolischem Replay: `runtime.image_hash` (Toolchain-Drift abgrenzen)
und `model.version`.

**Schritt 3 — Erwartungen *als Verhalten*, nicht als Wortlaut.**
Schlecht: die Trefferliste des ersten Laufs wörtlich kopiert — sie
bricht, sobald sich ein Score in der vierten Nachkommastelle ändert.
Gut, in `expectations/case-002.json` — dem Gleichstands-Fall:

```json
{
  "top_doc_path": "docs/handbuch/kapitel-03.md",
  "top_score_min": 0.72,
  "tie_break_stable": true
}
```

Drei semantische Aussagen statt eines wörtlichen Vergleichs: *welches*
Dokument oben steht, dass der Score eine Untergrenze hält — und dass die
Reihenfolge bei Gleichstand über zwei Läufe dieselbe bleibt. Die letzte
ist die eigentliche Zusage dieses Falls. Exact-Match bewahre für
strukturierte Schnittstellen (JSON-Felder), nie für Fließtext.

**Schritt 4 — Erster Lauf, Baseline einfrieren.** Die Kommandozeilen in
Schritt 4 und 5 zeigen die *Form*, die ein Replay-Harness anbieten
sollte. Das Kurs-Lab bringt keinen solchen Harness mit — es prüft nur
die Fixture-Form (§Minimaler Übungspfad, *Lab-Grenze*):

```bash
<dein-replay-harness> run --set ranking-baseline
```

Erwartet: drei grüne Fälle. Wenn nicht: *erst* das Manifest schärfen
(meist Schritt 3 zu eng), nicht die Implementierung anfassen.

**Schritt 5 — Drift messen: die Tie-Break-Regel tauschen.** Das ist
genau die Änderung aus der Engage-Situation — eine getauschte
Sortier-Bibliothek zieht die Regel mit:

```bash
<dein-replay-harness> run --set ranking-baseline --against <stand-nach-der-änderung>
```

Ergebnis: case-001 und case-003 bleiben grün, **case-002 wird rot**. Die
beiden Fälle ohne Gleichstand können die Änderung nicht sehen — hättest
du nur sie im Set, wäre der Replay grün und die Realität rot. Genau das
ist der Unterschied zwischen einem Demo-Set und einem Golden Set.

Drei mögliche Ergebnisse allgemein:
* alle grün → kein Drift in dieser Klasse.
* einer rot → erste Drift-Diagnose: ist die Erwartung zu eng (Schritt 3
  nachschärfen) oder hat der Kern ein neues Verhalten?
* zwei rot → die Änderung ist nicht ohne Anpassung möglich; Carveout +
  Folge-Slice für Erwartungs-Update.

*Quantifizieren statt nur einordnen.* Halte den Drift als **Zahl** fest,
nicht nur als "einer rot": die **Drift-Rate** = rote Fälle ÷
Gesamt-Fälle. Hier: 1 ÷ 3 = **33 %**.

Daran siehst du zugleich die Grenze des Minimal-Sets. Drei Fälle sichern
die *Abdeckung* — je eine Fehlerklasse Happy, Boundary, Negative —, aber
als Nenner taugen sie nicht: Jeder einzelne rote Fall springt um 33
Punkte, und eine Schwelle wie "ab 10 % Carveout-Pflicht" löst dann bei
jedem Rot aus. Die Rate trägt erst, wenn das Set über Rotation wächst
(Schritt 7). Bis dahin ist sie eine Notiz, keine Schwelle.

Was die Zahl leistet, sobald der Nenner trägt: (1) den *Trend* über
mehrere Änderungen (steigt sie von 5 % auf 15 %, ist der Kern selbst der
Verdächtige, nicht ein Einzelfall), und (2) eine *Schwelle* für den
Steering Loop ("ab Drift-Rate > X Carveout-Pflicht"). Eine ordinale
"einer rot"-Notiz lässt sich zwischen Läufen nicht vergleichen — ein
Prozentwert schon.

**Schritt 6 — Drift-Diagnose-Reihenfolge.** Wenn ein Lauf rot wird, ist
die Reihenfolge der Verdächtigen *nicht beliebig*:

| Reihenfolge | Verdächtiger | Belegquelle |
|---|---|---|
| 1 | Toolchain-Drift | `runtime.image_hash` verglichen |
| 2 | Modell-Drift | `model.version` · `model.seed` · `determinism:` verglichen |
| 3 | Erwartungs-Drift | Eingaben vs. Spec (Modul 3) |
| 4 | echte Regression | alles oben ausgeschlossen |

Für case-002 durchlaufen: Der Image-Hash ist identisch — Rang 1 fällt
weg. `model.version` und `model.seed` sind unverändert, aber
`determinism.tie_break_strategy` weicht ab — Rang 2 trifft zu, die Suche
endet hier. Wer stattdessen zuerst auf "echte Regression" tippt, baut den
Carveout an der falschen Stelle ein und lässt die eigentliche Ursache
stehen.

**Schritt 7 — Lerneintrag und Rotation.**
Replay-Sets verrotten (siehe Mini-Glossar oben, *Drift*). In
`evals/golden/ranking-baseline/CHANGELOG.md`:

```markdown
2026-06-15 — Baseline mit drei Fällen aufgesetzt.
2026-08-02 — Tie-Break-Wechsel in SL-029 hat case-002 rot gemacht;
             Erwartung bestätigt, kein Carveout. Zweiten
             Gleichstands-Fall ergänzt (drei Dokumente),
             weil case-002 nur den Zweier-Gleichstand deckt.
2026-09-10 — case-001 entfernt — Schnittstelle real geändert,
             der Fall war giftig geworden.
```

Sieben Schritte, ein reproduzierbares Manifest — und ein Set, dessen
Boundary-Fall die Fehlerklasse aus der Engage-Situation fängt.


## Worked Example B: dasselbe Manifest für ein Inferenz-Modell

**Ausgangssituation:** Die Suche hat eine zweite Stufe bekommen — zu den
Treffern schreibt ein Sprachmodell eine Kurz-Zusammenfassung. Sie
braucht ein eigenes Replay-Set, weil sie eigene Drift-Quellen hat.

Layout und die sieben Schritte bleiben die aus Worked Example A.
Verschoben hat sich, was in `model:` steht und was an die Stelle des
Seeds tritt:

```yaml
# evals/golden/summary-baseline/manifest.yaml
slice: SL-031
recorded_at: 2026-07-04T09:12:00Z
model:
  name: <modell-kennung>          # ohne gleitenden Alias
  version: "<release-snapshot>"
prompt_context:                   # tritt an die Stelle des Seeds
  system_prompt_hash: sha256:4b1e...
  tool_definitions_hash: sha256:9ad0...
  tool_order: [search, fetch_section]
runtime:
  image_hash: sha256:9c7f4a...
inputs_ref: inputs/
expectations_ref: expectations/
```

Drei Unterschiede zu A:

1. **Kein `seed:`.** Viele Inferenz-APIs bieten keinen Seed-Parameter —
   die Anthropic Messages API etwa kennt keinen, und Sampling-Parameter
   wie `temperature` sind auf ihren aktuellen Modellen ebenfalls entfernt
   (Stand 2026-08 — prüf es für deinen Anbieter nach, das ist eine
   datierte Beobachtung, keine Konstante).
   Ein Feld, dessen Wert auf nichts zeigt, ist keine Pflicht, sondern
   Dekoration.
2. **`model.version` trägt die Hauptlast** — die Kennung ohne gleitenden
   Alias, aus demselben Grund, aus dem ein Image-Hash kein Tag ist.
3. **`prompt_context:` statt `determinism:`.** System-Prompt,
   Werkzeug-Definitionen und deren Reihenfolge sind hier die Regeln, die
   sonst still driften. Als Hash im Manifest fällt jede Änderung auf,
   ohne dass du den ganzen Prompt einfrieren musst.

Auch die Erwartungen aus Schritt 3 verschieben sich: statt
`top_doc_path` und `tie_break_stable` prüfst du semantische Anker am
Fließtext — `must_include` · `must_not_include` und Grenzen für
`tool_calls`. Und in der Drift-Diagnose aus Schritt 6 kommt auf Rang 2
der Provider-Status hinzu: gleiche Version, anderes Subroute ist eine
reale Drift-Quelle.

Ein *Agentenlauf* als Messgegenstand ist derselbe Fall eine Ebene höher
— festgehalten wird dann nicht eine Antwort, sondern ein ganzer Lauf.

**Beide Formen im Lab:**
[`../../../lab/example/evals/golden/welle-1-baseline/`](../../../lab/example/evals/golden/welle-1-baseline/)
trägt `manifest.yaml`, `inputs/case-{001,002,003}.json`,
`expectations/case-{001,002,003}.json` und `CHANGELOG.md` — die
Verzeichnis-Struktur aus A. Inhaltlich ist es ein *gemischter* Fall:
Seine `inputs/` sind Such-Anfragen, das Embedding-Modell läuft im Replay
also mit und steht darum in seinem `model:`-Block. Layout von A,
Gewichtung von B — so sehen reale Sets meistens aus.

## Übungen

* Reproduzierbare Testläufe gegen ein Golden Set
* **(Erschaffen + Bewerten — aktiviert LZ 2)** *Mini-Golden-Set entwerfen und Auswahl begründen.* Gegeben die Ranking-Stufe aus Worked Example A: Zu einer Anfrage liefert die Suche die besten Treffer, bei Punktgleichstand entscheidet die Tie-Break-Regel. Entwirf ein Golden Set mit drei Fällen (Happy · Boundary · Negative — dieselbe Spec-Disziplin wie in Worked Example A Schritt 1): pro Fall die Eingabe, die Erwartung *als Verhalten, nicht als Wortlaut* (Schritt 3 — semantische Anker wie "dieses Dokument steht oben", "Mindest-Score wird erreicht", "die Reihenfolge bei Gleichstand ist stabil" statt eines wörtlich kopierten Ergebnis-Arrays) und ein *Auswahlkriterium* in einem Satz — welche Fehlerklasse fängt genau dieser Fall, die die anderen zwei nicht fangen? **Mindestens einer der drei Fälle muss den Gleichstand treffen** — das ist die Fehlerklasse aus der Engage-Situation, und kein Happy-Path-Fall sieht sie. Vergleiche die Struktur am Ende mit dem Lab-Set [`../../../lab/example/evals/golden/welle-1-baseline/`](../../../lab/example/evals/golden/welle-1-baseline/) (drei Cases Happy/Boundary/Negative je LH-FA-02). Anti-Antwort: drei Happy-Path-Varianten — das ist ein Demo-Set, kein Golden Set.
* **(Analysieren — aktiviert LZ 3)** *Drift quantifizieren.* Erzeuge eine Regression an deinem nicht-deterministischen Kern — getauschte Tie-Break-Regel, geänderte Seed-Ableitung oder neue Modellversion — und gib die Drift-Rate (rote ÷ gesamte Fälle) als Zahl an; ordne den Befund dann der Diagnose-Reihenfolge aus Schritt 6 zu (Toolchain → Modell-Drift → Erwartung → echte Regression). **Wo:** im eigenen Repo mit echten Zahlen — das Lab-Target führt keinen Lauf aus und kann darum keine roten Fälle erzeugen (siehe Lab-Grenze unten). Ohne eigenen Replay-Lauf: an der Vorgabe aus dem Selbstcheck (3 von 20 rot).
* **(Analysieren + Anwenden — aktiviert LZ 1)** *Zeige, dass der Lab-Sensor den Modellwechsel nicht sehen kann.* Kopiere `evals/golden/welle-1-baseline/` nach `evals/golden/drift-test/`, ändere in `manifest.yaml` `model.name` **und** `model.version`, verfälsche zusätzlich eine Erwartung (`top_doc_path`, `top_score_min`) und lasse `make replay RUN=drift-test` laufen. Beobachtung: dreimal grün. Benenne dann, welche Felder ein *Runner* vergleichen müsste, damit der Wechsel rot wird — das Manifest deklariert sie bereits (`verification.per_case_hash`, `determinism_check: two_runs_same_hash`, `runtime.image_hash`), nur löst sie kein Target ein. Pointe: Ein Sensor, der die Sache nicht sehen kann, über die er eine Zusage macht, ist ein Vorschlag, kein Gate ([Modul 13 §Typische Fehlvorstellungen](modul-13-quality-gates.md#typische-fehlvorstellungen)).

### Minimaler Übungspfad

```bash
cd lab/example
make replay RUN=welle-1-baseline
```

Erwartete Beobachtung: Das Target validiert nur die *Struktur* des
Golden-Set-Fixtures — Manifest vorhanden, `model:`- und `runtime:`-Block
vorhanden, mindestens drei Fälle, `inputs`/`expectations` gleich lang. Der
didaktische Punkt ist die Belegstruktur, nicht das Ergebnis.

Es liest keinen einzigen Wert *innerhalb* dieser Blöcke: Eine geänderte
Modellversion und eine verfälschte Erwartung lassen es unverändert grün.
Genau das ist die zweite Übung oben — der Befund ist der Lerngegenstand.

> *Lab-Grenze:* `make replay` ist ein **Struktur-Validator, kein
> Replay-Runner**. Es prüft die Form des Fixtures und führt keinen Lauf
> aus; es vergleicht nichts und kann darum keinen roten Fall erzeugen. Das
> Worked Example A (Schritte 1–7) ist Vor-Lehre, keine Probung. Folgen für
> die Lernziele:
>
> * **LZ 2** (Golden Set *aufbauen*, Auswahl *begründen*) — durch die
>   Mini-Golden-Set-Übung oben abgerufen, ohne Lauf.
> * **LZ 3** (Regression *quantifizieren*) — **nicht am Lab messbar.**
>   Abgerufen an gegebenen Zahlen (Selbstcheck) oder im eigenen Repo mit
>   echtem Runner.
> * **LZ 1** (Replay-Lauf *einrichten*) — die Blindheits-Übung oben zeigt
>   am Lab, *welche* Felder ein Runner vergleichen müsste; eingerichtet
>   wird er erst im eigenen Repo.

## Reflexion

Vier Standardfragen aus [`../grundlagen/reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md)
nach dem Replay-Setup und der Modellwechsel-Drift-Messung.
Modul-spezifische Trigger:

- **Beobachtung:** Welche Pflichtfelder hattest du im Manifest? Welche fehlten? In welcher Reihenfolge hast du Verdächtige für die Drift abgearbeitet?
- **2×2-Quadrant:** Replay als Sensor ist *computational feedback*; Golden-Set-Pflege ist Entropy Management.
- **Steering-Loop:** Image-Hash als Manifest-Pflicht? Golden-Set-Rotation an die Closure koppeln? Adversarial-Beispiele aus deinem Reflexions-Trace ziehen?
- **Conceptual Change:** Kandidaten in [`../grundlagen/lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "Wenn der Replay grün ist, ist das Modell gut", "Determinismus = Reproduzierbarkeit", "Golden Set ist statisch").

## Selbstcheck

* **(Erinnern)** Welche drei Felder muss ein Replay-Manifest mindestens festhalten?
* Was muss ein Replay festhalten, damit er deterministisch ist?
* **(Analysieren — aktiviert LZ 3)** Nach einem Modellwechsel sind 3 von 20 Golden-Fällen rot. Gib die Drift-Rate als Zahl an und sage, *was* die Zahl über mehrere Läufe sichtbar macht, das "drei rot" allein nicht zeigt.
* **(Bewerten/Erkennen — aktiviert LZ 4 Bewerten-Hälfte)** Wann wird ein Golden Set giftig (überfittet)?
* **(Erschaffen — aktiviert LZ 4 Erschaffens-Hälfte)** Gegeben ein überfittetes Golden Set (seit 14 Wochen 100 % grün im Replay, neue Eingabe-Klassen tauchen nur in Produktion auf): entwirf einen konkreten Rotations- und Sampling-Plan — welcher Anteil rotiert pro Closure, woher kommen die neuen Fälle, und welches Stopp-Kriterium verhindert Über-Rotation?
* **(Anwenden)** In deinem eigenen Repo: welche zwei Drift-Quellen würdest du *zuerst* messen, wenn du nur eine Woche Zeit hast?
* **(Erschaffens-Prozess)** Welcher Schritt beim Aufbau deines Replay-Manifests war der *unsicherste* — und warum? (Erfahrungsgemäß: Schritt 3 "Erwartungen als Verhalten, nicht als Wortlaut" oder Schritt 6 "Drift-Diagnose-Reihenfolge".)

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Drei Pflichtfelder eines Replay-Manifests? | "Modell." | Eingaben (als referenzierter Datensatz, nicht als Inline-Text) · Aufnahme-Zeitpunkt · je ein Feld pro Zufallsquelle des Laufs (Seed samt Ableitungsregel, dazu die Entscheidungsregeln). | + Image-Hash (siehe Abschnitt oben) — sonst lässt sich Drift nicht von Toolchain-Drift trennen. Exzellent benennt außerdem, dass die Feldliste von der *Art* des Kerns abhängt: beim Domänen-Modell trägt der Seed, beim Inferenz-Modell die Modellversion und der Prompt-Kontext — dort gibt es oft gar keinen Seed-Parameter. |
| Was braucht ein deterministischer Replay? | "Seed." | Inputs + Zufallsquelle (Seed und Ableitungsregel) + Modellversion + Tool-Versionen + Zeitstempel-Maskierung + Image-Hash (Docker-Harness, Modul 14). | + Hinweis: der Seed pinnt nur *eine* von mehreren Drift-Quellen; die übrigen driften unabhängig weiter — Tool-Subversions, lokale Zeit, Locale und Sortierreihenfolge, sichtbare CPU-Zahl, Netz-Latenz; bei Inferenz-Modellen zusätzlich Modell-Routing innerhalb derselben Version und der Prompt-Kontext. Exzellent benennt mehrere dieser Quellen, statt Determinismus am Seed allein festzumachen. |
| Drift quantifizieren (3 von 20 rot)? | "Ein paar rot." — keine Zahl. | Drift-Rate = 3 ÷ 20 = 15 %. | + Was die Zahl sichtbar macht: den *Trend* über mehrere Änderungen am Kern (steigt sie, ist der Kern selbst der Verdächtige, nicht der Einzelfall) und eine *Schwelle* für den Steering Loop ("ab > X % Carveout-Pflicht") — beides ist zwischen Läufen vergleichbar, "drei rot" nicht. |
| Wann wird ein Golden Set giftig? | "Wenn es nicht passt." | Wenn Replay reproduzierbar grün ist, aber Realität rot — typisch durch jahrelang konstantes Set. Symptome: keine Failure-Klasse seit X Wochen, neue Eingabe-Klassen tauchen *nur* in Produktion auf. | + Gegenmaßnahmen: Rotation (alte Beispiele rausnehmen), Sampling aus Produktions-Traces, Adversarial-Beispiele aus Steering-Loop-Einträgen ([`reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md)) ziehen. |
| Rotations-/Sampling-Plan für überfittetes Golden Set? | "Neue Beispiele dazu." | Konkreter Plan: fester Rotations-Anteil pro Closure — Slice oder Welle, je nachdem, was dein Repo führt (z. B. 20 % der ältesten Fälle raus), neue Fälle aus Produktions-Traces + Steering-Loop-Adversarial-Einträgen gezogen, Replay nach Rotation re-baselined. | + Stopp-Kriterium gegen Über-Rotation: Set behält einen stabilen Regressions-Kern (nie rotierende Anker-Fälle), sonst verliert man die Regressions-Funktion. Vorhersage: nach Rotation steigt die Failure-Rate kurzfristig — das ist Erfolg, nicht Defekt. |
| Zwei Drift-Quellen — welche zuerst? | "Modell ändert sich." | Zwei konkrete: (a) Modell-Drift (Version oder Zufallsquelle anders als deklariert; bei Inferenz-Modellen auch gleicher Tag, anderes Subroute beim Provider) und (b) Toolchain-Drift (Tool-Subversion oder Image-Hash anders als geplant). Beide sind in der ersten Woche messbar, beide haben einen sofortigen Sensor (Replay-Manifest-Vergleich). | + Begründung: andere Quellen (Eingabe-Distribution, Tool-Allowlist-Drift, Cache-Verhalten) sind nachgelagert — wer sie misst, bevor Modell und Toolchain gepinnt sind, misst Rauschen. Reihenfolge ist nicht beliebig. |
| Unsicherster Schritt beim Replay-Manifest? | Schritt benannt, aber ohne Begründung ("Schritt 3 war schwer."). | Konkret benannter Schritt + Begründung (z. B. "Schritt 3 Erwartungen, weil ich nicht entscheiden konnte, was *semantisch* gleich genug ist"). | + Pointe: Schritt 3 ist die häufigste Bruchstelle — wer Erwartungen wortwörtlich formuliert, bricht beim ersten Modellwechsel. Schritt 6 (Drift-Diagnose-Reihenfolge) ist die zweithäufigste: wer ohne Reihenfolge testet, klassifiziert echte Regressionen als Toolchain-Drift und umgekehrt. |

## Weiterlesen

* Test-Diversität als reale Praxis: `pt9912/grid-gym` in [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
* Nächstes Modul: [Modul 13 — Quality Gates](modul-13-quality-gates.md)
