# Harness — DocSearch C#-Skelett

| Target | Werkzeug | Bindung |
|---|---|---|
| `make lint` | `dotnet format` + `solid-suppression-gate` (Custom) | — |
| `make typecheck` | `dotnet build -warnaserror` | — |
| `make arch-check` | beide Sensoren unten | ADR-0001 Layering |
| `make a-check` | a-check-Container, `.a-check.yml` (netzlos, read-only) | ADR-0001 Layering, deklariert — Werkzeugwahl [ADR-0015](../../docs/plan/adr/0015-a-check-rollout-sprachskelette.md) |
| `make a-check-graph` | a-check `--print-graph` | Schichtbild aus derselben Deklaration, kein Gate |
| (in `arch-check`) | **NetArchTest** (in xUnit-Tests) | ADR-0001 Layering, vier Namespace-Paare |
| `make test` | `dotnet test` (xUnit) | — |
| `make coverage-gate` | `coverlet` + Schwelle | ADR-0013 |
| `make build` | `dotnet publish` + Distroless | — |

Die beiden Layering-Sensoren sehen Verschiedenes: a-check liest
`using`-Direktiven im Quelltext, NetArchTest die kompilierte Assembly. Ein voll
qualifizierter Typzugriff ohne `using` ist nur für NetArchTest sichtbar; die
`Types`-Schicht hat dort umgekehrt gar keine Regel und wird nur von a-check
geprüft.

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
