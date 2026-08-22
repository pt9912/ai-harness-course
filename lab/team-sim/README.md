# Team-Sim — Replay für Nebenläufigkeits-Szenarien

**Was das ist.** Ein Replay-Harness nach der Bauform von Modul 12, dessen
„Fälle" keine Modell-Läufe sind, sondern **Nebenläufigkeits-Szenarien**: Je
Szenario eine frische Team-Topologie (bare `origin.git` + zwei Clones), Aktionen
als `alice`/`bob`, und eine **vorab notierte Erwartung als Verhalten** — laut,
still oder Gate-Befund. Auch die stillen Ausgänge sind Erwartungen: s02/s03
*sollen* still verlaufen, sonst hätte die Lehre die Falle falsch beschrieben.

**Konsument:** wer die SOLL-Stufe *geprobt* der Team-Frage herstellt oder
wiederholt (`docs/team.md` §SOLL). **Kein Gate:** läuft auf Anlass
(`bash run.sh`), steht nicht in `make check` und wird nirgends als Sensor
behauptet.

**Standort-Grenze:** `run.sh` liest den d-check-Digest aus dem Repo-Makefile
(eine Quelle, kein zweiter Pin) und bricht außerhalb des Kurs-Repos
fail-closed ab — eine Kopie ohne Repo liefe sonst halb: Git-Szenarien grün,
Docker-Szenarien kryptisch rot.

**Aufruf.** `bash run.sh` läuft alle Gruppen, `bash run.sh s04 s06` nur
diese (Gruppen-Kennung = Präfix der Verdikte, siehe `manifest.yaml`).
`SIM_WORK=<dir>` setzt das Arbeitsverzeichnis (sonst `mktemp`, bleibt
liegen), `SIM_CLEAN=1` räumt es nach dem Lauf weg. Jeder Lauf schreibt
`$WORK/ergebnis.tsv`: ein Kopf mit Datum, Image-Digest, Repo-Stand und
Seed-Hash, dann je Verdikt Szenario · erwartet · beobachtet · `PASS`/`FAIL`/
`KAPUTT` — `KAPUTT` heißt: ein Vorbedingungs-Schritt (Commit, Push, `git mv`)
ist gescheitert, das Verdikt wurde nie gefällt; das ist kein `FAIL`, sondern
ein kaputter Lauf. Befund-Erwartungen prüfen Code **und** Ziel
(`wave-drift` auf `welle-5`, nicht irgendwo) — ein Code allein wäre auch bei
falscher Ursache „bestanden".

**Warum Clones statt Worktrees:** Worktrees teilen ein `.git` und verbieten
denselben Branch zweimal — sie modellieren *einen* Entwickler. Die
Team-Topologie ist geteilter Remote plus lokale Sichten; erst damit ist „was in
einem offenen PR liegt, ist für andere nicht da" real.

## Die Szenarien und ihre Läufe (erster Lauf 2026-08-16, 9/9; erweitert 2026-08-21, 11/11; erweitert 2026-08-22 auf d-check v0.62.0, 16/16; Form Welle 87, 16/16 · 0 KAPUTT; erweitert Welle 88 um s08–s11, 23/23 · 0 KAPUTT)

Kennungen sind stabil — Kursmodule zitieren sie —, die Reihenfolge ist die des
Runners, nach Aussage gruppiert: Singleton gegen Bijektion (s04a b e f i), der
Handbuch-Fall (s04g h), die Marker-Hälfte (s04c d).

