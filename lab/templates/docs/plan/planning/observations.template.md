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

WER SCHREIBT: die Slice-Closure (§7), vor dem `git mv` nach done/.
WER LIEST:    die Welle-Closure (was hat 3x erreicht -> verkoerpern) und die
              Wellen-Eroeffnung Schritt 2 (betrifft eine Beobachtung die
              Sub-Areas dieser Welle?).
OHNE WELLE:   BEIDE Leser haengen dann an der Slice-Arbeit — den Lese-Schritt
              loest die Slice-Closure aus (was hat mit ihr 3x erreicht?), den
              Sichtungs-Schritt die Slice-PLANUNG (`slice.template.md` §8,
              Block "Vorgelagert — offene Beobachtungen sichten"; er haengt
              nicht am Sub-Area-Modus und gilt auch bei reinem GF). Faellt der
              zweite weg, hat alles unter der Schwelle keinen Leser.

REGELN
- Erstauftreten: benennen, KENNUNG vergeben (BEO-<NNN>, fortlaufend), Beleg
  eintragen. Wiederauftreten: Zaehler erhoehen, Beleg ergaenzen — die
  Bezeichnung NICHT neu formulieren, sie ist nur noch Label.
- Ein BELEG ist eine Slice-Kennung `slice-<NNN>`, die als Datei im
  Planning-Lifecycle aufloest (open/, next/, in-progress/, done/) —
  nicht Freitext. Sonst ist die Belegspalte frei erfindbar und der Zaehler
  behauptet eine Haeufigkeit, die niemand nachpruefen kann. Die Anzahl der
  Belege MUSS dem Zaehler entsprechen.
- Erreicht ein Eintrag 3x, wandert er in die Steering-Loop-Eintraege der
  laufenden Welle-Closure und wird dort zur verkoerperten Regel (mit
  Herkunfts-Anker seit welle-<NN>). Ohne Welle: beim eigenstaendig
  ausgeloesten Lese-Schritt, Anker seit slice-<NNN>. Die Zeile bleibt hier
  stehen, mit Vermerk wohin.
- Eintraege verfallen nicht von selbst. Wer einen streicht, schreibt dazu,
  warum er nicht mehr auftreten kann (Ursache beseitigt, Sub-Area entfallen)
  — sonst ist es stilles Vergessen.
- Keine offenen Beobachtungen? Dann "— keine —" eintragen, nicht die Tabelle
  loeschen: die leere Liste ist die Aussage.

MECHANISIERUNG (Repo-Entscheidung, nicht vom Kurs vorgegeben)
Das BENENNEN und ZAEHLEN bleibt Handarbeit — ob zwei Eintraege dieselbe
Beobachtung meinen, entscheidet kein Werkzeug. Maschinell pruefbar ist nur
die DECKUNG: eine in done/ zitierte BEO-<NNN> hat eine Zeile hier, und jede
Zeile hier hat mindestens einen Beleg. Muster: schreiben -> committen ->
Gate prueft.
NICHT "und umgekehrt": eine Zeile MUSS nicht in done/ zitiert sein — die
allermeisten stehen unter der Schwelle und sind nirgends zitiert.
-->

| Kennung | Beobachtung | Sub-Area | Zähler | Belege | Stand |
|---|---|---|---|---|---|
| BEO-001 | <kurze, gleichbleibende Bezeichnung> | <Sub-Area> | 1× | <slice-NNN> | offen |
| BEO-002 | <aus Slice-§6 übernommenes offenes Risiko> | <Sub-Area> | 2× | <slice-NNN>, <slice-NNN> | offen |
| BEO-003 | <Beispiel: Schwelle erreicht> | <Sub-Area> | 3× | <slice-NNN>, … | verkörpert in `AGENTS.md` §<N> (`seit welle-<NN>`) |

## Gestrichene Einträge

<!--
Nicht loeschen, sondern hierher verschieben — mit Begruendung. Ein still
entfernter Eintrag ist nicht von einem nie aufgetretenen zu unterscheiden.
-->

| Kennung | Beobachtung | Gestrichen am | Warum sie nicht mehr auftreten kann |
|---|---|---|---|
| <BEO-NNN> | <Bezeichnung> | YYYY-MM-DD | <Ursache beseitigt / Sub-Area entfallen> |
