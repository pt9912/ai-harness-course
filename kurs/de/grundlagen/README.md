# Grundlagen

Diese Sektion legt die Begriffe und das konzeptuelle Vokabular fest, das
in allen Modulen vorausgesetzt wird. Die Modul-Texte verlinken zurück auf
diese Definitionen (Standard-Markdown), ohne sie erneut zu erklären.

*Pflicht-Vorablektüre sind nur* [`konzeptkarte.md`](konzeptkarte.md) *und*
[`klassifikation.md`](klassifikation.md) *§2×2-Matrix* (siehe
[Haupt-README §Vorab-Lektüre](../README.md#vorab-lektüre-pflicht)). Die
übrigen Dateien — besonders die 679-zeilige
[`konventionen.md`](konventionen.md) mit der Sub-Area- und
Trigger-Klassen-Tiefe — sind **Nachschlagewerke**: sektionsweise bei
Bedarf lesen (die Glossar-Tabelle als Pre-Training, der Bootstrap-Teil
erst zu Modul 2/5), nicht am Stück vorab. Wer sie als Block vor Modul 0
liest, lädt sich Modul-2-Tiefe auf, bevor ein Kontext dafür existiert.

## Inhalt

| Datei | Inhalt |
|---|---|
| [`konventionen.md`](konventionen.md) | Glossar, Verzeichniskonvention, Trennschärfen, Source Precedence, Spec-Stratifizierung, ID-Schema, Traceability-Constraint, `harness/README.md`-Pattern |
| [`konzeptkarte.md`](konzeptkarte.md) | Reduzierte Artefaktkette, vier Leitfragen, 2×2-Schnellanker gegen kognitive Überlast |
| [`klassifikation.md`](klassifikation.md) | Böckelers 2×2 (Feedforward/Feedback × Computational/Inferential), drei Harness-Kategorien (Maintainability, Architecture Fitness, Behaviour), OpenAIs drei operative Säulen (Context Engineering, Architectural Constraints, Entropy Management), Steering Loop, Lifecycle-Verteilung |
| [`durchsetzungsschicht.md`](durchsetzungsschicht.md) | Fail-closed Bindung von Konventionen an die Agent-Schleife: drei Bindepunkte (Tool-Call-/Handoff-Gate, Workflow-Skelett) auf der 2×2-Matrix, vier Design-Eigenschaften, ehrliche Grenzen, Referenz-Artefakte (Claude-Code-Hooks) |
| [`fallstudien.md`](fallstudien.md) | Vier reale Open-Source-Repos: `pt9912/grid-gym`, `pt9912/c-hsm-doc` und `pt9912/bess-ems` als laufende Beispiele, `pt9912/u-boot` als ADR-Korpus-Anker (Modul 4) |
| [`lernpfade.md`](lernpfade.md) | Drei Schwerpunkt-Pfade (Architect/Tech Lead, DevOps/Plattform, Implementation) — Vertiefungen je nach Rolle |
| [`reflexion-vorlage.md`](reflexion-vorlage.md) | Vier Standardfragen für Fehler-Provokations- *und* Diagnose-Übungen (Diagnose-Variante für Frage 2/3) — productive failure systematisch in Lernen überführen |
| [`lernervorstellungen.md`](lernervorstellungen.md) | Offene Sammlung typischer Präkonzepte der Zielgruppe — als Anker für die "Typische Fehlvorstellungen"-Blöcke der Module |
| [`kickoff-vorlauf.md`](kickoff-vorlauf.md) | Drei kalibrierte Vorlauffragen und YAML-Sammelplatz für die Präkonzept-Sammlung am Workshop-Anfang (Operationalisierung der zweiten Kattmann-Säule für die kollektive Kursnutzung) |
| [`checkpoints.md`](checkpoints.md) | Mini-Integrations-Checkpoints zwischen den fünf Phasen — Selbstdiagnose vor dem Abschlussprojekt |
| [`selbstcheck-rubrik.md`](selbstcheck-rubrik.md) | Drei-Stufen-Schema (rudimentär/solide/exzellent), nach dem die Selbstcheck-Rubriken in jedem Modul aufgebaut sind |

## Modulschema

Jedes Modul folgt demselben Aufbau:

0. **Engage** *(empfohlen, vor Lernzielen)* — eine kurze Vignette (3–6
   Sätze), die einen konkreten Reibungsfall schildert: zwei
   widersprüchliche Beobachtungen, ein überraschendes Ergebnis, eine
   Frage ohne offensichtliche Antwort. Zweck: *Unzufriedenheit* mit
   einer bestehenden Vorstellung *vor* der Lehre auslösen (Posner et
   al. 1982 §Bedingung 1 für Conceptual Change). Engage steht
   *vor* den Lernzielen, weil die didaktische Wirkung darauf beruht,
   dass Aufmerksamkeit *vor* dem expliziten Lernvertrag durch ein
   konkretes Problem gefangen wird — eine Lernziel-Liste, die schon
   gelesen ist, schließt die Frage, die Engage öffnen soll. Optional,
   aber in allen aktuellen Modulen vorhanden.
1. **Lernziele** — was kannst du danach. Jedes Lernziel trägt einen
   zweidimensionalen Tag nach Anderson/Krathwohl: `(Prozessdimension · Wissensdimension)`.
   Prozessdimension: *Erinnern · Verstehen · Anwenden · Analysieren · Bewerten · Erschaffen*.
   Wissensdimension: *faktisch · konzeptuell · prozedural · metakognitiv*.
   Beispiel: `(Analysieren · konzeptuell)` für eine Quadranten-Zuordnung in der 2×2-Matrix;
   `(Anwenden · prozedural)` für das Durchlaufen des 8-Schritt-Workflows.

   *Konvention "und"-Lernziele*: Einige Lernziele verbinden zwei
   Prozessdimensionen ("zuordnen *und* begründen"; "bewegen *und*
   benennen"). Drei Schreibweisen, in dieser Vorzugsreihenfolge:

   1. **Trennen.** Zwei Prozessdimensionen → zwei Lernziele mit je
      eigenem Tag. Sauberste Form, weil jedes LZ einzeln alignment-prüfbar
      ist. Bevorzugt, wenn die Verben tatsächlich unterschiedliche
      Tätigkeiten beschreiben (z. B. "*aufbauen* und *bewerten*").
   2. **Beide Verben sichtbar.** Wenn die Trennung das LZ künstlich
      zerreißen würde (Verben sind im Kursvokabular *eine* Tätigkeit,
      z. B. "*erkennen und entwerfen*" als Symptom→Gegenmaßnahme-Paar):
      Tag listet beide, getrennt durch `+`: `(Bewerten + Erschaffen ·
      konzeptuell+prozedural)`. Vorbilder: Modul 4 LZ 4, Modul 12 LZ 4.
      Pflicht: **jedes** Verb hat eine alignment-geprobte Stelle in
      Übung oder Selbstcheck.
   3. **Höheres Verb.** Wenn die niedrigere Prozessdimension nur
      *implizit* mitgemeint ist und kein eigenes Übungs-/Selbstcheck-
      Item hat: Tag führt nur das höhere Verb. "*X und Y begründen*"
      bekommt dann *Bewerten*, nicht *Verstehen + Bewerten*. Wer diese
      Form wählt, gibt zu: das niedrigere Verb ist nicht alignment-
      geprobt — was beim ersten Vorkommen in Modul 0/1 akzeptabel
      sein kann, ab Modul 3 ein Warnzeichen ist.

   Prüfschritt am Ende: zähle pro Verb im Tag die alignment-geprobten
   Stellen in Übung und Selbstcheck. Null → Form 3 wählen oder
   Selbstcheck ergänzen. Eins oder mehr → Form 1 oder 2.
2. **Lab-Bezug** — welche Verzeichnisse, Make-Targets oder Artefakte gehören dazu.
3. **Themen** — die Konzepte des Moduls.
4. **Kernidee** — die eine Aussage, an der das Modul hängt.
5. **Übungen** — Hands-on, mindestens eine mit absichtlichem
   Fehlerfall *oder* — als deklarierte Ausnahme — eine Diagnose-Übung
   an einem bereits defekten Artefakt (Diagnose-Variante, siehe
   [`reflexion-vorlage.md`](reflexion-vorlage.md); so verfährt z. B.
   Modul 2).
6. **Reflexion** — vier Standardfragen (Beobachtung · 2×2-Quadrant · Steering-Loop · Conceptual Change). Vollform mit Eintragsformat, Anti-Antworten und "Wann *nicht* reagieren": [`reflexion-vorlage.md`](reflexion-vorlage.md). Ab Modul 3 listen die Module nur die *modul-spezifischen Trigger* zu den vier Fragen — die Vollform wird in Modul 0 und 1 einmal aufgeschlagen und danach referenziert (Redundanz-Effekt, Sweller).
7. **Selbstcheck** — Fragen, die du nach dem Modul beantworten können solltest, mit Drei-Stufen-Rubrik (rudimentär/solide/exzellent).

Optional zusätzlich, jeweils mit eigener Überschrift:

* **Harness-Einordnung** — ordnet das Modul-Thema in die Klassifikation aus [`klassifikation.md`](klassifikation.md) ein (häufig in Phase 03–05).
* **Mini-Glossar** — drei bis sechs Begriffsanker mit Ein-Satz-Definition und "Bild im Kopf", wenn ein Modul mindestens drei neue Begriffe einführt (Pre-Training-Effekt, Mayer/Sweller). *Positions-Konvention:* typischerweise zwischen Aufwand-Zeile und Engage, sodass die Vignette das Vokabular schon nutzen kann. Ausnahme: Modul 0 hat den Mini-Glossar bewusst *nach* Engage — die Vignette verwendet dort common-language, weil die Fachbegriffe noch nicht zugänglich sind.
* **Vorgriff** — Kurzdefinition für Begriffe, deren Tiefen in späteren Modulen liegen (Isolated-Elements-Strategie). Vorbild: Image-Hash in [Modul 12](../04-qualitaet/modul-12-replay-evaluierung.md#begriff-image-hash-vorgriff-aus-modul-14).
* **Worked Example** — fünf bis sieben prozedurale Schritte mit Anfangs- und Endzustand, ein Skip-Hinweis am Anfang (Expertise-Reversal-Schutz). Frühe Vorbilder: Modul 1 und 3; inzwischen tragen alle Module 1–16 mindestens ein Worked Example mit Skip-Hinweis.
* **Typische Fehlvorstellungen** — Konfrontation typischer Präkonzepte mit Begründung; offene Sammlung in [`lernervorstellungen.md`](lernervorstellungen.md).
* **Optionale Explorations-Vorab-Übung** — Kapur-Stil-Vorab-Aufgabe vor dem Lesen des Moduls, in Modul 0 und 2 modelliert.

## Begleit-Lab

Der Kurs liefert ein Beispiel-Repo unter [`/lab/example/`](../../../lab/example/)
mit:

* lauffähigen Beispiel-Artefakten in `spec/`, `docs/plan/adr/`, `docs/plan/planning/`
* sechs parallelen Sprach-Skeletten (Go, Python, Kotlin, Java, C#, C++) mit eigener Toolchain in `go/`, `python/`, `kotlin/`, `java/`, `csharp/`, `cpp/` — *Phase C der Lab-Roadmap, ausgeliefert*
* Make-Targets für alle Gates (`make lint`, `make typecheck`, `make arch-check`, `make coverage-gate`, `make coverage-gate-critical`, `make gates`)
* Root-Harness-Targets für die Kursmodule (`make agent-implement`, `make agent-review`, `make verify`, `make replay`, `make trace`, `make release`)
* fingiertem "kaputten" Slice für die Review-Übung in [Modul 10](../04-qualitaet/modul-10-review-harness.md)
* Replay-Beispiel mit Golden Set in `evals/`

Arbeitsweise:

1. Modul lesen.
2. Genannte Make-Targets ausführen.
3. Übung bearbeiten.
4. Mindestens einen Fehlerfall absichtlich auslösen (z. B. Architekturregel verletzen, Spec-Lücke offenlassen, Agenten ohne Tool-Constraint laufen lassen).
5. Ergebnis mit [`../loesungen/`](../loesungen/) vergleichen.

Wenn ein Gate fehlschlägt, ist das kein Nebenthema. Genau dort lernt man
den Harness.
