# welle-1-baseline — CHANGELOG

Replay-Sets verrotten. Diese Datei dokumentiert die Veränderung des
Sets über Wellen — sie ist *Pflicht* (siehe
[Kurs Modul 12](../../../../../kurs/de/04-qualitaet/modul-12-replay-evaluierung.md)
und [ADR-0011](../../../docs/plan/adr/0011-closure-note-pflicht.md)
für die Closure-Disziplin generell).

## 2026-05-22 — Set angelegt

slice-005 (Golden Set anlegen) legt zwei Cases an: Happy Path und Negative
(leere Query → `E002`).

## 2026-05-30 — Boundary-Case ergänzt

slice-011 (Golden-Set-Erweiterung) nimmt den Fall `k > 100` aus Lastenheft
v0.2.0 auf. Vorher deckte das Set nur Happy Path und Negative ab — notiert als
`BEO-001` im Beobachtungs-Register. Die Cases stehen seither in der Reihenfolge
Happy · Boundary · Negative; der Negative-Case heißt dabei von `case-002` nach
`case-003` um. Umnummerierungen gehören in diese Datei, sonst zeigen ältere
Befunde auf den falschen Case.

## 2026-06-02 — Baseline aufgesetzt

Welle-1-Closure-Replay. Drei Cases:

- case-001: Happy Path (LH-FA-02)
- case-002: Boundary (`k > 100`, clamped auf 100; LH-FA-02 Boundary)
- case-003: Negative (leere Query → E002; LH-FA-02 Negative)

Modellversion: `local-embed-v3@2026-05-22`. Determinismus-Strategie aus
[ADR-0003](../../../docs/plan/adr/0003-index-storage-format.md) + slice-009 (Tie-Break-Determinismus).

## 2026-06-02 — Umstellung von flacher JSON-Datei auf Verzeichnis-Struktur

Bis Kurs-Welle 9 lag das Set als einzelne `welle-1-baseline.json`-Datei. Mit
[ADR-0012](../../../docs/plan/adr/0012-index-write-strategy.md) (Index-Write-Strategie) und der Schema-Konvention für
LH-FA-IDX-* ergänzt um die Verzeichnis-Struktur aus Modul 12 Worked
Example. Inhalt unverändert; Form maschinell strenger prüfbar.

**Migration-Schritte:**
- `manifest.yaml` mit Top-Level-Feldern (`model`, `runtime`, `determinism`)
- `inputs/case-*.json` getrennt von `expectations/case-*.json`
- `tool_calls`-Erwartungen pro Case ergänzt (semantische Schicht, nicht nur Exact-Match)
- `make replay RUN=welle-1-baseline` prüft jetzt die Verzeichnis-Form

Folge-Slice: keiner — Form-Migration, kein semantischer Drift.
