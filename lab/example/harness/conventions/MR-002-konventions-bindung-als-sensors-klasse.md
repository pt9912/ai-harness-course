# MR-002 — Konventions-Bindung als Sensors-Klasse

**Status:** Accepted

**Adaption:** Die Bindung-Spalte in [`README.md` §Sensors](../README.md#sensors-feedback-gates)
darf neben den vier kanonischen Klassen und der LH-Bindung auch eine
**Kurs-Konvention** nennen.

**Begründung:** Drei Gates dieses Repos setzen Regeln durch, die weder eine
Anforderung noch eine ADR sind, sondern Konventionen des Baseline-Regelwerks:
`make check-references` (Referenz-Richtung), `make replay`
(Golden-Set-Form, Modul 12) und `make release` (Release-Disziplin, Modul 16).
Ohne eigene Klasse trügen sie entweder `—` — dann behauptet die Tabelle, sie
setzten nichts durch — oder eine erfundene ID.

**Geltungsbereich:** nur die Bindung-Spalte in `harness/README.md` §Sensors.

**Ersetzt-Baseline-Regel:** [`harness-dateien.md` §Sensors — die vier kanonischen Bindung-Klassen als abschließende Liste](../../../../kurs/de/grundlagen/harness-dateien.md#harnessreadmemd-als-einstiegspunkt)

**Datum der Adoption:** 2026-06-02.
