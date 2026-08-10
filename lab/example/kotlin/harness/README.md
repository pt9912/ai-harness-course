# Harness — DocSearch Kotlin-Skelett

| Target | Werkzeug |
|---|---|
| `make lint` | `detekt` (inkl. Suppression-Verbot) |
| `make typecheck` | Kotlin-Compiler |
| `make arch-check` | beide Sensoren unten |
| `make a-check` | a-check-Container, `.a-check.yml` (netzlos, read-only) — Werkzeugwahl [ADR-0018](../../docs/plan/adr/0018-grenzen-gehoeren-in-die-konfiguration.md) |
| `make a-check-graph` | a-check `--print-graph`, Schichtbild aus derselben Deklaration |
| (in `arch-check`) | **Konsist** (in JUnit-Tests integriert), prüft den Quelltext — Import **und** voll qualifizierte Nennung |
| `make test` | JUnit 5 |
| `make coverage-gate` | `kover` mit Schwelle |
| `make coverage-gate-critical` | `kover`, nur `docsearch.service` (`-Pcritical`; [ADR-0013](../../docs/plan/adr/0013-coverage-schwellen.md): 90 %, Index via CO-001 ausgenommen) |
| `make build` | Gradle Build + Distroless |

Übergeordnete Quelle: [`../../harness/README.md`](../../harness/README.md).

## Safety boundaries (Kotlin-spezifisch)

- Kein `reflect`-Tricks zur Umgehung von `internal`-Sichtbarkeit.
- Keine `lateinit var` für Domain-Modelle.
- Keine globalen `object`-Singletons für veränderlichen Zustand.
