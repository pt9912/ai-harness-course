# Harness — DocSearch Java-Skelett

| Target | Werkzeug |
|---|---|
| `make lint` | Checkstyle + Suppression-Verbot |
| `make typecheck` | `javac` |
| `make arch-check` | **ArchUnit** in JUnit |
| `make test` | JUnit 5 |
| `make coverage-gate` | JaCoCo mit Schwelle |
| `make build` | Maven + Distroless |

Übergeordnet: [`../../harness/README.md`](../../harness/README.md).

## Safety boundaries (Java-spezifisch)

- Kein `Reflection` zur Umgehung von `package-private`-Sichtbarkeit.
- Keine `static`-Singletons für mutable State.
- Keine `Unsafe`-API.
