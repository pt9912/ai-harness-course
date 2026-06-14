# DocSearch — C++-Skelett

C++-Implementierung des DocSearch-Beispiels aus
[`../`](../README.md). Demonstriert die sprach-spezifische
Konkretion des Harness für C++/CMake:

| Konzept | Werkzeug |
|---|---|
| Linter | `clang-tidy` (bugprone, clang-analyzer) + Suppression-Gate |
| Typecheck | Compiler-Build (`-Wall -Wextra -Werror`) |
| Architekturtest | `cmake/arch-check.sh` (textbasiert, als CTest registriert) |
| Coverage | `gcov` + `gcovr` (`--fail-under-line`) |
| Build | CMake + Multi-Stage Docker (Distroless `cc`) |
| Lockfile | FetchContent-`GIT_TAG`-Pins (`cmake/Dependencies.cmake`) |
| Test-Framework | doctest (header-only, per FetchContent gepinnt) |

## Quickstart

```bash
make build         # Runtime-Image bauen
make gates         # alle Quality Gates (Lint, Typecheck, Arch, Test, Coverage)
make run           # Binary ausführen (--help)
```

## Struktur

```
cpp/
├── README.md
├── AGENTS.md                  C++-spezifische Ergänzung zu ../AGENTS.md
├── harness/README.md          C++-spezifische Sensors-Tabelle
├── Makefile                   gates · lint · typecheck · arch-check · test · coverage-gate · build
├── Dockerfile                 Multi-Stage, Distroless cc, nonroot
├── .clang-tidy                Linter-Checks (WarningsAsErrors)
├── CMakeLists.txt             C++20, CTest, Coverage-Option
├── cmake/
│   ├── Dependencies.cmake     doctest via FetchContent (GIT_TAG-Pin)
│   ├── arch-check.sh          ADR-0001 Layering (Include-Heuristik)
│   └── suppression-gate.sh    Inline-Suppression-Verbot
├── src/
│   ├── main.cpp               Composition Root (Wiring, ADR-0001)
│   ├── hexagon/               Kern — ohne Adapter-/Framework-Includes
│   │   ├── model/types.h      Domain-Modell, pure
│   │   ├── ports/             Driven Ports (EmbedderPort, ADR-0002)
│   │   ├── index/             Vektor-Storage, Cosinus, Tie-Break
│   │   └── service/           Geschäftslogik (Searcher)
│   └── adapters/
│       ├── embedding/         MockEmbedder (implementiert EmbedderPort)
│       └── ui/                SearchHandler (HTTP-Fassade)
└── tests/search_test.cpp      LH-FA-02 + LH-QA-02 + slice-009 (doctest)
```

Bezug zur Spec: alle `LH-*`-IDs aus
[`../spec/lastenheft.md`](../spec/lastenheft.md) sind in den
Make-Target-Kommentaren und Test-Namen referenziert. Das Layering folgt
[ADR-0001](../docs/plan/adr/0001-hexagonale-architektur.md): Adapter zeigen
nach innen auf den Kern, nie umgekehrt — durchgesetzt von
`cmake/arch-check.sh`.
