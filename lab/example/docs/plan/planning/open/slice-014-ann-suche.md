# Slice 014: Approximate-NN-Suche

**Lifecycle:** Der Zustand dieses Slice ist das Verzeichnis, in dem diese
Datei liegt — eines von `open/`, `next/`, `in-progress/`, `done/`. Er wechselt
nur durch `git mv` (Kurs
[Modul 5 §Lifecycle als State Machine](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#lifecycle-als-state-machine)).

**Welle:** welle-3-skalierung

**Bezug:** LH-QA-01 (Performance), implizit ADR-0003 (Index-Format)

**Autor:** Kurs-Lab. **Datum:** 2026-06-03.

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
| Äquivalente Pfade in python/kotlin/java/csharp/cpp | neu | Pro Sprach-Skelett |

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

<!-- Bei der Closure füllen — vor dem `git mv` nach `done/`, nicht danach. -->

## 8. Sub-Area-Modus-Begründung

**Status:** alle berührten Sub-Areas GF (siehe
`harness/conventions.md` §Modus-Deklaration pro Sub-Area: `*` = GF
für das DocSearch-Lab als Ganzes). Spec-Anker LH-QA-01 führt
(Performance-Anforderung), flankiert von ADR-0004 (in Outline), Code folgt —
kein Reconciliation, keine BF/Hybrid-Begründung nötig.

**Vorgelagert — Sub-Area-Wahl prüfen:** Drei berührte Sub-Areas, alle über der
Schwelle: *Planning-Lifecycle*, *Implementierung* und
*Replay-/Eval-Infrastruktur*. Keine ist zu grob; insbesondere wurde
*Implementierung* **nicht** zu „Backend" zusammengezogen — Index- und
Service-Schicht teilen hier dieselbe Konvention und dieselbe Inventur-Linie
(`harness/conventions.md`), sind also eine Sub-Area, nicht zwei.

**Vorgelagert — offene Beobachtungen sichten:** Register
(`../observations.md`) durchgegangen. Berührt sind drei Sub-Areas aus der
Modus-Tabelle (`harness/conventions.md`): *Planning-Lifecycle* (ADR-0004, §3),
*Implementierung* (`internal/index/`, `internal/service/`, §3) und
*Replay-/Eval-Infrastruktur* (Replay gegen das Golden Set, recall@5, DoD).

*Test-Infrastruktur* ist **nicht** berührt, obwohl `make test-determinism` auch
unter ANN grün bleiben muss: Der Slice *hält* die Determinismus-Konvention ein,
er bewegt sie nicht — genau der Fall, den
[`konventionen.md` §Was ist eine Sub-Area?](../../../../../../kurs/de/grundlagen/konventionen.md#was-ist-eine-sub-area)
von der Berührung ausnimmt.

**Zwei offene Treffer**, beide auf *Replay-/Eval-Infrastruktur*: `BEO-001` (2×)
und `BEO-002` (1×) — der Zähler-Stand steht hier, weil dieser Slice keinen
Modus-Begründungsblock trägt: Alle berührten Sub-Areas sind GF, das Feld
*Evidenz-/Diskrepanz-Risiko* existiert in dieser Datei also gar nicht.
Dazu eine **verkörperte** Zeile auf *Implementierung*, `BEO-005`: Sie steht mit
Zähler und Belegen im Register, trägt aber den Vermerk, wohin sie ging, und
wirkt über `AGENTS.md` §2.7 von selbst — der Tie-Break dieses Slice fällt
darunter. Auf *Planning-Lifecycle* steht keine Zeile.

Keiner der beiden offenen erreicht **mit diesem Slice** 3×. `BEO-002` steht bei
1× und kann die Schwelle mit einem einzelnen Slice ohnehin nicht erreichen —
inhaltlich einschlägig ist es sehr wohl, die Gleichstands-Eingaben sind genau
die Tie-Break-Frage aus §6; der Zähler geht also auf 2×, wenn der Fall hier
wieder auftritt. `BEO-001` stünde bei 3×, wenn dieser Slice einen Golden-Set-Case ohne
Boundary-Anteil aufnähme; seine DoD sieht das nicht vor — sie *misst* gegen den
bestehenden Satz. Kein Folge-Slice also; die Frage ist bei der Closure erneut zu
stellen, weil der Zähler bis dahin weitergelaufen sein kann.

Voraussetzung-Wissen für den Block-Aufbau: Kurs
[Modul 5 §Worked Mini-Example](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#worked-mini-example-bootstrap-modus-pro-sub-area-für-einen-slice-begründen).
