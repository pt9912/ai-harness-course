# Team-Sim — Replay für Nebenläufigkeits-Szenarien

**Was das ist.** Ein Replay-Harness nach der Bauform von Modul 12, dessen
„Fälle" keine Modell-Läufe sind, sondern **Nebenläufigkeits-Szenarien**: Je
Szenario eine frische Team-Topologie (bare `origin.git` + zwei Clones), Aktionen
als `alice`/`bob`, und eine **vorab notierte Erwartung als Verhalten** — laut,
still oder Gate-Befund. Auch die stillen Ausgänge sind Erwartungen: s02/s03
*sollen* still verlaufen, sonst hätte die Lehre die Falle falsch beschrieben.

**Drei Gegenstände, sauber getrennt.** s01–s11 proben den **gelehrten**
Korpus. **s19 probt eine Operation und ihren Sensor** — die ersten Szenarien
hier, die *keine* Nebenläufigkeit prüfen; die Topologie bleibt trotzdem, sie
kostet nichts und hält die Bauform gleich (Entwurf:
`docs/zeitdokument-archiv.md`). s12–s18 proben einen **Entwurf**: die Verzeichnisform des
Beobachtungs-Registers aus `docs/steering-loop-team.md` (Diskussionsstand,
nicht normativ) gegen die sieben Fälle, die dort unter §Nächster belastbarer
Schritt stehen. Der Seed trägt weiter die flache `observations.md` aus
Modul 6; die Verzeichnisform legen die Szenarien selbst an.

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

## Die Szenarien und ihre Läufe (erster Lauf 2026-08-16, 9/9; erweitert 2026-08-21, 11/11; erweitert 2026-08-22 auf d-check v0.62.0, 16/16; Form Welle 87, 16/16 · 0 KAPUTT; erweitert Welle 88 um s08–s11, 23/23 · 0 KAPUTT; nachgeprüft 2026-08-23 auf d-check v0.63.0, 23/23 · 0 KAPUTT; erweitert 2026-08-31 um s12–s18 auf d-check v0.67.0, 36/36 · 0 KAPUTT; nachgefahren auf v0.71.1 mit gedrehten Erwartungen s15b/s16c, 36/36 · 0 KAPUTT; erweitert 2026-08-31 um s19, 45/45 · 0 KAPUTT)

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
| s12 | zwei Belege derselben BEO aus zwei PRs (Verzeichnisform) | Merge glatt, abgeleiteter Zähler 3 | ✓ getrennte Dateien addieren sich ohne Zutun |
| s13 | derselbe Namespace/Slug in zwei PRs neu angelegt | add/add-Konflikt auf `observation.md` | ✓ der Pfad **ist** die Kennung, und er streitet |
| s14a | 1× auf `main`, beide Branches legen je einen Beleg nach | beide lokal 2× | ✓ die Schwelle ist auf keinem Branch sichtbar |
| s14b | ihr Merge-Stand: 3 Belege, `Zustand: offen` ohne Ausgang | **still** | ✓ kein Sensor hält die Schwelle — der Anlass des CR, gemessen |
| s15a | Slug-Verzeichnis umbenannt, Inhalt unverändert, `--staged` | **`core-drift-vcs`** (alter Pfad) | ✓ der lokale Hook sieht den Rename |
| s15b | **derselbe** Rename, committet, `--range` | **`core-drift-vcs`** (alter Pfad) | ✓ seit dem Fix in v0.71.1; unter v0.67.0 war hier **still** — siehe unten |
| s15c | Namespace umbenannt **und** umformuliert, `--range` | **`core-drift-vcs`** (alter Pfad) | ✓ ohne Rename-Ähnlichkeit greift die Delete-Hälfte |
| s16a | bestehenden Beleg geändert | **`core-drift-vcs`** | ✓ append-only hält, solange der Pfad bleibt |
| s16b | bestehenden Beleg gelöscht | **`core-drift-vcs`** | ✓ dieselbe Hälfte, andere Richtung |
| s16c | Beleg auf eine **andere Slice-Kennung** umbenannt, `--range` | **`core-drift-vcs`**, Zähler bleibt 2 | ✓ die schärfste Deckung: der Beleg kann den Slice nicht mehr still wechseln |
| s17 | dasselbe Phänomen unter zwei Slugs | **still** | ✓ die bewusst menschliche Grenze, gemessen statt behauptet |
| s18a | Alias-Gruppe: Beleg unterm Alias, Slice-Kennung doppelt, eine Invalidierung | **still** | ✓ alle Eingaben der Ableitung liegen vor, niemand liest sie |
| s18b | Alias-Zyklus A → B → A | **still** | ✓ die Kette hat keinen Leser |
| s19a | Archivierungs-Lauf über eine geschlossene Welle | 6 Volltexte im Zip, 4 Stubs | ✓ Reviews bekommen keinen Stub — sie haben keine eigene Identität |
| s19b | Trefferzeilen vorher/nachher **und** die vier Stubs stehen | fallen, Stubs da | ✓ 17 → 5; die zweite Hälfte kam aus einer Mutationsprobe |
| s19c | Slice **ohne** Wellen-Zugehörigkeit | `Welle:` bleibt `ohne Welle`, `Archiviert mit:` nennt die einsammelnde | ✓ zwei Tatsachen, zwei Felder |
| s19d | beide Verweis-Formen nach dem Umzug | 0 Befunde | ✓ — **erst nach einer Reparatur, siehe unten** |
| s19e | Gegenprobe: ohne Verweis-Nachzug | **`target-missing`** | ✓ die Zusage ist belegt, nicht behauptet |
| s19f | nicht gekürzter Slice im Wellen-Verzeichnis | **`section-pattern-missing`** | ✓ der Deckungs-Sensor beißt, mit `structure` allein |
| s19g | Slice der **offenen** Welle, flach in `done/` | **still** | ✓ kein Falsch-Positiv — prüft die Sensor-**Konfiguration**, nicht das Werkzeug (s. u.) |
| s19i | Welle-Stub trägt seine **eigene** Form | Zeiger auf die Ergebnisnotiz + Vorgangszahl | ✓ nachgetragen: die Probe schrieb erst beide Stub-Formen gleich |
| s19h | Rückgriff im `--depth 1`-Klon | Archiv liefert, `git show` scheitert | ✓ die Grenze des Entwurfs, gemessen |

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

