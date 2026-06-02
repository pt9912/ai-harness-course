# Modul 11 — Replay und Evaluierung

> **Aufwand:** ca. 75 Min Lesen · 90 Min Übung.

## Mini-Glossar für dieses Modul

Vier neue Begriffe — Volldefinitionen in
[`../grundlagen/konventionen.md`](../grundlagen/konventionen.md#kernbegriffe).
Den Image-Hash erklärt der Vorgriff-Block weiter unten.

| Begriff | Ein-Satz-Definition | Bild im Kopf |
|---|---|---|
| **Replay** | Deterministisch wiederholbarer Agentenlauf gegen fixierte Inputs. | Tonbandaufnahme, die man identisch noch einmal abspielt. |
| **Golden Set** | Kuratiertes Eingabe/Erwartungs-Paar für Regressionstests. | das Lehrbuch, gegen das jeder neue Lauf abgleicht. |
| **Drift** | Abweichung des Verhaltens zwischen zwei Läufen, deren Manifeste eigentlich übereinstimmen sollten. | Schiff, das vom Kurs abkommt, ohne dass jemand das Steuer berührt. |
| **Determinismus** | Gleiche Eingabe → gleiche Ausgabe; setzt Modell+Seed *und* Toolchain+Wetter im Container voraus. | derselbe Wurf eines gezinkten Würfels: vorhersagbar, nicht zufällig. |

## Engage

Du wechselst dein Modell. Acht von zehn typischen Eingaben liefern
identische Antworten — du gehst live. Zwei Wochen später beschwert sich
ein Kunde über eine Ausgabe, die *früher* korrekt war. Dein Replay-Set
deckte das Muster nicht ab. Schlimmer: dein Golden Set ist über die Zeit
zum *Eintrainierten-Set* geworden — Replay grün, Realität rot. Wie
bekommt man das Drift-Symptom in den Griff?

## Lernziele

Nach diesem Modul kannst du:

* einen Replay-Lauf *einrichten*, der unter Beibehaltung von Modellversion + Seed deterministisch wiederholbar ist (Anwenden),
* ein Golden Set *aufbauen* und Auswahlkriterien *begründen* (Erschaffen),
* eine Regression durch Modellwechsel *messen* und einen Drift *quantifizieren* (Analysieren),
* Symptome von Golden-Set-Überfitting *erkennen* und Gegenmaßnahmen (Rotation, Sampling) *entwerfen* (Bewerten + Erschaffen).

## Lab-Bezug

* [`../../../lab/example/evals/golden/`](../../../lab/example/evals/golden/)
* [`../../../lab/example/Makefile`](../../../lab/example/Makefile), Target `make replay RUN=welle-1-baseline`

## Themen

* Replay (Inputs · Seed · Modellversion)
* Golden Sets
* Regressionstests
* Bewertungsmetriken (Exact-Match, semantisch, rubric-based)
* Domänen-Test-Typen jenseits "Unit/Integration": *determinism*, *replay*, *fault* als eigene Make-Targets (Beispiel grid-gym: `make test-determinism`, `make test-replay`, `make test-fault`)

## Begriff: Image-Hash (Vorgriff aus Modul 13)

Dieses Modul referenziert mehrfach den *Image-Hash* — das volle Bild
liegt in [Modul 13 (Docker-Harness)](../05-betrieb/modul-13-docker-harness.md),
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

Ohne Replay ist jeder Agenten-Lauf ein einmaliges Experiment. Mit Replay
wird er zur Messung.

## Typische Fehlvorstellungen

- **"Wenn der Replay grün ist, ist das Modell gut."** — Replay grün heißt: das Modell hat das wiederholt, was *im Golden Set steht*. Ob das Golden Set noch die Realität abbildet, ist eine andere Frage.
- **"Golden Set ist statisch."** — Statische Golden Sets überfitten. Rotation und neues Sampling sind Pflicht, nicht Kür.
- **"Determinismus = Reproduzierbarkeit."** — Determinismus erfordert: Modellversion + Seed + Inputs *und* Tool-Versionen, Wetter im Container, Zeitstempel-Maskierung. Wer nur Seed pinnt, hat 60 % Determinismus.

## Worked Example: ein Replay-Manifest aufbauen

> **Wenn du Replay-Manifeste mit Modellversion + Seed + Image-Hash + Golden Set bereits pflegst, springe zu [§Übungen](#übungen).** Worked Examples helfen beim Aufbau des Schemas; ist es da, kostet das Mitlesen Last (Expertise-Reversal).

**Ausgangssituation:** Du hast einen Agentenlauf gemacht, der den Slice
`SL-024` (kleiner Replay-Erweiterung) abgeschlossen hat. Du willst ihn
als *Baseline-Replay* festhalten, gegen den Modellwechsel verglichen
wird.

**Schritt 1 — Pfad und Skelett anlegen.**

```
evals/golden/welle-1-baseline/
├── manifest.yaml
├── inputs/
│   ├── case-001.json
│   ├── case-002.json
│   └── case-003.json
└── expectations/
    ├── case-001.json
    └── ...
```

Drei Fälle ist das Minimum: Happy / Boundary / Negative — dieselbe
Spec-Disziplin wie bei Akzeptanzkriterien
([Modul 2](../01-spec-und-architektur/modul-02-lastenheft.md)). Ein
Replay mit einem Fall ist eine Demo, kein Replay.

**Schritt 2 — Pflichtfelder im Manifest fixieren.**

```yaml
# evals/golden/welle-1-baseline/manifest.yaml
slice: SL-024
recorded_at: 2026-06-15T10:31:00Z
model:
  name: claude-opus-4-7
  version: "20260301"
  seed: 42
runtime:
  image_hash: sha256:9c7f4a...   # siehe Vorgriff-Block oben
  toolchain:
    python: 3.12.4
    ruff: 0.4.10
inputs_ref: inputs/
expectations_ref: expectations/
```

Drei Felder sind im Selbstcheck Pflicht: `model.version`, `model.seed`,
`inputs_ref`. Zwei weitere unterscheiden ernsthaftes von symbolischem
Replay: `runtime.image_hash` (Toolchain-Drift abgrenzen) und
`recorded_at` (späteren Diff datieren).

**Schritt 3 — Erwartungen *als Verhalten*, nicht als Wortlaut.**
Schlecht: *"Agent antwortet exakt 'index updated'"* — bricht bei
Modellwechsel sofort. Gut:

```yaml
# expectations/case-001.json
{
  "must_include": ["index", "updated"],
  "must_not_include": ["error", "traceback"],
  "tool_calls": {
    "writer.write_index": {"min": 1, "max": 1}
  }
}
```

Drei semantische Aussagen statt eines wörtlichen Vergleichs. Exact-Match
bewahre für strukturierte Schnittstellen (JSON-Felder), nie für
Fließtext.

**Schritt 4 — Erster Lauf, Baseline einfrieren.**

```bash
make replay RUN=welle-1-baseline
```

Erwartet: drei grüne Fälle. Wenn nicht: *erst* das Manifest schärfen
(meist Schritt 3 zu eng), nicht das Modell tauschen.

**Schritt 5 — Modellwechsel-Drift messen.**

```bash
make replay RUN=welle-1-baseline MODEL=claude-sonnet-4-6
```

Drei mögliche Ergebnisse:
* alle grün → kein Drift in dieser Klasse.
* einer rot → erste Drift-Diagnose: ist die Erwartung zu eng (Schritt 3 nachschärfen)
  oder hat das neue Modell ein neues Verhalten?
* zwei rot → Modellwechsel nicht ohne Anpassung möglich; Carveout +
  Folge-Slice für Erwartungs-Update.

**Schritt 6 — Drift-Diagnose-Reihenfolge.** Wenn ein Lauf rot wird, ist
die Reihenfolge der Verdächtigen *nicht beliebig*:

| Reihenfolge | Verdächtiger | Belegquelle |
|---|---|---|
| 1 | Toolchain-Drift | `runtime.image_hash` verglichen |
| 2 | Modell-Routing | `model.version` plus Provider-Status |
| 3 | Erwartungs-Drift | Eingaben vs. Spec (Modul 2) |
| 4 | echte Regression | alles oben ausgeschlossen |

Wer zuerst auf "echte Regression" tippt, baut den Carveout an der
falschen Stelle ein.

**Schritt 7 — Lerneintrag und Rotation.**
Replay-Sets verrotten (siehe Mini-Glossar oben, *Drift*). In
`evals/golden/welle-1-baseline/CHANGELOG.md`:

```markdown
2026-06-15 — Baseline mit drei Fällen aufgesetzt.
2026-08-02 — Fall hinzugefügt aus Steering-Loop-Eintrag #4
             (vorher unerkanntes Negativ-Muster, siehe
             reflexion-vorlage.md).
2026-09-10 — Fall-001 entfernt — Realität hat
             Schnittstelle geändert, Fall war giftig.
```

Sieben Schritte, ein reproduzierbares Manifest. Vergleich:
[`../../../lab/example/evals/golden/`](../../../lab/example/evals/golden/).

## Übungen

* Reproduzierbare Testläufe gegen ein Golden Set
* Erzeuge eine Regression durch Modellwechsel und miss den Drift

### Minimaler Übungspfad

```bash
cd lab/example
make replay RUN=welle-1-baseline
```

Erwartete Beobachtung: Das Target validiert nur das Golden-Set-Fixture.
Der didaktische Punkt ist die Belegstruktur: Modellversion, mindestens
drei Fälle und explizite Erwartungen. Für die Drift-Übung änderst du in
einer Kopie die Modellversion oder eine Erwartung und notierst, ob der
Replay-Lauf noch als derselbe Lauf interpretierbar ist.

## Reflexion

Nach dem Replay-Setup und der Modellwechsel-Drift-Messung kurz **schriftlich**:

1. **Was ist beobachtbar passiert?** — Welche Pflichtfelder hattest du im Manifest? Welche fehlten? In welcher Reihenfolge hast du Verdächtige für die Drift abgearbeitet?
2. **Welcher 2×2-Quadrant war Ursache?** — siehe [`konzeptkarte.md §2x2-Schnellanker`](../grundlagen/konzeptkarte.md#2x2-schnellanker). Replay als Sensor ist *computational feedback*; Golden-Set-Pflege ist Entropy Management.
3. **Welche konkrete Steering-Loop-Aktion folgt?** — Image-Hash als Manifest-Pflicht? Golden-Set-Rotation als Welle? Adversarial-Beispiele aus deinem Reflexions-Trace ziehen?
4. **Welche eigene Vorstellung wurde unzufriedenstellend?** — Conceptual Change; Kandidaten in [`lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "Wenn der Replay grün ist, ist das Modell gut", "Determinismus = Reproduzierbarkeit", "Golden Set ist statisch").

Eintragsformat, "Wann *nicht* reagieren" und Anti-Antworten: [`reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md).

## Selbstcheck

* **(Erinnern)** Welche drei Felder muss ein Replay-Manifest mindestens festhalten?
* Was muss ein Replay festhalten, damit er deterministisch ist?
* Wann wird ein Golden Set giftig (überfittet)?
* **(Anwenden)** In deinem eigenen Repo: welche zwei Drift-Quellen würdest du *zuerst* messen, wenn du nur eine Woche Zeit hast?
* **(Erschaffens-Prozess)** Welcher Schritt beim Aufbau deines Replay-Manifests war der *unsicherste* — und warum? (Erfahrungsgemäß: Schritt 3 "Erwartungen als Verhalten, nicht als Wortlaut" oder Schritt 6 "Drift-Diagnose-Reihenfolge".)

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Drei Pflichtfelder eines Replay-Manifests? | "Modell." | Modellversion · Seed · Eingaben (Inputs als referenzierter Datensatz, nicht als Inline-Text). | + Pflichtfeld Nummer 4 in jedem ernsten Setup: Image-Hash (siehe Abschnitt oben) — sonst lässt sich Drift nicht von Toolchain-Drift trennen. Pflichtfeld Nummer 5: Zeitpunkt der Aufnahme (für Diff zu späteren Läufen). |
| Was braucht ein deterministischer Replay? | "Seed." | Modellversion + Seed + Inputs *und* Tool-Versionen + Zeitstempel-Maskierung + Image-Hash (Docker-Harness, Modul 13). | + Hinweis: wer nur Seed pinnt, hat ~60 % Determinismus. Reale Drift-Quellen: Tool-Subversions, Lokale-Zeit, Netz-Latenz, Modell-Routing innerhalb derselben Version. |
| Wann wird ein Golden Set giftig? | "Wenn es nicht passt." | Wenn Replay reproduzierbar grün ist, aber Realität rot — typisch durch jahrelang konstantes Set. Symptome: keine Failure-Klasse seit X Wochen, neue Eingabe-Klassen tauchen *nur* in Produktion auf. | + Gegenmaßnahmen: Rotation (alte Beispiele rausnehmen), Sampling aus Produktions-Traces, Adversarial-Beispiele aus Steering-Loop-Einträgen ([`reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md)) ziehen. |
| Zwei Drift-Quellen — welche zuerst? | "Modell ändert sich." | Zwei konkrete: (a) Modellversion-/Routing-Drift (gleicher Tag, anderes Subroute beim Provider) und (b) Toolchain-Drift (Tool-Subversion oder Image-Hash anders als geplant). Beide sind in der ersten Woche messbar, beide haben einen sofortigen Sensor (Replay-Manifest-Vergleich). | + Begründung: andere Quellen (Eingabe-Distribution, Tool-Allowlist-Drift, Cache-Verhalten) sind nachgelagert — wer sie misst, bevor Modell und Toolchain gepinnt sind, misst Rauschen. Reihenfolge ist nicht beliebig. |
| Unsicherster Schritt beim Replay-Manifest? | "Alles klar." (verdächtig) | Konkret benannter Schritt + Begründung (z. B. "Schritt 3 Erwartungen, weil ich nicht entscheiden konnte, was *semantisch* gleich genug ist"). | + Pointe: Schritt 3 ist die häufigste Bruchstelle — wer Erwartungen wortwörtlich formuliert, bricht beim ersten Modellwechsel. Schritt 6 (Drift-Diagnose-Reihenfolge) ist die zweithäufigste: wer ohne Reihenfolge testet, klassifiziert echte Regressionen als Toolchain-Drift und umgekehrt. |

## Weiterlesen

* Test-Diversität als reale Praxis: `pt9912/grid-gym` in [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
* Nächstes Modul: [Modul 12 — Quality Gates](modul-12-quality-gates.md)
