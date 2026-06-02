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
| [`reflexion-vorlage.md`](reflexion-vorlage.md) | Vier Standardfragen für jede Fehler-Provokations-Übung — productive failure systematisch in Lernen überführen |
| [`lernervorstellungen.md`](lernervorstellungen.md) | Offene Sammlung typischer Präkonzepte der Zielgruppe — als Anker für die "Typische Fehlvorstellungen"-Blöcke der Module |
| [`checkpoints.md`](checkpoints.md) | Mini-Integrations-Checkpoints zwischen den fünf Phasen — Selbstdiagnose vor dem Abschlussprojekt |
| [`selbstcheck-rubrik.md`](selbstcheck-rubrik.md) | Drei-Stufen-Schema (rudimentär/solide/exzellent), nach dem die Selbstcheck-Rubriken in jedem Modul aufgebaut sind |

## Modulschema

Jedes Modul folgt demselben Aufbau:

1. **Lernziele** — was kannst du danach. Jedes Lernziel trägt einen
   zweidimensionalen Tag nach Anderson/Krathwohl: `(Prozessdimension · Wissensdimension)`.
   Prozessdimension: *Erinnern · Verstehen · Anwenden · Analysieren · Bewerten · Erschaffen*.
   Wissensdimension: *faktisch · konzeptuell · prozedural · metakognitiv*.
   Beispiel: `(Analysieren · konzeptuell)` für eine Quadranten-Zuordnung in der 2×2-Matrix;
   `(Anwenden · prozedural)` für das Durchlaufen des 8-Schritt-Workflows.
2. **Lab-Bezug** — welche Verzeichnisse, Make-Targets oder Artefakte gehören dazu.
3. **Themen** — die Konzepte des Moduls.
4. **Kernidee** — die eine Aussage, an der das Modul hängt.
5. **Übungen** — Hands-on, mindestens eine mit absichtlichem Fehlerfall.
6. **Reflexion** — vier Standardfragen (Beobachtung · 2×2-Quadrant · Steering-Loop · Conceptual Change). Vollform mit Eintragsformat, Anti-Antworten und "Wann *nicht* reagieren": [`reflexion-vorlage.md`](reflexion-vorlage.md). Ab Modul 2 listen die Module nur die *modul-spezifischen Trigger* zu den vier Fragen — die Vollform wird in Modul 0 und 1 einmal aufgeschlagen und danach referenziert (Redundanz-Effekt, Sweller).
7. **Selbstcheck** — Fragen, die du nach dem Modul beantworten können solltest, mit Drei-Stufen-Rubrik (rudimentär/solide/exzellent).

Optional zusätzlich, jeweils mit eigener Überschrift:

* **Harness-Einordnung** — ordnet das Modul-Thema in die Klassifikation aus [`klassifikation.md`](klassifikation.md) ein (häufig in Phase 03–05).
* **Mini-Glossar** — drei bis sechs Begriffsanker mit Ein-Satz-Definition und "Bild im Kopf", wenn ein Modul mindestens drei neue Begriffe einführt (Pre-Training-Effekt, Mayer/Sweller).
* **Vorgriff** — Kurzdefinition für Begriffe, deren Tiefen in späteren Modulen liegen (Isolated-Elements-Strategie). Vorbild: Image-Hash in [Modul 11](../04-qualitaet/modul-11-replay-evaluierung.md#begriff-image-hash-vorgriff-aus-modul-13).
* **Worked Example** — fünf bis sieben prozedurale Schritte mit Anfangs- und Endzustand, ein Skip-Hinweis am Anfang (Expertise-Reversal-Schutz). Vorbilder: Modul 2, 3, 9, 12; ab Welle 6 auch Modul 8, 11, 14, 15.
* **Typische Fehlvorstellungen** — Konfrontation typischer Präkonzepte mit Begründung; offene Sammlung in [`lernervorstellungen.md`](lernervorstellungen.md).
* **Optionale Explorations-Vorab-Übung** — Kapur-Stil-Vorab-Aufgabe vor dem Lesen des Moduls, in Modul 0 und 2 modelliert.

## Begleit-Lab

Der Kurs liefert ein Beispiel-Repo unter [`/lab/example/`](../../../lab/example/)
mit:

* lauffähigen Beispiel-Artefakten in `spec/`, `docs/plan/adr/`, `docs/plan/planning/`
* fünf parallelen Sprach-Skeletten (Go, Python, Kotlin, Java, C#) mit eigener Toolchain — *Roadmap, Phase C; heute noch nicht ausgeliefert*
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
