# AGENTS.md — Python-spezifische Ergänzung

Ergänzt [`../AGENTS.md`](../AGENTS.md). Bei Konflikt gilt `../AGENTS.md`.

## Sprach-spezifische Hard Rules

### P-1 — `# noqa` ist verboten

`# noqa` und `# type: ignore` brechen das `noqa-gate` in `make gates`.
Ausnahmen leben in `pyproject.toml` `[tool.ruff.lint.per-file-ignores]`
oder `[tool.mypy.overrides]` mit Begründung und Slice-ID.

(Nach grid-gym-Vorbild.)

### P-2 — Layering via import-linter

Architektur-Constraints aus ADR-0001 werden durch `import-linter` mit
`importlinter.cfg` durchgesetzt. Verstöße brechen `make arch-check`.

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
- [ ] `lint-imports` (import-linter) grün.
- [ ] `make coverage-gate` grün.
- [ ] Test-Namen tragen LH-Bezug: `test_search_lhfa02_happy_path`.
