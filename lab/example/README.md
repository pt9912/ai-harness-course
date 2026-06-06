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
- **Slices in jedem Lifecycle-Status**: einer in `open/`, einer in
  `in-progress/`, mehrere in `done/`.
- **Ein Carveout** für eine Bootstrap-Coverage.
- **Ein Replay-Beispiel** in `evals/golden/` für [Modul 11](../../kurs/de/04-qualitaet/modul-11-replay-evaluierung.md).
- **Ein fingiertes Review-Fixture** in `exercises/09-review-fixture/`
  für [Modul 9](../../kurs/de/04-qualitaet/modul-09-review-harness.md).
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
│   ├── adr/                     ADR-Index + 3 ADRs
│   ├── planning/                Slices in allen Lifecycle-Stadien
│   ├── carveouts/               1 aktiver Carveout
│   └── planning/in-progress/roadmap.md
├── exercises/
│   ├── 00-postmortem.md
│   ├── 02-lastenheft.md
│   ├── 03-adr.md
│   ├── 08-implementation.md
│   └── 09-review-fixture/       kaputter Slice für Review-Übung
├── verification/checks/         Verification-Fixture für Modul 10
├── evals/golden/                Replay-Eingang/Erwartung
├── evals/example-trace.json     Minimal-Trace für Modul 0
├── otel/                        Trace-Fixture für Modul 14
├── runbooks/                    Release/Incident-Fixtures für Modul 15
└── (Sprach-Skelette in Phase C: go/, python/, kotlin/, java/, csharp/)
```

## Sprach-Skelette

Fünf parallele Implementierungen derselben Spec, jede mit eigener
Toolchain:

| Sprache | Stack | Linter | Architekturtest | Vorbild |
|---|---|---|---|---|
| [Go](go/) | Go 1.23 | `golangci-lint` | `depguard` | u-boot, c-hsm-doc |
| [Python](python/) | Python 3.12 + uv | `ruff` (noqa-Gate) | `import-linter` | grid-gym |
| [Kotlin](kotlin/) | Kotlin/JVM 21 + Gradle KTS | `detekt` | **Konsist** | (neu) |
| [Java](java/) | Java 21 + Maven | Checkstyle | **ArchUnit** | (neu) |
| [C#](csharp/) | .NET 10 + CPM | `dotnet format` | **NetArchTest** | bess-ems |

Jedes Skelett implementiert:

- Hexagonales Layering (ADR-0001) — UI → Service → {Index, Embedding} → Types.
- Tie-Break-Logik aus slice-009 (deterministische Sortierung bei gleichem Score).
- LH-FA-02 Akzeptanzkriterien (Happy/Boundary/Negative) als Tests.
- LH-QA-02 Determinismus-Test (gleiche Eingabe → gleiches Ergebnis).
- `make gates` als einheitlicher Vertrag.

## Lerneffekt aus Sprach-Vergleich

| Konzept | Was unterscheidet sich? |
|---|---|
| Suppression-Verbot | `//nolint` vs. `# noqa` vs. `@Suppress` vs. `@SuppressWarnings` vs. `#pragma warning disable` — siehe [Modul 8](../../kurs/de/03-agenten/modul-08-implementierung.md) |
| Architekturtest | Konfig (depguard, import-linter) vs. Test-Framework (Konsist, ArchUnit, NetArchTest) |
| Lockfile | `go.sum`, `uv.lock`, `gradle.lockfile`, Maven (transitive), CPM `packages.lock.json` |
| Container | Distroless Static (Go), python-slim, Distroless Java, Distroless .NET |
| Tie-Break | `sort.SliceStable` vs. `sorted(key=…)` vs. `compareBy(…).thenBy(…)` vs. `Comparator.thenComparing` vs. LINQ `OrderBy().ThenBy()` |

## Lernweg

Pro Modul: Template aus `../templates/` kopieren → ausfüllen → mit der
entsprechenden Datei hier vergleichen. Lösung in
[`../../kurs/de/loesungen/`](../../kurs/de/loesungen/) lesen.
