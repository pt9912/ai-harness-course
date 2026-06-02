# Grundlagen

Diese Sektion legt die Begriffe und das konzeptuelle Vokabular fest, das
in allen Modulen vorausgesetzt wird. Lies sie *vor* den Modulen — die
Modul-Texte verweisen mit `[[Begriff]]`-artigen Verlinkungen auf diese
Definitionen zurück, ohne sie erneut zu erklären.

## Inhalt

| Datei | Inhalt |
|---|---|
| [`konventionen.md`](konventionen.md) | Glossar, Verzeichniskonvention, Trennschärfen, Source Precedence, Spec-Stratifizierung, ID-Schema, Traceability-Constraint, `harness/README.md`-Pattern |
| [`konzeptkarte.md`](konzeptkarte.md) | Reduzierte Artefaktkette, vier Leitfragen, 2×2-Schnellanker gegen kognitive Überlast |
| [`klassifikation.md`](klassifikation.md) | Böckelers 2×2 (Feedforward/Feedback × Computational/Inferential), drei Harness-Kategorien (Maintainability, Architecture Fitness, Behaviour), OpenAIs drei operative Säulen (Context Engineering, Architectural Constraints, Entropy Management), Steering Loop, Lifecycle-Verteilung |
| [`fallstudien.md`](fallstudien.md) | Vier reale Open-Source-Repos als laufendes Beispiel: `pt9912/u-boot`, `pt9912/grid-gym`, `pt9912/c-hsm-doc`, `pt9912/bess-ems` |
| [`lernpfade.md`](lernpfade.md) | Drei Schwerpunkt-Pfade (Architect/Tech Lead, DevOps/Plattform, Implementation) — Vertiefungen je nach Rolle |
| [`reflexion-vorlage.md`](reflexion-vorlage.md) | Drei Standardfragen für jede Fehler-Provokations-Übung — productive failure systematisch in Lernen überführen |
| [`lernervorstellungen.md`](lernervorstellungen.md) | Offene Sammlung typischer Präkonzepte der Zielgruppe — als Anker für die "Typische Fehlvorstellungen"-Blöcke der Module |
| [`checkpoints.md`](checkpoints.md) | Mini-Integrations-Checkpoints zwischen den fünf Phasen — Selbstdiagnose vor dem Abschlussprojekt |
| [`selbstcheck-rubrik.md`](selbstcheck-rubrik.md) | Drei-Stufen-Schema (rudimentär/solide/exzellent), nach dem die Selbstcheck-Rubriken in jedem Modul aufgebaut sind |

## Modulschema

Jedes Modul folgt demselben Aufbau:

1. **Lernziele** — was kannst du danach.
2. **Lab-Bezug** — welche Verzeichnisse, Make-Targets oder Artefakte gehören dazu.
3. **Themen** — die Konzepte des Moduls.
4. **Kernidee** — die eine Aussage, an der das Modul hängt.
5. **Übungen** — Hands-on, mindestens eine mit absichtlichem Fehlerfall.
6. **Selbstcheck** — Fragen, die du nach dem Modul beantworten können solltest.

Manche Module haben zusätzlich einen Block **Harness-Einordnung**, der das
Modul-Thema in die Klassifikation aus [`klassifikation.md`](klassifikation.md)
einordnet.

## Begleit-Lab

Der Kurs liefert ein Beispiel-Repo unter [`/lab/example/`](../../../lab/example/)
mit:

* lauffähigen Beispiel-Artefakten in `spec/`, `docs/plan/adr/`, `docs/plan/planning/`
* fünf parallelen Sprach-Skeletten (Go, Python, Kotlin, Java, C#) mit eigener Toolchain
* Make-Targets für alle Gates (`make lint`, `make typecheck`, `make arch-check`, `make coverage-gate`, `make coverage-gate-critical`, `make gates`)
* Root-Harness-Targets für die Kursmodule (`make agent-implement`, `make agent-review`, `make verify`, `make replay`, `make trace`, `make release`)
* fingiertem "kaputten" Slice für die Review-Übung in [Modul 9](../04-qualitaet/modul-09-review-harness.md)
* Replay-Beispiel mit Golden Set in `evals/`

Arbeitsweise:

1. Modul lesen.
2. Genannte Make-Targets ausführen.
3. Übung bearbeiten.
4. Mindestens einen Fehlerfall absichtlich auslösen (z. B. Architekturregel verletzen, Spec-Lücke offenlassen, Agenten ohne Tool-Constraint laufen lassen).
5. Ergebnis mit [`../loesungen/`](../loesungen/) vergleichen.

Wenn ein Gate fehlschlägt, ist das kein Nebenthema. Genau dort lernt man
den Harness.
