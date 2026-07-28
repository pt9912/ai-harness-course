# Harness — DocSearch Python-Skelett

Sprach-spezifischer Einstieg. Übergeordnete Quelle:
[`../../harness/README.md`](../../harness/README.md).

## Sensors (Python-spezifisch)

| Target | Werkzeug | Charakter |
|---|---|---|
| `make lint` | `ruff check` (inkl. noqa-Gate) | Stil + Suppression-Verbot |
| `make typecheck` | `mypy --strict src/` | Statisch |
| `make arch-check` | `lint-imports` (import-linter) | ADR-0001 Layering |
| `make test` | `pytest` | Unit + Tie-Break |
| `make test-determinism` | `pytest -k determinism --count=100` (pytest-repeat) | LH-QA-02 |
| `make coverage-gate` | `pytest --cov` mit Schwelle | bootstrap-aware (70 %) |
| `make coverage-gate-critical` | wie oben, nur `docsearch/service` | mit CO-001 (Index-Layer), 80 % |
| `make build` | Multi-Stage Dockerfile | python-slim, nonroot |
| `make gates` | alle obigen | mandatory vor PR |

## Safety boundaries (Python-spezifisch)

- Kein `eval()` oder `exec()` in Production-Code.
- Keine `__import__`-Tricks zur Umgehung von Layering.
- Keine `globals()`-Mutation.
