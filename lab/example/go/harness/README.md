# Harness — DocSearch Go-Skelett

Sprach-spezifischer Harness-Einstieg. Übergeordnete Quellen:
[`../../harness/README.md`](../../harness/README.md) (sprachneutral) und
[`../AGENTS.md`](../AGENTS.md) (Go-Hard-Rules).

## Source precedence

Wie in [`../../harness/README.md`](../../harness/README.md), erweitert
um Go-spezifische Pfade:

- `go/.golangci.yml` — Linter + depguard (Architekturtest, ADR-0001).
- `go/go.mod`, `go/go.sum` — Toolchain-Pin und Lockfile.

## Guides (Go-spezifisch)

| Quelle | Inhalt |
|---|---|
| [`../AGENTS.md`](../AGENTS.md) | Go-Hard-Rules (G-1 bis G-4) |
| `.golangci.yml` | Linter-Konfiguration, depguard-Regeln |
| `internal/embedding/embedder.go` | Adapter-Vertrag (ADR-0002) |

## Sensors (Go-spezifisch)

| Target | Werkzeug | Charakter |
|---|---|---|
| `make lint` | `golangci-lint` | Stil + Suppression-Gate |
| `make typecheck` | `go vet` + Build | Statisch |
| `make arch-check` | depguard (Teil von `golangci-lint`) | ADR-0001 Layering |
| `make test` | `go test ./...` | Unit + Tie-Break |
| `make test-determinism` | `go test -run TestDeterminism -count=100` | LH-QA-02 |
| `make coverage-gate` | `go test -coverprofile` + Schwelle-Check | bootstrap-aware (70 %) |
| `make coverage-gate-critical` | wie oben, nur Critical-Paths | mit CO-001 (Index-Layer) |
| `make build` | Multi-Stage Dockerfile | Distroless, nonroot |
| `make gates` | alle obigen | mandatory vor PR |

## Traceability

- Test-Namen tragen LH-IDs: `TestSearch_LHFA02_Boundary_KClamped`.
- Make-Target-Kommentare nennen LH-IDs: `coverage-gate: ## LH-QA-Coverage`.
- ADR-Verweise in Code-Kommentaren bei nicht-trivialen Entscheidungen.

## Safety boundaries (Go-spezifisch)

- Kein `unsafe`-Paket außer in dokumentiertem Adapter (mit ADR).
- Keine `init()`-Funktionen mit Seiteneffekten (Tooling-Reset im Test).
- Keine globalen Variablen für veränderlichen Zustand.
