# Modul 1 — Der Entwicklungszyklus

> **Aufwand:** ca. 60 Min Lesen · 60 Min Übung.

## Engage

Drei Stunden Diskussion mit deinem Reviewer-Agent, am Ende setzt er den
PR auf "approve". Eine Woche später läuft Verifikation rot, weil das
Feature gegen ADR-3 verstößt. *Warum ist Review grün und Verifikation
rot?* Antwort am Ende dieses Moduls — und sie liegt im Diagramm unten.

## Lernziele

Nach diesem Modul kannst du:

* den Lebenszyklus Spec → ADR → Plan → Code → Review → Verifikation → Closure als gerichteten Graphen *zeichnen* (Anwenden),
* sechs Artefakte und sechs Rollen einander *zuordnen* und Kreuzungen *begründen* (Analysieren),
* die Traceability-Kette für einen realen Slice *prüfen* (Analysieren),
* eine Source Precedence für ein eigenes Repo *entwerfen* (Erschaffen).

## Lebenszyklus als Diagramm

```mermaid
flowchart LR
    Spec["spec/<br/>(was?)"] --> ADR["ADR<br/>(warum so?)"]
    ADR --> Plan["Slice-Plan<br/>(wann/wie?)"]
    Plan --> Code["Code"]
    Code --> Review["Review<br/>(gegen Plan/ADR)"]
    Review --> Verify["Verifikation<br/>(gegen DoD/Spec)"]
    Verify --> Closure["Closure<br/>(done/)"]
    Closure -. Lerneintrag .-> Spec
    Closure -. Lerneintrag .-> ADR
    Review -. Folge-ADR .-> ADR
    Verify -. Spec-Lücke .-> Spec
```

Die durchgezogenen Pfeile sind der *Vorwärtspfad* (was wird gebaut), die
gestrichelten der *Rückwärtspfad* (was lernt der Harness daraus). Beide
Richtungen sind Pflicht — eine Kette ohne Rückverweise ist nicht
auditierbar.

**Auflösung des Engage-Falls:** Review prüft Code gegen *Plan und ADR*.
Wenn der Plan die ADR-Verletzung nicht antizipiert hat, sieht Review
sie nicht. Verifikation prüft Code gegen *DoD und Spec* (und dort
referenzierte ADRs). Das ist genau der Grund, warum Review und
Verifikation getrennte Rollen sind — siehe [Modul 7](../03-agenten/modul-07-agentenrollen.md).

## Lab-Bezug

* `docs/plan/planning/in-progress/roadmap.md`
* Verzeichnisstruktur des Begleit-Repos (siehe [`../grundlagen/konventionen.md`](../grundlagen/konventionen.md))

## Themen

* Lebenszyklus
* Rollen
* Verantwortlichkeiten
* Artefakte
* Traceability

## Kernidee

Jedes Artefakt verweist nach oben (Begründung) und nach unten
(Konsequenz). Eine Kette ohne Rückverweise ist nicht auditierbar.

## Typische Fehlvorstellungen

- **"Plan ist nur eine Liste von Tickets."** — Plan ist die Stelle, an der Spec und ADR auf einen Code-Diff zusammenfallen. Ohne Bezugs-IDs zu Spec/ADR ist der Plan nicht prüfbar (und damit kein Plan, sondern eine Liste).
- **"Closure ist Schließen des Tickets."** — Closure verlangt einen Lerneintrag im Slice. Ohne Lerneintrag wird die Welle nicht "fertig", sondern nur "weg".
- **"Source Precedence kann man später festlegen."** — Wer das erste Mal ein Konflikt zwischen AGENTS.md und Spec hat und dann erst überlegt, hat den Konflikt bereits in den Code laufen lassen.

## Übungen

* Zeichne den Zyklus für ein Mini-Feature auf einem Blatt
* Identifiziere im Begleit-Repo einen Slice und folge der Kette Spec → ADR → Plan → PR
* Schreibe einen Source-Precedence-Block für ein eigenes Repo als ersten Abschnitt einer neuen `harness/README.md` (Vorlage in [`/lab/templates/harness/README.template.md`](../../../lab/templates/harness/README.template.md))

Nach den Übungen: [Reflexionsvorlage](../grundlagen/reflexion-vorlage.md).

## Selbstcheck

* Welche Information darf nur in der Spec stehen, welche nur im ADR?
* Was passiert, wenn ein Slice fertig ist, aber kein Closure-Eintrag existiert?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Spec vs. ADR — wo welche Info? | "Spec = was, ADR = warum." | Spec = vertragliche Anforderung mit Akzeptanzkriterien; ADR = Lösungsbegründung; Bezug per ID. | + Spec-Stratifizierung (Lastenheft/Spezifikation/Architektur), inkl. Regel "ADR darf Spezifikation, nicht Lastenheft schärfen". |
| Slice fertig, aber kein Closure-Eintrag? | "Ist nicht fertig." | Slice gilt nicht als `done/`, weil Lerneintrag fehlt; Welle kann nicht schließen. | + Folge für Steering Loop: ohne Closure-Eintrag wird das Versagensmuster nicht beobachtbar, also wird derselbe Fehler dreimal gemacht (Lücke wird unsichtbar). |

## Weiterlesen

* Source Precedence im Detail: [`../grundlagen/konventionen.md#source-precedence`](../grundlagen/konventionen.md#source-precedence)
* Nächstes Modul: [Modul 2 — Lastenheft und Spezifikation](modul-02-lastenheft.md)
