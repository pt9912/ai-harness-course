# Review-Fixture für Modul 10

Dieses Verzeichnis enthält einen **fingierten kaputten Slice** mit
**genau drei eingebauten Fehlern**, jeweils einer pro Finding-Kategorie:
HIGH, MEDIUM, LOW.

## Aufgabe

**Plan Review** (siehe Modul 10): Reviewer-Lauf gegen
[`slice-X-broken-feature.md`](slice-X-broken-feature.md). Erwartetes
Ergebnis: drei Findings, korrekt kategorisiert.

Der Reviewer muss als Eingaben mindestens haben:
- den Slice-Plan,
- [`../../AGENTS.md`](../../AGENTS.md) (Hard Rules),
- [`../../docs/plan/adr/0001-hexagonale-architektur.md`](../../docs/plan/adr/0001-hexagonale-architektur.md) (Layering),
- [`../../spec/lastenheft.md`](../../spec/lastenheft.md) (LH-FA-02, LH-QA-01).

Ohne diesen Kontext findet der Reviewer höchstens die LOW-Probleme —
das ist selbst Lehrstoff.

## Erfolgskriterien

Ein vollständiger Review-Lauf identifiziert:

| Kategorie | Hinweis ohne Auflösung |
|---|---|
| HIGH | Berührt ADR-0001 (Hexagonale Architektur) — eine DoD-Aussage widerspricht dem Layering. |
| MEDIUM | Eine Risiko-Begründung absolviert sich selbst, ohne gegen eine `LH-QA-*`-Anforderung evaluiert zu sein. |
| LOW | Ein Pflichtfeld ist syntaktisch gefüllt, aber semantisch tautologisch. |

Die konkrete Auflösung steht in
[`../../../../kurs/de/loesungen/modul-10-loesung.md`](../../../../kurs/de/loesungen/modul-10-loesung.md)
— nach dem eigenen Versuch dort vergleichen.

## Lerneffekt

Wenn dein Reviewer-Agent **nur HIGH-Findings** produziert, ist er
übersensibilisiert. Wenn er **nur LOW** findet, sind die Skills zu
schwach. Drei Kategorien zu sehen ist die Übung.
