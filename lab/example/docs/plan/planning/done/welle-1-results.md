# Welle 1 — MVP — Closure-Notiz

**Welle:** welle-1-mvp
**Abschluss:** 2026-05-28
**Verantwortlich:** Kurs-Lab

## Was wurde geliefert?

- Lauffähiger DocSearch-Stack in Go als Referenz-Sprache (Folge-Wellen portieren zu Python/Kotlin/Java/C#).
- Indexierung (LH-FA-01) und Suche (LH-FA-02) mit Akzeptanzkriterien grün.
- Drei ADRs Accepted (siehe [`../../adr/README.md`](../../adr/README.md)).
- `make gates` mit Linter, Typecheck, Architekturtest, Coverage (bootstrap-aware), Tests.
- Erstes Replay-Beispiel in `evals/golden/welle-1-baseline/` (siehe `manifest.yaml` + drei Cases unter `inputs/` und `expectations/`).

## Was hat funktioniert?

- Adapter-Pattern aus ADR-0001/0002 erlaubte Embedding-Modell-Wechsel binnen 30 min ohne Service-Eingriff.
- ID-Schema `LH-*` in Make-Target-Kommentaren wurde von zwei Reviewer-Agenten unabhängig korrekt zugeordnet.

## Was ging anders als geplant?

- Top-K-Boundary (`k > 100`) war im Original-Lastenheft nicht behandelt — Spec-Lücke. Folge: slice-007 plus Lastenheft v0.2.0.
- `make test-determinism` brachte einen nicht-deterministischen Tie-Break im Index-Storage zu Tage — slice-009 nachgezogen.

## Steering-Loop-Einträge

Eine **geschärfte Regel** nennt ihren **Zielort**, und das Ziel trägt den
Herkunfts-Anker `seit welle-1` — die Paarung wird beim Carveout-Audit
mitgeprüft. Eine **benannte Spec-Lücke** trägt keinen Anker: sie landet in
einer Lastenheft-Version und hat damit bereits eine `LH-*`-ID.

- **AGENTS.md-Hard-Rule** ergänzt: "Tie-Break in jeder sortierenden Operation muss explizit dokumentiert sein" — liegt in [`AGENTS.md`](../../../../AGENTS.md) §2.7 (trägt dort `seit welle-1`). Auslöser: slice-006, slice-009, slice-012 (3×).
- **Spec-Lücke** benannt: Top-K-Boundary (`k > 100`) war nicht behandelt — aufgelöst über Lastenheft v0.2.0 (`LH-FA-02`), kein Herkunfts-Anker nötig.

## Beobachtungen unter Schwelle

Übernahme in die nächste Closure, dort hochzählen. Bei 3× wandert der
Eintrag nach oben in die Steering-Loop-Einträge.

| Beobachtung (stabile Bezeichnung) | Betroffene Sub-Area | Zähler | Belege |
|---|---|---|---|
| Golden-Set-Case ohne Boundary-Anteil aufgenommen | Test-Infrastruktur | 2× | slice-005, slice-011 |
| Golden-Set deckt keine Gleichstands-Eingaben ab | Test-Infrastruktur | 1× | slice-009 (§6, Ausgang „weiter offen") |
| ADR-Bezug im Commit vergessen, im Review nachgetragen | Spec-Schreibung | 1× | slice-008 |

## Folge-Slices

- slice-013 (Property-Tests) — startet welle-2.
- slice-014 (ANN-Suche) — startet welle-3.

## Verifikation

- `make fullbuild` grün (Build-Hash `sha256:abc123…`).
- Replay-Lauf gegen Golden Set: 12/12 Cases grün.
- Coverage gesamt: 78 %, kritisch: 92 % (siehe Carveout CO-001 für Index-Layer).
