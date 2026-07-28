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

Alle Einträge kommen aus dem [Beobachtungs-Register](../observations.md) und
nennen ihre `BEO-<NNN>` — die Schwelle ist 3×. Eine **geschärfte Regel** trägt
das Pflichtfeld `liegt in <Zielort>`, und das Ziel trägt den Herkunfts-Anker
`seit welle-1`; geprüft wird die Paarung **am Ende von Closure-Schritt 3**,
nicht schon im Trigger-Audit (Schritt 2): dort gäbe es diese Einträge noch
nicht. Eine **benannte Spec-Lücke** trägt das Feld nicht — sie ist verkörpert
wie die anderen Klassen, nur in einer Lastenheft-Version statt an einem
Zielort, und ihr Gegenstück ist die `LH-*`-ID. Sie ist damit kein Gegenstand
der **Anker**-Paarung; an der **Register**-Paarung nimmt sie teil wie jeder
andere Eintrag.

- **AGENTS.md-Hard-Rule** ergänzt: "Tie-Break in jeder sortierenden Operation muss explizit dokumentiert sein" — liegt in `AGENTS.md §2.7` (trägt dort `seit welle-1`). Auslöser: `BEO-005` (slice-006, slice-009, slice-012 — 3×).
- **Spec-Lücke** benannt: Grenzwerte der Suche waren im Lastenheft nicht behandelt (zuletzt Top-K, `k > 100`) — aufgelöst über Lastenheft v0.2.0 (`LH-FA-02`), kein Herkunfts-Anker nötig. Auslöser: `BEO-007` (slice-003, slice-005, slice-007 — 3×).

## Beobachtungs-Register (Zeiger)

Der Zähler steht seit Kurs-Welle 59 als stehende Datei in
[`../observations.md`](../observations.md) — nicht mehr hier. Was in dieser
Welle 3× erreicht hat, steht oben unter *Steering-Loop-Einträge*.

## Folge-Slices

- slice-013 (Property-Tests) — startet welle-2.
- slice-014 (ANN-Suche) — startet welle-3.

## Verifikation

- `make fullbuild` grün (Build-Hash `sha256:abc123…`).
- Replay-Lauf gegen Golden Set: 12/12 Cases grün.
- Coverage gesamt: 78 %, kritisch: 92 % (siehe Carveout CO-001 für Index-Layer).
