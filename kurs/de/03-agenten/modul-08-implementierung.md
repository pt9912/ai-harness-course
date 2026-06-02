# Modul 8 — Implementierung durch KI-Agenten

> **Aufwand:** ca. 120 Min Lesen · 120 Min Übung. Dieses Modul ist absichtlich tief — der 8-Schritt-Workflow und die Hard Rules sind die operative Brücke zwischen Theorie (Module 1–7) und Gates (Module 9–12).

## Engage

Du gibst deinem Implementation-Agent einen Slice. Er liefert in vier
Minuten 800 Zeilen Diff. Du prüfst — und findest, dass er die Hälfte aus
einem ähnlichen Repo erfunden hat, weil deine AGENTS.md schwieg. Hätte
er stattdessen erst einen *Plan* ausgegeben, hätte er nach 30 Sekunden
einräumen müssen, dass er den Kontext nicht hat. Plan → Diff → Code ist
nicht eine Empfehlung; es ist *die Reihenfolge*, die "schreiben" von
"raten" trennt.

## Lernziele

Nach diesem Modul kannst du:

* einen Slice nach dem 8-Schritt-Workflow *umsetzen* und die Reihenfolge Plan → Diff → Code *einhalten* (Anwenden),
* drei Hard Rules für ein Beispiel-Repo *formulieren*, jeweils mit Falsch/Richtig-Beispiel und Begründung (Erschaffen),
* eine Hard Rule einem Quadranten der 2×2-Matrix *zuordnen* (Analysieren),
* die Wirkung von AGENTS.md auf einen Agentenlauf *messen*, indem du den Lauf mit und ohne AGENTS.md vergleichst (Bewerten).

## Lab-Bezug

* [`../../../lab/example/Makefile`](../../../lab/example/Makefile), Target `make agent-implement SLICE=slice-009`
* [`../../../lab/example/exercises/08-implementation.md`](../../../lab/example/exercises/08-implementation.md)

## Themen

* Codegenerierung
* Änderungsplanung vor Code
* Refactoring
* Architekturkonformität
* Werkzeugbindung (welche Tools darf der Agent benutzen)
* AGENTS.md als zentrale, maschinell lesbare Konventionsdatei
* Pre-completion Checklist Middleware (Self-Check vor PR-Open)

## Kernidee

Ein Agent ohne Plan schreibt Code. Ein Agent mit Plan schreibt das
*Richtige*. Die Reihenfolge Plan → Diff → Code ist nicht optional.

## Minimal Agent Workflow (8 Schritte)

Der Pfad, den jeder Implementation-Agent pro Slice durchläuft — und der
in `harness/README.md` als Vertrag dokumentiert wird:

1. `harness/README.md` lesen.
2. Relevante kanonische Quelle lesen (Source Precedence beachten).
3. Betroffene Requirement-/ADR-IDs identifizieren.
4. Kleinste sinnvolle Änderung planen.
5. Engsten nützlichen Sensor laufen lassen (z. B. nur eine Testdatei).
6. Repo-weiten Gate-Lauf vor Handoff (`make gates`).
7. Doku/Indizes aktualisieren, falls ein öffentlicher Vertrag berührt ist.
8. Ausgeführte Sensors und verbleibende Risiken berichten — keine Erfolgsmeldung ohne Gate-Ausführung.

### Workflow als Diagramm

```mermaid
flowchart TD
    Start([Slice startet]) --> S1["1. harness/README.md lesen"]
    S1 --> S2["2. kanonische Quelle lesen<br/>(Source Precedence)"]
    S2 --> S3["3. Requirement-/ADR-IDs<br/>identifizieren"]
    S3 --> S4["4. kleinste Änderung planen<br/>(Plan vor Code!)"]
    S4 --> S5["5. engsten Sensor laufen<br/>(eine Testdatei)"]
    S5 --> Check{Sensor grün?}
    Check -- nein --> S4
    Check -- ja --> S6["6. make gates (repo-weit)"]
    S6 --> CheckG{alle Gates grün?}
    CheckG -- nein --> S4
    CheckG -- ja --> S7["7. Doku/Indizes update<br/>(falls Vertrag berührt)"]
    S7 --> S8["8. Bericht:<br/>Sensors + Restrisiken"]
    S8 --> Done([Handoff an Reviewer])
```

