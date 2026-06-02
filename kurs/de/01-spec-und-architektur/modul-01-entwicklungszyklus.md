# Modul 1 — Der Entwicklungszyklus

## Lernziele

* Den Lebenszyklus Spec → ADR → Plan → Code → Review → Verifikation → Closure nachzeichnen
* Rollen und Artefakte einander zuordnen
* Traceability zwischen Artefakten herstellen
* Source Precedence für ein Repo festlegen und in `harness/README.md` dokumentieren

## Lab-Bezug

* `docs/plan/planning/in-progress/roadmap.md`
* Verzeichnisstruktur des Begleit-Repos (siehe [`../grundlagen/konventionen.md`](../grundlagen/konventionen.md))

## Themen

* Lebenszyklus
* Rollen
* Verantwortlichkeiten
* Artefakte
* Traceability

## Kernidee

Jedes Artefakt verweist nach oben (Begründung) und nach unten
(Konsequenz). Eine Kette ohne Rückverweise ist nicht auditierbar.

## Übungen

* Zeichne den Zyklus für ein Mini-Feature auf einem Blatt
* Identifiziere im Begleit-Repo einen Slice und folge der Kette Spec → ADR → Plan → PR
* Schreibe einen Source-Precedence-Block für ein eigenes Repo als ersten Abschnitt einer neuen `harness/README.md` (Vorlage in [`/lab/templates/harness/README.template.md`](../../../lab/templates/harness/README.template.md))

## Selbstcheck

* Welche Information darf nur in der Spec stehen, welche nur im ADR?
* Was passiert, wenn ein Slice fertig ist, aber kein Closure-Eintrag existiert?

## Weiterlesen

* Source Precedence im Detail: [`../grundlagen/konventionen.md#source-precedence`](../grundlagen/konventionen.md#source-precedence)
* Nächstes Modul: [Modul 2 — Lastenheft und Spezifikation](modul-02-lastenheft.md)
