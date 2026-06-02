# Modul 5 — Roadmap Engineering

> **Aufwand:** ca. 45 Min Lesen · 60 Min Übung. Dieses Modul ist absichtlich kurz — die Tiefe liegt in [Modul 4 (Slice-Schnitt)](modul-04-planning-harness.md) und [Modul 6 (Carveouts)](modul-06-carveouts.md).

## Engage

Frage an drei Tech Leads: *"Wann ist Welle 3 fertig?"* — Antwort A:
*"Am 30. Juni."* Antwort B: *"Wenn SL-024 und SL-027 in done/ liegen
und der Replay-Lauf grün ist."* Antwort C: *"Wenn das Team durch ist."*
Welche Antwort ist eine Roadmap? Genau eine. Die anderen sind Wunsch
oder Status.

## Lernziele

Nach diesem Modul kannst du:

* eine Roadmap als Reihenfolge von Wellen mit Triggern *aufbauen* (Erschaffen),
* Welle ↔ Meilenstein ↔ Release sauber *unterscheiden* (Verstehen),
* eine Welle, die 30 % über Schätzung liegt, *bewerten* (neu schneiden / neu planen / Carveout) (Bewerten),
* Welle-Abhängigkeiten *modellieren* und Blocker *identifizieren* (Analysieren).

## Lab-Bezug

* `docs/plan/planning/in-progress/roadmap.md`

## Themen

* Meilensteine
* Releases
* Fortschrittskontrolle
* Abhängigkeiten zwischen Wellen

## Kernidee

Eine Roadmap ist eine Reihenfolge von Wellen, keine Reihenfolge von
Terminen. Termine sind eine Folge der Wellen, nicht ihr Treiber.

## Typische Fehlvorstellungen

- **"Roadmap ist eine Datumsleiste."** — Datum ist Output, nicht Input. Wer Datumsleisten plant, plant Wunschdenken.
- **"Burndown ist Fortschritt."** — Burndown ist *Tempo*. Fortschritt ist, ob die Welle das verspricht, was sie sollte.
- **"Eine Roadmap ist statisch."** — Eine Roadmap, die nach drei Wellen nicht angepasst wurde, hat den Steering Loop nicht durchlaufen.
- **"Welle = Sprint."** — Ein Sprint endet durch *Datum* (zwei Wochen sind um). Eine Welle endet durch *Closure-Kriterien* (alle ihre Slices in `done/`, Replay-Lauf grün, Closure-Einträge geschrieben). Wer Wellen wie Sprints schneidet, kappt halbfertige Slices am Datum — und produziert genau die Auditierbarkeits-Lücke, die der Harness verhindern soll.
- **"Trigger = Datum."** — Ein Trigger ist eine *beobachtbare Bedingung* ("SL-024 liegt in `done/`", "Replay-Lauf gegen Golden Set grün", "Carveout `CO-007` aufgelöst"). Ein Datum ist kein Trigger, sondern eine Prognose. Wenn das einzige Trigger-Kriterium ein Kalendertag ist, plant die Roadmap nicht — sie hofft.

## Übungen

* Aufbau einer produktiven Roadmap für das Begleit-Lab
* Modelliere eine Abhängigkeit, die eine spätere Welle blockiert

Nach den Übungen: [Reflexionsvorlage](../grundlagen/reflexion-vorlage.md).

## Selbstcheck

* **(Erinnern)** Welche drei Bestandteile braucht ein Welle-Eintrag minimal, damit "fertig" beobachtbar wird?
* Was tust du, wenn eine Welle 30 % über der Schätzung liegt — neu schneiden, neu planen oder Carveout?
* Was unterscheidet eine Welle von einem Meilenstein?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Drei Bestandteile eines Welle-Eintrags? | "Slices und Datum." | Slice-IDs (Inhalt) · Trigger als beobachtbare Bedingung (kein Datum) · Closure-Kriterien (z. B. Replay grün, alle Slices in `done/`). | + Datum darf *erwähnt* werden (Prognose), darf aber nie Trigger sein — sonst kappt die Welle halbfertige Slices am Kalendertag und das Auditierbarkeits-Versprechen bricht. |
| Welle 30 % über Schätzung — was tun? | "Mehr Zeit geben." | Diagnose vor Aktion: liegt es an Slice-Größe (→ neu schneiden), an Reihenfolge (→ neu planen), oder an unerwarteter Komplexität (→ Carveout)? | + Hinweis, dass 30 % früh ein Steering-Loop-Signal sein können (Slice-Sizing-Regel schärfen), 30 % spät (vor Welle-Closure) eher Carveout. |
| Welle vs. Meilenstein? | "Größe." | Welle = Bündel paralleler/serialisierter Slices mit Closure-Kriterien. Meilenstein = extern beobachtbarer Zustand (Release, Audit-Punkt). | + Eine Welle endet *durch* Closure-Kriterien; ein Meilenstein endet durch *Datum oder externe Bestätigung* — und genau deshalb leitet sich der Meilenstein aus Wellen ab, nicht umgekehrt. |

## Weiterlesen

* Nächstes Modul: [Modul 6 — Carveout Management](modul-06-carveouts.md)
