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
-->

- **<Guide oder Sensor>** <geschärft/ergänzt>: <was genau> — liegt in
  `<AGENTS.md §X | Makefile-Target | .harness/skills/…>`.
  Auslöser: <slice-NNN, slice-MMM, slice-KKK> (3×).
- <…>

## Beobachtungen unter Schwelle

<!--
Der Zähler des Steering Loops (1x notieren · 2x Symptom · 3x Lücke).
Diese Sektion wird aus der VORHERIGEN Closure-Notiz ÜBERNOMMEN und
hochgezählt — nicht neu geschrieben. Ohne sie fängt der Zähler mit jeder
Welle bei null an, und ein Fehler, der einmal pro Welle auftritt, wird
nie als Lücke sichtbar.

Regeln:
- Erreicht ein Eintrag 3x, wandert er nach oben in die
  Steering-Loop-Einträge und verlässt diese Liste.
- Eintraege verfallen nicht von selbst. Wer einen streicht, schreibt
  dazu, warum er nicht mehr auftreten kann (Ursache beseitigt, Sub-Area
  entfallen) — sonst ist es stilles Vergessen.
- Die Bezeichnung muss über Wellen hinweg STABIL sein, sonst zaehlt man
  zwei Namen fuer dieselbe Sache getrennt und keiner erreicht je 3x.
-->

| Beobachtung (stabile Bezeichnung) | Betroffene Sub-Area | Zähler | Belege |
|---|---|---|---|
| <kurze, gleichbleibende Bezeichnung> | <Sub-Area> | 1× / 2× | <slice-NNN> |

<!-- Keine offenen Beobachtungen? Dann "— keine —" eintragen, nicht die
     Sektion löschen: die leere Liste ist die Aussage. -->

## Folge-Slices

<!-- Was aus dieser Welle heraus entstanden ist, mit Ziel-Welle. -->

- <slice-NNN (<Titel>) — startet welle-<NN+1>.>

## Verifikation

<!--
Die Belege aus Schritt 1 der Closure-Prozedur. Keine Behauptung ohne
nachprüfbaren Anker (Hash, Lauf, Zahl).
-->

- `make fullbuild` grün (Build-Hash `<sha256:…>`).
- Replay-Lauf gegen Golden Set: <N>/<N> Cases grün.
- Coverage gesamt: <N> %, kritisch: <N> % (offene Carveouts: <CO-NNN>).
