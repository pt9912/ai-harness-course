# <slice-NNN | welle-NN> — <Titel>

> **Template-Hinweis.** Vorlage für den gekürzten Stub, der beim Archivieren
> einer Welle an der Stelle des Volltexts liegen bleibt
> (`docs/plan/planning/done/<welle-id>/`). Kopiere die passende der beiden
> Formen unten, ersetze Platzhalter, lösche diesen Block und die jeweils
> andere Form.

Regeln dieses Artefakts: Baseline-Regelwerk `modul-06-roadmap.md`
§Die Wellen-Closure-Prozedur, Schritt 4 — was archiviert wird, was liegen
bleibt, in welcher Form, und dass die Ergebnisnotiz vollständig bleibt.

<!-- BEDIENHINWEIS — keine Norm; faellt beim Kopieren weg (README.md
§Verwendung, Schritt 5) und darf deshalb nichts Tragendes halten.

Der Stub traegt VIER Dinge und sonst nichts: Identitaet, Archiv-Zeiger,
Zustand, und die Kennungen, die den Vorgang ueberlebt haben. Lerneintrag,
Risiko-Ausgaenge, DoD-Tabelle und Abnahme gehen ins Archiv — sie stehen
ohnehin dort, wo sie gelesen werden: im Beobachtungs-Register, als ADR, als
Folge-Slice. Genau die nennt die Zeile `Hervorgegangen:`.

KEINE Abschnittsueberschriften (`## …`) im Stub: Ein Stub hat keine, ein
ungekuerzter Plan hat sie — daran ist die Kuerzung form-pruefbar.

`Welle:` und `Archiviert mit:` sind ZWEI Tatsachen. Ein Slice ohne
Wellen-Zugehoerigkeit behaelt `ohne Welle` und nennt im zweiten Feld die
Welle, deren Closure ihn eingesammelt hat.

Review-Reports bekommen KEINEN Stub — sie liegen im Archiv unter ihrem Slice.
-->

## Form A — Slice

# slice-<NNN> — <Titel>

> **ARCHIVIERT** — Volltext:
> `unzip -p done/<welle-id>/archiv.zip <pfad-im-archiv>`

**Welle:** <welle-id | ohne Welle>
**Archiviert mit:** <welle-id> · **Geschlossen:** <JJJJ-MM-TT>
**Hervorgegangen:** <BEO-*, ADR-*, Folge-Slice — oder `— keine —`>

## Form B — Welle-Plan

# <welle-id> — <Titel>

> **ARCHIVIERT** — Volltext:
> `unzip -p done/<welle-id>/archiv.zip <pfad-im-archiv>`

**Geschlossen:** <JJJJ-MM-TT> · **Ergebnisnotiz:** <welle-id>-results.md
**Archivierte Vorgänge:** <N Slices, M Reviews>
