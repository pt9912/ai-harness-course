# Abschlussprojekt — AI Harness Platform

## Features

* Spezifikation
* ADRs
* Planning Lifecycle
* Agentenrollen
* Reviews
* Verifikation
* Replay
* Evaluierung
* Quality Gates
* Observability

## Abgabe

Vollständiges Repository inklusive Dokumentation, Gates, Roadmap,
Reviews und Abschlussbericht. Das Repository muss:

* `make gates` grün durchlaufen
* einen Replay-Lauf gegen ein Golden Set reproduzieren
* mindestens eine ADR, einen Carveout und einen geschlossenen Slice in `done/` enthalten
* einen Trace eines kompletten Agenten-Durchlaufs (Plan → Implement → Review → Verify) im Anhang dokumentieren

## Bewertungsachsen

| Achse | Frage |
|---|---|
| Vollständigkeit | Sind alle Phasen-Artefakte vorhanden (Spec, ADR, Plan, Code, Review, Verifikation, Replay)? |
| Konsistenz | Stimmt Source Precedence? Widerspricht AGENTS.md keiner kanonischen Quelle? |
| Reproduzierbarkeit | Läuft `make gates` auf einem frischen Klon — und im CI — identisch durch? |
| Auditierbarkeit | Lässt sich jede relevante Änderung über eine Requirement-/ADR-ID zurückverfolgen? |
| Steering-Loop-Reife | Gibt es mindestens einen dokumentierten Failure → Guide/Sensor-Schritt? |

## Hinweise

* Beginne klein. Ein Repo, eine Repo-Klasse, drei Slices reichen.
* Schreibe `harness/README.md` als *eines der letzten* Artefakte, nicht als erstes — sonst dokumentierst du Wunschdenken statt Realität (siehe [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)).
* Lass dich nicht von der Modulanzahl täuschen: Das Abschlussprojekt verlangt Tiefe in *einem* Repo, nicht Breite über drei.
