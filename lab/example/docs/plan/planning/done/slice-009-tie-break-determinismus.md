# Slice 009: Tie-Break-Determinismus im Index-Storage

**Lifecycle:** Der Zustand dieses Slice ist das Verzeichnis, in dem diese
Datei liegt — eines von `open/`, `next/`, `in-progress/`, `done/`. Er wechselt
nur durch `git mv` (Kurs
[Modul 5 §Lifecycle als State Machine](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#lifecycle-als-state-machine)).

**Welle:** welle-1-mvp

**Bezug:** LH-QA-02 (Reproduzierbarkeit, primär), ADR-0003 (Index-Format).

**Nachtrag 2026-06-02** (Lab-Ausbau (Kurs-Welle 9); Traceability-Metadata, keine
Änderung am Slice): Der hier gebaute Tie-Break belegt zusätzlich
`LH-FA-IDX-003` (Index-Schreib-Idempotenz — Determinismus ist Voraussetzung für
bit-identische Schreib-Ergebnisse) und wird von `ADR-0012` als Verifikation
herangezogen. Beide entstanden nach diesem Slice; die Verweise sind rückwirkend
eingetragen.

**Autor:** Kurs-Lab. **Datum:** 2026-05-26.

## 1. Ziel

Deterministischen Tie-Break in der Top-K-Sortierung erzwingen — bei
identischem Cosinus-Score muss `(doc_path, section_index)` lexikographisch
sortiert werden (siehe Lastenheft, Spezifikation §1).

## 2. Definition of Done

- [x] `internal/index/index.go`: Tie-Break implementiert (`sort.SliceStable` + lexikographischer Zweitschlüssel).
- [x] `make test-determinism` läuft 100 Iterationen identische Eingabe, vergleicht Hashes.
- [x] Doku-Update in `spec/spezifikation.md` §1 LH-FA-02.a.
- [x] `make gates` grün.
- [x] Closure-Notiz (siehe §7).

## 3. Plan (vor Code)

| Datei / Komponente | Änderungs-Art | Begründung |
|---|---|---|
| `internal/index/index.go` | update | Sort-Closure ergänzt Tie-Break |
| `internal/index/index_test.go` | update | Test mit zwei identischen Scores |
| `internal/service/search_test.go` | update | Tie-Break-Reihenfolge auf Service-Ebene abgesichert |
| `<sprache>/Makefile` | update | `test-determinism` als eigenes Target |
| `spec/spezifikation.md` | update | §1 LH-FA-02.a Schritt 5 präzisiert |

## 4. Trigger

- Bug in slice-007-Review-Lauf zeigte nicht-deterministische Reihenfolge.

## 5. Closure-Trigger

- DoD vollständig.
- `make test-determinism` grün in CI.

## 6. Risiken und offene Punkte

Jedes Risiko trägt bei Closure genau einen Ausgang (Modul 5
§Offene Risiken werden bei Closure aufgelöst).

- Performance-Hit der Tie-Break-Vergleichsfunktion — **Ausgang:** entfallen.
  Gemessen < 1 % gegen den Benchmark aus `evals/`, damit kein Risiko mehr.
- Golden-Set-Cases decken keine Gleichstands-Eingaben ab — **Ausgang:**
  weiter offen → Beobachtungs-Register `BEO-002`
  (Sub-Area *Replay-/Eval-Infrastruktur*: verletzt ist die Golden-Set-Konvention,
  nicht die Test-Konvention).

## 7. Closure-Notiz

**Ausgeführt am:** 2026-05-26.

**Beobachtung:** Der ursprüngliche Bug rührte daher, dass Go's `sort.Slice`
nicht stable ist. Wechsel zu `sort.SliceStable` plus expliziter
Tie-Break-Closure macht die Reihenfolge deterministisch.

**Steering-Loop-Eintrag:** Beobachtung im Register auf **2×** erhöht
(`BEO-005`, Beleg `slice-009` ergänzt). Die Schwelle fällt erst mit
`slice-012`. Die Verkörperung —
AGENTS.md-Hard-Rule "Tie-Break in jeder sortierenden Operation muss explizit
dokumentiert sein" — erfolgt beim Lese-Schritt der Welle-1-Closure, nicht
hier: *gezählt* ist nicht *verkörpert*.

**Folge-Slice:** keiner notwendig — Eigenschaft ist abgesichert in
allen fünf weiteren Sprachen, wenn diese Welle 1 portieren (Welle 1
sortiert nach Sprach-Skelett-Roundtrip ab; siehe Roadmap M1).

## 8. Sub-Area-Modus-Begründung

**Status:** alle berührten Sub-Areas GF (siehe
`harness/conventions.md` §Modus-Deklaration pro Sub-Area: `*` = GF
für das DocSearch-Lab als Ganzes). Der Slice setzt **keine** Konventions-Adaption; die
`AGENTS.md`-Hard-Rule "Tie-Break explizit dokumentiert" entstand erst beim
Lese-Schritt der Welle-1-Closure aus `BEO-005`. Reine GF-Bewegung —
keine BF/Hybrid-Begründung nötig.

**Vorgelagert — Sub-Area-Wahl prüfen:** Drei berührte Sub-Areas, alle über der
Schwelle (`harness/conventions.md` §Modus-Deklaration): *Implementierung*
(`internal/index/`, `internal/service/`), *Test-Infrastruktur*
(`test-determinism` als neues Target — eine neue Konvention, keine additive
Arbeit unter der alten) und *Spec-Schreibung* (`spec/spezifikation.md` §1).
Keine davon ist zu grob geschnitten; *Sensor-Werkzeuge* ist mitberührt, aber
nur als Ablageort des Targets, nicht in seiner Konventions-Härte.

**Vorgelagert — offene Beobachtungen sichten:** Register
(`../observations.md`) durchgegangen. `BEO-005` (*Implementierung*) steht bei
1× aus `slice-006` und trifft mit diesem Slice zum **zweiten** Mal dieselbe
Sub-Area — Zähler auf 2×, Beleg ergänzt. Die Schwelle fällt erst mit
`slice-012`; verkörpert wird beim Lese-Schritt der Welle-1-Closure, nicht
hier. Auf *Test-Infrastruktur* und *Spec-Schreibung* steht keine Zeile.

Voraussetzung-Wissen für den Block-Aufbau: Kurs
[Modul 5 §Worked Mini-Example](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#worked-mini-example-bootstrap-modus-pro-sub-area-für-einen-slice-begründen).
