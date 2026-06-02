# Modul 0 — Einführung

## Lernziele

* Agent, LLM und Tool-Call trennscharf benennen
* Chatbot von Engineering-System unterscheiden
* Typische Scheitermuster von KI-Projekten benennen
* Den Begriff *Harness* nach Böckeler einordnen ("alles am Agenten außer dem Modell")

## Lab-Bezug

* `evals/example-trace.json` — kommentierter Agenten-Lauf
* `docs/glossar.md`

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

## Übungen

* Analyse eines fehlgeschlagenen KI-Projekts (Vorlage in `exercises/00-postmortem.md`)
* Provoziere absichtlich eine Halluzination, dokumentiere den Trigger

## Selbstcheck

* Wo verläuft die Grenze zwischen "guter Prompt" und "guter Harness"?
* Welche Fehlermodi eines Agenten kann ein Linter *nicht* fangen?

## Weiterlesen

* Konzeptueller Rahmen: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)
* Nächstes Modul: [Modul 1 — Der Entwicklungszyklus](../01-spec-und-architektur/modul-01-entwicklungszyklus.md)