| # | Szenario | Erwartung | beobachtet |
|---|---|---|---|
| s01 | Doppel-Anspruch: beide `git mv` denselben Slice auf `main` | zweiter Push non-fast-forward **abgelehnt** | ✓ laut, vor der Arbeit |
| s01b | nach dem Pull: Anspruch sichtbar oder Konflikt | sichtbar/Konflikt | ✓ add/add-Konflikt, laut |
| s02 | gleiche Slice-Nummer, zwei Titel, zwei Branches | Merge **still**, beide Dateien | ✓ exakt wie §Vergabe lehrt |
| s03 | Register: A erhöht Zeile, B legt neue fürs selbe Phänomen an | Merge **still**, Beobachtung halbiert | ✓ — **mit Befund, siehe unten** |
| s04a | zwei offene Wellen, flach + Liste | `planning` grün | ✓ Offene-Wellen-Modell trägt |
| s04b | dazu `waves.dir` aktiviert | **`wave-drift`** | ✓ Singleton-Semantik gemessen |
| s04e | wie s04b, aber `waves.mode: many` (d-check v0.62.0) | `planning` grün | ✓ Bijektion statt Singleton — der CR dieses Repos, geliefert |
| s04f | dazu eine dritte Welle flach **ohne** Zeiger | **`wave-drift`** | ✓ die Bijektion beißt; `many` ist kein stilles Grün |
| s04i | stattdessen ein Zeiger **ohne** Datei | **`wave-drift`** | ✓ die Bijektion beißt in beide Richtungen |
| s04g | **eine** Welle eröffnet (Zeiger) und nichts beansprucht (Marker), `waves` im Default `one` | **`wave-drift`** | ✓ der Handbuch-Fall: Singleton hält den Block gegen genau eine Datei |
| s04h | derselbe Zustand, `mode: many` | `planning` grün | ✓ der Marker geht in die Bijektion nicht ein |
| s04c | Wellen offen **und** nichts beansprucht: Ruhe-Marker *neben* der Liste | `planning` grün | ✓ der Leer-Anspruch-Fall ist legitim |
| s04d | Gegenprobe: Marker weg, `in-progress/` weiter leer | **`planning-drift`** | ✓ die Äquivalenz hält in beide Richtungen |
| s05 | zwei `MR`s parallel | Dateien still, Index-Zeile **laut** | ✓ Hybrid-These bestätigt |
| s06 | `pre-receive`-Hook schützt `main` | TA-7-Anspruch **scheitert** | ✓ Branch-Protection-Reibung real |
| s07 | Sichtung, während Erhöhung im offenen PR liegt | liest den **gemergten** Stand | ✓ „so alt wie der letzte Merge" |
| s08a | Welle auf `main` geschlossen — Register-Zeile, aber keine Ergebnisnotiz (`waves`, `many`) | **`wave-results-missing`** | ✓ die schlampige Closure ist laut |
| s08b | dieselbe Closure sauber (Notiz liegt) — der Slice der Welle ist weiter beansprucht, in `in-progress/` und in bobs offenem PR | **still** (0 Befunde) | ✓ Closure-Prozedur Schritt 1 ist Prozedur, kein Sensor |
| s09 | `slice-002` im Wellen-Plan vorvergeben ohne Datei; bob vergibt die Nummer im PR anders | **still** | ✓ „den PR-Rest fängt das Schema nicht" — gemessen |
| s10a | beide setzen `Verantwortlich:` desselben Slice in zwei PRs | Merge-Konflikt, **laut** | ✓ das Feld streitet, wenn beide es anfassen |
| s10b | bob setzt sich als Inhaber, alice ändert nur den Rumpf | **still**, Inhaber = bob | ✓ Übernahme ohne Gegenwehr bleibt unbemerkt |
| s11a | Geschichte-Zeile einer Accepted-ADR per PR gelandet, `vcs` auf der Range | 0 Befunde | ✓ `exclude-sections` trägt |
| s11b | Entscheidung derselben ADR per PR gelandet | **`core-drift-vcs`** | ✓ `doc-immutable` sieht den Kern auch durch den Merge |

**Befund aus s03 — die Stille braucht Abstand.** Mit einem *einzeiligen*
Register kollidierten Zeilen-Änderung und Anhang **laut** (benachbarte
Edit-Regionen); erst ab mehreren Zeilen Abstand mergt die Doppel-Zeile still.
Die stille Doppel-Zählung ist also eine Eigenschaft **großer** Register — genau
dort, wo auch das Wiedererkennen am teuersten ist. Das verfeinert die Lehre,
widerlegt sie nicht.

