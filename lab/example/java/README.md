# DocSearch — Java-Skelett

| Konzept | Werkzeug |
|---|---|
| Linter | Checkstyle |
| Typecheck | `javac` |
| Architekturtest | **ArchUnit** |
| Coverage | JaCoCo |
| Build | Maven |
| Lockfile | (transitive lock via `mvn dependency:tree`) |

## Quickstart

```bash
make build
make gates
```

## Struktur

```
java/
├── README.md · AGENTS.md · harness/README.md
├── Makefile · Dockerfile
├── pom.xml                    Maven
├── checkstyle.xml             Linter-Regeln
└── src/{main,test}/java/com/example/docsearch/
```
