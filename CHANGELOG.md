# Changelog

Kanonisches Register der Überarbeitungs-Wellen dieses Kurses. Die
Stand-Zeile von [`kurs/de/agents-regelwerk.md`](kurs/de/agents-regelwerk.md)
referenziert diese Nummern; adoptierende Repos vergleichen ihren
Baseline-`Stand:`-Eintrag gegen dieses Register.

> **Zählung.** Fortlaufend über alle Wellen (Inhalt, Didaktik,
> Tooling). Vor Einführung dieses Registers liefen zwei parallele
> Zählungen in Commit-Messages (generisch „Welle 1–16" und
> „Didaktik-Review Welle N") — Commit-Labels können daher von der
> kanonischen Nummer abweichen; maßgeblich ist dieses Register.

## Welle 19 — 2026-06-14 · C++/CMake-Skelett + Regelwerk-Drift-Sensor

### Neu

- **C++/CMake-Skelett** in [`lab/example/cpp/`](lab/example/cpp/) —
  sechstes Sprach-Skelett (C++20, hexagonal: `src/hexagon` + `src/adapters`),
  doctest via FetchContent (`GIT_TAG`-Pin), clang-tidy mit
  `WarningsAsErrors`, textbasierter `arch-check.sh` (ADR-0001) als
  CTest-Test, gcovr-Coverage. `make gates` grün im Docker (Coverage 94 %);
  Runtime-Image Distroless `cc` mit statisch gelinktem libstdc++ und
  glibc-Match (`debian:12` ↔ `distroless-debian12`, Base-Images per
  `@sha256` gepinnt).
- **Regelwerk-Drift-Sensor** — `make regelwerk-drift`
  ([`lab/example/tools/check_regelwerk_drift.py`](lab/example/tools/check_regelwerk_drift.py)):
  inhaltsbasierter sha256-Pin der adoptierten `agents-regelwerk.md` in
  `conventions.md` §Baseline; erkennt Upstream-Drift unabhängig vom
  `Stand:`-Marker (vgl. §„Nachweis über Inhalt, nicht Diff"). Kein
  `gates`-Glied — CI/periodisch, braucht die externe Quelle.
- **Regelwerk self-contained ausgeliefert** — `tools/rewrite-doc-links.py`
  schreibt die repo-internen Links der adoptierten `agents-regelwerk.md`
  beim Release auf absolute `blob/<tag>`-URLs um (fence- und
  existenz-gegated: illustrative Adopter-Pfade bleiben relativ). Das
  Regelwerk geht als eigenes Release-Asset neben `lab-templates.zip` raus
  (`releases/latest/download/agents-regelwerk.md`); `AGENTS.template`
  zeigt dorthin statt auf Raw-`main`. Quelle bleibt relativ (kein
  Stand-Bump). Behebt tote Verweise beim Kopieren/Cachen in fremde Repos.

### Geändert

- Sprach-Skelett-Zählung durchgängig fünf → sechs: Lab-Satelliten
  ([`lab/README.md`](lab/README.md), `lab/example/` README/Makefile/AGENTS,
  ADR-0001-Fitness-Table) und Kurs-Prosa (grundlagen, modul-08, modul-14,
  `agents-regelwerk.md`, konventionen) sowie CO-001 / slice-013 /
  slice-014 / roadmap.

## Welle 18 — 2026-06-11 · Konsistenz-Welle + Agents-Regelwerk

*(Commits dieser Welle tragen das historische Label „Welle 8
(Konsistenz)" — die Kollision mit der älteren Welle 8 war der Anlass
für dieses Register.)*

### Behoben

- Fachdidaktisches Review (konstruktives Alignment, Anderson/Krathwohl,
  CLT, didaktische Rekonstruktion): ~45 Befunde — ungeprobte
  Spitzen-Verben mit `LZ <N>`-Items geschlossen, Tag-Fehler korrigiert,
  Engage-/Glossar-/Stimulus-Fixes.
- Lösungsschicht vollständig nachgezogen: jede Übung und jedes
  Selbstcheck-Item der Module 0–16 hat ein Musterantwort-Pendant.
- Off-by-one-Modulnummern der Modul-2-Einfügung repariert
  (`klassifikation.md`, `lernervorstellungen.md`, `kickoff-vorlauf.md`,
  Modul 9 „8a/8b", Root-README-Phasentabelle).
- Lab-Drift: alle fünf Dockerfiles per Registry-Digest gepinnt
  (inkl. Ersatz des toten C#-Tags `cbl-mariner` → `azurelinux`),
  `make plan-status` ergänzt, Modul-8-Lab-Bezug ehrlich gemacht.
- Richtungsfehler in der Lifecycle-Faustregel (`klassifikation.md`:
  „nach rechts" → „nach links").
- Phase-05-Assessment-Vakuum: Pflicht-Feature „Produktionsfreigabe"
  im Abschlussprojekt, Checkpoint A probt Modul 2, Checkpoint D die
  Sensor-Literacy; Kalibrierungsbeispiel B belegt alle Indikatoren.

### Neu

- **`kurs/de/agents-regelwerk.md`** — der Kurs als Betriebsregelwerk für
  Code-Agenten (derivatives Sicht-Artefakt mit Stand-Zeile), in den
  Session-Lesepfaden verdrahtet (AGENTS-/harness-README-Templates,
  Worked Example, `conventions`-Adoptionsquelle mit Raw-URL).
  Im Lauf der Welle umbenannt (vormals `agents-digest.md`) und
  methodisch neu aufgebaut: statt Hand-Verdichtung ein
  **didaktik-freier Extrakt in Quellformulierung** (~4.000 Zeilen —
  Grundlagen-Dossiers komplett, Module 0–16 als operative Extrakte
  mit Quell-Verweis pro Abschnitt; weggelassen ist die
  Didaktik-Schicht, nicht verdichtet der Inhalt).
- Modul 13: Sektion „Gate-Typ ↔ Fehlerbild" (Zuordnungstabelle).
- Templates: ID-Schema-Deklarations-Slot in
  `conventions.template.md`; AGENTS-Template §5 erklärt die
  ID-Vergabe.
- `docs-check`: nicht-kollabierender Slugger (erstmals 0 ERROR),
  `docs-check:ignore`-Marker, Modul-Nummern-Sensor gegen
  Off-by-one-Drift (Linktext = ERROR, Prosa-Titel = WARN).
- Root-`Makefile`: `make docs-check` · `make alignment-check` ·
  `make check` (Docker-basiert, `ARGS`-Durchreichung).
- GitHub-Actions-Workflow `.github/workflows/checks.yml`: beide
  Validatoren als CI-Gate bei Push/PR, über dieselben Make-Targets
  wie lokal (`alignment-check --strict`).
- Review-Report formalisiert: Vorlage
  `lab/templates/docs/reviews/review-report.template.md`, Ablageort
  `docs/reviews/` in der Verzeichniskonvention, Modul-10-Sektion
  „Reviewer berichtet auch, was er nicht gefunden hat" (schließt die
  bis dahin hängende §-Referenz im Reviewer-Skill).
- Dieses CHANGELOG als kanonisches Wellen-Register.

## Welle 17 — 2026-06-08 · Didaktik-Review

*(Commit-Label: „Didaktik-Review Welle 8" — achte Welle der
didaktischen Teilserie.)* Alignment-, Konsistenz- und CLT-Fixes über
32 Dateien: systemisches und-Verb-Audit, M13-Gate-Familien,
Kickoff-YAML-Zielmodule, M8-Übergabe-Zählung, Vier-Repos-Angaben.

## Wellen 1–16 — 2026-06-02 bis 2026-06-04

| Welle | Datum | Inhalt |
|---|---|---|
| 16 | 2026-06-04 | Fallstudien-Drift gegen Ist-Zustand der vier Beispiel-Repos behoben |
| 15 | 2026-06-04 | Englische Autorzitate ins DE übertragen, Given/When/Then-Notation verankert |
| 14 | 2026-06-03 | 12 Didaktik-Review-Findings (vier Linsen) behoben |
| 13 | 2026-06-03 | 16 Didaktik-Review-Findings behoben |
| 12 | 2026-06-02 | Modul 06: Übungen an beide Erschaffen-LZ gebunden |
| 11 | 2026-06-02 | Reflexionsvorlage: drei → vier Fragen angeglichen |
| 10 | 2026-06-02 | Lab um Module-10/11/14-Artefakte erweitert |
| 9 | 2026-06-02 | Worked Examples für fünf Erschaffen-Lernziele ergänzt |
| 8 | 2026-06-02 | Didaktik-Review-Findings (16 Befunde) behoben |
| 7 | 2026-06-02 | Didaktik-Review-Restposten behoben |
| 6 | 2026-06-02 | Didaktik-Review-Findings (4 Linsen) behoben |
| 5 | 2026-06-02 | Didaktik-Review-Findings (Alignment, Bloom, CLT) behoben |
| 4 | 2026-06-02 | Didaktik-Gutachten-Findings behoben |
| 3 | 2026-06-02 | docs-check-Validator-Findings behoben |
| 2 | 2026-06-02 | Sprach-Skelette-Review-Findings behoben |
| 1 | 2026-06-02 | Kurs-Inhalt-Review-Findings behoben |

Hinweis: Die Verweise „Welle 8" und „Welle 13" in
[`kurs/de/grundlagen/lernervorstellungen.md`](kurs/de/grundlagen/lernervorstellungen.md)
beziehen sich auf diese Zählung.
