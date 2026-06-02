# Modul 14 — Observability

> **Aufwand:** ca. 75 Min Lesen · 90 Min Übung.

## Engage

Buchhaltung fragt: *"Was hat der KI-Slice SL-024 gekostet?"* Du weißt:
es waren Modell-X-Tokens, aber wie viele und in welcher Verteilung über
die acht Tool-Calls? Wenn du nicht antworten kannst, bist du in einer
Klasse von KI-Projekten, die spätestens beim zweiten Kostenreport gestoppt
werden. Token-Attribuierung ist nicht Bonus — sie ist Voraussetzung,
damit KI-Slices als reguläre Engineering-Slices behandelt werden können.

## Lernziele

Nach diesem Modul kannst du:

* OpenTelemetry-Traces eines Agentenlaufs *lesen* (Anwenden),
* Token-Kosten pro Slice *attribuieren* (Anwenden),
* Logs, Metriken und Traces *unterscheiden* und ein Telemetrie-Fehlszenario *zuordnen* (Analysieren),
* einen Prompt-Cache-Miss in den Metriken *erkennen* (Analysieren),
* Doku-Konsistenz-Drift mit einem Konsistenz-Agent *detektieren* (Bewerten — Brücke zu *Entropy Management*).

## Lab-Bezug

* `otel/`, lokaler Collector im Compose-Setup
* `make trace RUN=<id>`

## Themen

* OpenTelemetry
* Logs (was passierte)
* Metriken (wie oft, wie schnell)
* Traces (wer rief wen)
* Kostenkontrolle (Token, Modell, Cache-Hit)
* Doku-Konsistenz-Agent (AGENTS.md ↔ Code) als Drift-Detector

## Harness-Einordnung

Observability ist Eingangs- und Ausgangskanal für *Entropy Management*
(siehe [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)):
ohne Telemetrie weißt du nicht, wo der Harness rostet.

## Kernidee

Ein Agenten-Lauf ohne Trace ist ein Vorgang ohne Beleg. Du weißt, dass
es passiert ist; du weißt nicht, *was* passiert ist.

## Typische Fehlvorstellungen

- **"Logs reichen."** — Logs sagen *was passierte*, nicht *wer wen wann rief*. Trace ist die Antwort darauf.
- **"Metriken sind nur für Performance."** — Metriken sind auch für *Kosten* (Token, Cache-Hit-Rate) und *Drift* (AGENTS.md-Konsistenz-Score).
- **"Prompt-Caching ist Modell-Sache."** — Nein. Cache-Hits zeigen sich erst in Metriken, wenn du sie misst. Wer Cache-Miss-Spikes nicht beobachtet, sieht Injection-Versuche und Drift-Symptome nicht.
- **"Trace teurer Tool-Call ≠ unnötiger Tool-Call."** — Manche teuren Calls sind nötig. Frage: lässt er sich durch Caching, Vorab-Filter oder Kontext-Verdichtung billiger machen?

## Übungen

* Analyse eines KI-Agenten-Laufs im Trace-Viewer
* Identifiziere den teuersten Tool-Call und begründe, ob er nötig war

Nach den Übungen: [Reflexionsvorlage](../grundlagen/reflexion-vorlage.md).

## Selbstcheck

* Welche drei Felder muss ein Tool-Call-Span mindestens tragen?
* Wo schlägt sich ein Prompt-Cache-Miss in den Metriken nieder?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Drei Mindestfelder eines Tool-Call-Spans? | "Name, Zeit, Ergebnis." | `tool.name`, `tool.arguments` (redacted), `tool.result.status` plus Korrelations-IDs zu Slice/PR/Agent-Rolle. | + Begründung: Ohne `slice.id` / `requirement.id` ist Token-Attribuierung pro Slice nicht möglich; ohne `agent.role` bricht die Rollen-Trennung in der Forensik. |
| Prompt-Cache-Miss in den Metriken — wo? | "In den Kosten." | Anstieg der Token-Eingabe-Metrik *ohne* Anstieg der Cache-Hit-Rate-Metrik (`cache.hit_ratio` fällt). | + Zweck: Cache-Miss-Spikes sind oft Injection-Symptome (variable Eingaben umgehen Cache absichtlich) — Metrik dient also gleichzeitig Kosten- *und* Sicherheitsüberwachung. |

## Weiterlesen

* Nächstes Modul: [Modul 15 — Produktiver Betrieb](modul-15-produktiver-betrieb.md)
