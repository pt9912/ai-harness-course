# Modul 7 — Agentenrollen

## Lernziele

* Aufgaben zwischen den sechs Agentenrollen zuordnen
* Übergaben und Konfliktlösungen zwischen Rollen entwerfen

## Lab-Bezug

* `agents/{planner,architect,implementation,reviewer,verifier,validator}.md`
* Replay eines kompletten Rollendurchlaufs in `evals/`

## Themen

* Planner Agent
* Architect Agent
* Implementation Agent
* Reviewer Agent
* Verifier Agent (Verification)
* Validator Agent (Validation)
* Verantwortlichkeiten
* Übergaben
* Konfliktlösung (z. B. Reviewer findet ADR-Lücke)

## Kernidee

Rollentrennung verhindert, dass derselbe Kontext zweimal denselben Fehler
macht. Wer geplant hat, prüft nicht; wer geschrieben hat, reviewt nicht.

## Übungen

* Ordne 10 typische Tätigkeiten den Rollen zu
* Spiele einen Konfliktfall durch: Reviewer lehnt ab, Implementer widerspricht — wer entscheidet?

## Selbstcheck

* Warum braucht es Verification *und* Validation?
* Welche Rolle besitzt ein ADR — wer darf es ändern?

## Weiterlesen

* Nächstes Modul: [Modul 8 — Implementierung durch KI-Agenten](modul-08-implementierung.md)
