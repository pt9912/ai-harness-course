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
Hand, vom Agenten oder aus einer Abhängigkeit kommen.

#### Ziel-Form: Golden Set

**Ein Verzeichnis je Set.** Der Verzeichnisname ist frei — er darf an
der Closure hängen, die das Set erzeugt hat, oder an dem, was es misst.

```
<set-name>/
├── manifest.yaml     # womit gelaufen wurde — Felder unten
├── inputs/           # mindestens drei Fälle: Happy · Boundary · Negative
├── expectations/     # je ein Gegenstück pro Eingabe-Fall
└── CHANGELOG.md      # datierte Veränderung des Sets
```

**Mindestens drei Fälle — Happy · Boundary · Negative** (dieselbe
Spec-Disziplin wie Akzeptanzkriterien, [Modul 3](modul-03-spec.md)).
Ein Replay mit einem Fall ist eine Demo.

#### Ziel-Form: manifest.yaml

Welche Felder ein Manifest braucht, entscheidet **nicht die Art des
Kerns, sondern welche Quellen im Lauf noch zufällig sind.** Daher zwei
Formen mit derselben Regel dahinter.

Domänen-Modell (Simulation, Optimierer, Ranking, Scoring):

```yaml
recorded_at: <ISO-Zeitstempel der Aufnahme>
model:                         # die gemessene Stufe
  name: <Bezeichnung>
  version: <Kennung ohne gleitenden Alias>
  seed: <Startwert der Zufallsquelle>
determinism:                 # Regeln ohne eigenes Versionsfeld
  <regel>: <wert>
runtime:
  image_hash: <sha256:...>
inputs_ref: <Pfad auf das Eingabe-Verzeichnis>
expectations_ref: <Pfad auf das Erwartungs-Verzeichnis>
```

Inferenz-Modell (Embedding-Modell, LLM) — `seed:` entfällt, an seine
Stelle tritt der Prompt-Kontext, der Rest bleibt:

```yaml
model:
  name: <Modell-Kennung>     # ohne gleitenden Alias
  version: <Release-Snapshot>
prompt_context:
  system_prompt_hash: <sha256:...>
  tool_definitions_hash: <sha256:...>
  tool_order: [<werkzeug>, ...]
```

Was die einzelnen Felder festhalten:

| Feld | Was hineingehört | Wozu |
|---|---|---|
| `inputs_ref` | Pfad auf den Eingabe-Datensatz — referenziert, nicht als Inline-Text kopiert | damit der Lauf gegen fixierte Eingaben läuft und nicht gegen eine Kopie, die still mitwandert |
| `expectations_ref` | Pfad auf das Erwartungs-Verzeichnis, ein Gegenstück je Eingabe-Fall | ohne Gegenstück gibt es nichts zu vergleichen |
| `recorded_at` | Zeitpunkt der Aufnahme | damit spätere Läufe ihren Diff datieren können |
| `model.seed` | Startwert der Zufallsquelle samt Ableitungsregel | pinnt den stochastischen Anteil des Laufs |
| `determinism:` | Entscheidungsregeln ohne eigenes Versionsfeld — Tie-Break, Sortierstabilität, Grenzwerte | pinnt, was sonst still driftet: Niemand bemerkt einen Tie-Break-Wechsel an einer Versionsnummer |
| `prompt_context:` | System-Prompt und Werkzeug-Definitionen **als Hash**, dazu deren Reihenfolge | dasselbe beim Inferenz-Modell — als Hash fällt jede Änderung auf, ohne dass du den ganzen Prompt einfrieren musst |
| `runtime.image_hash` | byte-genaue Adresse des Container-Images, kein Tag | grenzt Toolchain-Drift ab (Rang 1 der Diagnose unten) |
| `model.version` | die konkrete Kennung, nicht die Familie | grenzt Modell-Drift ab (Rang 2) |

**Pflicht sind drei Positionen** — zwei feste Felder und eine Familie:
`inputs_ref`, `recorded_at` und **je ein Feld pro Zufallsquelle des
Laufs**. Wie viele Felder die dritte Position umfasst, entscheidet der
Lauf: beim Domänen-Modell `model.seed` *und* `determinism:`, beim
Inferenz-Modell `model.version` *und* `prompt_context:`. `model.seed`
**entfällt**, wenn die API keinen Seed-Parameter anbietet — ein Feld,
dessen Wert auf nichts zeigt, ist keine Pflicht, sondern Dekoration.

`runtime.image_hash` und `model.version` sind beim Domänen-Modell keine
Pflicht, unterscheiden aber ernsthaftes von symbolischem Replay. Beim
Inferenz-Modell rückt `model.version` in die Pflicht — dort ist es die
Zufallsquelle.

#### Regeln

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
  ordinale „einer rot"-Notiz lässt sich zwischen Läufen nicht
  vergleichen. **Als Schwelle trägt die Rate aber erst, wenn das Set
  über Rotation gewachsen ist:** Bei den drei Pflicht-Fällen springt
  jeder einzelne rote Fall um 33 Punkte, und eine Schwelle wie „ab 10 %
  Carveout-Pflicht" löst dann bei jedem Rot aus. Bis dahin ist sie eine
  Notiz, keine Schwelle.
- **Drift-Diagnose in fester Reihenfolge** (wer zuerst „echte Regression"
  tippt, baut den Carveout an der falschen Stelle ein):

| Reihenfolge | Verdächtiger | Belegquelle |
|---|---|---|
| 1 | Toolchain-Drift | `runtime.image_hash` verglichen |
| 2 | Modell-Drift | `model.version` · `model.seed` · `determinism:` verglichen |
| 3 | Erwartungs-Drift | Eingaben vs. Spec (Modul 3) |
| 4 | echte Regression | alles oben ausgeschlossen |

Beim Inferenz-Modell kommt auf Rang 2 der **Provider-Status** hinzu:
gleiche Version, anderes Subroute ist eine reale Drift-Quelle.

- **Rotation:** Replay-Sets verrotten — Fälle aus Steering-Loop-Einträgen
  ergänzen, giftig gewordene (Schnittstelle real geändert) entfernen,
  datiert im Set-eigenen `CHANGELOG.md`.

