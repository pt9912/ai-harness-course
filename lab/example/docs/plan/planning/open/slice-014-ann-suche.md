# Slice 014: Approximate-NN-Suche

**Status:** open

**Welle:** welle-3-skalierung

**Bezug:** LH-QA-01 (Performance), implizit ADR-0003 (Index-Format)

**Autor:** Kurs-Lab. **Datum:** 2026-05-30.

## 1. Ziel

Lineare Cosinus-Suche durch Approximate-NN ersetzen, um p95-Latenz
auch bei > 100k Index-Einträgen zu halten.

## 2. Definition of Done

- [ ] ADR-0004 "ANN-Bibliothek-Wahl" Accepted.
- [ ] Adapter `IndexSearcher` mit Implementierungen `Linear` (Default) und `ANN` (neue).
- [ ] `make test-determinism` weiterhin grün (deterministischer Tie-Break auch bei ANN).
- [ ] Replay gegen Golden Set: recall@5 verschlechtert sich um maximal 5 %.
- [ ] `make gates` grün.
- [ ] Closure-Notiz mit Recall-Vergleich (Linear vs. ANN).

## 3. Plan (vor Code)

| Datei / Komponente | Änderungs-Art | Begründung |
|---|---|---|
| `docs/plan/adr/0004-ann-bibliothek.md` | neu | Wahl mit Alternativen-Vergleich |
| `internal/index/searcher.go` (Go) | neu | Interface + Linear-Implementierung |
| `internal/index/ann.go` (Go) | neu | ANN-Implementierung |
| `internal/service/search.go` | update | Konstruktor wählt Searcher per Config |
| Äquivalente Pfade in python/kotlin/java/csharp | neu | Pro Sprach-Skelett |

## 4. Trigger

- Wenn slice-013-property-tests done (Replay-Suite muss stabil sein, bevor Searcher-Wechsel valides Messen erlaubt).

## 5. Closure-Trigger

- DoD vollständig.
- Replay-Lauf zeigt p95-Verbesserung bei mindestens einer Konfiguration > 100k Einträge.
- Closure-Notiz schließt Recall-Vergleich ein.

## 6. Risiken und offene Punkte

- ANN-Bibliotheken haben unterschiedliche Lizenz-Charakteristiken — InfoSec-Review nötig.
- Deterministischer Tie-Break ist bei ANN nicht-trivial (siehe LH-QA-02).
- Möglicher Carveout, wenn recall@5 nicht haltbar.

## 7. Closure-Notiz

<!-- Erst nach Abschluss füllen. -->

## 8. Sub-Area-Modus-Begründung

**Status:** alle berührten Sub-Areas GF (siehe
`harness/conventions.md` §Modus-Deklaration pro Sub-Area: `*` = GF
für das DocSearch-Lab als Ganzes). Spec-Schreibung (LH-FA-12) und
Architektur (ADR-0004 in Outline) führen, Code folgt — kein
Reconciliation, keine BF/Hybrid-Begründung nötig.

Voraussetzung-Wissen für den Block-Aufbau: Kurs
[Modul 5 §Worked Mini-Example](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#worked-mini-example-bootstrap-modus-pro-sub-area-für-einen-slice-begründen).
