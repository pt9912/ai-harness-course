# DocSearch — Go-Skelett

Go-Implementierung des DocSearch-Beispiels aus
[`../`](../README.md). Demonstriert die sprach-spezifische
Konkretion des Harness für Go:

| Konzept | Werkzeug |
|---|---|
| Linter | `golangci-lint` |
| Typecheck | Go-Compiler (`go vet`) |
| Architekturtest | `depguard` (in `.golangci.yml`) |
| Coverage | `go test -cover` |
| Build | `go build` in Multi-Stage Docker |
| Lockfile | `go.sum` |

## Quickstart

```bash
make build         # Image bauen
make gates         # alle Quality Gates (Lint, Typecheck, Arch, Test, Coverage)
make run           # Binary ausführen (--help)
```

## Struktur

```
go/
├── README.md
├── AGENTS.md                  Go-spezifische Ergänzung zu ../AGENTS.md
├── harness/README.md          Go-spezifische Sensors-Tabelle
├── Makefile                   gates · lint · typecheck · arch-check · test · coverage-gate · build
├── Dockerfile                 Multi-Stage, Distroless
├── .golangci.yml              Linter + depguard (Architekturtest)
├── go.mod
├── cmd/docsearch/main.go      Entry-Point (UI-Layer)
└── internal/
    ├── types/                 Domain-Modell, Pure
    ├── service/               Geschäftslogik
    ├── index/                 Vektor-Storage, Tie-Break
    ├── embedding/             Adapter-Interface + Mock
    └── ui/                    HTTP-Handler
```

Bezug zur Spec: alle `LH-*`-IDs aus
[`../spec/lastenheft.md`](../spec/lastenheft.md) sind in den
Make-Target-Kommentaren referenziert.