**Befund aus s15 — dieselbe Umbenennung, zwei Modi, gegenteilige Antwort;
gemeldet, bestätigt, behoben.** Der Entwurf stützte die Unveränderlichkeit von
Namespace und Slug auf `vcs`:
[`DC-FA-VCS-001`](https://github.com/pt9912/d-check/blob/main/spec/lastenheft.md#dc-fa-vcs-001--git-diff-immutabilität-des-core-über-eine-commit-range-modul-vcs-opt-in)
nennt die **umbenannte** immutable Datei ausdrücklich als `core-drift-vcs`.
Unter `v0.67.0` hing die Zusage am Eingabe-Modus: Über `--staged` meldete der
Rename (s15a), über `--range` — den CI-Pfad — blieb derselbe Rename still.
Erst wenn die Ähnlichkeit unter die Schwelle fiel, entstand die Delete-Hälfte
(s15c). Reproduziert auch an d-checks eigener Dogfood-Klasse, als
**Werkzeug-Befund** gemeldet und dort bestätigt und in **`v0.71.1`** behoben
(Range-Diff ohne Rename-Erkennung, kein Lastenheft-Bump: die Anforderung war
nicht falsch, sie war nicht eingelöst). Seit dem Pin-Bump messen s15b und s16c
den Fix — beide Modi antworten gleich. Die schärfste Folge misst s16c: Weil
der Dateiname eines Belegs **die** Slice-Kennung ist, hätte ein reiner Rename
den Zähler richtig gelassen und den Beleg falsch gemacht; heute meldet es.

**Befund aus s19 — was jedes Verdikt absichert, und was nicht.** Ein Review
hat acht Mutationen gegen die Archivierungs-Operation gefahren. Zwei Ergebnisse
gehören benannt: **s19g** wird unter *keiner* Mutation des Werkzeugs rot — es
sichert die Sensor-**Konfiguration** ab (der welle-gescopte Glob), nicht die
Operation; rot wird es erst, wenn man den Glob auf die flache Vor-Probe-Form
zurückstellt. Das ist als Regressions-Wächter richtig, aber es sagt nichts über
das Archivieren. Und **der Deckungs-Sensor prüft die Marke, nicht die
Kürzung**: Ein Stub mit `Archiviert mit:`, der den vollen Text behalten hat,
kommt durch — nur die Trefferzahl von s19b fällt darauf.

**Befund aus s19 — ein Verdikt maß die falsche Größe.** `s19b` prüfte nur, dass
die Trefferzahl *fällt*. Eine Mutationsprobe — die Kürzung fällt aus, es
entstehen gar keine Stubs — ließ es **grün**: Löschen senkt die Zahl genauso
wie Kürzen. Das Verdikt hängt jetzt zusätzlich an den vier Stubs, und dieselbe
Mutation macht es rot. Genau die Klasse, die ein Konsumenten-Register als
*„ein Test, dessen Umkehrung grün bleibt"* führt — hier an der eigenen Suite
gefunden, nicht am Gegenstand.

**Befund aus s19 — der Verweis-Nachzug braucht zwei Formen, nicht eine.** Der
erste Lauf war rot: Der Nachzug traf nur Verweise mit `done/`-Präfix, wie das
Register sie schreibt. Die **Ergebnisnotiz** schreibt aber
geschwister-relativ — sie liegt selbst in `done/` und **bleibt** dort, während
ihre Slices ins Wellen-Verzeichnis wandern. Das ist kein Sonderfall, sondern
der garantierte Fall dieses Entwurfs, und es ist dieselbe Blindstelle, die der
Skriptkopf von `slice-mv.sh` im Nachbar-Repo für sich benennt. Mit beiden
Formen ist s19d grün; s19e zeigt per Gegenprobe, dass die Zusage ohne Nachzug
wirklich bricht.

**Befund aus s12–s18 — was die Form ohne Werkzeug gewinnt, und was sie ihm
schuldet.** Drei der sieben Fälle entscheidet **git** allein: getrennte
Belege addieren sich beim Merge (s12), derselbe Pfad streitet laut (s13), ein
geänderter oder gelöschter Beleg meldet sich (s16a/b) — keiner davon braucht
eine CI-Zusage über den Merge-Stand. Ein vierter ist **bewusst** still (s17):
semantische Gleichheit bleibt menschlich. Zwei sind der Gegenstand des CR und
haben heute keinen Leser: die Schwelle im Merge-Stand (s14b) und die
Alias-/Invalidierungs-Ableitung samt Zyklus (s18). Der siebte galt als gelöst,
war es nicht — und ist es seit `v0.71.1` (s15b). Damit ist die Aussage des Entwurfs — *die
deterministische Hälfte braucht einen CR* — auf ihre belastbare Fassung
gebracht: Sie braucht ihn für **zwei** Aussagen, und für eine dritte braucht
sie eine Reparatur am vorhandenen Modul.

## Grenzen — ausdrücklich

Das hier hebt die Team-Frage von *entworfen* auf **geprobt**, nicht auf
*belegt*: Geprüft ist die **Nebenläufigkeits-Mechanik** mit kooperativen
Akteuren, die die Regeln kennen. Nicht prüfbar sind echter **Dissens**
(TA-6-Terminal), **Lesarten-Divergenz** zwischen Menschen und echte
**Einarbeitung** — und es bleibt Eigenprüfung. Squash-Merges einer Forge
verändern die Historie anders als die lokalen Merges hier; für diese Szenarien
ohne Belang, aber benannt.
