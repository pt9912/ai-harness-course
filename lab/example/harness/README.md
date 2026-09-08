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
| 5 | [`../docs/plan/planning/in-progress/roadmap.md`](../docs/plan/planning/in-progress/roadmap.md) | Wellen-Sequenz |
| 6 | [`../docs/user/`](../docs/user/) | Operations, Quality, Releasing — *derzeit Platzhalter, Inhalte siehe `../runbooks/` und `AGENTS.md` §4* |
| 7 | [`../README.md`](../README.md) | Projekt-Überblick |
| 8 | [`../AGENTS.md`](../AGENTS.md) | Agent-Briefing |
| 9 | diese Datei | Harness-Einstieg |

## Guides (Feedforward-Quellen)

| Quelle | Inhalt |
|---|---|
| [`../spec/lastenheft.md`](../spec/lastenheft.md) | LH-FA-* und LH-QA-* mit Akzeptanzkriterien |
| [`../spec/spezifikation.md`](../spec/spezifikation.md) | Algorithmen, Defaults (`MAX_TOPK`, `EMBEDDING_DIM`), Fehler-Codes |
| [`../spec/architecture.md`](../spec/architecture.md) | Schichten, Constraints, Sequenzen |
| [`../docs/plan/adr/`](../docs/plan/adr/) | Architektur- und Prozess-Entscheidungen; Index: [`README.md`](../docs/plan/adr/README.md) |
| [`../docs/plan/planning/`](../docs/plan/planning/) | aktuelle Slices, Roadmap |
| [`../AGENTS.md`](../AGENTS.md) | Hard Rules, Workflow |
| [`conventions.md`](conventions.md) | repo-lokale Strukturregeln, Adaptions-Block (`MR-*`), Modus-Deklarationen |
| [Kurs-Regelwerk](../../regelwerk/README.md) | adoptiertes Betriebsregelwerk in Agenten-Kurzform; derivativ, Stand siehe [`conventions.md`](conventions.md) §Baseline |

## Sensors (Feedback-Gates)

**Sprach-Skelett-Gates** — im jeweiligen Skelett aufzurufen; `gates`, `ci` und
`fullbuild` reicht das Root-`Makefile` zusätzlich per `COURSE_LANG=<sprache>`
durch, die übrigen nicht. Alle sind in den sechs Skeletten real implementiert.

