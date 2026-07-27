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
`done/`-Verzeichnis für die drei Vorbild-Closures. `slice-020` ist das
Vorbild für einen **wellenlosen** Slice (Kurs Modul 6 §Wann Arbeit eine
Welle braucht).

## Roadmap

Siehe [`in-progress/roadmap.md`](in-progress/roadmap.md).
