# Welle welle-2-qualitaet: Qualitätsschwelle

**Lifecycle:** Diese Datei liegt **flach** unter `docs/plan/planning/`, solange
die Welle läuft; bei Closure wandert sie per `git mv` nach `done/`, neben ihre
`welle-2-results.md`. Der Zustand ist die Verzeichnis-Position, kein
Status-Feld. Dass sie die *aktuelle* Welle ist, sagt die Roadmap
([`in-progress/roadmap.md`](in-progress/roadmap.md) §Aktuelle Welle).

**Zielmeilenstein:** M2 — Qualitätsschwelle.

**Verantwortlich:** Kurs-Lab. **Datum:** 2026-06-03.

---

## 1. Welle-Ziel

Der Determinismus-Anspruch aus `LH-QA-02` ist nicht mehr nur behauptet, sondern
property-getestet — in allen sechs Sprachen —, und der Testbestand trägt die
nächste Coverage-Stufe. Die Schwelle selbst hebt diese Welle **nicht** an: das
tut die Nachfolge-ADR zu [ADR-0013](../adr/0013-coverage-schwellen.md), deren
Trigger die Closure dieser Welle ist.

## 2. Trigger (Welle startet)

- `welle-1-mvp` geschlossen (2026-06-02).
- Golden Set `evals/golden/welle-1-baseline/` existiert.

## 3. Closure-Trigger (Welle schließt)

- slice-013 (Property-Tests) in `done/`, in allen sechs Sprachen.
- `make fullbuild` grün.
- Replay gegen das Golden Set grün.
- Closure-Notiz in `welle-2-results.md`.

> *Lab-Grenze:* Das Kurs-Skelett kann den Replay nicht ausführen; es liefert
> nur die Fixture-Prüfung `make replay`. Der Trigger oben ist die Bedingung
> des *Projekts*, nicht die des Skeletts — siehe
> [`evals/golden/README.md`](../../../evals/golden/README.md), Absatz *Lab-Grenze*.

## 4. Slices in dieser Welle

| Slice | Titel | Bezug |
|---|---|---|
| slice-013 | Property-Tests für Tie-Break und Ranking | LH-QA-02 |

Der Zustand jedes Slice ist sein Lifecycle-Verzeichnis und wird hier **nicht**
gespiegelt.

**Ein-Slice-Bündel und trotzdem eine Welle:** Der Closure-Trigger fordert
`make fullbuild` und den Replay-Beleg — repo-weite Belege, die in keiner
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

<!-- Erst bei der Closure füllen — mit Pfaden vom Ruheort `done/` aus. -->

Ergebnis: <Zeiger auf `welle-2-results.md`, Geschwister im Ruheort `done/`>
Zähler: <Zeiger aufs Beobachtungs-Register, eine Ebene über dem Ruheort>
