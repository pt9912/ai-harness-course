# Planning — <Projektname>

> **Template-Hinweis.** Vorlage für `docs/plan/planning/README.md`. Kopiere
> nach `docs/plan/planning/README.md`, ersetze `<Platzhalter>` und lösche
> diesen Block. **Derivativ:** dokumentiert die Konvention; Quelle der
> Wahrheit sind die Dateien in den Verzeichnissen selbst.

Slice-Lifecycle: `open/` → `next/` → `in-progress/` → `done/`.

Reine `git mv`-Commits beim Wechsel zwischen Verzeichnissen — siehe Hard
Rule „git mv + Inhaltsänderung = zwei Commits" in
[`../../../AGENTS.md`](../../../AGENTS.md).

## Lifecycle-Bedeutungen

| Verzeichnis | Bedeutung |
|---|---|
| `open/` | Geplant, noch nicht priorisiert. Keine Garantie auf Umsetzung. |
| `next/` | Als Nächstes priorisiert. Verantwortlicher zugeordnet. |
| `in-progress/` | Branch / PR existiert. |
| `done/` | DoD erfüllt, gemerged, Closure-Notiz vorhanden. |

## Slices vs. Wellen — zwei Ablagen, dieselbe Regel

- **Slices** tragen ihren Zustand über das **Verzeichnis**
  (`open/` → `next/` → `in-progress/` → `done/`).
- Eine **Welle** (Bündel von Slices) ebenso: Der Zustand ist die
  Verzeichnis-Position, kein `Status:`-Feld. Der Welle-Plan (`<welle-id>.md`)
  liegt **flach** in `planning/`, solange die Welle läuft, und wandert bei
  Closure per `git mv` nach `done/` — neben seine
  `welle-<NN>-results.md`. Die Lifecycle-Verzeichnisse durchläuft er nicht.
  Sequenzierungs-Autorität bleibt die Roadmap
  ([`in-progress/roadmap.md`](in-progress/roadmap.md): Meilensteine, Wellen,
  aktive Welle).
- Der aktive Durchlauf `open/` → `next/` → `in-progress/` nimmt ausschließlich
  **Slices** auf; `done/` archiviert **zusätzlich** abgeschlossene
  **Nicht-Slice-Records** — Welle-Plan und Welle-Closure
  `done/welle-<NN>-results.md`, und aufgelöste Carveouts wandern ebenfalls
  dorthin (Baseline-Regelwerk `modul-07-carveouts.md`).

Neben den Lifecycle-Verzeichnissen liegt **flach** in `planning/` das
**Beobachtungs-Register** (`observations.md`): Es trägt den
Steering-Loop-Zähler, wird bei jeder Slice-Closure fortgeschrieben und
überlebt jede Welle (Baseline-Regelwerk `modul-06-roadmap.md`
§Das Beobachtungs-Register).

## Aktueller Stand

Nicht als Snapshot hier eintragen — der Stand ergibt sich aus den
`open/`/`next/`/`in-progress/`/`done/`-Verzeichnissen (optional ein
`plan-status`-Target wie im Kurs-`lab/example`), sonst driftet die Tabelle.

## Roadmap

Siehe [`in-progress/roadmap.md`](in-progress/roadmap.md).
