# Changelog

Kanonisches Register der Überarbeitungs-Wellen dieses Kurses. Die
Stand-Zeile von [`kurs/de/agents-digest.md`](kurs/de/agents-digest.md)
referenziert diese Nummern; adoptierende Repos vergleichen ihren
Baseline-`Stand:`-Eintrag gegen dieses Register.

> **Zählung.** Fortlaufend über alle Wellen (Inhalt, Didaktik,
> Tooling). Vor Einführung dieses Registers liefen zwei parallele
> Zählungen in Commit-Messages (generisch „Welle 1–16" und
> „Didaktik-Review Welle N") — Commit-Labels können daher von der
> kanonischen Nummer abweichen; maßgeblich ist dieses Register.

## Welle 18 — 2026-06-11 · Konsistenz-Welle + Agents-Digest

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

- **`kurs/de/agents-digest.md`** — der Kurs als Betriebsregelwerk für
  Code-Agenten (derivatives Sicht-Artefakt mit Stand-Zeile), in den
  Session-Lesepfaden verdrahtet (AGENTS-/harness-README-Templates,
  Worked Example, `conventions`-Adoptionsquelle mit Raw-URL).
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
