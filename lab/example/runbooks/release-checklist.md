# Release-Checkliste — DocSearch-Lab

Diese Checkliste ist ein Lehr-Fixture fuer Modul 16. Jedes Item braucht
einen Beleg, nicht nur ein Haekchen.

| Item | Beleg |
|---|---|
| Gates gruen | `make gates COURSE_LANG=go` oder Sprach-Aequivalent |
| Replay ausgefuehrt | `make replay RUN=welle-1-baseline` |
| Trace vorhanden | `make trace RUN=sl-009-agent-run` |
| ADR-/Requirement-IDs nachvollziehbar | `slice-009`, `LH-QA-02`, `ADR-0003` |
| Rollback-Entscheidung bekannt | [`incident-agent-data-loss.md`](incident-agent-data-loss.md) |

## Freigabeentscheidung

Freigabe nur, wenn Gates, Replay und Trace einen gemeinsamen Slice-Bezug
haben. Einzelne gruen gemeldete Tools ohne Traceability sind kein
Release-Beleg.
