# Welle welle-2-qualitaet: Qualitätsschwelle

**Lifecycle:** Diese Datei liegt **flach** unter `docs/plan/planning/`, solange
die Welle läuft; bei Closure wandert sie per `git mv` nach `done/`, neben ihre
`welle-2-results.md`. Der Zustand ist die Verzeichnis-Position, kein
Status-Feld. Dass sie die *aktuelle* Welle ist, sagt die Roadmap
([`in-progress/roadmap.md`](in-progress/roadmap.md) §Aktuelle Welle).

**Zielmeilenstein:** M2 — Qualitätsschwelle.

**Verantwortlich:** Kurs-Lab. **Datum:** 2026-05-29.

---

## 1. Welle-Ziel

Der Determinismus-Anspruch aus `LH-QA-02` ist nicht mehr nur behauptet, sondern
property-getestet — in allen sechs Sprachen —, und das Coverage-Gate steht eine
Bootstrap-Stufe höher.

## 2. Trigger (Welle startet)

- `welle-1-mvp` geschlossen (2026-05-28).
- Golden Set `evals/golden/welle-1-baseline/` existiert.

## 3. Closure-Trigger (Welle schließt)

- slice-013 (Property-Tests) in `done/`, in allen sechs Sprachen.
- `make fullbuild` grün.
- Replay-Lauf gegen das Golden Set grün.
- Closure-Notiz in `welle-2-results.md`.

## 4. Slices in dieser Welle

| Slice | Titel | Bezug |
|---|---|---|
| slice-013 | Property-Tests für Tie-Break und Ranking | LH-QA-02 |

Der Zustand jedes Slice ist sein Lifecycle-Verzeichnis und wird hier **nicht**
gespiegelt.

**Ein-Slice-Bündel und trotzdem eine Welle:** Der Closure-Trigger fordert
`make fullbuild` und den Replay-Lauf — repo-weite Belege, die in keiner
Slice-DoD stehen. Genau dieses *Mehr* macht die Welle, nicht die Anzahl der
Slices (Kurs [Modul 6 §Wann Arbeit eine Welle braucht](../../../../../kurs/de/02-planung/modul-06-roadmap.md#wann-arbeit-eine-welle-braucht--und-wann-nicht)).

## 5. Abhängigkeiten

- Blockiert: `welle-3-skalierung` (ANN ohne Property-Tests wäre ungeprüfte Basis).
- Wird blockiert von: keiner offenen Welle.

## 6. Out-of-Scope für diese Welle

- ANN-Suche und Multi-Sprach-Adapter-Cleanup (→ `welle-3-skalierung`).
- Alles, was `LH-FA-*` erweitert — diese Welle härtet, sie liefert keine
  neue Fähigkeit.

## 7. Closure-Notiz

<!-- Erst nach Welle-Abschluss füllen: Zeiger auf `welle-2-results.md` und aufs
Beobachtungs-Register — mit Pfaden vom Ruheort `done/` aus. -->
