# MR-003 — MR-001 gegenstandslos durch Baseline-Update

**Status:** Accepted

- **Datum:** 2026-08-01
- **Geltungsbereich:** [`MR-001`](done/MR-001-source-precedence-mit-spezifikations-schicht.md)
- **Ersetzt-Baseline-Regel:** — *(keine; dieser Eintrag löst eine eigene
  frühere Adaption auf und tritt nicht an die Stelle einer Baseline-Regel)*
- **Adaption:** *keine* — dieser Eintrag löst `MR-001` auf. Die Baseline führt
  seither **alle drei Spec-Straten als obligatorisch**
  ([`konventionen.md` §Spec-Straten](../../../../kurs/de/grundlagen/referenz-richtung.md#spec-straten-mehr-als-ein-spec-dokument));
  die Source-Precedence-Tabelle mit `spec/spezifikation.md` auf Rang 2 ist
  damit der Default und keine Abweichung mehr.
- **Begründung:** Eine Adaption, die durch ein Baseline-Update
  gegenstandslos wird, wird nicht gelöscht und nicht überschrieben, sondern
  bekommt einen Nachfolger, der sie auflöst und den auslösenden
  Baseline-Stand nennt — dieselbe Append-only-Disziplin wie bei ADRs
  ([`konventionen.md` §Source Precedence](../../../../kurs/de/grundlagen/source-precedence.md#source-precedence)).
- **Auflösungs-Trigger:** permanent.
