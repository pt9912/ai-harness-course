# Modul 9 — Review Harness

## Lernziele

* Reviews als reproduzierbare Läufe einrichten
* Findings nach HIGH/MEDIUM/LOW/INFO klassifizieren
* Plan-, Design- und Code-Reviews unterscheiden

## Lab-Bezug

* `make agent-review PR=<id>`
* fingierter "kaputter" Slice in `exercises/09-review-fixture/`

## Themen

* Plan Reviews
* Design Reviews
* Code Reviews
* Findings und ihre Kategorien

## Finding-Kategorien

| Kategorie | Bedeutung |
|---|---|
| HIGH | blockiert Merge: Sicherheits-, Korrektheits- oder ADR-Verstoß |
| MEDIUM | sollte vor Merge geklärt werden |
| LOW | nice-to-fix, blockiert nicht |
| INFO | Hinweis, keine Aktion erwartet |

## Harness-Einordnung

Review = *inferential feedback* (siehe
[`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)).
Teurer als ein Linter, billiger als Verifikation. Adressiert primär die
Maintainability-Kategorie.

## Kernidee

Ein Review ohne Kategorisierung ist eine Mängelliste. Ein Review mit
Kategorisierung ist eine Entscheidungsvorlage.

## Übungen

* Review realer Änderungen im Begleit-Repo
* Reviewe den fingierten kaputten Slice — finde die drei eingebauten Fehler

## Selbstcheck

* Wann wird aus einem LOW-Finding ein HIGH-Finding?
* Was tust du, wenn der Reviewer-Agent dasselbe Finding zweimal mit unterschiedlicher Kategorie meldet?

## Weiterlesen

* Nächstes Modul: [Modul 10 — Verification Harness](modul-10-verification.md)
