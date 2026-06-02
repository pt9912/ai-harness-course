# Uebung 02 — Lastenheft schaerfen

## Ausgangstext

> DocSearch soll Markdown-Dateien speichern und durchsuchen.

Dieser Satz ist absichtlich zu vage. Er laesst offen, ob Speicherung
Dateisystem, Datenbank, Cache oder externe API bedeutet.

## Aufgabe

1. Formuliere daraus eine `LH-FA-*`-Anforderung mit Happy Path,
   Boundary und Negative.
2. Ergaenze eine Out-of-Scope-Liste.
3. Notiere mindestens einen Satz, der dem Agenten eine plausible, aber
   falsche Implementierungsrichtung verbietet.

## Material

- [`../spec/lastenheft.md`](../spec/lastenheft.md)
- [`../../templates/spec/lastenheft.template.md`](../../templates/spec/lastenheft.template.md)

## Selbsttest

Dein Ergebnis ist brauchbar, wenn ein Implementation-Agent nicht mehr
erraten muss, wo Daten gespeichert werden, welche Grenze fuer `k` gilt
und was bei leerer Suchanfrage passieren soll.
