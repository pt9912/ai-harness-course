# Harness — DocSearch C#-Skelett

| Target | Werkzeug |
|---|---|
| `make lint` | `dotnet format` + `solid-suppression-gate` (Custom) |
| `make typecheck` | `dotnet build -warnaserror` |
| `make arch-check` | **NetArchTest** (in xUnit-Tests) |
| `make test` | `dotnet test` (xUnit) |
| `make coverage-gate` | `coverlet` + Schwelle |
| `make build` | `dotnet publish` + Distroless |

Übergeordnet: [`../../harness/README.md`](../../harness/README.md).

## Reproduzierbarkeit

- `global.json` pinnt das .NET SDK.
- `Directory.Packages.props` (CPM) pinnt alle Paket-Versionen.
- `packages.lock.json` (generiert) wird ins Repo eingecheckt.
- `RestoreLockedMode=true` in `Directory.Build.props` — Restore schlägt fehl bei Lock-Drift.

## Safety boundaries (C#-spezifisch)

- Kein `unsafe`-Code außer in dokumentiertem Adapter.
- Keine `reflection`-Tricks zur Umgehung von `internal`.
- Keine statischen Singletons für mutable State.
