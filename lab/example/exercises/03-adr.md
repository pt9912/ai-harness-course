# Uebung 03 — ADR aus einer Architekturentscheidung ableiten

## Ausgangslage

DocSearch soll Embeddings erzeugen. Das Team diskutiert drei Varianten:
direkter Cloud-API-Aufruf im Service, lokales Mock-Modell im Service,
oder Adapter-Schicht mit austauschbarem Provider.

## Aufgabe

1. Schreibe eine ADR im MADR-Stil.
2. Verweise auf mindestens eine `LH-*`- oder `LH-QA-*`-ID.
3. Formuliere eine Konsequenz, die spaeter als Architekturtest pruefbar
   ist.

## Material

- [`../docs/plan/adr/0001-hexagonale-architektur.md`](../docs/plan/adr/0001-hexagonale-architektur.md)
- [`../docs/plan/adr/0002-modellwahl-embedding.md`](../docs/plan/adr/0002-modellwahl-embedding.md)
- [`../../templates/docs/plan/adr/NNNN-titel.template.md`](../../templates/docs/plan/adr/NNNN-titel.template.md)

## Erwartetes Zwischenprodukt

Eine ADR, die nicht nur eine Entscheidung beschreibt, sondern mindestens
eine spaetere Fitness Function vorbereitet.
