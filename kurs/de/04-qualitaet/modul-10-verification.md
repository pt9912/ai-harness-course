# Modul 10 — Verification Harness

## Lernziele

* Plan-gegen-Code-Diffs automatisch verifizieren
* DoD-Verletzungen erkennen, bevor sie ins Closure rutschen
* ADR-Konformität messbar machen

## Lab-Bezug

* `make verify SLICE=<id>`
* `verification/checks/`

## Themen

* Plan-gegen-Code-Prüfung
* DoD-Verifikation
* ADR-Konformität
* Architekturkonformität
* Pre-completion Checklist Middleware (vom Agenten selbst durchlaufen, bevor er "fertig" meldet)

## Harness-Einordnung

Verifikation = primär *inferential feedback* in der Behaviour-Kategorie,
unterstützt durch *computational feedback* (Fitness Functions für die
Architecture-Fitness-Kategorie). Dies ist die anspruchsvollste Schicht
— und laut Böckeler die am wenigsten ausgereifte. Siehe
[`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md).

## Kernidee

Verifikation ist die Stelle, an der der Harness *gegen sich selbst*
misst: "Hat das, was gebaut wurde, das umgesetzt, was geplant war?" —
nicht: "Ist es gut?"

## Übungen

* Automatische Verifikation eines Slices
* Provoziere eine DoD-Verletzung und prüfe, ob sie erkannt wird

## Selbstcheck

* Warum reicht ein grünes Testsuite-Ergebnis nicht als Verifikation?
* Wer löst den Konflikt, wenn Verification rot, Review grün ist?

## Weiterlesen

* Nächstes Modul: [Modul 11 — Replay und Evaluierung](modul-11-replay-evaluierung.md)
