# Modul 2 — Lastenheft und Spezifikation

## Lernziele

* Ein Lastenheft schreiben, das von einem Agenten umsetzbar ist
* Funktionale und nichtfunktionale Anforderungen trennen
* Akzeptanzkriterien testbar formulieren

## Lab-Bezug

* `spec/`
* `exercises/02-lastenheft.md`

## Themen

* Anforderungen
* Nichtfunktionale Anforderungen
* Akzeptanzkriterien
* Scope und Out-of-Scope
* Spec-Qualität für Agentenkonsum (Eindeutigkeit, Negativbedingungen, Beispiele)
* Spec-Stratifizierung (Lastenheft vertraglich, Spezifikation technisch, Architektur diagrammatisch)
* ID-Schema (z. B. `LH-*`, `HSM-*`) als Klammer zwischen Anforderung, Make-Target und Commit

## Harness-Einordnung

Spec = *inferential feedforward* (siehe
[`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)).
Sie ist die billigste Kontrolle: Was die Spec sauber ausschließt, kommt
im Review nicht mehr vor.

## Kernidee

Ein Agent ist ein extrem buchstabengetreuer Praktikant. Was nicht in der
Spec steht, existiert für ihn nicht — Lopopolos Maxime: *"anything it
can't access in-context doesn't exist."* Was zweideutig in der Spec
steht, wird auf die für dich ungünstigste Weise interpretiert.

## Übungen

* Erstellung eines vollständigen Lastenhefts für ein kleines Feature
* Provoziere absichtlich einen Spec-Bug: lass den Agenten gegen eine unterspezifizierte Anforderung laufen und benenne, was schiefging

## Selbstcheck

* Welche drei Tests würden ein Akzeptanzkriterium falsifizieren?
* Wo gehört "Performance < 200 ms" hin — funktional oder nichtfunktional?

## Weiterlesen

* Spec-Stratifizierung im Detail: [`../grundlagen/konventionen.md#spec-stratifizierung`](../grundlagen/konventionen.md#spec-stratifizierung)
* Reales Beispiel mit Lastenheft/Spezifikation-Trennung: `pt9912/c-hsm-doc` in [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
* Nächstes Modul: [Modul 3 — Architektur und ADRs](modul-03-architektur-adrs.md)
