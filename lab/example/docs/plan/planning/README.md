# Planning — DocSearch

Slice-Lifecycle: `open/` → `next/` → `in-progress/` → `done/`.

Reine `git mv`-Commits beim Wechsel zwischen Verzeichnissen — siehe
Hard Rule "git mv + Inhaltsänderung = zwei Commits" in
[`../../../AGENTS.md`](../../../AGENTS.md).

## Lifecycle-Bedeutungen

| Verzeichnis | Bedeutung |
|---|---|
| `open/` | Geplant, noch nicht priorisiert. Keine Garantie auf Umsetzung. |
| `next/` | Als Nächstes priorisiert. Verantwortlicher zugeordnet. |
| `in-progress/` | Branch / PR existiert. |
| `done/` | DoD erfüllt, gemerged, Closure-Notiz vorhanden. |

## Aktueller Stand

Nicht als Snapshot hier eintragen — der Stand ergibt sich aus den
Verzeichnissen: `make plan-status`. Eine Tabelle daneben wäre eine zweite
Quelle für denselben Zustand und driftet, sobald ein `git mv` sie nicht
mitnimmt.

Die `done/`-Slices sind im Beispiel nur exemplarisch vertreten; welche, sagt
`make plan-status`. Jede Datei dort trägt eine Closure-Sektion — Slice-Plan wie
Welle-Plan wie Closure-Notiz —, das verlangt [ADR-0011](../adr/0011-closure-note-pflicht.md), und
`make doc-check` prüft es (`planning.closure`, Schwelle und Kandidaten-Menge aus
der ADR — [ADR-0019](../adr/0019-closure-sensor-und-skript-rolle.md)). `slice-020` ist das Vorbild
für einen Slice **ohne Wellen-Zugehörigkeit** in einem Repo, das Wellen
schneidet (Kurs Modul 6 §Wann Arbeit eine Welle braucht). *Wellenlos* ist
dieses Repo nicht — das wäre der Repo-Modus, und der lautet hier: mit Wellen.

## Slices vs. Wellen — zwei Ablagen, dieselbe Regel

- **Slices** tragen ihren Zustand über das **Verzeichnis**
  (`open/` → `next/` → `in-progress/` → `done/`).
- Eine **Welle** ebenso: Der Welle-Plan (`<welle-id>.md`) liegt **flach** in
  `planning/`, solange die Welle läuft — hier
  [`welle-2-qualitaet.md`](welle-2-qualitaet.md) —, und wandert bei Closure
  per `git mv` nach `done/`, neben seine `welle-<NN>-results.md`:
  [`done/welle-1-mvp.md`](done/welle-1-mvp.md) neben
  [`done/welle-1-results.md`](done/welle-1-results.md). Den aktiven Durchlauf
  `open/` → `next/` → `in-progress/` durchläuft er nicht; `done/` ist sein
  einziges Lifecycle-Verzeichnis. **Geplante Wellen bekommen noch keine
  Datei** — sie stehen in der Roadmap unter *Nächste Wellen* und nirgends
  sonst. Eine flache Datei bedeutet damit immer *läuft*: zwei Positionen,
  nicht drei.
- Der aktive Durchlauf nimmt ausschließlich **Slices** auf; `done/` archiviert
  **zusätzlich** abgeschlossene **Nicht-Slice-Records** — Welle-Plan und
  Welle-Closure.

Neben den Lifecycle-Verzeichnissen liegt **flach** in `planning/` das
[Beobachtungs-Register](observations.md): Es trägt den Steering-Loop-Zähler,
wird bei jeder Slice-Closure fortgeschrieben und überlebt jede Welle
(Kurs Modul 6 §Das Beobachtungs-Register).

## Roadmap

Siehe [`in-progress/roadmap.md`](in-progress/roadmap.md).
