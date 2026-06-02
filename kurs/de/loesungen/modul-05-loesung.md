# Lösung — Modul 5: Roadmap Engineering

Zugehöriges Modul: [Modul 5 — Roadmap Engineering](../02-planung/modul-05-roadmap.md).

## Selbstcheck-Antworten

### Was tust du, wenn eine Welle 30 % über der Schätzung liegt — neu schneiden, neu planen oder Carveout?

Es kommt darauf an, *warum* die Schätzung daneben lag. Drei Diagnosen,
drei Antworten:

1. **Scope ist gewachsen** (neue Anforderung im Lauf der Welle): → **Neu schneiden.** Der zusätzliche Scope wandert in eine eigene Welle oder einen eigenen Slice. Die aktuelle Welle wird auf den ursprünglichen Scope reduziert und kann normal schließen.
2. **Annahme war falsch** (z. B. "Bibliothek X liefert das schon" stellte sich als falsch heraus): → **Neu planen.** Die Welle bekommt einen neuen Plan mit korrigierter Annahme, dokumentiert als ADR-Update oder Carveout. Schätzung wird neu vorgenommen.
3. **Unvorhergesehene Komplexität in *einem* Slice der Welle** (Rest läuft): → **Carveout** für die problematische Stelle, Welle kann mit eingeschränktem Scope schließen, Carveout-Trigger im nächsten Sprint angesetzt.

Anti-Antwort: "Wir biegen die Schätzung gerade." Das macht den Steering
Loop unbrauchbar — wenn Schätzungen sich an Realität anpassen statt
umgekehrt, lernst du nichts über deine Schätzungsqualität.

## Übungshinweise

### Aufbau einer produktiven Roadmap für das Begleit-Lab

Maßstab:

- Mindestens drei Wellen, davon mindestens eine mit klar nachgelagerter Abhängigkeit ("Welle 2 startet erst, wenn Welle 1 done").
- Jede Welle hat einen *Trigger* (was muss vorher passiert sein) und einen *Closure*-Trigger (was muss erreicht sein, damit sie als done gilt).
- Jeder Slice in jeder Welle hat eine LH-/HSM-/GG-ID-Referenz (siehe [ID-Schema](../grundlagen/konventionen.md#id-schema-als-klammer)).
- Mindestens ein expliziter "Wir-tun-X-nicht-in-dieser-Welle"-Eintrag pro Welle. Negativ-Scope ist Roadmap-Disziplin.

Vergleich-Möglichkeit: [`/lab/example/docs/plan/planning/in-progress/roadmap.md`](../../../lab/example/docs/plan/planning/in-progress/roadmap.md)
(im Lab nach Phase B).

### Modelliere eine Abhängigkeit, die eine spätere Welle blockiert

Beispielszenario: Welle 2 ("LLM-gestützter Replay-Diff-Reporter")
braucht ein in Welle 1 definiertes Trace-Format. Wenn Welle 1 das
Trace-Format ändert, blockiert sie Welle 2.

Modellierung:

- Welle 2 deklariert in ihrem Plan: `Voraussetzung: Welle 1, Trace-Format-Vertrag (ADR-7)`.
- ADR-7 dokumentiert den Vertrag und nennt Welle 2 als Konsument.
- Wenn Welle 1 das Format ändern muss, ist das ein ADR-Update (ADR-7 superseded), und Welle 2 *muss* angepasst werden — als eigener Slice in Welle 2 oder als Carveout.

## Häufige Fehler

- **Roadmap als Datums-Versprechen verstehen.** Datum ist Folge der Wellen, nicht ihr Treiber. Wenn du Termine fest schreibst und Scope variabel hältst, lieferst du Scope-Kompromisse statt Lieferversprechen.
- **Wellen ohne Closure-Trigger.** "Welle ist done, wenn alle Slices done sind." Tautologie, kein Trigger. Was ist die *Beobachtung*, die das System grün meldet?
- **Implizite Abhängigkeiten zwischen Wellen.** Wenn die Reihenfolge "ist halt logisch", wird die Reihenfolge bei Druck umgekehrt — mit Folgen. Abhängigkeit gehört explizit in den Plan.

## Verweise

- Slice-Lifecycle: [Modul 4](../02-planung/modul-04-planning-harness.md)
- Vorherige Lösung: [Modul 4](modul-04-loesung.md)
- Nächste Lösung: [Modul 6](modul-06-loesung.md)
