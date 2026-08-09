# AGENTS.md — Go-spezifische Ergänzung

Dieser Anhang ergänzt [`../AGENTS.md`](../AGENTS.md) um Go-spezifische
Hard Rules. **Bei Konflikt gilt `../AGENTS.md`** (Source Precedence).

## Sprach-spezifische Hard Rules

### G-1 — Suppression-Verbot konkret

`//nolint`-Marker und `//nolint:<linter>` brechen das
`suppression-gate` (umgesetzt in `.golangci.yml` `issues.exclude-rules`).
Ausnahmen werden mit Begründung und ADR-/Slice-ID dort dokumentiert.

### G-2 — Layering via depguard und a-check

Die Architektur-Constraints aus ADR-0001 werden von **zwei** Sensoren
durchgesetzt, beide hinter `make arch-check`
([ADR-0015](../docs/plan/adr/0015-a-check-rollout-sprachskelette.md)):
`depguard` in `.golangci.yml` und die Deklaration in `.a-check.yml`.
Verstöße brechen `make arch-check`.

`depguard` führt **Deny-Listen** je Quell-Verzeichnis:

| Verbotene Quelle | Darf NICHT importieren |
|---|---|
| `internal/ui` | `internal/index`, `internal/embedding` |
| `internal/service` | `internal/ui` |
| `internal/index` | `internal/service`, `internal/ui`, `internal/embedding` |
| `internal/embedding` | `internal/service`, `internal/ui`, `internal/index` |

`.a-check.yml` führt umgekehrt eine **Allow-Liste**: Erlaubt ist, was als Kante
deklariert ist. Ein Paket, das in keiner `files`-Liste von depguard steht — ein
neues `internal/audit/` etwa —, ist dort ungeprüft; a-check meldet jeden seiner
Schicht-Importe, bis es eine Schicht und ihre Kanten bekommt. Wer eine Schicht
hinzufügt, ändert `.a-check.yml` **und** `.golangci.yml`, nicht diese Tabelle.

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
