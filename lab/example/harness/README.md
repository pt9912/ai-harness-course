# Harness — DocSearch

## Purpose

Dieser Harness verbindet die bestehenden Spezifikationen, ADRs,
Planning-Dokumente und Gates des DocSearch-Beispiel-Repos. Er ist
**kein Ersatz** für `spec/` oder `docs/`, sondern ein **Einstiegspunkt**
für Menschen und AI-Code-Agenten.

Wenn diese Datei einer kanonischen Quelle widerspricht, gewinnt die
kanonische Quelle und diese Datei wird angepasst.

## Source precedence

| Rang | Datei | Charakter |
|---|---|---|
| 1 | [`../spec/lastenheft.md`](../spec/lastenheft.md) | vertraglich abnahmebindend |
| 2 | [`../spec/spezifikation.md`](../spec/spezifikation.md) | technisch fortschreibbar |
| 3 | [`../spec/architecture.md`](../spec/architecture.md) | Komponenten/Sequenzen, meilensteinfrei |
| 4 | [`../docs/plan/adr/`](../docs/plan/adr/) | Architekturentscheidungen |
| 5 | [`../docs/plan/planning/in-progress/roadmap.md`](../docs/plan/planning/in-progress/roadmap.md) | aktuelle Welle |
| 6 | (`../docs/user/`) | Operations, Quality, Releasing (entsteht in welle-4) |
| 7 | [`../README.md`](../README.md) | Projekt-Überblick |
| 8 | [`../AGENTS.md`](../AGENTS.md) | Agent-Briefing |
| 9 | diese Datei | Harness-Einstieg |

## Guides (Feedforward-Quellen)

| Quelle | Inhalt |
|---|---|
| [`../spec/lastenheft.md`](../spec/lastenheft.md) | LH-FA-* und LH-QA-* mit Akzeptanzkriterien |
| [`../spec/spezifikation.md`](../spec/spezifikation.md) | Algorithmen, Defaults (`MAX_TOPK`, `EMBEDDING_DIM`), Fehler-Codes |
| [`../spec/architecture.md`](../spec/architecture.md) | Schichten, Constraints, Sequenzen |
| [`../docs/plan/adr/`](../docs/plan/adr/) | 3 ADRs: Layering, Modellwahl, Index-Format |
| [`../docs/plan/planning/`](../docs/plan/planning/) | aktuelle Slices, Roadmap |
| [`../AGENTS.md`](../AGENTS.md) | Hard Rules, Workflow |

## Sensors (Feedback-Gates)

| Target | Charakter | Status |
|---|---|---|
| `make lint` | Linter + Suppression-Gate | grün |
| `make typecheck` | Statische Typprüfung | grün |
| `make arch-check` | Layering aus ADR-0001 | grün |
| `make test` | Unit-Tests | grün |
| `make test-determinism` | LH-QA-02 100 Iter. | grün |
| `make coverage-gate` | Gesamt-Coverage (bootstrap-aware) | grün, Schwelle 70 %, M2 → 80 % |
| `make coverage-gate-critical` | Critical-Path-Coverage | **bootstrap-aware mit CO-001** (Index-Layer ausgenommen bis Welle 2 done) |
| `make test-property` | Property-Based-Suite | **erst nach slice-013** (in-progress) |
| `make gates` | alle inneren Gates | grün |
| `make ci` | gates + Replay + Image-Scan | grün |
| `make fullbuild` | volle Closure | grün, letzter Hash `sha256:abc123…` |

**Nicht behauptet**, weil nicht vorhanden: `make sbom`, `make
security-scan` (geplant in welle-4-betrieb).

## Traceability rules

- PRs/Commits **müssen** mindestens eine `LH-*`- oder `ADR-*`-ID nennen (geprüft durch Pre-commit-Hook).
- Neue Anforderungen brauchen Beleg: Test (mit ID im Test-Namen), Gate, Demo, oder ADR.
- Neue ADRs müssen [`../docs/plan/adr/README.md`](../docs/plan/adr/README.md) aktualisieren.
- Lifecycle-Bewegung eines Slice ist reiner `git mv` (siehe AGENTS.md §2.3, §2.8).

## Safety and scope boundaries

DocSearch ist **kein produktives System**. Es ist ein Lehr-Beispiel.

- Keine personenbezogenen Klartext-Daten in Logs (siehe LH-QA-04, geprüft in `make lint`).
- Embedding-Adapter muss On-Prem-Fähigkeit haben (siehe ADR-0002, InfoSec-Constraint).
- Reindex ist nicht atomar gegenüber paralleler Search — `make test` deckt das ab, Multi-Worker-Setup ist out-of-scope (siehe Lastenheft §5).
- Tie-Break in sortierenden Operationen ist explizit (AGENTS.md §2.7).

## Minimal agent workflow

1. Diese Datei lesen.
2. Relevante kanonische Quelle lesen (Source Precedence beachten).
3. Betroffene IDs identifizieren.
4. Kleinste Änderung planen.
5. Engsten nützlichen Sensor laufen lassen.
6. Repo-weiten Gate-Lauf vor Handoff (`make gates`).
7. Doku/Indizes aktualisieren, falls ein öffentlicher Vertrag berührt.
8. Ausgeführte Sensors und verbleibende Risiken berichten — keine Erfolgsmeldung ohne Gate-Ausführung.
