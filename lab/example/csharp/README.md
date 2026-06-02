# DocSearch — C#-Skelett (.NET 10)

Nach Vorbild `pt9912/bess-ems` (Central Package Management, `dotnet format`,
NetArchTest).

| Konzept | Werkzeug |
|---|---|
| Linter | `dotnet format`, Roslyn Analyzers, StyleCop |
| Typecheck | `dotnet build` |
| Architekturtest | **NetArchTest** |
| Coverage | `coverlet` + `reportgenerator` |
| Build | `dotnet build` / `dotnet publish` |
| Lockfile | `Directory.Packages.props` (Central Package Management) + `packages.lock.json` |

## Quickstart

```bash
make build
make gates
```

## Struktur

```
csharp/
├── README.md · AGENTS.md · harness/README.md
├── Makefile · Dockerfile
├── DocSearch.sln
├── Directory.Build.props        Lock-Mode + Analyzer-Settings
├── Directory.Packages.props     Central Package Management
├── global.json                  SDK-Pin
├── .editorconfig                StyleCop-Regeln + Suppression-Verbot
└── src/DocSearch/, tests/DocSearch.Tests/
```
