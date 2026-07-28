# Review-Runde 9 — die Reparaturen der Runde 8

**Stand:** 2026-07-28. **Status:** vollständig behoben — siehe
[§Behebung](#behebung) am Ende.

**Gegenstand:** der Diff `ade3d67..b23706d` — die Nacharbeit zu
[Runde 8](review-runde-8.md) (dort abgelegt, vollständig behoben; diese Datei
führt ab hier den offenen Stand).

**Verfahren:** wie in den Vorrunden drei unabhängige Reviewer mit getrennten
Linsen und getrenntem Kontext — (1) Satz- und Struktur-Integrität innerhalb
jeder Datei, (2) Kongruenz zwischen Quelle, Spiegel, Template, Lösung,
Lab-Vorbild und CHANGELOG, (3) Mechanik-Tauglichkeit („funktioniert die Regel,
wenn ein Adopter sie wörtlich befolgt?"). Die Nummerierung ist beim
Zusammenführen neu vergeben; wo mehr als eine Linse denselben Defekt unabhängig
fand, ist das vermerkt.

**Umfang:** 31 Befunde, dazu 3 vorbestehende Defekte.
**Davon 28 neu erzeugt durch die Reparaturen der Runde 8.** Die Prognose der
Vorrunde hat sich erneut bestätigt — und diesmal schärfer: **Vier der sieben
Blocker sind Rückfälle in die Klasse R8-01**, also in genau den Defekt, den
diese Runde zum tragenden Befund erklärt hatte.

**Gates zum Zeitpunkt des Reviews:** `make check` grün (d-check 0 Befunde,
`docs-check` 0 ERROR / 0 WARN, `alignment-check` 0 WARN), `lab/example`
`make verify` grün. Kein Befund dieser Runde ist maschinell sichtbar.

**Muster dieser Runde.** Die Runde 8 hat zwei Bewegungen gemacht, und beide
haben ihre eigene Fehlerklasse mitgebracht:

1. **Normlast vom Kommentar in den Rumpf verschieben** (R8-01). Wo die
   Bewegung unvollständig blieb, ist der Defekt jetzt schlimmer als vorher —
   der Rumpf trägt die halbe Regel und liest sich wie die ganze
   (R9-03, R9-04, R9-11). Wo sie gar nicht stattfand, kam neue Normlast in den
   Kommentar (R9-02). Wo sie zu weit ging, steht Regeltext in einem Artefakt,
   das ihn veröffentlicht (R9-05, R9-22).
2. **Eine Regel maschinell prüfbar machen** (Beleg-Formbindung,
   Sektions-Scope, Zielort-Auflösung). Jede dieser drei Schärfungen erzeugt
   einen Sensor, der auf dem eigenen Vorbild feuert oder nicht entscheidbar
   ist (R9-01, R9-20, R9-21).

---

## Blocker

### R9-01 — Die neue Beleg-Formbindung läuft am eigenen Vorbild rot

*(Alle drei Linsen unabhängig; erzeugt in Runde 8, Reparatur des vorbestehenden
Defekts 2.)*

`kurs/de/02-planung/modul-06-roadmap.md` :377–382, Spiegel :93,
`observations.template.md` :35–39:

> der **Beleg** ist formgebunden: eine Slice-Kennung `slice-<NNN>`, die **als
> Datei im Planning-Lifecycle auflöst**, und so viele, wie der Zähler behauptet

**Szenario:** Der Adopter baut den Sensor nach der Norm und kalibriert ihn am
Kurs-Vorbild. Gemessen gegen `lab/example/docs/plan/planning/`:

```
Dateien:  slice-009, slice-013, slice-014, slice-020
BEO-001: 2×, Belege OK — nicht auflösbar: slice-005, slice-011
BEO-003: 2×, Belege OK — nicht auflösbar: slice-008, slice-012
BEO-005: 3×, Belege OK — nicht auflösbar: slice-006, slice-012
BEO-007: 3×, Belege OK — nicht auflösbar: slice-003, slice-005, slice-007
```

**4 von 7 Zeilen rot, 9 nicht auflösbare Belege.** Die Zähler-Hälfte hält
überall, die Datei-Hälfte nirgends. `BEO-007` ist in **diesem** Commit
entstanden — mit drei Belegen, von denen keiner existiert. Drei Zellen tragen
zusätzlich den Freitext, den die Regel ausdrücklich ausschließt
(`slice-020 (§6, Ausgang „weiter offen")`, `slice-012 (Finding-Klasse aus
Review)`).

Der Freibrief `lab/example/…/README.md` :27 („nur exemplarisch vertreten")
deckt fehlende Slice-Dateien — aber genau die macht diese Regel maschinell
prüfbar. Das ist dieselbe Klasse wie R8-04, eine Ebene tiefer: eine Reparatur,
die einen Sensor erzeugt, der am Kurs-Vorbild feuert. Und das Argument, mit dem
R8-14 den Welle-Plan ins Vorbild geholt hat (*„Ohne sie behauptete die Regel
eine Pflicht, die das eigene Vorbild nicht erfüllte"*, `CHANGELOG.md` :101),
gilt hier unverändert und wurde nicht angewandt.

### R9-02 — Das Register-Template hat die R8-01-Behandlung nicht bekommen — und dann neue Normlast in den Kommentar

*(Linse 3)*

`observations.template.md` :9–59 ist ein einziger Kommentarblock. Er trägt:
`WER SCHREIBT` / `WER LIEST` / `OHNE WELLE`, alle vier REGELN — darunter die
**neue Beleg-Formregel** :35–39 —, die Streichungs-Regel, die
MECHANISIERUNGs-Hälfte, und den **Zeiger ins Baseline-Regelwerk** :11–12.

`lab/templates/README.md` :65 ordnet an, alle HTML-Kommentare zu entfernen.

**Szenario:** Der Adopter kopiert nach `docs/plan/planning/observations.md` und
führt Schritt 4+5 aus. Übrig: Überschrift, `**Status:**`-Zeile, zwei Tabellen.
Und weil das Register ein **Singleton** ist (`README.md` :78 führt
`observations` in der Verwerfen-Liste), ist die `.template.md` danach weg — der
Adopter hat keinen Weg zurück zur Regel, nicht einmal den Verweis darauf.

Das Vorbild zeigt, dass es anders geht: `lab/example/…/observations.md` :6
trägt „Regeln: Kurs-Regelwerk `modul-06-roadmap.md` §Das Beobachtungs-Register"
im **Rumpf**. Die R8-01-Reparatur hat `slice`, `welle-results` und `welle`
umgestellt, dieses Template ausgelassen — und dann Normlast hineingelegt.

### R9-03 — Die zweite Hälfte der Anker-Paarung ist beim R8-08-Fix aus dem Rumpf *in* den Kommentar gewandert

*(Linse 1 und Linse 3 unabhängig; erzeugt in Runde 8, Reparatur zu R8-08.)*

`slice.template.md` :146–148:

> `<!-- Das Ziel traegt dann `(seit slice-<NNN>)`. Feld und Pfad stehen auf
>      EINER Zeile … -->`

Dass das Ziel den Herkunfts-Anker tragen muss, ist die **andere Hälfte des
Paares** — Normlast, nicht Begründung. `grep -n "seit slice\|seit welle"
slice.template.md` liefert genau diese eine Zeile: nach Schritt 5 kommt der
Anker im ganzen Artefakt nicht mehr vor.

**Szenario:** Der Adopter schließt einen wellenlosen Slice und schreibt
korrekt `— liegt in \`AGENTS.md §2.7\`.` Nichts sagt ihm mehr, dass
`AGENTS.md §2.7` den Gegenanker `(seit slice-047)` tragen muss. Er schreibt
eine Hälfte; die Anker-Paarung läuft rot mit „Anker vergessen" — die Klasse
*halluziniertes Gate*, gegen die der Sensor gebaut ist.

Die Schwesterdatei macht es richtig: `welle-results.template.md` :66 hält „und
das Ziel trägt `seit welle-<NN>`" im Rumpf. Dieselbe vermeidbare Asymmetrie,
mit der R8-01 argumentiert hat — nur in umgekehrter Richtung.

### R9-04 — Der Rumpf des Slice-Templates ordnet die benannte Spec-Lücke „gezählt, nicht verkörpert" zu

*(Linse 1 und Linse 3 unabhängig; erzeugt in Runde 8, Reparatur zu R8-05.)*

`slice.template.md` :135–137 (Rumpf, überlebt):

> Das Feld `liegt in` steht nur, wenn die Regel **mit diesem Slice** verkörpert
> wurde …; sonst entfällt es und der Eintrag ist *gezählt, nicht verkörpert*.

:117–121 (Kommentar, wird gelöscht) trägt die Ausnahme: die Spec-Lücke trägt
kein Feld und ist trotzdem verkörpert.

**Szenario:** Wellenloser Slice, `BEO-011` erreicht mit ihm 3× und wird über
Lastenheft v0.4.0 aufgelöst — eine benannte Spec-Lücke, kein Pfad. Nach
Schritt 5 liest der Adopter nur den Rumpf: kein Feld ⇒ „gezählt, nicht
verkörpert". Genau die Zuordnung, die die §Behebung der Runde 8 für „schlicht
falsch" erklärt.

Quelle (`konventionen.md` :867), Spiegel (:829) und Modul 6 (:520) tragen die
Ausnahme im Rumpf. Ausgerechnet die eine Datei, in der ein wellenlos
verkörperter Slice sie braucht, verliert sie beim Kopieren.

### R9-05 — `welle.template.md` §7 bekam einen Rumpf, der bis zur Closure auf nichts zeigt

*(Linse 3; erzeugt in Runde 8, Reparatur zu R8-01/R8-23.)*

`welle.template.md` :101–102:

> `Ergebnis: [\`welle-<NN>-results.md\`](welle-<NN>-results.md).`
> `Zähler: [\`../observations.md\`](../observations.md).`

**Szenario:** Der Adopter eröffnet Welle 1, kopiert nach
`docs/plan/planning/welle-1-mvp.md`, ersetzt `<NN>` (Schritt 3) und löscht die
Kommentare (Schritt 5) — darunter :83 „Erst nach Welle-Abschluss füllen". Zwei
Links im Rumpf einer **flach liegenden** Datei:

- `welle-1-results.md` entsteht erst bei der Closure, Wochen später.
- `../observations.md` ist nach der Ruheort-Regel :86–90 von `done/` aus <!-- d-check:ignore (zitierter Template-Pfad, relativ zum Adopter-Repo) -->
  geschrieben; flach in `planning/` löst es nach `docs/plan/observations.md`
  auf — existiert nicht.

Die mitgelieferte Gate-Baseline `lab/templates/.d-check.yml` fährt
`modules: [links, anchors]` über `roots: ["."]` und ignoriert nur
`**/*.template.md`, nicht die gefüllte Datei. **`make docs-check` ist damit vom
ersten Tag der Welle bis zur Closure rot** — für zwei Links, die der Adopter
gar nicht schreiben sollte.

Das eigene Vorbild macht es umgekehrt: `welle-2-qualitaet.md` :58–61 (aktive
Welle, in diesem Diff neu) hat in §7 nur den Kommentar und keinen Rumpf. Genau
deshalb ist `make verify` grün — das Vorbild widerlegt das Template still.

### R9-06 — „ohne laufende Welle" steht auf der falschen Achse — die Norm meint den Repo-Modus

*(Linse 2 zweifach, Linse 1 unabhängig; erzeugt in Runde 8, Reparatur zu
R8-06/R8-07.)*

**Keine offene Sachfrage — die Norm ist eindeutig, Runde 8 hat sie falsch
umgesetzt.** Es sind zwei Achsen, und Runde 8 hat sie zusammengezogen:

| Achse | Frage | Belegstelle | Entscheidet |
|---|---|---|---|
| **Repo-Modus** | Schneidet dieses Repo überhaupt Wellen? | Modul 6 :302 „In einem **Repo mit Wellen** …", :282 „Wer lange wellenlos arbeitet", :634 „ohne Welle gibt es gar keinen Träger" | Wer Lese-Schritt, Sichtungs-Schritt, Trigger-Audit und die **drei Paarungen** trägt — und ob der Anker `seit welle-<NN>` oder `seit slice-<NNN>` lautet |
| **Slice-Zugehörigkeit** | Gehört *dieser* Slice in ein Wellen-Bündel? | `slice.template.md` :12 `**Welle:** <welle-id> oder "ohne Welle"` | Nur, ob seine Closure auf einen Wellen-Trigger wartet |

Die gesamte Steering-Loop-Mechanik hängt an der **ersten** Achse. Ein Repo mit
Wellen hat eine Welle-Closure, die alles seit der letzten Welle in `done/`
durchgeht — **auch Slices, die zu keiner Welle gehören**. Erst wenn das Repo
gar keine Wellen schneidet, fehlt dieser Sammelpunkt, und die Slice-Closure
muss selbst prüfen.

Der Ausdruck trägt in diesem Diff dennoch an verschiedenen Orten zwei
verschiedene Schwellen:

| Ort | Lesart |
|---|---|
| Modul 6 :301–303 („in einem **Repo mit Wellen** … ohne Welle findet die nicht statt") | **Repo**-Ebene: es läuft überhaupt keine Welle |
| `slice.template.md` :49, :152 („Gehört **der Slice** zu einer Welle, prüft sie deren Closure") | **Slice**-Ebene: dieser Slice gehört zu keiner |
| `modul-06-loesung.md` :308 („Gehört er — wie hier — zu **keiner**, gibt es keine Welle-Closure, auf die zu warten wäre") | schließt von der Slice-Ebene auf die Repo-Ebene |

Das sind verschiedene Sensoren. Der Schluss in der Lösung ist ungültig: Ein
Slice kann zu keiner Welle gehören, während im Repo eine läuft.

**Und genau das führt das Vorbild vor.** `slice-020` :5 trägt
„**Welle:** ohne Welle", :9 „**Datum:** 2026-06-03" — und behauptet :33 und
:85 „**ohne laufende Welle**: die drei Paarungen geprüft". In demselben Diff
ist `welle-2-qualitaet.md` als **flach liegende, laufende** Welle angelegt
worden, :11 „**Datum:** 2026-05-29", Roadmap :13 „Start: 2026-05-29" — fünf
Tage *vor* slice-020s Closure. Nach der Norm hätte hier die Welle-2-Closure
geprüft, nicht die Slice-Closure.

Der einzige Vorbild-Beleg für den wellenlosen Paarungs-Zweig steht damit in
einem Repo-Zustand, den er selbst widerlegt.

**Was daraus folgt** (keine Abwägung, drei falsche Stellen): `slice.template.md`
:49 und :152 fragen die falsche Achse ab — richtig ist *führt dein Repo
Wellen?*. `slice-020` :33/:85 behauptet „ohne laufende Welle" in einem Repo mit
zwei Wellen; seine Paarungen prüft die welle-2-Closure. Und
`modul-06-loesung.md` :306–310 zieht den ungültigen Schluss *gehört zu keiner
Welle ⇒ es gibt keine Welle-Closure* — siehe R9-07.

### R9-07 — Der Maßstab der Musterlösung bestraft die Antwort, die die Musterlösung drei Zeilen darüber verlangt

*(Linse 1 und Linse 2 unabhängig; erzeugt in Runde 8, Reparatur zu R8-18.)*

`kurs/de/loesungen/modul-06-loesung.md` :306–315:

> :308–310 „Gehört er … zu **keiner** … die Slice-Closure löst den Lese-Schritt
> selbst aus … Wer hier **ausnahmslos** ‚bis zur nächsten Welle-Closure'
> antwortet, hat den wellenlosen Zweig übersehen."
> :314–315 „**Maßstab:** Die Antwort trennt *eintragen* (Slice-Closure) von
> *lesen* (**Welle-Closure**) …"

Der unveränderte Maßstab schreibt genau die Zuordnung als Kriterium fest, die
der neue Absatz drei Zeilen darüber als Fehler markiert. Ein Bewerter, der dem
Maßstab folgt, wertet die eigene Musterlösung ab.

Dazu die Prämisse: Die Übung `modul-06-roadmap.md` :574 fragt „Der Eintrag
steht danach bei 3×, **aber die nächste Welle-Closure ist Wochen entfernt**:
Was passiert bis dahin?" — sie setzt eine bestehende nächste Welle-Closure
voraus, also ein Repo **mit** Wellen.

**Die Auflösung ist einseitig** (aus R9-06): Der Maßstab hat recht, der neue
Absatz nicht. In einem Repo mit Wellen liest die nächste Welle-Closure, auch
für einen Slice, der zu keiner Welle gehört. Der wellenlose Zweig gehört
erwähnt — aber als *Repo-ohne-Wellen*-Fall, nicht als Folge der
Slice-Zugehörigkeit. Die Reparatur zu R8-18 ist zurückzunehmen, nicht
weiterzuentwickeln.

---

## Weitere Befunde

### R9-08 — Der Fluss-Graph kennt den wellenlosen Leser nicht — er ist der einzige Ort, der ihn zeigen müsste

*(Linse 2 und Linse 3 unabhängig)*

`kurs/de/grundlagen/konventionen.md` :915–917:

> `C -- "1x / 2x: bleibt offen" --> F["Wellen-Eröffnung Schritt 2: …"]`
> `F --> G["Slice-Planung: Sub-Area-Modus-Begründung Kriterium 3"]`

Der Graph wird :936–938 ausdrücklich als „die ausgearbeitete Illustration der
Regel §Jedes Artefakt hat einen Konsumenten" eingeführt. Für 1×/2× hat er
weiterhin genau **einen** Ausgang — die Wellen-Eröffnung, die im wellenlosen
Repo nie stattfindet. Damit ist `G` unerreichbar und die linke Schleife tot:
genau der Zustand, den R8-15 geschlossen haben sollte. Die Reparatur ist in
Quelle, Spiegel, Template und Modul 5 nachgezogen worden, ins Diagramm nicht.
Zusätzlich nennt `G` weiterhin „Kriterium 3", während die neue Norm den Block
*Vorgelagert* nennt.

### R9-09 — Knoten `E`: trägerlose Formel plus ein Pflichtfeld, das eine der drei Klassen nicht trägt

*(Linse 1)*

`konventionen.md` :913 — in diesem Diff angefasst:

> `E["Verkörperung<br/>(Lese-Schritt löst aus: Welle-Closure,<br/>ohne Welle
> eigenständig)<br/>Steering-Loop-Eintrag + Pflichtfeld<br/>liegt in
> &lt;Zielort&gt;"]`

Zwei Defekte in einem Knoten. **Erstens** „ohne Welle eigenständig" — die
Formel ohne Träger und Moment, die R8-24 in Quelle und Spiegel ersetzt hat; die
§Behebung behauptet, sie „steht nirgends mehr". **Zweitens** ist `E` der
einzige Ausgang des 3×-Zweiges, also auch der Weg der benannten Spec-Lücke —
und die trägt nach :867 gerade kein `liegt in`. Die R8-19-Reparatur hat den
Knoten von „+ Zielort" auf „+ Pflichtfeld liegt in <Zielort>" verschärft und
den Widerspruch damit erst scharf gemacht.

### R9-10 — Das Register-Template führt in seinen REGELN die Formel weiter, die seine eigene OHNE-WELLE-Zeile gerade ersetzt hat

*(Linse 1 und Linse 2 unabhängig)*

`observations.template.md` :42–43 gegen :24–25 derselben Datei:

> :24–25 (neu) „den Lese-Schritt **loest die Slice-Closure aus**"
> :42–43 (alt) „Ohne Welle: beim **eigenstaendig ausgeloesten** Lese-Schritt"

Acht Zeilen auseinander, in dem Artefakt, das die Regeln des Registers führt.
Ein netzloser Adopter liest beide Fassungen in derselben Datei.

### R9-11 — Der neue Rumpf definiert die Register-Paarung mit einer Hälfte, nachdem die Runde zwei entschieden hat

*(Linse 2)*

`welle-results.template.md` :67–69 — die Zeile, die R8-01 aus dem Kommentar in
den überlebenden Rumpf gehoben hat:

> die Anker-Paarung und die **Register-Paarung (jede genannte `BEO-<NNN>` hat
> eine Zeile im Register)**

Quelle :528–530, Spiegel :174–178, CHANGELOG :64–66 und
`observations.template.md` :53–58 sagen alle „**zwei Hälften** … **und** jede
Registerzeile trägt mindestens einen Beleg". Nach Schritt 5 ist die
Ein-Hälften-Fassung die einzige, die beim Adopter ankommt — die zweite Hälfte
und mit ihr die Beleg-Formbindung fällt aus dem Artefakt heraus, das sie
erzwingen soll.

### R9-12 — Die Beispielzeile des Registers verletzt die Regel 26 Zeilen darüber

*(Linse 1 und Linse 3 unabhängig)*

`observations.template.md` :38–39 gegen :65:

> :39 „Die Anzahl der Belege MUSS dem Zaehler entsprechen."
> :65 `| BEO-003 | <Beispiel: Schwelle erreicht> | … | 3× | <slice-NNN>, … |`

Ein Platzhalter plus Auslassungspunkte für einen Zähler von 3×. Die Zeilen für
1× und 2× (:63/:64) stimmen — nur die Zeile für den Schwellenfall, den die
Regel adressiert, nicht.

### R9-13 — Ein DoD-Item, das erst nach dem `git mv` erfüllbar ist, entscheidet über den `git mv`

*(Linse 3; erzeugt in Runde 8, Reparatur zu R8-06/R8-07.)*

`slice.template.md` :49 gegen :34 und `README.template.md` :21:

> :34 „Was muss erfüllt sein, damit der Slice in `done/` wandert?"
> :49 „- [ ] Ohne laufende Welle: die drei Paarungen … geprüft — **nach** dem
> `git mv` nach `done/`"

Die Auflösung („Das letzte Item liegt bewusst HINTER dem `git mv`") steht
:38–39 **im Kommentar** und ist nach Schritt 5 weg — R8-01-Klasse.

Dazu die Hard Rule „git mv + Inhaltsänderung = zwei Commits"
(`README.template.md` :10–12): Das Paarungs-Ergebnis wird laut :152 **in** die
Datei geschrieben, der Ablauf braucht also drei Commits (§7 schreiben → reiner
`git mv` → Ergebnis nachtragen). Der Kurs benennt zwei.

**Szenario:** Der Adopter bewegt entweder mit unerfüllter DoD, oder er prüft
die Paarungen im `in-progress/`-Zustand — dann laufen sie grün, weil sie in
`done/` nichts finden. Der Fall, den R8-07 schließen sollte.

Und das Vorbild führt es vor: `slice-020` :33 hakt das Item mit `[x]` ab.

### R9-14 — Der Paarungs-Zeitpunkt der Welle-Closure ist mit einem `git mv` begründet, den es dort für die geprüften Einträge nicht gibt

*(Linse 1 und Linse 2 unabhängig; erzeugt in Runde 8, Reparatur zu R8-07.)*

`modul-06-roadmap.md` :513–514, Spiegel :169–170:

> in Schritt 2 gäbe es sie noch nicht, **und vor dem `git mv` lägen sie nicht
> in `done/`**, wo die Paarungen suchen

Der einzige `git mv` dieses Schrittes (:491) bewegt die Welle-**Plan**-Datei,
die keine Steering-Loop-Einträge trägt. Die geprüften Einträge stehen in
`welle-<NN>-results.md`, und die wird laut `welle-results.template.md` :4
direkt **nach `done/` kopiert** — sie liegt dort vom ersten Moment an. Die
Begründung ist aus dem wellenlosen Slice-Fall importiert, wo die Datei selbst
wandert. Ein Adopter, der die Reihenfolge daraus ableitet, wartet auf ein
Ereignis, das für seine Prüfobjekte nie eintritt.

### R9-15 — Der einzige wellenlose Leser sitzt in einer Sektion, die dasselbe Template freistellt

*(Linse 2 und Linse 3 unabhängig; erzeugt in Runde 8, Reparatur zu R8-15.)*

`slice.template.md` :159 gegen :179–185:

> :159 „**Optional bei reinem Refactor** ohne neue Sub-Area-Berührung."
> :179–185 „Beide *Vorgelagert*-Blöcke hängen nicht am Modus … der **einzige
> Leser** für alles, was unter der Schwelle steht … Fällt er weg, ist das
> Register unterhalb von 3× write-only."

**Szenario:** Wellenloses Repo, der nächste Slice ist ein reiner Refactor. Der
Adopter lässt §8 weg — ausdrücklich erlaubt. Damit entfällt der Leser, den drei
Zeilen darüber für unverzichtbar erklärt wird. Die Reparatur hat die
**Modus**-Achse geschlossen und die **Existenz**-Achse übersehen.

Dazu die Kongruenz: `lab/templates/README.md` :162–165 beschreibt §8 weiter
modusgebunden, und der Spiegel-Abschnitt, der §8 definiert
(`modul-05-planning-harness.md` :145–150), zählt dessen Bestandteile
abschließend auf und kennt den Block gar nicht.

### R9-16 — Der neu ernannte Träger des Sichtungs-Schritts hat kein Vorbild und keine Quell-Verankerung

*(Linse 1 und Linse 3 unabhängig; erzeugt in Runde 8, Reparatur zu R8-15.)*

`modul-06-roadmap.md` :295 nennt als Träger „Slice-**Planung**, §8
*Vorgelagert — offene Beobachtungen sichten*, beim Anlegen **jedes** Slice".

`grep -rn "Vorgelagert" kurs/ lab/` liefert Treffer nur in `slice.template.md`,
`observations.template.md` und den beiden Modul-6-Dateien — **keinen einzigen
in `lab/example/`**. Alle vier Vorbild-Slices haben ein §8, das nur aus dem
GF-Status-Hinweis besteht; keiner sichtet das Register. `slice-020` ist
ausdrücklich das *wellenlose* Vorbild — und im Register stehen zu diesem
Zeitpunkt `BEO-001` bis `BEO-004` und `BEO-006` unter der Schwelle, ohne dass
sie je jemand liest.

Zugleich fehlt die Quell-Verankerung: Modul 5 kennt die Sichtung nur als
**Kriterium 3** (:227–233), und sein eigenes GF-Worked-Example beantwortet
Kriterium 3 (:248–251) ohne das Register überhaupt zu erwähnen. Der Block
existiert damit nur im Template — Template-Struktur ohne Quelle, die Klasse aus
[Feedback: Quelle ist Anker](../../CHANGELOG.md).

### R9-17 — Rubrik und Lösungstabelle stehen auf dem Stand vor der Träger-Entscheidung

*(Linse 1 und Linse 2 unabhängig)*

- Rubrik `modul-06-roadmap.md` :634 (*exzellent*): „den Lese-Schritt **löst
  dann aus, wer wellenlos arbeitet**" — trägerlos, die Formel aus R8-24.
- Lösung `modul-06-loesung.md` :201–202: derselbe Satz.
- Lösung :193–195, Tabelle *Wer einträgt, wer liest*: zwei Zeilen,
  `Slice-Closure` schreibt, `Welle-Closure` liest — Modul 5 :68–71 nennt seit
  diesem Diff **zwei** Leser.
- Rubrik :631 (Tool-Pin-Zeile, *solide*): „sein Steering-Loop-Eintrag wird bei
  der **Slice-Closure** eingetragen, gelesen wird es bei der nächsten
  **Welle-Closure**" — bei einem Slice, den dieselbe Zelle als „ohne Welle"
  einordnet.

Die R8-17-Reparatur hat den Lösungsblock ergänzt, die Rubrik nicht. Ein
Lernender wird an Kriterien gemessen, die die Norm in derselben Datei 340
Zeilen höher aufgegeben hat.

### R9-18 — Der neue Vorbild-Kommentar verweist auf ein DoD-Item, das dort fehlt — und behauptet die Ausnahme unbedingt

*(Linse 1; erzeugt in Runde 8, Reparatur zu R8-13.)*

`slice-013-property-tests.md` :51–53 und `slice-014-ann-suche.md` :51–53:

> „Ausnahme: die drei Paarungen werden erst danach geprüft (**§2, letztes
> DoD-Item**)."

Das letzte DoD-Item ist in `slice-013` „Closure-Notiz mit gefundenen
Counter-Examples", in `slice-014` „Closure-Notiz mit Recall-Vergleich" — ein
Paarungs-Item existiert in keiner der beiden Dateien. Beiden fehlt außerdem das
Register-Item, das das Template seit Welle 59 trägt.

Zweitens gehören beide Slices zu einer Welle (`welle-2-qualitaet` bzw.
`welle-3-skalierung`). Die Ausnahme gilt laut Template :49 nur „ohne laufende
Welle"; der Kommentar behauptet sie unbedingt.

### R9-19 — „nicht durch eine Sektion" und „Der Geltungsbereich ist die Sektion" stehen sechs Zeilen auseinander

*(Linse 1; erzeugt in Runde 8, Reparatur zu R8-22.)*

`konventionen.md` :840 und :847, Spiegel :809 / :816:

> :840 „Ausgelöst wird durch ein Feld, **nicht durch eine Sektion** und nicht
> durch Prosa"
> :847 „**Der Geltungsbereich ist die Sektion**, nicht die Datei."

Dasselbe Wort trägt in unmittelbarer Nachbarschaft die gegensätzliche Wertung:
erst ist die Sektion ausdrücklich *nicht* das Auslösende, dann die konstitutive
Bedingung dafür, dass überhaupt ein Feld vorliegt.

### R9-20 — Der Sektions-Scope steht nicht in dem Modul, das beide Formen lehrt

*(Linse 2)*

Der Scope steht ausschließlich in `konventionen.md` :847–853 und seinem
Spiegel. In **Modul 6**, wo beide Formen unmittelbar nebeneinander gelehrt
werden, steht er an keiner der drei Stellen:

- :58 und :628 und Lösung :31 — „`SL-024` **liegt in** `done/`" als
  Muster-Trigger,
- :516 — „ausgelöst durch das Pflichtfeld `liegt in <Zielort>`, **nicht durch
  die Semantik des Eintrags**" — ohne jeden Sektions-Vorbehalt.

`CHANGELOG.md` :117 und die §Behebung der Runde 8 begründen den Verzicht auf
eine Umformulierung damit, der Scope löse das Problem. Wer Modul 6 liest, sieht
die Kollision und nicht ihre Auflösung.

### R9-21 — „Der Pfad existiert" — relativ wozu? Zwei Konventionen in einem Feldblock

*(Linse 3; erzeugt in Runde 8, Reparatur zu R8-16.)*

`konventionen.md` :857–858:

> Geprüft wird dann: (1) **der Pfad existiert** — dafür trennt der Sensor ein
> Suffix ab ` §` oder ab `:` ab und prüft den Rest als Pfad

Das Feld steht in `docs/plan/planning/done/slice-047-….md`. Im selben
Bullet-Block von `slice.template.md` §7 stehen beide Konventionen:

- :144 `liegt in \`AGENTS.md §X\`` — nur **repo-root**-relativ auflösbar
  (`lab/example/AGENTS.md` liegt in der Wurzel),
- :149 „Beobachtungs-Register (`../observations.md`)" — **datei**-relativ. <!-- d-check:ignore (zitierter Template-Pfad, relativ zum Adopter-Repo) -->

Löst der Sensor datei-relativ auf, sucht er
`docs/plan/planning/done/AGENTS.md` → rot auf einem korrekten Eintrag. Löst er
root-relativ auf, bricht die Ruheort-Regel aus `welle.template.md` :86–90, die
für dieselben Sektionen datei-relativ anordnet. Kein Satz sagt, welche gilt.

### R9-22 — Der Regeltext im Rumpf ist dem Platzhalter-Ersetzen ausgeliefert

*(Linse 3; erzeugt in Runde 8, Reparatur zu R8-01.)*

`welle-results.template.md` :61–69 ist in diesem Diff in den **Rumpf**
gewandert — er überlebt also und wandert mit `<Zielort>`, `<NN>`, `<NNN>` in
jedes veröffentlichte Artefakt. `lab/templates/README.md` :63 ordnet an:
„**`<Platzhalter>`-Stellen ersetzen.**"

Das Vorbild `welle-1-results.md` :29–30 wendet Schritt 3 auf zwei Platzhalter
**derselben Zeile** gegensätzlich an: `<NN>` → `1`, `<Zielort>` bleibt stehen.
Ein Adopter, der Schritt 3 wörtlich befolgt, macht aus der allgemeinen Regel
eine falsche Einzelaussage („das Pflichtfeld `liegt in AGENTS.md §2.7`"). Der
Rumpf-Umzug hat keine Kennzeichnung mitgeliefert, die Regeltext vom
Platzhalter-Ersetzen ausnimmt.

### R9-23 — Das CHANGELOG behauptet im selben Abschnitt die Formbindung und dass die Paarung im Vorbild hält

*(Linse 2)*

`CHANGELOG.md` :67–69 gegen :96–98:

> :67 „Der Beleg ist dabei **formgebunden** … sonst wäre die Belegspalte frei
> erfindbar."
> :96 „… — **die Register-Paarung hält damit im Vorbild**."

Die zweite Aussage prüft nur die erste Hälfte. Die zweite Hälfte, die derselbe
Eintrag 30 Zeilen höher als formgebunden deklariert, hält nicht (R9-01). Das
kanonische Register behauptet eine Vollständigkeit, die es selbst 30 Zeilen
zuvor unmöglich gemacht hat.

### R9-24 — Der Auszug-Kommentar im Kursmodul zählt `BEO-007` nicht mit

*(Linse 2)*

`modul-06-roadmap.md` :337:

> `<!-- Auszug: BEO-002..004 und BEO-006 hier weggelassen -->`

Gezeigt 2 + weggelassen 4 = 6; das Register hat seit diesem Diff **sieben**
Zeilen (`CHANGELOG.md` :94 sagt es selbst). `BEO-007` fehlt. Der Kommentar ist
genau die Deckungs-Zusage, die das Modul zwei Absätze später von jedem Register
verlangt.

### R9-25 — Die aktive Welle im Vorbild hat §7 als Kommentar, das Template als Rumpf

*(Linse 2)*

`welle-2-qualitaet.md` :58–61 trägt §7 nur als Kommentar; `welle.template.md`
:101–102 und der geschlossene `welle-1-mvp.md` :70–71 tragen den Rumpf. Ein
Adopter, der die aktive Welle als Muster nimmt, bekommt eine §7 ohne Rumpf.
(Siehe R9-05: unter den aktuellen Regeln ist die Vorbild-Fassung die
*richtige* — die Divergenz zeigt, dass das Template repariert gehört, nicht das
Vorbild.)

### R9-26 — Die Template-Überschrift weicht von allen sechs realen Instanzen ab

*(Linse 3; vorbestehend, durch den neuen Scope erst tragend.)*

`slice.template.md` :102 heißt `## 7. Closure-Notiz (bei Closure zu füllen)`.
Alle sechs realen Instanzen in `lab/example` und `lab/templates` heißen
`## 7. Closure-Notiz`.

Der Zusatz ist kein `<Platzhalter>` (Schritt 3 greift nicht) und kein Kommentar
(Schritt 5 greift nicht) — er bleibt dauerhaft stehen. `konventionen.md`
:842–843 macht die Sektion seit diesem Diff zum **Geltungsbereich** des
Auslösers; ein sektions-scoped Sensor auf exakter Überschrift trifft entweder
die Adopter-Dateien nicht oder das Vorbild nicht.

### R9-27 — „Geplant" ist eine dritte Welle-Position, für die die Zwei-Positionen-Regel keinen Ort hat

*(Linse 3)*

`welle.template.md` :13 / `README.template.md` :27–33:

> Ob eine flache Welle *aktuell* oder *geplant* ist, sagt die Roadmap.

Der Satz setzt voraus, dass geplante Wellen flach liegen — sonst gäbe es nichts
zu disambiguieren. Das Vorbild führt `welle-3-skalierung` und `welle-4-betrieb`
in der Roadmap :25–26 als geplante Wellen; `find` zeigt **keine** Datei zu
beiden. Wer die Regel wörtlich befolgt, legt für jede geplante Welle eine
flache Datei an — und erbt für jede sofort die zwei toten Links aus R9-05, über
den gesamten Planungshorizont.

### R9-28 — Der Spiegel sagt die Pointe der Rückführungen zweimal

*(Linse 1; erzeugt in Runde 8, Reparatur zu R8-11.)*

`lab/regelwerk/modul-05-planning-harness.md` :31–33 und :53–56 führen dieselben
zwei Übergänge mit derselben Begründung ein — der neue Absatz und der
bestehende Abschnitt *Trigger je Lifecycle-Übergang*, 20 Zeilen auseinander.

### R9-29 — Der Modultext beantwortet jetzt wörtlich seine eigene Übung

*(Linse 1; erzeugt in Runde 8, Reparatur zu R8-11.)*

`modul-05-planning-harness.md` :62–64 („Sie sehen wie Scheitern aus und tragen
in Wahrheit die Lifecycle-Disziplin — wer sie nicht benutzt, schiebt still
weiter.") gegen Übung :351 („Welcher der fünf ist am leichtesten zu übersehen —
und warum?") und die *exzellent*-Zelle :362, die genau diese Pointe belohnt.
Vor der Reparatur stand sie nur in Übung und Rubrik.

### R9-30 — Dieselbe Formangabe steht jetzt in drei Modulen in zwei Wortlauten

*(Linse 2; erzeugt in Runde 8, Reparatur zu R8-25.)*

- Modul 9 (Quelle :148 / Spiegel :154, in diesem Diff angeglichen):
  „`(seit welle-<NN>)` **— ohne Welle** `(seit slice-<NNN>)`"
- Modul 10 (:214 / :76) und Modul 13 (:142 / :75): „`(seit welle-<NN>)`
  **bzw.** `(seit slice-<NNN>)`"

R8-25 hat Modul 9 mit seinem Spiegel wortgleich gemacht — und dabei die
Quer-Kongruenz zu Modul 10/13 aufgegeben, die vorher die Referenz war.

### R9-31 — „Sechs Form-Zeilen" — es sind sieben

*(Linse 1)*

`docs/reviews/review-runde-8.md` :494 behauptet für `slice.template.md` §7
„eine Regel-Zeile … plus **sechs** Form-Zeilen". Nachgezählt: sieben
(:141–152). Die Runde führt unter §Geprüft und ohne Befund eigens den Punkt
„Zahlwörter … alle nachgezählt und korrekt".

---

## Vorbestehend — nicht aus diesem Diff

- **`check_closure_notes.py` misst §5 statt §7.** `find_closure_section`
  nimmt die *erste* Überschrift, deren Titel „closure" enthält — das ist
  `## 5. Closure-Trigger`. Gegenprobe: `slice-020` mit vollständig geleertem §7
  bleibt grün. Das war schon vorher so; dieser Diff macht §7 zum Träger von
  vier neuen Pflichten und schiebt mit `welle-1-mvp.md` eine Artefaktklasse in
  den Scan, deren §3 *Closure-**Trigger*** die Prüfung abfängt. Ein Adopter,
  der den Gate übernimmt, hält §7 für bewacht.
- **Der Planning-Index schickt aufgelöste Carveouts ins falsche `done/`.**
  `README.template.md` :39–41 sagt, sie wandern nach `done/` — sein `done/` ist
  `docs/plan/planning/done/`. Carveouts ruhen in `docs/plan/carveouts/done/`
  (Modul 7 :159, so auch im Vorbild). Die in diesem Diff neu geschriebene
  Vorbild-Parallele lässt die Klausel wortlos weg, statt sie zu spiegeln.
- **Das Vorbild führt die Snapshot-Tabelle, die das Template verbietet** —
  und beruft sich das Template für seine Empfehlung ausgerechnet auf
  `lab/example`. Die Tabelle nennt zudem weder `welle-1-mvp.md` noch
  `welle-1-results.md`, die in diesem Diff nach `done/` gekommen sind. Genau
  die vorhergesagte Drift, im Beleg-Repo der Regel.

---

## Geprüft und ohne Befund

- **Die R8-05-Entscheidung selbst hält**, wo sie im Rumpf steht: Quelle
  `konventionen.md` :867, Spiegel :829, Modul 6 :520 und
  `welle-results.template.md` :61–69 sagen übereinstimmend *verkörpert, nur
  nicht an einem Zielort*. Nur `slice.template.md` fällt heraus (R9-04).
- **Die R8-04-Entscheidung ist an allen Prosa-Stellen durchgezogen**: Quelle,
  Spiegel, CHANGELOG und `observations.template.md` sagen alle „zwei Hälften,
  nicht die Umkehrung". Nur der Template-Rumpf fällt heraus (R9-11).
- **Die Anker-Auflösung `done/slice-<NNN>-*.md`** trifft die realen Dateinamen
  in `lab/example` (`slice-009-tie-break-determinismus.md`,
  `slice-020-referenz-richtung-repariert.md`).
- **Der Welle-Plan ist im Vorbild angekommen** und die Verzeichnis-Positionen
  stimmen: `done/welle-1-mvp.md` neben `done/welle-1-results.md`,
  `welle-2-qualitaet.md` flach. Die Roadmap führt beide korrekt.
- **Relative Pfade der neuen Vorbild-Dateien** lösen aus ihrer jeweiligen Tiefe
  auf (sechs bzw. fünf Ebenen), Anker `#wann-arbeit-eine-welle-braucht--und-wann-nicht`
  existiert.
- **Code-Fences paarig, Mermaid-Blöcke geschlossen, Tabellen
  spaltenzahl-korrekt** über alle 24 geänderten Dateien.
- **`docs/reviews/`** — die Verschiebung bricht keinen Verweis; die beiden
  internen Links von Runde 8 auf Runde 7 lösen im neuen Ordner auf.

---

## Entschieden — 2026-07-28, vor der Reparatur

Zwei Punkte, die dieses Review als offen ausgegeben hatte. Der erste war es
nicht: Die Norm beantwortet ihn, Runde 8 hat sie falsch umgesetzt. Der zweite
ist eine echte Lücke und wird geschlossen.

### E-1 — „ohne Welle" ist der **Repo-Modus**, nicht die Slice-Zugehörigkeit

Ein Repo arbeitet **mit Wellen und Slices** oder **nur mit Slices**. Daran
hängt die gesamte Steering-Loop-Mechanik (Details und Belegstellen in R9-06).
Das Kopf-Feld `**Welle:** … oder "ohne Welle"` eines Slice sagt etwas anderes —
ob dieser Slice in ein Bündel gehört —, und aus ihm folgt für Lese-Schritt,
Sichtungs-Schritt, Trigger-Audit und die drei Paarungen **nichts**.

Konsequenz: In einem Repo mit Wellen prüft die nächste Welle-Closure alles, was
seit der letzten Welle in `done/` gelandet ist — auch Slices ohne
Wellen-Zugehörigkeit. Die Slice-Closure trägt die Prüfung nur in einem Repo,
das gar keine Wellen schneidet.

Damit sind R9-06, R9-07 und die Achsen-Hälfte von R9-13 und R9-17 keine
Abwägungen mehr, sondern Rücknahmen: `slice.template.md` :49/:152,
`slice-020` :33/:85 und `modul-06-loesung.md` :306–310 fragen die falsche Achse
ab. Der Rubrik-Satz, den R8-17/R8-18 „repariert" haben, war vorher richtig.

### E-2 — Template-Schichtung: vier Schubladen, ein Test, ein Sensor

Es gab keine Regel dafür, was in den Rumpf gehört und was in den Kommentar —
die gemeinsame Ursache von R9-02, R9-03, R9-04, R9-05, R9-11, R9-13 und R9-22.
Sie lautet ab jetzt:

| Schublade | Inhalt | Überlebt `README.md` Schritt 5? |
|---|---|---|
| **Regelwerk** | Der Normtext. **Einzige** Quelle. | — (vendored unter `.harness/baseline/<tag>/`) |
| **Rumpf** | Nur, was das *fertige Artefakt* trägt: Feldnamen, Feldreihenfolge, `<Platzhalter>` — plus **genau ein** Regelwerk-Zeiger pro Pflicht-Sektion | ja |
| **DoD (§2)** | Jede Pflicht, die der Ausfüllende **abhaken** muss. Das ist die Prozedur | ja |
| **Kommentar** | Begründung und Bedienhinweis | nein |

**Test für den Rumpf:** *Liest sich das im veröffentlichten Artefakt als Inhalt
— oder als Anleitung an jemanden?* Anleitung gehört nie in den Rumpf (R8-08),
und Regeltext im Rumpf wird von Schritt 3 zerschossen, weil dessen Platzhalter
ersetzt werden (R9-22).

**Harte Regel:** *Kein Kommentar ist die einzige Fundstelle einer Norm.*

**Nachtrag zur Feedback-Hälfte — der ursprüngliche Vorschlag war falsch.**
Geplant war ein *Sensor* („trägt der Kommentar einen Regelwerk-Zeiger, muss der
Rumpf auch einen tragen"). Der Versuch, ihn zu bauen, hat ihn widerlegt:
`tools/docs-check.js` :55 nimmt `lab/templates` per Default aus — die Prüfung
hätte in genau dem Verzeichnis, für das sie gebaut war, nie feuern können (im
Break-Test bestätigt). Und sie hätte die Skript-Fläche vergrößert, die dieses
Repo seit Welle 32 abbaut.

Dazu der inhaltliche Einwand: *„Ist dieser Satz eine Norm?"* ist ein **Urteil**,
kein Match — dieselbe Klasse wie *„ist das dieselbe Beobachtung?"* beim
Register. Die Feedback-Hälfte ist deshalb **inferential**: eine HIGH-Regel
*Norm nur im Template-Kommentar* im Reviewer-Skill. Die Grenze steht benannt —
die Regel hängt an einem Review, nicht an einem Lauf. Einen Sensor zu
behaupten, wo keiner steht, wäre die Klasse *halluziniertes Gate*, auf die
eigene Konvention angewandt.

Das Idiom ist nicht neu: `README.template.md` :41/:46, `roadmap.template.md`
:11 und `observations.template.md` :11 benutzen es bereits — E-2 macht es
verbindlich und schließt die Lücken.

---

## Behebung

**2026-07-28**, in der Reihenfolge unten. Gates danach: `make check` grün
(d-check 0 Befunde, `docs-check` 0 ERROR / 0 WARN, `alignment-check` 0 WARN),
`lab/example` `make verify` grün — der geschärfte Closure-Note-Gate zusätzlich
per Break-Test verifiziert.

**Dritte Entscheidung, bei der Ausführung getroffen (E-3, aus R9-01):** Die
Beleg-Formbindung bleibt, aber ohne Existenz-Pflicht — **Form**
(`slice-<NNN>`, kein Freitext) · **Anzahl** (= Zähler) · **Lage** (führt das
Repo die Datei, liegt sie in `done/`). Ein Repo darf Slices führen, die es
nicht als Plan-Datei ablegt; ein Sensor, der sie einforderte, liefe auf jedem
gewachsenen Repo rot. Dass damit ein erfundenes `slice-999` unentdeckt bleibt,
steht als Grenze benannt statt überspielt.

| Befund | Was geändert wurde |
|---|---|
| E-1 / R9-06 / R9-07 | Modul 6 stellt die **Achse** voran, bevor die Tabelle greift: *wellenlos* ist der Repo-Modus, `**Welle:**` die Bündel-Zugehörigkeit. Zurückgenommen: `slice.template.md` :49/:152, `slice-020` §2/§7, `modul-06-loesung.md` (c). Der Rubrik-Satz, den R8-17/R8-18 „repariert" hatten, steht wieder richtig; die Lösung nennt den wellenlosen Zweig als *Repo*-Fall. |
| E-2 / R9-02 · R9-03 · R9-04 · R9-05 · R9-11 · R9-13 · R9-22 | Neue Konvention §Template-Schichtung (Quelle + Spiegel) und alle vier Templates danach umgebaut: Normtext raus aus Rumpf **und** Kommentar, ein Regelwerk-Zeiger in den Rumpf jeder Pflicht-Sektion. `observations.template.md` bekommt den Zeiger überhaupt zum ersten Mal (es war das einzige Template ohne R8-01-Behandlung). `welle.template.md` §7 trägt Platzhalter statt Links — der alte Rumpf machte `make docs-check` beim Adopter vom ersten Tag der Welle an rot. |
| E-3 / R9-01 | Beleg-Regel auf Form · Anzahl · Lage umgestellt, Grenze benannt (Quelle, Spiegel, Template, CHANGELOG). Im Vorbild ist der Freitext aus drei Belegzellen raus; die Herkunft innerhalb des Slice steht in dessen §6/§7, wo sie hingehört. |
| R9-08 · R9-09 | Der Fluss-Graph hat einen zweiten Ausgang für `1×/2×` (Slice-Planung im Repo ohne Wellen) und Knoten `E` nennt Träger statt „eigenständig" — und den Zielort statt eines Pflichtfelds, das eine der drei Klassen nicht trägt. |
| R9-10 | `observations.template.md` REGELN nennt denselben Träger wie Quelle und Spiegel. |
| R9-12 | Die `3×`-Beispielzeile trägt drei Belege statt „`<slice-NNN>`, …". |
| R9-14 | Die Paarungs-Begründung in Schritt 3 nennt nicht mehr den `git mv` — die Closure-Notiz wird direkt nach `done/` geschrieben; der `git mv` betrifft die Welle-*Plan*-Datei. Quelle und Spiegel. |
| R9-15 | §8 steht in **jedem** Slice-Plan; was am Modus hängt, ist nur der Begründungsblock darin. Template, Template-Index und Spiegel gleichgezogen. |
| R9-16 | Alle drei Vorbild-Slices tragen jetzt den Block *Vorgelagert — offene Beobachtungen gesichtet*, mit echtem Befund gegen das Register. |
| R9-17 | Die Lösungstabelle *Wer einträgt, wer liest* nennt **zwei** Leser; die Rubrik-Zelle nennt den Träger statt „wer wellenlos arbeitet". |
| R9-18 | Der §7-Kommentar in `slice-013`/`slice-014` verweist nicht mehr auf ein DoD-Item, das dort fehlt. |
| R9-19 | „nicht durch eine Sektion" → „nicht durch die Semantik des Eintrags"; der Scope-Absatz sagt jetzt ausdrücklich, dass er den Satz eingrenzt statt ihm zu widersprechen. |
| R9-20 | Der Sektions-Scope steht jetzt auch in Modul 6 (a), wo beide `liegt in`-Formen gelehrt werden — samt Nennung des Trigger-Sprachgebrauchs als Nicht-Auslöser. Quelle und Spiegel. |
| R9-21 | Die Prüfvorschrift sagt, **ab Repo-Wurzel**, und grenzt das gegen die datei-relativen Nachbar-Pfade ab, die der Ruheort-Regel folgen. |
| R9-23 · R9-24 | `CHANGELOG.md`: Beleg-Regel wie beschlossen, Vollständigkeits-Behauptung präzisiert; der Auszug-Kommentar in Modul 6 zählt `BEO-007` mit. |
| R9-25 | Die aktive Welle im Vorbild trägt §7 wie das Template — Platzhalter, kein Kommentar-Only. |
| R9-26 | `## 7. Closure-Notiz` — die Template-Überschrift heißt jetzt wie alle sechs realen Instanzen. |
| R9-27 | Geplante Wellen bekommen **keine** Datei; zwei Positionen, nicht drei. `welle.template.md` und Planning-Index. |
| R9-28 · R9-29 | Die Rückführungs-Pointe steht wieder nur in ihrem eigenen Abschnitt; der Modultext beantwortet seine Übung nicht mehr vorweg. Quelle und Spiegel. |
| R9-30 | Modul 10 und 13 tragen dieselbe Formangabe wie Modul 9 — Quelle und Spiegel, alle sechs Stellen wortgleich. |
| R9-31 | „sieben Form-Zeilen" in `review-runde-8.md`. |
| vorbestehend 1 | `check_closure_notes.py` misst §7 statt §5 (`"closure" && !"trigger"`). Break-Test: leere Closure-Notiz läuft jetzt rot. |
| vorbestehend 2 | Aufgelöste Carveouts wandern nach `docs/plan/carveouts/done/`, nicht in den Planning-`done/`. |
| vorbestehend 3 | Der Planning-Index des Vorbilds führt keine Snapshot-Tabelle mehr, sondern verweist auf `make plan-status` — wie das Template es verlangt. |

**Zurückgenommen:** die geplante Sensor-Hälfte von E-2. Begründung oben unter
E-2; `tools/docs-check.js` bleibt unverändert.

**Empfohlen:** eine zehnte Runde.

---

## Ursprünglich geplante Reihenfolge

Reihenfolge, in der die Befunde abgearbeitet wurden:

1. **E-2 encodieren** — Guide + Spiegel + Sensor. Erst danach die sieben
   Schichtungs-Befunde, sonst repariert man sie ohne Maßstab.
2. **E-1 zurücknehmen** — die drei falsch-achsigen Stellen plus die
   Rubrik/Lösungs-Paare (R9-06, R9-07, R9-13, R9-17).
3. **R9-01** — entschieden als E-3 (siehe §Behebung): Die Beleg-Formbindung läuft auf
   4 von 7 Zeilen des eigenen Vorbilds rot. Die Wahl steht zwischen *Regel
   abschwächen* (Beleg = Kennung, Existenz nicht gefordert) und *Vorbild
   vervollständigen* (zehn fehlende Slice-Dateien anlegen). Die zweite ist die
   teurere und die ehrlichere — und die, die R8-14 für den Welle-Plan gewählt
   hat.
4. **Der Fluss-Graph** (R9-08, R9-09) — er ist bei jeder der letzten drei
   Runden übersehen worden und ist der einzige Ort, der die Mechanik als Bild
   zeigt.
5. Anschließend die übrigen. Danach eine zehnte Runde.
