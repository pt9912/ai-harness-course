# Harness — DocSearch C++-Skelett

Sprach-spezifischer Harness-Einstieg. Übergeordnete Quellen:
[`../../harness/README.md`](../../harness/README.md) (sprachneutral) und
[`../AGENTS.md`](../AGENTS.md) (C++-Hard-Rules).

## Source precedence

Wie in [`../../harness/README.md`](../../harness/README.md), erweitert
um C++-spezifische Pfade:

- `cpp/.clang-tidy` — Linter-Checks (WarningsAsErrors, Modul 13).
- `cpp/cmake/arch-check.sh` — Layering-Gate (ADR-0001).
- `cpp/cmake/Dependencies.cmake` — Toolchain-Pin (doctest per `GIT_TAG`).

## Guides (C++-spezifisch)

| Quelle | Inhalt |
|---|---|
| [`../AGENTS.md`](../AGENTS.md) | C++-Hard-Rules (C-1 bis C-4) |
| `.clang-tidy` | Linter-Konfiguration, zentrale Ausnahmen |
| `src/hexagon/ports/embedder_port.h` | Adapter-Vertrag (ADR-0002) |

## Sensors (C++-spezifisch)

| Target | Werkzeug | Charakter |
|---|---|---|
| `make lint` | `clang-tidy` + `suppression-gate.sh` | Stil + Suppression-Gate |
| `make typecheck` | Compiler-Build `-Werror` | Statisch |
| `make arch-check` | `cmake/arch-check.sh` (Include-Heuristik) | ADR-0001 Layering |
| `make test` | doctest via `ctest -R unit` | Unit + Tie-Break |
| `make test-determinism` | `ctest -R determinism` (100 Iterationen) | LH-QA-02 |
| `make coverage-gate` | `gcovr --fail-under-line` | bootstrap-aware (70 %) |
| `make coverage-gate-critical` | wie oben, nur `hexagon/service/` | mit CO-001 (Index-Layer) |
| `make build` | Multi-Stage Dockerfile | Distroless cc, nonroot |
| `make gates` | alle obigen | mandatory vor PR |

## Traceability

- Test-Namen tragen LH-/slice-IDs: `LH-FA-02 Boundary …`, `slice-009 TieBreak`.
- Make-Target-Kommentare nennen LH-IDs: `coverage-gate: ## LH-QA-Coverage`.
- ADR-Verweise in Code-Kommentaren bei nicht-trivialen Entscheidungen.

## Safety boundaries (C++-spezifisch)

- Kein `reinterpret_cast`/`const_cast` außer in dokumentiertem Adapter (mit ADR).
- Kein roher `new`/`delete`-Besitz — Wertsemantik bzw. Smart Pointer.
- Keine globalen veränderlichen Zustände; der Kern bleibt framework-frei.
