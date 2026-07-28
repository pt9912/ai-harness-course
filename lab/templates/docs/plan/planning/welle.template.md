# Welle <welle-id>: <Titel>

> **Template-Hinweis.** Vorlage für eine Welle (Bündel von Slices, das
> gemeinsam geplant und abgeschlossen wird, siehe
> [Baseline-Regelwerk Modul 5](../../../../regelwerk/modul-05-planning-harness.md)
> und [Modul 6](../../../../regelwerk/modul-06-roadmap.md)).
> Kopiere nach `docs/plan/planning/<welle-id>.md` und ersetze
> Platzhalter. Lösche diesen Block.

**Lifecycle:** Diese Datei entsteht bei der **Eröffnung** der Welle und liegt
flach unter `docs/plan/planning/`; bei Closure wandert sie per `git mv` nach
`done/` (neben ihre `welle-<NN>-results.md`). Der Zustand ist die
Verzeichnis-Position — kein Status-Feld. **Geplante Wellen bekommen noch keine
Datei:** Sie stehen in der Roadmap unter *Nächste Wellen* und nirgends sonst —
zwei Positionen, nicht drei.

**Zielmeilenstein:** M<NN> oder "kein Meilenstein-Bezug".

**Verantwortlich:** <Name>. **Datum:** YYYY-MM-DD.

---

## 1. Welle-Ziel

<!--
Was liefert die Welle? Eine Aussage, die sich an einem Lasttest oder
Akzeptanzkriterium spiegelt.
-->

<…>

## 2. Trigger (Welle startet)

<!--
Was muss vorher passiert sein? Verweise auf vorangegangene Wellen
oder externe Ereignisse.
-->

- <z.B. Welle <welle-vorher-id> done.>
- <z.B. ADR-<NNNN> accepted.>

## 3. Closure-Trigger (Welle schließt)

<!--
Was muss erreicht sein, damit die Welle done ist? Aktion, nicht
Termin.
-->

- <z.B. Alle Slices done.>
- <z.B. `make fullbuild` grün.>
- <z.B. Replay-Lauf gegen Golden Set durchläuft.>
- <z.B. Closure-Notiz in `welle-<NN>-results.md`.>

## 4. Slices in dieser Welle

<!-- Zustand jedes Slice = sein Lifecycle-Verzeichnis (open/next/in-progress/
done), hier NICHT gespiegelt — eine Status-Spalte driftete gegen die
Verzeichnisse (dieselbe zweite Wahrheit, die beim Slice retired wurde). -->

| Slice | Titel | Bezug |
|---|---|---|
| slice-<NN-A> | <…> | LH-FA-<NN> |
| slice-<NN-B> | <…> | LH-FA-<NN> |

## 5. Abhängigkeiten

<!--
Welche Wellen kommen *nach* dieser? Falls jemand sie ändert, was
bricht?
-->

- Blockiert: Welle <welle-id> (wegen <Vertragspunkt>).
- Wird blockiert von: Welle <welle-id>.

## 6. Out-of-Scope für diese Welle

<!--
Explizite Nicht-Inhalte. Schützt vor Scope-Creep.
-->

- <…>

## 7. Closure-Notiz

<!-- Erst nach Welle-Abschluss füllen: Zeiger auf die Ergebnis-Notiz
`welle-<NN>-results.md` (nur die Nummer, nicht die volle Welle-ID).

Pfade so schreiben, wie sie vom RUHEORT dieser Datei aus auflösen: Sie wandert
bei Closure per `git mv` nach `done/` — die Ergebnis-Notiz liegt dort als
Geschwister (also ohne Präfix), das Beobachtungs-Register eine Ebene höher
(`../observations.md`). Ein im Schreibmoment richtiges `done/…` bricht für
jeden Leser danach.

Die Ruheort-Regel gilt fuer die Pfade, die DU hier eintraegst. Der
Ziel-Form-Zeiger direkt darunter ist davon ausgenommen: Er zeigt auf eine
Schwester-Vorlage im Template-Verzeichnis, nicht auf ein Artefakt deines
Repos, und faellt mit diesem Kommentar ohnehin weg.

Ziel-Form: [`welle-results.template.md`](welle-results.template.md) — sie trägt
die Pflichtteile inklusive des Zeigers aufs Beobachtungs-Register, das bei
jeder Slice-Closure fortgeschrieben wird. -->

Ergebnis: <Zeiger auf `welle-<NN>-results.md`, Geschwister im Ruheort `done/`>
Zähler: <Zeiger aufs Beobachtungs-Register, eine Ebene über dem Ruheort>
