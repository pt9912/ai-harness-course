# Modul 6 — Carveout Management

## Lernziele

* Temporäre und permanente Carveouts sauber dokumentieren
* Jeden temporären Carveout an einen Folge-Slice koppeln

## Lab-Bezug

* `docs/plan/carveouts/`

## Themen

* Temporäre Ausnahmen
* Permanente Ausnahmen
* Trigger für die Auflösung
* Folge-Slices

## Harness-Einordnung

Carveout-Pflege ist ein Pfeiler von *Entropy Management* (siehe
[`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)):
ein Carveout-Audit pro Welle verhindert, dass temporäre Ausnahmen zu
permanenten Lügen werden.

## Kernidee

Jeder temporäre Carveout benötigt einen Plan. Ein Carveout ohne
Auflösungs-Trigger ist ein permanenter Carveout, der lügt.

## Übungen

* Dokumentiere einen Carveout für eine fehlende Coverage-Schwelle
* Verknüpfe ihn mit einem konkreten Folge-Slice

## Selbstcheck

* Wann darf ein Carveout das `make gates`-Ziel grün halten, und wann nicht?

## Weiterlesen

* Nächstes Modul: [Modul 7 — Agentenrollen](../03-agenten/modul-07-agentenrollen.md)
