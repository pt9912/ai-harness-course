# Carveouts — DocSearch

Aktive Carveouts mit Auflösungs-Trigger. Aufgelöste Carveouts wandern
nach `done/` (reiner `git mv`).

## Aktive Carveouts

| ID | Titel | Gate | Trigger | Folge-Slice |
|---|---|---|---|---|
| [CO-001](CO-001-index-coverage.md) | Bootstrap-Coverage Index-Layer | `coverage-gate-critical` | Welle 2 done | slice-013 |
| [CO-002](CO-002-replay-verifikation.md) | Replay-Verifikation deklariert, nicht durchgesetzt | `make replay` | slice-015 done | slice-015 |

## Aufgelöste Carveouts

(noch keine)

## Konventionen

- Jeder aktive Carveout braucht: Trigger, Folge-Slice, letzten Prüf-Termin.
- Bei Welle-Closure: Carveout-Audit zwingend. Welche sind weiterhin gültig? Welche aufgelöst?
- Siehe [Kurs Modul 7](../../../../../kurs/de/02-planung/modul-07-carveouts.md).
