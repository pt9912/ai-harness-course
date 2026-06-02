# Modul 11 — Replay und Evaluierung

> **Aufwand:** ca. 75 Min Lesen · 90 Min Übung.

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

Nach den Übungen: [Reflexionsvorlage](../grundlagen/reflexion-vorlage.md).

## Selbstcheck

* **(Erinnern)** Welche drei Felder muss ein Replay-Manifest mindestens festhalten?
* Was muss ein Replay festhalten, damit er deterministisch ist?
* Wann wird ein Golden Set giftig (überfittet)?
* **(Anwenden)** In deinem eigenen Repo: welche zwei Drift-Quellen würdest du *zuerst* messen, wenn du nur eine Woche Zeit hast?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Drei Pflichtfelder eines Replay-Manifests? | "Modell." | Modellversion · Seed · Eingaben (Inputs als referenzierter Datensatz, nicht als Inline-Text). | + Pflichtfeld Nummer 4 in jedem ernsten Setup: Image-Hash (siehe Abschnitt oben) — sonst lässt sich Drift nicht von Toolchain-Drift trennen. Pflichtfeld Nummer 5: Zeitpunkt der Aufnahme (für Diff zu späteren Läufen). |
| Was braucht ein deterministischer Replay? | "Seed." | Modellversion + Seed + Inputs *und* Tool-Versionen + Zeitstempel-Maskierung + Image-Hash (Docker-Harness, Modul 13). | + Hinweis: wer nur Seed pinnt, hat ~60 % Determinismus. Reale Drift-Quellen: Tool-Subversions, Lokale-Zeit, Netz-Latenz, Modell-Routing innerhalb derselben Version. |
| Wann wird ein Golden Set giftig? | "Wenn es nicht passt." | Wenn Replay reproduzierbar grün ist, aber Realität rot — typisch durch jahrelang konstantes Set. Symptome: keine Failure-Klasse seit X Wochen, neue Eingabe-Klassen tauchen *nur* in Produktion auf. | + Gegenmaßnahmen: Rotation (alte Beispiele rausnehmen), Sampling aus Produktions-Traces, Adversarial-Beispiele aus Steering-Loop-Einträgen ([`reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md)) ziehen. |
| Zwei Drift-Quellen — welche zuerst? | "Modell ändert sich." | Zwei konkrete: (a) Modellversion-/Routing-Drift (gleicher Tag, anderes Subroute beim Provider) und (b) Toolchain-Drift (Tool-Subversion oder Image-Hash anders als geplant). Beide sind in der ersten Woche messbar, beide haben einen sofortigen Sensor (Replay-Manifest-Vergleich). | + Begründung: andere Quellen (Eingabe-Distribution, Tool-Allowlist-Drift, Cache-Verhalten) sind nachgelagert — wer sie misst, bevor Modell und Toolchain gepinnt sind, misst Rauschen. Reihenfolge ist nicht beliebig. |

## Weiterlesen

* Test-Diversität als reale Praxis: `pt9912/grid-gym` in [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
* Nächstes Modul: [Modul 12 — Quality Gates](modul-12-quality-gates.md)
