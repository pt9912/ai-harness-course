# AGENTS.md — Python-spezifische Ergänzung

Ergänzt [`../AGENTS.md`](../AGENTS.md). Bei Konflikt gilt `../AGENTS.md`.

## Sprach-spezifische Hard Rules

### P-1 — `# noqa` ist verboten

`# noqa` und `# type: ignore` brechen das `noqa-gate` in `make gates`.
Ausnahmen leben in `pyproject.toml` `[tool.ruff.lint.per-file-ignores]`
oder `[tool.mypy.overrides]` mit Begründung und Slice-ID.

(Nach grid-gym-Vorbild.)

### P-2 — Layering via import-linter und a-check

Architektur-Constraints aus [ADR-0001](../docs/plan/adr/0001-hexagonale-architektur.md) werden von **zwei** Sensoren durchgesetzt,
beide hinter `make arch-check`
([ADR-0017](../docs/plan/adr/0017-kotlin-luecke-am-bestandssensor-geschlossen.md)):
`import-linter` mit `importlinter.cfg` und die Deklaration in `.a-check.yml`.
Verstöße brechen `make arch-check`.

Sie sehen Verschiedenes, und hier deutlicher als in den anderen Skeletten.
`import-linter` löst den AST auf und sieht **jede** Import-Schreibweise;
a-check liest Text und sieht nur die **absolute** — blind ist es für
`from ..ui import x`, für `from docsearch import ui` (liefert nur `docsearch`)
und ab dem zweiten Modul einer Komma-Liste. Umgekehrt ist `.a-check.yml` eine
**Allow-Liste**: Ein neues Modul, das in keinem Contract aufgezählt ist, bleibt
bei `import-linter` ungeprüft und wird von a-check gemeldet.

Schreiben Sie kanten-relevante Importe deshalb absolut und einzeln.

### P-3 — Kein `.venv` im Repo, kein `pip install`

Toolchain läuft über `uv` im Docker-Image (siehe AGENTS.md §2.1). Lokales
`pip install ...` ist verboten — bricht Reproduzierbarkeit (LH-QA-03).

### P-4 — Sortier-Stabilität explizit

`sorted(..., key=..., reverse=True)` ist nicht stable für Tie-Break-
Kontrolle. Pflicht: explizite Tie-Break-Tupel `key=lambda x: (-score, doc_path, section_index)`.

### P-5 — `from __future__ import annotations`

In jeder Modul-Datei, um konsistente Typen ohne TYPE_CHECKING-Branches.

## Pre-completion Checklist (Python)

- [ ] `ruff check .` grün.
- [ ] `mypy --strict src/` grün.
- [ ] `make arch-check` grün (import-linter **und** a-check).
- [ ] `make coverage-gate` grün.
- [ ] Test-Namen tragen LH-Bezug: `test_search_lhfa02_happy_path`.
