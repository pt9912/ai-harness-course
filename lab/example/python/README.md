# DocSearch — Python-Skelett

Python-Implementierung. Anlehnung an `pt9912/grid-gym` (Docker-only,
`noqa`-Verbot, uv-Toolchain).

| Konzept | Werkzeug |
|---|---|
| Linter | `ruff` (inkl. noqa-Gate) |
| Typecheck | `mypy --strict` |
| Architekturtest | `import-linter` |
| Coverage | `pytest --cov` |
| Build | `uv build` in Multi-Stage Docker |
| Lockfile | `uv.lock` |

## Quickstart

```bash
make build
make gates
```

## Struktur

```
python/
├── README.md · AGENTS.md · harness/README.md
├── Makefile · Dockerfile
├── pyproject.toml          ruff + mypy + import-linter Config
├── importlinter.cfg        Layering-Contracts (ADR-0001)
├── src/docsearch/          Quellcode mit hexagonalem Layout
└── tests/                  pytest mit LH-Bezug
```
