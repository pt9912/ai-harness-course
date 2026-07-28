# Welle welle-1-mvp: Lauffähiger DocSearch-Stack

**Lifecycle:** Diese Datei lag flach unter `docs/plan/planning/`, solange die
Welle lief, und ist bei Closure per `git mv` hierher nach `done/` gewandert —
neben ihre Ergebnis-Notiz. Der Zustand ist die Verzeichnis-Position, kein
Status-Feld.

**Zielmeilenstein:** M1 — Lauffähiger Stack.

**Verantwortlich:** Kurs-Lab. **Datum:** 2026-05-12.

---

## 1. Welle-Ziel

Ein lauffähiger DocSearch-Stack in Go als Referenz-Sprache: Indexierung und
Suche erfüllen ihre Akzeptanzkriterien, `make gates` läuft repo-weit grün, und
ein erster Replay-Lauf gegen ein Golden Set existiert.

## 2. Trigger (Welle startet)

- Lastenheft v0.1.0 abgenommen (`LH-FA-01`, `LH-FA-02`, `LH-QA-02`).
- ADR-0001 (Adapter-Pattern) und ADR-0002 (Embedding-Modellwahl) accepted.

## 3. Closure-Trigger (Welle schließt)

- Alle Slices dieser Welle in `done/`.
- `make fullbuild` grün.
- Replay-Lauf gegen das Golden Set `evals/golden/welle-1-baseline/` durchläuft.
- Closure-Notiz in `welle-1-results.md`.

Das *Mehr* gegenüber den einzelnen DoDs: `make fullbuild` und der Replay-Lauf
sind repo-weite Bedingungen und stehen in keiner einzelnen Slice-DoD — deshalb
liegt hier eine Welle vor und nicht wellenlose Arbeit
(Kurs [Modul 6 §Wann Arbeit eine Welle braucht](../../../../../../kurs/de/02-planung/modul-06-roadmap.md#wann-arbeit-eine-welle-braucht--und-wann-nicht)).

## 4. Slices in dieser Welle

| Slice | Titel | Bezug |
|---|---|---|
| slice-001 | Repo-Bootstrap, Gate-Baseline | LH-QA-02 |
| slice-002 | Dokument-Parser und Chunking | LH-FA-01 |
| slice-003 | Embedding-Adapter (ADR-0002) | LH-FA-01 |
| slice-004 | Index-Persistenz | LH-FA-01 |
| slice-005 | Golden Set anlegen | LH-QA-02 |
| slice-006 | Index-Storage | LH-FA-01 |
| slice-007 | Top-K-Boundary nachziehen (Lastenheft v0.2.0) | LH-FA-02 |
| slice-008 | Spec-Stratum-Pflege | LH-QA-02 |
| slice-009 | Tie-Break-Determinismus | LH-QA-02 |
| slice-010 | Replay-Harness | LH-QA-02 |
| slice-011 | Golden-Set-Erweiterung | LH-QA-02 |
| slice-012 | Such-Endpoint | LH-FA-02 |

Der Zustand jedes Slice ist sein Lifecycle-Verzeichnis und wird hier **nicht**
gespiegelt — eine Status-Spalte driftete gegen die Verzeichnisse.

## 5. Abhängigkeiten

- Blockiert: `welle-2-qualitaet` (die Property-Tests brauchen den Stack).
- Wird blockiert von: keiner Welle.

## 6. Out-of-Scope für diese Welle

- ANN-Suche (→ `welle-3-skalierung`).
- Betrieb, Helm-Chart, OTel-Pipeline (→ `welle-4-betrieb`).
- Portierung auf Python/Kotlin/Java/C# (Folge-Wellen).

## 7. Closure-Notiz

Ergebnis: [`welle-1-results.md`](welle-1-results.md).
Zähler: [`../observations.md`](../observations.md).
