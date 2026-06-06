# Kurs: KI-Agenten-gestützter Entwicklungsprozess

Ein praxisorientierter Kurs für Spezifikation, Planung, Implementierung,
Review, Verifikation und Quality Gates mit KI-Agenten.

Das Besondere an diesem Kurs: Er lehrt nicht, wie man einen KI-Agenten
benutzt, sondern wie man einen **vollständigen, auditierbaren
Entwicklungsprozess mit KI-Agenten** aufbaut und betreibt.

Der Begriff *Harness Engineering* hat zwei prägende Quellen — Birgitta
Böckeler (Thoughtworks) für den konzeptuellen Rahmen und Ryan Lopopolo
(OpenAI) für das empirische Playbook. Beide werden in
[`grundlagen/klassifikation.md`](grundlagen/klassifikation.md)
eingeführt und in [`abschluss/quellen.md`](abschluss/quellen.md) belegt.

## Zielgruppe

* Softwareentwickler
* Softwarearchitekten
* Tech Leads
* DevOps Engineers
* KI-Plattform-Teams

Voraussetzungen:

* Git
* Docker
* Grundlagen von Softwarearchitektur
* Grundkenntnisse in mindestens einer Programmiersprache
* Grundverständnis von LLMs als Black Box (Prompt rein, Text raus)

## Voraussetzungscheck

Bevor du in [Modul 0](00-einfuehrung/modul-00-einfuehrung.md) startest,
solltest du die folgenden Aufgaben ohne längere Recherche lösen können:

1. Lege ein Git-Repository an, erstelle einen Feature-Branch, committe eine Änderung, öffne einen Pull Request.
2. Schreibe ein Dockerfile, das eine Toolchain reproduzierbar bereitstellt, und baue das Image lokal.
3. Lies einen LLM-Tool-Call-Trace (Input · Tool-Call · Tool-Result · Output) und benenne die vier Bestandteile.
4. Formuliere für eine Funktion deiner Wahl drei Akzeptanzkriterien im Given/When/Then-Stil.
5. Erkläre den Unterschied zwischen Linter, Typecheck und Integrationstest.

Wenn dir 1–2 schwerfallen, hole Git- und Docker-Grundlagen vor Modul 0
nach. Wenn 3 neu ist, sieh dir vor [Phase 3 (Agenten)](03-agenten/)
einen kommentierten Agenten-Lauf an. Wenn 4–5 unklar sind, plane für
[Phase 1 (Spec)](01-spec-und-architektur/) und
[Phase 4 (Qualität)](04-qualitaet/) mehr Zeit ein.

### Vorab-Lektüre (Pflicht)

Bevor du Modul 0 öffnest, lies einmal — auch wenn die Begriffe noch
fremd wirken:

1. [`grundlagen/konzeptkarte.md`](grundlagen/konzeptkarte.md) — Artefaktkette und vier Leitfragen.
2. [`grundlagen/klassifikation.md`](grundlagen/klassifikation.md) §2×2-Matrix — die ersten zwei Bildschirmseiten reichen.

Ab Modul 0 verlangen die Reflexionsblöcke eine Quadranten-Zuordnung
(Computational/Inferential × Feedforward/Feedback). Wer die 2×2-Matrix
nicht einmal gesehen hat, kann die Reflexion nicht ausfüllen — und die
Reflexion ist nach der Pass-Through-Logik die teuerste Stelle, die zu
überspringen.

### Selbst-Diagnose: vom Voraussetzungscheck zur Phase

