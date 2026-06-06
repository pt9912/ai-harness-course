# Slice 009: Tie-Break-Determinismus im Index-Storage

**Status:** done

**Welle:** welle-1-mvp

**Bezug:** LH-QA-02 (Reproduzierbarkeit, primär), LH-FA-IDX-003 (Index-Schreib-Idempotenz, sekundär — deterministischer Tie-Break ist Voraussetzung für bit-identische Schreib-Ergebnisse), ADR-0003 (Index-Format), ADR-0012 (Index-Write-Strategie, sekundär)

**Autor:** Kurs-Lab. **Datum:** 2026-05-26.

## 1. Ziel

Deterministischen Tie-Break in der Top-K-Sortierung erzwingen — bei
identischem Cosinus-Score muss `(doc_path, section_index)` lexikographisch
sortiert werden (siehe Lastenheft, Spezifikation §1).

## 2. Definition of Done

- [x] `internal/index/searcher.go`: Tie-Break implementiert.
- [x] `make test-determinism` läuft 100 Iterationen identische Eingabe, vergleicht Hashes.
- [x] Doku-Update in `spec/spezifikation.md` §1 LH-FA-02.a.
- [x] `make gates` grün.
- [x] Closure-Notiz (siehe §7).

## 3. Plan (vor Code)

| Datei / Komponente | Änderungs-Art | Begründung |
|---|---|---|
| `internal/index/searcher.go` | update | Sort-Closure ergänzt Tie-Break |
| `internal/index/searcher_test.go` | update | Test mit zwei identischen Scores |
| `Makefile` | update | `test-determinism` als eigenes Target |
| `spec/spezifikation.md` | update | §1 LH-FA-02.a Schritt 5 präzisiert |

## 4. Trigger

- Bug in slice-007-Review-Lauf zeigte nicht-deterministische Reihenfolge.

## 5. Closure-Trigger

- DoD vollständig.
- `make test-determinism` grün in CI.

## 6. Risiken und offene Punkte

- Performance-Hit der Tie-Break-Vergleichsfunktion vernachlässigbar (< 1 %).

## 7. Closure-Notiz

**Ausgeführt am:** 2026-05-26.

**Beobachtung:** Der ursprüngliche Bug rührte daher, dass Go's `sort.Slice`
nicht stable ist. Wechsel zu `sort.SliceStable` plus expliziter
Tie-Break-Closure macht die Reihenfolge deterministisch.

**Steering-Loop-Eintrag:** AGENTS.md wurde erweitert um eine
Hard-Rule "Tie-Break in jeder sortierenden Operation muss explizit
dokumentiert sein" (jetzt auch in `harness/README.md` als Safety-Boundary).

**Folge-Slice:** keiner notwendig — Eigenschaft ist abgesichert in
allen vier weiteren Sprachen, wenn diese Welle 1 portieren (Welle 1
sortiert nach Sprach-Skelett-Roundtrip ab; siehe Roadmap M1).

## 8. Sub-Area-Modus-Begründung

**Status:** alle berührten Sub-Areas GF (siehe
`harness/conventions.md` §Modus-Deklaration pro Sub-Area: `*` = GF
für das DocSearch-Lab als Ganzes). Der Slice hat die `AGENTS.md`-Hard-
Rule "Tie-Break explizit dokumentiert" als Konventions-Adaption
gesetzt; das ist eine GF-Bewegung (Doku führt, Code wird gemessen) —
keine BF/Hybrid-Begründung nötig.

Voraussetzung-Wissen für den Block-Aufbau: Kurs
[Modul 5 §Worked Mini-Example](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#worked-mini-example-bootstrap-modus-pro-sub-area-für-einen-slice-begründen).
