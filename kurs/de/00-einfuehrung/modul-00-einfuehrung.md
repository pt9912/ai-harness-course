# Modul 0 — Einführung

> **Aufwand:** ca. 45 Min Lesen · 60 Min Übung. Optional vorgeschaltet: [Hello-Harness](hello-harness.md) (30 Min Hands-on).

## Engage

Du hast einen Agenten gebaut, der gestern ein Ticket sauber erledigt hat.
Heute gibt er für *dasselbe* Ticket eine andere Antwort. Hast du einen
Bug — oder einen Harness-Mangel? Genau diese Frage trennt Chatbots von
Engineering-Systemen, und sie ist der Grund, warum dieser Kurs existiert.

## Mini-Glossar für diesen Einstieg

Das vollständige Glossar steht in
[`../grundlagen/konventionen.md`](../grundlagen/konventionen.md#kernbegriffe).
Für die ersten Seiten reichen die folgenden acht Begriffe — jeweils ein
Satz, ein Bild im Kopf:

| Begriff | Ein-Satz-Definition | Bild im Kopf |
|---|---|---|
| **LLM** | Modell, das Text-Eingabe in Text-Ausgabe abbildet — *stateless*. | eine Funktion: rein Text, raus Text. |
| **Tool-Call** | Strukturierter Aufruf einer Funktion durch das LLM (`name`, `arguments`, `result`). | das LLM zeigt mit dem Finger und sagt: *"führe das aus"*. |
| **Agent** | LLM + Tools + Schleife. Hält Zustand über mehrere Turns. | LLM, das nicht nur antwortet, sondern *handelt*. |
| **Harness** | Alles am Agenten *außer* dem Modell — Spec, ADRs, Tools, Gates, Telemetrie. | das Geschirr um das Modell, das es lenkt. |
| **Chatbot** | Agent oder LLM mit Fokus auf *Antwort*. | Gespräch. |
| **Engineering-System** | Agent + Harness mit Fokus auf *reproduzierbares, auditierbares Handeln*. | Lieferprozess. |
| **Halluzination** | Plausibles, aber falsches Ausgabe-Stück — meist Folge fehlender Information *im Kontext*. | der Agent *rät*, weil ihm niemand widerspricht. |
| **Reproduzierbarkeit / Auditierbarkeit** | Reproduzierbar: zweimal dasselbe → zweimal dasselbe. Auditierbar: jede Entscheidung lässt sich zurückverfolgen. | "Was ist passiert?" hat eine eindeutige Antwort. |

Lies das einmal langsam durch. Die acht Begriffe sind das gesamte
Vokabular, das du brauchst, um den Rest des Moduls *ohne weitere
Nachschlag-Schleifen* zu lesen.

## Lernziele

Nach diesem Modul kannst du:

* Agent, LLM und Tool-Call *trennscharf benennen* (Verstehen),
* Chatbot von Engineering-System anhand mindestens dreier Kriterien *unterscheiden* (Analysieren),
* drei typische Scheitermuster von KI-Projekten *identifizieren* und mindestens eines davon einem Quadranten der 2×2-Matrix *zuordnen* (Analysieren),
* den Begriff *Harness* nach Böckeler *einordnen* und gegen "Prompt Engineering" *abgrenzen* (Bewerten).

## Lab-Bezug

* [`../../../lab/example/evals/example-trace.json`](../../../lab/example/evals/example-trace.json) — kommentierter Minimal-Trace
* [`../../../lab/example/docs/glossar.md`](../../../lab/example/docs/glossar.md) — kleines Kurs-Glossar am DocSearch-Beispiel

## Themen

* Was sind KI-Agenten?
* Warum viele KI-Projekte scheitern
* Grenzen von Prompt Engineering
* Der Unterschied zwischen Chatbot und Engineering-System
* LLM vs. Agent vs. Workflow

## Kernidee

Ein Chatbot antwortet. Ein Agent handelt. Engineering-Systeme handeln
**reproduzierbar** und **auditierbar** — das ist nicht dasselbe wie
"antwortet besser". Der Harness ist genau das System, das aus einem
handelnden Agenten einen reproduzierbar handelnden Agenten macht.

## Typische Fehlvorstellungen

- **"Wir brauchen erst ein besseres Modell."** — In den dokumentierten Scheitenfällen war meist nicht das Modell die Ursache, sondern eine Spec-Lücke oder ein fehlender Sensor. Das Modell rät, *weil nichts in der Eingabe widerspricht*. Lopopolo (OpenAI 2026) und die Fallstudien in [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md) belegen das.
- **"Wir bauen einen Mega-Prompt."** — Der Prompt wird zur Anti-Spec, die niemand pflegt. Was in *jedem* Lauf relevant ist, gehört in AGENTS.md oder eine Fitness Function, nicht in den Prompt.
- **"Der Agent muss nur freier entscheiden dürfen."** — Genau das macht Auditierbarkeit unmöglich. Engineering-Systeme sind *reproduzierbar*, nicht kreativ.

## Übungen

* Analyse eines fehlgeschlagenen KI-Projekts (Vorlage:
  [`../../../lab/example/exercises/00-postmortem.md`](../../../lab/example/exercises/00-postmortem.md))
* Provoziere absichtlich eine Halluzination, dokumentiere den Trigger

Nach beiden Übungen: [Reflexionsvorlage](../grundlagen/reflexion-vorlage.md) durchlaufen.

## Selbstcheck

* **(Erinnern)** Welche drei Bestandteile hat ein Tool-Call laut Mini-Glossar?
* Wo verläuft die Grenze zwischen "guter Prompt" und "guter Harness"?
* Welche Fehlermodi eines Agenten kann ein Linter *nicht* fangen?

### Selbstcheck-Rubrik

Schema in [`../grundlagen/selbstcheck-rubrik.md`](../grundlagen/selbstcheck-rubrik.md). Drei Stufen pro Frage:

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Drei Bestandteile eines Tool-Calls? | "Name und Argumente." | `name`, `arguments`, `result` — strukturierter Aufruf einer Funktion durch das LLM. | + Anwendung: ohne `result`-Feld kann der Verifier den Lauf nicht reproduzieren; ohne `arguments` ist Token-Attribution unmöglich. Diese drei sind das Minimum, *bevor* Korrelations-IDs (Slice, Agent-Rolle) dazukommen — Modul 14 erweitert. |
| Grenze "guter Prompt" ↔ "guter Harness"? | "Harness ist umfangreicher." | Prompt verbessert *eine* Interaktion; Harness verbessert *jede zukünftige Interaktion derselben Klasse*. | + Test "wäre die Anweisung in *jedem* Lauf relevant?" und Verweis auf AGENTS.md/Fitness Function als Ablage. |
| Fehlermodi, die ein Linter *nicht* fängt? | "Semantik." | Drei Klassen: semantische Halluzination, ADR-Verstoß, Spec-Lücken-Symptom. | + zwei weitere (implizite Annahmen, Sicherheits-Anti-Pattern im Fremdkontext) und Zuordnung zu Sensor-Typen (Compiler/ArchUnit/Verifier/Replay/Security-Gate). |

## Weiterlesen

* Konzeptueller Rahmen: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)
* Nächstes Modul: [Modul 1 — Der Entwicklungszyklus](../01-spec-und-architektur/modul-01-entwicklungszyklus.md)
