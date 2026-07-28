# Welle <NN> — <Titel> — Closure-Notiz

> **Template-Hinweis.** Vorlage für die Ergebnis-Notiz einer Welle.
> Kopiere nach `docs/plan/planning/done/welle-<NN>-results.md` — nur die
> Nummer, nicht die volle Welle-ID (die Welle `welle-1-mvp` schließt mit
> `welle-1-results.md`). Ersetze Platzhalter und lösche diesen Block.
> Zugleich wandert die Welle-*Plan*-Datei per `git mv` nach `done/`, neben
> diese Notiz. Pflichtteile und Ablauf: Baseline-Regelwerk
> `modul-06-roadmap.md` §Wellen-Closure-Prozedur (Modul 6), Schritt 3.

**Welle:** <welle-id, z. B. welle-1-mvp>
**Abschluss:** YYYY-MM-DD
**Verantwortlich:** <Name>

## Was wurde geliefert?

<!--
Ergebnis, nicht Tätigkeit. Mit ID-Bezug, wo es einen gibt.
-->

- <LH-FA-NN erfüllt, Akzeptanzkriterium grün.>
- <…>

## Was hat funktioniert?

<!-- Was du im nächsten Zyklus bewusst wieder so machen würdest. -->

- <…>

## Was ging anders als geplant?

<!--
Beobachtungen, keine Schuldzuweisung. Jede Zeile möglichst mit der
Konsequenz, die daraus schon gezogen wurde (Folge-Slice, Spec-Version).
-->

- <…>

## Steering-Loop-Einträge

<!--
Nur Beobachtungen, die die Schwelle von 3× erreicht haben — sie sind
jetzt VERKÖRPERT und wirken ab hier von selbst. Pro Eintrag: was wurde
geschärft, und wo liegt es jetzt?
Klassen: geschärfte Regel (AGENTS.md / MR-<NNN>) · neuer Sensor (Gate,
Skill) · benannte Spec-Lücke (Lastenheft-Version, Folge-ADR).

PFLICHTFELD "liegt in" fuer geschaerfte Regel und neuen Sensor: der Zielort
ist maschinell pruefbar und bildet mit dem Herkunfts-Anker am Ziel ein PAAR —
das Ziel muss existieren und `seit welle-<NN>` tragen. NUR dieses Feld loest
die Anker-Paarung aus; eine benannte Spec-Luecke traegt stattdessen ihre
`LH-*`-ID und ist kein Gegenstand der Paarung. Regel und Sensor:
Baseline-Regelwerk `grundlagen-konventionen.md` §Herkunfts-Anker für
Steering-Loop-Regeln.

REGISTER-PAARUNG: jede genannte `BEO-<NNN>` MUSS eine Zeile in
`../observations.md` haben — geprueft am Ende von Schritt 3.
-->

- **<Guide oder Sensor>** <geschärft/ergänzt>: <was genau>
  — liegt in `<AGENTS.md §X | Makefile-Target | .harness/skills/…>`.
  (Feld und Pfad stehen auf EINER Zeile — ein zeilenweiser Sensor greift sonst
  nicht; die Sektionsangabe steht INNERHALB der Backticks.)
  Auslöser: `BEO-<NNN>` (<slice-NNN>, <slice-MMM>, <slice-KKK> — 3×).
- <…>

<!-- Gegenstück am Ziel, nicht vergessen — es ist die andere Hälfte des Paares:
     noqa-gate:  ## LH-QA-SUP-002 · seit welle-<NN>
     ### 3.3 <Hard Rule>   (seit welle-<NN>)
     Entfernen oder Lockern dieser Regel setzt später den Retirement-Check
     voraus: „seit welle-<NN> — ist die Beobachtung wieder aufgetreten?" -->

## Beobachtungs-Register (Zeiger)

<!--
NICHT MEHR HIER PFLEGEN. Der Zaehler lebt seit Kurs-Welle 59 als stehende
Datei: `docs/plan/planning/observations.md` (Ziel-Form
[`observations.template.md`](observations.template.md), Regeln im
Baseline-Regelwerk `modul-06-roadmap.md` §Das Beobachtungs-Register).

Grund: Eine hier gepflegte Sektion muss von Closure zu Closure UEBERNOMMEN
werden. Wer das vergisst, setzt den Zaehler auf null; die erste Welle braucht
eine Sonderregel; und ohne Welle gibt es gar keinen Traeger. Der stehende Ort
streicht alle drei Faelle.

Diese Sektion bleibt als ZEIGER, damit ein Leser der Closure-Notiz den Zaehler
findet — sie traegt keine Daten mehr.
-->

Der Zähler steht in [`../observations.md`](../observations.md).
Was in dieser Welle **3×** erreicht hat, steht oben unter
*Steering-Loop-Einträge*.

## Folge-Slices

<!--
DERIVATIV: der Folge-Slice selbst ist eine Datei in `open/`; diese Liste
zeigt nur darauf. Deshalb braucht sie keinen eigenen Konsumenten — wohl
aber eine Deckung: jeder genannte Folge-Slice MUSS als Datei im
Planning-Lifecycle existieren (`open/`, `next/`, `in-progress/`, `done/` —
nicht nur `open/`, er kann bis zur Prüfung weitergewandert sein).
Folge-Slice-Paarung, geprüft am Ende von Schritt 3 der Closure-Prozedur.
Genannt ohne angelegt ist dieselbe Klasse wie ein halluziniertes Gate.
-->

- <slice-NNN (<Titel>) — startet welle-<NN+1>.>

## Verifikation

<!--
Die Belege aus Schritt 1 der Closure-Prozedur. Keine Behauptung ohne
nachprüfbaren Anker (Hash, Lauf, Zahl).
-->

- `make fullbuild` grün (Build-Hash `<sha256:…>`).
- Replay-Lauf gegen Golden Set: <N>/<N> Cases grün.
- Coverage gesamt: <N> %, kritisch: <N> % (offene Carveouts: <CO-NNN>).
