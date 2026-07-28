# Release-Checkliste — DocSearch-Lab

Diese Checkliste ist ein Lehr-Fixture fuer Modul 16. Jedes Item braucht
einen Beleg, nicht nur ein Haekchen.

| Item | Beleg |
|---|---|
| Gates gruen | `make gates COURSE_LANG=go` oder Sprach-Aequivalent |
| Golden-Set-Form geprueft | `make replay RUN=welle-1-baseline` (validiert die Form, fuehrt den Replay nicht aus) |
| Trace vorhanden | `make trace RUN=sl-009-agent-run` |
| ADR-/Requirement-IDs nachvollziehbar | `slice-009`, `LH-QA-02`, `ADR-0003` |
| Rollback-Entscheidung bekannt | [`incident-agent-data-loss.md`](incident-agent-data-loss.md) |

## Freigabeentscheidung

Freigabe nur, wenn Gates, Golden-Set-Form und Trace einen gemeinsamen
Slice-Bezug haben. Einzelne gruen gemeldete Tools ohne Traceability sind kein
Release-Beleg.