Die Items oben sind nicht symmetrisch; sie zeigen auf unterschiedliche
Phasen des Kurses. Wenn du beim Check stolperst, kannst du die
[Pass-Through-Tabelle](grundlagen/checkpoints.md#pass-through-logik-zum-abschlussprojekt)
nutzen, um die Phase mit der zu erwartenden schwächsten Abschluss-Achse
schon vor Modul 0 zu identifizieren:

| Voraussetzungs-Item | Schwierigkeit dort sagt voraus | Erwartete Schwäche im Abschluss |
|---|---|---|
| 1 (Git/PR) | wenig | — (Mindestschwelle) |
| 2 (Docker) | wenig–mittel | Reproduzierbarkeit |
| 3 (LLM-Trace) | mittel | Auditierbarkeit |
| 4 (Akzeptanzkriterien) | mittel–hoch | Vollständigkeit + Konsistenz |
| 5 (Linter/Typecheck/Integration) | mittel | Steering-Loop-Reife |

Diese Tabelle ist *probabilistisch*, kein Urteil. Sie sagt dir nur, *wo
du beim ersten Durchlauf wahrscheinlich Zeit investieren musst* — nicht,
was du erreichen kannst.

## Lernfortschritt

| Modul | Du solltest danach können ... |
|---|---|
| [0](00-einfuehrung/modul-00-einfuehrung.md) | Agent, LLM, Tool-Call, Harness und Chatbot-vs-Engineering-System trennscharf benennen |
| [1](01-spec-und-architektur/modul-01-entwicklungszyklus.md) | den Lebenszyklus Spec → ADR → Plan → Code → Review → Verifikation als Artefaktkette nachzeichnen |
| [2](01-spec-und-architektur/modul-03-lastenheft.md) | ein Lastenheft mit Akzeptanzkriterien schreiben, das von einem Agenten umsetzbar ist |
| [3](01-spec-und-architektur/modul-04-architektur-adrs.md) | Architekturentscheidungen so dokumentieren, dass spätere Agentenläufe sie als Constraint nutzen |
| [4](02-planung/modul-05-planning-harness.md) | Slices über die Lifecycle-Verzeichnisse `open → next → in-progress → done` bewegen |
| [5](02-planung/modul-06-roadmap.md) | eine Roadmap mit Wellen, Triggern und Closure-Kriterien aufbauen |
| [6](02-planung/modul-07-carveouts.md) | Carveouts (temporär/permanent) sauber dokumentieren und mit Folge-Slices verknüpfen |
| [7](03-agenten/modul-08-agentenrollen.md) | Aufgaben zwischen Planner-, Architect-, Implementation-, Reviewer-, Verification- und Validation-Agent zuordnen |
| [8](03-agenten/modul-09-implementierung.md) | einen Slice mit einem Implementation-Agent umsetzen und die Architekturkonformität wahren |
| [9](04-qualitaet/modul-10-review-harness.md) | Findings nach HIGH/MEDIUM/LOW/INFO klassifizieren und einen Review-Lauf reproduzierbar machen |
| [10](04-qualitaet/modul-11-verification.md) | Plan-gegen-Code-Diffs automatisch verifizieren und DoD-Verletzungen erkennen |
| [11](04-qualitaet/modul-12-replay-evaluierung.md) | Replay-Läufe mit Golden Sets fahren und Regressionen messen |
| [12](04-qualitaet/modul-13-quality-gates.md) | Quality Gates als `make`-Ziele aufsetzen, im CI verankern, als computational feedback klassifizieren |
| [13](05-betrieb/modul-14-docker-harness.md) | einen Docker-only Build-Harness aufbauen, der lokal und im CI identisch läuft |
| [14](05-betrieb/modul-15-observability.md) | OpenTelemetry-Traces eines Agentenlaufs lesen und Token-Kosten attribuieren |
| [15](05-betrieb/modul-16-produktiver-betrieb.md) | ein Projekt für den produktiven Betrieb freigeben (Runtime-Validation, Security, Incident Response) |

## Wegweiser

| Bereich | Inhalt |
|---|---|
| [`grundlagen/`](grundlagen/) | Begriffe, Source Precedence, **Konzeptkarte**, 2×2-Klassifikation, drei Säulen, Steering Loop, vier Fallstudien, **Lernpfade**, **Reflexions­vorlage**, **Lernervorstellungen**, **Phasen-Checkpoints** — vor den Modulen zu lesen. |
| [`00-einfuehrung/`](00-einfuehrung/) | Modul 0: Worum geht es überhaupt? |
| [`01-spec-und-architektur/`](01-spec-und-architektur/) | Module 1–3: Lebenszyklus, Lastenheft, ADRs. |
| [`02-planung/`](02-planung/) | Module 4–6: Planning-Lifecycle, Roadmap, Carveouts. |
| [`03-agenten/`](03-agenten/) | Module 7–8: Rollen und Implementierung. |
| [`04-qualitaet/`](04-qualitaet/) | Module 9–12: Review, Verifikation, Replay, Gates. |
| [`05-betrieb/`](05-betrieb/) | Module 13–15: Docker-Harness, Observability, Produktion. |
| [`abschluss/`](abschluss/) | Abschlussprojekt mit Bewertungsraster, Quellen, Branchen-Anwendungsanker. |

## Lernpfade je nach Rolle

Alle Module sind sinnvoll, aber Vertiefung lohnt je nach Rolle anders.
Drei empfohlene Schwerpunkt-Pfade in [`grundlagen/lernpfade.md`](grundlagen/lernpfade.md):

- **Pfad A** für Architects/Tech Leads: Spec-Disziplin, ADRs, Verifikation, Architecture Fitness.
- **Pfad B** für DevOps/KI-Plattform: Gates, Reproduzierbarkeit, Observability, Incident Response.
- **Pfad C** für implementierende Entwickler: Agentenbedienung, Reviews, Hard Rules.

## Selbstdiagnose zwischen Phasen

[`grundlagen/checkpoints.md`](grundlagen/checkpoints.md) enthält
Mini-Checkpoints zwischen den Phasen (A nach Spec/Architektur, B nach
Planung, C nach Agenten, D nach Qualität). Jeder Checkpoint ist eine
kleine, konkrete Aufgabe mit Selbsttest — gedacht als Stolperstein
*bevor* das Abschlussprojekt überfordert.

## Arbeitsweise

Jedes Modul folgt demselben Aufbau (Details in
[`grundlagen/README.md`](grundlagen/README.md)):

1. **Lernziele** — was kannst du danach.
2. **Lab-Bezug** — welche Verzeichnisse, Make-Targets oder Artefakte gehören dazu.
3. **Themen** — die Konzepte des Moduls.
4. **Kernidee** — die eine Aussage, an der das Modul hängt.
5. **Übungen** — Hands-on, mindestens eine mit absichtlichem Fehlerfall.
6. **Selbstcheck** — Fragen, die du nach dem Modul beantworten können solltest.

Für Selbststudium ist ein Modul auf ca. 90 Minuten Lesen plus 60 Minuten
Übung ausgelegt.
