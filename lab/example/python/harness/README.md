# Harness — DocSearch Python-Skelett

Sprach-spezifischer Einstieg. Übergeordnete Quelle:
[`../../harness/README.md`](../../harness/README.md).

## Sensors (Python-spezifisch)

| Target | Werkzeug | Charakter |
|---|---|---|
| `make lint` | `ruff check` (inkl. noqa-Gate) | Stil + Suppression-Verbot |
| `make typecheck` | `mypy --strict src/` | Statisch |
| `make arch-check` | beide Sensoren unten | [ADR-0001](../../docs/plan/adr/0001-hexagonale-architektur.md) Layering |
| `make a-check` | a-check-Container, `.a-check.yml` (netzlos, read-only) | [ADR-0001](../../docs/plan/adr/0001-hexagonale-architektur.md) Layering, deklariert — Werkzeugwahl [ADR-0017](../../docs/plan/adr/0017-kotlin-luecke-am-bestandssensor-geschlossen.md) |
| `make a-check-graph` | a-check `--print-graph` | Schichtbild aus derselben Deklaration, kein Gate |
| (in `arch-check`) | `lint-imports` (import-linter) | [ADR-0001](../../docs/plan/adr/0001-hexagonale-architektur.md) Layering, aufgezählte Contracts; sieht jede Import-Schreibweise |
| `make test` | `pytest` | Unit + Tie-Break |
| `make test-determinism` | `pytest -k determinism --count=100` (pytest-repeat) | LH-QA-02 |
| `make coverage-gate` | `pytest --cov` mit Schwelle | [ADR-0013](../../docs/plan/adr/0013-coverage-schwellen.md): 70 %, M2 → 80 % |
| `make coverage-gate-critical` | wie oben, nur `docsearch/service` | [ADR-0013](../../docs/plan/adr/0013-coverage-schwellen.md): 90 %, Index-Layer via CO-001 ausgenommen |
| `make build` | Multi-Stage Dockerfile | python-slim, nonroot |
| `make gates` | alle obigen | mandatory vor PR |

## Safety boundaries (Python-spezifisch)

- Kein `eval()` oder `exec()` in Production-Code.
- Keine `__import__`-Tricks zur Umgehung von Layering.
- Keine `globals()`-Mutation.