| Target | Vertrag | Bindung |
|---|---|---|
| `make lint` | Linter + Suppression-Gate | [LH-QA-04](../spec/lastenheft.md#lh-qa-04--audit-datenschutz) (Regel `no-userid-in-log`) |
| `make typecheck` | Statische Typprüfung | — |
| `make arch-check` | Layering | [ADR-0001](../docs/plan/adr/0001-hexagonale-architektur.md) |
| `make test` | Unit-Tests | — |
| `make test-determinism` | 100 Wiederholungen identischer Eingabe | [LH-QA-02](../spec/lastenheft.md#lh-qa-02--reproduzierbarkeit) |
| `make coverage-gate` | Gesamt-Coverage, bootstrap-aware | [ADR-0013](../docs/plan/adr/0013-coverage-schwellen.md): 70 %, ab M2 80 % (via Nachfolge-ADR) |
| `make coverage-gate-critical` | Critical-Path-Coverage | [ADR-0013](../docs/plan/adr/0013-coverage-schwellen.md): 90 %, Index-Layer via [`CO-001`](../docs/plan/carveouts/CO-001-index-coverage.md) bis Welle 2 ausgenommen |
| `make gates` | alle inneren Gates | — |
| `make ci` | gates + `test-determinism` + `coverage-gate-critical` | — |
| `make fullbuild` | volle Closure | Image-Hash `sha256:abc123…` (Modul 14) |

Repo-weit, sprachunabhängig (nur im Root-`Makefile`):

| Target | Vertrag | Bindung |
|---|---|---|
| `make verify` | Closure-Pflicht + Referenz-Richtung; mit `SLICE=` zusätzlich die Slice-DoD | — (Aggregat) |
| `make verify-closure-notes` | dieselbe Aussage wie `planning.closure` unten, **als Vorführ-Gegenstand**: An diesem Skript zeigt [Modul 11](../../../kurs/de/04-qualitaet/modul-11-verification.md) „Fitness Function ohne Standard-Tool". Die Deckung trägt es nicht mehr — belegt, nicht behauptet: je Verstoßklasse ein Break-Test mit beiden Sensoren, über alle drei Dateiarten des Ruheorts | [ADR-0019](../docs/plan/adr/0019-closure-sensor-und-skript-rolle.md) |
| [`make doc-check`](sensors/doc-check.md) | **Fünf Module** (`reviews`, `ids`, `planning`, `targets`, `matrix`) über die Doku-Referenzen: Review-Report-Deckung, ADR-Kennung als Link, Roadmap- und Wellen-Invarianten, reale Make-Targets, Referenz-Richtung; Vertrag, drei Grenzen und **je Modul eine eigene Bindung** in der verlinkten Datei | fünf Konventions-Bindungen (`MR-002`), einzeln in [`sensors/doc-check.md`](sensors/doc-check.md#bindung) |
| `make verify-slice` | DoD eines Slice plausibilisieren; Aufruf mit `SLICE=<id>` | — |
| `make plan-status` | Slice-Verteilung über die Lifecycle-Verzeichnisse; rot, wenn ein Lifecycle-Verzeichnis fehlt | — |
| [`make replay`](sensors/replay.md) | Golden-Set-Fixture validieren, Aufruf mit `RUN=<set-name>`, **kein Lauf**; Vertrag und zwei Grenzen in der verlinkten Datei | [Modul 12 §Golden-Set-Form](../../../kurs/de/04-qualitaet/modul-12-replay-evaluierung.md) (`MR-002`) |
| `make trace` | Trace-Fixture ausgeben, Aufruf mit `RUN=<name>`; rot, wenn sie fehlt oder keine Spans trägt | — |
| `make release` | Release-Checkliste und Runbook-Fixtures prüfen | [Modul 16 §Release-Disziplin](../../../kurs/de/05-betrieb/modul-16-produktiver-betrieb.md) (`MR-002`); Fixture: [`../runbooks/release-checklist.md`](../runbooks/release-checklist.md) |

**Werkzeuge — genannt, weil der Lauf sie braucht, aber kein Gate.** `export`
lebt in den sechs `<sprache>/Makefile` und wird vom Root **nicht**
durchgereicht; die beiden `agent-*` nur im Root:

| Target | Tut was | Bindung |
|---|---|---|
| `make export` | packt die Belege der Beleg-Stages host-seitig aus (Rückweg ohne Mount): Lint-Befunde, Coverage-Zusammenfassung, maschinenlesbarer Coverage-Report — in allen sechs Skeletten derselbe Satz | kein Gate |
| `make agent-implement` | zeigt das Kontextpaket eines Implementer-Agenten; Aufruf mit `SLICE=<id>` | kein Gate |
| `make agent-review` | zeigt die Review-Fixture zu [Modul 10](../../../kurs/de/04-qualitaet/modul-10-review-harness.md) | kein Gate |

**Aktueller Lauf-Status:** CI-Badge bzw. lokal `make help` / `make gates` (keine Status-Spalte hier, siehe [Konventionen §`harness/README.md` als Einstiegspunkt](../../../kurs/de/grundlagen/harness-dateien.md#harnessreadmemd-als-einstiegspunkt)).
**Rote Gates:** Begründung im verlinkten `CO-<NNN>` (Bindung-Spalte), Modul 7.
**Nicht behauptet** (geplant, nicht in Makefile): `make test-property` (Property-Based-Suite, slice-013, in-progress), `make sbom`, `make security-scan` (welle-4-betrieb).
**Weder vorhanden noch in der Roadmap:** ein Image-Scan — anders als `make sbom` und `make security-scan`, die für `welle-4-betrieb` vorgemerkt sind.

**Nicht Teil von `ci`:** das Golden Set ([`sensors/replay.md`](sensors/replay.md) §Grenze).

## Traceability rules

- PRs/Commits **müssen** mindestens eine `LH-*`- oder `ADR-*`-ID nennen (geprüft durch Pre-commit-Hook).
- Neue Anforderungen brauchen Beleg: Test (mit ID im Test-Namen), Gate, Demo, oder ADR.
- Neue ADRs müssen [`../docs/plan/adr/README.md`](../docs/plan/adr/README.md) aktualisieren.
- Lifecycle-Bewegung eines Slice ist reiner `git mv` (siehe AGENTS.md §2.3, §2.8).

## Safety and scope boundaries

DocSearch ist **kein produktives System**. Es ist ein Lehr-Beispiel.

- Keine personenbezogenen Klartext-Daten in Logs (siehe [LH-QA-04](../spec/lastenheft.md#lh-qa-04--audit-datenschutz), geprüft in `make lint`).
- Embedding-Adapter muss On-Prem-Fähigkeit haben (siehe [ADR-0002](../docs/plan/adr/0002-modellwahl-embedding.md), InfoSec-Constraint).
- Reindex ist nicht atomar gegenüber paralleler Search — `make test` deckt das ab, Multi-Worker-Setup ist out-of-scope (siehe Lastenheft §5).
- Tie-Break in sortierenden Operationen ist explizit (AGENTS.md §2.7).

## Minimal agent workflow

1. Diese Datei lesen.
2. Relevante kanonische Quelle lesen (Source Precedence beachten).
3. Betroffene IDs identifizieren.
4. Kleinste Änderung planen.
5. Engsten nützlichen Sensor laufen lassen.
6. Repo-weiten Gate-Lauf vor Handoff: `make gates` (Sprach-Skelett) **und**
   `make verify` (Closure-Pflicht + Referenz-Richtung).
7. Doku/Indizes aktualisieren, falls ein öffentlicher Vertrag berührt.
8. Ausgeführte Sensors und verbleibende Risiken berichten — keine Erfolgsmeldung ohne Gate-Ausführung.

Dieser Workflow deckt ausschließlich die Implementer-Rolle ab. Schritt 8
ist der Rollenwechsel, kein Abschluss: Bericht → Handoff an Reviewer →
Verifier. Kein Self-Review — anderer Kontext findet andere Findings,
derselbe Kontext dieselben blinden Flecken (Baseline-Regelwerk
`modul-08-agentenrollen.md`).

## Leseordnung

Die Menschen-Hälfte des Einstiegs (Baseline:
[`grundlagen-harness-dateien.md` §Einstiegspunkt](../../regelwerk/grundlagen-harness-dateien.md#harnessreadmemd-als-einstiegspunkt)) —
drei geordnete Zeiger, der Rest dieser Datei ist Referenzfläche:

1. [`AGENTS.md` §Hard Rules](../AGENTS.md) — was in diesem Repo nie passieren darf.
2. [`spec/lastenheft.md`](../spec/lastenheft.md) — wogegen abgenommen wird.
3. Bei Bedarf: [`harness/conventions.md`](conventions.md) — die repo-lokalen
   Adaptionen, eine Zeile pro aktiver.