Zwei Rücksprungkanten sind didaktisch wesentlich: 5→4 und 6→4. Nicht
zurück zu Schritt 1 — der Plan wird *verfeinert*, nicht der Kontext neu
gelesen.

## Hard Rules (repo-spezifisch)

Negativregeln, die der Agent nie brechen darf. Eine gute Hard Rule hat
*Falsch/Richtig*-Beispiele **und** eine *technische Begründung*.
Beispiele aus realen Repos (siehe
[`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)):

* **Docker-only** (grid-gym): kein lokales `.venv`, kein `pip install` außerhalb von Dockerfile-Stages.
  *Falsch:* `uv run python tools/foo.py`.
  *Richtig:* `docker compose run --rm test-runner uv run python tools/foo.py`.
  *Begründung:* Toolchain-Reproduzierbarkeit + Supply-Chain-Defense.
* **`# noqa` ist verboten** (grid-gym): bricht das `noqa-gate` in `make gates`. Ausnahmen werden in `pyproject.toml` mit Begründung dokumentiert.
* **Suppression-Verbot pro Sprache** — derselbe Mechanismus, andere Syntax:
  * Python: `# noqa` (grid-gym `noqa-gate`)
  * Go: `//nolint`
  * C#: `#pragma warning disable`, `[SuppressMessage]` (bess-ems `solid-suppression-gate`)
  * Kotlin: `@Suppress("...")`
  * Java: `@SuppressWarnings("...")`
  In jeder Sprache gilt: Inline-Suppression bricht das Suppression-Gate; Ausnahmen wandern in eine zentrale Konfigurations-Datei mit Begründung.
* **git mv + Inhaltsänderung = zwei Commits** (grid-gym): erst reiner `git mv` (Git erkennt R-Rename), dann Inhalt umschreiben.
  *Begründung:* Sonst fällt die Rename-Detection unter die 50 %-Similarity-Schwelle und `git log --follow` wird unzuverlässig.
* **Architektur ist sprach- und meilensteinfrei** (grid-gym, c-hsm-doc): `spec/architecture.md` referenziert ADRs und Modul-Pfade, aber keine Wellen, Slices oder Closure-Daten. Die zeitliche Schicht lebt in `docs/plan/planning/`.
* **Optimierer darf nie direkt aufs Gerät schreiben** (bess-ems-Klasse): Output fließt durch Statemachine, Constraint-Limiter, Ramp-Limiter.
* **Gates dürfen nicht ohne ADR gelockert werden**: jede Schwellen-Senkung ist ein ADR, kein PR-Kommentar.

Hard Rules sind *computational + inferential feedforward* zugleich: sie
stehen in AGENTS.md (Agent liest sie) **und** werden idealerweise durch
eine Fitness Function geprüft (Linter schlägt an). Wenn nur eines von
beiden existiert, ist die Regel nur halb durchgesetzt.

## Typische Fehlvorstellungen

- **"Agent liefert schnell, also ist der Workflow Overhead."** — Geschwindigkeit ohne Plan produziert Diffs, die später als Review-Last anfallen. Plan + Diff + Code kostet 20 % länger und spart 50 % Review.
- **"Hard Rules schreibe ich in AGENTS.md, und das reicht."** — Eine Hard Rule, die nur in AGENTS.md steht (inferential feedforward), ist halbgesetzt. Erst mit Fitness Function (computational feedback) ist sie *durchgesetzt*. Beides ist Pflicht.
- **"Wenn die Tests grün sind, ist der Slice fertig."** — Schritt 8 verlangt einen Bericht über *Sensors und verbleibende Risiken*. Grüne Tests sind notwendig, nicht hinreichend.
- **"Die Pre-completion Checklist ist Bürokratie."** — Sie ist der einzige Schritt, der vor Übergabe an Reviewer/Verifier eine *Selbstaussage* erzwingt. Wer keinen Selbst-Check macht, lädt jedes Risiko in die nächste Rolle.

## Übungen

* Implementierung eines Features aus einem Slice-Plan
* Lass den Agenten ohne ADR-Kontext laufen und vergleiche mit dem Lauf *mit* ADR-Kontext
* Formuliere drei Hard Rules für ein Beispiel-Repo und prüfe, ob mindestens eine maschinell durchsetzbar ist

### Minimaler Übungspfad

```bash
cd lab/example
make agent-implement SLICE=slice-009
```

Erwartete Beobachtung: Das Target erzeugt keinen Code. Es zeigt das
Kontextpaket, das ein Implementation-Agent vor dem Plan lesen muss. Erst
wenn du dieses Paket benennen kannst, ist der freie Agentenlauf sinnvoll.

Nach den Übungen: [Reflexionsvorlage](../grundlagen/reflexion-vorlage.md).

## Selbstcheck

* **(Erinnern)** Nenne die acht Schritte des Minimal Agent Workflow in Reihenfolge.
* Welche Eingaben braucht ein Implementation-Agent minimal, um nicht zu halluzinieren?
* Wann ist ein Implementation-Agent fertig — wenn der Code kompiliert, oder wenn die DoD erfüllt ist?
* Welche deiner Hard Rules wandert in welche Quadranten der 2×2-Matrix?
* **(Anwenden)** Welcher Schritt des 8-Schritt-Workflows ist in deinem eigenen Repo heute am schwächsten verankert — und woran erkennst du das?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Acht Workflow-Schritte in Reihenfolge? | fünf oder weniger genannt | (1) `harness/README.md` lesen · (2) kanonische Quelle · (3) Requirement-/ADR-IDs · (4) kleinste Änderung planen · (5) engster Sensor · (6) `make gates` · (7) Doku/Indizes · (8) Bericht über Sensors + Restrisiken. | + Rücksprungkanten benannt: 5→4 und 6→4 (Plan wird *verfeinert*, nicht Kontext neu gelesen). Wer rückläufig zu Schritt 1 springt, hat keinen Plan-Defekt, sondern einen Kontext-Defekt — das ist eine andere Ursache. |
| Minimale Eingaben gegen Halluzination? | "Klare Anweisung." | `harness/README.md` + relevante kanonische Quelle + Requirement/ADR-IDs + AGENTS.md + Tool-Allowlist. | + Hinweis Lopopolo: "anything it can't access in-context doesn't exist" — fehlende Eingaben werden *durch Raten ersetzt*, nicht durch Schweigen. |
| Fertig: Code kompiliert oder DoD erfüllt? | "DoD." | DoD-erfüllt + Schritt 8 ausgeführt (Bericht über Sensors + Restrisiken). Kompilierender Code ist notwendig, nicht hinreichend. | + Folge: ohne Schritt-8-Bericht wird jedes Risiko in die nächste Rolle (Reviewer/Verifier) verlagert — das bricht die Kontext-Trennung der Rollen. |
| Hard Rules ↔ Quadranten der 2×2-Matrix? | "Inferentielle Feedforward." | Jede Hard Rule liegt in *zwei* Quadranten: inferential feedforward (steht in AGENTS.md) + computational feedback (Fitness Function/Linter-Gate). | + Hard Rule nur in einem Quadranten ist halb durchgesetzt; nur in AGENTS.md vergisst der Agent sie unter Druck, nur als Fitness Function ohne AGENTS.md-Eintrag versteht der Agent das *Warum* nicht. |
| Schwächster Schritt im eigenen Repo? | konkret benannt, aber ohne Beleg | Konkret benannter Schritt (z. B. Schritt 7: Doku-Update bleibt liegen) + Beleg (z. B. `harness/README.md` wurde seit 6 Wochen nicht angepasst, obwohl drei Gate-Targets sich änderten). | + Steering-Loop-Eintrag formuliert: was im Harness verändert wird, damit Schritt X beim nächsten Lauf nicht mehr schwächster Schritt ist (z. B. Doku-Konsistenz-Agent als Drift-Sensor, Modul 14). |

## Weiterlesen

* 2×2-Matrix für Quadranten-Zuordnung: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)
* Nächstes Modul: [Modul 9 — Review Harness](../04-qualitaet/modul-09-review-harness.md)
