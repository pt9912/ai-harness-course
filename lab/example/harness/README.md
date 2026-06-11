# Harness — DocSearch

## Purpose

Dieser Harness verbindet die bestehenden Spezifikationen, ADRs,
Planning-Dokumente und Gates des DocSearch-Beispiel-Repos. Er ist
**kein Ersatz** für `spec/` oder `docs/`, sondern ein **Einstiegspunkt**
für Menschen und AI-Code-Agenten.

Wenn diese Datei einer kanonischen Quelle widerspricht, gewinnt die
kanonische Quelle und diese Datei wird angepasst.

Strukturregeln (Verzeichniskonvention, ID-Schemata, Modus-Deklarationen
pro Sub-Area, Zusatzklassen für Sensors-Bindung) sowie Adaptionen ggü.
der adoptierten Baseline leben in [`conventions.md`](conventions.md).
Diese Datei dupliziert sie nicht.

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
| [`conventions.md`](conventions.md) | repo-lokale Strukturregeln, Adaptions-Block (`MR-*`), Modus-Deklarationen |
| [Agents-Digest des Kurses](../../../kurs/de/agents-digest.md) | adoptiertes Betriebsregelwerk in Agenten-Kurzform; derivativ, Stand siehe [`conventions.md`](conventions.md) §Baseline |

## Sensors (Feedback-Gates)

| Target | Vertrag | Bindung |
|---|---|---|
| `make lint` | Linter + Suppression-Gate | — |
| `make typecheck` | Statische Typprüfung | — |
| `make arch-check` | Layering | [ADR-0001](../docs/plan/adr/0001-hexagonale-architektur.md) |
| `make test` | Unit-Tests | — |
| `make test-determinism` | 100 Wiederholungen identischer Eingabe | LH-QA-02 |
| `make coverage-gate` | Gesamt-Coverage, bootstrap-aware | Schwelle 70 %, M2 → 80 % |
| `make coverage-gate-critical` | Critical-Path-Coverage | bootstrap via [`CO-001`](../docs/plan/carveouts/CO-001-index-coverage.md) bis Welle 2 done |
| `make gates` | alle inneren Gates | — |
| `make ci` | gates + Replay + Image-Scan | — |
| `make fullbuild` | volle Closure | Image-Hash `sha256:abc123…` (Modul 14) |

**Aktueller Lauf-Status:** CI-Badge bzw. lokal `make help` / `make gates` (keine Status-Spalte hier, siehe [Konventionen §`harness/README.md` als Einstiegspunkt](../../../kurs/de/grundlagen/konventionen.md#harnessreadmemd-als-einstiegspunkt)).
**Rote Gates:** Begründung im verlinkten `CO-<NNN>` (Bindung-Spalte), Modul 7.
**Nicht behauptet** (geplant, nicht in Makefile): `make test-property` (Property-Based-Suite, slice-013, in-progress), `make sbom`, `make security-scan` (welle-4-betrieb).

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
