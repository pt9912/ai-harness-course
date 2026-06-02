# Modul 15 — Produktiver Betrieb

## Lernziele

* Ein Projekt für den produktiven Betrieb freigeben
* Runtime-Validation gegen Spec laufen lassen
* Incident Response für Agenten-Fehler aufsetzen

## Lab-Bezug

* `runbooks/`
* `make release`

## Themen

* Releases
* Runtime Validation (Schema, Spec, Budget)
* Sicherheitsprüfungen (Prompt Injection, Tool-Abuse, Data Exfiltration)
* Incident Response (Replay, Rollback, Forensik)

## Kernidee

Produktiv heißt: Du musst eine Frage in der Nacht beantworten können,
ohne den Autor zu kennen. Runbooks und Replay sind dafür da.

## Übungen

* Produktionsfreigabe eines Projekts (Checkliste aus dem Begleit-Repo)
* Spiele ein Incident-Szenario durch: Agent löscht versehentlich produktive Daten — was tust du in den ersten 15 Minuten?

## Selbstcheck

* Welche Telemetrie brauchst du, um einen Prompt-Injection-Versuch nachträglich zu erkennen?
* Wann ist Rollback der falsche Reflex?

## Weiterlesen

* Übergang zum Abschluss: [Abschlussprojekt](../abschluss/abschlussprojekt.md)
