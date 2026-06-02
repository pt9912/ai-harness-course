# Modul 4 — Planning Harness

## Lernziele

* Slices über die Lifecycle-Verzeichnisse bewegen
* Slice-Pläne so schneiden, dass sie agentisch umsetzbar sind
* Trigger und Closure-Kriterien explizit machen

## Lab-Bezug

* `docs/plan/planning/{open,next,in-progress,done}/`
* `make plan-status`

## Themen

* Slice-Planung
* Wellen
* Trigger
* Closure
* Was ein Plan enthalten muss, damit ein Agent ihn umsetzen kann

## Kernidee

Ein Slice ist klein, wenn ein Agent ihn in *einem* Lauf abschließen kann
und ein Reviewer den Diff *in einer Sitzung* prüfen kann. Größer ist
falsch.

## Übungen

* Planung eines Features über mehrere Wellen
* Bewege einen Slice durch alle vier Verzeichnisse
* Schneide einen zu großen Slice in zwei umsetzbare Slices

## Selbstcheck

* Welcher Trigger bewegt einen Slice von `next/` nach `in-progress/`?
* Wann darf ein Slice in `done/` landen, obwohl ein Gate rot ist?

## Weiterlesen

* Welle-Self-Close-Konvention als Hard Rule: `pt9912/grid-gym` in [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
* Nächstes Modul: [Modul 5 — Roadmap Engineering](modul-05-roadmap.md)
