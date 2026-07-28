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

| Verzeichnis | Anzahl Slices |
|---|---|
| `open/` | 1 (slice-014-ann-suche) |
| `next/` | 0 |
| `in-progress/` | 1 (slice-013-property-tests) |
| `done/` | 13 (slice-001 bis slice-012, slice-020) |

Die `done/`-Slices sind im Beispiel nur exemplarisch vertreten — siehe
`done/`-Verzeichnis für die drei Vorbild-Closures (`slice-009`, `slice-020`,
`welle-1-results.md`; `welle-1-mvp.md` daneben ist der geschlossene
Welle-*Plan*, keine Closure-Notiz). `slice-020` ist das
Vorbild für einen **wellenlosen** Slice (Kurs Modul 6 §Wann Arbeit eine
Welle braucht).

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
  einziges Lifecycle-Verzeichnis. Ob eine flache Welle *aktuell* oder
  *geplant* ist, sagt die Roadmap.
- Der aktive Durchlauf nimmt ausschließlich **Slices** auf; `done/` archiviert
  **zusätzlich** abgeschlossene **Nicht-Slice-Records** — Welle-Plan und
  Welle-Closure.

Neben den Lifecycle-Verzeichnissen liegt **flach** in `planning/` das
[Beobachtungs-Register](observations.md): Es trägt den Steering-Loop-Zähler,
wird bei jeder Slice-Closure fortgeschrieben und überlebt jede Welle
(Kurs Modul 6 §Das Beobachtungs-Register).

## Roadmap

Siehe [`in-progress/roadmap.md`](in-progress/roadmap.md).
