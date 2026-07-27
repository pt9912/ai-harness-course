# Beobachtungs-Register

> **Template-Hinweis.** Vorlage für das stehende Beobachtungs-Register des
> Repos. Kopiere nach `docs/plan/planning/observations.md` (flach, neben den
> offenen Wellen) und ersetze Platzhalter. Lösche diesen Block.

**Status:** Aktiv. **Letzte Änderung:** YYYY-MM-DD.

<!--
Der Zähler des Steering Loops (1x notieren · 2x Symptom · 3x Lücke).
Ziel-Form und Regeln: Baseline-Regelwerk `modul-06-roadmap.md`
§Das Beobachtungs-Register.

WARUM STEHEND: Der Zähler muss zwischen den Wellen überleben. Eine Sektion,
die von Closure zu Closure weitergereicht wird, haengt an einer ungebrochenen
Kette — wer die Uebernahme vergisst, setzt den Zaehler auf null, und wer
laengere Zeit keine Welle eroeffnet, hat gar keinen Traeger. Diese Datei
existiert ab Repo-Beginn.

REGELN
- Erstauftreten: benennen, KENNUNG vergeben (BEO-<NNN>, fortlaufend), Beleg
  eintragen. Wiederauftreten: Zaehler erhoehen, Beleg ergaenzen — die
  Bezeichnung NICHT neu formulieren, sie ist nur noch Label.
- Erreicht ein Eintrag 3x, wandert er in die Steering-Loop-Eintraege der
  laufenden Welle-Closure und wird dort zur verkoerperten Regel (mit
  Herkunfts-Anker). Die Zeile bleibt hier stehen, mit Vermerk wohin.
- Eintraege verfallen nicht von selbst. Wer einen streicht, schreibt dazu,
  warum er nicht mehr auftreten kann (Ursache beseitigt, Sub-Area entfallen)
  — sonst ist es stilles Vergessen.
- Keine offenen Beobachtungen? Dann "— keine —" eintragen, nicht die Tabelle
  loeschen: die leere Liste ist die Aussage.

MECHANISIERUNG (Repo-Entscheidung, nicht vom Kurs vorgegeben)
Die Eintraege aus den done/-Closures lassen sich einsammeln; das BENENNEN
bleibt Handarbeit. Empfohlenes Muster: generieren -> committen -> ein Gate
vergleicht Generat gegen Committetes, damit ein Eintrag aus done/, der hier
fehlt, auffaellt.
-->

| Kennung | Beobachtung | Sub-Area | Zähler | Belege | Stand |
|---|---|---|---|---|---|
| BEO-001 | <kurze, gleichbleibende Bezeichnung> | <Sub-Area> | 1× | <slice-NNN> | offen |
| BEO-002 | <aus Slice-§6 übernommenes offenes Risiko> | <Sub-Area> | 2× | <slice-NNN>, <slice-NNN> | offen |
| BEO-003 | <Beispiel: Schwelle erreicht> | <Sub-Area> | 3× | <slice-NNN>, … | verkörpert in `AGENTS.md` §<N> (welle-<NN>) |

## Gestrichene Einträge

<!--
Nicht loeschen, sondern hierher verschieben — mit Begruendung. Ein still
entfernter Eintrag ist nicht von einem nie aufgetretenen zu unterscheiden.
-->

| Kennung | Beobachtung | Gestrichen am | Warum sie nicht mehr auftreten kann |
|---|---|---|---|
| <BEO-NNN> | <Bezeichnung> | YYYY-MM-DD | <Ursache beseitigt / Sub-Area entfallen> |
