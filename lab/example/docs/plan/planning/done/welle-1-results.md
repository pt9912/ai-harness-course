# Welle 1 — MVP — Closure-Notiz

**Welle:** welle-1-mvp
**Abschluss:** 2026-05-28
**Verantwortlich:** Kurs-Lab

## Was wurde geliefert?

- Lauffähiger DocSearch-Stack in Go als Referenz-Sprache (Folge-Wellen portieren zu Python/Kotlin/Java/C#).
- Indexierung (LH-FA-01) und Suche (LH-FA-02) mit Akzeptanzkriterien grün.
- Drei ADRs Accepted (siehe [`../../adr/README.md`](../../adr/README.md)).
- `make gates` mit Linter, Typecheck, Architekturtest, Coverage (bootstrap-aware), Tests.
- Erstes Replay-Beispiel in `evals/golden/welle-1-baseline.json`.

## Was hat funktioniert?

- Adapter-Pattern aus ADR-0001/0002 erlaubte Embedding-Modell-Wechsel binnen 30 min ohne Service-Eingriff.
- ID-Schema `LH-*` in Make-Target-Kommentaren wurde von zwei Reviewer-Agenten unabhängig korrekt zugeordnet.

## Was ging anders als geplant?

- Top-K-Boundary (`k > 100`) war im Original-Lastenheft nicht behandelt — Spec-Lücke. Folge: slice-007 plus Lastenheft v0.2.0.
- `make test-determinism` brachte einen nicht-deterministischen Tie-Break im Index-Storage zu Tage — slice-009 nachgezogen.

## Steering-Loop-Einträge

- **Spec-Template** erweitert um Pflicht-Sektion "Boundary" je Akzeptanzkriterium (siehe Lab-Template `lastenheft.template.md` §3).
- **AGENTS.md-Hard-Rule** ergänzt: "Tie-Break in jeder sortierenden Operation muss explizit dokumentiert sein" — heute Teil von slice-009-Closure.
- **Reviewer-Skill** geschärft auf "Spec-Vollständigkeit" (Boundary + Negative).

## Folge-Slices

- slice-013 (Property-Tests) — startet welle-2.
- slice-014 (ANN-Suche) — startet welle-3.

## Verifikation

- `make fullbuild` grün (Build-Hash `sha256:abc123…`).
- Replay-Lauf gegen Golden Set: 12/12 Cases grün.
- Coverage gesamt: 78 %, kritisch: 92 % (siehe Carveout CO-001 für Index-Layer).
