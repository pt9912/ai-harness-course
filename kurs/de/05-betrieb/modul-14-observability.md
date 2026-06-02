# Modul 14 — Observability

## Lernziele

* OpenTelemetry-Traces eines Agentenlaufs lesen
* Token-Kosten pro Slice attribuieren
* Logs, Metriken und Traces für Agenten unterscheiden

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

## Übungen

* Analyse eines KI-Agenten-Laufs im Trace-Viewer
* Identifiziere den teuersten Tool-Call und begründe, ob er nötig war

## Selbstcheck

* Welche drei Felder muss ein Tool-Call-Span mindestens tragen?
* Wo schlägt sich ein Prompt-Cache-Miss in den Metriken nieder?

## Weiterlesen

* Nächstes Modul: [Modul 15 — Produktiver Betrieb](modul-15-produktiver-betrieb.md)
