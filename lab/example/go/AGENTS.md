# AGENTS.md — Go-spezifische Ergänzung

Dieser Anhang ergänzt [`../AGENTS.md`](../AGENTS.md) um Go-spezifische
Hard Rules. **Bei Konflikt gilt `../AGENTS.md`** (Source Precedence).

## Sprach-spezifische Hard Rules

### G-1 — Suppression-Verbot konkret

`//nolint`-Marker und `//nolint:<linter>` brechen das
`suppression-gate` (umgesetzt in `.golangci.yml` `issues.exclude-rules`).
Ausnahmen werden mit Begründung und ADR-/Slice-ID dort dokumentiert.

### G-2 — Layering via depguard

Die Architektur-Constraints aus ADR-0001 werden durch `depguard` in
`.golangci.yml` durchgesetzt. Verstöße brechen `make arch-check`.

| Verbotene Quelle | Darf NICHT importieren |
|---|---|
| `internal/ui` | `internal/index`, `internal/embedding`, `internal/audit` |
| `internal/service` | `internal/ui` |
| `internal/index` | `internal/service`, `internal/ui`, `internal/embedding` |
| `internal/embedding` | `internal/service`, `internal/ui`, `internal/index` |

### G-3 — Stable-Sort plus Tie-Break

Aus AGENTS.md §2.7 plus slice-009 (siehe
[`../docs/plan/planning/done/slice-009-tie-break-determinismus.md`](../docs/plan/planning/done/slice-009-tie-break-determinismus.md)):
**`sort.Slice` ist verboten**. Verwende `sort.SliceStable` mit
explizitem Tie-Break.

### G-4 — `errors.Is` / `errors.As` statt `==`

Fehler-Vergleich mit `==` ist anfällig gegen Wrapping. Pflicht:
`errors.Is(err, ErrXYZ)`.

## Pre-completion Checklist (Go)

Vor `go test ./...`-Erfolgsmeldung muss der Implementer prüfen:

- [ ] `go vet ./...` grün.
- [ ] `golangci-lint run` grün.
- [ ] `make arch-check` grün.
- [ ] `make coverage-gate` grün (oder Carveout dokumentiert).
- [ ] Spec-Bezug in Test-Namen (`TestSearch_LHFA02_HappyPath`).
