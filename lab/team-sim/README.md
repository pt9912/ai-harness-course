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

**Warum Clones statt Worktrees:** Worktrees teilen ein `.git` und verbieten
denselben Branch zweimal — sie modellieren *einen* Entwickler. Die
Team-Topologie ist geteilter Remote plus lokale Sichten; erst damit ist „was in
einem offenen PR liegt, ist für andere nicht da" real.

## Die Szenarien und ihre Läufe (erster Lauf 2026-08-16, 9/9; erweitert 2026-08-21, 11/11)

| # | Szenario | Erwartung | beobachtet |
|---|---|---|---|
| s01 | Doppel-Anspruch: beide `git mv` denselben Slice auf `main` | zweiter Push non-fast-forward **abgelehnt** | ✓ laut, vor der Arbeit |
| s01b | nach dem Pull: Anspruch sichtbar oder Konflikt | sichtbar/Konflikt | ✓ add/add-Konflikt, laut |
| s02 | gleiche Slice-Nummer, zwei Titel, zwei Branches | Merge **still**, beide Dateien | ✓ exakt wie §Vergabe lehrt |
| s03 | Register: A erhöht Zeile, B legt neue fürs selbe Phänomen an | Merge **still**, Beobachtung halbiert | ✓ — **mit Befund, siehe unten** |
| s04a | zwei offene Wellen, flach + Liste | `planning` grün | ✓ Offene-Wellen-Modell trägt |
| s04b | dazu `waves.dir` aktiviert | **`wave-drift`** | ✓ Singleton-Semantik gemessen |
| s04c | Wellen offen **und** nichts beansprucht: Ruhe-Marker *neben* der Liste | `planning` grün | ✓ der Leer-Anspruch-Fall ist legitim |
| s04d | Gegenprobe: Marker weg, `in-progress/` weiter leer | **`planning-drift`** | ✓ die Äquivalenz hält in beide Richtungen |
| s05 | zwei `MR`s parallel | Dateien still, Index-Zeile **laut** | ✓ Hybrid-These bestätigt |
| s06 | `pre-receive`-Hook schützt `main` | TA-7-Anspruch **scheitert** | ✓ Branch-Protection-Reibung real |
| s07 | Sichtung, während Erhöhung im offenen PR liegt | liest den **gemergten** Stand | ✓ „so alt wie der letzte Merge" |

**Befund aus s03 — die Stille braucht Abstand.** Mit einem *einzeiligen*
Register kollidierten Zeilen-Änderung und Anhang **laut** (benachbarte
Edit-Regionen); erst ab mehreren Zeilen Abstand mergt die Doppel-Zeile still.
Die stille Doppel-Zählung ist also eine Eigenschaft **großer** Register — genau
dort, wo auch das Wiedererkennen am teuersten ist. Das verfeinert die Lehre,
widerlegt sie nicht.

**Befund aus s04c/s04d — der Wächter prüft die Marker-Hälfte, nicht die
Liste.** Der Abschnitt *Offene Wellen* trägt zwei unabhängige Aussagen: Die
Liste folgt den **Dateien**, der Ruhe-Marker folgt dem **Anspruch**. Beides
zugleich (Wellen gelistet, nichts beansprucht) ist der Normalfall direkt nach
der Wellen-Eröffnung — und `planning` bleibt dabei grün (s04c); fehlt der
Marker bei leerem `in-progress/`, meldet derselbe Sensor `planning-drift`
(s04d). Damit ist die Äquivalenz *Marker ⟺ kein Slice in `in-progress/`* in
**beiden** Richtungen gemessen statt behauptet. Was **nicht** gewächtert ist:
die Liste gegen die Welle-Dateien — das wäre eine Bijektion und braucht ein
eigenes Prädikat (offener `waves.dir`-CR, siehe s04b).

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