**Befund aus s04c/s04d — der Marker-Wächter prüft die Marker-Hälfte; die
Liste hat seit v0.62.0 ihr eigenes Prädikat.** Der Abschnitt *Offene Wellen*
trägt zwei unabhängige Aussagen: Die
Liste folgt den **Dateien**, der Ruhe-Marker folgt dem **Anspruch**. Beides
zugleich (Wellen gelistet, nichts beansprucht) ist der Normalfall direkt nach
der Wellen-Eröffnung — und `planning` bleibt dabei grün (s04c); fehlt der
Marker bei leerem `in-progress/`, meldet derselbe Sensor `planning-drift`
(s04d). Damit ist die Äquivalenz *Marker ⟺ kein Slice in `in-progress/`* in
**beiden** Richtungen gemessen statt behauptet. Die Liste gegen die
Welle-Dateien ist das **andere** Prädikat — eine Bijektion —, und seit d-check
v0.62.0 hat sie eins: `waves.mode: many` (der CR dieses Repos, geliefert;
s04e/s04f/s04i). Unter dem Default `one` bleibt s04b rot — derselbe Zustand,
ein anderes Kardinalitäts-Modell; der Ruhe-Marker geht in die Bijektion nicht
ein (s04g/s04h). Eine Nuance aus dem Bau: Mit **zwei** flachen Wellen und
stehendem Marker ist `one` zufällig grün — der Bool-Vergleich prüft bei
stehendem Marker nur „ungleich eins" —, deshalb misst s04g den Ein-Wellen-Fall
auf frischer Topologie statt den s04c-Zustand.

**Befund aus s08b, s09, s10b — drei stille Ausgänge, alle drei Lehre.** Die
Sensoren des Planning-Harness halten Form gegen Form: Marker gegen
Verzeichnis, Zeiger gegen Dateien, Register-Zeile gegen Notiz, ADR-Kern gegen
Range. Drei Aussagen des Korpus liegen daneben und haben heute keinen
Wächter — und jetzt ist das gemessen, nicht gelesen: **(1)** Eine Welle lässt
sich sauber schließen, während ein Slice mit ihrem `Welle:`-Feld beansprucht
ist (Modul 6 §Wellen-Closure-Prozedur, Schritt 1 „Alle Slices der Welle liegen
in `done/`" — Prozedur, kein Sensor; `waves` hält Zeiger und Notiz, nicht das
Feld des Slice). **(2)** Eine im offenen Wellen-Plan vorvergebene Nummer kann
im PR anderweitig gezogen werden; source-precedence §Vergabe sagt genau das
(„den PR-Rest fängt das Schema nicht"), s09 zeigt, dass auch der Wellen-Plan-
Rest nicht gefangen wird. **(3)** Das Rolleninhaber-Feld (TA-1) streitet nur,
wenn beide es anfassen; eine Übernahme gegen einen, der gerade den Rumpf
ändert, mergt still — das Feld ist Zustand ohne Wächter, wie der Kurs es
deklariert. Konsequenz: keine neuen Sensoren behaupten; die drei Stellen sind
als Grenze benannt, und wer einen Wächter will, weiß jetzt, was er messen muss.

**Zwei Werkzeug-Lehren aus dem Bau** (beide kosteten je einen Fehllauf):
`git init --bare` ohne `-b main` lässt Clones leer auschecken — drei Szenarien
„bestanden" gegen leere Verzeichnisse, die Wachsamkeits-Zeile in `topo()`
verhindert das jetzt; und ein Merge-Commit braucht eine Git-Identität — der
erste Merge (fast-forward) läuft ohne, der zweite bricht mit rc=128.

## Grenzen — ausdrücklich

Das hier hebt die Team-Frage von *entworfen* auf **geprobt**, nicht auf
*belegt*: Geprüft ist die **Nebenläufigkeits-Mechanik** mit kooperativen
Akteuren, die die Regeln kennen. Nicht prüfbar sind echter **Dissens**
(TA-6-Terminal), **Lesarten-Divergenz** zwischen Menschen und echte
**Einarbeitung** — und es bleibt Eigenprüfung. Squash-Merges einer Forge
verändern die Historie anders als die lokalen Merges hier; für diese Szenarien
ohne Belang, aber benannt.
