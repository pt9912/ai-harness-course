# Uebung 00 — Postmortem eines fehlgeschlagenen Agentenlaufs

## Ausgangslage

Ein Implementation-Agent sollte `slice-009` umsetzen. Er hat direkt Code
geschrieben, ohne `harness/README.md` zu lesen. Die Tests waren lokal
gruen, aber die Reihenfolge gleicher Scores war im CI nicht
deterministisch.

## Aufgabe

1. Benenne den beobachtbaren Fehler.
2. Ordne die Ursache einer Harness-Luecke zu.
3. Entscheide, ob die naechste Steering-Loop-Aktion ein Guide, ein Sensor
   oder beides ist.

## Material

- [`../docs/plan/planning/done/slice-009-tie-break-determinismus.md`](../docs/plan/planning/done/slice-009-tie-break-determinismus.md)
- [`../harness/README.md`](../harness/README.md)
- [`../evals/example-trace.json`](../evals/example-trace.json)

## Erwartetes Zwischenprodukt

Ein Postmortem mit drei kurzen Abschnitten: Beobachtung, Harness-Luecke,
Steering-Loop-Aktion. Vergleiche danach mit
[`../../../kurs/de/loesungen/modul-00-loesung.md`](../../../kurs/de/loesungen/modul-00-loesung.md).
