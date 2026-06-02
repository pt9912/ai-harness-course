# DocSearch — Kotlin-Skelett

Kotlin/JVM-Implementierung.

| Konzept | Werkzeug |
|---|---|
| Linter | `detekt` |
| Typecheck | Kotlin-Compiler |
| Architekturtest | **Konsist** (Kotlin-natives ArchUnit-Pendant) |
| Coverage | `kover` |
| Build | Gradle (KTS) |
| Lockfile | `gradle.lockfile` |

## Quickstart

```bash
make build
make gates
```

## Struktur

```
kotlin/
├── README.md · AGENTS.md · harness/README.md
├── Makefile · Dockerfile
├── build.gradle.kts · settings.gradle.kts
├── config/detekt.yml          Linter
└── src/
    ├── main/kotlin/com/example/docsearch/  Quellcode
    └── test/kotlin/com/example/docsearch/  Tests inkl. Konsist
```
