# welle-1-baseline — CHANGELOG

Replay-Sets verrotten. Diese Datei dokumentiert die Veränderung des
Sets über Wellen — sie ist *Pflicht* (siehe
[Kurs Modul 11](../../../../../kurs/de/04-qualitaet/modul-11-replay-evaluierung.md)
und [ADR-0011](../../../docs/plan/adr/0011-closure-note-pflicht.md)
für die Closure-Disziplin generell).

## 2026-05-28 — Baseline aufgesetzt

Welle-1-Closure-Replay. Drei Cases:

- case-001: Happy Path (LH-FA-02)
- case-002: Boundary (`k > 100`, clamped auf 100; LH-FA-02 Boundary)
- case-003: Negative (leere Query → E002; LH-FA-02 Negative)

Modellversion: `local-embed-v3@2026-05-15`. Determinismus-Strategie aus
ADR-0003 + slice-009 (Tie-Break-Determinismus).

## 2026-06-02 — Umstellung von flacher JSON-Datei auf Verzeichnis-Struktur

Bis Welle 9 lag das Set als einzelne `welle-1-baseline.json`-Datei. Mit
ADR-0012 (Index-Write-Strategie) und der Schema-Konvention für
LH-FA-IDX-* ergänzt um die Verzeichnis-Struktur aus Modul 11 Worked
Example. Inhalt unverändert; Form maschinell strenger prüfbar.

**Migration-Schritte:**
- `manifest.yaml` mit Top-Level-Feldern (`model`, `runtime`, `determinism`)
- `inputs/case-*.json` getrennt von `expectations/case-*.json`
- `tool_calls`-Erwartungen pro Case ergänzt (semantische Schicht, nicht nur Exact-Match)
- `make replay RUN=welle-1-baseline` prüft jetzt die Verzeichnis-Form

Folge-Slice: keiner — Form-Migration, kein semantischer Drift.
