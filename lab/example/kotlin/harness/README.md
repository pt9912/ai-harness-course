# Harness — DocSearch Kotlin-Skelett

| Target | Werkzeug |
|---|---|
| `make lint` | `detekt` (inkl. Suppression-Verbot) |
| `make typecheck` | Kotlin-Compiler |
| `make arch-check` | **Konsist** (in JUnit-Tests integriert) |
| `make test` | JUnit 5 |
| `make coverage-gate` | `kover` mit Schwelle |
| `make build` | Gradle Build + Distroless |

Übergeordnete Quelle: [`../../harness/README.md`](../../harness/README.md).

## Safety boundaries (Kotlin-spezifisch)

- Kein `reflect`-Tricks zur Umgehung von `internal`-Sichtbarkeit.
- Keine `lateinit var` für Domain-Modelle.
- Keine globalen `object`-Singletons für veränderlichen Zustand.
