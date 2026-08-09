# Harness — DocSearch C++-Skelett

Sprach-spezifischer Harness-Einstieg. Übergeordnete Quellen:
[`../../harness/README.md`](../../harness/README.md) (sprachneutral) und
[`../AGENTS.md`](../AGENTS.md) (C++-Hard-Rules).

## Source precedence

Wie in [`../../harness/README.md`](../../harness/README.md), erweitert
um C++-spezifische Pfade:

- `cpp/.clang-tidy` — Linter-Checks (WarningsAsErrors, Modul 13).
- `cpp/cmake/arch-check.sh` — Layering-Gate, Skript-Sensor ([ADR-0001](../../docs/plan/adr/0001-hexagonale-architektur.md)).
- `cpp/.a-check.yml` — Layering-Gate, deklarativer Sensor ([ADR-0001](../../docs/plan/adr/0001-hexagonale-architektur.md), Werkzeugwahl [ADR-0016](../../docs/plan/adr/0016-a-check-in-allen-skeletten.md)).
- `cpp/cmake/Dependencies.cmake` — Toolchain-Pin (doctest per `GIT_TAG`).

## Guides (C++-spezifisch)

| Quelle | Inhalt |
|---|---|
| [`../AGENTS.md`](../AGENTS.md) | C++-Hard-Rules (C-1 bis C-4) |
| `.clang-tidy` | Linter-Konfiguration, zentrale Ausnahmen |
| `src/hexagon/ports/embedder_port.h` | Adapter-Vertrag ([ADR-0002](../../docs/plan/adr/0002-modellwahl-embedding.md)) |

## Sensors (C++-spezifisch)

| Target | Werkzeug | Charakter |
|---|---|---|
| `make lint` | `clang-tidy` + `suppression-gate.sh` | Stil + Suppression-Gate |
| `make typecheck` | Compiler-Build `-Werror` | Statisch |
| `make arch-check` | beide Sensoren unten | [ADR-0001](../../docs/plan/adr/0001-hexagonale-architektur.md) Layering |
| `make a-check` | a-check-Container, `.a-check.yml` (netzlos, read-only) | [ADR-0001](../../docs/plan/adr/0001-hexagonale-architektur.md) Layering, deklariert — Werkzeugwahl [ADR-0016](../../docs/plan/adr/0016-a-check-in-allen-skeletten.md) |
| `make a-check-graph` | a-check `--print-graph` | Schichtbild aus derselben Deklaration, kein Gate |
| (in `arch-check`) | `cmake/arch-check.sh` (Include-Heuristik) | [ADR-0001](../../docs/plan/adr/0001-hexagonale-architektur.md) Layering, vier benannte Verzeichnispaare |
| `make test` | doctest via `ctest -R unit` | Unit + Tie-Break |
| `make test-determinism` | `ctest -R determinism` (100 Iterationen) | LH-QA-02 |
| `make coverage-gate` | `gcovr --fail-under-line` | [ADR-0013](../../docs/plan/adr/0013-coverage-schwellen.md): 70 %, ab M2 80 % |
| `make coverage-gate-critical` | wie oben, nur `hexagon/service/` | [ADR-0013](../../docs/plan/adr/0013-coverage-schwellen.md): 90 %, Index-Layer via CO-001 ausgenommen |
| `make build` | Multi-Stage Dockerfile | Distroless cc, nonroot |
| `make gates` | alle obigen | mandatory vor PR |

## Traceability

- Test-Namen tragen LH-/slice-IDs: `LH-FA-02 Boundary …`, `slice-009 TieBreak`.
- Make-Target-Kommentare nennen LH-IDs, **wo eine LH-Bindung besteht**:
  `test-determinism: configure ## LH-QA-02`. `coverage-gate` gehört zu keiner Lastenheft-Anforderung und zitiert
  deshalb die ADR, die seine Schwelle setzt (`ADR-0013`) — siehe [`../../harness/README.md` §Sensors](../../harness/README.md#sensors-feedback-gates).
- ADR-Verweise in Code-Kommentaren bei nicht-trivialen Entscheidungen.

## Safety boundaries (C++-spezifisch)

- Kein `reinterpret_cast`/`const_cast` außer in dokumentiertem Adapter (mit ADR).
- Kein roher `new`/`delete`-Besitz — Wertsemantik bzw. Smart Pointer.
- Keine globalen veränderlichen Zustände; der Kern bleibt framework-frei.
