# Example — DocSearch

Ein **fiktiver, aber realistischer** KI-Mini-Service als Beispiel-Repo
zum Kurs. Genug Komplexität, um die Konzepte des Kurses am konkreten
Artefakt zu erleben — bewusst kein produktiver Code.

## Was DocSearch tut

DocSearch indexiert eine Sammlung von Markdown-Dokumenten und stellt
eine semantische Suche bereit. Eine Anfrage liefert die k relevantesten
Dokument-Abschnitte. Die Embedding-Erzeugung läuft über ein LLM.

## Warum dieses Beispiel?

- **Mehrere Schichten** (Index, Suche, Embedding-Adapter, API) — genug
  für Layering-ADRs und Architekturtests.
- **Realistische ADRs**: Modellwahl für Embeddings, Vektor-Datenbank,
  hexagonale Architektur.
- **Slices in jedem Lifecycle-Status** — welche gerade wo liegen, sagt
  `make plan-status`, nicht diese Datei
  ([`docs/plan/planning/README.md` §Aktueller Stand](docs/plan/planning/README.md#aktueller-stand):
  eine Tabelle daneben driftet, sobald ein `git mv` sie nicht mitnimmt).
- **Ein Carveout** für eine Bootstrap-Coverage.
- **Ein Replay-Beispiel** in `evals/golden/` für [Modul 12](../../kurs/de/04-qualitaet/modul-12-replay-evaluierung.md).
- **Ein fingiertes Review-Fixture** in `exercises/09-review-fixture/`
  für [Modul 10](../../kurs/de/04-qualitaet/modul-10-review-harness.md).
- **Geführte Fixtures** für Verifikation, Trace-Analyse und Runbook-Arbeit
  in `verification/`, `otel/` und `runbooks/`.

## Struktur

```
example/
├── README.md                    (diese Datei)
├── Makefile                     Root-Harness-Targets für Kursmodule
├── AGENTS.md                    Hard Rules und Source Precedence
├── harness/README.md            Harness-Einstieg
├── harness/conventions.md       repo-lokale Strukturregeln (MR-NNN, Modus-Deklaration)
├── docs/glossar.md              Mini-Glossar für Modul 0
├── spec/
│   ├── lastenheft.md            LH-*-IDs, Akzeptanzkriterien
│   ├── spezifikation.md         Algorithmen, Defaults, Codes
│   └── architecture.md          Schichten, Sequenzen
├── docs/plan/
│   ├── adr/                     ADR-Index + ADRs
│   ├── planning/                Slices in allen Lifecycle-Stadien
│   ├── carveouts/               1 aktiver Carveout
│   └── planning/in-progress/roadmap.md
├── exercises/
│   ├── 00-postmortem.md
│   ├── 02-lastenheft.md
│   ├── 03-adr.md
│   ├── 08-implementation.md
│   └── 09-review-fixture/       kaputter Slice für Review-Übung
├── verification/checks/         Verification-Fixture für Modul 11
├── evals/golden/                Replay-Eingang/Erwartung
├── evals/example-trace.json     Minimal-Trace für Modul 0
├── otel/                        Trace-Fixture für Modul 15
├── runbooks/                    Release/Incident-Fixtures für Modul 16
└── go/, python/, kotlin/, java/, csharp/, cpp/   (sechs Sprach-Skelette)
```

## Sprach-Skelette

Sechs parallele Implementierungen derselben Spec, jede mit eigener
Toolchain:

| Sprache | Stack | Linter | Architekturtest | Vorbild |
|---|---|---|---|---|
| [Go](go/) | Go 1.23 | `golangci-lint` | `depguard` + a-check | u-boot, c-hsm-doc |
| [Python](python/) | Python 3.12 + uv | `ruff` (noqa-Gate) | `import-linter` + a-check | grid-gym |
| [Kotlin](kotlin/) | Kotlin/JVM 21 + Gradle KTS | `detekt` | **Konsist** + a-check | (neu) |
| [Java](java/) | Java 21 + Maven | Checkstyle | **ArchUnit** + a-check | (neu) |
| [C#](csharp/) | .NET 10 + CPM | `dotnet format` | **NetArchTest** + a-check | bess-ems |
| [C++](cpp/) | C++20 + CMake | `clang-tidy` | `arch-check.sh` **+ a-check** (+ CTest) | cmake-xray, b-cad |

Jedes Skelett implementiert:

- Hexagonales Layering ([ADR-0001](docs/plan/adr/0001-hexagonale-architektur.md)) — UI → Service → {Index, Embedding} → Types.
- Tie-Break-Logik aus slice-009 (deterministische Sortierung bei gleichem Score).
- [LH-FA-01](spec/lastenheft.md#lh-fa-01--dokument-indexierung) und [LH-FA-02](spec/lastenheft.md#lh-fa-02--semantische-suche) Akzeptanzkriterien (Happy/Boundary/Negative) als Tests.
- Die vier Fehler-Codes aus [spec §4](spec/spezifikation.md#4-fehler-codes-und-logging-felder)
  (E001, E002, E003, E099) mit HTTP-Status an einer Stelle abgebildet.
- [LH-QA-02](spec/lastenheft.md#lh-qa-02--reproduzierbarkeit) Determinismus-Test (gleiche Eingabe → gleiches Ergebnis).
- `make gates` als einheitlicher Vertrag.

Nicht im Skelett: die Index-Persistenz aus
[spec §1 LH-FA-IDX-003.a](spec/spezifikation.md#lh-fa-idx-003a--index-schreiben)
([ADR-0003](docs/plan/adr/0003-index-storage-format.md), [ADR-0012](docs/plan/adr/0012-index-write-strategy.md)) und die Abschnitts-Zerlegung an `##`-Headings. Der Index
lebt im Speicher, `reindex` zählt Dateien statt Abschnitte und antwortet
deshalb nur mit `indexed_docs`, nicht mit `indexed_sections`. Die Skelette
zeigen Schichtung, Gates und Traceability — nicht das fertige Produkt.

## Lerneffekt aus Sprach-Vergleich

| Konzept | Was unterscheidet sich? |
|---|---|
| Suppression-Verbot | `//nolint` vs. `# noqa` vs. `@Suppress` vs. `@SuppressWarnings` vs. `#pragma warning disable` vs. C++ `// NOLINT` / `#pragma GCC diagnostic` — siehe [Modul 9](../../kurs/de/03-agenten/modul-09-implementierung.md) |
| Architekturtest | Konfig (depguard, import-linter) vs. Test-Framework (Konsist, ArchUnit, NetArchTest) vs. Skript (C++ `arch-check.sh`) — und in **jedem** Skelett derselbe deklarative Zweitsensor daneben ([ADR-0017](docs/plan/adr/0017-kotlin-luecke-am-bestandssensor-geschlossen.md)). Der Vergleich zeigt damit auch, was die Bauform einer Regel ausmacht: Konsist prüft `file.imports`, ArchUnit den Bytecode — dieselbe Umgehung, verschiedene Sichtbarkeit |
| Lockfile | `go.sum`, `uv.lock`, `gradle.lockfile`, Maven (transitive), CPM `packages.lock.json`, FetchContent-`GIT_TAG` (C++) |
| Container | Distroless Static (Go), python-slim, Distroless Java, Distroless .NET, Distroless cc (C++) |
| Tie-Break | `sort.SliceStable` vs. `sorted(key=…)` vs. `compareBy(…).thenBy(…)` vs. `Comparator.thenComparing` vs. LINQ `OrderBy().ThenBy()` vs. `std::stable_sort` (C++) |

## Lernweg

Pro Modul: Template aus `../templates/` kopieren → ausfüllen → mit der
entsprechenden Datei hier vergleichen. Lösung in
[`../../kurs/de/loesungen/`](../../kurs/de/loesungen/) lesen.
