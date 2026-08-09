# Harness — DocSearch Java-Skelett

| Target | Werkzeug |
|---|---|
| `make lint` | Checkstyle + Suppression-Verbot |
| `make typecheck` | `javac` |
| `make arch-check` | beide Sensoren unten |
| `make a-check` | a-check-Container, `.a-check.yml` (netzlos, read-only) — Werkzeugwahl [ADR-0015](../../docs/plan/adr/0015-a-check-rollout-sprachskelette.md) |
| `make a-check-graph` | a-check `--print-graph`, Schichtbild aus derselben Deklaration |
| (in `arch-check`) | **ArchUnit** in JUnit, importiert Bytecode |
| `make test` | JUnit 5 |
| `make coverage-gate` | JaCoCo mit Schwelle |
| `make coverage-gate-critical` | JaCoCo, nur `docsearch/service/` (Profil `critical-coverage`; ADR-0013: 90 %, Index via CO-001 ausgenommen) |
| `make build` | Maven + Distroless |

Übergeordnet: [`../../harness/README.md`](../../harness/README.md).

## Safety boundaries (Java-spezifisch)

- Kein `Reflection` zur Umgehung von `package-private`-Sichtbarkeit.
- Keine `static`-Singletons für mutable State.
- Keine `Unsafe`-API.
