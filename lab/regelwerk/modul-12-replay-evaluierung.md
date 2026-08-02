## Modul 12 — Replay und Evaluierung

<!-- Quelle: [04-qualitaet/modul-12-replay-evaluierung.md](../../kurs/de/04-qualitaet/modul-12-replay-evaluierung.md) -->

### Kernidee (Modul 12)

Ohne Replay ist jeder Lauf ein einmaliges Experiment. Mit Replay wird er
zur Messung — und damit zum Sensor, der merkt, wenn eine schnell
gemachte Änderung das *Verhalten* gedreht hat, nicht nur die Signatur.

**Wovon diese Regeln sprechen, wenn sie „Modell" sagen:** vom
*nicht-deterministischen Kern* deines Produkts — der Komponente, die auf
dieselbe Eingabe nicht garantiert dieselbe Ausgabe liefert. Im Regelfall
ist das dein **Domänen-Modell**: Simulation, Optimierer, Ranking,
Scoring — samt seiner Zufallsquelle und seiner Entscheidungsregeln. Ein
Inferenz-Modell (Embedding-Modell, LLM) ist derselbe Fall mit anderen
Drift-Quellen. Hat dein Repo beides, gilt das Verfahren für beide
getrennt.

### Regeln gegen typische Fehlannahmen (Modul 12)

- Replay grün heißt: das Modell hat das wiederholt, was *im Golden Set steht*. Ob das Golden Set noch die Realität abbildet, ist eine andere Frage.
- Statische Golden Sets überfitten. Rotation und neues Sampling sind Pflicht, nicht Kür.
- Determinismus erfordert, dass *jede* Quelle gepinnt ist: Inputs, die Zufallsquelle (Seed **und** ihre Ableitungsregel), die Modellversion, die Tool-Versionen, der Umgebungszustand des Containers (Zeit, Locale, Env-Variablen, Netz, sichtbare CPU-Zahl) und die Zeitstempel-Maskierung. Wer nur den Seed pinnt, pinnt eine *einzige* davon — die übrigen driften unabhängig weiter.

### Replay-Manifest (Modul 12)

Ein Baseline-Replay hält das Verhalten eines Laufs als Messung fest,
gegen die spätere Änderungen verglichen werden — gleich ob sie von
Hand, vom Agenten oder aus einer Abhängigkeit kommen. Layout: **ein
Verzeichnis je Set** mit `manifest.yaml`, `inputs/`, `expectations/` und
`CHANGELOG.md`. Der Verzeichnisname ist frei — er darf an der Closure
hängen, die das Set erzeugt hat, oder an dem, was es misst. Regeln:

- **Mindestens drei Fälle — Happy · Boundary · Negative** (dieselbe
  Spec-Disziplin wie Akzeptanzkriterien, [Modul 3](modul-03-spec.md)).
  Ein Replay mit einem Fall ist eine Demo.
- **Manifest-Pflichtfelder:** `inputs_ref`, `recorded_at` und **je ein
  Feld pro Zufallsquelle des Laufs** — `model.seed` für den
  stochastischen Anteil und ein `determinism:`-Block für die
  Entscheidungsregeln, die sonst still driften. Zwei weitere
  unterscheiden ernsthaftes von symbolischem Replay:
  `runtime.image_hash` (Toolchain-Drift abgrenzen) und `model.version`.
- **Variante Inferenz-Modell:** Steht statt eines Domänen-Modells ein
  Embedding-Modell oder ein LLM im Lauf, verschiebt sich das Gewicht:
  `model.version` wird zum wichtigsten Feld — die Kennung ohne
  gleitenden Alias, aus demselben Grund, aus dem ein Image-Hash kein Tag
  ist. Und `model.seed` **entfällt**, wenn die API keinen Seed-Parameter
  anbietet. An die Stelle des Seeds tritt dann der **Prompt-Kontext**:
  System-Prompt, Werkzeug-Definitionen und deren Reihenfolge gehören ins
  Manifest. In der Drift-Diagnose kommt auf Rang 2 der Provider-Status
  hinzu — gleiche Version, anderes Subroute ist eine reale Drift-Quelle.
  Ein Feld, dessen Wert auf nichts zeigt, ist keine Pflicht, sondern
  Dekoration.
- **Erwartungen als Verhalten, nicht als Wortlaut:** semantische Anker
  statt wörtlichem Vergleich. Bei einem Domänen-Modell etwa der erwartete
  Spitzenwert, eine Score-Untergrenze und die Stabilität der Reihenfolge
  bei Gleichstand; bei einem Inferenz-Modell `must_include` ·
  `must_not_include` · `tool_calls`-Zähler. Eine wörtlich kopierte
  Ausgabe bricht, sobald sich ein Wert in der letzten Nachkommastelle
  ändert. Exact-Match nur für strukturierte Schnittstellen
  (JSON-Felder), nie für Fließtext.
- **Baseline einfrieren:** wird der erste Lauf nicht grün, *erst* das
  Manifest schärfen (meist Erwartung zu eng), nicht die Implementierung
  anfassen.
- **Drift als Zahl:** **Drift-Rate** = rote Fälle ÷ Gesamt-Fälle. Die
  Zahl macht *Trend* über mehrere Änderungen und eine *Schwelle* für den
  Steering Loop („ab Drift-Rate > X Carveout-Pflicht") prüfbar — eine
  „zwei rot"-Notiz lässt sich zwischen Läufen nicht vergleichen.
- **Drift-Diagnose in fester Reihenfolge** (wer zuerst „echte Regression"
  tippt, baut den Carveout an der falschen Stelle ein):

| Reihenfolge | Verdächtiger | Belegquelle |
|---|---|---|
| 1 | Toolchain-Drift | `runtime.image_hash` verglichen |
| 2 | Modell-Drift | `model.version` · `model.seed` · `determinism:` verglichen |
| 3 | Erwartungs-Drift | Eingaben vs. Spec (Modul 3) |
| 4 | echte Regression | alles oben ausgeschlossen |

- **Rotation:** Replay-Sets verrotten — Fälle aus Steering-Loop-Einträgen
  ergänzen, giftig gewordene (Schnittstelle real geändert) entfernen,
  datiert im Set-eigenen `CHANGELOG.md`.

