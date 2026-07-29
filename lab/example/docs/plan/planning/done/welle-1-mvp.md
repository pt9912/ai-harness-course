# Welle welle-1-mvp: Lauffähiger DocSearch-Stack

**Lifecycle:** Diese Datei lag flach unter `docs/plan/planning/`, solange die
Welle lief, und ist bei Closure per `git mv` hierher nach `done/` gewandert —
neben ihre Ergebnis-Notiz. Der Zustand ist die Verzeichnis-Position, kein
Status-Feld.

**Zielmeilenstein:** M1 — Lauffähiger Stack.

**Verantwortlich:** Kurs-Lab. **Datum:** 2026-05-12.

---

## 1. Welle-Ziel

Ein lauffähiger DocSearch-Stack: Indexierung und Suche erfüllen ihre
Akzeptanzkriterien, `make gates` läuft in allen sechs Sprach-Skeletten grün, und
ein erstes Golden Set für den Replay existiert. Go führt als Referenz-Sprache —
die übrigen fünf Skelette ziehen dieselbe Logik nach; das ist Teil dieser Welle
(Meilenstein M1: ein Lab-Beispiel pro Sprache).

## 2. Trigger (Welle startet)

- Meilenstein M1 in der [Roadmap](../in-progress/roadmap.md) benannt und
  einer Welle zugeordnet.
- Kein Vorgänger — dies ist die erste Welle.

Bewusst *nicht* als Trigger geführt: Repo-Bootstrap und Gate-Baseline
(slice-001), Lastenheft v0.1.0 (slice-001) und die ADRs 0001/0002
(slice-001, slice-003). Sie entstehen *in* dieser Welle und wären damit
Ergebnisse, keine beobachtbaren Vorbedingungen — auch dann nicht, wenn sie
zeitlich am Anfang stehen.

## 3. Closure-Trigger (Welle schließt)

- Alle Slices dieser Welle in `done/`.
- `make fullbuild` grün.
- Replay gegen das Golden Set `evals/golden/welle-1-baseline/` grün.
- Closure-Notiz in `welle-1-results.md`.

> *Lab-Grenze:* Das Kurs-Skelett kann den Replay nicht ausführen; es liefert
> nur die Fixture-Prüfung `make replay`. Der Trigger oben ist die Bedingung
> des *Projekts*, nicht die des Skeletts — siehe
> [`evals/golden/README.md`](../../../../evals/golden/README.md), Absatz *Lab-Grenze*.

Das *Mehr* gegenüber den einzelnen DoDs: `make fullbuild` und der Replay-Beleg
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

## 7. Closure-Notiz

Ergebnis: [`welle-1-results.md`](welle-1-results.md).
Zähler: [`../observations.md`](../observations.md).
