# Modul 3 — Architektur und ADRs

## Lernziele

* Architekturentscheidungen so dokumentieren, dass spätere Agentenläufe sie als Constraint nutzen können
* Den Unterschied zwischen ADR und Spec sauber halten
* Architektur-Reviews mit Agenten unterstützen

## Lab-Bezug

* `docs/plan/adr/`
* `exercises/03-adr.md`

## Themen

* Architekturentscheidungen
* ADR-Formate (MADR, Nygard)
* Architektur-Reviews
* ADRs als maschinell prüfbare Constraints
* Übersetzung ADR → Fitness Function

## Harness-Einordnung

ADR = *inferential feedforward* (für den Implementation-Agent) und
gleichzeitig Quelle für *computational feedback* (ArchUnit/Fitness
Functions, wenn die Entscheidung maschinell prüfbar ist). Eine ADR ohne
Fitness Function ist eine Absichtserklärung.

## Kernidee

Ein ADR ist die einzige Stelle, an der "weil" gegen "ist halt so" gewinnt.
Wenn dein Reviewer-Agent den Grund nicht findet, kann er die Entscheidung
nicht verteidigen.

## Hard Rule (Beispiel aus c-hsm-doc, ADR 0001)

Begriff *Hard Rule* siehe Glossar in
[`../grundlagen/konventionen.md`](../grundlagen/konventionen.md).

*"Eine ADR mit Status `Accepted` wird nicht inhaltlich überschrieben.
Spätere Korrekturen oder Schärfungen entstehen als neue ADR mit
explizitem Verweis auf die abgelöste oder geschärfte Vorgängerin."*

Wirkung: ADRs sind Geschichtsdokumente, kein Wiki. Reviewer-Agent kann
auf ältere Entscheidungen vertrauen, ohne Versionsstände zu vergleichen.

## Übungen

* ADR für Modellwahl
* ADR für Tool Calling
* ADR für Evaluierung
* ADR für Layering (Beispiel nach OpenAI: `Types → Config → Repo → Service → Runtime → UI` — jede Schicht darf nur "abwärts" importieren) und parallele Fitness Function in ArchUnit/dep-cruiser
* Lass einen Agenten gegen eine vorhandene ADR-Verletzung laufen und prüfe, ob er sie erkennt

## Selbstcheck

* Wann wird aus einer ADR eine Architekturtest-Regel?
* Was ist der Unterschied zwischen *superseded* und *deprecated* ADR?

## Weiterlesen

* Repo mit 10 ADRs als Beispiel-Korpus: `pt9912/u-boot` in [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
* Nächstes Modul: [Modul 4 — Planning Harness](../02-planung/modul-04-planning-harness.md)
