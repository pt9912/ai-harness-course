# Modul 11 — Replay und Evaluierung

## Lernziele

* Replay-Läufe deterministisch wiederholen
* Golden Sets aufbauen und pflegen
* Regressionen messbar machen

## Lab-Bezug

* `evals/golden/`
* `make replay RUN=<id>`

## Themen

* Replay (Inputs · Seed · Modellversion)
* Golden Sets
* Regressionstests
* Bewertungsmetriken (Exact-Match, semantisch, rubric-based)
* Domänen-Test-Typen jenseits "Unit/Integration": *determinism*, *replay*, *fault* als eigene Make-Targets (Beispiel grid-gym: `make test-determinism`, `make test-replay`, `make test-fault`)

## Kernidee

Ohne Replay ist jeder Agenten-Lauf ein einmaliges Experiment. Mit Replay
wird er zur Messung.

## Übungen

* Reproduzierbare Testläufe gegen ein Golden Set
* Erzeuge eine Regression durch Modellwechsel und miss den Drift

## Selbstcheck

* Was muss ein Replay festhalten, damit er deterministisch ist?
* Wann wird ein Golden Set giftig (überfittet)?

## Weiterlesen

* Test-Diversität als reale Praxis: `pt9912/grid-gym` in [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
* Nächstes Modul: [Modul 12 — Quality Gates](modul-12-quality-gates.md)
