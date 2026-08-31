# Changelog

Kanonisches Register der Überarbeitungs-Wellen dieses Kurses. Die
Stand-Zeile von [`lab/regelwerk/README.md`](lab/regelwerk/README.md)
referenziert diese Nummern; adoptierende Repos vergleichen ihren
Baseline-`Stand:`-Eintrag gegen dieses Register.

> **Zählung.** Fortlaufend über alle Wellen (Inhalt, Didaktik,
> Tooling). Vor Einführung dieses Registers liefen zwei parallele
> Zählungen in Commit-Messages (generisch „Welle 1–16" und
> „Didaktik-Review Welle N") — Commit-Labels können daher von der
> kanonischen Nummer abweichen; maßgeblich ist dieses Register.

## Welle 109 — 2026-08-31 · Die Wellen-Closure archiviert ihre Zeitdokumente

Die in Welle 107 entworfene und in Welle 108 geprobte Form geht in den Kanon.
Die Wellen-Closure bekommt einen **vierten Schritt**: Was die Welle einsammelt
— ihre Slice-Dateien, ihr eigener Plan, die Review-Reports dieser Slices —
wandert in ein unveränderliches `done/<welle-id>/archiv.zip`. Die
**Ergebnisnotiz bleibt vollständig und flach**; Slices und Welle-Plan bleiben
als **gekürzter Stub**; Review-Reports bekommen keinen, sie haben keine
Identität jenseits ihres Slice.

- [`modul-06` §Die Wellen-Closure-Prozedur](kurs/de/02-planung/modul-06-roadmap.md#die-wellen-closure-prozedur)
  trägt den Schritt: was archiviert wird, was liegen bleibt, in welcher Form —
  und die **Auswahl nach der Welle, nicht nach dem Verzeichnis**: die Slices
  dieser Welle *und* die wellenlosen seit der letzten Closure, nicht die einer
  offenen. Aus fünf Belegen werden sechs.
- [`modul-05`](kurs/de/02-planung/modul-05-planning-harness.md): `done/` ist
  nicht die letzte Station der Datei. Der Stub hält die Verzeichnis-Position
  als Zustand, und wer auf den Slice zeigt, zeigt weiter auf etwas.
- [`modul-10`](kurs/de/04-qualitaet/modul-10-review-harness.md): Aus
  *„Lauf-Beleg, kein Wissensspeicher"* folgt, wohin er am Ende geht — ganz ins
  Archiv, ohne Stub. Und: Ein Rang-Dokument, das einen einzelnen Report
  verlinkt, hat ein Problem, das älter ist als das Archiv.
- Neue Vorlagen `archiv-stub-slice.template.md` und
  `archiv-stub-welle.template.md`; die tragenden Bedingungen stehen als
  Fließtext, nicht im Bedienhinweis.

**Zwei Sätze tragen die Regel, und beide kommen aus Messungen der Welle 108:**
Die **Auswahl gehört in die Operation**, nicht in ihren Aufrufer — wer ihr die
Liste vorgibt, nimmt ihr die Entscheidung ab, an der sie scheitern könnte. Und
**urteilsfrei ist die Form des Stubs**: dass er den Archiv-Zeiger trägt *und
die Abschnitte des vollen Plans nicht mehr*. Die zweite Bedingung ist die
wichtigere — ein Stub, der nur den Zeiger trägt und den Text behält, wäre die
Archivierung, die es nicht gab.

**Ab Einführung, kein Nachrüsten.** Wellen, die vorher schlossen, bleiben, wie
sie sind; eine Rück-Archivierung wäre Bewegung ohne Anlass. Das Beispiel-Repo
ist damit unverändert konform.

**Vier Grenzen, im Kanon benannt statt überspielt:** Geprüft ist die Form,
nicht die Länge. Ob das Archiv vollständig ist, bezeugt nur der
Archivierungs-Commit — danach ist es für jedes Gate opak; deshalb gehört die
Operation in ein Werkzeug. Für ein Repo **ganz ohne** Wellen fehlt der
Auslöser. Und: **Vor der ersten Archivierung ist der Geltungsbereich der
vorhandenen Sensoren zu prüfen** — ein Sensor, der auf `done/*.md` keilt,
sieht die Stubs im Unterverzeichnis nicht mehr und bleibt grün, ohne noch
etwas zu prüfen. Dieselbe Bauform wie ein halluziniertes Gate, nur von der
anderen Seite: Die Zusage bleibt, ihr Prüfbereich schrumpft.

**Zwei Review-Runden, sieben Befunde — und zwei davon zeigen die Grenze der
eigenen Gegenprobe.** Die Aufzählung „fünf Schritte" stand nach `293a010`
noch an zwei Stellen: einmal als *„alle fünf"* ohne das Wort *Schritte*,
einmal über einen Zeilenumbruch getrennt (`Fünf\nSchritte`). Mein Grep hat
beide nicht gefunden, und meine Gegenprobe war derselbe Grep — sie war für
genau das blind, wofür er blind war. Dazu stand die **Rollen-Sequenz-Tabelle
in Modul 8** vollständig auf dem Fünf-Schritt-Stand (Zeilen 4/5 falsch
nummeriert, der neue Schritt fehlte). Der **Herkunfts-Anker** in
`traceability.md` versprach eine Auflösung *„in einem Hop"* über
`done/slice-<NNN>-*.md` §7 — nach dem Archivieren sind es zwei, und §7 steht
im Zip; die Stelle sagt das jetzt. Im **Spiegel** fehlten zwei operative
Sätze (Werkzeug statt Handarbeit; die Rang-Dokument-Regel aus Modul 10). Und
die **neue Vorlage** wiederholte die Falle aus Welle 105 — zwei tragende
Aussagen standen nur im Bedienhinweis, der beim Kopieren wegfällt. Sie ist
jetzt in zwei Vorlagen geteilt (eine H1 je Datei, wie die übrigen 21), und
beide Aussagen stehen als Fließtext.

Nachgemessen, bevor die Regel geschrieben wurde: Weder `planning` noch `waves`
bricht an einem Unterverzeichnis in `done/` — beide lesen das
Roadmap-Verzeichnis, nicht das Archiv; die Gegenprobe (`planning-drift` bei
belegtem `in-progress/`) beißt weiter.

Spiegel und Vorlagen ziehen mit; `Stand:` auf Kurs-Welle 109.

Gates: `make check` — d-check 0 Befunde, `docs-check` 0 ERROR / 0 WARN,
`alignment-check` 0 WARN; `make bundle-check` grün.

## Welle 108 — 2026-08-31 · Die Archiv-Form, geprobt — und zweimal korrigiert

Welle 107 hielt den Entwurf fest und nannte sechs Proben. Sie sind gefahren
(`lab/team-sim` s19, zehn Verdikte, Gesamtlauf 46/46 · 0 KAPUTT) — und **zwei
davon haben den Entwurf geändert, bevor eine Zeile Kanon geschrieben wurde.**
Genau dafür ist die Reihenfolge *erst proben, dann verkörpern* da.

**Der Sensor erzwingt ein Wellen-Verzeichnis.** Die Deckungs-Prüfung sollte mit
`structure` und `require-pattern` baubar sein. Gemessen ist sie das auch — aber
`require-pattern` gilt **unbedingt** über seinen Glob. Über dem flachen
`done/slice-*.md` meldete sie den vergessenen Slice richtig **und den zur noch
offenen Welle gehörenden falsch mit**: ein Sensor, der bei jeder korrekt
geschlossenen Arbeit rot wird. Über `done/welle-<NN>/slice-*.md` meldet dieselbe
Regel nur den vergessenen (s19f), der offene bleibt still (s19g). **Der
Geltungsbereich steht seither im Pfad, weil die Bedingung ihn nicht ausdrücken
kann** — und die Zielform ist ein Wellen-*Verzeichnis*, nicht nur ein
Wellen-*Zip*.

**Der Verweis-Nachzug braucht zwei Formen.** Der erste Lauf war rot: Der Nachzug
traf nur Verweise mit `done/`-Präfix, wie das Register sie schreibt. Die
**Ergebnisnotiz** schreibt geschwister-relativ — sie liegt selbst in `done/`
und *bleibt* dort, während ihre Slices umziehen. Das ist der garantierte Fall
dieser Regel, nicht ihr Randfall, und dieselbe Blindstelle, die `slice-mv.sh`
im Nachbar-Repo für sich benennt. Mit beiden Formen ist s19d grün, und s19e
belegt per Gegenprobe, dass die Zusage ohne Nachzug wirklich bricht.

Die übrigen vier Proben tragen: 6 Volltexte im Zip gegen 4 Stubs — Reviews
bekommen keinen, sie haben keine eigene Identität (s19a); die Trefferzahl fällt
am selben Bestand von 17 auf 5 (s19b); der wellenlose Slice behält `ohne Welle`
und nennt die einsammelnde Welle im zweiten Feld (s19c); und im `--depth 1`-Klon
liefert das Archiv den Volltext, während `git show` scheitert (s19h).

`lab/team-sim` bekommt damit die ersten Szenarien, die **keine**
Nebenläufigkeit prüfen — Gegenstand ist eine Operation und ihr Sensor. Die
Topologie bleibt trotzdem; sie kostet nichts und hält die Bauform gleich. Das
steht im README so.

**Und dann hat ein Review neun Mutationen gefahren — mit zwei Ergebnissen, die
im Entwurf standen und nicht stimmten.** Erstens: `s19b` prüfte nur, dass die
Trefferzahl *fällt* — das erreicht auch bloßes Löschen; das Verdikt hängt jetzt
zusätzlich an den vier Stubs. Zweitens, und schwerer: **Der Deckungs-Sensor
prüfte die Marke, nicht die Kürzung.** Ein Stub mit `Archiviert mit:`, der den
vollen Text behalten hatte, kam durch — die zentrale Zusage des Entwurfs.
**Behoben:** eine zweite Bedingung `forbid-pattern: '(?m)^## '`. Ein Stub trägt
eine Überschrift und Felder, ein ungekürzter Plan seine Abschnitte; unter
derselben Mutation wird der Lauf jetzt rot, und s19j prüft den Fall
vorab-registriert. Das `(?m)` ist notwendig — ohne Multiline-Flag ankert RE2 am
Textanfang und die Bedingung schweigt (gemessen). Geprüft ist damit die
**Form**, nicht die Länge: Ein Stub, der die Überschriften entfernt und den
Fließtext stehen lässt, käme weiter durch. Das ist die schwächere Restlücke,
und sie steht im Entwurf.

**Und der s19g-Befund hat die Probe an der richtigen Stelle repariert.** Er
lautete: *s19g wird unter keiner Mutation des Werkzeugs rot.* Der Grund war
nicht das Verdikt, sondern die **Grenze der Probe** — das Szenario übergab der
Operation eine fertige Dateiliste, also konnte sie gar nicht falsch auswählen,
und *sie greift den offenen Slice nicht* war per Konstruktion wahr. Die
**Auswahl** steht jetzt in der Operation, wo der Entwurf sie ohnehin verlangt:
Slices der geschlossenen Welle **und** wellenlose, aber nicht die einer
offenen. Damit prüft s19g die Operation statt der Konfiguration —
gegengeprüft mit zwei Auswahl-Mutationen: *sammelt alles ein* macht s19g rot,
*vergisst den wellenlosen Slice* macht s19c rot.

Dazu zwei kleinere Nachzüge: Der **Welle-Stub** trägt im Entwurf eine eigene
Form (Zeiger auf die Ergebnisnotiz, Zahl der Vorgänge) — die Probe schrieb
beide Stub-Formen gleich; jetzt geprüft als s19i. Die **Gegenprobe s19e** kann
zum No-op werden, wenn der Nachzug ohnehin fehlt — sie prüft jetzt vorab, dass
ihr injizierter Defekt gegriffen hat. Und dass Review-Reports **keinen** Stub
bekommen, prüft nichts — dritte benannte Sensor-Lücke.

**Eine Zahl ist präzisiert, nicht korrigiert.** Der Review konnte die
tar.gz-Messung mit **synthetischen** Korpora nicht reproduzieren. Am realen
Bestand nachgemessen hält die Richtung dreimal — 9,56 MiB bei
Verzeichnis-Reihenfolge, 7,26 mit `--sort=name`, 6,54 zusätzlich mit
`git repack -adq`, gegen 2,94 für Zip. Die Aussage lautet damit *tar.gz kostet
ein Vielfaches*, nicht *tar.gz kostet 9,56 MiB*; die Methode steht jetzt dabei.

Kein Gate daraus: `lab/team-sim` läuft auf Anlass. Keine Änderung an `kurs/de`,
`lab/regelwerk`, Templates oder Beispiel; das Bundle ist unberührt. Offen
bleiben das Repo ganz ohne Wellen und die Vollständigkeit des Archivs, die nur
der Archivierungs-Commit bezeugen kann.

Gates: `make check` — d-check 0 Befunde, `docs-check` 0 ERROR / 0 WARN,
`alignment-check` 0 WARN.

## Welle 107 — 2026-08-31 · Zeitdokumente bekommen einen Ausgang aus dem Arbeitsbaum

Nicht der Platz ist das Problem, sondern das **Rauschen im Agentenlauf**: Ein
`grep` nach einem Begriff trifft Dokumente, die ihn in einem Zustand tragen,
den es nicht mehr gibt — ein Review-Satz von vor drei Monaten liest sich in
einer Trefferzeile wie die geltende Regel. Der Korpus kennt die Diagnose eine
Ebene tiefer und löst sie dort über die Verzeichnis-Position: Aufgelöste
`MR`-Einträge wandern nach `conventions/done/`, „ein aufgelöster Eintrag liest
sich wie ein geltender … ein Korrektheits-Risiko". Für Reviews und
geschlossene Slices fehlt diese Bewegung.

Gemessen an einem Adopter-Repo: 245 Review-Reports und 113 geschlossene
Slices; zehn realistische Suchbegriffe über die Slices ergeben **3320
Trefferzeilen**.

[`docs/zeitdokument-archiv.md`](docs/zeitdokument-archiv.md) hält den
Entwurfsstand fest, bewusst **noch nicht normativ**:

- **Werkzeugseitige Abhilfen scheiden aus**, weil sie an der lokalen
  Installation hängen — `.ignore` wirkt nur unter ripgrep bzw. einem `ugrep`
  mit `--ignore-files`, `GREP_OPTIONS` ist seit GNU grep 2.21 wirkungslos, eine
  Wrapper-Funktion wird im nicht-interaktiven Lauf nicht geladen. Alles
  gemessen. Bleibt der werkzeugunabhängige Hebel: Was nicht im Arbeitsbaum
  steht, kann nicht getroffen werden.
- **Mit der Closure einer Welle** wandern ihre Zeitdokumente in ein
  unveränderliches `welle-<NN>-archiv.zip`. Slices und Welle-Pläne bleiben als
  **gekürzter Stub** liegen, Review-Reports gehen ganz, die **Ergebnisnotiz
  bleibt vollständig** — sie ist die Bedeutung, das Archiv nur die Koordinate.
- **Der Stub statt eines zentralen Registers:** Beim Rauschen sind beide
  gleichwertig (3320 → 38 Trefferzeilen, fast alle in der Titelzeile), aber der
  Stub hält die **Verzeichnis-Position als Zustand** und lässt eingehende
  Verweise gültig — keine fünfte Lifecycle-Position, keine Verweis-Einlösung.
- **Zip, nicht tar.gz**, gemessen über drei Runden: 2,94 gegen 9,56 MiB. gzip
  komprimiert den ganzen Strom, Zip je Eintrag, und git deltat unveränderte
  Einträge. `tar` scheidet aus, weil der Klartext roh im Archiv liegt.
- **Zwei Felder statt einem:** `Welle:` trägt die Mitgliedschaft,
  `Archiviert mit:` die Einsammlung. Sie fallen auseinander, sobald ein Slice
  keiner Welle angehört — **40 von 95** im gemessenen Bestand —, und ein
  Zustandsfeld darf keine Mitgliedschaft behaupten, die es nie gab.
- **Der Sensor in zwei Hälften** (Mitgliedschaft und Abzählung) plus die
  Grenze, die keine Form-Prüfung schließt: ein geschlossener Slice ohne
  Zugehörigkeit, den niemand eingesammelt hat, fehlt in beiden Zählungen. Das
  ist das Argument dafür, dass die Operation ins Werkzeug gehört.

Keine Änderung an `kurs/de`, `lab/regelwerk`, Templates oder Beispiel; das
Bundle ist unberührt. Offen bleibt der Fall des Repos **ganz ohne** Wellen —
dort fehlt der Sammelpunkt, und eine Schwelle bleibt der Fallback.

Gates: `make check` — d-check 0 Befunde, `docs-check` 0 ERROR / 0 WARN,
`alignment-check` 0 WARN.

## Welle 106 — 2026-08-31 · Die Schwelle bekommt ihre drei Ausgänge

Modul 5 verlangt für jedes notierte Risiko **genau einen von drei Ausgängen** —
eine geschlossene Menge, kein Freitext, mit sauber benannter urteilsfreier
Hälfte. Eine Ebene höher fehlte dieselbe Form: Was ein Eintrag *tut*, wenn er
3× erreicht, stand als Fließtext in der Stand-Spalte. Damit war der teuerste
Moment des Steering Loops der einzige ohne Formvorgabe.

- [`modul-06` §Das Beobachtungs-Register](kurs/de/02-planung/modul-06-roadmap.md#das-beobachtungs-register):
  Ab 3× trägt der Stand **verkörpert** (Zielort *und* Herkunfts-Anker),
  **geplant** (Kennung des Slice oder der Welle, die die Regel schreibt) oder
  **gestrichen** (mit Begründung). Unterhalb der Schwelle ist `offen` der
  Normalzustand; *gestrichen* hängt als einziges nicht an der Schwelle, denn
  eine weggefallene Ursache wartet nicht auf den dritten Beleg.
- **Warum ein dritter Ausgang.** Die Schwelle fällt nicht immer dort, wo die
  Regel geschrieben werden kann. Ohne *geplant* bliebe nur, den Eintrag `offen`
  stehen zu lassen — dann ist die Schwelle folgenlos — oder eine Verkörperung
  zu behaupten, die es nicht gibt. *Geplant* ist deshalb ein Ausgang **mit
  Kennung**, kein Vorsatz.

**Und der Beleg zählt jetzt Vorgänge, nicht Funde.** Zwei Fälle, beide an einem
fremden Register gemessen, beide dort bewusst und begründet abweichend:

- **Ein Vorgang zählt einmal.** Zwei Funde im selben Slice sind *eine*
  Gelegenheit — derselbe Kopf, derselbe Kontext, dieselbe Sitzung belegen
  nichts über die Hartnäckigkeit eines Phänomens. Gegenprobe: ein Register
  führte einen Slice zweimal und stand damit auf 7 statt 6.
- **Was keinen Vorgang hat, zählt nicht — wird aber benannt.** Neben dem Slice
  taugen auch Welle und Review-Report als Beleg; ein Vorkommen beim Lesen von
  Code oder im Gespräch bewegt den Zähler nicht. Gegenprobe: ein Eintrag stand
  auf Zähler 3 mit *einem* Slice-Beleg, mit der Notiz „die Klasse ist dichter
  als der Zähler". Der Preis ist ein Zähler, der langsamer steigt als das
  Phänomen auftritt; der Gegenwert ist einer, der nie mehr behauptet, als
  seine Belegliste trägt.

Spiegel, Vorlage und die Lösung zu Modul 6 ziehen mit — dort war der
Zwischenzustand als *„gezählt, aber nicht verkörpert"* beschrieben, also genau
die Lücke, die der dritte Ausgang schließt. Das Beispiel-Register hat die Regel beim
Nachziehen selbst geprüft: `BEO-006` stand mit Zähler 1× auf *geschlossen in
`slice-022`* — ein vierter Ausgang im Freitext, und zugleich der Fall, der
zeigt, dass *gestrichen* nicht an der Schwelle hängen darf. Die Zeile ist
jetzt dort, wo sie hingehört, und die Regel sagt es ausdrücklich.

Damit sind beide Quell-Wellen erledigt, auf die der d-check-CR wartet.

Gates: `make check` — d-check 0 Befunde, `docs-check` 0 ERROR / 0 WARN,
`alignment-check` 0 WARN. `make bundle-check` grün.

## Welle 105 — 2026-08-31 · Das Bereichssegment bekommt einen Ort

Der Kanon vergibt Kennungen mit Bereichssegment — `ADR-IDX-0004`,
`slice-IDX-007` — und sagt, die Bereiche seien „nicht neu zu erfinden, es sind
die Sub-Areas, die `harness/conventions.md` ohnehin einzeln deklariert". Den
**Ort** benennt er damit. Die **Gestalt** nicht: Die Modus-Deklaration führt
Pfade und Prosa-Namen, und das Kürzel `IDX` steht in keiner Tabelle. Wer eine
Kennung vergibt, erfindet es also doch — jeder für sich.

Gemessen an zwei Adopter-Repos führt keine Modus-Deklaration ein Kürzel —
`d-check` Pfade (`*`, `tools/harness/`), das Beispiel-Repo Prosa-Namen. **Beide
sind damit nicht mangelhaft, sondern korrekt ausgenommen:** An beiden schreibt
ein Mensch, ihre Kennungen tragen kein Bereichssegment, und `d-check` sagt das
in seiner eigenen `conventions.md` ausdrücklich. Die Lücke wurde denn auch
nicht an ihnen sichtbar, sondern an einem Konsumenten-CR für den
Mehr-Schreiber-Fall: Er verlangte, eine Herkunfts-Sub-Area gegen den
deklarierten Bestand zu prüfen — und die Prüfung hätte keine auflösbare
Autorität gehabt.

**Nicht behoben und hier benannt:** Die Sub-Area-Spalte des
Beobachtungs-Registers führt weiterhin Prosa-Namen, also denselben Namen, der
laut dieser Welle umformuliert werden darf. Das ist dieselbe Fragilität eine
Ebene weiter; sie bleibt offen, bis ein Anlass sie misst.

- [`source-precedence.md` §Vergabe](kurs/de/grundlagen/source-precedence.md#vergabe-woher-die-nächste-nummer-kommt):
  Das Segment wird **nachgeschlagen, nicht formuliert**. Fehlt das Kürzel in
  der Deklaration, zählen zwei Schreiber in zwei Räumen, ohne dass etwas
  kollidiert — dieselbe stille Teilung wie bei einer Beobachtung unter zwei
  Namen, nur eine Ebene tiefer: dort teilt sich der Zähler, hier der Zählraum.
- [`harness-dateien.md` §Konventionsspeicher](kurs/de/grundlagen/harness-dateien.md#harnessconventionsmd-als-konventionsspeicher):
  Die Modus-Deklaration führt eine **Kürzel-Spalte** — kurz, GROSS, ohne
  Leerzeichen. Der Name taugt nicht als Segment, weil er umformuliert werden
  darf und das Segment nicht; ein vergebenes Kürzel ist **unveränderlich**.
- **Bedingt, nicht absolut.** Wo Kennungen kein Segment tragen, entfällt die
  Spalte. Die Frage nach dem Zählraum entsteht erst mit dem zweiten Menschen
  am Repo — der Kanon sagt das selbst, und das Beispiel-Repo ist genau dieser
  Fall. Eine Kürzel-Spalte ohne Kennungen, die sie benutzen, deklariert
  nichts.

Spiegel und Vorlage ziehen mit (`conventions.template.md` bekommt die Spalte
samt Streich-Hinweis für Ein-Schreiber-Repos); das Beispiel-Repo bekommt
**keine** Spalte, sondern den Satz, warum es keine hat.

Damit ist die erste der zwei Quell-Wellen erledigt, auf die der d-check-CR
wartet. Die zweite — die geschlossene Menge der Ausgänge bei 3× samt der
beiden Beleg-Fälle — steht aus.

Gates: `make check` — d-check 0 Befunde, `docs-check` 0 ERROR / 0 WARN,
`alignment-check` 0 WARN.

## Welle 104 — 2026-08-31 · Der Steering-Loop-Zähler wird für Teams neu geschnitten

Ein Team mit einem Feature- oder Bugfix-Branch je Aufgabe schreibt bei jeder
Slice-Closure in dieselbe `observations.md`. Der Zähler ist fachlich
personenunabhängig, seine Ablage aber ein gemeinsamer Ganz-Wert: offene PRs
sind beim Sichten unsichtbar, zwei Hälften derselben Beobachtung können still
nebeneinander mergen, und eine nächste `BEO-<NNN>` ist über offene Branches
nicht lokal ableitbar.

[`docs/steering-loop-team.md`](docs/steering-loop-team.md) hält den aktuellen
Entwurfsstand fest, bewusst **noch nicht normativ**:

- Beobachtungen liegen unter `observations/BEO-<SUB-AREA>/<slug>/` statt als
  Zeilen einer gemeinsamen Tabelle.
- `observation.md` trägt die stabile Identität, `state.md` den veränderlichen
  Stand und `evidence/<slice-id>.md` je ein Auftreten. Der Zähler wird aus den
  gültigen Evidence-Dateien abgeleitet und nicht gespeichert.
- Für den Slug hielt der Entwurf das vorhandene Modul `vcs` für ausreichend
  (`--range`/`--staged` meldet Rename und Delete einer immutablen Datei). Die
  Probe widerlegt das für den **reinen** Rename; siehe unten. Davon abgegrenzt
  bleibt das hermetische Modul `immutable`: Es schützt den Core per Hash,
  bindet aber den Pfad nicht.
- Der Entwurf behandelt neun Problemfelder: unter anderem semantische
  Doppelbenennung, den parallelen 3×-Übergang, Status und Invalidierung,
  Alias-Auflösung, erzeugte Sicht und die Migration bestehender
  `BEO-<NNN>`.
- Eine Lösungsmatrix stellt jedem dieser neun Punkte einen konkreten
  Schreibweg, die maschinelle Absicherung und die verbleibende menschliche
  Restgrenze gegenüber. Sie entscheidet unter anderem für Merge-Queue plus
  3×-Gate, append-only Invalidierungen, azyklische Aliase, beidseitige
  Evidence-Paarung und einen deklarierten Legacy-Cutover.
- Die deterministische Aggregation — Evidence zählen, Schwelle und
  Folgeaktion paaren, Pfad und Inhalt decken — kann der heutige d-check-
  Modulsatz nicht als Ganzes ausdrücken. Beides ist deshalb passiert: ein
  Werkzeug-CR und das Replay.

**Der CR und die Rückfragen.** Ein Change Request an d-check beantragt die
relationale und aggregierende Prüfung; d-check hat mit vier Fragen und einer
Abhängigkeit geantwortet, wir mit einem Antwortschreiben. Beide Dokumente sind
zugestellt und liegen beim Empfänger — dieses Repo hält davon keine Kopie
(Change Request ist ein externer Prozess, kein Harness-Konstrukt).
Sechs Punkte ändern den Antrag — §1 vertagt, §2 als Verschärfung gegen den
eigenen Kanon markiert, §5 und §6 zurückgezogen, der Abschnitt *Bereits
gelöst: Immutabilität* zurückgezogen, zwei Mutationsproben ergänzt. Die drei
tragenden: Die Diagnosesicht (§6) ist als
`--doctor`-Erweiterung zurückgezogen — sie ersetzt eine verlorene Lesefläche
und gehört in die Berichts-Klasse. Die Drei ist **Konvention**, nicht
Konfiguration; die freie Zustands-Liste ist gestrichen, weil sie verdeckte,
dass unser Zustands-Vokabular noch kein Kanon ist. Die Sub-Area-Autorität ist
als Kreuz-Dokument-Bindung angenommen — und älter als der Antrag: Modul 6
trägt die Regel seit ihrer Niederschrift ohne Mechanik.

**Das Replay: sieben Fälle, gemessen.** `lab/team-sim` bekommt s12–s18 für die
Verzeichnisform (36/36 · 0 KAPUTT, erst auf Image-Pin v0.67.0, nach dem Bump auf v0.71.1 erneut). Der Seed bleibt
unverändert — die Szenarien legen die Entwurfsform selbst an, weil sie kein
Kanon ist. Ergebnis: **Drei** Aussagen trägt git ohne Werkzeug und ohne
CI-Zusage über den Merge-Stand (getrennte Belege addieren sich, s12; derselbe
Namespace/Slug streitet laut, s13; ein geänderter oder gelöschter Beleg meldet
`core-drift-vcs`, s16a/b). **Eine** ist bewusst still (zwei Slugs für dasselbe
Phänomen, s17). **Zwei** sind der Gegenstand des Gates und haben heute keinen
Leser (die Schwelle im Merge-Stand, s14b; Alias-Auflösung, Invalidierung und
Zyklus, s18).

**Und einer galt als gelöst und ist es nicht (s15).** Dieselbe Umbenennung
einer immutablen Datei, über beide dokumentierten Eingabe-Modi derselben
Anforderung: Über `--staged` meldet `vcs` `core-drift-vcs` (s15a), über
`--range` bleibt sie still (s15b) — und der stille ist der CI-Pfad. Erst wenn
die Datei dabei umformuliert wird, erscheint auch dort die Delete-Hälfte
(s15c). `DC-FA-VCS-001` nennt die umbenannte immutable Datei ausdrücklich,
ohne einen Modus einzuschränken. Der Befund geht als eigener Bericht an
d-check;
der Abschnitt *Bereits gelöst: Immutabilität* des CR ist zurückgezogen. Die
schärfste Folge misst s16c: Weil der Dateiname eines Belegs die Slice-Kennung
ist, lässt ein reiner Rename den Zähler richtig und macht den Beleg falsch.

**Der Ausgang, am selben Tag.** d-check hat geantwortet: **angenommen und
aufgeschoben**, auf unseren eigenen Vorschlag hin — §1–§5 entstehen nach
unseren zwei Quell-Wellen. Die Sub-Area-Autorität und die CI-Voraussetzung
gelten als gesetzt, §6 wird als eigener Ausgabemodus entgegengenommen. Die von
uns als Zwischenschritt vorgeschlagene Anzahl-Prüfung am flachen Register
lehnt d-check ab, mit unserem eigenen Argument: Ein Gate gegen eine Regel, deren
Quelle sich unvollständig nennt, erzwänge am ersten Tag Informationsverlust
oder einen Carveout. Der `vcs`-Befund ist **bestätigt und behoben** in
`v0.71.1` — Range-Diff ohne Rename-Erkennung, alle vier Fälle nachgefahren,
kein Lastenheft-Bump: die Anforderung war nicht falsch, sie war nicht
eingelöst. Der Pin dieses Repos steht seither auf `v0.71.1` (eigener
`chore(d-check)`); mit ihm sind s15b und s16c von *still* auf
`core-drift-vcs` gedreht — die Probe misst jetzt den Fix.

Keine Änderung an `kurs/de`, `lab/regelwerk`, Templates oder Beispiel; die
`Stand:`-Zeile des Regelwerk-Spiegels bleibt unverändert. Die Welle
dokumentiert einen Entwurf samt Probe, keine neue Baseline-Regel.

Gates: `make check` — d-check 0 Befunde, `docs-check` 0 ERROR / 0 WARN,
`alignment-check` 0 WARN.

## Welle 103 — 2026-08-30 · Zwei Rot-Quellen, ein Prinzip

Zweiter Befund desselben Konsumenten: Der Beispielpfad der MR-Vorlage
(`../../.harness/baseline/<tag>/…`) löst nur aus `conventions/` auf; nach dem
`git mv` nach `done/` zeigt er eine Ebene zu hoch. Ihr Gate meldete es sofort
(2 × `target-missing`), die Pfade wurden nach dem Umzug berichtigt. Die
Ruheort-Regel des Kanons gilt laut eigenem Wortlaut *„für jede Datei, die per
`git mv` wandert"* — die Vorlage folgte ihr nicht.

**Der Einwand gegen die naive Anwendung ist richtig.** Ein Slice-Plan wird kurz
am Schreibort und lange am Ruheort gelesen; ein Adaptions-Eintrag umgekehrt —
er lebt seine ganze aktive Zeit in `conventions/`. „Vom Ruheort schreiben"
hieße dort: die ganze Zeit rot.

**Und die gemeldete Tiefe ist die kleinere Hälfte.** Derselbe Link trägt die
Baseline-**Version** im Pfad, und die bewegt sich bei jedem Bump. Am Bestand
des Meldenden gemessen: **45 Vorkommen in 29 aktiven** Einträgen, alle auf
`v5.12.0` — sie entwerten sich mit seinem nächsten Pin-Bump, ohne dass jemand
etwas verschiebt. Für die 3 Vorkommen in `done/` hat er die richtige Antwort
schon (scoped `ignore-refs`, damit eingefrorene Belege nicht verfälscht werden).

### Entschieden

- **Nicht die Form wechseln, das Rotten sichtbar machen.** Drei Auswege wurden
  erwogen und verworfen: den Link durch ein Abschnitts-Zitat ersetzen (löst
  beide Rot-Quellen, wirft aber die Existenz- und Anker-Prüfung weg), ihn in
  die Index-Zeile verschieben (halbe Prüfung), oder nur Pflichten schreiben
  (Tag-Rot bleibt still). Alle drei kaufen Wartungsruhe mit Blindheit — der
  Tausch, den dieser Korpus sonst ablehnt.
- **Die Ruheort-Regel bekommt ihre Gegenrichtung** (`grundlagen-traceability.md`):
  Wo eine Datei lange aktiv und kurz im Ruheort lebt, wird **nicht** vom
  Ruheort geschrieben — der `git mv` zieht die Pfad-Berichtigung nach sich, als
  eigener Commit (Modul 9 trennt Umzug und Inhalt ohnehin). Der Wächter ist die
  Existenzprüfung des Links, die genau diesen Fall gemeldet hat.
- **Die Version wird eine geprüfte Größe.** Der adoptierte Stand steht
  **einmal** im Adaptions-Block — die Pflichtgliederung verlangt ihn dort
  ohnehin —, und ein Versions-Sensor prüft jeden Pin dagegen: Ein vergessener
  Nachzug ist ein Befund, kein toter Link. `lab/templates/.d-check.yml` trägt
  das Muster als auskommentierten Block, mit `exempt-paths` für `done/`.
- **Die MR-Vorlage nennt beide Pflichten an der Feld-Zeile**, statt sie dem
  Adopter zu überlassen.
- **Der `Stand` im Adaptions-Block ist eine Version, kein Datum.** Das Review
  des eigenen Beispiels fand den Defekt an der Fixture: Die Vorlage schlug
  bisher *„Datum oder Version, z. B. Template-Set 2026-06"* vor — steht dort
  ein Datum, findet der Versions-Sensor keine Version und bricht **fail-closed
  den ganzen Lauf ab** (`versions.current-from: keine Version im adressierten
  Span`), statt einen Befund zu melden. Ein ausgeliefertes Beispiel hätte den
  Gate des Adopters lahmgelegt, sobald er die Vorlage so ausfüllt, wie sie es
  vorschlug. Der Stand trägt jetzt Version/Tag, das Adoptions-Datum steht in
  der Zeile darunter.

Der Weg dorthin kam aus dem Handbuch des Konsumenten selbst: Es führt
`versions` mit `pin-pattern`/`current-from` und dokumentiert die Anker-Wanderung
mit derselben Begründung — *„ein vergessener Versions-Bump fällt so auf, statt
still auf eine alte Version zu zeigen"*.

Einordnung: **MINOR** — die Ruheort-Regel bekommt eine Hälfte dazu.

Am Fixture belegt, nicht behauptet: Ein Eintrag auf altem Stand meldet
`version-stale` mit Zeile und Ist-Version; nachgezogen meldet derselbe Lauf 0.

Gates: `make check` 0 ERROR / 0 WARN, `make bundle-check` 0 Befunde.

## Welle 102 — 2026-08-30 · Ein Beispiel, das nie traf

Zwei Nachträge zum Release `v5.13.0`, beide von außen gemeldet.

### Entschieden

- **Das `vcs`-Beispiel der Vorlage schützte nichts.** `lab/templates/.d-check.yml`
  führt einen auskommentierten Block *Append-only der Adaptions-Einträge* mit
  `immutable-when: '^\*\*Status:\*\* Accepted'`. Der Konsument `d-check` meldete,
  das kollidiere mit der in Welle 100 aus der MR-Vorlage entfernten
  `Status`-Zeile. Nachgemessen ist es schlimmer und älter: Die Vorlage trug die
  Zeile als **Listenpunkt** (`- **Status:** Accepted`), die Regex ankert am
  Zeilenanfang ohne Strich — **0 Treffer, auch vor Welle 100**. Wer den Block
  aktivierte, bekam ein Modul, dessen Datei-Menge leer ist: ein Gate, das nie
  etwas zu prüfen fand und trotzdem grün meldete.
- **Die Reparatur folgt der Regel, nicht dem alten Feld.** Der Konventions-
  speicher sagt *„Einträge werden nie überschrieben"* — Unveränderlichkeit gilt
  **ab dem ersten Commit, nicht ab einem Status**. Deshalb keilt
  `immutable-when` jetzt auf die Datums-Zeile (`^- \*\*Datum:\*\*`), die jeder
  Eintrag trägt, und `status-line`/`head-allow` entfallen: Ein MR-Eintrag hat
  keinen erlaubten Übergang *in* der Datei, sein Zustand ist die
  Verzeichnis-Position. Gegenprobe: 1/1 in der Vorlage, **33/33** in den
  MR-Dateien des meldenden Konsumenten.
- **Das ADR-Pendant ist gegengeprüft und intakt.** Dieselbe Bauform steht in
  `.d-check.yml` dieses Repos für `lab/example`-ADRs; dort schreiben die Dateien
  `**Status:** Accepted` ohne Strich, die Regex trifft 8 von 12. Der Defekt war
  auf das Vorlagen-Beispiel beschränkt.
- **Das Release trägt künftig eine Prüfsumme.** Kein Release seit `v3.7.0` hatte
  eine; `templates-release` hängt jetzt `SHA256SUMS` neben das Bundle. Der Nutzen
  ist nicht *„dem Release vertrauen"* — wer das Asset ersetzen kann, ersetzt auch
  die Summe —, sondern die **Archiv-Form** aus Modul 14: Wer die Baseline
  vendort, hält fest, *was* er vendort hat, und kann es später gegenprüfen. Der
  Tag allein trägt das nicht; er ist verschiebbar.

Einordnung: **PATCH** (`v5.13.1`) — ein kaputtes Beispiel wird richtig, eine
Release-Mechanik kommt dazu; kein Regeltext ändert sich.

Gates: `make check` 0 ERROR / 0 WARN, `make bundle-check` 0 Befunde.

## Welle 101 — 2026-08-30 · Der Prüflauf verliert den Mount

Nachlese zu Welle 100, und diesmal wechselt die **Baseline**. Die Besitzfrage
dort hatte drei Antworten; die dritte — Quellen per `COPY` ins Image, Ergebnisse
über `stdout` — ist keine Variante unter anderen, sondern die einzige, die auch
die zwei übrigen Schäden beseitigt: dass ein Gate den Arbeitsbaum *ändern* kann,
und dass Docker Mountpunkte host-seitig als root anlegt. Belegt am eigenen
Bestand: Der `--tmpfs /src/.git`-Kniff des Kotlin-Skeletts hinterließ die
root-eigene `.git`-Hülle auch dann noch, als der Container unter der Host-UID
lief. Vorbild ist `MR-001` von `claude-ai-harness` — die Adaption eines
Konsumenten wird damit zur Regel für alle.

### Entschieden

- **Modul 14 §Der Prüflauf ist hermetisch — kein Mount** ist die neue gelehrte
  Form: `COPY` statt Bind-Mount, Rückweg über `stdout`, Gate-Stage und
  Beleg-Stage getrennt, `export` erbt von `repo` und nicht vom Gate. Vier
  Eigenschaften, vier Wirkungen — und der Preis steht dabei: Rebuild je
  Änderung, und der Rückweg löst **Ausgaben**, nicht Eingaben.
- **Die Besitz-Tabelle aus Welle 100 wird nachgeordnet.** Sie zählt jetzt die
  zwei Mount-Preise für den auf, der trotzdem mountet — die Antwort steht davor.
- **Die Ausnahme ist benannt und bedingt** (Modul 2 §Anmerkung zum
  Gate-Fragment): Ein tool-generiertes Fragment mountet read-only; das bleibt
  zulässig, **solange das Werkzeug nur liest** — der Besitz-Schaden entsteht am
  Schreiben. Wer auch das hermetisch will, bindet das Fragment nicht ein,
  schreibt die Recipe aus und deklariert die Abweichung als `MR-<NNN>`. Genau
  darunter fällt `MR-001` des Konsumenten.
- **Alle sechs Sprach-Skelette sind umgebaut** — kein `-v` mehr in den Gates.
  Zwei Bauformen, je nach Werkzeug: `python`, `go` und `cpp` tragen ihre
  Werkzeuge im Image und rufen sie per `docker run`; `java`, `kotlin` und
  `csharp` ziehen ihre Abhängigkeiten beim Build, dort **ist** die Gate-Stage
  das Gate. Damit die zweite Form denselben Vertrag hat wie die erste, braucht
  sie zwei Griffe: **`--no-cache-filter <stage>`** führt die Stage bei jedem
  Aufruf neu aus (gecacht bleiben `repo` und die Werkzeug-Layer — gemessen: nur
  zwei Layer `CACHED`, die Gate-Stage läuft), und **kein `-q`**, sonst zeigt ein
  roter Gate nur den Exit-Code statt der Befunde. Beides steht in Modul 14.
- **Der Beleg-Satz ist in allen sechs Skeletten derselbe**: Lint-Befunde,
  Coverage-Zusammenfassung und der maschinenlesbare Coverage-Report
  (`coverage.xml` · `coverage.out` · `jacoco.xml` · `report.xml` ·
  `coverage.cobertura.xml`, je nach Werkzeug). Vorher hatten nur `python` und
  `java` einen Coverage-Beleg — `make export` versprach überall dasselbe und
  lieferte in vier Skeletten weniger.
- **Die Gates dieses Repos ebenso.** `tools/Dockerfile` baut jetzt aus der
  Repo-Wurzel, `docs-check` und `alignment-check` laufen im Image statt über
  `-v "$(CURDIR)":/work`. Neu: `make gate-image` (in AGENTS.md §4 eingetragen)
  und eine `.dockerignore` — ohne sie wanderten 46 MB `.git` in jeden Kontext.
  `d-check.mk` bleibt beim `:ro`-Mount: Es liest nur, und das Fragment gehört
  dem Werkzeug.

### Was der Umbau gefunden hat

Drei Befunde, die es ohne ihn nicht gegeben hätte:

- **Ein selbstgebautes behauptetes Gate.** Die erste Fassung der `export`-Stage
  trug ein `ENTRYPOINT ["sh","-c","tar …"]`. Docker hängt die `run`-Argumente
  daran an, also führte `docker run IMG ruff check .` in Wahrheit *tar* aus —
  `make gates` meldete **grün, ohne eine Prüfung auszuführen**. Gefunden hat es
  der Break-Test, nicht der grüne Lauf. Konsequenz im Dockerfile-Kommentar
  festgehalten: kein `ENTRYPOINT` auf einer Stage, in der man Werkzeuge aufruft.
- **Was nicht kopiert wird, gilt nicht.** `csharp` verlor beim COPY die
  `.editorconfig` — die Analyzer urteilten im Image anders als im Arbeitsbaum
  (CA1707 als Fehler). Dasselbe drohte `java` mit `checkstyle-suppressions.xml`.
  Beide stehen jetzt in der COPY-Liste, mit Begründung an der Zeile.
- **Der `targets`-Sensor hat jede neue Regel gemeldet** — `gate-image`,
  `cov-image`, `export` in fünf Makefiles. `export` steht jetzt in der
  Target-Tabelle des Beispiels (aus „alle zehn" wird „alle elf"), die
  Bau-Schritte in `exempt-targets`; das abgelöste `configure` ist dort raus.

Break-Tests je Skelett (Befund eingebaut → rot, entfernt → grün): `python`
(ruff), `go` (golangci-lint), `cpp` (Compiler), `java` (Checkstyle), `csharp`
(dotnet format), `kotlin` (Kotlin-Compiler).

Gates: `make check` 0 ERROR / 0 WARN, `make bundle-check` 0 Befunde,
`make -C lab/example verify` 74/0, `make gates` in allen sechs Skeletten grün.

## Welle 100 — 2026-08-30 · Zwei Konsumenten lesen mit

Auslöser sind die zwei realen Adopter der Baseline: `d-check` (vendort seit
Längerem) und `claude-ai-harness` (adoptiert gerade, `v5.12.0`). Fünf Befunde,
alle an ihrem oder unserem Bestand belegt — drei sind Lücken **unseres**
Korpus, die erst auffielen, weil jemand anders damit arbeitet.

### Entschieden

- **`MR-<NNN>` steht jetzt im Glossar.** Die Kennung wurde in `modul-02`
  13-mal, in `modul-13` 10-mal und in `grundlagen-source-precedence` 8-mal
  benutzt — und in **zwei Zeilen des Glossars selbst** (`harness/conventions.md`,
  `Stratum`), ohne dass es sie führte. Die neue Zeile definiert sie über ihre
  Rolle, nach dem Vorbild von `BEO-<NNN>`: Adaptions-Eintrag, Vergabestelle ist
  der Adaptions-Block, Zustand ist die Verzeichnis-Position. **Die Buchstaben
  bleiben bewusst unaufgelöst** — nirgends im Korpus und in keinem der beiden
  Adopter-Repos steht, wofür „MR" ausgeschrieben steht; eine Expansion wäre
  eine neue Behauptung, keine Wiedergabe.
- **Die MR-Vorlage verliert ihr `Status:`-Feld.** `MR-NNN-titel.template.md`
  druckte `- **Status:** Accepted` — obwohl ihr eigener Kopfhinweis dreizehn
  Zeilen darüber sagt *„der Zustand ist die Verzeichnis-Position, kein
  Status-Feld"*, die Quelle das Feld nicht unter den Pflichtfeldern führt und
  `lab/example` es nie hatte. Familien-Erbe aus der ADR-Vorlage, dieselbe
  Bauform wie der Befund aus Welle 85. Gewandert ist es trotzdem: `MR-001` in
  `claude-ai-harness` trägt es, weil die Vorlage es vorgab.
- **Modul 14: Der Reproduzierbarkeits-Anker hat zwei Formen.** Der Kurs lehrte
  nur die Archiv-Form (*„brauchst du den Image-Hash von damals"*) und nannte
  ihre Bedingung nicht — die Wörter *Registry*, *push*, *aufbewahren* kamen im
  Modul nicht vor. Neu: **Archiv** (Digest des gebauten Images, Bedingung: das
  Image wird aufbewahrt) neben **Rezept** (Commit plus gepinnte
  Eingangs-Digests, Bedingung: nichts wird beim Build installiert). Mit der
  Präzision, die beide trennt: Der Digest des *gebauten* Images ist nicht
  reproduzierbar — Zeitstempel wandern in die `COPY`-Schichten —, in der
  Rezept-Form hält `harness/image-hash.txt` deshalb fest, *welches* Image lief,
  und ist kein Wiederholungs-Schlüssel.
- **Modul 14: `nonroot` endet nicht am Runtime-Image.** Schritt 4 härtet die
  ausgelieferte Stage; den Arbeitsbaum berührt die Toolchain-Stage. Der Beleg
  lag im eigenen Repo: `lab/example` trug `build/`, `build-cov/`, `target/`,
  `.gradle/`, `.mypy_cache/`, `.coverage` als **`root:root`** — `touch` in
  `build-cov/` scheiterte mit *Permission denied*. Neu ist die Frage *Wem
  gehören die Belege, die ein containerisierter Gate schreibt?* samt der drei
  Antworten und ihrer Preise (`:ro` + Umleitung · `--user` · Rückweg über
  `stdout`), inklusive der Grenze: Der Rückweg löst **Ausgaben**, nicht
  Eingaben — ein erneuertes Lock-File muss zurück in den Baum.
- **Modul 13: Gate und Beleg sind zwei Rollen derselben Prüfung.** Bisher
  nirgends verankert. Ein Befund darf den Report nicht verhindern; das Urteil
  fällt im Gate, nicht im Beleg. `|| true` gehört an den Beleg-Lauf und nie an
  den Gate-Lauf, dort wäre es ein behauptetes Gate. Aufbau-Folge: Die
  einsammelnde Stelle darf nicht vom Gate abhängen — sonst macht ein roter Gate
  das Werkzeug unbaubar, mit dem man ihn untersucht.

### Mitgezogen: der Befund am eigenen Bestand

Die Regel gilt zuerst für uns, und der Bestand war rot: `lab/example` trug
`build/`, `build-cov/`, `target/`, `.gradle/`, `.kotlin/`, `.mypy_cache/`,
`.coverage` und ein leeres `.git` als **`root:root`** — `touch` in `build-cov/`
scheiterte mit *Permission denied*. Ursache in jedem Fall dieselbe: ein
beschreibbarer Bind-Mount und ein Container, der als root lief. Auch die
Wurzel-Gates mounteten `-v "$(CURDIR)":/work` ohne `:ro`, obwohl sie nur lesen.

Die **Antwort** darauf steht nicht hier, sondern in Welle 101: Sie wechselt die
Baseline auf den hermetischen Prüflauf und räumt damit alle drei Schäden
zugleich ab — Besitz, Schreibzugriff auf die Quellen und die root-eigenen
Mountpunkt-Hüllen.

Gates: `make check` 0 ERROR / 0 WARN, `make bundle-check` 0 Befunde.

## Welle 99 — 2026-08-30 · Der Spiegel zeigt nicht nach draußen

Auslöser ist die Lese-Sicht eines **Code-Agenten auf das vendorte Regelwerk**:
Der Schluss von `grundlagen-durchsetzungsschicht.md` §Referenz-Implementierung
schickte ihn zu einem Projekt, das nicht mitreist — *„läuft in realen Repos
bereits produktiv … die Details holt man aus der Referenz."* Die Referenz liegt
nicht im Bundle; der Absatz löst nichts auf und kostet Kontext.

Der Absatz ist doppelt defekt. Welle 35 hat ihn beim Entfernen der
Kurs-Verweise **umformuliert statt gestrichen**: Die Quelle sagt *„läuft in den
Fallstudien-Repos (`fallstudien.md`) bereits real"*, der Spiegel sagte *„läuft
in realen Repos bereits produktiv"* — **`produktiv` kommt in der Quelldatei
nicht vor** (`grep -c`). Das ist eine verfasste Aussage, die
[Probe B](docs/regelwerk-extrakt.md#teil-3--zwei-proben-und-was-keine-von-beiden-fängt)
fängt; gefunden hat sie ein Leser, kein Sensor.

### Entschieden — die Netzlos-Nachlese zu Welle 35

- **Der Absatz entfällt ganz** (Operation 1, ganze Einheit —
  [`docs/regelwerk-extrakt.md` §Teil 2](docs/regelwerk-extrakt.md#teil-2--was-der-spiegel-tun-darf)).
  Operatives geht nicht verloren: *„die Skripte werden hier referenziert, nicht
  inline ausgerollt"* beschreibt die Entscheidung der **Kursseite** über ihre
  eigene Darstellung, keine Regel des Adopters. Fix-Richtung Quelle → Spiegel
  heißt hier **entfernen**, nicht netzlos umformulieren — dieselbe Behandlung
  wie die vier quellenlosen Aussagen in `modul-12` (2026-08-16).
- **`modul-00` fällt mit, aus demselben Griff.** Quelle: *„Lopopolo (OpenAI
  2026) und die Fallstudien in [`fallstudien.md`] belegen das"*; Spiegel seit
  W35: *„… und die **dokumentierten Repo-Fallstudien** belegen das"* —
  `Repo-Fallstudien` steht in der Quelldatei **null**-mal. Der ganze Beleg-Satz
  geht; der tragende bleibt wortgleich (*„Das Modell rät, weil nichts in der
  Eingabe widerspricht"*). Den Quellwortlaut ohne Link zu retten hätte die
  baumelnde Deixis erzeugt, nur den Fallstudien-Teil zu streichen die Flexion
  eines bleibenden Satzes geändert — keine der fünf Operationen.
- **`modul-02` fällt mit, aus anderem Grund.** *„Die vier Fallstudien sind alle
  in BF (siehe oben)"* stand seit Welle 20 **quelltreu** da — im Spiegel zeigt
  aber weder *„die vier Fallstudien"* noch *„siehe oben"* auf etwas, das
  mitreist. Der tragende Satz *„BF ist der typische Ausgangspunkt realer Repos"*
  bleibt.
- **Die Quelle behält ihre Fallstudien-Verweise.** Netzlos zu sein ist die
  Pflicht des Spiegels, nicht des Kurses.

### Entschieden — der Abschnitt sagt jetzt, wozu er da ist

Die Anschlussfrage war *„Das Regelwerk ist für einen Code-Agenten — was soll er
mit einer Referenz-Implementierung anfangen?"*. Antwort: nichts, aber mit einer
**Vollständigkeits-Checkliste** sehr wohl — und genau als solche ist der
Abschnitt am realen Konsumenten belegt (Welle 94: der `d-check`-CR maß gegen die
Zusage *„das vollständige Artefakt-Set"* und fand eine fehlende Klasse). Beide
Korrekturen laufen quell-seitig, der Spiegel erbt sie.

- **Der Titel benennt die Sache statt eines fremden Repos**: `##
  Referenz-Implementierung` → `## Das vollständige Artefakt-Set`. Eine Referenz,
  die der vendorte Leser nicht hat, ist derselbe Defekt wie der gestrichene
  Absatz, eine Ebene höher. Der Anker `#referenz-implementierung` war
  **unreferenziert** (repo-weit geprüft) — der Umbau kostet keinen Link.
- **Der Nachweis-Bullet trägt die Wirkung, nicht den Träger** (Präzedenz Welle
  95): *„eine gemeinsame, inhaltsbasierte Nachweis-Quelle für Gate-Lauf und
  Handoff-Gate (eine Wahrheit, keine Logik-Dopplung)"*. Die Skriptnamen des
  Referenz-Repos stehen im Kurs als **eigener Satz** dahinter — damit sind sie
  im Spiegel als ganze Einheit weglassbar, und der `d-check:ignore`-Marker
  entfällt dort ersatzlos. Ein Pfad, den ein Gate ausnehmen muss, ist kein Pfad,
  sondern eine Illustration; als Regelträger taugt er nicht.
- **Der Vorspann ist die Prüfaussage**: *„Eine Durchsetzungsschicht ist erst
  vollständig, wenn es alle fünf gibt"* statt der Wiederholung des Titels. Damit
  ist zählbar, was vorher Behauptung war.

Die Lehre der Welle steht quer zu beiden Hälften: Eine Netzlos-Runde, die
Verweise **umschreibt** statt sie zu streichen, hinterlässt zwei Schäden statt
keinem — einen quellenlosen Satz und einen Zeigefinger ins Leere.

Gates: `make check` 0 ERROR / 0 WARN, `make bundle-check` 0 Befunde.

## Wellen 95–98 — 2026-08-26 · Vier Punkte aus einem Konsumenten-CR

Auslöser ist ein **Konsumenten-CR von `d-check`** (2026-08-25, geprüft gegen
Baseline `v5.11.0`). Vier Beobachtungen aus dem laufenden Betrieb, jede an
eigenem Bestand belegt, jede einzeln annehmbar gehalten — und **keine**
verlangt ein Gate. Alle vier sind angenommen; einer wird anders encodiert als
beantragt.

## Welle 95 — Die Drei-Ausgänge-Regel bekommt ihre urteilsfreie Hälfte

`modul-05` §*Offene Risiken werden bei Closure aufgelöst* las sich als reine
Disziplin. `modul-06` macht an derselben Lage vor, wie der Kanon damit umgeht
— *Mensch urteilt, Maschine prüft Deckung*, gefolgt davon, was ohne Urteil
prüfbar ist. Für die Drei-Ausgänge-Regel fehlte diese Trennung, obwohl sie
eine hat.

### Entschieden

- **Urteilsfrei ist Form, nicht Inhalt.** *Dass* zu jedem notierten Risiko ein
  Ausgang dasteht und *welcher der drei* es ist — die drei sind eine
  geschlossene Menge, kein Freitext. Ein Risiko ohne Ausgang und ein Ausgang,
  der keiner der drei ist, sind an der Form erkennbar. **Urteil** bleibt, ob
  der eingetragene Ausgang *trägt*.
- **Die Wirkung ist encodiert, nicht der Träger.** Der CR schlug vor: *„ein
  Slice in `done/` trägt keinen unaufgelösten Vorlagen-Platzhalter"*. Das
  steht so **nicht** da, aus zwei Gründen. Erstens Referenz-Richtung — der
  Satz stünde im Kursmodul und setzte die Platzhalter-Form von
  `slice.template.md` voraus; die Vorlage ist abgeleitet und illustrativ, und
  eine Regel, die die Form ihrer eigenen Ableitung zur Bedingung macht, dreht
  die Richtung um. Zweitens Reichweite — der stehengebliebene Platzhalter ist
  ein *Fall* von „kein Ausgang", nicht der Regelinhalt. Ein Adopter ohne
  unsere Vorlage fiele aus der Träger-Fassung heraus.
- **Werkzeug-agnostisch, wie beim Register.** *Welches* Werkzeug die
  urteilsfreie Hälfte prüft, ist Repo-Entscheidung; dass sie eine hat, ist es
  nicht. Der Bindepunkt ist derselbe wie bei der Regel selbst: der Übergang
  nach `done`.

Der CR belegt die Klasse an eigenem Bestand (über drei aufeinanderfolgende
Closures landeten benannte offene Punkte in Closure-Notizen statt in einem der
drei Ausgänge; kein Gate war dafür zuständig) und hat die Prüfung netzlos
gebaut — 137 Slices, null Treffer, vier konstruierte Verstöße rot gesehen. Die
Belege begründen die Regel; sie werden nicht Teil von ihr.

## Welle 96 — *„referenziert Modul-Pfade"* sagt jetzt, welche Pfade

Zwei Fundstellen im Bundle, `modul-03` §*Ziel-Form: Architektur-Sicht* und
`AGENTS.template.md` §3.4, beide wörtlich parallel — der CR hat den vendorten
Baum durchsucht und keine dritte gefunden. Im Kurs-Repo kommt der Spiegel in
`lab/example/AGENTS.md` dazu, der nicht mitreist; er zieht mit. Ob
*Modul-Pfad* einen Code-Pfad oder einen Dokument-Pfad meint, sagte keine von
beiden — und für den Adopter ist die Folge binär: konform oder verschärft mit
Adaptions-Eintrag.

### Entschieden

- **Gemeint sind Pfade zu Code-Modulen** (`src/service/`). Der
  Aufzählungspunkt trägt zwei Eigenschaften und der Satz bedient beide: „darf
  Code-Modul-Pfade referenzieren" trägt die *sprachfreie* Hälfte — ein Pfad
  benennt den Ort, ohne ein Sprachkonstrukt zu nennen —, „aber keine Wellen,
  Slices, Commit-Hashes oder Closure-Daten" die *meilensteinfreie*. Gegen
  „Wellen" hätte ein Dokument-Pfad keinen Kontrast; die Achse ist räumlich
  gegen zeitlich.
- **Die Erlaubnis ist keine Pflicht, und das steht jetzt dabei.** Der Satz ist
  asymmetrisch: Der erste Teil erlaubt, der zweite verbietet. Dass
  `architecture.template.md` ihre Komponenten über Rollen und `ARC-*` führt,
  ist deshalb kein Gegenbeleg — eine nicht ausgeübte Erlaubnis ist kein
  Verbot. Ohne diesen Zusatz bliebe die Frage nur halb beantwortet: Wer
  Code-Pfade *verbietet*, verschärft.

## Welle 97 — Bewusstes Brechen verlangt die gelesene Ursache

`modul-13` §*Fitness Function aus einem ADR-Satz*, sechster Schritt, war
erfüllt, sobald *irgendetwas* rot wurde. Ein roter Exit ist aus dem falschen
Grund leicht zu bekommen — der CR belegt drei Fehlläufe aus zwei
aufeinanderfolgenden Arbeitstagen: ein Nachbarlinter, der das Rot lieferte ·
eine nie gefahrene Direktiv-Form, deren Wohlgeformtheit aus der Annahme
stammte · eine Probe im einzigen ausgenommenen Abschnitt, deren berechtigtes
Schweigen fast als *„greift nicht"* verbucht worden wäre.

### Entschieden

- **Das Rot muss von *dieser* Regel kommen**, und der Nachweis ist nicht *„es
  wurde rot"*, sondern die **gelesene Ursache**: Die Meldung nennt die
  gebrochene Regel und die Fundstelle, beides gehört angesehen.
- **Als Paar mit der Gegenrichtung geschrieben.** Der Kanon führte bereits die
  Negativkontrolle — `modul-11` §Schritt 8 verlangt den *unveränderten
  Bestand*, auf dem der Sensor schweigen muss. Was fehlte, ist die
  Positivkontrolle. `modul-13` verweist jetzt auf `modul-11`, sodass die zwei
  Richtungen von dort als Paar lesbar sind — der Rückverweis bleibt aus, weil
  der CR ihn nicht verlangt und Modul 11 seine Probe für sich vollständig
  beschreibt. Ein Wächter, der immer rot wird, besteht die eine Probe; einer,
  der nie rot wird, die andere; eine bestandene Probe sagt nichts über die
  jeweils andere.
- **Satellit nachgezogen.** `modul-13-loesung.md` §*Provoziere absichtlich
  einen Coverage-Gate-Failure* ließ Schritt 3 bei *„muss rot werden"* stehen —
  genau die Formulierung, die diese Welle als unzureichend benennt. Die Übung
  verlangt jetzt, dass die Meldung die provozierte Datei nennt.

## Welle 98 — Die Reichweite eines Zitats ist jetzt eine Frage, kein Einzelfall

`grundlagen-source-precedence.md` beantwortete die Reichweitenfrage zweimal —
für die `MR-<NNN>` in ihrem Geltungsbereich und für die eigene Rangordnung in
ihrer universalen Hälfte —, beide Male **für sich selbst**. Der Schritt von
den zwei Einzelfällen zur Frage als solcher fehlte, und dort sitzt eine eigene
Fehlerklasse: Der Text stimmt, die in Anspruch genommene Reichweite nicht.

### Entschieden

- **Ein Satz, der die Frage stellt**, an jede zitierte Aussage und auch an
  einen Satz der Baseline: *Gilt er auch außerhalb des Falls, für den er
  geschrieben wurde?*
- **Kein Katalog von Verstoßformen.** Der CR nennt drei beobachtete Formen;
  eine davon ist bereits geregelt und wurde nur überlesen — dafür entsteht
  keine zweite Regel. Die anderen sind Instanzen derselben Frage. Ein Katalog
  deckte die vierte Form nicht ab, die Frage schon.
- **Verortet bei den zwei Stellen**, nicht in `grundlagen-referenz-richtung.md`:
  Die regelt die *Richtung* (welche Artefakt-Klasse welche referenzieren darf)
  und ist als Matrix gebaut; Reichweite ist eine Eigenschaft der zitierten
  Aussage, kein Matrix-Feld.

## Welle 94 — 2026-08-23 · Eine Rangliste ordnet, jetzt deckt sie auch ab

Auslöser ist ein **Konsumenten-CR von `d-check`** („ein Artefakt ohne Rolle, und
keine Vollständigkeits-Zusage", 2026-08-23, geprüft gegen Baseline `v5.9.0` und
Kurs-`HEAD`). Zwei belegte Auslassungen, beide klein, beide mit Schaden am
realen Konsumenten.

### Entschieden

- **Der Werkzeug-Einstieg bekommt eine Rolle.**
  `durchsetzungsschicht.md` §Referenz-Implementierung nannte „das
  **vollständige** Artefakt-Set" und ließ ausgerechnet die Datei aus, die
  **immer** im Lauf-Kontext liegt — die Wurzel-Datei, die das Werkzeug
  automatisch lädt. Nicht bloß eine Auslassung: eine Vollständigkeits-Behauptung,
  die nicht hielt. Sie steht jetzt in der Liste, ausdrücklich als **Artefakt
  vierter Art** — die drei Bindepunkte bleiben drei, der Einstieg ist keiner.
  Ihre Rolle: Sie bringt `AGENTS.md` in den Lauf-Kontext (wo Modul 9 es für
  jeden Lauf verlangt) und **verweist** dorthin, statt festzulegen.
- **Die Rangliste sagt jetzt auch, was *nicht* außerhalb stehen darf.**
  `source-precedence.md` führte neun Ränge und zwei bewusste Nicht-Ränge; eine
  Datei außerhalb war damit **nicht verboten, nur unsichtbar**. Neu: Jede Regel,
  der ein Agent folgen muss, steht in einer gerankten Quelle oder im
  Konventionsspeicher; Artefakte außerhalb dürfen verweisen und ausführen, aber
  nichts festlegen. Das ist die **Mengen-Hälfte** der Zwei-Quadranten-Regel —
  jene sagt, *wo* eine Hard Rule steht, dieser Satz, dass es keine außerhalb
  gibt.
- **Der Anschluss läuft über die bestehende Nicht-Rangliste, nicht daneben.**
  Aus „zwei Dinge stehen bewusst nicht in der Rangliste" werden drei, mit dem
  Unterschied, der sonst verlorenginge: Konventionsspeicher und Baseline
  *dürfen* festlegen, jeder in seiner Rolle — der Einstieg nicht. Ein frei
  formulierter Satz hätte dem Absatz zwei Bildschirme weiter oben
  widersprochen.
- **Die Reihenfolge beim Aufräumen ist das Eigentliche.** (1) zeilenweise
  belegen, wo jede Aussage gerankt steht; (2) Waisen nach `AGENTS.md` umziehen;
  (3) *erst dann* kürzen. Der CR belegt den Beinahe-Unfall: Ein Slice wollte
  eine ungerankte Datei auf einen Verweis kürzen, weil ihr Inhalt „ohnehin
  gerankt" stehe — ein Review widerlegte die Annahme, sonst wäre eine Hard Rule
  gelöscht worden, und kein Gate hätte es gemeldet.
- **Kein Sensor, und das steht dabei.** Welche Datei normativen Text trägt,
  steht nicht in der Datei — es bleibt ein Review-Griff. Die frühere CR-Fassung
  forderte eine Audit-Hälfte; sie ist zu Recht gefallen, denn ohne Baubarkeit
  wäre sie ein behauptetes Gate.

Der CR nimmt in seiner eigenen §5 mehrere frühere Behauptungen zurück
(`.claude/` sei unbekannt; ein Slash-Command mit eigener Schrittfolge sei eine
Abweichung; mehrere Hard Rules seien heimatlos). Diese Welle folgt der
geprüften Fassung: belegt ist **eine** heimatlose Regel, und das genügt.

### Review-Nacharbeit (sieben Befunde, alle behoben)

Ein Review über den ungecommitteten Stand fand sieben Stellen, keine
gate-sichtbar. Zwei davon hätten die Welle in ihr Gegenteil verkehrt:

- **Die Zusage verbot, was das Regelwerk fordert** (MAJOR der Wirkung nach):
  Sie zählte „Skill- und Command-Dateien" unter die Artefakte, die nichts
  festlegen dürfen — während `durchsetzungsschicht.md` §Drei Bindepunkte dem
  Workflow-Skelett (einem Slash-Command) ausdrücklich aufgibt, *„den Ablauf
  vorzugeben (Slice-Workflow als feste Schrittfolge)"*. Ein Adopter hätte
  seinen dritten Bindepunkt auf einen Verweis gekürzt. Aufgelöst über die
  Unterscheidung, die fehlte: **ausbuchstabieren ≠ festlegen** — ein Skelett,
  das die kanonische Schrittfolge vorgibt, buchstabiert aus; eines, das eine
  eigene Regel einführt, legt fest.
- **Die adoptierte Baseline fehlte in der Aufzählung.** Der Satz nannte zwei
  Orte (gerankte Quelle, Konventionsspeicher), der Absatz darüber aber drei
  Nicht-Ränge. Eine Baseline-Regel, die nirgends restated ist, wäre nach dem
  Wortlaut ein illegales „Artefakt außerhalb" gewesen — also löschbar. Genau
  der stille Lösch-Unfall, gegen den diese Welle geschrieben ist. Jetzt drei
  Orte.

Dazu fünf kleinere: **„Zwei-Quadranten-Regel"** war eine Wortprägung, die es im
Korpus nicht gibt, und ihre Glosse gab die bestehende Regel falsch wieder
(sie fordert Verdopplung über zwei Quadranten, nicht eine Rang-Position) —
gestrichen. **„Artefakt vierter Art"** zählte falsch: Die Liste trägt mit
Hook-Verdrahtung und Nachweis-Quelle längst Artefakte, die keine Bindepunkte
sind — jetzt „kein vierter Bindepunkt … ein Artefakt eigener Art". Das
**Mermaid-Diagramm** der Nicht-Rang-Schicht kannte den neuen dritten Eintrag
nicht — Knoten und Legende ergänzt. Im **Spiegel** war der Link-*Text* nicht
mit umgeschrieben (`source-precedence.md` statt `grundlagen-…`), was im
netzlosen Bundle auf eine nicht existierende Datei zeigt. Und eine Prosa-Zeile
lief auf 99 Zeichen statt der üblichen ~75.

Quelle `kurs/de/grundlagen/{source-precedence,durchsetzungsschicht}.md`, beide
Splits wortgleich mitgezogen (nur die Link-Umschreibung des Spiegels).
Regelwerk-Stand auf 94. Gates grün: `make check` 0 ERROR / 0 WARN.

## Welle 93 — 2026-08-23 · AGENTS.md §4 wird die Autorität über die Targets

Welle 92 hatte `targets` mit der Rechnung „19 undokumentierte Targets"
zurückgestellt. Die Rechnung stimmte, ihre Begründung nicht — und die Tabelle,
die sie verlangt, hat eigenen Nutzen: Wer hier arbeitet, findet die Gates jetzt
an einer Stelle statt im Makefile.

### Entschieden

- **§4 trägt eine Target-Tabelle, und sie ist die Autorität.** Sieben Zeilen,
  eine je Wurzel-Target. `targets` prüft beide Richtungen gegen sie: jedes
  behauptete Target ist eine Regel (`gate-phantom`), und jede Regel steht in
  der Tabelle (`gate-undocumented`).
- **Die zwölf `doc-*` sind namentlich ausgenommen, nicht per Glob.** Sie
  stammen aus dem tool-generierten `d-check.mk`, tragen dort ihre eigene
  `##`-Beschreibung und werden von `make doc-help` gelistet; sie in `AGENTS.md`
  zu wiederholen hieße, eine generierte Datei ein zweites Mal zu führen.
  Namentlich statt per Muster, damit eine Fragment-Regeneration mit einem neuen
  Target **auffällt** statt still durchzurutschen — geprüft: `doc-planning` aus
  der Liste genommen ⇒ `d-check.mk:51 gate-undocumented`.
- **Drei Break-Tests, alle beißen.** Erfundenes Target in die Tabelle ⇒
  `AGENTS.md:50 gate-phantom`; `make bundle-check` aus der Tabelle entfernt ⇒
  `Makefile:57 gate-undocumented`; Ausnahme entfernt ⇒ wie oben.
  Wiederherstellung je per sha256 verifiziert.

### Korrektur zu Welle 92

Der dortige Eintrag sagt, die `make X`-Zeilen der Kurs-Tabellen „schlagen gar
nicht an — `gate-phantom: 0`", und gibt das als Messung aus. Das war ein
**Artefakt einer unvollständigen Konfiguration**: Der Probelauf setzte nur
`makefiles` und `authority`, nicht `doc-tables` — und ohne `doc-tables` wird
überhaupt keine Behauptung gelesen. Die Kurs-Tabellen bleiben tatsächlich
außen vor, aber aus einem anderen Grund: `doc-tables` **benennt die Dateien**,
und dort steht nur `AGENTS.md`. Eine Eigenschaft der Konfiguration, keine des
Moduls. Der Welle-92-Eintrag bleibt stehen; ein Register wird nicht rückwirkend
umgeschrieben.

Regelwerk unberührt, Stand bleibt 90. Gates grün: `make check` 0 ERROR / 0 WARN.

## Welle 92 — 2026-08-23 · Zwei Gewohnheiten werden Invarianten

Das Register und die Meilenstein-Tabelle hielten ihre Form bisher nur, weil
niemand sie brach. d-check v0.63.0 brachte die achte `structure`-Bedingung
(`headings-match`), v0.61.0 die siebte (`table-order`) — damit sind beide
Formen prüfbar statt nur gewohnt.

### Entschieden

- **Jede Wellen-Überschrift trägt ihre Nummer.** `headings-match: '^Wellen? [0-9]+'`
  auf Ebene 2 innerhalb von `# Changelog`. Das `?` ist kein Schnörkel: Die
  Sammel-Überschrift `## Wellen 1–16` aus der Zeit vor diesem Register ist
  legitim, und ein naives `^Welle ` hätte sie rot gemeldet — der erste Entwurf
  tat genau das.
- **Die Meilenstein-Tabelle läuft absteigend.** `table-order: desc` auf
  Spalte 1 im Abschnitt `## Meilensteine`. Die Schlüsselzelle wird **roh**
  gelesen, die Backticks um `` `v5.10.0` `` stören also nicht — dafür ist die
  Roh-Lesung gebaut.
- **Beide sind break-getestet, nicht nur grün.** Wellen-Nummer aus der
  Überschrift entfernt → `CHANGELOG.md:14 section-heading-mismatch`;
  zwei Meilenstein-Zeilen vertauscht → `docs/roadmap.md:89 section-unordered`,
  je auf der Bruchzeile. Gegenprobe: `## Wellen 1–16` bleibt still, und ein in
  einem ```markdown-Fence zitiertes `## 7. Closure-Notiz` ebenfalls — Fences
  zählen nicht. Wiederherstellung je per sha256 verifiziert.
- **`CHANGELOG.md` steht in `scan.ignore` und wird trotzdem geprüft.**
  `structure` benennt seine Dateien selbst und kennt deshalb kein `scope`. Das
  steht als Kommentar im Block, weil es beim Lesen der Konfiguration sonst wie
  ein Widerspruch aussieht.
- **`CLAUDE.md` bekommt Titel und Anweisung.** Statt des nackten Verweises
  jetzt „Claude Code Einstieg — ai-harness-course" plus einen Satz: vor jeder
  Änderung `AGENTS.md` lesen und befolgen. Der Titel sagt, um welches Repo es
  geht; die Anweisung ist eine, keine Fußnote. Eigene Regeln trägt sie
  weiterhin nicht. Der Welle-91-Eintrag sagt „ist eine Zeile" — das galt für
  den Stand von Welle 91 und bleibt stehen; ein Register wird nicht rückwirkend
  umgeschrieben.
- **`targets` bleibt aus — die Absage ist gemessen, nicht geraten.** Die
  Vermutung war, die `make X`-Zeilen der Kurs-Tabellen (Lehrbeispiele über
  *fremde* Makefiles) würden das Modul fluten: **`gate-phantom: 0`**, sie
  schlagen gar nicht an. Der echte Preis ist die andere Hälfte —
  **`gate-undocumented: 19`**, weil `AGENTS.md` `make check` nur im Fließtext
  nennt und `targets` ausschließlich Tabellenzeilen sieht. Ob dieses Repo eine
  Target-Tabelle bekommt, ist eine eigene Frage mit eigenem Nutzen, keine
  Sensor-Entscheidung.

Regelwerk unberührt, Stand bleibt 90. Gates grün: `make check` 0 ERROR / 0 WARN.

## Welle 91 — 2026-08-23 · Das Kurs-Repo sagt, wie an ihm gearbeitet wird

Die Konventionen dieses Repos lagen verstreut: Rangfolge in einem behobenen
Review-Befund, Schnittregel in `docs/regelwerk-extrakt.md`, SemVer-Politik in
`docs/team-plan.md`, Commit-Form nur in der Historie, Gate-Pflicht nirgends.
Ein Agent, der hier zu arbeiten anfängt, musste sie sich zusammensuchen — oder
raten.

### Entschieden

- **`AGENTS.md` trägt sie, mit einer Warnung im Kopf.** Der Kurs lehrt
  `AGENTS.md` als Einstieg eines *adoptierenden* Repos (README §Einstiegspunkt
  für Code-Agenten); dieses Repo ist die **Quelle** der Lehre und kein Adopter
  — es führt kein `spec/`, keine Slices, kein `harness/`. Die Datei sagt das in
  ihrem ersten Absatz und verweist für die gelehrte Form auf
  `lab/example/AGENTS.md`. Ohne diesen Hinweis wäre die sichtbarste
  `AGENTS.md` des Repos ein Nicht-Beispiel für das, was es lehrt.
- **Zeigen statt wiederholen.** Rangfolge, Schnittregel und SemVer-Politik
  stehen bereits an ihren Orten; `AGENTS.md` verweist dorthin, statt sie zweite
  Fassung werden zu lassen. Neu niedergeschrieben ist nur, was nirgends stand:
  Commit-Form, Gate-Pflicht vor dem Commit, die Regel gegen neue Prüf-Skripte,
  und dass ein Meilenstein erst mit der Stichprobe im **veröffentlichten**
  Bundle gilt — nicht schon bei grünem Workflow.
- **`CLAUDE.md` ist eine Zeile.** Werkzeug-Verkabelung, kein Harness-Konstrukt:
  Claude Code liest sie von selbst, sie zeigt auf `AGENTS.md` und trägt
  **keinen** eigenen Inhalt. Sobald sie eine Regel selbst formulierte, stünden
  zwei Fassungen derselben Regel im Repo.
- **Kein `Co-Authored-By` mehr, und die Datei sagt warum.** Neue Commits führen
  den Trailer nicht; 47 der 50 Commits davor führen ihn. `AGENTS.md` weist das
  als bewussten Bruch aus statt als Abbild der Historie — eine Konventionsdatei,
  die das Gegenteil ihrer eigenen Historie behauptet, wäre genau die
  Harness-Lüge, vor der Modul 2 warnt.

Regelwerk unberührt, Stand bleibt 90. Gates grün: `make check` 0 ERROR / 0 WARN
(`d-check` sieht die getrackte Sicht — neue Wurzeldateien müssen vor dem Lauf
im Index liegen, sonst meldet er `target-untracked`).

## Welle 90 — 2026-08-23 · Ab Accepted zählt jede Zeile

Vier Befunde am Lastenheft, aus dem Audit nach Welle 89. Der Kern: Die Quelle
lehrte nie, dass das Lastenheft einen Lebenszyklus hat — also hat das Template
ihn erfunden (`Status: Draft | In Review | Accepted`, nirgends sonst im Korpus)
und seine Hauptregel darauf gestützt.

### Entschieden

- **Der Status gilt dem Dokument, nicht der Anforderung.** Vor `Accepted` ist
  das Lastenheft ein Entwurf — frei änderbar, ohne Change Request, ohne
  Historie-Zeile. Ab `Accepted` ist **jede** Änderung eine Vertragsänderung.
  Damit ist auch das **Hinzufügen** einer neuen `LH-*` CR-pflichtig: Die
  Template-Regel sprach von „Änderung an *angenommenen* Anforderungen" und ließ
  damit offen, ob eine *neue* Anforderung darunterfällt — der Scope konnte
  still wachsen, genau an der Decke. Element-Ebene raus, Dokument-Ebene rein,
  wie die Quelle es ohnehin formuliert („Das Lastenheft ändert nur ein externer
  Change Request").
- **Zurückgezogen wird markiert, nicht gelöscht.** Eine `LH-*`, deren Bedarf
  ersatzlos entfällt, bleibt mit `[zurückgezogen]` stehen; die Nummer bleibt
  vergeben (§Vergabe — Lücken werden nicht nachbelegt). Das spiegelt die
  Unterscheidung, die die ADR längst trifft (`superseded` = Antwort wechselt,
  `deprecated` = Bedarf entfällt); für `LH-*` fehlte sie. Gelöscht wären beide
  Fälle unsichtbar, und jeder Slice auf die Kennung zeigte ins Leere.
- **Die Ziffernwahl ist projektlokal.** Das Template verwies für
  `Major.Minor.Patch` auf `modul-03-spec.md` — das dort nichts zur Stelle sagt.
  Verlangt ist der Bump als Fußabdruck; **welche** Stelle steigt, gehört in den
  Adaptions-Block von `harness/conventions.md`, wie die Rangwahl innerhalb des
  Vertrags-Stratums. Kein SemVer-Regime für Anforderungen erfunden.
- **Die Tatsachenberichtigung ist die einzige Ausnahme — und war unverankert.**
  Eine Stelle, die etwas anderes behauptete als vereinbart, ändert nicht das
  Versprechen, sondern dessen falsche Wiedergabe; sie braucht keinen CR, wenn
  sie in der Historie als solche ausgewiesen ist und keine Aussage einer
  Anforderung berührt. Das Beispiel-Repo führte diese Einordnung seit Welle 62
  (`0.4.1` — „Tatsachenberichtigung, keine Vertragsänderung"), Quelle und
  Regelwerk kannten sie nicht: eine Struktur im Beispiel ohne Quell-Verankerung.
  Der erste Entwurf dieser Welle machte es umgekehrt falsch und erklärte **jede**
  Umformulierung zur Vertragsänderung — das hätte einen Tippfehler
  CR-pflichtig gemacht und der besseren Position des Beispiels widersprochen.
  Jetzt trägt die Quelle die Ausnahme, mit den zwei Bedingungen als Wächter.
- **Ein Befund hat die Gegenprüfung nicht überlebt.** „Quelle und Template
  widersprechen sich" war zu scharf: Das Template ist über neue Anforderungen
  *stumm*, nicht gegenteilig — Unterbestimmung, kein Konflikt. Die Behauptung
  steht korrigiert; der Fix ist derselbe.

Quelle `kurs/de/grundlagen/source-precedence.md` §Spec-Stratifizierung, Split
`lab/regelwerk/grundlagen-source-precedence.md` wortgleich mitgezogen; vier
Stellen in `lab/templates/spec/lastenheft.template.md` angeglichen.
`lab/example/spec/lastenheft.md` nicht angefasst — es stand bereits konform,
Kopf wie Historie. `Ü-12` in
[`docs/reviews/review-runde-11.md`](docs/reviews/review-runde-11.md) stand
fälschlich noch als offen; behoben war der Befund seit Welle 62 (`50d726e`),
der Eintrag ist jetzt entsprechend markiert. Kein neues Kennungsschema, kein Sensor: Weder Status noch
Rücknahme sind maschinell prüfbar, beides bleibt Review-Griff.
Regelwerk-Stand auf 90.

### Review-Nacharbeit (sieben Befunde, alle behoben)

Ein Review über den ungecommitteten Stand fand sieben Stellen — keine davon
gate-sichtbar, alle semantisch:

- **Template §7 widersprach der Quelle, die es zitiert** (MAJOR): die
  Tatsachenberichtigung fehlte dort, ein Tippfehler wäre CR-pflichtig gewesen.
- **Das Beispiel trug noch die zurückgezogene Element-Formulierung** (MAJOR):
  `lab/example/spec/lastenheft.md` §7 war die *letzte* Fundstelle von „Änderung
  an angenommenen Anforderungen" im Korpus. Die Behauptung dieser Welle, das
  Beispiel stehe konform, galt für Kopf und Historie — nicht für seinen
  Regeltext.
- **`[zurückgezogen]` war eine Template-Erfindung** (MEDIUM): eine Notation, die
  in Quelle und Regelwerk nirgends stand — derselbe Fehlertyp, den diese Welle
  beseitigt. Jetzt trägt die Quelle die Ziel-Form (*Vermerk im Titel, ohne
  eigene Notation*), das Template spiegelt sie.
- **Ein Split-Absatz war paraphrasiert statt weggelassen** (MEDIUM):
  `grundlagen-referenz-richtung.md` schrieb die User-Story-Probe um, statt die
  Sätze der Quelle zu übernehmen und die Literatur zu streichen. Jetzt exakt
  das: reine Auslassung von 103 Zeichen, sonst wortgleich.
- **„Form ist kein Beleg" stand unversöhnt neben Mechanismus 1** (MEDIUM), der
  das Stratum gerade über die Kennungs-*Form* bestimmt. Aufgelöst: Die
  Kennungs-Form **deklariert**, sie belegt nicht — sie ist die Erklärung des
  Autors, nicht das Aussehen der Gattung.
- **Der Berichtigung fehlte der eigene Fußabdruck** (LOW): Version-Bump und
  Historie-Zeile bleiben, „Verweis" trägt `—`.
- **Der Ü-12-Nachtrag nannte den Split als Quelle** (LOW), nicht `kurs/de/`.

Gates grün: `make check` 0 ERROR / 0 WARN.

## Welle 89 — 2026-08-23 · Form ist kein Beleg

§Spec-Straten nennt zwei Achsen — *normativer Gehalt* und *Änderungs-Prozess* —
und sagte nicht, welche bei Dissens sticht. Aufgefallen ist es an der User
Story: Sie schreibt Given/When/Then wie das Lastenheft, wird aber im Refinement
geändert. Nach Form gälte Vertrag, nach Prozess nicht.

### Entschieden

- **Bei Dissens entscheidet der Änderungs-Prozess.** Der normative Gehalt ist
  Auslegung — die Fachliteratur streitet ihn am selben Artefakt aus (Cohn:
  „represents a requirement"; Jeffries: die Karte enthält „not all the
  information that makes up the requirement … just enough text to identify"
  sie). Der Änderungs-Prozess ist dagegen beobachtbar, und die
  Stratum-Definitionen sind ohnehin über ihn formuliert („Change Request",
  „fortschreibbar", „Diagramm-Update"): Die Gehalts-Spalte beschreibt, die
  Prozess-Spalte entscheidet.
- **Die Genre-Falle ist benannt.** Eine vertraute Dokument-Gattung legt ein
  Stratum durch ihre *Form* nahe; Form ist kein Beleg. Das trifft jeden
  Adopter, der ein benanntes Genre mitbringt — die Kollision steckt im eigenen
  Lastenheft-Template (Given/When/Then für `LH-FA-*`), nicht nur in fremden
  Gewohnheiten.
- **Beide Änderungs-Prozesse stehen jetzt im Glossar.** §Trennschärfen
  unterscheidet *Refinement* (teamintern, laufend, ohne Vertragspartner) von
  *Change Request* (extern mit dem Auftraggeber vereinbart) — das Paar, das
  nach dieser Welle über das Stratum entscheidet. „Change Request" ist
  zusätzlich Kernbegriff, quelltreu aus §Spec-Stratifizierung verdichtet; der
  `Stratum`-Eintrag nennt den Tie-Break. Ohne das trüge der neue Text mit
  „Refinement" einen tragenden Begriff, den der Korpus nirgends führt — der
  Fehlertyp, den dieselbe Welle am Lastenheft-Template benennt.
- **Kein viertes Stratum, kein neues Kennungsschema, kein Sensor.** Die User
  Story ist Slice-Klasse und liegt unter `docs/plan/planning/`; ein
  `spec/user-stories/` hebt ein volatiles Artefakt über die Decke. „Wer darf
  diese Datei ändern" steht nicht in der Datei und ist damit nicht maschinell
  prüfbar — Review-Griff, kein Gate. Templates und `lab/example` unberührt.

Quelle `kurs/de/grundlagen/referenz-richtung.md` §Spec-Straten und
`begriffe.md`, Splits `lab/regelwerk/grundlagen-referenz-richtung.md` und
`grundlagen-begriffe.md` quelltreu mitgezogen (Didaktik und Literatur
weggelassen); Regelwerk-Stand auf 89. Kein neuer Anker, keine
neuen Verweise — die 17 Dateien, die auf §Spec-Straten zeigen, bleiben
unberührt.

Gates grün: `make check` 0 ERROR / 0 WARN.

## Welle 88 — 2026-08-22 · Vier unbelegte Aussagen, sieben Verdikte

Der Faden aus Welle 87: Closure-Seite, Vorvergabe, Rolleninhaber-Feld und
`doc-immutable` unter Nebenläufigkeit — vier Aussagen des Korpus, bis hierher
aus dem Text abgeleitet. Jetzt je ein Szenario mit vorab notierter Erwartung,
und jedes nennt die Kursstelle, die es trägt.

### Gemessen, nicht behauptet (Lauf 2026-08-22, d-check v0.62.0, 23/23 · 0 KAPUTT)

| # | Zustand | erwartet | beobachtet |
|---|---|---|---|
| s08a | Welle auf `main` geschlossen, Register-Zeile ohne Ergebnisnotiz (`waves`, `many`) | `wave-results-missing` | ✓ laut |
| s08b | dieselbe Closure sauber — der Slice der Welle bleibt beansprucht (`in-progress/`, offener PR) | **still** | ✓ kein Sensor sieht den Widerspruch |
| s09 | `slice-002` im Wellen-Plan vorvergeben, im PR anders gezogen | **still** | ✓ „den PR-Rest fängt das Schema nicht" |
| s10a | beide setzen `Verantwortlich:` desselben Slice | Konflikt, laut | ✓ |
| s10b | Übernahme des Feldes, Gegenseite ändert nur den Rumpf | **still** | ✓ Inhaber gewechselt, niemand hat es gesehen |
| s11a | Geschichte-Zeile einer Accepted-ADR per PR, `vcs` auf der Range | 0 Befunde | ✓ `exclude-sections` trägt |
| s11b | Entscheidung derselben ADR per PR gelandet | `core-drift-vcs` | ✓ auch durch den Merge-Commit |

### Entschieden

- **Drei stille Ausgänge sind Lehre, keine Defekte.** Die Planning-Sensoren
  halten Form gegen Form (Marker ↔ Verzeichnis, Zeiger ↔ Dateien, Zeile ↔
  Notiz, Kern ↔ Range); das `Welle:`-Feld eines beanspruchten Slice gegen
  eine geschlossene Welle (Modul 6 §Wellen-Closure-Prozedur, Schritt 1), die
  Vorvergabe im Wellen-Plan (source-precedence §Vergabe) und das
  Rolleninhaber-Feld (TA-1) haben keinen Wächter — und der Korpus sagt das
  an allen drei Stellen schon. Kein Sensor behauptet; die README benennt die
  Grenze und was ein Wächter messen müsste.
- **`doc-immutable` läuft jetzt im Team-Kontext:** der einzige Sensor mit
  Commit-Range sieht den Kern-Eingriff auch, wenn er per Merge-Commit landet,
  und lässt die Geschichte-Zeile durch. Seed erweitert um `ADR-0001` und den
  `vcs`-Block (nicht in `modules:` — s11 schaltet ihn per `--enable vcs
  --range` ein, wie der PR-Job); `planning` steht im Seed zuletzt, damit die
  Szenarien ihren `waves`-Block weiter anhängen können — der erste Lauf fand
  genau diesen Fehler (`field waves not found`, 2 FAIL) und einen zweiten im
  Schnitt von s10b (zweite Probe vom halb gemergten Stand statt vom Seed).
- Faden geschlossen (verlässt die Tabelle); Regelwerk unberührt, Stand bleibt
  86 (Lab-only).

Gates grün: `make check` 0 ERROR / 0 WARN.

## Welle 87 — 2026-08-22 · Team-Sim in Modul-12-Form

`lab/team-sim` hat heute zwei Kursaussagen getragen (Modul 5 s06, Modul 6
s04b/g/e/h) und einen d-check-CR belegt — als Runner war es ein Skript mit
Verdikten nach stdout, ohne Auswahl, ohne Ergebnisdatei, mit einem Manifest,
das den Lauf nicht bestimmte. Das ist die Replay-Form, die Modul 12 lehrt,
nur zur Hälfte. Nachgezogen, ohne eine Kennung zu ändern.

### Entschieden

- **Runner:** `bash run.sh [sNN …]` läuft Gruppen einzeln (Kennung = Präfix
  der Verdikte); `SIM_CLEAN=1` räumt auf; jeder Lauf schreibt
  `$WORK/ergebnis.tsv` mit Kopf (Datum, Image-Digest, Repo-Stand, Seed-Hash)
  und je Verdikt Szenario · erwartet · beobachtet · Verdikt — der Lauf ist
  belegbar, nicht nur notiert. Vorbedingungs-Schritte laufen durch
  `schritt`: scheitert einer, ist das Szenario **`KAPUTT`**, nicht `FAIL` —
  ein Verdikt über einen nie hergestellten Zustand wäre keines (Exit-Code
  schlägt bei beidem). Befund-Erwartungen prüfen Code **und** Ziel
  (`wave-drift` auf `welle-5`, `planning-drift`), nicht „Code irgendwo".
  Reihenfolge nach Aussage gruppiert, Kennungen **stabil** — Modul 5 und 6
  zitieren sie.
- **Manifest nach Modul 12:** was den Lauf bestimmt — Runner, Seed,
  Runtime (Image, Digest-Quelle, Netz, Topologie), wo die Erwartungen stehen,
  wo das Ergebnis landet, Gruppen → Verdikte, Läufe mit Datum, Image, Satz
  und Ergebnis. Vorher: Name, Seed-Pfad, eine Szenarien-Liste und der
  Digest als Kommentar.
- README: §Aufruf, Tabelle in Runner-Reihenfolge, Kopfzeile der Läufe
  fortgeschrieben. Kein Gate, wie gehabt; Regelwerk unberührt
  (Regelwerk-Stand bleibt 86 — Welle-72-Präzedenz: Lab-only).
- **Nicht in dieser Welle:** neue Szenarien. Die Closure-Seite unter
  Nebenläufigkeit (Welle schließen, während ein PR einen Slice beansprucht),
  die Vorvergabe (`slice-002` im Wellen-Plan ohne Datei, TB-010), der
  Rolleninhaber-Doppelanspruch im Feld (TA-1) und `doc-immutable` im Team
  sind unbelegte Aussagen — als Faden in `docs/roadmap.md` eingetragen.

Gemessen: 16/16 · 0 KAPUTT auf d-check v0.62.0 (`ergebnis.tsv` im Lauf);
Auswahl `s06` einzeln grün; `SIM_CLEAN` entfernt das Arbeitsverzeichnis; der
`KAPUTT`-Pfad meldet, zählt und schreibt die Zeile. Gates grün: `make check`
0 ERROR / 0 WARN.

## Welle 86 — 2026-08-22 · Versionen hat der Vertrag

Nachlese zu Welle 85: Die Historie der Spezifikation hatte im Template die
Spalten `Version | Datum | Änderung`, im Beispiel `Datum | Änderung` — und die
Quelle entschied es nicht. Gemessen an den Konsumenten: d-check führt seine
Spezifikations-Historie als `Datum | Änderung`, a-check (Template-Erbe) mit
`Version`. Der Vertrag trägt die Version, weil ihr Bump der Fußabdruck des
Change Requests ist (§Spec-Stratifizierung); die Technik ist fortschreibbar
ohne ihn — eine Technik-Version versioniert nichts, was jemand bezieht.

### Entschieden

- **Die Historie der Spezifikation führt Datum und Änderung — keine Version**
  (Modul 3 §Die Spezifikation, Quelle; Regelwerk §Ziel-Form: Spezifikation).
  `spezifikation.template.md` verliert die Spalte; das Beispiel hatte sie nie.
  Lastenheft-Historie (`Version | Datum | Änderung | Verweis`) unverändert.

Gates grün: `make check` 0 ERROR / 0 WARN, Beispiel `verify`, `make bundle-check`.

## Welle 85 — 2026-08-22 · Die Technik hat eine Historie, keinen Kopf

Der Faden aus dem Welle-84-Review: `spezifikation.template.md` trug
`**Status:** Aktiv. **Letzte Änderung:** <Datum>` **neben** seiner Historie —
ohne Quell-Satz. Modul 3 nennt das Frische-Datum nur für die Sicht (*„Keine
Historie, nur ein Frische-Datum … Vertrag und Technik führen eine"*); das
Template hatte die Kopfzeile aus der Familie geerbt.

### Entschieden

- **Kein Kopf-Datum, kein Kopf-Status für die Spezifikation** (Modul 3 §Die
  Spezifikation, Quelle; Regelwerk §Ziel-Form: Spezifikation): Ihre Änderungen
  stehen in der Historie, die letzte Zeile ist das Datum — ein Frische-Marker
  im Kopf wäre dasselbe Datum ein zweites Mal, und zwei Felder für eines
  driften. Das unterscheidet sie von der Sicht, die keine Historie hat. Einen
  eigenen Status trägt sie nicht: verbindlich, solange das Lastenheft es ist,
  dessen Status die IDs steuert. Der Frische-Marker der Sicht und die
  Kopfzeile des Lastenhefts (Version · Status · Autor/Datum, der
  CR-Fußabdruck) bleiben.
- `spezifikation.template.md` und das Beispiel verlieren die Zeile; der Faden
  ist geschlossen und verlässt die Tabelle.

Gates grün: `make check` 0 ERROR / 0 WARN, Beispiel `verify`, `make bundle-check`.

## Welle 84 — 2026-08-22 · Ein Register hat keinen Kopf

Der kleine Faden aus Welle 83: Die Kopfzeile `**Status:** Aktiv. **Letzte
Änderung:** <Datum>` über Roadmap und Registern — gepflegtes Feld oder `git`?

### Gemessen, nicht behauptet

Die Kopfzeile ist eine Template-Familie: `spezifikation`, `architecture`,
`reconciliation`, `observations`, `roadmap`. Für das Sicht-Stratum ist sie
Quelle-verankert (Modul 3: *Frische-Marker, kein Änderungs-Protokoll*), und
das Beispiel pflegt sie (architecture 08-08 = letzter Commit); die Technik
trägt sie im Template neben ihrer Historie, ohne Quell-Satz — als Faden
eingetragen, nicht Gegenstand dieser Welle. Für die drei
lebenden Planning-Register schreibt keine Quelle sie vor — und dort stand sie
stale: Beispiel-`observations.md` 06-03 bei letztem Commit 08-09,
Beispiel-Roadmap 06-03 bei 08-16, Kurs-Roadmap `Stand: 07-31` über 26
Datei-Commits (`50d726e..aaf1145`, drei Wochen).
`Status: Aktiv` hatte in keinem Register je einen anderen Wert.

### Entschieden

- **Lebende Register tragen keine Kopfzeile** (`harness-dateien.md` §Was ein
  Kommentar trägt, Absatz *Die Kopfzeile eines lebenden Registers ist
  derselbe Fall*; Regelwerk-Spiegel): *Aktiv* ist kein Zustand, den ein
  Register wechselt, und ein Datum, das niemand pflegt, behauptet einen — die
  Stand-Zellen-Regel aus Welle 83, nur im Kopf. Der Zustand eines Registers
  ist sein Inhalt, sein Änderungsdatum hält `git`. **Der Frische-Marker des
  Sicht-Stratums bleibt** — er ist die bewusste Aussage, die kein Inhalt
  darunter trägt; die Abgrenzung steht im selben Absatz.
- `roadmap.template.md`, `observations.template.md` und
  `reconciliation.template.md` verlieren die Zeile; Spec-Templates unberührt.
  Beispiel-Roadmap und -Beobachtungs-Register ohne Kopfzeile; die Kurs-Roadmap
  ohne `Stand:`; `docs/team.md` ebenso — es ist ein Register (`TB-`/`TA-`
  mit `Stand`-Spalte), und sein Kopf stand einen Tag hinter der letzten
  Inhaltsänderung. Nicht gemeint ist ein Kopfdatum, das ein benannter Trigger
  pflegt — der Wellen-Stand des Regelwerks, der Frische-Marker der Sicht.
- **Faden *Kopfzeile `Status:`/`Letzte Änderung:` der Roadmap* geschlossen**
  — entschieden für `git`; die Zeile verlässt die Tabelle.

Gates grün: `make check` 0 ERROR / 0 WARN, Beispiel `verify`, `make bundle-check`.

## Welle 83 — 2026-08-22 · Zustand und Anker — die zweite Hälfte der Zeitform-Regel

Welle 71 bestimmte, was ein Kommentar trägt, und nannte die Klasse beim Namen:
*Zeitform im Zustands-Artefakt*. Ihre zweite Hälfte — die Rümpfe von Registern
und Roadmap — blieb unbestimmt, und die Roadmap dieses Repos zeigte, was dann
passiert. Gemessen am 2026-08-22, bevor eine Zeile Norm geschrieben war.

### Gemessen, nicht behauptet

`docs/roadmap.md` vor dem Umbau: die `Stand`-Zellen dreier offener Fäden mit
894, 1.174 und 1.303 Zeichen — Chroniken statt Zustände, eine davon mit zwei
Punkten, die laut `docs/team.md` seit Welle 79 umgesetzt waren; das Drift-Log
mit der Zeile „Noch keine." und darunter **18 Zeilen** — neun Meilensteine,
neun Faden-Schließungen, **null** Trigger-Verschiebungen —, während der
CHANGELOG dieselben neun Schließungen längst führte (Wellen 49, 52, 54, 55, 58,
73, 74) und §Abgeschlossene Wellen Nicht-Duplikation zusagte; dazu zwei
stehengebliebene Zustandssätze (`Stand: 2026-07-31`, „Der letzte war v5.6.0").
Die Regel existierte schon — für Kommentare (Hard Rule *Herkunft als ein
auflösbares Feld, nie als Absatz*), und ihr Vorbild auch: die `Stand`-Spalte
des Beobachtungs-Registers (*„verkörpert in `AGENTS.md` §2.7 (`seit welle-1`)"*).

### Entschieden

- **Dieselbe Regel für Zustandsfelder** (`harness-dateien.md` §Was ein
  Kommentar trägt, Quelle): Eine `Stand`-/`Status`-Zelle nennt den Zustand
  und den Beleg — als auflösbaren Anker, nie als Chronik; eine Begründung des
  Zustands ist Zustand. Was sonst in der Zelle stand, hat seine Orte:
  Behauptung und Handlung beim Vorhaben, Schließung im Closure-Log
  (Wellen-Betrieb: *Abgeschlossene Wellen*; sonst dort, wo das Repo
  Schließungen führt — `done/` und `git`, ohne Slice-Lifecycle etwa der
  `CHANGELOG`), Umplanung im Drift-Log, der Rest in `git`. Ein Drift-Log, das
  Schließungen und Meilensteine protokolliert, ist ein zweites Closure-Log —
  eine Kopie, und Kopien driften. Adressaten- und Zeitform-Test gelten
  unverändert; Träger sind Briefing (`AGENTS` §3.7) und Reviewer-Skill, kein
  Gate — „ist das eine Chronik?" ist ein Urteil.
- **Modul 6, Schritt 6 sagt, was die Register tragen — und was nicht:**
  Closure-Log = was geschlossen ist; Drift-Log = was umgeplant wurde
  (Trigger verschoben, präzisiert, ersetzt; Slice oder Welle umgehängt) und
  sonst nichts; erreichte Meilensteine stehen mit Datum und Beleg in der
  `Status`-Spalte ihrer Tabelle. Regelwerk-Spiegel (beide) wortgleich im
  Operativen; `roadmap.template.md` trägt die Regel als Bedienhinweis an
  Meilenstein- und Drift-Tabelle; der Reviewer-Skill bekommt den HIGH-Eintrag
  *Zustandsfeld trägt Chronik*, `AGENTS.template.md` §3.7 den Zusatz; kein
  Sensor behauptet. Das Beispiel zieht nach: M1 trägt seinen Beleg.
- **`docs/roadmap.md` nach der Regel umgebaut** (Commit `aaf1145`, vor der
  Norm — das Artefakt war das Audit): `Stand`-Zellen 21–358 Zeichen, Behauptung
  und Handlung in der Faden-Zelle, Messungen als Commit-/Register-Anker;
  Drift-Log mit fünf echten, aus git datierten Umplanungen; erreichte
  Meilensteine unter §Meilensteine in der Modul-6-Form; geschlossene Fäden
  verlassen die Tabelle.
- **Faden *Roadmap-Rumpf trägt Entstehungsgeschichte* geschlossen** — Norm
  geschrieben, Artefakt umgebaut; die Zeile verlässt die Tabelle, wie die Regel
  es sagt.

**Nachgetragen:** Zwei Schließungen standen bisher nur in der `Stand`-Zelle
ihres Fadens, nicht im Register — der Faden *d-check-Pin-Sprung (v0.56.0 →
v0.59.0)*, geschlossen am 2026-08-16 (Commit `061fe8f`), und der Faden
*`waves.dir` und das Offene-Wellen-Modell*, geschlossen in Welle 82 (Commit
`f108b1e`). Die neun Schließungen der alten Drift-Tabelle standen bereits in
ihren Wellen.

**Neuer Faden:** die Kopfzeile `Status:`/`Letzte Änderung:` der Roadmap
(Template-Form) war in Kurs-Roadmap und Beispiel stale — gepflegtes Feld oder
`git`? In `docs/roadmap.md` eingetragen, nicht entschieden.

Gates grün: `make check` 0 ERROR / 0 WARN, `make bundle-check`.

## Welle 82 — 2026-08-22 · Die zweite Hälfte bekommt ihren Wächter

Welle 81 hatte die Lücke benannt: Der Abschnitt *Offene Wellen* trägt zwei
Aussagen, gewächtert war nur eine. Noch am selben Tag liefert d-check v0.62.0
genau das Prädikat, das der Kurs als Change Request erbeten hatte; einen Tag
später schaltet das Lab es ein — gemessen statt gelesen.

### Entschieden

- **Zwei Aussagen, zwei Wächter** (Modul 6 §Offene Wellen, Quelle). Die
  Marker-Hälfte bleibt die deklarierte Redundanz (Marker ⟺ `in-progress/`
  ohne Slice, beide Richtungen). Die Listen-Hälfte ist kein Marker-Vergleich,
  sondern eine **Bijektion** — Kennungen im Block ⟺ flache Welle-Dateien,
  beide Richtungen —, und sie hat eine Vorbedingung, die der Marker nicht
  hat: Der Sensor muss das **Kardinalitäts-Modell** kennen. Ein Wächter, der
  den Block gegen *genau eine* Datei hält, meldet unter *Offene Wellen* zwei
  legitime Zustände als Drift (zwei offene Wellen; Welle eröffnet, nichts
  beansprucht). Der Ruhe-Marker geht in die Bijektion nicht ein. Das
  „bekannte Lücke statt verschwiegener" aus Welle 81 bleibt als Regel
  stehen: Wer eine Hälfte ungewächtert lässt, benennt sie. Der
  Regelwerk-Split zieht quelltreu nach, der Bedienhinweis in
  `roadmap.template.md` in Template-Form; die Template-`.d-check.yml` trägt
  weiter keinen `planning`-Block — die Quelle schreibt keinen vor.
- **`lab/example` hält beide Hälften** (`slice-025`): `planning.waves` mit
  `dir: docs/plan/planning` und `mode: many`; die übrigen Schlüssel treffen
  die Repo-Defaults und stehen deshalb nicht in der Config. Bestand 73/0 ohne
  eine Änderung an Roadmap oder Welle-Dateien; AGENTS.md §3,
  `harness/README.md` und `docs/plan/planning/README.md` nennen den Wächter.
  Die GRENZE-Notiz „bewusst kein Opt-in" ist damit Geschichte.
- **d-check-Pin v0.59.0 → v0.62.0** (Digest `sha256:3996a593…4cacf`;
  Gegenprobe aus Welle 73 bestanden: Release **und** Image publiziert).
  Prozedur wie beim
  letzten Sprung: Trockenlauf auf beiden Konfigurationen identisch (Wurzel
  207/0, Beispiel 73/0), die zwei `planning`-Break-Tests aus Welle 78 beißen
  auf dem neuen Image mit unverändertem Code `planning-drift`, beide
  `d-check.mk`-Fragmente regeneriert — **auch das des Beispiels, das seit
  v0.56.0 stehengeblieben war**; das neue Target `doc-structure` hat der
  `targets`-Sensor des Beispiels wie vorgesehen als `gate-undocumented`
  gemeldet, es steht jetzt in `exempt-targets` (optionaler d-check-Lauf,
  kein Gate). bundle-check 49/0. v0.60.0 (`links.resolve-from`) und v0.61.0
  (`structure`, Chronologie-Monotonie) sind opt-in und bleiben aus.
- **Team-Sim-Manifest vollständig.** `manifest.yaml` führte neun Szenarien,
  `run.sh`/README elf — s04c/s04d fehlten seit Welle 81. Jetzt sechzehn, und
  jede Erweiterung steht mit Datum, neuem Satz und Ergebnis im Manifest.
  `dcheck()` im Runner reicht die volle Ausgabe durch statt `tail -2` — ein
  zweiter Befund hätte den erwarteten Code sonst aus dem Fenster geschoben.

### Gemessen, nicht behauptet

| Zustand | `mode: one` (Default) | `mode: many` |
|---|---|---|
| Team-Sim-Seed, zwei offene Wellen (flach + gelistet) | `wave-drift` (**s04b**) | grün (**s04e**) |
| Seed, **eine** Welle eröffnet und nichts beansprucht (Zeiger und Marker nebeneinander) | `wave-drift` (**s04g**) | grün (**s04h**) |
| Seed, dritte Welle flach **ohne** Zeiger | — | `wave-drift` (**s04f**) |
| Seed, Zeiger **ohne** Datei | — | `wave-drift` (**s04i**) |
| Beispiel, heutiger Bestand | grün (genau eine offene Welle — der Singleton gilt zufällig) | grün |
| Beispiel-Kopie, zweite offene Welle | `wave-drift` | grün |
| Beispiel, vier Experimente, fünf Codes | — | `wave-drift` in beide Richtungen, `wave-preview-exists` (Beifang des welle-3-Tests), `wave-results-missing`, `wave-unregistered` |

Team-Sim 16/16 (Lauf 2026-08-22, d-check v0.62.0). Die ersten zwei Zeilen
sind der Kern: derselbe Zustand, zwei Verdikte — das Modell entscheidet,
nicht der Bestand. Die Beispiel-Zeile „heutiger Bestand" ist die Warnung: Ein
grüner Opt-in-Lauf beweist nur, dass der Bestand konsistent ist, nicht,
welches Modell der Sensor prüft. Nicht geskriptet, ad hoc am Seed gemessen:
`mode: ""` → Exit 2 mit Schlüssel-Nennung (fail-closed); und zwei flache
Wellen **mit** Marker sind unter `one` zufällig grün — der Bool-Vergleich
zählt bei stehendem Marker nur „ungleich eins" —, deshalb misst s04g den
Ein-Wellen-Fall.

Gates grün: `make check` 0 ERROR / 0 WARN (d-check 208 Dateien, 0 Befunde),
`make -C lab/example verify` 74/0, `make -C lab/example gates COURSE_LANG=go`,
`make bundle-check` 49/0.

## Welle 81 — 2026-08-21 · Zwei Hälften, ein Wächter

Zwei Befunde aus einem Konsumenten-Audit, beide von derselben Bauart: Die
Regel nennt ihr Mittel und lässt offen, was sie trägt — und wer sie
mechanisiert, merkt es als Erster.

### Entschieden

- **`klasse` ist das sechste Feld des Output-Schemas** (Modul 10). Welle 43
  führte die Finding-Klasse als Übergabepunkt in den Steering-Loop-Zähler ein
  und verankerte sie im Report-Template — das §Output-Schema der **Quelle**
  zählte weiter fünf Felder. Das Template erklärt seine Felder zugleich für
  *„nur gespiegelt, bei Abweichung gilt der Skill"*: Nach seiner eigenen
  Konfliktregel war `klasse` damit nichtig, während der Zähler daran hing.
  Fix-Richtung Quelle — Modul 10 führt das Feld, Regelwerk-Split und
  `reviewer.template.md` ziehen wortgleich mit; ohne den Skill-Mitzieh wäre
  die Drift nur eine Ebene tiefer gewandert (Report-Template sechs Felder,
  Reviewer-Skill fünf).
- **Der Ruhe-Marker steht *zusätzlich* zur Liste, nicht an ihrer Stelle**
  (Modul 6 §Offene Wellen). Der Abschnitt trägt zwei **unabhängige**
  Aussagen: Die Liste folgt den **Dateien** (ein Zeiger je offener
  Welle-Datei), der Marker folgt dem **Anspruch** (`in-progress/` ohne
  Slice). Das alte „stattdessen" stellte beide gegeneinander und widersprach
  damit der eigenen Wellen-Eröffnungs-Prozedur, deren Schritt 3 den Zeiger
  setzt, *bevor* ein Slice beansprucht ist — der Normalfall nach jeder
  Eröffnung war unter der Struktur-Regel nicht darstellbar. Der Marker sagt
  jetzt, was sein Wortlaut sagt: *nichts in Arbeit*, nicht *keine offene
  Welle*.
- **Die Wächter-Semantik ist benannt statt angedeutet.** Gewächtert ist nur
  die Marker-Hälfte, und zwar in **beide** Richtungen: fehlender Marker bei
  leerem `in-progress/` und stehengebliebener Marker bei beanspruchtem Slice
  sind derselbe Defekt. Die Liste ist Ableitung **ohne** Wächter — sie gegen
  die Welle-Dateien zu halten wäre eine Bijektion, kein Marker-Vergleich, und
  braucht ein eigenes Prädikat. Das steht ausdrücklich da: Wer die Kopplung
  mechanisiert, soll wissen, *welche* Hälfte sein Sensor prüft, statt einen
  halben Wächter für einen ganzen zu halten.
- **Der Marker-Wortlaut gehört in keinen Sektions-Text** — neu im
  Bedienhinweis von `roadmap.template.md`, der ihn selbst literal trug. Ein
  Doku-Sensor matcht den Marker als Substring des Blocks; ein Hinweis- oder
  Regeltext, der den Wortlaut zitiert, matcht sich selbst und meldete „Ruhe"
  bei beanspruchtem Slice. Die Vorlage verweist für den Wortlaut jetzt aufs
  Regelwerk, statt ihn zu nennen, und sagt Sensor-Bauern dazu: Code-Fences
  beim Matchen aus dem Block nehmen.

### Gemessen, nicht behauptet: Team-Sim 11/11

„Hält in beide Richtungen" wäre ohne Lauf eine Behauptung gewesen.
`lab/team-sim/` bekommt zwei Szenarien (Lauf 2026-08-21, 11/11): **s04c**
stellt den baseline-legitimen Zustand her — zwei Wellen gelistet,
`in-progress/` leer, Marker neben der Liste — und `planning` bleibt grün;
**s04d** nimmt allein den Marker weg, und derselbe Sensor meldet
`planning-drift`. Damit ist die Äquivalenz gemessen statt gelesen. Der
`waves.dir`-CR-Faden bleibt unberührt offen: Die Bijektion Liste ↔ Dateien
prüft weiterhin niemand.

## Welle 80 — 2026-08-16 · Geprobt, nicht belegt

Zwischen *entworfen* (Welle 79) und *belegt* (braucht ein adoptierendes Team)
fehlte eine Stufe, die von uns herstellbar ist: **geprobt** — die
Nebenläufigkeits-Mechanik der sieben Anpassungen unter simuliertem
Mehr-Schreiber-Betrieb provoziert, mit vorab notierten Erwartungen.

### Entschieden

- **`lab/team-sim/` — ein Replay für Nebenläufigkeits-Szenarien**, nach der
  Bauform von Modul 12: Je Szenario eine frische Team-Topologie (bare
  `origin.git` + zwei Clones — bewusst keine Worktrees, die modellieren
  *einen* Entwickler), Aktionen als `alice`/`bob`, Erwartung als Verhalten —
  laut, still oder Gate-Befund. **Auch die stillen Ausgänge sind
  Erwartungen**: Verläuft die Nummern-Kollision *nicht* still, hätte die
  Lehre die Falle falsch beschrieben. Kein Gate — läuft auf Anlass, steht
  nicht in `make check`; der d-check-Digest kommt aus dem Repo-Makefile
  (eine Quelle), fail-closed außerhalb des Repos.
- **`team.md` §SOLL ist dreistufig.** Die Grenze steht in der Stufe selbst:
  Geprüft ist die Mechanik mit kooperativen Akteuren, die die Regeln kennen —
  **Dissens, Lesarten-Divergenz zwischen Menschen und echte Einarbeitung
  bleiben bei 0×**, und es ist Eigenprüfung.

### Der erste Lauf: 9/9 — und drei Erträge darüber hinaus

Alle Vorhersagen der Team-Strecke hielten der Mechanik stand: Der
Doppel-Anspruch wird non-fast-forward **abgelehnt** (TA-7), die stille
Nummern-Kollision tritt exakt wie in §Vergabe gelehrt ein, das `MR`-Hybrid
verhält sich wie beschrieben (Dateien still, Index-Zeile laut), zwei offene
Wellen sind für `planning` grün, und die Sichtung liest den gemergten Stand.

1. **Die Stille braucht Abstand** (s03): Im einzeiligen Register kollidierten
   Zeilen-Änderung und Anhang **laut** — still wird die Doppel-Zählung erst
   in großen Registern, genau dort, wo auch das Wiedererkennen am teuersten
   ist. Das schärft `TB-011`, statt es zu widerlegen.
2. **Die `waves.dir`-Unvereinbarkeit ist gemessen** (s04b): zwei offene
   Wellen, `planning` grün — `waves.dir` dazugeschaltet meldet `wave-drift`.
   Der Roadmap-Faden trägt jetzt einen reproduzierbaren Befund statt einer
   Lesart.
3. **Die Branch-Protection-Reibung ist real** (s06): Ein `pre-receive`-Hook
   auf `main` lässt den TA-7-Anspruch scheitern — die Grenze, die bisher nur
   als Beispiel für „entworfen ≠ belegt" diente, ist jetzt Messwert.

### Ehrlichkeit über den Bau

Der Harness selbst brauchte drei Anläufe, und beide Werkzeug-Lehren stehen im
README: `git init --bare` ohne `-b main` ließ drei Szenarien gegen **leere
Verzeichnisse** „bestehen" — die Klasse *Prüfung, die nicht prüft*, jetzt mit
Wachsamkeits-Zeile in der Topologie; und der zweite Merge braucht eine
Git-Identität. Danach dreifach im Scratchpad abgesichert: seiteneffektfrei
(`git status` vor/nach identisch), deterministisch (zwei Läufe
zeilenidentisch), fail-closed als Kopie außerhalb des Repos — der Kopie-Test
fand den Halb-Läufer-Defekt, bevor er jemanden täuschen konnte.

### Konsequenz aus s06 — die Regel nennt jetzt ihre Wirkung

Die TA-7-Regel schrieb das **Mittel** fest (Direkt-Commit auf den Hauptzweig);
gemessen scheitert es an Branch-Protection, die reale Teams standardmäßig
fahren — die erste Team-Adoption hätte die Regel als unbefolgbar gelesen und
wäre still abgewichen. Modul 5 trägt jetzt: *Die Regel trägt die Wirkung,
nicht das Mittel* — sichtbar werden muss der Anspruch vor der Arbeit; wo der
Direkt-Commit scheitert, deklariert das Repo seinen Träger als `MR` (etwa
Claim-Ausnahme im Schutzregime oder sofort gemergter Anspruchs-PR). Still
abweichen ist keiner der beiden. Spiegel nach der Schnittregel (der
Lab-Verweis reist nicht mit — Operation 1).

**Damit ändert die Welle doch etwas am Bundle** — der eine
Modul-5-Spiegel-Absatz. Additiv; er reist mit dem nächsten Release.
`lab/team-sim/` selbst reist nicht mit (`build-bundle.sh` kopiert
`regelwerk/` und `templates/`).

## Welle 79 — 2026-08-16 · Das SOLL ist entworfen

Vierte und letzte Umsetzungs-Welle des [Team-Plans](docs/team-plan.md):
Pakete **P5** und **P6** — `TA-3` und `TA-5` aus [`docs/team.md`](docs/team.md).
Mit ihr ist die erste SOLL-Stufe der Team-Frage erreicht: **entworfen** — alle
sieben Anpassungen sind in Kurs, Regelwerk, Templates und Beispiel verkörpert.

### Entschieden

- **§Vergabe kennt jetzt seine Grenzen** (`TA-3`). `MR-<NNN>` ist als
  **Hybrid** benannt (Eintragsdatei still, Index-Zeile laut — die
  zweitgrößte Kennungs-Klasse des gemessenen Konsumenten hatte keine
  Vergabe-Regel); die **Welle** fällt aus dem Zählraum-Schema (sie bündelt
  Slices über Sub-Areas hinweg — repo-weit dicht bleibt richtig, das Risiko
  trägt die Planner-Eröffnung); und *„lokal ableitbar"* hat seine Grenze:
  Der Zählraum ist Verzeichnis **plus offene Welle-Dateien** — der gemessene
  `061`–`064`-Fall —, den PR-Rest fängt das Schema nicht, und das gehört
  gesagt. Die Schema-Frage selbst (Zähler ersetzen) bleibt ausdrücklich
  draußen; ihre Abwägung liegt in `team.md`.
- **Die Leseordnung** (`TA-5`, erste Hälfte). Die Pflichtgliederung von
  `harness/README.md` bekommt die achte Zeile — **Quelle zuerst**, sonst wäre
  die Template-Sektion selbst Template-Drift. Die Menschen-Hälfte des
  Einstiegs: drei bis fünf **geordnete** Zeiger; eine Leseordnung, die alles
  nennt, ist keine. Beispiel mit gefüllter Fassung.
- **Der Rückbau-Trigger** (`TA-5`, zweite Hälfte). Eine **neue** Hard Rule
  trägt ab Einführung einen Auflösungs-Trigger oder *permanent* — dieselbe
  Disziplin wie ADR und Carveout; dieselbe Regel für neue HIGH-Einträge des
  Reviewer-Skills. Für den Altbestand gilt kein Nachrüsten (die
  Herkunfts-Anker-Präzedenz: ein nachgetragener Trigger wäre erfunden, nicht
  rekonstruiert); deklarierter Backfill bleibt möglich.

### Die Team-Strecke in einer Bilanz

Wellen 76–79, sieben Anpassungen, zehn Befunde — **alle umgesetzt**. Was der
Korpus jetzt kann, was er vorher nicht konnte: die Person in der Rolle
benennen (Rolleninhaber), die Zuweisung tragen (`Verantwortlich:`), den
Anspruch sichtbar machen, bevor die Arbeit beginnt (Hauptzweig-`git mv`),
sagen, über welchen Stand seine Regeln sprechen (gemergter Stand), einen
Konflikt beenden statt dokumentieren (Verdikt wird ADR), auf *„Aktuelle
Welle"* verzichten (Offene Wellen, derivativ), seine Vergabe-Grenzen nennen
und einem neuen Menschen eine Reihenfolge geben.

**Erreicht ist die Stufe *entworfen*, nicht *belegt*** — die Unterscheidung
aus `team.md` §SOLL: Belegt wird erst, wenn ein Repo mit ≥ 3 Schreibern die
Baseline adoptiert und keinen der beschriebenen Ausfälle meldet. Das ist
nicht von uns herbeiführbar; der Trigger steht in der
[Roadmap](docs/roadmap.md). Der Geltungsbereich sagt es den Adoptern
(*entworfen, nicht belegt*) und bleibt, bis die zweite Stufe erreicht ist.

**Bundle-Bilanz:** Fünf Spiegel, ein Template, die Beispiel-Kette. Additive
Regeln → **MINOR**, wenn released wird — die Wellen 76–79 zusammen sind ein
natürlicher Release-Schnitt.

## Welle 78 — 2026-08-16 · Befördert wird niemand

Dritte Umsetzungs-Welle des [Team-Plans](docs/team-plan.md): Paket **P3**, die
`TA-2`-Restzeile — *„Aktuelle Welle" entfällt*. Der Abschnitt war keine
Eigenschaft des Repos, sondern eine Aussage über die Aufmerksamkeit **einer**
Person (`TB-014`): Bei mehreren Menschen gibt es keine oder mehrere laufende
Wellen, und der leere Fall war beim Konsumenten belegt — ein 23-Zeilen-Block
für *„Keine aktive Welle"*. Zugleich war er eine Kopie der Wellen-Plan-Datei,
deren Drift dieselbe Roadmap an anderer Stelle als real dokumentiert.

### Entschieden

- **Offene Wellen, derivativ.** Der Ersatz-Abschnitt zeigt, statt zu führen:
  Der Zustand sind die **flachen Welle-Dateien**; woran gerade gearbeitet
  wird, sagt das `Welle:`-Feld der Slices in `in-progress/` (aus Welle 77);
  Ziel, Trigger und Closure-Kriterien stehen in der Welle-Datei, nicht hier.
  Ist nichts beansprucht, trägt der Abschnitt den Ruhe-Marker *„Nichts in
  Arbeit"* — die eine deklarierte Redundanz, und sie hat einen **Wächter**.
- **Befördert wird niemand.** Closure-Schritt 5 verliert seine zweite Hälfte
  (*„die erste Zeile aus Nächste Wellen wird zur neuen Aktuellen Welle"*) —
  die Beförderung setzte genau einen Fokus voraus. Die Rollen-Tabelle in
  Modul 8 zieht nach.
- **Die Präzedenz-Tabelle zieht nach** (Review-Fund nach dem Umbau): Rang 5
  hieß an vier Orten noch *„aktuelle Welle"*, jetzt *„Wellen-Sequenz"* — was
  die Roadmap tatsächlich noch trägt.

### Der kritische Fund: der Sensor las die alte Überschrift

d-checks `planning`-Modul prüft den Ruhe-Marker **im Block `## Aktuelle
Welle`** — der Umbau hätte den CI-Job `example-verify` gebrochen. `heading`
und `marker` sind konfigurierbar; das Beispiel überschreibt beide
(`.d-check.yml`), mit dem Vermerk, dass der Werkzeug-Default nachziehen
könnte — ein CR-Kandidat, kein stiller Bruch.

**Break-Tests statt grünem Vertrauen:** Falsche Überschrift →
`planning-drift` (fail-closed); Ruhe-Marker trotz laufendem `slice-013` →
`planning-drift`. Beide beißen auf die neue Konfiguration — und belegen
nebenbei, dass die Overrides gelesen werden, nicht still ignoriert.

### Bauform und Beleg

Kette: Modul 6 (sechs Stellen, samt Beispiel-Block des Worked Example) ·
Modul 8 · Modul 1 · Verzeichniskonvention → drei Spiegel (Probe A auf allen
geänderten Passagen: 5/5) → `roadmap.template.md` (Sektion ersetzt) ·
`README.template.md` · `AGENTS.template.md` → Beispiel (Roadmap, Wellen-Datei,
`.d-check.yml`, Sensors-Zeile, `AGENTS`/`harness`-Kette). Die
Lab-Grenze-Notiz ging nicht verloren — sie stand schon in der Wellen-Datei;
die Roadmap-Kopie entfällt ersatzlos.

Restsuche inklusive Deklinationen: **0 Treffer** außer dem dokumentierten
Werkzeug-Default in der Sensors-Zeile.

**Bundle-Bilanz:** Spiegel, Templates und die Beispiel-Kette reisen. Ein
Template-**Abschnitt** entfällt zugunsten einer derivativen Form — nach der
im [Plan](docs/team-plan.md) abgeleiteten Entscheidung **MINOR**: Die
MAJOR-Politik bindet an Asset-Entfernung und Layout-Bruch der Datei-Ebene;
den Widerspruchsfall beim Adopter behandelt der Freshness-Audit-Ausgang 5
per `MR`.

## Welle 77 — 2026-08-16 · Der Anspruch wird sichtbar, bevor die Arbeit beginnt

Zweite Umsetzungs-Welle des [Team-Plans](docs/team-plan.md): Pakete **P2** und
**P4** — `TA-2` (ohne die P3-Zeile), `TA-7` und `TA-4` aus
[`docs/team.md`](docs/team.md). Welle 76 gab der Person in der Rolle ein Wort;
diese Welle gibt der **Zuweisung einen Ort** und dem **Zustand einen
Geltungs-Stand**.

### Entschieden

- **Die Zuweisung hat einen Ort** (`TA-2`). `open → next` setzt den
  Verantwortlichen: Das Feld `Verantwortlich:` im Slice-Kopf trägt den
  Rolleninhaber der Implementer-Rolle, der die Arbeit hält — `—` bis zur
  Priorisierung. Der **Autor** bleibt getrennt (er schrieb den Plan), und das
  Feld ist **kein Statuswert**: Der Zustand bleibt das Verzeichnis, das Feld
  sagt *wer*, nicht *wo*. Kein Sensor prüft es — als Deklaration
  ausgesprochen, statt ein Gate zu behaupten. Die Welle hatte das Feld schon
  (`welle.template.md`); jetzt hat es der Slice, das Artefakt, das den
  Lifecycle trägt.
- **Der Übergang landet auf dem Hauptzweig, vor der Arbeit** (`TA-7`). Reist
  der `git mv` erst im PR mit, ist der Zustand **zweigelokal** —
  `in-progress/` ist für alle anderen leer, bis die Arbeit fertig ist; das
  Verzeichnis, das laufende Arbeit benennt, wäre genau für laufende Arbeit
  unzuverlässig. Der Übergangs-Commit macht den Anspruch sichtbar, **bevor**
  jemand anderes dieselbe Arbeit beginnt. Dazu die Abgrenzung in §Vergabe,
  damit kein Scheinwiderspruch entsteht: Das *Ableiten* einer Kennung braucht
  keinen Hauptzweig-Zugriff, das *Beanspruchen* einer Arbeit landet dort.
- **Der Stand wird gesagt** (`TA-4`). *Aussagen über die Verzeichnis-Position
  gelten für den gemergten Stand* (Modul 5); die `ls`-Zusage in Modul 6 ist
  entsprechend qualifiziert, und der Sichtungs-Schritt benennt, dass das
  Beobachtungs-Register beim Lesen so alt ist wie der letzte Merge.
- **`TB-012` schließt nebenbei.** Die Lifecycle-Tabelle der Planning-README
  (Vorlage und Beispiel) sagt jetzt, was gelehrt wird: `next/` mit dem Feld,
  `in-progress/` = *„Beansprucht: Der `git mv` liegt auf dem Hauptzweig, vor
  der Arbeit — Branch/PR entsteht danach."* Die quellenlose Formulierung
  *„Branch / PR existiert"* existiert nirgends mehr.

### Bauform und Beleg

Additiv bis auf die zwei Template-Zeilen, die von quellenlos auf gelehrt
wechseln. Kette vollständig: Quelle (Modul 5, 6, 9, §Vergabe) → vier Spiegel
(Schnittregel, per Teilfolgen-Probe verifiziert) → zwei Templates →
Beispiel-README; Vollständigkeit per grep über alle drei Konstrukte belegt.

Der Review vor dem Commit fand zwei Dinge — beide in `team.md`, nicht in der
Umsetzung: ein Umstellungs-Zitat aus einer eigenen früheren Korrektur, und
den strukturellen Effekt, dass **umgesetzte Befunde jetzt Text zitieren, den
es nicht mehr gibt**. Die Zitate sind der Zustand *davor* und bleiben; die
Abschnitte sagen es jetzt (*„Was dastand — behoben in Welle NN"*).

**Bundle-Bilanz:** Vier Spiegel-Dateien, zwei Templates und die
`README`-Kette reisen im Bundle. Neue Regeln plus zwei begründete
Zeilen-Wechsel → **MINOR**, wenn released wird.

## Welle 76 — 2026-08-16 · Ein Wort für die Gegenrichtung

Erste Umsetzungs-Welle des [Team-Plans](docs/team-plan.md): Pakete **P0** und
**P1** — die Anpassungen `TA-1` und `TA-6` aus [`docs/team.md`](docs/team.md).
Der Korpus modellierte Rollen und Personen nur in einer Richtung: *eine Person,
mehrere Rollen*. Für die Gegenrichtung — eine Rolle, mehrere Menschen — fehlte
das Wort, und Regeln der Form *„die Rolle X tut Y"* zerfielen in zwei Lesarten.

### Entschieden

- **Der Rolleninhaber** (`TA-1`). *Wer eine Rolle in einem konkreten Lauf
  füllt, ist ihr Rolleninhaber* (Modul 8). Der Begriff steht **neben** der
  Kontext-Trennung, nicht gegen sie — die Rolle bleibt personen-ungebunden.
  Damit werden drei Regeln eindeutig: das WIP-Limit (Modul 5 — *pro
  Rolleninhaber = 1, pro Mensch in der Implementer-Rolle, nicht pro Rolle*),
  die Reviewer-Drift (Modul 10 — *zwischen Sessions und zwischen
  Rolleninhabern*; Abweichung zwischen Inhabern ist **Dissens**, kein
  Nicht-Determinismus, geschärft wird der Skill, nicht die mildere Lesart
  gewählt) und das Architect-Verdikt (Modul 8 — es nennt seinen Inhaber,
  *„der Architect" ist sonst eine Adresse, die zwei Antworten geben kann*).
- **Das Konflikt-Terminal** (`TA-6`). Der Konflikt-Pfad verbot die
  Entscheidung nach Seniorität, benannte aber kein **letztes** Artefakt —
  zwischen Menschen dokumentiert ein Artefakt die Uneinigkeit, es beendet sie
  nicht. Jetzt: Wird keines der drei Verdikte akzeptiert, nimmt der Architect
  sein Verdikt **als ADR** an. Der Vorgang endet nicht, weil jemand recht
  bekommt, sondern weil die Entscheidung immutabel wird; Widerspruch geht den
  Folge-ADR-Weg und braucht **neue Evidenz statt Wiederholung**. Das
  Senioritäts-Verbot bleibt unberührt — verboten ist Seniorität als
  *Argument*. Dazu Modul 4: Eine ADR entsteht nicht nur aus
  Architektur-Fragen.
- **Der Geltungsbereich** (P0). Erstmals deklariert, an beiden Enden:
  `kurs/de/README.md` §Zielgruppe und — weil der Adopter das Bundle liest,
  nicht den Kurs — als Zeile in `lab/regelwerk/README.md`. *Getestet und
  gelebt mit einem schreibenden Menschen plus Agenten je Repository; die
  Mehr-Schreiber-Fassung ist entworfen, nicht belegt.*

### Bauform und Beleg

Alle Änderungen sind **additiv** — kein bestehender Satz wurde entfernt, der
Ein-Personen-Fall bleibt unverändert gültig. Kette vollständig gelaufen:
Quelle → Spiegel (Schnittregel, Deixis auf Spiegel-Anker) → Lösungen;
Templates bewusst unberührt (Plan P1). Vollständigkeit gemessen statt
behauptet: `Rolleninhaber` steht in sieben Dateien der Kette, das Terminal in
Quelle, Lösung und Spiegel.

Eine Korrektur am eigenen Entwurf noch vor dem Commit: Der P0-Absatz
behauptete zunächst *„Rolleninhaber und Zuweisung"* — die Zuweisung landet
erst mit P2. Ein Geltungsbereichs-Absatz, der Konstrukte nennt, die es noch
nicht gibt, wäre selbst die Klasse Harness-Lüge gewesen.

**Bundle-Bilanz:** Die drei geänderten Spiegel-Module, der Modul-4-Spiegel und
die `README`-Zeile reisen im Bundle. Additive Regeln → **MINOR**, wenn
released wird.

## Welle 75 — 2026-08-16 · Der Spiegel formuliert nicht

Zwei Fäden, ein Auslöser. Die Frage *„das Regelwerk trägt bei einem Schreiber —
was bricht bei dreien?"* wurde als Bestandsaufnahme geführt und landete in
[`docs/team.md`](docs/team.md). Beim Review dieser Datei wurden ihre **60
Zitate** wortweise gegen `kurs/de` geprüft — und drei der Abweichungen lagen
nicht in der Datei, sondern **im Regelwerk-Spiegel**: `lab/regelwerk` zitierte
an diesen Stellen etwas, das die Quelle so nie gesagt hat. Aus dem ersten Faden
wurde ein Register mit Anpassungs-Entwürfen, aus dem zweiten eine Regel, zehn
Korrekturen und eine Messung.

### Faden 1 — Team-Tauglichkeit: IST deklariert, sieben Anpassungen entworfen

[`docs/team.md`](docs/team.md) hält fest, was vorher nirgends stand: **IST ist
ein schreibender Mensch plus Agenten** — und das ist nicht deklariert; ein
Adopter mit drei Leuten erfährt an keiner Stelle, dass er außerhalb des
Getesteten arbeitet. **SOLL ist Teamfähigkeit, zweistufig**: *entworfen* (an
uns) gegen *belegt* (braucht ein adoptierendes Team, nicht herbeiführbar).

- **14 Befunde** (`TB-001`–`TB-014`), davon vier begründet gestrichen oder
  abgelöst — die Streichungen bleiben mit Grund stehen, nach dem Muster des
  Beobachtungs-Registers. Ordnendes Prinzip: drei Achsen — *Rolle* ist im
  Korpus voll ausgearbeitet, *Person* kommt nur als „eine Person, mehrere
  Rollen" vor (die Gegenrichtung nirgends), *Zuweisung* hat kein Wort.
- **Sieben Anpassungen** (`TA-1`–`TA-7`) mit Entwurfsteil — je *wo es landet*,
  Preis und Grenze. Die zehn offenen Befunde fallen ohne Rest auf sie. Kern:
  ein Wort für den **Rolleninhaber**, ein `Verantwortlich:`-Feld im Slice-Kopf
  (die Welle hat es schon), der Lifecycle-`git mv` landet **vor** der Arbeit
  auf dem Hauptzweig, und der Konflikt-Pfad bekommt ein Terminal — das
  bestrittene Verdikt wird ADR.
- **Am Konsumenten gemessen statt hergeleitet**: `git shortlog` über die vier
  Baseline-Repos (je eine Autoren-Identität — alle Verhaltens-Befunde stehen
  bei 0× und sind als Vorhersagen deklariert); in `ai-harness-init` die
  Slice-Lücke `061`–`064` (im Wellen-Plan vergeben, als Datei nie entstanden —
  widerlegt „lokal ableitbar"), `MR` als mit 24 Einträgen zweitgrößte
  Kennungs-Klasse ohne Vergabe-Regel, und ADR-0015 als unabhängiger Beleg der
  fehlenden Eigentums-Achse.
- Die tragendste Einzeleinsicht: ***„Aktuelle Welle" ist keine Eigenschaft des
  Repos*** — sie beschreibt die Aufmerksamkeit *einer* Person; bei mehreren
  gibt es keine oder mehrere. Der leere Fall ist beim Konsumenten belegt (ein
  23-Zeilen-Abschnitt für „Keine aktive Welle"). Die Auflösung liegt im Repo:
  flache Wellen-Dateien plus das `Welle:`-Feld in `in-progress/`.

Alles davon ist **Entwurf, nicht Verkörperung** — 0×-Befunde lösen nach der
Zählregel keine Regeländerung aus; die Roadmap trägt den Faden mit dem
Trigger der zweiten SOLL-Stufe.

### Faden 2 — die Schnittregel und zehn behobene Paraphrasen

`lab/README.md` versprach *„wortgleich zur Quelle"*. Der Spiegel trägt je nach
Datei **32–62 %** seiner Quelle — die Zusage war nicht unerfüllt, sondern
falsch: Didaktik entfällt, Verweise werden umgehängt. Was dabei erlaubt ist,
stand nirgends; die Review-Runden 7–11 (99 Spiegel-Erwähnungen) korrigierten
Einzelfälle ohne Maßstab.

**Entschieden:** [`docs/regelwerk-extrakt.md`](docs/regelwerk-extrakt.md)
trägt die Regel, `lab/README.md` verweist statt zu behaupten. Erste Fassung
als Verbotsliste — **an sechs realen Formen gescheitert**, jedes Mal war das
Spiegel-Ergebnis richtig und die Regel dagegen. Deshalb positiv neu gefasst:

> **Der Spiegel formuliert nicht.** Er wählt aus, setzt zusammen, bindet an
> und benennt.

Fünf Operationen (Weglassen ganzer Einheiten · Zusammensetzen wörtlicher
Fragmente · Anbinden von Verweisen und Pronomen · Benennen · Frage→Aussage),
abschließend gemeint, nicht abschließend bewiesen — die Beweislast dreht sich:
Unvorhergesehenes ist ein Befund, bis die Liste erweitert wird. Dazu zwei
Proben: **Teilfolge** (fängt Ersetzung und Umstellung) und **Wortdeckung**
(fängt Zusätze); keine fängt den gestrichenen Teilsatz, der eine Bedingung
trug — das bleibt ein Urteil je Streichung.

**Zehn Paraphrasen behoben**, in sieben Spiegel-Dateien, jede gegen die Quelle
gegengeprüft. Die markantesten: der gestrichene Qualifikator *„nach der
dritten Welle"* (`grundlagen-harness-dateien`); die zu Prosa umgeschriebene
Übungstabelle in `modul-06` — sie ist als **Tabelle wortgleich zurück**, die
Prosa hatte aus *„fehlende Latenz"* still *„fehlenden Beleg"* gemacht; und
`modul-12`, kein Paraphrase- sondern ein **Verfasser-Fall**: vier Aussagen
ohne jede Quell-Entsprechung, entfernt statt umformuliert — ein Spiegel darf
nichts sagen, was seine Quelle nicht sagt.

**Gemessen, nicht nur behoben:** Der Kandidaten-Durchgang (14 fettgesetzte
Vorspänne: 3 Falsch-Positive · 5 zulässig · 6 Befunde) und ein
Wortdeckungs-Prototyp über alle 26 Dateien: **63 Kandidaten-Absätze** tragen
Wörter, die ihre Quelle nicht kennt — eine **Altbestands-Schicht** im
Digest-Stil von vor der Quelltreue-Disziplin, vorn `modul-12` (9) und
`modul-13` (8). Als eigenes Vorhaben eingeordnet; der dauerhafte Sensor wäre
ein Change Request an den Doku-Prüfer und ergibt erst danach Sinn — vorher
liefe er dauerhaft rot. Der Prototyp bleibt bewusst kein Repo-Skript
(Skriptflächen-Regel).

### Bundle-Bilanz

Von der Welle reisen **die sieben korrigierten Spiegel-Dateien** im Bundle;
`docs/team.md`, `docs/regelwerk-extrakt.md` und die Roadmap-Fäden sind
Kurs-Repo-Artefakte und reisen nicht. Am ausgelieferten Artefakt sind es
Treue-Korrekturen ohne Regel-Änderung — nach dem v5.3.1-Präzedenzfall
**PATCH**, wenn released wird. Die Release-Stichprobe sollte die
`modul-06`-Tabelle (mit `slice-019`) und den Qualifikator *„nach der dritten
Welle"* prüfen.

## Welle 74 — 2026-08-15 · Zwei Wellen lang ein Vorschlag

Welle 72 verdrahtete vier d-check-Module im Beispiel-Repo, Welle 73 kam die
Closure-Fähigkeit dazu und mit ADR-0019 ein Vorführ-Gegenstand daneben. Beim
Review der Verdrahtung fiel auf, was keiner der Läufe zeigen kann: **Nichts
davon lief je in CI.** `checks.yml` fährt `docs-check`, `alignment-check` und
`adr-immutability` — `make -C lab/example verify` steht in keinem Workflow.

Die Datei trägt den Satz, den das verletzt, im **eigenen Kopf**: *„Ein Gate, das
nur lokal läuft, ist ein Vorschlag (Modul 13)."*

### Entschieden

- **Ein Job, ein `make`-Aufruf.** `example-verify` ruft
  `make -C lab/example verify` — dieselbe Zeile wie lokal. Der Lauf ist
  hermetisch (Prüfer im Container, digest-gepinnt, `--network none`), also
  braucht es keine Workflow-Nachbildung; und eine Nachbildung prüfte ohnehin
  nicht das, was lokal läuft. Dieselbe Begründung, aus der der Bundle-Bau in
  `tools/build-bundle.sh` liegt statt im Workflow.
- **`make -C` gegengeprüft, nicht angenommen.** Der Prüfer mountet `$(CURDIR)`;
  aus der Wurzel aufgerufen zeigt das auf `lab/example`. Gemessen: beide
  Sensoren melden dieselben Zahlen wie beim Aufruf aus dem Verzeichnis.
- **Der Preis steht im Faden, nicht im Kleingedruckten.** `main` färbt sich
  künftig rot, sobald das Beispiel driftet. Das ist der Zweck — aber es ist eine
  Setzung über den Merge-Pfad und war deshalb eine Entscheidung, keine
  Aufräumarbeit.

### Was der Job abdeckt

`matrix` (Referenz-Richtung), `targets` (kein behauptetes Gate ohne Regel, keine
Regel ohne Doku), `planning` inklusive `closure` (Lifecycle-Invariante und die
vier Bedingungen aus ADR-0011), `ids` (ADR-Kennungen sind Links) — dazu
`check_closure_notes.py`, das seit ADR-0019 die Lehre trägt und nicht mehr die
Deckung, aber lauffähig bleiben muss, weil ein Worked Example mit totem
Gegenstand keines ist.

### Der erste Lauf fand sofort etwas — an uns

Der Job war grün, und das Log zeigte trotzdem einen Unterschied: **CI meldete 73
geprüfte Dateien, lokal waren es 74.** Ein grüner Job, der eine andere Menge
sieht als der lokale Lauf, ist nicht dasselbe Gate — und die Differenz fällt nur
auf, wenn man die Zahlen liest statt der Farbe.

Ursache: `python/.pytest_cache/README.md`. Die `scan.ignore` des Beispiels führte
`build`, `build-cov`, `target` und `.gradle`, aber keine der Python-Caches. Lokal
scannte der Prüfer die Datei mit, in CI existiert sie nicht — dort gibt es nur
den Checkout.

**Und es blieb nicht bei einem Sensor.** Dieselbe Frage eine Ebene höher
gestellt, mit demselben Verfahren — CI-Log gegen lokalen Lauf:

| Sensor | CI | lokal | Differenz |
|---|---|---|---|
| `d-check`, Beispiel | 73 | 74 | `.pytest_cache/README.md` |
| `d-check`, Wurzel | 198 | 199 | dieselbe Datei |
| `docs-check.js`, Wurzel | 176 | **200** | 23 × `cpp/build-cov/**` + dieselbe Datei |

Der Node-Rest-Sensor war der schlimmste Fall: Seine `SKIP_DIRS` kannte `build`,
aber nicht `build-cov` — er las lokal die 23 vendorierten Markdown-Dateien von
doctest mit. **Ein Viertel seines lokalen Korpus war Fremdmaterial**, das in CI
nie auftaucht.

Heute war alles harmlos (0 Befunde überall), aber die Bauform ist es nicht: Ein
Treffer in einem Werkzeug-Cache oder in vendoriertem Fremdcode hätte lokal rot
und in CI grün gemeldet — und Modul 14 verlangt ausdrücklich, dass beide Läufe
identisch sind.

Behoben an allen drei Stellen; danach 73 = 73, 198 = 198, 176 = 176. Die
Gegenprobe, die auch künftig trägt, steht als Kommentar an jeder der drei
Listen: Weichen die Dateizahlen ab, die CI-Sicht mit `git archive HEAD`
nachstellen und dagegen laufen lassen.

**`.gitignore` musste dafür nicht angefasst werden** — die Pfade sind dort längst
abgedeckt, und genau deshalb sieht CI sie nicht. Die Duplizierung bleibt: d-check
interpretiert `.gitignore` nicht, und `docs-check.js` führt seine eigene Liste.
Drei Listen für dieselbe Aussage, von Hand parallel zu halten; kein Sensor prüft
ihre Gleichheit. Der Symptom-Test dafür ist die Dateizahl, und der steht jetzt
überall dabei.

Das ist der Ertrag des Jobs am ersten Tag — nicht ein gefundener Doku-Fehler,
sondern der Nachweis, dass Läufe, die man für identisch hielt, es an drei
Stellen nicht waren.

**Am Bundle ändert die Welle nichts** — ein Workflow reist nicht mit. Kein
Versions-Bump.

## Welle 73 — 2026-08-10 · Zwei Kopien, zwei Antworten

Welle 72 schloss mit einem Konsumenten-Befund: `ai-harness-init` las Modul 8
falsch, und die Ursache lag nicht im Kurs, sondern im **Spiegel** — dort war
der Satz verdünnt, der die Achse trägt. Vier Stellen wiederhergestellt, Release
raus. Offen blieb die Frage dahinter: **War das systematisch?**

Diese Welle beantwortet sie — und trifft dabei auf denselben Fehlermodus in
einer zweiten Bauform. Beide Male steht eine Aussage an einem Ort, dessen
Wahrheit woanders wohnt: Der Regelwerks-Spiegel kopiert den Kurs, eine ADR
kopierte Fakten über ein Fremdwerkzeug. Die Antworten fallen entgegengesetzt
aus — die eine Kopie ist unvermeidlich, die andere nicht.

### Antwort eins: systematisch nein — vier Stellen aber doch

Alle **26 Dateipaare** Kurs ↔ Spiegel, satzweise geprüft. Maßstab war die
Regel, die der Spiegel sich selbst gibt: Didaktik darf weg, Operatives nur
quelltreu. Vier Defekte, alle behoben, kein neuer Satz:

1. **`modul-06`** — die Taxonomie eines Steering-Loop-Eintrags fehlte:
   *„(geschärfte Regel / neuer Sensor / benannte Spec-Lücke)"*. Das ist die
   Angabe, an der ein Leser erkennt, *was* er eintragen soll — operativ, nicht
   didaktisch.
2. **`grundlagen-traceability`** — Paraphrase ohne Bedeutungsverlust:
   *„es gewöhnliche Wörter"* statt *„dieselben zwei Wörter gewöhnliche
   Sprache"*, *„Trigger-Sprachgebrauch"* statt *„Trigger-Formulierung"*. Heute
   harmlos; genau diese Umformulierungen verlieren beim nächsten Mal ein Wort
   zu viel — der Modul-8-Defekt war eine Generation weiter.
3. **`modul-13`** — der Spiegel behauptete *„Die Übersetzung in **fünf**
   Schritten"*, die Quelle nummeriert **sechs**. Weggelassen ist der
   sprachkonkrete Implementierungs-Schritt, zu Recht — falsch war die Zahl.
   Jetzt ohne Zahl, mit benannter Auslassung.
4. **`modul-06`** — Fettung verloren bei erhaltenem Satz: *„**Ohne diesen
   Lese-Schritt ist das Register write-only**"*. Der Satz stand da, seine
   Betonung nicht.

Nicht behoben, weil legitim: umgehängte Link-Texte, angepasste
Überschriften-Ebenen, generalisierte Kennungen, weggelassene
Fehlvorstellungs-Zitate, Fallstudien, Übungen und Verweise auf nicht
mitreisendes Material.

### Was die Methode über sich selbst ergab

Der erste Durchlauf meldete **666 Abweichungen**. Als Defektzahl wertlos — zur
Kalibrierung eine Datei bekannter Treue gegengelesen: dort waren **alle neun**
Abweichungen legitim. Erst die Umstellung auf die *Defekt-Signatur* — der
Spiegel sagt **weniger** — und das Filtern der Didaktik-Muster gab Signal:
10 Kandidaten, davon 8 legitim, **2 echte Defekte**.

Die anderen beiden Defekte fand keine der Satz-Prüfungen, sondern zwei
Stichproben — und die Stichproben zeigten dabei, wo die Grenze liegt:

- **Zahlwörter** („fünf" vs. „sechs" beim selben Substantiv) fand Defekt 3. Der
  Satz ist eine bewusste Verdichtung und lag unter jeder Ähnlichkeitsschwelle;
  der Satz-Vergleich konnte ihn nicht sehen. Case-sensitiv gezählt erzeugte
  dieselbe Probe drei Falsch-Positive.
- **Fettungs-Vergleich über die ganze Datei**: 136 Fälle, ausnahmslos Rauschen
  — ein Begriff wird bei seiner Definition gefettet und danach normal genannt,
  und der Definitionssatz fehlt im Spiegel zu Recht. Erst der Vergleich am
  **erhaltenen** Satz gibt Signal: genau ein Treffer, Defekt 4.

**Kein Gate daraus.** Die Trennung legitim/Paraphrase steckt in Filtern nach
Augenschein; ein Sensor mit dieser Trefferquote wäre ein Vorschlag, kein Gate.
Was bleibt, ist die Methode, nicht das Skript.

### Antwort zwei: a-check meldet seine Blindheit jetzt selbst

Welle 72 endete mit vier Befunden an a-check, „allen voran eine Laufzeit-Diagnose
der eigenen Heuristik-Grenze". Aus vieren wurden sechs; **v0.17.0 setzt sie
praktisch alle um**. Der Pin steht auf
`ghcr.io/pt9912/a-check@sha256:665540114aea…` in allen sechs Skeletten.

Die zwei neuen Diagnosen beantworten genau die Frage, die im Rollout sechsmal
von Hand gestellt wurde:

| Diagnose | Aussage |
|---|---|
| Grenz-Hinweis | *„N Import-Zeile(n) unterliegen einer Heuristik-Grenze"* — mit Datei, Zeile, Grund |
| Auflösungs-Hinweis | *„Schicht X: N Datei(en), 0 von M Import-Symbolen lösen auf eine Schicht auf"* |

Gegen die sechs Konfigurationen gelaufen: **alle sechs schweigen**. Damit ist
zum ersten Mal *belegt* statt angenommen, dass keine der Deklarationen still
blind ist. Dass das Schweigen etwas bedeutet, ist nachgestellt: Ein
Komma-Import in Python meldet den Grenz-Hinweis punktgenau, und der Mono-Scan
mit sprach-präfixierten Globs — der Fall, der ganz am Anfang vollständig grün
und vollständig blind war — meldet jetzt *„0 von 14 Import-Symbolen lösen auf"*.
Damit ist **Schritt 0 vom Handgriff zur Werkzeug-Eigenschaft** geworden: Was
die Diagnose meldet, muss niemand mehr durch einen eingebauten Verstoß suchen.

Zwei der Änderungen sind BREAKING, beide zu unseren Gunsten:

- **`--print-mk` gibt einen Platzhalter statt eines Digests aus.** Genau der
  Fehlpin, der hier v0.15.0 statt v0.16.0 kostete, ist damit unmöglich: Der
  Platzhalter bricht laut, statt gültig auszusehen und falsch zu sein.
- **`forbidden_constructs` bricht fail-closed**, wenn die Schicht keine
  `port`-Rolle trägt, statt still wirkungslos zu bleiben.

Dazu `$(DOCKER)` im generierten Fragment — verifiziert mit
`make a-check DOCKER=podman`.

### Antwort zwei, Teil zwei: die Grenze zieht dorthin, wo sie gelesen wird

Und damit zur zweiten Kopie. Die ADR-Kette des a-check-Rollouts wurde an zwei
Tagen **viermal** abgelöst, die letzten beiden Male aus demselben Grund: Eine
Tabelle im Entscheidungs-Körper führte **Fakten über ein Fremdwerkzeug** —
welche Schreibweise welcher Sensor sieht. Solche Fakten ändern sich mit jedem
Release, und weil eine `Accepted`-ADR immutabel ist, erzwingt jede Änderung
eine Nachfolge-ADR samt Umhängen aller Verweise.

v0.17.0 hätte die vierte Ablösung in zwei Tagen ausgelöst: Die dort notierte
Grenze *„das generierte Fragment ruft `docker` wörtlich auf"* ist behoben —
upstream, an der Stelle, die die ADR selbst benannt hatte.

Das Problem ist nicht die Kette, sondern der **Ort**. Eine Grenze wird
gebraucht, wenn jemand die Konfiguration liest oder ändert, nicht wenn jemand
die Entscheidung nachvollzieht. `ADR-0018` trägt die Entscheidung der
Vorgängerin vollständig weiter — mit **derselben Nummerierung**, die Lehre aus
dem vorigen Supersede — und ergänzt Punkt 7: Jede `<sprache>/.a-check.yml`
trägt einen `GRENZE`-Block. Welche Schreibweise dieses Skelett umgehen könnte,
ob der Bestandssensor sie sieht, was daraus folgt. Die ADR führt **kein
Inventar mehr**; sie entscheidet, *dass* deklariert wird. Ein Werkzeug-Release
ändert damit Kommentare, keine ADR.

Drei Skelette trugen ihre Grenze bisher nur als Prosa (cpp, csharp, go) — jetzt
alle sechs als benannter Block, damit die ADR-Aussage auch stimmt.

Der Preis steht als Contra in der ADR: Es gibt keinen Ort mehr, an dem alle
sechs Grenzen nebeneinander stehen, und keinen Sensor, der sie gegeneinander
hält. Der Re-Evaluierungs-Trigger benennt genau das — und verlangt für einen
gemeinsamen Ort dann einen Sensor, nicht wieder eine Tabelle.

### Am Konsumenten abgelesen: die Adresse einer Adaption

Anders als der Modul-8-Befund oben ist das **keine** Meldung eines Konsumenten,
sondern eine Beobachtung an seinem Artefakt: `d-check` trägt in seinem
Adaptions-Index `<a id>`-Anker, die der Kurs nirgends verlangt. Frage war, ob
sie in die Vorlage gehören. Sie gehören — und der Grund ist stärker als
Kosmetik.

Der Kurs schreibt für `harness/conventions.md` die Verzeichnis-Form vor: Index
hier, ein `MR` je Datei, und bei Auflösung wandert die Datei per `git mv` nach
`conventions/done/`. Damit **bricht ein Pfad-Link auf eine Adaption genau in
dem Moment, in dem die Adaption sich auflöst** — die Referenz stirbt am
Erfolgsfall. Die Index-Zeile dagegen wechselt nur von einer Tabelle in die
andere, innerhalb derselben Datei. Trägt sie einen expliziten Anker, überlebt
die Adresse den Übergang.

Es ist wortgleich das Argument, mit dem der Kurs die Slice-ID als Token statt
als Pfad führt. Ausgeschrieben war es für Adaptionen nicht — und deshalb fehlte
in der Vorlage die Stelle, an der die Adresse entsteht.

Am realen Konsumenten gemessen statt hergeleitet: `d-check` hat **265**
eingehende `conventions.md#mr-…`-Links, und `AGENTS.md` verweist dort auf
`MR-022`, dessen Datei längst in `conventions/done/` liegt. Der Link hält,
weil der Anker mitgewandert ist. Derselbe Verweis als Pfad wäre tot.

Encodiert von der Quelle abwärts, nicht als Template-Drift:

- **Kurs** ([`grundlagen/harness-dateien.md`](kurs/de/grundlagen/harness-dateien.md)) —
  von außen wird der Index adressiert, nicht die Eintrags-Datei; der Anker
  trägt die **Kennung, nie den Titel** (ein Titel-Slug bricht bei der ersten
  Umformulierung und wäre genau die instabile Adresse, die er ersetzen soll);
  und wer von der Inline- in die Verzeichnis-Form wandert, behält den alten
  Überschriften-Slug **zusätzlich**, sonst rotten die schon veröffentlichten
  Verweise.
- **Kurs** ([`grundlagen/source-precedence.md`](kurs/de/grundlagen/source-precedence.md)) —
  dieselbe Stelle sagte bisher, Kennungen in Tabellenzellen hätten „keinen
  eigenen HTML-Anker". Wahr über den *automatischen*, und als unbedingter Satz
  hätte er der neuen Regel widersprochen. Jetzt qualifiziert, mit der
  Abgrenzung: Für die Spec-Straten lohnt es nicht — dort wandert nichts.
- **Regelwerk**, beide Spiegel quelltreu; **Vorlagen**, `conventions.template.md`
  (beide Tabellen) und `MR-NNN-titel.template.md` (Feld *Löst auf*).
- **Worked Example** — und dort lag der Defekt, den die Regel voraussagt:
  `done/MR-001` verwies per Pfad auf `MR-003`, das noch aktiv ist. Wäre `MR-003`
  aufgelöst worden, wäre der Verweis gebrochen. Jetzt Index-Anker, wie gelehrt.

**Ein Gate steht dahinter, und es ist gemessen.** Der `anchors`-Sensor deckt
Inline-HTML-Anker mit ab; der Break-Test meldet den verfälschten Anker
punktgenau als `anchor-missing`. Kein neues Skript, kein neues Modul.

### Derselbe Faden, eine Frage weiter: der Ausgang, der die Wahl verschluckte

Die Anschlussfrage lautete: Was passiert mit einer bestehenden `MR`, wenn die
neue Baseline ihr **widerspricht** — und man die neue Regel eigentlich
übernehmen will? Der Freshness-Audit (Modul 2) führt dafür fünf Ausgänge, und
sie sind ausdrücklich als Klassifikation des *Deltas* eingeführt. Bei vieren
folgt die Auflösung aus dem Delta. Beim fünften nicht: Dort sprang der Text
direkt zu *„dann gilt sie in ihrem Geltungsbereich weiter"* — als hätte das
Repo keine Wahl. Genau die hat es aber, und die Frage war der Beleg, dass der
Abschnitt sie nicht beantwortet.

Ausgang 5 nennt jetzt beide Zweige und die Abgrenzung dazwischen:

- **Abweichung behalten** → der Widerspruch gehört benannt, sonst adoptiert das
  Repo eine Regel, die es nicht befolgt (das stand schon da).
- **Neue Regel übernehmen** → Rückbau wie bei *gegenstandslos*, aber aus dem
  umgekehrten Grund: Dort hat die Baseline dem Repo recht gegeben, hier gibt
  das Repo der Baseline recht. Der Unterschied gehört in die `Begründung` des
  Nachfolge-Eintrags, weil er eine **Entscheidung** ist und kein Befund.
- **Übernehmen wollen, aber noch nicht können** → keine `MR`. Eine Adaption
  sagt *„diese Regel gilt hier nicht"*, ein Carveout sagt *„sie gilt, wir
  erfüllen sie noch nicht"* — befristet, mit Trigger und Folge-Slice. Für den
  Teilfall *Lockerung trifft verschärfte Baseline* stand das zwei Sätze weiter
  schon; jetzt steht die Regel dahinter.

Nebenbefund am Worked Example, gefunden beim Prüfen derselben Mechanik:
`MR-003` des Beispiels löst `MR-001` auf, trug aber **weder `Löst auf` noch
`Ausgelöst durch Baseline-Stand`** — beide Pflicht, sobald ein Eintrag einen
früheren ablöst. Die Ablösung stand nur im Fließtext, und `Geltungsbereich`
zeigte ersatzweise auf `MR-001` statt auf die Artefakte. Ausgerechnet die
Datei, die diese Mechanik vorführen soll. Nachgetragen als deklarierter
Konventions-Backfill — Append-only schützt die *Aussage*, nicht die Nachpflege,
dieselbe Unterscheidung wie beim `Schärft:`-Backfill im ADR-Index.

Kein Sensor prüft `MR`-Feldvollständigkeit; deshalb ist es nie aufgefallen und
wird auch künftig nicht auffallen. Als Sensor-Kandidat notiert, nicht behauptet.

### d-check v0.53.0 bis v0.56.0: ein stiller Grün-Pfad und zwei gelieferte CRs

Vier Releases an einem Tag, der Pin steht auf **v0.56.0**.

**v0.53.0 nennt als Anlass einen ausgelieferten stillen Grün-Pfad in v0.52.0**
— genau unserem damaligen Pin: Hinter einem bis zum Dateiende offenen Fence
übersprang die Vorverarbeitung den Rest der Datei, und Module meldeten grün,
ohne gelesen zu haben. Kein Ausfall, den man sieht: Ein Gate, das nichts gelesen
hat, sieht aus wie ein Gate, das nichts gefunden hat. Gemessen, bevor der Pin
stieg — Kurs-Repo 0 Befunde, Beispiel 0 Befunde: Wir waren nicht betroffen.

**Der Bundle-Check bekommt `spans` dazu.** `tools/bundle-d-check.yml` fuhr nur
`[links, anchors]` — und beide sind genau die Module, die hinter einem offenen
Fence still werden. Im Bundle wiegt das schwerer als im Repo: Der
Release-Rewrite fasst die Dateien an, ein Fence, der erst dabei aufgeht, ist im
geprüften Repo-Stand nicht sichtbar. Das ist derselbe Grund, aus dem es diesen
Check überhaupt gibt. Break-Test am **gebauten** Bundle: offener Fence →
`fence-unclosed` an der Öffnungszeile, 1 Befund; entfernt → 0.

**v0.54.0 liefert `slice-097` — den ersten unserer beiden CRs.**
`planning.closure.glob` entkoppelt den Kandidaten-Filter der Closure-Prüfung von
`slice-glob`. Damit ist die Closure-Fähigkeit im Beispiel **verdrahtet**, und
zwar mit zwei bewussten Setzungen:

- `glob: '*.md'` — im Ruheort liegen neben Slices die Welle-Dokumente, und die
  tragen dieselbe Pflicht. `slice-glob` zu weiten wäre der falsche Knopf: Es
  zählt, was *in Arbeit* ist, und die Lifecycle-Invariante meldete danach falsch.
- `heading-pattern: '^#{1,3} .*Closure-Notiz'` statt des Defaults `^#{2,3}`.
  Grund ist eine Form des Korpus selbst: `welle-results.template.md` führt die
  Bestimmung im **Titel** (`# Welle <NN> — <Titel> — Closure-Notiz`), nicht in
  einem Abschnitt. Gemessen: Mit dem Default meldet ausgerechnet die Datei
  `closure-note-missing`, **die die Notiz ist**. `Closure-Trigger` und `Offene
  Risiken zur Welle-Closure` bleiben draußen, weil das Muster die Notiz benennen
  muss — genau die Falsch-grün-Falle, die das Skript in Welle 72 hatte.

Break-Tests: H1-Notiz entfernt → `closure-note-missing`; Notiz auf einen Satz
gekürzt → `closure-note-thin`. Beide punktgenau.

**Wo diese Prüfung läuft, ist die schwächere Aussage.** `make -C lab/example
verify` steht in keinem Workflow — weder die neue Closure-Fähigkeit noch die
vier Module des Beispiels (`matrix`, `targets`, `planning`, `ids`) noch das
Skript daneben laufen in CI. Das ist älter als diese Welle und keine Folge der
Verdrahtung, aber `checks.yml` trägt im eigenen Kopf den Satz, den das verletzt:
*„Ein Gate, das nur lokal läuft, ist ein Vorschlag."* Als Faden notiert, nicht
still gelassen.

**v0.55.0 liefert `slice-098` — den zweiten CR.** `closure.placeholder: true`
meldet den unausgefüllten Rumpf einer Vorlage; Inline-Code zählt nicht mit, weil
dort Syntax *gezeigt* wird — genau die Falsch-Positiv-Sorge, gegen die die
Regex des Skripts eigens gebaut war.

Damit sind **beide** CRs geliefert, und die Kongruenz ist Klasse für Klasse
gemessen, je Verstoß beide Sensoren nebeneinander:

| Klasse | d-check | Skript |
|---|---|---|
| Bestand unverändert | still | still |
| Sektion entfernt | `closure-note-missing` | rot |
| Notiz auf einen Satz | `closure-note-thin` | rot |
| unausgefüllter Platzhalter | `closure-note-placeholder` | rot |
| Floskel (8 von 10 Phrasen) | `closure-note-boilerplate` | rot |
| Floskel `ok` / `n/a` | **still** | rot |

**Beim Portieren der Floskel-Liste ging es schief.** Der *unveränderte* Bestand
meldete plötzlich vier `closure-note-boilerplate`. Ursache: d-check matchte den
**literalen Substring**, das Skript die **Wortgrenze** — `ok` trifft in
`dokumentiert`, `n/a` in Pfaden. Kontrolliert nachgewiesen an einer Probe, deren
einziges Vorkommen in `dokumentiert` steckt: mit `ok` rot, nach Ersetzen des
einen Wortes grün. **v0.56.0 behebt es** (`slice-104`, mit derselben Messung —
„68 Treffer, davon einer echt"); alle zehn Phrasen des Skripts stehen jetzt in
der Konfiguration.

Die Lehre daran überlebt den Fix: **Die Vorbedingung des Handbuchs — „Phrase nur
aufnehmen, wenn sie im Bestand null Treffer hat" — ist nur so gut wie die Lexik,
mit der man zählt.** Mit Wortgrenzen gezählt: zehnmal Null. Mit d-checks
damaliger Lexik: achtmal Null, einmal 18, einmal 6. Dieselbe Frage, zwei
Antworten, und die falsche hätte ein dauerhaft rotes Gate eingebaut.

### v0.56.0 macht `closure-note-thin` schärfer — und deckt einen Denkfehler auf

Das Release warnt: *„Ein grüner Lauf kann rot werden."* Vor dem Pin gemessen,
und genau so trat es ein: `welle-1-mvp.md:81` meldete neu `closure-note-thin`.

Der Befund ist **richtig am Kandidaten und falsch an der Kandidaten-Menge**.
Jene Datei ist der Welle-*Plan*, und ihr §7 lautet vollständig:

```markdown
## 7. Closure-Notiz

Ergebnis: [`welle-1-results.md`](welle-1-results.md).
Zähler: [`../observations.md`](../observations.md).
```

Das ist die von `welle.template.md` **vorgeschriebene** Form — die Notiz selbst
lebt in `welle-<NN>-results.md`. Vier Sätze dort zu verlangen hieße, die
Ergebnis-Notiz zu duplizieren, also genau die Drift zu erzeugen, gegen die der
Kurs sonst antritt. Bis v0.55.0 rutschte die Datei nur durch, weil die Punkte in
den Link-Pfaden als Satzenden zählten — grün aus dem falschen Grund.

Der Kandidatenfilter steht deshalb jetzt auf `slice-*.md`. Der Wunsch wäre
„Slices **plus** Ergebnis-Notizen, **ohne** den Plan", und er lässt sich nicht
schreiben: `glob` ist ein einzelner String, eine Liste wird abgelehnt
(`cannot unmarshal !!seq into string`), Brace-Ausdrücke erzeugen einen
Phantom-Kandidaten, Negations-Klassen greifen nicht. Mit dem engeren Glob
entfällt auch die `heading-pattern`-Weitung auf Ebene 1 — sie trug nur die
Ergebnis-Notiz, und eine Einstellung, die nicht beißt, ist eine Behauptung.

### Kongruenz unter v0.56.0 — und zwei eigene Fehler auf dem Weg dorthin

| Klasse | d-check | Skript |
|---|---|---|
| Bestand unverändert | still | still |
| Sektion entfernt | `closure-note-missing` | rot |
| Notiz auf einen Satz | `closure-note-thin` | rot |
| Floskel, mehrwortig | `closure-note-boilerplate` | rot |
| Floskel `Ok.` allein | `closure-note-boilerplate` | rot |
| unausgefüllter Platzhalter | `closure-note-placeholder` | rot |

Der erste Anlauf sagte: *„gleichauf in der Sache, aber d-check prüft nur die 6
Slices statt aller 8 Dateien — retiren hieße Deckung verlieren."* Das war
**falsch, und zwar zweifach an meiner eigenen Konfiguration**:

- **Die Schwelle stand auf der Werkzeug-Vorbelegung, nicht auf der
  Entscheidung.** `min-sentences` lag bei d-checks Default 4; **ADR-0011
  §Entscheidung 1 sagt „mindestens zwei Sätze"**. Ein Gate, das schärfer ist als
  seine ADR, ist genauso falsch wie eines, das lascher ist — beides setzt eine
  Entscheidung durch, die niemand getroffen hat. Und genau daran scheiterte
  `welle-1-mvp.md`, was ich dann fälschlich als Werkzeug-Mangel deutete.
- **Die Kandidaten-Menge war unter-, nicht über-gefasst.** ADR-0011 zählt in
  ihrer Geschichte `welle-1-mvp.md` **ausdrücklich** zu den betroffenen Dateien.
  `glob: 'slice-*.md'` war der Fehler, `*.md` die richtige Antwort.

Mit beiden Werten aus der ADR ist der Bestand grün und d-check echte Obermenge —
belegt mit **12 Break-Tests über alle drei Dateiarten** des Ruheorts (Slice,
Welle-Ergebnisnotiz, Welle-Plan), je beide Sensoren am selben Fund, Bestand
beidseitig still. Nicht gebraucht wurde damit ein Glob wie `*[^p].md`, der zwar
funktioniert, aber nur, weil *diese* Welle „mvp" heißt; die nächste
(`welle-3-skalierung` im Kurs) hätte ihn still gebrochen.

### Das Skript bleibt trotzdem — und der Grund stand nicht im Code

Technisch war es ab hier ablösbar. Der Fußabdruck sagte etwas anderes:
[Modul 11](kurs/de/04-qualitaet/modul-11-verification.md) ist das Worked Example
*„Fitness Function ohne Standard-Tool"* — sieben Schritte, an deren Ende man das
Skript selbst schreibt —, und es verlinkt `lab/example/tools/check_closure_notes.py`
per Pfad als Vergleichsgegenstand. Dazu hing die Skill-Vorlage
`closure-note-reviewer` mit dreizehn Nennungen daran.

Löschen hätte also nicht Redundanz entfernt, sondern **dem Kurs seinen Gegenstand
genommen**. Die Norm-Hierarchie entscheidet das eindeutig: Ein Beispiel zu
löschen, auf das der Kurs zeigt, macht den *Kurs* falsch, nicht das Beispiel
richtig.

Entschieden in [ADR-0019](lab/example/docs/plan/adr/0019-closure-sensor-und-skript-rolle.md)
(Bezug auf ADR-0011, kein Supersede — dieselbe Form wie beim zweiten
Layering-Sensor): **Die Deckung trägt `planning.closure`, das Skript trägt die
Lehre.** Beide laufen weiter, denn ein Worked Example, dessen Gegenstand nicht
mehr läuft, ist ein totes Beispiel. Wo das Skript als *Gate* dokumentiert war —
`AGENTS.md` §3, `harness/README.md` §Sensors, `docs/plan/planning/README.md` —
steht jetzt seine Rolle.

**Der Kurs bekommt daraus einen achten Schritt**, werkzeug-agnostisch formuliert:
*Ein selbstgebautes Gate ist auf Zeit gebaut.* „Kein Standard-Tool prüft das" ist
eine Aussage über heute. Erscheint später eines, ist die Frage, ob es eine
Obermenge ist — Kandidaten-Menge, Bedingungen und **die Schwelle, wie die ADR sie
setzt**, jeweils einzeln nachgewiesen, je Verstoßklasse mit beiden Sensoren
nebeneinander. Und es gibt eine dritte Antwort neben *retiren* und *behalten*:
Ein Skript kann einen **anderen Konsumenten** bekommen — dann trägt es nicht mehr
Deckung, sondern eine Rolle, und die gehört ausgeschrieben.

Die Skill-Vorlage nennt jetzt kein Beispiel-Werkzeug mehr, sondern „das
Struktur-Gate deines Repos" — dieselbe Korrektur wie beim retirten
`check-references` in Welle 72: Die Norm beschreibt den Gate, nicht sein Target.

Zwei Lehren aus dem Verlauf:

- **Ein Trigger auf fremde Buchführung misst deren Ordnung, nicht die eigene
  Vorbedingung.** Der Faden nannte zwischenzeitlich *„`slice-098` landet in
  d-checks `done/`"* — beobachtbar, aber am falschen Gegenstand: Die Fähigkeit
  war ausgeliefert, während die Slice-Datei im Tag noch in `in-progress/` stand.
- **Ein Tag ist kein Release.** v0.56.0 existierte zwischenzeitlich als Tag ohne
  veröffentlichtes Release und ohne Image in der Registry — nichts, worauf sich
  pinnen ließe. Geprüft mit Gegenprobe, damit die Feststellung nicht selbst ein
  stiller Fehlschlag war.

### Was diese Welle ändert — und was das für Adopter heißt

Am **Bundle** kommen an:

- die vier Treuekorrekturen (`grundlagen-traceability.md`,
  `modul-06-roadmap.md`, `modul-13-quality-gates.md`);
- die **Adress-Regel für Adaptionen** in `grundlagen-harness-dateien.md` und
  `grundlagen-source-precedence.md` plus beiden `conventions`-Vorlagen;
- der geschärfte **Ausgang 5** des Freshness-Audits in
  `modul-02-harness-bootstrap.md`;
- **„Ein selbstgebautes Gate ist auf Zeit gebaut"** in
  `modul-11-verification.md` — mitsamt der dritten Antwort neben retiren und
  behalten: das Skript mit dem anderen Konsumenten;
- die **Skill-Vorlage** `closure-note-reviewer.template.md`, die kein
  Beispiel-Werkzeug mehr nennt, sondern „das Struktur-Gate deines Repos";
- ein Nebenbefund am Rand: In `grundlagen-traceability.md` stand als letzte
  Zeile ein **nackter Anker ohne Inhalt** — Rest eines Umzugs, auf den
  niemand zeigte. Er bleibt (eine vergebene Adresse verfällt nicht), trägt
  jetzt aber den Zeiger auf die Stelle, an der die Regel wirklich steht.

Die Treuekorrekturen allein wären PATCH gewesen. Mit Adress-Regel, Ausgang 5
und dem achten Schritt kommen **Regeln hinzu** — additiv, nichts entfällt, kein
Asset entfernt, kein Layout gebrochen: **MINOR**. Wer die `conventions`-Vorlage
schon ausgefüllt hat, ergänzt die Anker in seinem Index und hängt Pfad-Verweise
auf Adaptionen um; wer nichts tut, verliert nichts Bestehendes — er behält nur
die Verweise, die beim nächsten `git mv` brechen.

Die Stand-Zeile von [`lab/regelwerk/README.md`](lab/regelwerk/README.md) zieht
auf Welle 73 nach.

Der übrige Umfang liegt in `lab/example` (a-check-Pin, `GRENZE`-Blöcke,
ADR-0018) und reist im Bundle nicht mit.

Offen und als Fäden notiert: die 48 nackten ADR-Kennungen in `docs/plan/adr/`
selbst (unzulässig zu beheben — Immutabilität, am eigenen `core-drift-vcs`
belegt); und das Retiren von `check_closure_notes.py`, dessen Trigger jetzt
**beobachtbar** ist statt erhofft — beide CRs sind bei d-check angenommen und
liegen als `slice-097` und `slice-098` im Backlog. Der d-check-Pin bleibt auf
`v0.52.0`: Die dortige unveröffentlichte Arbeit wird erst mit einem Tag
relevant, auf ungetaggte Commits pinnen wir nicht.

## Welle 72 — 2026-08-09 · Zwei Sensoren an derselben Aussage

ADR-0001 des Beispiel-Repos verlangt „pro Sprach-Skelett ein Architekturtest",
und sechs Skelette lösen das mit sechs Mechanismen: `depguard`,
`import-linter`, Konsist, ArchUnit, NetArchTest, ein `arch-check.sh`. Alle
sechs sind **Verbotslisten** — sie wachsen dort, wo jemand an einen Fall
gedacht hat. Das C++-Skript nennt zwei Adapter beim Namen; ein dritter wäre
ungeprüft. Die C#-Tests prüfen vier Namespace-Paare; für die `Types`-Schicht
gibt es gar keine Regel.

[a-check](https://github.com/pt9912/a-check) dreht die Richtung um: `edges`
sagt, was **erlaubt** ist, alles andere ist ein Befund. Das Beispiel bekommt
den Prüfer deshalb **additiv** — der jeweilige Bestandssensor bleibt, denn die
Mechanismus-Vielfalt ist Lehrinhalt, kein Altlast-Zustand.

### Entschieden

- **Ein Gate, zwei Sensoren, in allen sechs Skeletten.** `make arch-check` ruft
  beide, und zwar beide vollständig — ein Abbruch nach dem ersten roten zeigt
  immer nur eine Befund-Menge. Das Ziel-Set von `make gates` bleibt unverändert.
- **Eine Config pro Skelett, Scan-Wurzel ist das Sprachverzeichnis.** Ein
  gemeinsamer Scan über `lab/example/` wurde geprüft und verworfen: Go-Importe
  tragen den Modulpfad und lösen gegen sprach-präfixierte Schicht-Globs nicht
  auf — ein eingebauter Verstoß blieb unentdeckt, das Gate wäre **still grün**.
- **Modelliert wird, was gebaut ist.** Rollen (`role: app`) nur dort, wo die
  Schicht sie einlöst; fünf der sechs Skelette sind geschichtet ohne Ports und
  tragen reine Kanten. Eine Rolle zu setzen, die der Code nicht einlöst, meldete
  Verstöße gegen eine Architektur, die niemand gebaut hat.
- **Kein Skript-Zuwachs.** `a-check.mk` ist tool-generiert und wird included;
  die Regeln stehen in `.a-check.yml`.

### Der Befund, der die Welle trägt: die Bauform der Regel

a-check liest die Import-Anweisung. Blind ist es für die Schreibweise, die
**daran vorbei** koppelt — ein elternrelativer `#include`, ein voll
qualifizierter Typ ohne `import`, ein relativer Python-Import. Ob daraus eine
Gate-Lücke wird, entscheidet der Bestandssensor.

Die erste Vermutung war: AST- oder Bytecode-basierte Werkzeuge decken es ab,
textbasierte nicht. Java hat sie bestätigt, **Kotlin sie widerlegt**. Konsist
*könnte* den AST lesen; seine Regeln im Skelett sind gegen `file.imports`
geschrieben und liegen damit auf derselben Ebene wie a-check. Gemessen:
`com.example.docsearch.ui.Handler` ohne Import — compiliert, a-check 0 Befunde,
Konsist `BUILD SUCCESSFUL`. Ein echter Verstoß passiert beide.

| Skelett | Umgehende Schreibweise | Bestandssensor sieht sie? |
|---|---|---|
| C++ | elternrelativer `#include` | **nein** — per `constructs`-Regel verboten |
| Kotlin | voll qualifizierter Typ ohne `import` | **nein** — `constructs` deckt nur die Richtung auf `ui` |
| C# | dito | ja — Assembly |
| Java | dito | ja — Bytecode |
| Python | relativ, Subpaket-Form, Komma-Liste | ja — AST; a-check ist dort der *schwächere* Sensor |
| Go | keine — der Compiler weist relative Importe ab | entfällt |

Das tragende Merkmal ist also nicht die Werkzeugklasse, sondern **wie die Regel
geschrieben ist** — und das steht in keinem Datenblatt, nur im Regel-Quelltext
des jeweiligen Skeletts. Der Slice zieht daraus die Konsequenz: Die Frage
„welche Schreibweise setzt die Auflösung voraus, und erzwingt sie etwas?" steht
als **Schritt 0 vor der Config**, mit Beleg-Pflicht am Skelett. Sie stand
zunächst nur als Grenze in einer ADR — also an der Stelle, von der Welle 71
schon gemessen hat, dass sie den nicht erreicht, der die Arbeit macht.

### Was die Gates dabei über sich selbst verrieten

Vier Sensoren behaupteten mehr, als sie prüften; alle vier fielen beim
Verdrahten auf, nicht im Betrieb:

- **`make help`** listete an der Kurs-Wurzel „Makefile" und „d-check.mk" statt
  der Target-Namen — seit dem `d-check.mk`-Include, weil `grep` bei mehreren
  Dateien den Dateinamen voranstellt. `make help` ist laut AGENTS.md die
  autoritative Target-Liste.
- **`check_closure_notes`** band an die erste Überschrift mit „closure" ohne
  „trigger" — in einem Slice war das „Offene Risiken zur Welle-Closure", nicht
  die Notiz. Hätte jene Sektion zwei Sätze, wäre das Gate **grün** gewesen,
  auch bei leerer Closure-Notiz. Falsch-grün, nicht nur falsch-rot.
- **`go/AGENTS.md` §G-2** verbot `internal/ui` den Import von `internal/audit`
  — dafür führt `depguard` keine Regel, und das Paket existiert nicht.
- **Die Pre-completion-Checklisten** in python, java und kotlin nannten das
  Bestandswerkzeug direkt (`lint-imports`, `mvn test`, `./gradlew test`). Seit
  a-check als zweiter Sensor hängt, deckt das den Gate nicht mehr ab; alle sechs
  nennen jetzt das Target, nicht das Werkzeug.

### Die Gates, die dabei entstanden sind

Dieselbe Welle hat den Befund-Weg zu Ende gegangen: Was hier von Hand auffiel,
prüft jetzt ein Sensor. `d-check` bringt die Module mit, es kam kein Skript dazu
— eines ging sogar.

- **`matrix`** trägt die Referenz-Richtung (Kurs §Referenz-Richtung). Damit ist
  `lab/example/tools/check_references.py` **retired**: Es trug zwei Zellen der
  Matrix und erklärte die dritte — ADR → Slice — im eigenen Kopf für nicht
  grep-bar. Der Kurs löst sie längst über den umgekehrten Default (Kante
  verboten, Ausnahme am Ort deklariert). Kongruenz vor dem Löschen belegt, je
  Verstoß beide Sensoren nebeneinander.
- **`ids`** macht ADR-Kennungen linkpflichtig — keine Kosmetik: `matrix` prüft
  den Status eines Ziels **nur an Links**, eine nackte Kennung ist für die
  Richtungs-Prüfung unsichtbar. 62 Links in 27 Dateien.
- **`targets`** hält Doku-Tabellen und Make-Regeln zusammen — gegen
  „halluzinierte Gates", die AGENTS.md die häufigste Form der Harness-Lüge
  nennt. Alle drei Befunde beim Verdrahten wurden durch *Dokumentieren* gelöst,
  nicht durch Ausnehmen.
- **`vcs`** setzt ADR-Immutabilität durch und belegte sich sofort an einem
  eigenen Verstoß: ADR-0015 war `Accepted` und wurde danach im Kern
  nachgebessert. Zurückgesetzt statt nachgebessert — die Korrektur lebt im
  Nachfolger.
- **`planning`**, **`hostpaths`**, **`spans`**, **`tracked`** dazu; `spans` fand
  eine unschließbare Code-Span in einem Review-Dokument.

**Nicht verdrahtet, mit Grund:** `commits` — die Regel dafür steht in der
AGENTS.md des *Beispiels*, und das ist ein Teilbaum ohne eigenes `.git`; für das
Kurs-Repo selbst gibt es sie nicht. Ein Gate zu stellen hieße, eine Konvention
zu erfinden oder dauerhaft rot zu sein.

### Die Kotlin-Lücke, geschlossen wo sie entsteht

Der eine Fall, in dem **beide** Sensoren blind waren, ist zu — und zwar am
Bestandssensor, nicht per Zusatzregel. Konsists Regeln waren gegen
`file.imports` geschrieben und lagen damit auf derselben Ebene wie a-check; sie
prüfen jetzt den Quelltext und fangen auch die voll qualifizierte Nennung.
Gemessen: `service → ui` vorher grün, jetzt rot.

Die `constructs`-Regel, die im C++-Muster für Kotlin nachgebaut worden war,
**entfällt** damit — nachgewiesen, dass sie nichts mehr trägt: Sie kannte nur
die Richtung auf `ui`, und `index → service` liegt außerhalb ihrer Zone.
Kotlin verhält sich jetzt wie Java und C#. C++ bleibt das einzige Skelett mit
zwei textnahen Sensoren; dort trägt die Regel weiter.

Die ADR-Kette dieser Welle ist damit vierstellig — `0014 → 0015 → 0016 → 0017`,
jede Ablösung von einer Messung ausgelöst. Zweimal ist dabei derselbe Fehler
passiert und beim zweiten Mal an der Wurzel behoben: Eine Nachfolge-ADR, die
weniger trägt als ihre Vorgängerin, macht jeden Abschnitts-Zeiger auf sie
falsch. `0017` übernimmt Entscheidung **und** Nummerierung der Vorgängerin.

### Was die Aufräumarbeit über ihre eigenen Grenzen ergab

Die Linkpflicht (`ids`) traf drei Kennungs-Klassen mit drei verschiedenen
Antworten — die Messung hat entschieden, nicht die Symmetrie:

- **`ADR-*` und `LH-*` außerhalb der ADRs:** verlinkt, zusammen 120 Stellen.
- **Alles in `docs/plan/adr/`:** *unzulässig* zu beheben. Jede ADR ist
  `Accepted` oder `Superseded`; einen Link im Körper zu ergänzen ist eine
  Kern-Änderung — nachgestellt, `core-drift-vcs`. Das Ziel-Verzeichnis, das
  `ids` konstruktionsbedingt ausnimmt, ist genau das, in dem eine Korrektur
  verboten wäre.
- **`slice-*`:** bewusst **keine** Linkpflicht. Der Kurs nennt die Slice-ID
  einen „stabilen Token, auch nachdem die Datei nach `done/` wandert" — ein
  Pfad-Link macht sie instabil, jeder `git mv` bräche ihn repo-weit.

Der d-check-Pin steht auf v0.52.0. Dessen neue Closure-Notiz-Prüfung wäre der
naheliegende Anlass gewesen, auch das letzte handgeschriebene Prüfskript des
Beispiels zu retiren — die Messung sagte nein: Zwei Klassen (unausgefüllte
Template-Platzhalter, Nicht-`slice-*`-Dateien in `done/`) fängt nur das Skript.
Als Faden mit zwei CR-Kandidaten in der Roadmap.

### Nachtrag aus einem Konsumenten-Befund: der Spiegel war verdünnt

`ai-harness-init` meldete, die Tabelle *Welche Rolle braucht welche
Artefaktklasse* (Modul 8) lasse sich als Zuweisung von **Schreibrechten**
lesen, im Widerspruch zu den zwei Stellen desselben Moduls, die Schreibrechte
wirklich verteilen. Vorgeschlagen war ein klarstellender Satz unter der
Tabelle, ausdrücklich mit der Bitte um Gegenprüfung.

Die Gegenprüfung ergab etwas anderes. Die Achse steht im Kurs deutlich —
*„Eine Rolle wird über **genau die** Artefaktklasse geführt, die ihr Urteil
trägt — und das ist meistens kein Skill"* —, im **Spiegel** aber verkürzt auf
*„Jede Rolle wird über die Artefaktklasse geführt, die ihr Urteil trägt"*.
Verloren waren die Exklusivität und die Pointe des Abschnitts; dazu in zwei
Tabellenzellen das Kriterium selbst. Auf Rückfrage bestätigte der Konsument,
nur den Spiegel gelesen zu haben — die Fehllesart ist damit erklärt und die
Ursache gemessen, nicht vermutet.

Der Spiegel darf **Didaktik weglassen, Operatives aber nur quelltreu
übernehmen**. Vier Stellen sind wiederhergestellt; kein neuer Satz. Die einzige
verbleibende Abweichung ist eine verankerte Auflösung fürs Alleinstehen
(`AGENTS.md + 8-Schritt-Workflow` statt `+ Workflow`).

Der Befund ist älter als diese Welle — er stammt aus dem Split des Moduls. Er
wird hier korrigiert, weil das Release noch nicht draußen war.

### Was diese Welle ändert — und was das für Adopter heißt

Der Schwerpunkt liegt in `lab/example`, aber **nicht nur dort**: Kurs,
Regelwerk-Spiegel und ein Template nannten weiter ein Gate namens
`check-references`, das es nach dem Retiren nirgends mehr gibt. Der Name ist
aus der Norm-Schicht entfernt, ohne sie werkzeug-spezifisch zu machen — sie
beschreibt jetzt den *Gate*, nicht sein Target. Die Stand-Zeile von
[`lab/regelwerk/README.md`](lab/regelwerk/README.md) zieht deshalb auf Welle 72
nach.

Offen und als eigene Fäden notiert: Konsists Regeln auf Typ-Referenzen statt
`file.imports` heben; die 48 nackten ADR-Kennungen in `docs/plan/adr/` selbst,
die `ids` konstruktionsbedingt nicht sieht (das Modul nimmt sein
Ziel-Verzeichnis aus); und vier Befunde an a-check selbst — allen voran eine
Laufzeit-Diagnose der eigenen Heuristik-Grenze („welche Import-Schreibweisen
dieses Repos extrahiert dieses Backend nicht?"). Sie würde Schritt 0 vom
Handgriff zur Werkzeug-Eigenschaft machen.

## Welle 71 — 2026-08-08 · Was ein Kommentar trägt

Wiederkehrende Beobachtung: In Code-, Config- und Skript-Dateien beschreiben
Kommentare nicht nur, sie betreiben Forensik — *„die frühere Zusage wurde
ersetzt"*, *„der Guard war unerreichbar und ist entfallen"*. Dieselbe Klasse
zeigte sich in Wellen, Slices und der Roadmap, dort aber im **Rumpf** statt im
Kommentar. Damit war die Frage nicht Kommentar-Hygiene, sondern **Zeitform im
Zustands-Artefakt**.

Auditiert wurde gegen `ai-harness-init` — ein realer Konsument mit vollem
Slice-Lifecycle, sechs Sprachen ausgeschlossen, Go/Shell/Make als Bestand.
Gemessen: 21 Treffer in 21 nicht-Test-Go-Dateien; `harness/tools/mutate.sh`
trägt einen 64-Zeilen-Kopf mit zwölf Befund-Nummern; emittierte Artefakte
(`enforce.mk`, `d-check.yml`) nennen Slice-Nummern des **Erzeuger**-Repos, die
im erzeugten Repo in *null* Hops auflösen.

Der tragende Befund ist ein Durchsetzungs-Befund. Dort formuliert `ADR-0014`
die Regel längst richtig und allgemein — *„im Artefakt bleibt, was `git` nicht
halten kann"* —, aber der Code-Agent liest sie nie: ADRs kommen nur über
Slice-Referenzen in seinen Lesepfad, und ein Code-Slice referenziert keine ADR
über den Konventions-Block. Auf ausdrückliche Anweisung korrigierte der Agent
dann sieben Kommentare — **fünf sauber, einen reproduzierte er im selben Diff,
einen ließ er als Trümmer stehen**. Eine Regel, die nur am Vorsatz angreift,
erreicht genau diese Rate.

### Entschieden

- **Positive Bestimmung statt Verbotsliste.** `grundlagen/harness-dateien.md`
  bekommt §*Was ein Kommentar trägt* mit fünf Klassen — **Zusage · Kopplung ·
  Abgrenzung · Rang-Zeiger · Grenze** — und einem Leser-Modell: Ein Kommentar
  schreibt an den, der *ändert*, nicht an den, der *entscheidet*. Der Abschnitt
  steht neben §Template-Schichtung, die nur MD-Templates regelt, weil deren
  Kommentare beim Adoptieren gelöscht werden; Code-Kommentare bleiben.
- **Zwei Tests:** Adressaten-Test (ändert er oder entscheidet er?) und
  Zeitform-Test (Indikativ über das, was ist?).
- **Drei Klassen fallen dadurch heraus, ohne eigenes Verbot:** *Deliberation*
  (Konjunktiv über die verworfene Alternative → ADR), *Herkunfts-Prosa*
  (abwesender Text oder Code → `git`) und *Ersetzungs-Trümmer* (eine
  Teilersetzung ließ den Rest des alten Satzes stehen).
- **Emittierte Artefakte tragen keinen Herkunfts-Anker.** Verlässt ein Artefakt
  sein Erzeuger-Repo, reist der Kontext nicht mit — dieselbe Regel, die beim
  Regelwerk-Split die Deixis umhängt.
- **Träger, nicht Gate.** Modul 9 bekommt den Generierungs-Moment, die
  `AGENTS.template.md` eine Hard Rule `3.7`, der Reviewer-Skill einen
  HIGH-Eintrag. Ein Sensor wird **nicht** behauptet: Nur die Trümmer-Klasse
  wäre ein Match, und gebaut ist sie nicht.

### Aus dem Beispiel-Zug: der Zeitform-Test war zu scharf

`lab/example` gegen die Regel gezogen: drei Verstöße behoben (eine
Herkunfts-Prosa in einem Go-Test, eine Deliberation im C#-Makefile, ein
Vorfalls-Bericht in `check_closure_notes.py`). Dabei fielen **vier korrekte
Kommentare** durch den Test — *„das wäre ein eigener Slice"*, die
Grenze-Klasse. Der Konjunktiv zeigt dort nach vorn, nicht zurück. Der Test
unterscheidet jetzt die Zeitrichtung; Fix-Richtung Quelle, nicht Beispiel.

### Aus dem Review

Der neue Abschnitt behauptete, Schritt 5 und 6 des Minimal Agent Workflow
erzeugten Code — die eigene Liste hat dort *Sensor-Lauf* und *Gate-Lauf*; der
Code entsteht zwischen 4 und 5. Der Grenze-Block nannte drei Fehlerklassen, die
Fallout-Tabelle drei andere, und der eine als „Match" deklarierten Klasse war
kein Träger zugeordnet. In derselben Beispiel-Datei stand 23 Zeilen tiefer eine
zweite Herkunfts-Prosa, die der erste Durchgang übersehen hatte. Dazu die
Navigations-Nachzüge (Segmenting-Empfehlung, §Themen, Grundlagen-Index) und die
harte Zahl *„fünf"* im Template, die eine sechste Klasse falsifiziert hätte —
sie trägt jetzt nichts mehr.

## Welle 70 — 2026-08-08 · Ein Closure-Kriterium ohne Gegenstand

Aus einer Leserfrage: *Was meint man mit Reconciliation-Backlog? „Backlog" wird
sonst nicht erwähnt, und es gibt auch kein Template dafür.*

Beides stimmte. Der Begriff kam achtmal vor, durchweg wie ein zählbares
Register behandelt — er *„steht"*, er *„sinkt um genau einen Eintrag"* — und er
ist das **Closure-Kriterium des Brownfield-Bootstraps**. Definiert war er
nirgends: kein Glossareintrag, kein Template, kein Pfad. Dazu trug er drei
Namen (`Diskrepanz-Backlog` in Modul 1, `Reconciliation-Backlog` in Modul 2 und
`bootstrap.md`, `CO-DS-*-Backlog` in der Musterlösung).

### Entschieden

- **Er bekommt einen Ort:** `docs/plan/planning/reconciliation.md`, flach neben
  dem Beobachtungs-Register, mit Vorlage. Eine Zeile je Fund des Rückbaus —
  Kennung `RC-<NNN>`, Fund, Sub-Area, Klasse, Auflösung, Stand —, plus eine
  Append-only-Tabelle für aufgelöste Zeilen.

  Zwei Zwischenfassungen sind vorher gescheitert, und beide am selben Punkt.
  Die erste definierte den Backlog als „die offenen `CO-DS-*`" — eine Notation,
  die §Vergabe nicht deckt, weil dort der Slot die Sub-Area trägt. Die zweite
  wich auf „ablesbar an der Roadmap" aus und verschob das Problem nur: An der
  Roadmap steht nirgends, welche Slices aus der Inventur stammen. **Nichts
  markiert die Zugehörigkeit** — weder eine Kennung noch eines der sechs
  Carveout-Kopffelder —, also ist die Menge ohne Register nicht bestimmbar, und
  ein Closure-Kriterium über eine unbestimmbare Menge ist keines.

  Das Gegenargument („ein drittes Register wäre eine Kopie, die driftet") hält
  nicht: `observations.md` hat dieselbe Form — Beobachtungen entstehen in
  Slices, die Beleg-Spalte zeigt darauf — und der Kurs hat sich dort längst für
  eine eigene stehende Datei entschieden.
- **„Steht" heißt nicht „ist leer", sondern *jede Zeile trägt ihre Auflösung*.**
  Beim Bootstrap-Ende ist das Register voll; leer wird es je Sub-Area erst bei
  der Graduation, und das ist dort die Graduation-Bedingung.
- **`CO-DS-*` entfällt.** Die Klasse steht in der Register-Zeile, nicht in der
  Kennung — damit braucht der Carveout keinen Typ-Marker mehr, der mit dem
  Bereichssegment aus §Vergabe kollidierte. Carveouts heißen wieder `CO-<NNN>`.
- **Ein Name statt drei.** Modul 1 und die Modul-2-Lösung sind angeglichen.

### Aus dem Review: die Präfix-Regel war falsch formuliert

Der Review dieser Welle traf die Kernregel von Welle 68. *„Das Präfix kodiert
das Stratum"* stimmt für `SPEC-*` und `ARC-*`, nicht aber für die Verfeinerung:
`LH-FA-IDX-003` (Vertrag) und `LH-FA-IDX-003.a` (Technik) teilen dasselbe
Präfix — dort trägt der **Suffix** das Stratum. Schlimmer war die Dispatch-Form
in §Referenz-Richtung: *„`LH-*` → Vertrag, `SPEC-*` und
`<PREFIX>-FA-*.<Buchstabe>` → Technik"* — überlappende Muster, bei denen
First-Match-Wins die Verfeinerung als Vertrag einordnet. Betroffen wären genau
die Kennungen, die Welle 68 gerade erst gesetzt hat (`ADR-0012`, drei
Beispiel-Slices).

Beide Stellen heißen jetzt **Kennungs-Form** statt Präfix, und die Muster sind
ausdrücklich disjunkt gelesen: `<PREFIX>-FA-<NN>` *ohne* Suffix → Vertrag,
derselbe Name *mit* `.<Buchstabe>` sowie `SPEC-*` → Technik, `ARC-*` → Sicht.

Dazu vier kleinere Nachzüge: Die neue Überschrift des Freshness-Audits hatte
zwei fremde Blöcke unter sich gezogen (sie haben jetzt eigene); der
Regelwerk-Split trug einen Satz, den die Quelle nicht hatte (Quelle nachgezogen);
die Selbstcheck-Rubrik führte mit *„Reconc.-Slice-Backlog"* eine vierte
Schreibweise; und der `MR-004`-Beispielblock in Modul 7 nannte einen
Folge-Slice `slice-014`, der im selben Beispiel-Repo schon vergeben ist.

Der Vergleichsfall stand daneben und hat den Mangel sichtbar gemacht: Das
**Beobachtungs-Register** ist dieselbe Art Sammlung — wächst und schrumpft über
Slices hinweg — und hat Namen, Template, festen Pfad, Zählregel und Schwelle.
Der Reconciliation-Backlog hatte nichts davon, obwohl er in einem
Closure-Kriterium steht.

## Welle 69 — 2026-08-08 · Eine Regel, die nie jemand übernommen hat

Adopter-Beobachtung aus `ai-harness-init` — derselben Quelle wie Welle 27, und
genau an der Stelle, die Welle 27 offen gelassen hat. Der §Freshness-Audit war
mit sechs Eigenschaften deutlich stärker als vermutet: Er geht durch die
Adaptions-Liste statt nur durch den Diff und vergleicht auch die Form. Aber
**alle sechs hängen an einer Änderung**. Eigenschaft 4 sagt es wörtlich — die
Ausgänge „beziehen sich auf das *Delta* der neuen Fassung, nicht auf den
Zustand der Baseline".

Damit findet keine von ihnen eine Regel, die nie ins ausgefüllte Artefakt
übernommen wurde und sich seither nie geändert hat: Sie erzeugt keinen
Template-Diff und hat keinen `MR`-Eintrag, den der Adaptions-Durchgang
abschreiten könnte. Sie ist unsichtbar, *weil* sie alt und stabil ist.

Zwei gemessene Belege, keine Konstruktion. Der `## 3.`-Block der
`AGENTS.template.md` ist von `v4.0.0` bis `v5.1.0` **bytegleich** — vier
Releases, ein Major-Sprung, Delta durchgehend null; zwei seiner sechs Regeln
fehlen in der `AGENTS.md` des Adopters, und die Re-Vendor-Reviews dieser
Spanne konnten das nicht finden. (Bei `v4.0.0` wurden 3.3 und 3.4 zuletzt
umgeschrieben — ein Delta-Review dort *hätte* den Block betreten. Die
Unsichtbarkeit beginnt erst danach, und das genügt: Sie hält seit vier
Releases an und endet aus eigener Kraft nie.) Und ein ganzes Modul lag beim
Adopter vom ersten Tag an vollständig im Repo, ohne je ein Delta gewesen zu
sein.

### Entschieden

- **Siebte Eigenschaft: eine Stichprobe gegen den Bestand.** Sie läuft
  unabhängig vom Ergebnis der Tag-Frage — damit ist der Audit in einer stabilen
  Phase erstmals kein No-op mehr: Ist der Pin aktuell, haben die sechs anderen
  nichts zu tun, und genau dann wächst der Befund, um den es geht.
  Auswahlkriterium
  fällt mit der Ursache zusammen — gezogen wird aus den Abschnitten **ohne
  Delta seit Adoption**, der Komplementärmenge zu
  `git diff <alt> <neu> -- .harness/baseline/`. Umfang: ein Abschnitt pro
  Audit, rotierend. **Keine Vollinventur** — die zöge das Closure-Kriterium ins
  Unabsehbare und nähme der Welle, was sie von sich selbst verlangt.
- **Ausgang getrennt nach Einzelfall und Muster.** Ein Fund geht den Weg jeder
  Diskrepanz (Übernahme oder Carveout). *Mehrere* Funde treffen nicht die
  einzelne Regel, sondern die `MR-000`-Aussage „keine inhaltlichen Adaptionen
  ggü. Baseline-Default" — sie ist dann nachweislich falsch und wird korrigiert.
- **Keine fünfte Trigger-Klasse.** Die vier bestehenden sind
  änderungsgetriebene Repo-interne Auslöser; dieser Fund entsteht gerade *ohne*
  Bewegung, und sein Auslöser ist der Audit selbst (Eigenschaft 1). Gefehlt hat
  kein Trigger, sondern ein Ort für den Fund.

### Die Achse, die beide Modi nicht abdecken

Ein erfahrener Leser hielt eine Regelwerks-Migration für einen
Brownfield-Fall — plausibel, weil BF als „Code existiert, Doku folgt — Inventur
des Bestands" definiert ist. Der Schluss ist falsch, und die Modus-Tabelle
*lädt dazu ein*: Ihre Spalte **Trigger-Richtung** führt `Doc → Code` und
`Code → Doc`; beide Modi regeln dieselbe Achse. Eine Migration hat Harness,
ausgefüllte Artefakte und erklärte Adoption bereits — sie ist eine dritte
Beziehung, **adoptierte Norm ↔ ausgefülltes Artefakt**, und für die ist der
Freshness-Audit zuständig. §Modus pro Sub-Area benennt das jetzt.

Daraus folgt auch die Korrektur an einer naheliegenden Antwort: Bei einer
Häufung ist die **BF-Markierung nicht** das richtige Werkzeug — sie setzt
*Code führt, Doku folgt* und trifft die Achse nicht. Modul 7 sagt das jetzt an
der Stelle, an der der Werkzeug-Trichter endet.

### Zwei Nachzüge aus dem Review

- **`§Freshness-Audit` ist jetzt eine echte Überschrift** — vorher fetter
  Fließtext, auf den sechs Verweise zeigten, ohne ihn anspringen zu können.
  Alle sechs tragen jetzt einen Anker; die Phrase in `AGENTS.template.md`
  nennt die Sektion beim vollen Namen.
- **`SL-*` ist korpusweit zu `slice-<NNN>` geworden** — 90 Vorkommen in 20
  Dateien. Welle 68 hatte nur Modul 12 gezogen, weil dort eine Kurzform in ein
  Manifest-Feld geraten war; die Messung dahinter war zu eng und hinterließ
  zwei Schreibweisen für dieselbe Artefakt-Klasse. Der Baseline-Token heißt
  `slice-<NNN>`, wie `lab/example` ihn führt. Zwei Nachläufer waren nötig: die
  Dopplungs-Heuristik griff in Komposita (`Folge-Slice slice-027` →
  `Folge-slice-027`), und die Typ-Präfixe `SL-CO-AUDIT-*` / `SL-RC-*` fielen
  durch ein Muster, das Ziffern direkt hinter `SL-` erwartete.

### Kleinigkeit mit Vorgeschichte

Das CHANGELOG zu Welle 27 hielt fest, die Gegenmaßnahme sei bisher „nur als
Listen-Phrase" benannt gewesen. Die Prozedur kam damals — die Phrase in
`AGENTS.template.md` zeigte seither weiter auf nichts. Sie hat jetzt ihr Ziel.

## Welle 68 — 2026-08-08 · Präfixe, die niemand referenzieren konnte

Aus einer Nutzer-Frage, ob `spec/spezifikation.md` eigene IDs trägt. Die
Antwort war im Korpus dreimal verschieden gegeben:
[`referenz-richtung.md`](kurs/de/grundlagen/referenz-richtung.md) führte
`SPEC-*`/`ARC-*` als Baseline-Mechanismus, [Modul
2](kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md) als deklarationspflichtige
Adaption in einer `MR-001`, und die `MR-000`-Default-Liste in
[`conventions.template.md`](lab/templates/harness/conventions.template.md) kannte
beide Präfixe gar nicht.

Der Beleg, auf den sich die Baseline-Behauptung berief, belegte ihr Gegenteil:
`referenz-richtung.md` schickte zum „Bootstrap-Beleg in `modul-02`" — und dort
stand „die Adaption". Wer die Modul-2-Sequenz wörtlich abarbeitete, legte
zudem eine `MR-001` ohne Abweichung an; ein Adaptions-Eintrag, der keine
benannte Baseline-Regel ersetzt, ist laut Vorlage aber ein **Fork**.

### Entschieden

- **`SPEC-*` und `ARC-*` sind Baseline**, keine Adaption. Das Präfix kodiert
  das Stratum; nur das Vertrags-Präfix (`LH`, `HSM`, `GG`) wird pro Repo
  gewählt.
- **Beides sind Struktur-IDs, keine Anforderungs-IDs.** Sie machen
  adressierbar, was im Stratum ohnehin steht, und verpflichten zu nichts —
  daran hängt, dass die Sicht derivativ bleibt und die Spezifikation nicht
  anfängt zu versprechen.
- **Referenziert wird die ID, ersatzweise der Abschnitt.** Der `§`-Anker
  bleibt der vorgesehene Rückfallweg; eine erzwungene ID über Fließtext
  benennt nichts, sie nummeriert nur.

### Regelwerk

- **§ID-Schema als Klammer trägt das Straten-Modell** — vier Kennungs-Arten mit
  Stratum und Charakter. Vorher stand dort nur die Vertrags-Reihe, weshalb der
  Zeiger aus §Referenz-Richtung (SDP) ins Leere lief.
- **`<PREFIX>-FA-<NN>.<Buchstabe>` ist erstmals in der Quelle verankert.** Das
  Schema stand bis hierher nur in `spezifikation.template.md` und berief sich
  auf einen Abschnitt, der es nicht kannte — Template-Drift ohne Quell-Anker.
- **Die Referenz-Matrix adressiert Technik und Sicht über Kennungen** —
  *Technik-ID* (`SPEC-*` oder `<PREFIX>-FA-*.<Buchstabe>`) und *Sicht-ID*
  (`ARC-*`), ersatzweise der `§`-Anker. Das gilt für ADR und Slice; der
  **Carveout bleibt beim Abschnitt**, weil er ein Stück Geltung ausklammert,
  das selten auf genau einer Kennung sitzt.
- **Modul-2-Schritt 3 legt keine `MR-001` mehr an.** Das Bootstrap-Repo weicht
  nirgends ab; die ID-Schema-Deklaration ist Teil der `MR-000`-Aussage, die
  Index-Tabelle bleibt leer.

### Templates und Beispiel

- `conventions.template.md` führt `SPEC-<NNN>`/`ARC-<NNN>` in der
  `MR-000`-Default-Liste und trennt das frei wählbare Vertrags-Präfix von den
  festen Stratum-Präfixen.
- `spezifikation.template.md` vergibt `SPEC-*` in §2 bis §6 — auch in §4, wo
  der Fehler-Code das Laufzeit-Symbol bleibt und die Kennung die *Festlegung*
  darüber benennt; sonst hätte eine ADR zur Fehlerbehandlung kein Ziel.
- `architecture.template.md` vergibt die Komponenten-`ARC-*` in §1 und die
  Schnittstellen-`ARC-*` in §3. Die Schichten-Tabelle in §2 verweist nur —
  eine Schicht ist eine Gruppierung über Komponenten, keine eigene Sache, und
  ein Repo mit zwei Komponenten in einer Schicht hätte sonst Komponenten ohne
  Kennung.
- `lab/example` zieht nach: Kennungen in beiden Spec-Dateien, und drei ADRs
  nennen im `Schärft:`-Feld jetzt die Kennung statt des Abschnitts. Sektionen,
  die keine Kennungen vergeben, behalten den `§`-Anker — der Rückfallweg im
  Betrieb, nicht ein Rückstand.

### Nachgezogen im Review

Ein Review des ersten Wurfs fand neun Widersprüche, die kein Gate sehen kann.
Die tragenden drei: Die Quelle zählte Fehler-Codes unter das, was eine `SPEC-*`
trägt, während die Vorlage für dieselbe Sektion das Gegenteil vorschrieb; die
`ARC-*`-Vergabe hing an der Schichten-Tabelle und war nur erfüllbar, solange
Komponente und Schicht 1:1 fallen; und `ARC-*` war als „Komponente **oder
Schnittstelle**" definiert, ohne dass je eine Sektion einer Schnittstelle eine
Kennung gab. Dazu: Die Matrix nannte für das Technik-Stratum nur `SPEC-*` und
übersah die Verfeinerungs-IDs — sie sagt jetzt *Technik-ID* und *Sicht-ID* und
löst die Begriffe unter der Matrix auf.

Eine zweite Runde fand, was die Fixes selbst angerichtet hatten. Drei davon
sind lehrreich:

- **Nummernblöcke waren eine unbelegte Konvention.** Templates und Beispiel
  hatten Blöcke je Sektion encodiert (§3 → `SPEC-010`, §5 → `020`), die keine
  Quelle lehrt — und nach dem Nachtragen von §4 nicht einmal monoton waren.
  Jetzt wird **fortlaufend je Datei** gezählt, und §Vergabe trägt die Regel:
  Struktur-IDs sind dort als dritte Klasse geführt (*viele pro Datei*, kein
  Bereichssegment), neben „eine Datei" und „je eine eigene Datei".
- **Das ADR-Template zog nicht mit.** Sein `Schärft:`-Feld zeigte weiter nur
  die `§`-Form, während die Beispiel-ADRs migriert waren — genau die
  Drift-Richtung, die die Normhierarchie verbietet.
- **Der Bereichssegment-Satz erklärte zur Pflicht, was §Vergabe ausnimmt.**
  §Vergabe leitet den Zählraum aus der *Ablage* her: `LH-*` lebt in einer
  Datei und kollidiert laut. Der neue Text nennt jetzt diese Herleitung,
  statt eine Pflicht zu behaupten.

Dazu: `LH-FA-IDX-003` hatte keinen Verfeinerungs-Abschnitt, worauf `ADR-0012`
zeigen konnte — das Beispiel hat ihn bekommen, statt den Zeiger auf die
Verfeinerung einer *anderen* Anforderung stehen zu lassen.

## Welle 67 — 2026-08-02 · Ein Pflichtfeld, das der Adopter nicht füllen kann

Aus einer Nutzer-Frage nach der Metapher „Wetter im Container" in
[Modul 12](kurs/de/04-qualitaet/modul-12-replay-evaluierung.md). Die Metapher war
das kleinere Problem. Dahinter lag, dass das Modul durchgehend ein
**Inferenz-Modell** voraussetzte — Modellversion, Provider-Status,
Sampling-Parameter —, während ein adoptierendes Repo oft gar kein LLM hat,
sondern ein **Domänen-Modell**. `grid-gym` als Referenz-Konsument ist genau
dieser Fall: reale Seeds über `RandomPort`, kein Provider, keine Modellversion.

Die Probe darauf: `model.seed` stand als Selbstcheck-Pflichtfeld neben dem
Beispiel-Modell `claude-opus-4-7` — und die Anthropic Messages API kennt keinen
Seed-Parameter. Das Modul machte ein Feld zur Pflicht, dessen Wert für sein
eigenes Beispiel auf nichts zeigt. Umgekehrt trägt beim Domänen-Modell der Seed
und die Modellversion fehlt. Beide Adopter-Formen konnten die Regel nie
vollständig erfüllen.

### Entschieden

- **Domänen-Modell im Vordergrund, Inferenz-Modell als zweites Beispiel.**
  „Modell" heißt im Modul jetzt einmal generisch der *nicht-deterministische
  Kern* des Produkts; alles Weitere hängt an dieser einen Definition.
- **Modul 12 baut das Set, Modul 13 setzt es durch.** Die Aufzählung der
  Domänen-Gates (`test-determinism`, `test-replay`, `test-fault`) stand in
  beiden Modulen; sie gehört zu Modul 13, das sie definiert und an Adopter
  ausliefert. Modul 12 trägt nur noch den Zeiger, Modul 13 einen Gegenzeiger
  für die Wort-Kollision (`test-replay` ist dort das Gate, hier die Praxis).

### Regelwerk

- **`model.seed` und `model.version` sind nicht mehr beide unbedingt Pflicht.**
  Pflicht ist *je ein Feld pro Zufallsquelle des Laufs*: beim Domänen-Modell der
  Seed samt Ableitungsregel plus ein `determinism:`-Block, beim Inferenz-Modell
  die Version und der Prompt-Kontext.
- **Das Layout schreibt kein Namensmuster mehr vor.** `evals/golden/welle-NN-baseline/`
  war für ein Repo, das Slices ohne Wellen führt, nicht erfüllbar. Pflicht ist
  ein Verzeichnis je Set.
- **Die Erwartungs-Regel nennt beide Formen** — Schwellen und Invarianten neben
  `must_include`/`tool_calls`. Vorher stand dort nur die Inferenz-Form.
- **Drift-Diagnose Rang 2** belegt zusätzlich `determinism:`; ohne das findet
  die Reihenfolge den Fall nicht, den das Modul an ihr vorführt.
- **Der Manifest-Abschnitt zeigt die Form, statt sie zu beschreiben.** Er
  beschrieb ein YAML-Dokument in Prosa — zehn Feldnamen, keine sichtbare
  Struktur, dazu wechselnde Notation (`model.seed` als Punkt-Pfad neben
  `determinism:` als Block). Neu: zwei `#### Ziel-Form`-Abschnitte mit
  Verzeichnis- und Feld-Skelett (Platzhalter, keine Beispieldaten — „Form ja,
  Auszug nein") und eine Tabelle *Feld · Was hineingehört · Wozu*. `inputs_ref`
  und `recorded_at` standen vorher als Pflichtfelder da, ohne dass irgendwo
  stand, was hineingehört.
- **Die Fallunterscheidung Domänen-/Inferenz-Modell steht vor den Regeln.** Sie
  stand als Bullet `**Variante Inferenz-Modell:**` mitten in der Regel-Liste und
  machte dort einen zweiten kompletten Bauplan auf — eine Liste von Einzelregeln,
  in der ein Element plötzlich das ganze Konstrukt neu aufsetzt. Beide Formen
  stehen jetzt oben nebeneinander, die Regeln darunter gelten für beide. Der
  Provider-Status-Zusatz ist dabei zur Drift-Diagnose-Tabelle gewandert, wo er
  hingehört; er hing im Inferenz-Bullet, vier Bullets vor der Tabelle.
- **Vier operative Regeln aus der Quelle nachgezogen, die beim Auszug gefehlt
  hatten.** Gefunden von einer Bauprobe (Adopter baut ein Golden Set allein aus
  dem Split, ohne Kurszugriff): die **Fallauswahl-Regel** — jeder Fall fängt
  eine andere Fehlerklasse, drei Varianten desselben Happy Path sind ein
  Demo-Set, und der Boundary-Fall ist meist der einzige, der `determinism:`
  überhaupt auslöst. Ohne sie war ein blinder Sensor split-konform. Dazu die
  **Kopplung `inputs/`↔`expectations/` über den Dateinamen** (die Regel „je ein
  Gegenstück" war ohne sie mechanisch nicht einlösbar), **„Ins Manifest gehört
  nur, was der Lauf selbst noch tut"** und die Eskalation **zwei rot → Carveout
  plus Folge-Slice**, mit der der Anschluss an Modul 7 zurückkommt. Ergänzt
  außerdem `slice:` als Traceability-Anker, `evals/golden/` als Ort und die
  Inhalts-Regel für das Set-eigene `CHANGELOG.md`.

### Geändert

- **Zwei Worked Examples statt eines geflickten.** A baut ein Manifest für die
  Ranking-Stufe, B dasselbe für ein Inferenz-Modell (ohne `seed:`, mit
  `prompt_context:`-Hashes). A ist neu geschrieben, nicht umetikettiert: Der
  Tie-Break trägt von der Engage über `case-002` und das konkrete Rot in
  Schritt 5 bis zum Lerneintrag in Schritt 7, und die Diagnose-Tabelle wird
  angewendet statt nur aufgestellt.
- **Die Drift-Rate rechnet am eigenen Fall** (1 ÷ 3) und benennt die Grenze des
  Minimal-Sets: Drei Fälle sichern die Abdeckung, taugen aber nicht als Nenner.
- **„Wetter im Container" ersetzt** durch die Aufzählung, die man abarbeiten
  kann — Zeit, Locale, Env-Variablen, Netz, sichtbare CPU-Zahl. Die Metapher war
  nirgends aufgelöst, auch nicht in `begriffe.md`, und stand ausgerechnet in der
  Glossar-Tabelle.
- **„pro Welle" als Rotations-Kadenz** durch die Closure ersetzt (Slice oder
  Welle) — an fünf Stellen in Modul und Lösung. Ein Slice kann ohne Welle
  bestehen.
- **Anbieter-Aussagen datiert** (`Stand 2026-08`) statt undatiert stehen zu
  lassen; sie tragen den Punkt, altern aber ohne Sensor.
- **`begriffe.md`:** *Drift* und *Determinismus* ergänzt. Das Mini-Glossar
  verwies für vier Begriffe auf „Volldefinitionen" dort; zwei davon fehlten.
- **Vier Quell-Defekte behoben, die der Split nur geerbt hatte** — gefunden von
  der Bauprobe, die sie korrekt *nicht* dem Split angelastet hat. (1) Die
  Determinismus-Regel fordert „Seed **und** ihre Ableitungsregel", das
  Worked-Example-Manifest zeigte `seed: 42` und kein Feld dafür;
  `seed_derivation` steht jetzt in `determinism:`, wo es hingehört — wie aus
  dem Seed die Werte je Fall entstehen, ist selbst eine Regel ohne
  Versionsfeld. (2) Dieselbe Regel verlangt Zeit, Locale, Netz und sichtbare
  CPU-Zahl; auch dafür gab es kein Feld. Neu `runtime.env` und
  `runtime.timestamp_masking`, mit der Begründung, die vorher nirgends stand:
  Der Image-Hash pinnt die Toolchain, nicht den Laufzeit-Zustand — der
  entsteht erst beim Start des Containers. (3) Die Fall-Dateien hatten keine
  gelehrte Form; `id` · `kind` · `bezug` sind jetzt gesetzt, wobei `bezug` die
  Traceability auf das Akzeptanzkriterium trägt. Das Lab-Fixture führte diese
  Felder längst — gelehrt wurden sie nie. (4) Die Drift-Diagnose-Tabelle nennt
  auf Rang 2 zusätzlich `prompt_context:`; beim Inferenz-Modell ist es die
  Hauptdriftquelle und fehlte in der Belegquelle.

### Lab

- Manifest-Kopf von `welle-1-baseline`: Verweis auf „Modul 11" korrigiert (die
  Renummerierung von Welle 8 war dort nie angekommen) und der Fall benannt —
  gemischt, weil das Embedding im Replay mitläuft.
- README-Anker auf Worked Example A nachgezogen.
- `welle-1-baseline/manifest.yaml` um `determinism.seed_derivation`,
  `runtime.env` und `runtime.timestamp_masking` ergänzt — die Felder, die
  Modul 12 jetzt lehrt. `make replay` prüft weiter nur die Struktur.

### Review

Sechs Review-Durchgänge über die eigene Arbeit, je mit Befunden — die letzten zwei
als externe Reviews samt Bauprobe:

- **Runde 1** — Widerspruch im selben Abschnitt (der Springer-Satz nannte noch
  „Modellversion + Seed"), und der Split paraphrasierte, statt operativ
  quelltreu zu übernehmen.
- **Runde 2** — die konkret gewordene Schritt-5-Rechnung widersprach dem
  Drift-Raten-Beispiel drei Absätze weiter; `SL-031` war doppelt belegt.
- **Runde 3** — **die Lösungsschicht wurde nur teilweise nachgezogen.** Die
  Musterlösung zu Übung 1 beantwortete weiter die alte Aufgabe
  (`summarize_doc`), die zu Übung 2 fuhr das Drehbuch „Modell A → Modell B".
  Wer die neue Aufgabe löste und abglich, fand ein anderes Szenario.
- **Runde 4** — Review auf Anforderung, gegen den fertigen Stand. Sieben
  Befunde, drei davon adopter-relevant: Der Verweis „Layout von A, Gewichtung
  von B" auf das Lab-Set **stimmte nicht** — das Fixture trägt `model.seed` und
  `determinism:`, also zwei von drei B-Markern in ihrer A-Ausprägung; B-artig
  ist nur der Messgegenstand. Im Regelwerk stand die Drift-Rate ohne die
  Einschränkung aus der Quelle als schwellenfähig da, zwei Bullets unter der
  Pflicht zu drei Fällen — ein Adopter, der nur den Split liest, baut genau die
  Kombination, die das Modul ausschließt. Und `prompt_context:` war das einzige
  Feld, das der Split nicht namentlich nannte; die Pointe *als Hash* fehlte, wer
  ihm folgte, fror den ganzen Prompt ein. Die übrigen vier: `CHANGELOG.md`
  fehlte im Skelett von Schritt 1, obwohl der Split sie zum Layout zählt;
  „Beobachtung: dreimal grün" passte nicht zum Ablauf der Übung (die
  Musterlösung läuft nach *jeder* Verfälschung, die Aufgabe sammelte sie);
  „drei Felder" zählte vier auf, weil die dritte Position eine Familie ist; und
  der Split zitierte „zwei rot", wo die Quelle „einer rot" argumentiert.

- **Runde 5** — zwei unabhängige Reviews gegen den Commit aus Runde 4: einer auf
  Normkonformität und Quelltreue, einer als **Bauprobe** (ein Adopter baut ein
  Golden Set für einen Routenplaner, nur aus dem Split, ohne Kurszugriff, und
  protokolliert jede Stelle, an der er raten musste). **Der Runde-4-Commit hatte
  selbst fünf Fehler eingeführt:** Ein neuer Merksatz („nicht die *Art* des
  Kerns") negierte wortgleich die Rubrik-Zelle 70 Zeilen weiter — die derselbe
  Commit angefasst hatte. Die Übungs-Korrektur („nach jeder der drei
  Änderungen") passte nicht zur Musterlösung, die drei Läufe bei *zwei*
  Änderungen plus einem Baseline-Lauf fährt. Und drei Quell-Aussagen waren beim
  Umbau paraphrasiert: „`prompt_context:` *statt* `determinism:`" zu „der Rest
  bleibt", „trägt die Hauptlast" zu „ist die Zufallsquelle" (eine Version ist
  keine Zufallsquelle), „viele *Inferenz*-APIs" zu „die API". Die Bauprobe fiel
  durch — siehe Regelwerk-Block oben.

- **Runde 6** — Gegenprobe: dieselben zwei Reviewer noch einmal gegen die
  Runde-5-Korrekturen, die Bauprobe mit demselben Szenario. Ergebnis: Die neun
  gemeldeten Befunde sind sachlich zu, **aber die Korrektur von Befund 3 hat
  einen neuen Defekt erzeugt.** „`prompt_context:` tritt an die Stelle von
  `determinism:`" ist quelltreu zu WE B Punkt 3 — und bricht den Mischfall, den
  der Split zwei Absätze davor selbst einführt. Die Quelle sagt an beiden
  Stellen Unterschiedliches: `:303` „statt `determinism:`", `:327` „stehen in
  `determinism:`, nicht in `prompt_context:`" — bei einem Inferenz-Modell. Der
  Split deckt jetzt beide Fälle ab (rein → an Stelle von; gemischt → beide
  Blöcke). Dazu vier Regel-Anteile zurückgenommen, die die Quelle nicht setzt:
  `slice` „oder zuletzt geändert" (das Worked Example lässt den Anker stehen und
  führt Änderungen im `CHANGELOG.md`), „nicht über eine Liste im Manifest",
  „immer gleich lang" (das ist eine Eigenschaft, die das *Lab-Target* prüft,
  keine Manifest-Regel) und die Umnummerierungs-Regel — die stand nur im
  Lab-Fixture, und aus dem Beispiel zieht der Split keine Regeln.
  `evals/golden/` ist von Vorschrift zu „üblicherweise" abgeschwächt, weil die
  Quelle den Pfad zeigt, aber nicht setzt.

**Konsequenz aus Runde 6:** Zwei Reviewer mit verschiedenen Fragen können
einander widersprechen, und beide recht haben — der Quelltreue-Prüfer bestätigte
genau die Formulierung, die der Bauprobe-Prüfer als Defekt fand. Das ist kein
Widerspruch im Urteil, sondern einer *in der Quelle*, den erst die zweite Frage
sichtbar macht. Wo das passiert, ist der Fix eine Formulierung, die beide
Quell-Stellen abdeckt — nicht die Wahl einer der beiden.

**Konsequenz aus Runde 5:** Eine *Korrektur*-Runde am selben Abschnitt braucht
denselben Gesamt-Durchgang wie eine Neufassung. Wer nur die korrigierte Stelle
liest, sieht den neuen Widerspruch zur unveränderten Stelle nicht — hier zur
Rubrik, die im selben Commit angefasst wurde. Und: Die Bauprobe hat in einem
Durchgang gefunden, was vier Lese-Runden nicht gefunden haben. Der Unterschied
ist die Frage — Lesen prüft „stimmt das?", Bauen prüft „reicht das?".

**Konsequenz aus Runde 3 für den Steering Loop:** Bei einem *Szenario-Wechsel* reicht es
nicht, in der Lösung die geänderten Stellen zu suchen — sie ist ganz zu lesen.
Die Regel „Satelliten mitziehen" hat nicht gefehlt, sie wurde unvollständig
angewendet.

**Kein Sensor.** `docs-check` prüft Links und Form, `alignment-check` prüft
Bloom-Marker und Aktivierungs-Verbstämme — keines prüft, ob eine Musterlösung
dieselbe Aufgabe beantwortet, die die Übung stellt. Ein Bezeichner-Abgleich
Modul↔Lösung wurde über alle 17 Paare probiert und verworfen: überwiegend
Fehlalarme, weil eine Musterlösung konkreter werden *soll* als die Aufgabe. Die
Prüfung bleibt das Lesen beim Wellen-Abschluss.

**Der Split war nicht lesbar — und keine der vier Runden hat es gemerkt.** Der
Befund kam beim Gegenlesen von außen: „das ist nicht zu verstehen", präzisiert
zu zwei Stellen — `**Variante Inferenz-Modell:**` mitten in der Regel-Liste und
Pflichtfelder, die nirgends erklärt werden. Beides stand seit Welle 67 so da und
hat vier Review-Durchgänge überlebt, weil jede Runde *Aussagen* geprüft hat
(stimmt die Regel? deckt sie sich mit der Quelle?), keine die *Form* (kann ein
Adopter danach ein Manifest bauen, ohne den Kurs zu lesen?). Die Runden 1–4
haben denselben Abschnitt viermal gelesen und dreimal geändert.

**Konsequenz:** Beim Split ist die Prüffrage nicht „ist das richtig?", sondern
**„reicht das zum Bauen?"** — der Kurs erklärt Felder im Fließtext eines Worked
Example, der Split hat diesen Kontext nicht und muss die Form darum *zeigen*.
Der Regelwerk-Split ist der einzige Ort, an dem ein strukturiertes Konstrukt
ohne Template auskommen musste; alle anderen (Slice, ADR, Carveout, Lastenheft)
zeigen mit `### Ziel-Form:` auf `../templates/`. Ein
`templates/evals/golden/manifest.template.yaml` bleibt die offene Option — sie
würde das Skelett aus dem Split herausziehen, kostet aber Bundle-Fläche und ist
eine eigene Entscheidung.

**Ein Falsch-Positiv im `alignment-check`, notiert statt gefixt.** Runde 4 fand,
dass LZ 4 (Überfitting *erkennen*, Rotation *entwerfen*) keine Übung hat — der
Check meldet es trotzdem nicht, weil `verbStem("entwerfen")` = `entwer` im
Übungen-Block auf den Titel von Übung 1 trifft („Mini-Golden-Set *entwerfen*"),
die ausdrücklich LZ 2 aktiviert. Das Skript kommentiert nur das umgekehrte
Risiko (Ablaut-Falsch-*Negative*). Die Lage selbst ist vertretbar — LZ 4 zeigt
sich über Wochen an einem benutzten Set, nicht an einem Lab-Lauf; der
Lab-Grenze-Block sagt das jetzt hin, statt zu schweigen. Ein schärferer
Verbstamm-Abgleich (Marker schlägt Stamm) bleibt eine Option, kein Slice: Er
würde in allen 17 Modulen neu triagiert werden müssen.

### Zahlen

`d-check` 187 Dateien · `docs-check` 189 · `alignment-check` 0 WARN — alle drei
0 Befunde.

**Bruch für Konsumenten:** Ein vendortes Regelwerk, das `model.seed` und
`model.version` als unbedingte Manifest-Pflichtfelder übernommen hat, erfüllt
die Regel nicht mehr wörtlich — sie verlangt jetzt je ein Feld pro
Zufallsquelle. Ebenso entfällt das Namensmuster `evals/golden/welle-NN-baseline/`;
bestehende Verzeichnisnamen bleiben gültig, sie sind nur nicht mehr vorgeschrieben.

## Welle 66 — 2026-08-02 · Drei, wo acht stehen

Aus einer Nutzer-Frage an [`lab/regelwerk/README.md`](lab/regelwerk/README.md).
Welle 63 teilte `konventionen.md` auf sechs Seiten, Welle 64 entfernte die
Weiterleitung — der **Index** beider READMEs zog jedes Mal mit. Die
**Fließtext-Zählung** darüber nicht.

### Korrigiert

- **„die drei Grundlagen-Abschnitte (Konventionen, Klassifikation,
  Durchsetzungsschicht)"** in [`lab/regelwerk/README.md`](lab/regelwerk/README.md)
  (Kopfabsatz und Blockquote) und [`lab/README.md`](lab/README.md). Das
  Verzeichnis liefert **acht** Splits, und die Index-Liste zwölf Zeilen weiter
  unten in derselben Datei zählt sie auch alle auf — die Datei widersprach sich
  selbst. „Konventionen" benannte dabei einen Abschnitt, den es seit Welle 64
  nicht mehr gibt.
- **Die Zahl fällt weg, statt korrigiert zu werden** (*„und die
  Grundlagen-Abschnitte"*). Eine zweite Zählung im Fließtext neben der
  maßgeblichen Index-Liste ist dieselbe Drift-Klasse wie die zwei Verzeichnisse
  aus Welle 64: Sie altert bei jedem Split mit, und niemand merkt es. Der
  Zeiger bleibt, der Bestand steht nur noch an einer Stelle.
- **Kein Sensor.** Das Doku-Gate prüft Link-*Ziele*, keine Mengenangaben in
  Prosa. Wie bei den Link-Texten aus Welle 64 fällt das nur beim Lesen auf.

Kein Bruch für Konsumenten: reine Prosa-Korrektur, kein Pfad, kein Anker, keine
Regel betroffen.

## Welle 65 — 2026-08-01 · Wer vergibt die nächste Nummer?

Aus einer Nutzer-Frage: Fortlaufende Kennungen funktionieren, solange **ein**
Mensch am Repo schreibt. Was passiert bei mehreren gleichzeitig?

### Hinzugefügt

- **[§Vergabe: woher die nächste Nummer kommt](kurs/de/grundlagen/source-precedence.md)**
  unter §ID-Schema als Klammer. Der Abschnitt beginnt mit der Diagnose, nicht
  mit der Regel: **Die Kollisionsfläche ist nicht die Nummer, sondern die
  Ablage.** `LH-*` lebt in *einer* Datei — zwei gleichzeitige Anforderungen
  erzeugen einen Git-Konflikt, laut und sofort. ADR, Slice, Welle und Carveout
  sind je eine eigene Datei: Zwei Entwickler, die unabhängig `0012` ziehen,
  erzeugen `0012-cache.md` und `0012-index.md`, Git meldet nichts, und im Repo
  stehen zwei Artefakte unter derselben Kennung.
- **Der Zählraum ist die Sub-Area** — `ADR-IDX-0004`, `slice-AUTH-007`. Keine
  neue Taxonomie: Es sind die Sub-Areas, die `harness/conventions.md` ohnehin
  deklariert. Die tragende Eigenschaft ist **lokale Ableitbarkeit** — wer in
  `IDX` arbeitet, sieht im eigenen Checkout, was vergeben ist, ohne Absprache
  und ohne Schreibzugriff auf den Hauptzweig. Das folgt aus dem
  Traceability-Constraint (*„ein Commit-Hook prüft, dass die Nachricht
  mindestens eine ID enthält"*): Wer die Kennung erst beim Landen bekommt, hat
  sie im entscheidenden Moment nicht.
- **Die Grenze steht dabei**, statt weggelassen zu werden: Zwei Entwickler in
  *derselben* Sub-Area kollidieren weiterhin — und das ist Absicht, sie
  entscheiden gleichzeitig über denselben Bereich. Das Schema verwandelt einen
  stillen Merge-Unfall in ein inhaltliches Signal; es beseitigt ihn nicht. Ein
  Personen- oder Branch-Segment gäbe die Garantie, altert aber mit der Person
  und sagt dem Reviewer nichts.
- **Kein Sensor.** Eindeutigkeit prüft heute kein Modul des Doku-Gates. Das
  steht so da, statt einen Gate zu behaupten.

### Geändert

- **Das Segment ist kein Default, sondern eine Deklaration.** Ein Repo mit
  einem schreibenden Menschen fährt mit dichten Nummern besser; die Wahl gehört
  in die ID-Schema-Deklaration in `harness/conventions.md`, wo `<PREFIX>-FA-*`,
  `ADR-<NNNN>` und `CO-<NNN>` ohnehin festgelegt werden. Damit bleibt die Regel
  **additiv** — keine umbenannte Datei, kein Layout-Bruch.
- **Vier Vorlagen** tragen die Wahl: `conventions.template.md` (`MR-000`
  deklariert bei mehreren Schreibenden auch den Zählraum), `lastenheft`,
  ADR und Slice (Dateiname-Hinweis auf die Bereichsform).
- **Das Beispiel-Repo beruft sich auf die Norm, statt sie zu erfinden.**
  `lab/example/spec/lastenheft.md` hatte das Bereichskürzel seit `v0.4.0`
  **selbst deklariert**, als wäre es eine Repo-Eigenheit — der Kurs benutzte es
  in Lösungen und Modul 15, ohne es je zu definieren. Die Drift lief in der
  verbotenen Richtung (Beispiel → Lehre) und ist damit zu.

### Korrigiert

- **Die sechs Split-Dateien aus Welle 63 waren eine Ebene zu flach.** Das
  Regelwerk führt `##` Titel / `###` Abschnitt / `####` Unterabschnitt; die
  neuen Dateien hatten Titel *und* Abschnitte auf `##`. Kein Link brach dabei —
  Slugs entstehen aus dem Text, nicht aus der Ebene.

## Welle 64 — 2026-08-01 · Der Wegweiser fällt, und das Lastenheft bekommt den Fall, den es nicht kannte

Zwei Fäden, die aus Welle 63 herausfielen — der eine schließt sie ab, der
andere kam aus einem Adopter-Repo.

### Entfernt

- **Die Weiterleitung `konventionen.md` entfällt** (Quelle und Spiegel). In
  Welle 63 blieb sie stehen, damit der Split additiv ist; danach zeigte im
  ganzen Repo nur noch **eine** Zeile auf sie — der README-Index. Sie war
  damit kein Verzeichnis mehr, sondern ein zweites neben dem README, und die
  READMEs beider Seiten führen die sechs Seiten ohnehin. Zwei Verzeichnisse
  derselben Dateien sind die Drift-Klasse, gegen die dieses Repo gebaut ist.

### Hinzugefügt

- **Personalunion von Auftraggeber und Entwickler**
  ([§Spec-Stratifizierung](kurs/de/grundlagen/source-precedence.md)). Der Kurs
  kannte nur den *externen* Change Request — in einem Repo, das sein eigener
  Auftraggeber ist, verlangt die Regel damit etwas, das es nicht geben kann.
  Der Beleg liegt im eigenen Haus: `lab/example/spec/lastenheft.md` steht auf
  `Accepted` und trägt vier Versions-Bumps ohne einen einzigen CR.

  Neu: *Was die Regel trägt, ist nicht die **Externalität**, sondern die
  **Trennung von Entscheidung und Umsetzung**.* Fallen die Rollen zusammen,
  fehlt nur die Ticket-Form; der Träger ist dann der **Commit** — ein
  angenommener CR ändert in einem eigenen Commit ausschließlich das Lastenheft
  und liegt **vor** dem Slice, der ihn umsetzt. Ablesbar an
  `git log -- spec/lastenheft.md`. Mit der Grenze dazu: Die Hard Rule bleibt,
  dass keine interne Quelle `LH-*` ändert — und **kein Sensor prüft die
  Commit-Form**, das bleibt ein Review-Griff.

### Geändert

- **112 Link-Texte in 43 Dateien.** Der Split hatte die Link-*Ziele*
  umgehängt, die *Beschriftungen* nicht: `[konventionen.md](begriffe.md#…)` —
  der Leser sieht eine Datei, landet in einer anderen. Kein Gate meldet das,
  der Link löst ja auf.
- **18 Klartext-Zeiger** in Templates und Regelwerk-Splits (*„Baseline-Regelwerk
  `grundlagen-konventionen.md` §Referenz-Richtung"*) auf ihre Zielseite gesetzt.
  Sie stehen im **Rumpf** und wandern damit in jedes Adopter-Artefakt.
- **Tombstones** für die zwei entfernten Dateien in `.d-check.yml`: Die
  Review-Reports zitieren sie mit Zeilennummern als historischen Beleg und
  werden dafür nicht editiert — dieselbe Mechanik wie für `agents-regelwerk.md`
  seit Welle 24.

**Bruch für Konsumenten:** Die Dateien `kurs/de/grundlagen/konventionen.md` und
`regelwerk/grundlagen-konventionen.md` **entfallen ersatzlos**. Wer einen
Klartext-Zeiger der Form *„`grundlagen-konventionen.md` §Source Precedence"* in
einem ausgefüllten Artefakt stehen hat, findet die Datei nicht mehr — er zeigt
ins Leere, und **kein Gate fängt das**. Nacharbeit: `grep -rl
'grundlagen-konventionen'` über das eigene Repo, dann auf die Zielseite setzen —
`begriffe` · `source-precedence` · `referenz-richtung` · `harness-dateien` ·
`bootstrap` · `traceability`. Das Verzeichnis aller sechs steht in
`regelwerk/README.md`.

## Welle 63 — 2026-08-01 · Die Konventionen verlassen die eine große Datei

Direkte Folge von Welle 62, am selben Tag: Dort hat der Adaptions-Block den
Pflicht-Lesepfad verlassen, hier tut es das Konventionen-Regelwerk selbst.
Derselbe Befund eine Ebene höher — und derselbe Schnitt.

### Geändert

- **`grundlagen-konventionen.md` (1099 Zeilen) liegt auf sechs Seiten.** Die
  Datei war **29 %** des ganzen Regelwerks, in einem Bundle, dessen Index
  verspricht: *„Pro Abschnitt eine Datei, damit ein Agent einen einzelnen
  Abschnitt laden kann, ohne das ganze Regelwerk im Kontext zu halten."* Für
  19 der 20 Dateien stimmte das, für diese nicht. Der Schnitt folgt dem
  **Gegenstand**:

  | Seite | Zeilen | Inhalt |
  |---|---:|---|
  | [Referenz-Richtung (SDP)](kurs/de/grundlagen/referenz-richtung.md) | 341 | inkl. Spec-Straten |
  | [Harness-Bootstrap](kurs/de/grundlagen/bootstrap.md) | 234 | Sub-Area, Modus, Trigger-Klassen |
  | [Die Harness-Dateien und ihre Form](kurs/de/grundlagen/harness-dateien.md) | 193 | Verzeichniskonvention, Template-Schichtung, `harness/README.md`, Konventionsspeicher |
  | [Source Precedence](kurs/de/grundlagen/source-precedence.md) | 169 | + Spec-Stratifizierung, ID-Schema |
  | [Traceability-Constraint](kurs/de/grundlagen/traceability.md) | 119 | |
  | [Kernbegriffe und Trennschärfen](kurs/de/grundlagen/begriffe.md) | 53 | |

  Die größte Konventionen-Seite liegt damit **unter** `modul-02` (362) — die
  Familie ist im Band des übrigen Regelwerks angekommen. Geschnitten wurde in
  der **Quelle**; das Regelwerk spiegelt, sonst trüge es Struktur ohne
  Quell-Verankerung.
- **Vier Überschriften eine Ebene hoch.** `Referenz-Richtung (SDP)` (339
  Zeilen), `Spec-Stratifizierung` und `ID-Schema als Klammer` hingen als
  Unterpunkte an `Source Precedence` — einem Abschnitt von 107 Zeilen. Vier
  gleichrangige Themen als Kinder eines von ihnen. **Kein Link brach dabei**:
  GitHub-Slugs entstehen aus dem Überschriften-*Text*, die Ebene geht nicht ein.
- **Abschnitts-Index im Regelwerk-README**, damit das Versprechen „nur den
  benötigten Abschnitt laden" auch ohne Datei-Scan einlösbar ist.

### Entschieden

- **Additiv, kein Bruch — und das Kriterium dahinter ist ein anderes als
  gedacht.** `konventionen.md` bleibt unter seinem Namen und wird **Wegweiser**:
  eine Tabelle, die je Seite die Anker nennt, die dorthin gewandert sind. Jeder
  Klartext-Zeiger (*„`konventionen.md` §Source Precedence"*) in einem
  ausgefüllten Adopter-Artefakt landet weiter — und zwar besser als vorher:
  eine Zeile statt 1099.

  Die MAJOR-Politik nennt *„Asset-Entfernung / Layout-Bruch"*. Beim Nachlesen
  der drei Präzedenzfälle ist das ein **Proxy**: `v2.0.0` beendete einen
  *Bezugsweg* (Einzeldatei per URL), `v3.0.0` änderte die *Entpack-Mechanik*,
  `v4.0.0` ließ *Zeiger ins Leere* laufen. Das gemeinsame Merkmal ist nicht,
  dass eine Datei fehlt, sondern **dass ein bestehender Zeiger nirgendwo mehr
  hinführt**. Ein Split mit Wegweiser tut das nicht — daher `v4.1.0`, nicht
  `v5.0.0`.

### Review

- **Vier Deixis-Verweise, die kein Gate sieht.** Nach dem Schnitt zeigten
  *„die §Spec-Stratifizierung **oben**"*, *„Im Fluss-Diagramm **oben**"*,
  *„…Konsumenten (**unten**)"* und *„§Konventionsspeicher (**oben**)"* über
  eine Dateigrenze. Es ist **Prosa, kein Link** — `d-check` lief die ganze Zeit
  auf 0. Sechs weitere `oben`/`unten` einzeln geprüft und stehengelassen: Sie
  zeigen weiter innerhalb ihrer Datei. Deixis gehört beim Split umgehängt wie
  ein relativer Link, nur fängt sie kein Sensor.
- **Fünf ankerlose Verweise geschärft** — sie landeten auf dem Wegweiser und
  funktionierten, meinten aber je einen bestimmten Abschnitt (Modul 1 die
  Verzeichniskonvention, Modul 4 das Glossar).
- **Kein Inhaltsverlust**: Wortbestand der sechs Seiten gegen den alten Stand
  verglichen — verloren ist nur die Präambel, die der Wegweiser ersetzt.

### Zahlen

`d-check` 189 statt 177 Dateien · `bundle-check` 49 statt 43 · beide 0 Befunde.

## Welle 62 — 2026-08-01 · Drei Straten sind Pflicht, die Matrix wird 8×8, und der Adaptions-Block verlässt den Lesepfad

Eine Welle aus Nutzer-Fragen, nicht aus einem Review-Lauf. Jede Frage traf eine
Stelle, an der eine Regel formuliert war, aber ihr Träger fehlte — oder wo ein
Beleg die Regel trug, der sie nicht tragen durfte.

### Entschieden

- **Alle drei Spec-Straten sind obligatorisch.** Der Satz *„nur Vertrag und
  Sicht sind obligatorisch"* begründete die Optionalität des Technik-Stratums
  damit, dass Repos ihre technischen Festlegungen „in Vertrag oder Sicht
  falten". Das verschiebt aber nicht Inhalt, sondern dessen
  **Änderungs-Prozess**: Im Vertrag wären die Festlegungen abnahmebindend und
  nur per Change Request änderbar, und keine ADR dürfte sie je schärfen. Ein
  Repo *kann* mit zwei Straten fahren — dann ist das eine deklarierte
  `MR-<NNN>`, nicht ein Weglassen. Der Bruch war ohnehin schon da: Modul 2
  führte alle drei längst als Gründungs-Dokumente, Modul 1 zählte ein fehlendes
  `spezifikation.md` als Lücke, die Templates lieferten neun Ränge — die
  Konventionen-Liste war der Ausreißer.
- **Fremd-Repos begründen keine Kursregel.** Der einzige Beleg für die
  Optionalität war der Stand eines anderen Repos — und zwar ein *älterer*. Ein
  Konsument, der hinterherhängt, ist ein Migrationsfall, kein Beleg. Der Grund
  ist **Drift**: Fremd-Repos entwickeln sich weiter, jeder Verweis ist ein
  Stand, keine laufende Quelle. Steht jetzt im Kopf von
  [`fallstudien.md`](kurs/de/grundlagen/fallstudien.md), damit nicht jeder der
  rund zwanzig Verweise einzeln qualifiziert werden muss.
- **Die Decken-Regel gilt auch in der Historie — für alle drei Straten gleich.**
  Zwei Fassungen standen im selben Dokument: Regel 5 nahm die Historie-Tabelle
  aus, Modul 3 nahm sie nicht aus, und die zwei Spec-Templates hatten sich je
  eine Seite ausgesucht. Entschieden wurde für die strenge Fassung, mit einer
  Begründung, die vorher keine Seite führte: **Unreparierbarkeit.** Eine
  Historie-Zeile ist ein Protokoll und wird nicht rückwirkend geändert — wird
  die dort genannte ADR superseded, zeigt die Zeile dauerhaft auf eine
  Entscheidung, die nicht mehr gilt, und kein Gate meldet es, solange die
  Sektion ausgenommen ist. Im Körper ist derselbe Zeiger reparierbar. Für
  rottende Verweise ist die Historie die *schlechteste* Stelle, nicht die
  harmloseste. Regel 5 behält ihren Sinn für die Planungs-Ebene, wo die
  Slice-ID ein stabiler Token bleibt.
- **Eine Verweis-Spalte trägt nur, was sonst nirgends im Repo steht.** Damit
  ist erklärt, warum der Vertrag eine hat (der externe CR hat kein anderes
  Zuhause) und Technik und Sicht keine — ohne auf „der Vertrag ist besonders"
  zurückzufallen. Beleg war das Beispiel-Repo: Für `MAX_TOPK` nannte die
  Historie `LH-FA-02`, der Körper `LH-QA-01` — dieselbe Kopplung zweimal,
  bereits auseinandergelaufen.
- **Der Adaptions-Block verlässt den Pflicht-Lesepfad.** `harness/conventions.md`
  liest jeder Agentenlauf. Im Beispiel-Repo waren das bei vier `MR` schon 82 von
  178 Zeilen, davon 28 für eine Adaption, die *aufgelöst* ist — nicht nur
  Kontext-Kosten, sondern ein Korrektheits-Risiko, weil ein aufgelöster Eintrag
  sich wie ein geltender liest. Neu: Index in `conventions.md`, ein Eintrag je
  Datei unter `harness/conventions/`, aufgelöste unter `conventions/done/`. Der
  Zustand ist die Verzeichnis-Position, kein Status-Feld.

### Geändert

- **Referenz-Matrix von 7×7 auf 8×8** ([§Referenz-Richtung](kurs/de/grundlagen/konventionen.md#referenz-richtung-sdp-wer-darf-wen-referenzieren)).
  Roadmap und Welle sind getrennt; die Reihenfolge folgt der Zeigerichtung
  **Slice → Welle → Roadmap**. Getrennt wird sagbar, was zusammengefasst
  unsichtbar blieb: Ein Slice nennt nie die Roadmap, und was von außen doch auf
  sie zeigt, zeigt auf einen **Meilenstein**, nie auf die Planung selbst. Die
  Zellen sind aus den Vorlagen belegt (`welle.template.md` führt Zielmeilenstein
  und Slice-Liste, `slice.template.md` das `Welle:`-Feld). Die drei Diagramme
  zeigen keine Selbstbezüge mehr — die Diagonale steht in der Matrix.
- **Source Precedence auf neun Ränge**, `spec/spezifikation.md` als Rang 2.
- **Modul 3 und 4 neu geschnitten** — `modul-03-spec.md` („Die Spec: Lastenheft,
  Spezifikation, Architektur") und `modul-04-adrs.md`; die Architektur-Sicht
  wandert von 4 nach 3. Damit ist **`Ü-09` erledigt**, der Befund aus Runde 11,
  der wegen des vendored Bundle-Layouts auf das nächste brechende Release
  vertagt war. Aufwandsangaben nachgezogen (105/75 statt 90/90 Min Lesen; die
  Blocksumme bleibt bei 360 — verschoben, nicht gewachsen).
- **`spec/` wird nicht mehr auf ein Stratum verkürzt.** Der Glossar-Eintrag
  „Spec" definierte es als *Lastenheft-Artefakt*, die Verzeichniskonvention
  nannte nur „Lastenhefte", die Konzeptkarte stellte die Architektur auf die
  ADR-Seite, und das Lebenszyklus-Bild reduzierte `spec/` auf *(was?)*.
- **`MR` benennt die Baseline-Regel, die sie ersetzt.** Die Fork-Grenze der Norm
  hängt daran, dass eine Adaption *eine benannte Regel ersetzt* — ein Feld dafür
  gab es nicht, die Norm musste auf das Freitextfeld `Adaption` verweisen.
  Folge: uneinheitlich angewandt, ein Eintrag im Beispiel nannte gar keine.
  Neu: Pflichtfeld `Ersetzt-Baseline-Regel`, als Link mit Abschnitts-Anker in
  die vendored Fassung; ein Datei-Link benennt keine Regel.
- **Der Adaptions-Block des Templates lieferte vier `MR` mit vier Rollen aus**,
  markiert nur im HTML-Kommentar — den Schritt 5 des Adoptierens löscht.
  `MR-001` war ein *Beispiel* (halb fertige Behauptung, halb Platzhalter),
  `MR-003` gar keine Adaption („keine inhaltliche Abweichung vom
  Baseline-Default") und inhaltlich doppelt. Übrig bleiben zwei Rollen ohne
  Nummernlücke; der Beispieltext steckt jetzt *in* den Platzhaltern, wo er
  Schritt 3 nicht überleben kann.

### Lab

- **Beispiel-Repo:** sechs verbotene Verweise aus den Spec-Historien entfernt
  (`slice-001`, `slice-007`, dreimal `ADR-*`), die vier `LH-*`-Aufwärtsbezüge
  blieben; `spezifikation.md` verliert die Verweis-Spalte. Die Adaptionen liegen
  jetzt einzeln, `MR-001` unter `done/`.
- **`check_references.py` prüft das ganze Dokument.** `strip_provenance_section()`
  ist entfernt — die Funktion schnitt genau die Sektion heraus, in der die
  Verweise landen. Break-Test: ADR-Verweis in eine Historie-Zeile gesetzt →
  1 Befund, Exit 1; zurückgesetzt → ok. Vorher lief derselbe Fall grün durch.
- **Templates:** `.d-check.yml` trägt den auskommentierten `vcs`-Opt-in für die
  Append-only-Disziplin der `MR`-Dateien — dasselbe Modul, mit dem der Kurs ADRs
  schützt. Es funktioniert nur in der Einzeldatei-Form: Eine wachsende
  Sammeldatei ist per Konstruktion Core-Drift.

### Offen

- **Provenance-Faden geschlossen bis auf die Norm-Ebene** — der
  [Roadmap-Eintrag](docs/roadmap.md) ist von „Entscheidung ausstehend" auf den
  Umsetzungsstand umgeschrieben.
- **Das ausliefernde Release ist MAJOR** (`v4.0.0`) — Assets werden umbenannt,
  siehe den Bruch-Block unten.

**Bruch für Konsumenten:** (1) Die Regelwerk-Dateien `modul-03-lastenheft.md`
und `modul-04-architektur-adrs.md` heißen jetzt `modul-03-spec.md` und
`modul-04-adrs.md`. Die Vorlagen tragen ihre Namen als **Klartext**-Zeiger im
Rumpf (*„Baseline-Regelwerk `modul-03-lastenheft.md` §Ziel-Form:
Akzeptanzkriterium"*) — und der Rumpf überlebt das Adoptieren. Der Zeiger steht
also in den *ausgefüllten* Artefakten und zeigt nach dem Upgrade ins Leere;
**kein Gate fängt das**, weil es kein Link ist. Nacharbeit:
`grep -rl 'modul-03-lastenheft\|modul-04-architektur-adrs'` über das eigene Repo,
dann ersetzen. (2) `Ersetzt-Baseline-Regel` ist ein **neues Pflichtfeld** der
`MR-<NNN>`-Einträge — nach [Modul 2](kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md)
verlangen neue Pflichtfelder Nacharbeit am gefüllten Artefakt: je Eintrag die
Baseline-Regel nachtragen, an deren Stelle er tritt (oder `—`; dann ist er keine
Adaption, und der Eintrag gehört überprüft).

**Kein Bruch** ist die neue Verzeichnis-Form des Adaptions-Blocks. Die Form
bleibt **Wahl** — gekippt ist nur der Default der Vorlage; bestehende
`conventions.md` mit inline geführten Einträgen bleiben gültig.

## Welle 61 — 2026-07-30 · Runde 11: die Wellen-Rollen-Sequenz, und zwei Gates, die nicht prüften

Review-Runde 11 ([`docs/reviews/review-runde-11.md`](docs/reviews/review-runde-11.md)):
drei Reviewer mit getrennten Linsen und getrenntem Kontext, einer in einem
eigenen Worktree für Break-Tests. Dazu zwei Befunde, die aus Nutzer-Fragen
entstanden, nicht aus einem Review-Lauf.

### Hinzugefügt

- **[Modul 8 §Rollen-Sequenz für eine Welle](kurs/de/03-agenten/modul-08-agentenrollen.md).**
  Der Slice-Zyklus hatte eine Rollen-Sequenz mit neun Übergaben, der
  Wellen-Zyklus keine — acht Prozedur-Schritte ohne benannten Träger, obwohl sie
  vier Kontexte berühren. Neu: Träger und Übergabe-Artefakt pro Schritt, fünf
  Übergaben in drei Zügen. **Die Eröffnung ist Planner-Arbeit ohne Übergabe** —
  eine Aussage, keine Leerstelle. Zu erfinden war nichts: Die Tätigkeits-Tabelle
  in [Lösung Modul 8](kurs/de/loesungen/modul-08-loesung.md) ordnete die
  schwersten Schritte längst zu (*Hard Rule in AGENTS.md → Architect + Planner*).
- **Beide Sequenzen sind nötig, weil ein Repo auch ohne Wellen arbeitet.** Ohne
  Wellen-Betrieb bleiben vier der fünf Übergaben; die **Verifier→Planner-Kante
  entfällt** — und dass gerade sie entfällt, ist die Definition: Ein repo-weiter
  Beleg über die Slice-DoDs hinaus *ist* das *Mehr*, an dem eine Welle hängt.
  Rollen-Sequenz und Wellen-Kriterium sind dieselbe Aussage aus zwei Richtungen.
- **[Modul 15 §Lab-Grenze](kurs/de/05-betrieb/modul-15-observability.md).** Das
  Modul lehrte ein Span-Schema ohne Emissions-Pfad, und die Grenze war — anders
  als beim Replay und beim Coverage-Gate — nicht benannt. Jetzt steht dort, was
  das Fixture ist (handgeschrieben, ein *Slice*-Trace), wie die Rolle in einer
  instrumentierten Umgebung zustande kommt (**Angabe des Starters** durch das
  gestartete Rollen-Artefakt; `OTEL_RESOURCE_ATTRIBUTES` nur, wenn der Lauf
  selbst OTel emittiert — sonst das Lauf-Buch des Starters), und dass Exporter,
  Collector und Sampling Repo-Entscheidungen sind: *Mitzunehmen ist das Schema,
  nicht das Setup.*

- **Modul 4 lehrt jetzt beide Hälften seines Titels.** Die Architektur-*Sicht*
  (`spec/architecture.md`) hatte ein Template und einen Index-Anspruch auf
  Modul 4, aber keinen Ort, der sie behandelt — sie kam dort genau einmal vor,
  in den Fehlvorstellungen, als Abgrenzung. Neu: §Die Architektur-Sicht mit den
  zwei Regeln, die anderswo festgelegt sind und hier zusammenlaufen (derivativ
  · sprach- und meilensteinfrei), plus Ziel-Form im Spiegel. Erfunden wurde
  nichts; die Normen standen in Konventionen und Modul 9.
- **Die Drift-Übung in Modul 12 konnte keine Beobachtung erzeugen** (`Ü-05`).
  `make replay` ist ein Struktur-Validator, kein Runner — Break-Test: Modell
  gewechselt und Erwartung verfälscht, dreimal grün. Der Lab-Grenze-Block
  erklärte die Fixture-Grenze und behauptete zugleich, LZ 3 werde „durch die
  Drift-Übung in einer Kopie" abgerufen. Jetzt Zuordnung je Lernziel, und die
  Blindheit ist die Übung: dreimal grün beobachten und benennen, welche Felder
  ein Runner vergleichen müsste. Lösung mitgezogen. Neu offen als `Ü-11`: Das
  Manifest deklariert `per_case_hash` und `determinism_check` als „in CI
  verpflichtend" — kein Target löst das ein.
- **Das Replay-Manifest trug drei unwahre Angaben** (`Ü-11`). Neben dem
  Verifikations-Vertrag nannte der `toolchain`-Block `python` als
  „Replay-Runner (tools/)" — dort liegen nur Doku-Gates — und `node` als
  Prüfer von `make replay`, das reines Shell ist. Kein Runner gebaut: Die
  Erwartungen referenzieren ein Korpus (`docs/init.md`), das nicht existiert;
  ohne Korpus kein Lauf und keine Kalibrierung. Stattdessen mit den eigenen
  Konstrukten aufgelöst — Manifest und Target-Ausgabe sagen jetzt die Grenze,
  **CO-002** trägt Trigger und Folge-Slice, **slice-015** trägt Korpus,
  Runner und zwei Break-Tests in der DoD. Der `verification`-Block bleibt:
  Modul 12 lehrt ihn als Pflichtinhalt; falsch war die Behauptung, er werde
  durchgesetzt.
- **Vier Templates verloren beim Adoptieren jeden Regelwerk-Anker.** Schritt 4
  entfernt den Hinweis-Block, Schritt 5 die Kommentare — bei `carveout`,
  `architecture`, dem ADR-Template und `spezifikation` stand danach kein
  Zeiger mehr im Rumpf; `carveout.template.md` hatte in keiner Schicht einen.
  Zwei encodierte Entscheidungen hingen daran: die Accepted-Immutabilität und
  die CR-Landing-Disziplin aus Welle 34. Sieben Vorlagen nachgezogen, je ein
  Kopf-Zeiger plus jede sonst sterbende Norm im Rumpf, in der Klartext-Form
  von `slice.template.md`. **Unbewacht:** Die Unterscheidung Rumpf /
  Kommentar / Hinweis-Block prüft kein Gate — einmal aufgeräumt, nicht
  strukturell erledigt (`Ü-10`).
- **Auch das mittlere Spec-Stratum hat jetzt eine Ziel-Form.** Modul 3 heißt
  „Lastenheft und Spezifikation"; das Lastenheft hatte eine Ziel-Form, die
  Spezifikation stand mit einem Halbsatz und einer Zeile in der
  Stratifizierung da. Neu: §Die Spezifikation in der Quelle,
  §Ziel-Form: Spezifikation im Spiegel — fortschreibbar · präzisiert nie
  erweitert · optional, alles aus `konventionen.md` §Spec-Straten. Dass die
  Datei weiter `modul-03-lastenheft.md` heißt, bleibt offen (`Ü-09`):
  umbenennen bricht das vendored Layout und ist MAJOR.
- **Zwei weitere Templates hatten keinen Verweis aus irgendeinem Modul** —
  `AGENTS.template.md` (Index: Modul 9) und `project-readme.template.md`
  (Index: Modul 2). Beide Artefakte werden in ihrem Modul ausgiebig behandelt,
  nur die Ziel-Form fehlte. Nachgezogen; kein Template steht mehr ohne
  Verweis.

### Geändert

- **Die Projekt-README ist Rang 6, nicht Rang 7.** Zwei Stellen in
  `lab/templates/` lehrten den falschen Rang — Rang 7 ist `AGENTS.md`. Die
  Zahl stand nur in der Vorlage, nie in der Quelle.
- **Die Zuordnungs-Einheit der Token-Bilanz ist der Lauf.** Modul 15 nannte das
  Ziel der Attribuierung „Kostenstellen" — Organisations-Vokabular, während
  Modul 8 Rollen-Trennung als *Kontext*-Trennung definiert. Mini-Glossar und
  Übungsauftrag sagen jetzt: ein **Kontext**, kein Mensch.
- **Eine Bezeichnung pro Agentenrolle, nachgezogen.** Die Sechserliste stand
  noch in `README.md` §Lernziele in den zurückgezogenen Namen — an der
  sichtbarsten Stelle des Repos, während Welle 60 „durchgehend" behauptete.
- **Die Wellen-Closure-Schritte tragen die Nummern von Modul 6**, alle fünf.
  Die erste Fassung der Träger-Tabelle vergab 4 und 5 an Teile von Schritt 3 und
  ließ die echten Schritte 4 und 5 ohne Träger.

### Lab

- **`make verify-slice` konnte nicht rot werden.** Nicht eine Prüfung war
  wirkungslos, sondern alle vier: `exit 1` in einer Subshell, Zeilen mit `;`
  verkettet — make sah nur den Status von `echo … ok`.
  `verify-slice SLICE=slice-999` lief grün durch. Jetzt `set -e` plus
  geschweifte Klammern, mit Kommentar an der Stelle, weil sie Lehrmaterial ist.
  Der wirksame Gate fand sofort einen echten Mangel: `slice-020` nannte
  `make gates` nicht, obwohl `AGENTS.md` es als *mandatory vor PR* führt.
- **Der Closure-Note-Gate meldete QA-Messungen als Platzhalter.** Die
  Platzhalter-Regex aus Welle 60 traf `p95 < 1 s und Recall > 0,9`, Autolinks,
  HTML-Tags und C++-Templates — Falsch-Positive auf genau dem Format, in dem
  eine Closure-Notiz eine QA-Erfüllung berichtet. Eng gefasst und in beide
  Richtungen verifiziert: acht Gegenbeispiele still, vier Platzhalter-Formen
  weiter getroffen, blanker Template-Rumpf weiter rot.
- **`POST /reindex` (LH-FA-01) existierte in keinem der sechs Skelette.** Die
  Coverage-Messung aus `Ü-03` legte offen, dass `E001` in **keiner** Sprache
  getestet war und `E099` nur in Go — Ursache war nicht die Testauswahl,
  sondern fehlender Produktionscode: Ohne Aufrufpfad gibt es für `E001` nichts
  zu prüfen. Die Spec verlangte beides seit jeher (`lastenheft.md` LH-FA-01
  nennt Happy/Boundary/Negative wörtlich). Nachgezogen in allen sechs Sprachen:
  `Indexer`-Service, `/reindex` im UI-Adapter, die drei Akzeptanzkriterien, ein
  `LH-QA-02`-Determinismus-Fall und **eine** Zuordnungsstelle für alle vier
  Codes aus spec §4. `lab/example/README.md` nennt jetzt den Umfang und die
  zwei bewusst offenen Spec-Teile (Index-Persistenz nach ADR-0003/0012,
  Abschnitts-Zerlegung samt `indexed_sections`).
- **`E099` kam in Go mit Status 400.** Der Decode-Pfad in
  `go/internal/ui/handler.go` schrieb den Status neben die Zuordnungstabelle,
  und ein Test hielt die 400 fest — spec §4 ordnet `E099` den Status 500 zu.
  Beide Pfade laufen jetzt über `statusFor`. Was dabei sichtbar wurde und
  offen bleibt: Die Spec kennt **keinen** Code für syntaktisch kaputte
  Eingabe. Das ist eine Spec-Lücke, kein Handler-Fehler.
- **Kotlins `make lint` war auf `main` rot.** `detekt` meldete
  `UseCheckOrError` in `SearchTest.kt`; der Befund lag vor dieser Welle und
  hing an keinem Baseline-Eintrag. Behoben mit `error(…)` statt
  `throw IllegalStateException(…)` — kein Suppression-Eintrag.
- **Pythons `coverage-gate-critical` maß nur eine Testdatei.** `--cov` zeigte
  auf den ganzen Service-Layer, `pytest` lief auf `tests/test_service.py`.
  Solange dort alles lag, fiel es nicht auf; mit `reindex.py` sackte die
  Messung auf 50 %. Jetzt `tests/`.
- **ADR-0011 trägt vier Pflichten statt drei.** *Ausgefülltheit* war als
  Zähl-Ausnahme zu Pflicht 1 formuliert, während der Code Platzhalter
  unabhängig von der Satzzahl abweist — die Historie-Zeile behauptete dazu
  „Pflicht 1 wurde nicht erweitert". Beides berichtigt; „deckt Pflicht 1 und 2
  vollständig ab" ist gefallen, weil die Maschine Satzendezeichen zählt und
  nicht Substanz.

### Regelwerk

- **Der Modul-15-Split trug Kurs-Didaktik.** Er übernahm die §Lab-Grenze samt
  Rahmen („Das Kurs-Fixture ist …") — Aussagen über Material, das im netzlosen
  Bundle nicht existiert. Über vier Korrekturen auf null reduziert: Was
  operativ blieb, sind zwei Sätze in Sektionen, die es schon gab. Wenn eine
  Sektion unter Nachfragen nur schrumpft und nie präziser wird, war sie keine
  Regel, sondern Erklärung am falschen Ort.
- **„Der Lauf hängt am Slice-Trace" war eine Modellwahl, als Regel verkauft.**
  Die Korrelation trägt `slice.id` — Pflichtfeld jedes Spans; Läufe als je
  eigene Traces leisten dasselbe, und ein Slice läuft Tage. In der Quelle als
  Modellwahl benannt, im Split gestrichen.
- **Die Ein-Satz-Definition der Referenz-Richtung ließ zwei Straten aus.** Die
  Kette stand im selben Dokument dreimal verschieden: Glossar
  `` `lastenheft.md` › ADR › Slice `` · §Referenz-Richtung
  `Vertrag › ADR › Slice` mit Nachsatz · §Spec-Straten
  `Vertrag › Technik › Sicht › ADR › Slice`. Die meistgelesene war die
  schwächste — und sie nannte einen **Dateinamen**, obwohl dasselbe Dokument
  zwei Seiten später schreibt: *„Die Matrix-Zeilen sind Stratum-Klassen, nicht
  Dateinamen."* Wer nur dort nachschlug, für den kamen `spezifikation.md` und
  `architecture.md` im Rang gar nicht vor. Glossar trägt jetzt die volle Kette
  als Klassen.
- **Die ADR-Spalte der Spezifikations-Historie steht auf zwei Gründen, nicht
  auf einem.** Zwischenzeitlich war sie mit „die ADR ist der legitime Urheber"
  begründet — ein Kausal-Argument, wo ein Referenz-Argument hingehört, und
  damit sah die Erlaubnis wie ein Widerspruch zur Decken-Regel aus. Tragend
  ist die Glossar-Zeile: *Abwärts-Verweise sind Kontext, keine Spezifikation*
  — erlaubt, ohne Normkraft; die `Schärft:`-Deklaration bleibt die einzige
  normative Kante. Der Änderungs-Prozess erklärt zusätzlich, warum die
  Provenance dort aussagekräftig ist. Beim Lastenheft trägt beides nicht, und
  das steht jetzt dabei: Seine Matrix-Zeile ist die einzige mit ❌ **ohne**
  Kontext-Zelle.
- **Warum die Architektur-Sicht keine Historie hat, steht jetzt da.** Template,
  Beispiel-Repo und ein reales Adopter-Repo führen alle drei nur
  `**Letzte Änderung:**` — übereinstimmend, aber unbegründet. Der Grund folgt
  aus dem Änderungs-Prozess: Vertrag und Technik haben einen benennbaren
  Urheber (externer CR bzw. schärfende ADR), die Sicht hat keinen; jede ihrer
  Änderungen folgt aus einer Änderung darüber. Eine Verweis-Spalte trüge dort
  nichts Zulässiges — die ADR darf sie nicht nennen, eigene Anforderungen hat
  sie nicht. Die fehlende Historie ist damit eine **Folge, keine Lücke**, und
  `Letzte Änderung` ist ein Frische-Marker, kein Protokoll.
- **Die Decken-Regel gilt jetzt ohne Schlupfloch.** Erst stand dort „normativ
  referenziert es nur intra-`LH-*`" — das ließ die Historie offen, und genau
  dorthin wandern in der Praxis Slice-, ADR- und Wellen-Verweise. Die
  Vertrags-Zeile der Matrix trägt in jeder fremden Spalte ein ❌ **ohne**
  Kontext-Ausnahme, anders als jede andere Zeile. Jetzt ausgeschrieben: Das
  Lastenheft nennt kein anderes Artefakt, **in keinem Abschnitt, auch nicht in
  der Historie**. Für die übrigen Straten bleibt die Provenance-Ausnahme, weil
  ihr Änderungs-Prozess einen Urheber im Repo hat — der Vertrag hat keinen.
  Der Anlass geht nicht verloren, er liegt am anderen Ende: `Schärft:` der ADR,
  Closure-Notiz des Slice. Quelle, Spiegel und `lastenheft.template.md` §7.
- **Alle drei Spec-Straten nennen jetzt ihre Referenz-Richtung.** Nach der
  Sicht (`V11-03`) fehlte sie auch bei Technik und Vertrag: Die Spezifikation
  trägt keinen ADR-Rückzeiger als Begründung — die ADR deklariert aufwärts in
  `Schärft:`, und die ADR-Spalte der Historie bleibt erlaubt, weil Provenance
  *Kontext* ist. Das Lastenheft ist die Decke und referenziert normativ nur
  innerhalb der eigenen `LH-*`-Reihe. Neu offen als `Ü-12`: Die
  Lastenheft-Historie des Beispiel-Repos nennt Slices und eine ADR als
  Änderungsgrund — genau das, was die CR-Regel aus Welle 34 ausschließt.
- **Modul 9 erlaubte, was die Referenz-Richtung verbietet** (`V11-03`). Die
  Hard Rule sagte *„`spec/architecture.md` referenziert ADRs und
  Modul-Pfade"*; `konventionen.md` §Referenz-Richtung und
  `architecture.template.md` sagen das Gegenteil. Der Rang entscheidet:
  **Vertrag › Technik › Sicht › ADR › Slice** — die Sicht steht *über* der
  ADR, normative Referenzen zeigen nur aufwärts. Ursache war eine
  Fehlklassifikation: Die Regel stand unter „Hard Rules (**repo-spezifisch**)",
  ist aber keine Repo-Entscheidung, sondern folgt aus dem Sicht-Stratum — und
  musste dort nie gegen die allgemeine Norm geprüft werden. Modul 4 ist jetzt
  Definitionsort; Modul 9 benennt stattdessen die fehlende Unterscheidung:
  *Ein Repo verkörpert eine universelle Regel in `AGENTS.md`, es entscheidet
  sie nicht.* Vier abhängige Stellen nachgezogen.
- **Modul 4 nannte die Referenz-Richtung nicht.** Die ADR ist der Ort, an dem
  die SDP-Asymmetrie praktisch wird — der Kontext verweist aufwärts auf die
  stabilere Quelle, nie abwärts auf einen Slice. Weder Quelle noch Spiegel
  sagten das; Worked-Example-Schritt 3 heißt „Spec-Verweis statt
  -Wiederholung" und ließ die Richtung offen. Beide nachgezogen mit Zeiger auf
  `konventionen.md` §Referenz-Richtung (SDP).
- **Zwei Glossar-Zeilen des Spiegels trugen `[#NAME?]` als Link-Text** —
  ein Tabellenkalkulations-Artefakt aus dem Split. Die Quelle sagt
  `[§Referenz-Richtung]` und `[§Spec-Straten]`. Kein Gate fing es: Die Links
  lösen auf, nur der Text war Müll.
- **Fremdprojekt-Namen im Bundle waren tote Zeiger.** Welle 35 hatte die
  Links auf `fallstudien.md` entfernt und die Namen stehen lassen — ein
  Adoptierender las *„Hard Rule (Beispiel aus c-hsm-doc, ADR 0001)"* und
  konnte es nicht auflösen. 16 Stellen in `regelwerk/` und `templates/`
  bereinigt; die Regeln tragen sich jetzt selbst. Zwei brauchten mehr als das
  Streichen der Klammer: `grundlagen-konventionen.md` verwies auf eine Datei
  **im fremden Repo** und schaltete dafür das eigene Gate stumm
  (`d-check:ignore`) — Verweis und Suppression sind weg; und die
  Optimierer-Regel aus Modul 9 ist als **Domänen-Beispiel** ausgewiesen, weil
  sie ohne den Marker wie eine universelle Regel las. Die Quelle behält ihre
  Fallstudien: dort reist `fallstudien.md` mit.

## Welle 60 — 2026-07-29 · E-2 vollzogen, „berührt" definiert, die Zeitachse des Vorbilds geradegezogen

Review-Runde 10 abgearbeitet ([`docs/reviews/review-runde-10.md`](docs/reviews/review-runde-10.md)),
dazu drei Klassen von Befunden am Vorbild-Repo, die dieselbe Runde zutage
gefördert hat. Kein Befund dieser Runde war maschinell sichtbar — `make check`
und `make verify` waren die ganze Zeit grün.

### Entschieden

- **Was „berührt" heißt.** Der Begriff steht an rund fünfzehn Stellen im Kurs,
  löst jeden §8-Block aus und war nirgends definiert. Jetzt in
  [`konventionen.md` §Was ist eine Sub-Area?](kurs/de/grundlagen/konventionen.md):
  Ein Slice *berührt* eine Sub-Area, wenn er ihren **Doku-/Code-Abgleich
  bewegt**. Zwei Wege dorthin, nur einer steht im Diff — **Pfad-Berührung**
  (mechanisch ablesbar, aber *nicht hinreichend*: additive Arbeit innerhalb
  einer schon deklarierten Konvention zählt nicht) und **Aussagen-Berührung**.
  Grenze benannt: Der Diff liefert eine Kandidatenliste, kein Urteil.
- **Die Sub-Area-Spalte des Registers bekommt eine Befüllungs-Regel**
  ([Modul 6](kurs/de/02-planung/modul-06-roadmap.md)): Sie trägt die Sub-Area,
  deren Konventions-Härte oder Inventur-Linie die Beobachtung betrifft — nicht
  die, in deren Verzeichnis sie auffiel. Dieselbe Berührungs-Frage, rückwärts.
- **E-2 wird ausgeführt, nicht zurückgenommen.** Runde 10 hatte drei Optionen
  gestellt (zurücknehmen · Durchsetzung schaffen · Geltungsbereich
  verkleinern). Keine davon: Die Regel war nie falsch, sie war nur nie
  vollzogen.

### Hinzugefügt

- **Die Ruheort-Regel ist jetzt definiert**
  ([`konventionen.md` §Herkunfts-Anker](kurs/de/grundlagen/konventionen.md)).
  Quelle und Spiegel beriefen sich namentlich auf sie; `grep -rn "Ruheort"`
  lieferte zwei Zitate und keine Definition. Sie stand in einem
  Template-Kommentar, den Adoptions-Schritt 5 löscht.
- **Die zwei vorgelagerten Schritte der §8-Begründung** stehen in
  [Modul 5](kurs/de/02-planung/modul-05-planning-harness.md) — Sub-Area-Wahl
  prüfen · offene Beobachtungen sichten. Sie waren als Pflicht in *jedem*
  Slice-Plan verlangt und existierten ausschließlich im Template.
- **„Die leere Liste ist die Aussage"** (Modul 6): Ein Register ohne offene
  Beobachtungen trägt `— keine —` und bleibt stehen. Das adoptierte
  `observations.template.md` startet seither in genau diesem Zustand — vorher
  mit drei erfundenen Beobachtungen, weil Schritt 3 unbedingt befiehlt,
  Platzhalter zu ersetzen.

### Geändert

- **Alle sechs Planning-Templates tragen einen Regelwerk-Zeiger pro Sektion.**
  Gemessen nach Adoptions-Schritt 4 (Hinweis-Block weg) und 5 (Kommentare weg)
  standen `README.template.md`, `roadmap.template.md` und
  `welle.template.md` bei **null** Zeigern der Form *„Regeln dieser Sektion:"*,
  `slice.template.md` und `welle-results.template.md` bei **einem**. (Zählt man
  jede Regelwerk-*Nennung*, waren es 7 bzw. 2 — so steht es in
  `docs/reviews/review-runde-10.md` unter R10-02; die meisten davon lagen im
  Hinweis-Block oder in einer einzigen Sektion.) Ein Adopter verliert beim
  Kopieren keine Norm mehr.
- **Die *Lage*-Prüfung des Belegs läuft nach dem `git mv`**, zusammen mit der
  Register-Paarung (c). Vorher lief sie per Konstruktion bei jeder korrekt
  ausgeführten Closure rot: Der Beleg wird vor dem `mv` geschrieben, und der
  `mv` ist ein eigener Commit.
- **Zwei Leser statt einer.** Modul 6, Spiegel und Selbstcheck-Rubrik nannten
  nur den Lese-Schritt (Welle-Closure); der Sichtungs-Schritt (Slice-Planung
  §8) hält alles unter der Schwelle am Leben und fehlte.
- **Achse E-1 vereinheitlicht.** „Ohne laufende Welle" ist die falsche Achse —
  ein Repo mit Wellen hat regelmäßig keine laufende Welle und trotzdem eine
  nächste Welle-Closure. Korrigiert in Modul 6, im Spiegel und im laufenden
  CHANGELOG-Block; historische Einträge bewusst unangetastet.
- **Die Grenze der E-2-Feedback-Hälfte sagt jetzt das Entscheidende:** Der
  Reviewer-Skill ist eine *Ziel-Form für das adoptierende Repo*. Wo der
  Adopter kein Review einrichtet, hat die Hard Rule keinen Träger — das ist
  der Auslieferungszustand, kein Sonderfall.

### Nachgezogen

- **Eine Bezeichnung pro Agentenrolle.** Die kanonische Sechserliste stand im
  Repo in **vier** Fassungen; zwei Rollen hatten Doppelnamen
  (`Implementation`/`Implementer`, `Verification`/`Verifier`). Kanon ist jetzt
  durchgehend das Akteursnomen — **Planner · Architect · Implementer ·
  Reviewer · Verifier · Validator** —, denn fünf der sechs waren es schon; nur
  eines war ein Vorgangsnomen. Mitgezogen: 57 Komposita
  (`Implementation-Agent` → `Implementer-Agent`), die Mermaid-Teilnehmer, die
  Übergabe-Ketten, die Selbstcheck-Rubrik, die `agent.role`-Werte im
  Trace-Fixture und die Attributions-Tabelle in `modul-15-loesung.md`.
  *Implementation* und *Verification* bleiben, wo sie die **Tätigkeit** meinen
  (Modul 11 heißt weiter *Verification Harness*, das Begriffspaar
  Verification/Validation bleibt unangetastet).

### Lab

- **Acht Einzelbefunde am Vorbild-Repo** (Klasse 1 der Inventur): `make ci`
  versprach Replay-Lauf und Image-Scan und tat beides nicht · `slice-009` hakte
  Datei-Änderungen ab, die es nie gab · **`LH-QA-Coverage` war keine ID** — die
  Coverage-Schwellen bekommen **[ADR-0013](lab/example/docs/plan/adr/0013-coverage-schwellen.md)**
  (bootstrap-aware 70 %, kritisch 90 %) · `docs/user/quality.md` wurde als
  existierend behauptet · `AGENTS.md` verschwieg die repo-weite
  Verifikations-Schicht · das `Status:`-Feld im Slice-Kopf stand gegen die eigene
  Regel · ADR-0011 zählte zwei `done/`-Dateien, es waren drei · `CO-001`
  prüfte in Java und Kotlin keine Schwelle.
- **Der Closure-Note-Gate war grün auf dem blanken Template-Rumpf.** Break-Test
  reproduziert (exit 0), bestehender Checker um eine Platzhalter-Prüfung
  gehärtet — kein neues Skript. ADR-0011 führt das als geschärfte Fitness
  Function, nicht als neue Pflicht.
- **Die Zeitachse des Vorbild-Repos stand an 23 Stellen gegen sich selbst:**
  Slices zitierten ADRs aus ihrer Zukunft, ADRs schrieben ihre Urheberschaft
  Slices mit fremdem Titel zu, der Index-Pfad lautete je nach Datei anders, der
  Jetzt-Punkt lag mal im Juni, mal im Juli. Nachträge stehen jetzt sichtbar da
  statt als stille Rückdatierung.
- **Die Sub-Area-Tabelle deckt jeden Pfad-Cluster ab** — 186 von 186 verfolgten
  Dateien, entweder als Sub-Area oder in §Nicht als Sub-Area geführt mit Grund.
  Vorher hatten `tools/`, `runbooks/`, die Container-/Build-Dateien und jedes
  `<lang>/Makefile` keine Sub-Area, der ein Slice seinen §8-Block hätte
  zuordnen können.
- Alle vier Vorbild-Slices tragen beide *Vorgelagert*-Blöcke; der Blockname
  lautet überall wie in der Norm (*sichten*, nicht *gesichtet*).

## Welle 59 — 2026-07-27 · Der Steering-Loop-Zähler bekommt einen Ort, der Wellen überlebt

### Hinzugefügt

- **[Modul 6](kurs/de/02-planung/modul-06-roadmap.md) §Das Beobachtungs-Register.**
  Der Zähler (*1× notieren · 2× Symptom · 3× Lücke*) liegt jetzt als stehende
  Datei `docs/plan/planning/observations.md` — flach neben den offenen Wellen,
  nicht mehr als Sektion in `welle-NN-results.md`.
- **[`observations.template.md`](lab/templates/docs/plan/planning/observations.template.md)**
  mit sechs Spalten und einer eigenen Sektion für gestrichene Einträge.
- **Wer schreibt, wer liest.** Eingetragen wird bei der **Slice-Closure** —
  neuer Eintrag mit `BEO-<NNN>` oder Zähler +1 und Beleg. Die **Welle-Closure
  liest** nur noch: Was hat 3× erreicht → verkörpern. *Das* ist der Punkt, an dem
  der Zähler von der Welle unabhängig wird; ein Repo ohne Wellen-Betrieb zählt
  weiter. Der Pflichtschritt steht in
  `slice.template.md` §6/§7 — dort, wo er ausgeführt wird, nicht nur in der Lehre.
- **Dritte Paarung in der Welle-Closure (Schritt 3):** Jede genannte `BEO-<NNN>` existiert als
  Zeile im Register. *Nennung ohne Deckung ist eine Harness-Lüge* gilt jetzt auch
  hier.
- **Der wellenlose Fall gilt auch für den Lese-Schritt** — und dafür musste das
  **Herkunfts-Anker-Subsystem** mit: Ein Repo ohne Wellen-Betrieb löst den
  Lese-Schritt eigenständig aus; erreicht ein Eintrag 3×, wird er verkörpert, und
  der Anker lautet `seit slice-<NNN>` statt `seit welle-<NN>`. Nachgezogen wurden
  **alle** Normstellen dieses Subsystems, nicht nur die Einführung:
  §Herkunfts-Anker (der Absatz argumentierte bis dahin *gegen* den Slice), das
  Form-Beispiel, die **Anker-Paarung** (sie verlangte die Wellenform) und ihr
  **Einstiegspunkt** — der Sensor lief über die Welle-Closure-Notiz, die es ohne
  Welle nicht gibt; er kennt jetzt §7 der Slice-Closure als zweite Quelle. Dazu
  Modul 9, 10 und 13 mit ihren Formangaben, `welle-results.template.md` und der
  Fluss-Graph. Ohne diesen Durchgang hätte eine wellenlos verkörperte Regel den
  Paarungs-Sensor garantiert rot laufen lassen — oder er hätte sie gar nicht
  gesehen.
- **`BEO-<NNN>` als Kennung.** Bisher musste die *Bezeichnung* über Wellen
  hinweg wortgleich bleiben — das Template mahnte es in Großbuchstaben, weil es
  bricht. Jetzt wird beim Erstauftreten einmal benannt und eine ID vergeben;
  Wiederauftreten zitiert sie. Umformulierungen ändern nur noch das Label, nicht
  die Zählung. Damit ist die Beobachtung die letzte zählbare Klasse im Harness,
  die eine ID bekommt (neben `LH-*`, `ADR-*`, `MR-*`, `CO-*`).

### Geändert

- **Warum stehend statt in der Welle-Closure.** Die bisherige Sektion wurde von
  Closure zu Closure **übernommen** und hochgezählt. Das hängt an einer
  ungebrochenen Kette mit drei Bruchstellen: vergessene Übernahme setzt den
  Zähler auf null, die erste Welle braucht eine Sonderregel, und ohne
  Wellen-Betrieb gibt es gar keinen Träger. Der feste Ort streicht alle drei — die Datei existiert ab
  Repo-Beginn.
- **Arbeitsteilung benannt, Werkzeug offen gelassen:** Das Urteil — *ist das
  dieselbe Beobachtung?* — fällt beim Schreiben, durch den Menschen, der die
  Kennung vergibt oder zitiert. Maschinell entscheidbar ist nur die **Deckung**:
  eine in `done/` zitierte `BEO-<NNN>` hat eine Registerzeile, und jede
  Registerzeile trägt mindestens einen Beleg — *nicht* die Umkehrung „jede Zeile
  ist irgendwo zitiert", denn die allermeisten stehen unter der Schwelle.
  Der Beleg ist dabei formgebunden — **Form** (`slice-<NNN>`, kein Freitext) ·
  **Anzahl** (so viele wie der Zähler) · **Lage** (führt das Repo die
  Slice-Datei, liegt sie in `done/`). Die *Existenz* wird bewusst nicht
  verlangt, und diese Grenze steht benannt: Ein Repo darf Slices führen, die es
  nicht als Plan-Datei ablegt.
  Muster: schreiben → committen → Gate prüft Deckung. *Welches* Werkzeug, legt
  der Kurs nicht fest.
- **Verzeichniskonvention:** Die flache Ebene unter `planning/` ist jetzt
  deklariert — offene Wellen (`<welle-id>.md`) und das Register. Sie wurde
  bislang benutzt (Modul 6, Template), stand aber in keiner Konvention.
- **Die Verweise nachgezogen** — Risiko-Ausgänge in Modul 5 und
  `slice.template.md`, der Steering-Loop-Graph in `konventionen.md`, der
  Template-Index, der Planning-Index in Template und Lab, die
  Regelwerk-Spiegel von Modul 5, 6, 10 und den Konventionen. Auch die
  **Modul-10-Strecke** (Quelle, Spiegel, `review-report.template.md`) trug die
  alte Mechanik und ist mitgezogen — die Finding-Klasse wandert jetzt bei der
  Slice-Closure ins Register, nicht in eine Verdichtung.
  `welle-results.template.md` behält die Sektion als **Zeiger** ohne Daten,
  damit ein Leser der Closure-Notiz den Zähler findet.
- **Didaktik:** Themen-Bullet, Übung und Selbstcheck-Item (beide LZ 2, das dafür
  um *„einordnen, wo der Steering-Loop-Zähler geführt wird und wer ihn schreibt
  bzw. liest"* erweitert wurde), Rubrik-Zeile und zwei Lösungsblöcke. Dazu eine
  neue Kernbegriffs-Zeile `BEO-<NNN>` in Quelle und Spiegel und der Nachzug in
  `welle.template.md`.
- **Lab:** Die drei realen Zeilen aus `welle-1-results.md` sind nach
  `observations.md` umgezogen und haben Kennungen bekommen (`BEO-001` bis
  `BEO-003`); dazu neu `BEO-004` (Lerneintrag aus `slice-020` §7), `BEO-005`
  (der einzige reale 3×-Fall, verkörpert in `AGENTS.md` §2.7), `BEO-006`
  (offenes Risiko aus `slice-020` §6) und `BEO-007` (der Auslöser der benannten
  Spec-Lücke) — sieben Zeilen insgesamt.
  Das Register erklärt die retrospektive
  Kennungs-Vergabe. `slice-009` und `slice-020` zitieren ihre Kennungen,
  `welle-1-results.md` nennt `BEO-005` und `BEO-007` beim Auslöser — beide
  Hälften der Register-Paarung halten damit im Vorbild, Form und Anzahl der
  Belege eingeschlossen.
- **Der Welle-Plan ist im Vorbild jetzt vertreten:** `done/welle-1-mvp.md`
  (geschlossen, neben seiner Ergebnis-Notiz) und `welle-2-qualitaet.md` (flach,
  aktive Welle). Ohne sie behauptete die Regel eine Pflicht, die das eigene
  Vorbild nicht erfüllte. Der Planning-Index im Lab trägt die
  Slice-vs-Welle-Konvention dazu.

### Nachgezogen (Review-Runden 7 bis 9)

- **Neue Konvention: [§Template-Schichtung](kurs/de/grundlagen/konventionen.md)**
  samt Spiegel. Ein Template wird beim Adoptieren abgebaut — alle Kommentare
  fallen weg. Vier Schichten statt zwei: **Regelwerk** trägt den Normtext als
  einzige Quelle, der **Rumpf** nur Form plus einen Regelwerk-Zeiger pro
  Pflicht-Sektion, die **DoD** die abhakbare Prozedur, der **Kommentar** die
  Begründung. Hard Rule: *Kein Kommentar ist die einzige Fundstelle einer
  Norm.* Das war die gemeinsame Ursache von sieben Befunden der Runde 9 — die
  Runde 8 hatte Normlast verschoben, ohne einen Maßstab dafür zu haben.
  Die Feedback-Hälfte ist **inferential** (HIGH-Regel im Reviewer-Skill), nicht
  computational: „Ist dieser Satz eine Norm?" ist ein Urteil, und
  Template-Verzeichnisse sind für Referenz-Gates bewusst ausgenommen. Ein
  Sensor wäre hier ein halluziniertes Gate; die Grenze steht benannt.
- **„Ohne Welle" ist der Repo-Modus, nicht die Slice-Zugehörigkeit.** Ein Repo
  arbeitet mit Wellen und Slices oder nur mit Slices; daran hängt, wer
  Lese-Schritt, Sichtungs-Schritt, Trigger-Audit und die drei Paarungen trägt.
  Das Kopf-Feld `**Welle:**` eines Slice sagt nur, ob er in ein Bündel gehört —
  ein Repo mit Wellen prüft **auch Slices ohne Wellen-Zugehörigkeit** bei
  seiner nächsten Welle-Closure. Runde 8 hatte die beiden Achsen
  zusammengezogen; Template, Vorbild `slice-020` und der Lösungsblock (c) sind
  zurückgenommen.
- **Der Fluss-Graph** in `konventionen.md` zeigt jetzt beide Leser für
  Einträge unter der Schwelle — bisher führte die `1×/2×`-Kante allein zur
  Wellen-Eröffnung, die es im wellenlosen Repo nicht gibt.
- **Der Closure-Note-Gate im Lab misst §7 statt §5.** `find_closure_section`
  nahm die erste Überschrift mit „Closure" im Titel — das war
  *Closure-Trigger*, geschrieben bei der Planung. Ein Slice mit vollständig
  leerer Closure-Notiz lief grün; mit dem Fix läuft er rot (Break-Test).

### Nachgezogen (Review-Runden 7 und 8)

- **Zustands-Regel für Wellen vereinheitlicht:** `README.template.md` — der
  Welle-Zustand ist die Verzeichnis-Position, kein `Status:`-Feld, und der
  Welle-Plan ist nicht optional. Er durchläuft den aktiven Durchlauf
  `open/` → `next/` → `in-progress/` **nicht**; `done/` ist sein einziges
  Lifecycle-Verzeichnis.
- **„Drei Übergänge" nennt drei** (Modul 5 + Spiegel): `in_progress → done`
  ist als einziger Weg nach `done` benannt, die beiden **Rückführungen**
  stehen daneben und behalten ihren Ausnahmecharakter.
- **Der Auslöser der Anker-Paarung ist disambiguiert.** Das Feld `liegt in`
  löst **nur innerhalb** von `## Steering-Loop-Einträge` bzw. Slice-§7 aus —
  der Trigger-Sprachgebrauch „`SL-024` liegt in `done/`" aus demselben Modul
  also nicht. In den Backticks steht ein **Zielort**, nicht immer eine Datei:
  `AGENTS.md §<N>` · `Makefile:<target>` · `.harness/skills/<name>.md`; der
  Sensor trennt ein Suffix ab ` §` oder `:` ab, bevor er den Pfad prüft.
- **Die benannte Spec-Lücke ist entschieden:** Sie durchläuft das Register wie
  die anderen zwei Lerneintrags-Klassen und trägt eine `BEO-<NNN>`. Sie ist
  *verkörpert* — nur in einer versionierten Spec statt an einem Zielort, mit
  der `LH-*`-ID als Gegenstück. Damit ist sie kein Gegenstand der
  **Anker**-Paarung, sehr wohl aber der **Register**-Paarung. Die frühere
  Zuordnung *gezählt, nicht verkörpert* traf sie fälschlich und hätte
  verhindert, dass sie die Schwelle je erreicht.
- **Der wellenlose Betrieb hat für jeden Vorgang einen Träger und einen
  Moment** (Modul 6 + Spiegel, jetzt als Tabelle): Zähler und Lese-Schritt bei
  der Slice-Closure, **Sichtungs-Schritt bei der Slice-Planung** (§8,
  unabhängig vom Sub-Area-Modus — ohne ihn hätte alles unter der Schwelle
  keinen Leser), Trigger-Audit bei jeder Closure, und **alle drei Paarungen
  nach dem `git mv`**, weil sie in `done/` suchen.
- **Der Anker `seit slice-<NNN>` löst auf `done/slice-<NNN>-<kurzer-titel>.md`
  auf** — die reale Namensform aus `slice.template.md`, maschinell
  `done/slice-<NNN>-*.md`. Die verkürzte Angabe traf keine einzige Datei.
- **Die Normlast der Templates verlässt den Kommentar.** Schritt 5 der
  *Verwendung* entfernt alle Kommentare — was dort stand, war beim Adopter weg.
  `slice.template.md` §7 und `welle-results.template.md`
  §Steering-Loop-Einträge tragen seither **Form** als Body-Zeilen und einen
  **Regelwerk-Zeiger** auf den Normtext; der Kommentar hält nur noch die
  Begründung. Das ist dieselbe Setzung wie §Template-Schichtung oben, nicht
  ihre Gegenrede: Der Normtext selbst steht im Regelwerk, nicht im Rumpf.
  Dazu ein DoD-Item für die drei Paarungen und ein Ruheort-Carveout in
  `welle.template.md`.

## Welle 58 — 2026-07-27 · Discovery-Register geschlossen: eine Beobachtung unter Schwelle, kein Plan

### Geändert

- **Faden *Discovery-/Kandidaten-Register* geschlossen**, 25 Wellen nach seiner
  Vertagung. Nach dem Trigger-Neuschnitt (Welle 57) ist die Beleglage: **0**
  Beobachtungen des Drucks nach dem Welle-33-Fix, **1** Messung mit negativem
  Ergebnis. Die Ursprungs-Beobachtung entstand *vor* dem Fix und belegt nicht,
  dass er nicht reicht.
- **Der Grund ist die Zählregel des Kurses selbst.** Eine 1×-Beobachtung ist eine
  *Beobachtung unter Schwelle*, kein Steering-Loop-Eintrag — die Schwelle liegt
  bei 3×. Sie gehört damit nicht in eine Liste, die **Handlungen** verspricht.
  Dass sie 25 Wellen dort stand, liegt daran, dass dieses Repo mangels
  Wellen-Betrieb keinen Kanal für Beobachtungen unter Schwelle hat — die Roadmap
  war der einzige Ort, und dort las sie sich wie ausstehende Arbeit.
- **Wiedereintritt bleibt möglich und ist benannt:** Zeigt ein Repo den Druck
  *nach* Welle 33 — Nicht-Slice-Register werden mangels Ort in ein
  Lifecycle-Verzeichnis gezwängt, obwohl `done/` sanktioniert ist —, wird der
  Faden als **frische** Beobachtung neu eröffnet, nicht als Fortsetzung dieser.

### Nicht gemessen, und das steht so da

Ob der Welle-33-Fix bei `m-trace` gereicht hat, ist von hier nicht messbar (Repo
nicht greifbar). Die Schließung stützt sich deshalb ausdrücklich **nicht** auf
„vermutlich erledigt", sondern auf die fehlende Nach-Fix-Beobachtung.

## Welle 57 — 2026-07-27 · Ein Trigger, der seine eigene Korrektur nicht kannte

### Geändert

- **Faden *Discovery-/Kandidaten-Register*: Trigger neu geschnitten.** Er lautete
  „ein **zweites** Konsument-Repo zeigt denselben Druck unabhängig" — und zählte
  damit die Ursprungs-Beobachtung als erste von zwei. Die stammt laut Welle 33 aus
  einem `m-trace`-Planning-Layout-Audit und entstand **vor** der Korrektur, die
  genau darauf hin gemacht wurde (`done/` als sanktionierte Heimat abgeschlossener
  Nicht-Slice-Records). Eine Beobachtung von vor dem Fix belegt nicht mehr, dass
  der Fix nicht reicht. Der Trigger fragt jetzt danach: *zeigt ein Repo den Druck
  **nach** Welle 33?*
- **Beleglage ausgeschrieben statt angedeutet:** eine Vor-Fix-Beobachtung
  (`m-trace`, von hier nicht nachmessbar), eine Nach-Fix-Messung mit negativem
  Ergebnis (Welle 56). `d-check` stand als Beleg im Faden, war aber nie die
  Druckquelle — die Zeile las sich, als stützten zwei Repos die Verallgemeinerung.

### Warum nicht geschlossen

Der naheliegende Schluss wäre „ein Vor-Fix-Fall plus ein negativer Nach-Fix-Fall
= erledigt". Er trägt nicht: Ob der Welle-33-Fix bei `m-trace` gereicht hat, ist
von hier **nicht messbar**, und ein unbelegtes „vermutlich erledigt" wäre genau
die Vermutung, die diese Wellen-Serie aus der Roadmap entfernt hat.

## Welle 56 — 2026-07-27 · Wie ein Faden zu prüfen ist — und der erste, der es bekommt

### Hinzugefügt

- **Zweite Form-Disziplin in [`docs/roadmap.md`](docs/roadmap.md) §Offene Fäden.**
  Ein Faden trägt zwei Dinge: eine *Behauptung über den Ist-Zustand* und eine
  *vorgeschlagene Handlung*. Wer nur die Behauptung prüft, hat den Faden nicht
  geprüft. Das Audit vom selben Tag prüfte ausschließlich Behauptungen und
  meldete „fünf von sechs halten" — zwei fielen beim Anfassen trotzdem, bei
  beiden war die Behauptung **wahr** und die Folgerung falsch (*Mechanische
  Wächter*: „lässt sich prüfen" — nein, die Fehlerklassen sind semantisch;
  *Fork-Grenze*: „also Zeremonie" — nein, das Kriterium hätte die Regel
  erschlagen, auf die es sich beruft).

### Geändert

- **Faden *Discovery-/Kandidaten-Register* erstmals gemessen.** Er stand seit
  Welle 33 mit „kein Beleg, dass dort *derselbe* Druck auftrat" — was klang wie
  *nicht nachgesehen*, und das war es auch. Jetzt nachgesehen: Der zweite
  Adopter zeigt den Druck **nicht**. Sein `docs/plan/planning/` trägt nur Slices
  und die Roadmap, und ein Review hält als Repo-Praxis fest, dass `done/` die
  Nicht-Slice-Records archiviert — genau der Weg, den der Kurs seit Welle 33
  vorsieht. Das ist ein **negativer Beleg**, kein fehlender. Die früher zitierten
  `MR-007/008/010` belegen Adopter-Schaft, nicht diesen Druck.

## Welle 55 — 2026-07-27 · Die Fork-Grenze bekommt einen Eingang statt einer Streichung

### Behoben

- **Faden *Fork-Grenze ohne Konsument* geschlossen — sein Kriterium war zu
  scharf.** Er verlangte „Feld, Gate, Übung oder Rubrik-Zeile", sonst sei die
  Dreier-Taxonomie Kandidat zum Kürzen. Gegengeprüft: Die Regel, auf die er sich
  beruft — [§Jedes Artefakt hat einen Konsumenten](kurs/de/grundlagen/konventionen.md) —
  speist selbst **0** Übungen, **0** Rubrik-Zeilen, **0** Gates und bestünde ihre
  eigene Probe nicht. Sie greift ausdrücklich *zur Entwurfszeit*; ein Mensch ist
  ein zulässiger Konsument.
- **Der reale Unterschied war enger — und er ist behoben.** Auf die
  Konsumenten-Regel verweisen zwei Templates, jemand wird also dorthin geschickt.
  Auf die Fork-Grenze verwies **nichts**: keine Zeremonie, aber kein Eingang.
  Der Adaptions-Block von `conventions.template.md` trägt jetzt die Grenze als
  Schreib-Zeit-Probe — dort sitzt der Autor eines `MR`-Eintrags —, und die Grenze
  selbst benennt ihren Leser, wie die Konsumenten-Regel es verlangt
  („benennt, **wer es liest und wann**").

## Welle 54 — 2026-07-27 · Ein Faden, der nicht baubar ist — gemessen statt vermutet

### Geändert

- **Faden *Mechanische Wächter gegen Doku-Drift* geschlossen.** Er versprach zwei
  Prüfungen, die `make check` „heute nicht hat" — als wären sie nur zu bauen.
  Gegen das reale Repo geprüft, ist keine davon umsetzbar: §-Prosa-Zeiger melden
  18 von 31 (deutsche §-Verweise sind Kurzformen der Überschrift), die
  Aufzählungs-Gleichheit scheitert am Zahlwort als Attribut („Regeln für die
  *sechs* Schritte:" gefolgt von vier Regeln), und die naheliegende dritte Idee —
  gleiches Substantiv, andere Zahl — meldet 16 legitime Fälle. Die drei belegten
  Fehlerklassen sind **semantisch**, nicht syntaktisch.
- **Ersetzt durch einen engeren Faden:** die Link-Trümmer-Prüfung bei `d-check`
  anregen. Sie ist generisch und gehört nicht in `docs-check.js` — der Rest-Sensor
  prüft ausdrücklich nur repo-spezifische Semantik, die ein generischer
  Referenz-Checker nicht kennen kann. Ein Einbau dort hätte die Pilot-Migration
  rückabgewickelt.

### Nicht gebaut — und warum das der Ertrag ist

Beim Prototyp der Link-Trümmer-Prüfung fiel im **Break-Test** auf, dass die Regex
gar nicht auslösen konnte: Sie schloss `.` aus, um Satzpunkte zu vermeiden, die
realen Trümmer beginnen aber mit `../`. Die Meldung „0 Befunde auf grünem Repo"
war damit wertlos. Ohne den erzwungenen Fehlerfall wäre ein Halluzinations-Gate
eingebaut und als Erfolg gemeldet worden — genau das, was
[Modul 13](kurs/de/04-qualitaet/modul-13-quality-gates.md) als Disziplinregel
benennt: Ein Gate, das nicht rot werden kann, ist keins.

## Welle 53 — 2026-07-27 · Das ausgelieferte Bundle bekommt einen Wächter

### Hinzugefügt

- **`make bundle-check` und ein Prüfschritt im Release-Workflow.** `make check`
  prüft `lab/regelwerk/` im **Repo-Stand** — der Release-Workflow schreibt die
  Links danach mit `rewrite-doc-links.py` um, zippt und lädt hoch. Zwischen
  Rewrite und Upload prüfte **nichts**. Ein Rewrite-Fehler oder ein Link, der
  erst durch das Umschreiben bricht, ging unbemerkt an jeden Adopter. Der neue
  Schritt läuft **vor** dem Zippen: Geprüft werden die Bytes, die im ZIP landen.
- **[`tools/build-bundle.sh`](tools/build-bundle.sh)** — die Assemblierung stand
  bisher inline im Workflow. Damit war ein lokaler Check bestenfalls eine
  *Nachbildung*, und eine Nachbildung prüft nicht das, was ausgeliefert wird.
  Jetzt bauen Workflow und `make bundle-check` über dasselbe Skript. Nebeneffekt:
  Das Pinnen der Template-Links läuft auf der Kopie statt auf `lab/templates` im
  Arbeitsbaum — ein lokaler Lauf hinterlässt keine gepinnten Links mehr im Repo.
- **[`tools/bundle-d-check.yml`](tools/bundle-d-check.yml)** — Prüf-Konfiguration
  für den Bundle-Stand (Pfade eine Ebene flacher als im Repo). `regelwerk/` wird
  scharf geprüft; `templates/` mischt symbolische Ziel-Repo-Pfade mit prüfbaren
  Verweisen, deshalb dieselbe `in`/`refs`/`keep`-Trennung wie im Repo-Config.
  Der Kern ist `keep: ["regelwerk/**"]`: Eine umbenannte Regelwerk-Überschrift
  verschickt sonst unbemerkt einen toten Anker ins Adopter-Repo.

### Belege

- Grüner Fall: `make bundle-check` → 41 Dateien, 0 Befunde; ZIP 55 Dateien wie
  im Release, und die Prüf-Config landet **nicht** darin.
- Break-Test: ein toter Anker in `lab/regelwerk/modul-06-roadmap.md` → der Gate
  meldet `anchor-missing` und bricht mit Exit ≠ 0. Ein Gate, das nicht rot
  werden kann, ist keins (Modul 13).

### Nicht gemacht

Der zwischenzeitliche Vorschlag, die vendored Baseline aus dem **Adopter**-
Prüfumfang zu nehmen, ist verworfen: Er hätte fremde Defekte stillgelegt statt
behoben — Gate-Absenkung zur Befund-Vermeidung. Defekte im Kurs gehören vor der
Auslieferung gefangen, und genau dort sitzt der neue Wächter.

## Welle 52 — 2026-07-27 · Drei Fäden geschlossen — keiner durch Abarbeiten

Alle drei fielen, weil ihre **Prämisse** nicht hielt. Das ist der eigentliche
Ertrag dieser Welle: Ein Faden, dessen Trigger nie geprüft wird, altert genauso
still wie die Doku, die er beschreibt.

### Behoben

- **Phase C ist geliefert — sechs Stellen behaupteten das Gegenteil.**
  `make gates` über alle sechs Sprachskelette: **6/6 grün**, mit echten
  Toolchains und Coverage-Schwellen (Go 77,8 % · Python 76,99 % bei Schwelle
  70 % · Kotlin `koverVerify` · Java `mvn verify` · C# `dotnet test` · C++ 1/1).
  `kurs/de/grundlagen/README.md` nannte Phase C längst „ausgeliefert", während
  [Modul 13](kurs/de/04-qualitaet/modul-13-quality-gates.md), `lab/README.md`
  (3×), `lab/example/README.md`, `lab/example/AGENTS.md` und `CO-001` weiter
  „kommen in Phase C" sagten — Modul 13 zusätzlich mit falscher Zahl („fünf"
  statt sechs). Alle korrigiert. Dieselbe Klasse wie der Meilenstein `v3.7.0`,
  der auf „ausstehend" stand, obwohl er zweimal getaggt war.
- **Spec-Strata-Adaptionsrichtung: ein Zeiger widersprach seinem Ziel.**
  `harness/README.template.md` schickte Zwei-Straten-Repos zu `MR-001` als
  Beispiel — und `MR-001` dokumentiert den *Drei*-Straten-Fall.
  [`konventionen.md` §Spec-Straten](kurs/de/grundlagen/konventionen.md) entscheidet
  die Richtung längst („nur Vertrag und Sicht sind obligatorisch; das
  Technik-Stratum ist optional"), also **Baseline = zwei Straten, die
  Drei-Straten-Form ist die Adaption**. Der Hinweisblock sagt das jetzt und
  benennt, dass die Vorlage bereits die adaptierte Form zeigt.
- **Der Formcheck des Adaptions-Durchgangs war nie Prosa-Arbeit.**
  [Modul 2 §Freshness-Audit](kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md)
  verlangte von Hand zu prüfen, ob `Geltungsbereich`-Verweise nach dem Update
  noch auflösen. Messung an einer Fixture: Der ausgelieferte
  `lab/templates/.d-check.yml` hat `roots: ["."]`, ignoriert `.harness/` nicht,
  und d-check scannt Punktverzeichnisse — ein toter Anker meldet sich als
  `anchor-missing`. Der Text verweist jetzt aufs Gate; übrig bleibt die einmalige
  Prüfung, dass `.harness/baseline/` im Prüfumfang liegt.

### Geändert

- **Neuer Faden, eng geschnitten:** *Bootstrap-Übung im Lab fehlt.*
  `lab/example/exercises/` trägt Übungen zu anderen Modulen, aber keine zum
  Bootstrap — das ist wahr geblieben, hatte mit Sprach-Skeletten aber nie etwas
  zu tun und war nur mitgeschleppt unter *Lab Phase C*.

## Welle 51 — 2026-07-27 · Zwei Restbefunde aus der Review-Serie zu Welle 50

### Behoben

- **Die Selbstcheck-Präambel von [Modul 2](kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md)
  stimmte nach Welle 50 nicht mehr.** Sie behauptet, der Selbstcheck decke „alle
  fünf Lernziele plus die Conceptual-Change-Selbstvalidierung" ab — Welle 50 hat
  aber ein siebtes Item ergänzt, das an keinem Lernziel hängt. Statt es einem
  Lernziel anzuhängen, das es nicht trägt, sagt die Präambel jetzt, was der Fall
  ist: Der §Freshness-Audit trägt Regeln, die *nach* dem Bootstrap greifen und
  deshalb außerhalb der Lernziele liegen; geprüft werden sie trotzdem, weil eine
  Regel ohne Prüfung halbgesetzt wäre.
- **Rangzahlen in Prosa entfernt**
  ([Modul 1](kurs/de/01-spec-und-architektur/modul-01-entwicklungszyklus.md)):
  aus „ADRs sind Rang 4, AGENTS.md Rang 8" wurde „Die ADR rangiert höher als
  `AGENTS.md`". Dieselbe Kur wie in Welle 50 für `konventionen.md` — eine
  Rangzahl in Prosa gilt immer nur für *eine* Strata-Variante und altert mit
  jeder anderen. Der Regelwerk-Spiegel trägt die Zeile nicht.

### Nicht behoben — bewusst als Fäden geführt

Die übrigen Befunde der fünf Review-Runden stehen in
[`docs/roadmap.md`](docs/roadmap.md), weil sie eine **Entscheidung oder einen
Beleg** brauchen, keine Redaktion: die widersprüchliche Spec-Strata-
Adaptionsrichtung (welche Richtung gilt, ist eine Setzung), der Formcheck, der
erst ins Gate kann, wenn ein Adopter die vendored Baseline in seinen Prüfumfang
nimmt, und die Fork-Grenze, deren Konsument sich erst zeigen muss.

## Welle 50 — 2026-07-27 · Was mit `MR-*`-Adaptionen passiert, wenn die Baseline weiterzieht

### Hinzugefügt

- **[Modul 2](kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md)
  §Freshness-Audit: der Review geht durch die Adaptions-Liste, nicht nur durch
  den Diff.** Bisher stand dort nur „ein neuer Tag löst einen Review aus" — was
  dieser Review umfasst, war nirgends gesagt, und `MR` kam im ganzen Abschnitt
  nicht vor. Ein Adopter bekam also die Aufforderung zu reviewen, aber nicht den
  Hinweis, seine eigenen Abweichungen gegen die neue Fassung zu halten. Jede
  `MR-<NNN>` trägt ein Pflichtfeld *Auflösungs-Trigger oder „permanent"*, und ein
  neuer Baseline-Stand ist genau das Ereignis, das solche Trigger feuert — ein
  Trigger, den niemand abfragt, ist kein Wächter. Fünf Ausgänge pro Eintrag —
  gegenstandslos · bleibt gültig · teilweise überholt · Bezug ist entfallen ·
  widerspricht —, jeweils bezogen auf das **Delta** der neuen Fassung, nicht auf
  den Zustand der Baseline: Eine Adaption weicht definitionsgemäß von einer
  Baseline-Regel ab, eine Zustands-Frage hätte den Normalfall durchfallen lassen.
  Davor ein Formcheck: Ein toter Anker im Geltungsbereich ist
  kein Ausgang, sondern ein Formfehler.
  `permanent`-Einträge werden ausdrücklich mitgeprüft (*permanent* heißt „kein
  automatischer Trigger", nicht „unauflösbar"); war die Adaption eine *Lockerung*
  und die Baseline verschärft, ist ein **Carveout** die richtige Antwort, keine
  stille Dauer-`MR`.
- **Der Review vergleicht auch die Form, nicht nur die Regeln.** Regel-Drift hat
  seit jeher ein Signal (den `Auflösungs-Trigger` einer `MR-<NNN>`), Form-Drift
  hatte keines: Ändert ein neuer Stand die *Struktur* der Artefakte, meldet sich
  nichts. Der Fall ist nicht theoretisch — diese Welle selbst ergänzt zwei Felder
  in `conventions.template.md`, und `harness/conventions.md` ist ein **Singleton**
  (`lab/templates/README.md`: einmal füllen, Template verwerfen). Neu: Nach dem
  Re-Vendoring ist die vendored Referenz-Form unter
  `.harness/baseline/<tag>/templates/` die Vergleichsgrundlage — neue *optionale*
  Felder brauchen keinen Rückbau, neue **Pflicht**-Felder und umbenannte
  Sektionen schon; für wiederkehrende Templates gilt Append-only (neue Instanzen
  folgen der neuen Form, bestehende werden nicht umgeschrieben). Dazu präzisiert
  `lab/templates/README.md`, dass „`.template.md` verwerfen" die Kopie im
  Arbeitsbaum meint, nicht die vendored Referenz-Form.
- **Rückbau ist ein neuer Eintrag, kein Edit** — mit Slot im ausgelieferten
  Artefakt: `conventions.template.md` trägt jetzt die Felder *Löst auf* und
  *Ausgelöst durch Baseline-Stand*. Vorher hätte die Regel in ein Skelett
  geschrieben werden müssen, das dafür kein Feld hat.
- **Selbstcheck, Rubrik-Zeile, Themen-Bullet und die zugehörige Antwort in
  [`loesungen/modul-02-loesung.md`](kurs/de/loesungen/modul-02-loesung.md)** in Modul 2 — der ganze
  §Freshness-Audit war didaktisch ungedeckt (kein Thema, kein Item, keine
  Rubrik), und diese Welle hängt zwei weitere normative Regeln daran.

### Geändert

- **[`konventionen.md`](kurs/de/grundlagen/konventionen.md) §Source Precedence
  ordnet `harness/conventions.md` und die vendored Baseline ein** — beide
  bewusst **außerhalb** der Rangliste. Der Konventionsspeicher ist kein weiterer
  Rang, sondern die Stelle, an die die rangierten Dokumente Form- und
  Strukturfragen *abtreten*: Wo `AGENTS.md` oder `harness/README.md` dazu nichts
  sagen, entsteht kein Konflikt, sondern eine Zuständigkeit — die Rangliste
  entscheidet über *Inhalt*, der Konventionsspeicher über *Form*. Ein zehnter
  Rang wäre zudem praktisch falsch: Modul 1 nennt neun Ränge als Maximum, und
  die ausgelieferte Template-Form ist mit drei Spec-Straten bereits dort.
- **Die Anschlussregel steht jetzt da, wo sie gesucht wird:** Eine `MR-<NNN>`
  gilt innerhalb ihres deklarierten Geltungsbereichs vor der Baseline, außerhalb
  gilt die Baseline unverändert. Daraus die Grenze — eine `MR-<NNN>`, deren
  Geltungsbereich die *gesamte* Baseline umfasst, ist kein Adaptions-Eintrag
  mehr, sondern ein **Fork**; eine *fehlende* Angabe ist kein eigener Fall,
  sondern ein Formfehler (Pflichtfeld).
- **Pflichtfeld-Liste des Adaptions-Blocks vervollständigt** — das Feld
  *Adaption* fehlte, obwohl das Template es seit jeher führt.
- **Rangzahl-Kollision bereinigt:** `konventionen.md` bezeichnete an anderer
  Stelle `harness/README.md` als „Rang 9" — eine Zahl aus der Template-Form, die
  gegen die Default-Liste mit acht Rängen stand. Jetzt rangagnostisch („unterster
  Rang"). Dazu ergänzt `AGENTS.template.md` die fehlende `docs/user/*`-Zeile:
  Die ausgelieferten Träger einer Precedence-Tabelle — die drei Singleton-Templates
  **und** `lab/example/AGENTS.md` — trugen bis dahin zwei verschiedene
  Rangordnungen (8 vs. 9 Ränge, README einmal auf 6, einmal auf 7); im
  Begleit-Lab existiert `docs/user/` sogar, fehlte in `AGENTS.md` aber.
- **Ablösung und Schärfung getrennt:** `Löst auf` gilt für die Ablösung; eine
  bloße *Schärfung* (der alte Eintrag gilt weiter, enger) steht wie bisher im
  Titel — `(schärft MR-<NNN>)`, wie in Modul 13 §Worked Example B.
- **Regelwerk-Splits `grundlagen-konventionen` und `modul-02` mitgezogen**,
  Stand-Zeile auf Welle 50.
- **Vier offene Punkte als Fäden in [`docs/roadmap.md`](docs/roadmap.md)** statt
  in dieser Welle miterledigt: mechanische Wächter gegen Doku-Drift, die
  widersprüchliche Spec-Strata-Adaptionsrichtung in den Templates (vorbestehend),
  die Fork-Grenze ohne Konsument und der Formcheck, der ins Gate gehört. Fünf
  Review-Runden über diese Welle fanden dreimal dieselben Fehlerklassen — Echo
  nicht mitgezogen, Pointer ohne Ziel, Ausgang nicht ausführbar —, und mindestens
  vier Befunde wären maschinell gefallen. Das ist der Grund für den ersten Faden.
- **Diagramm und Konfliktregel nachgezogen:** Der Precedence-Graph zeigt die
  Harness-Schicht und die Baseline als eigene Ebene, die Legende kennt die neue
  graue Farbe, und die Konfliktregel nennt `harness/conventions.md` mit.

## Welle 49 — 2026-07-27 · Zwei Korrekturen nach v3.8.0: Quellen-Titel und ein Faden, der keiner war

### Behoben

- **Böckeler-Artikeltitel am Original geprüft.** Er lautet
  *„Harness engineering for coding agent users"* — klein geschrieben und mit
  „users". `quellen.md` trug seit jeher *„Harness Engineering for Coding Agents"*,
  und in Welle 48 wurde der README-Text nach dieser Abschrift „korrigiert" — eine
  richtige Fassung durch eine falsche ersetzt. Der Fehler ist methodisch: Für
  einen externen Titel ist eine repo-interne Datei kein Beleg. Beide Stellen
  stehen jetzt auf dem am Original geprüften Wortlaut, `quellen.md` zusätzlich mit
  Erscheinungsdatum. Die verlinkte URL war bereits die kanonische
  (`articles/harness-engineering.html` liefert HTTP 200; der
  `exploring-gen-ai/`-Pfad antwortet mit 301 auf ebendiese).

### Geändert

- **[Modul 6](kurs/de/02-planung/modul-06-roadmap.md) beantwortet den
  Vorwärts-Blick für wellenlose Arbeit.** Der nach Welle 48 offene Faden
  behauptete, wellenlose Arbeit habe kein „Soll" — nur ein „Ist" über
  `ls in-progress/`. Gegen Modul 5 gehalten hält das nicht: `next/` heißt
  *priorisiert/eingeplant*, und `open→next` **ist** die Priorisierungs-
  Entscheidung — seit Welle 48 wellenneutral formuliert. Der tragende Punkt liegt
  tiefer: Eine Reihenfolge *einzelner* Slices kennt der Harness überhaupt nicht,
  auch nicht für wellengebundene Arbeit. Die Roadmap ordnet **Wellen**, die Spalte
  *Wichtigste Slices* nennt Inhalt statt Rang, und `slice.template.md` hat kein
  Prioritätsfeld. Der Faden behauptete also einen Nachteil, den es nicht gibt; er
  ist **aufgelöst, nicht gelöst**. Modul 6 warnt an derselben Stelle davor, für
  wellenlose Arbeit eine Rangliste neben der Roadmap anzulegen — das wäre eine
  Sortierung, die es für Slices nie gab, und die zweite Quelle, die die Regel
  darüber gerade vermeidet. Regelwerk-Split mitgezogen.
- **`docs/roadmap.md`**: Faden entfernt, Drift-Tabelle trägt die Begründung
  (inklusive des Fehlers im Fadentext selbst, der `open/` statt `next/` nannte).

## Welle 48 — 2026-07-27 · Wellenlose Arbeit bekommt eine Regel; README neu gefasst

### Hinzugefügt

- **[Modul 6](kurs/de/02-planung/modul-06-roadmap.md) §Wann Arbeit eine Welle
  braucht — und wann nicht.** Das Roadmap-Format ist wellen-zentriert (fünf
  Abschnitte, alle über Wellen), und `slice.template.md` bot seit jeher den Wert
  `ohne Welle` an — ohne dass die Quelle den Begriff kannte. Für einen einzelnen
  Slice gab es damit keinen Ort, und der Fehlgebrauch ist beobachtet: Die Arbeit
  landet unter *Aktuelle Welle*, bis der Abschnitt seitenlang ist und zugleich
  meldet, dass keine Welle läuft. Die Regel ist aus dem Kernbegriff hergeleitet
  („Bündel von Slices, das gemeinsam **abgeschlossen** wird"): **Eine Welle liegt
  vor, wenn es eine beobachtbare Closure-Bedingung gibt, die mehr beobachtet, als
  die DoDs ihrer Slices schon belegen.** Kein Größen-Kriterium — ein
  Ein-Slice-Bündel bleibt eine Welle, wenn sein Trigger repo-weite Belege fordert.
- **Wellenlose Arbeit erscheint nicht in der Roadmap.** Ihr Zustand ist die
  Verzeichnis-Position ([Modul 5](kurs/de/02-planung/modul-05-planning-harness.md));
  ein Eintrag daneben wäre eine zweite Quelle für denselben Zustand. Einzige
  Berührung: liefert sie den letzten Beleg eines Meilensteins, bleibt die Spalte
  `Welle(n)` leer und der Beleg steht als Slice-ID daneben.
- **Übung, Selbstcheck und Lösung** zur neuen Regel (beide auf LZ 2, das dafür um
  *„erkennen, wann Arbeit ganz ohne Welle läuft"* erweitert wurde) — mit dem
  Gegenfall, an dem sich zeigt, ob jemand das Kriterium oder bloß die Slice-Zahl
  anwendet.
- **`lab/example/…/done/slice-020-referenz-richtung-repariert.md`** — erster
  wellenloser Slice im Begleit-Lab; der Template-Wert `ohne Welle` hatte bis dahin
  kein Vorbild. Reaktiv ausgelöst durch `make check-references`, mit einem Risiko
  im Ausgang *weiter offen*, das in die nächste Welle-Closure abliefert.

### Geändert

- **Welle-Closure Schritt 3 verdichtet jetzt *alle* Slice-Closures seit der letzten
  Welle-Closure**, die wellenlosen eingeschlossen — vorher nur „die Slices dieser
  Welle". Ohne diese Korrektur hätte die neue Regel drei Wächter still abgeschaltet:
  Der Steering-Loop-Zähler (1×/2×/3×) entsteht ausschließlich in diesem Schritt, der
  Risiko-Ausgang *weiter offen* hat dort sein einziges Ziel, und die Carveout-Frist
  („seit > 2 Wellen aktiv", [Modul 7](kurs/de/02-planung/modul-07-carveouts.md))
  misst in Wellen. Ein Modus ohne Wächter wäre genau die Pathologie, die Welle 44
  als *„ein Trigger ohne Wächter ist eine Absichtserklärung mit Verfallsdatum"*
  benannt hat.
- **Zwei Mermaid-Diagramme kodierten die Kopplung mit** und wurden nachgezogen: der
  Steering-Loop-Graph in
  [`konventionen.md`](kurs/de/grundlagen/konventionen.md) (Knoten „Welle-Closure
  Schritt 3") und das Lifecycle-Zustandsdiagramm in Modul 5 (`open --> next: in
  Welle priorisiert` → `priorisiert/eingeplant`; Note „bei der **nächsten**
  Welle-Closure"). Die Abhängigkeitsgraphen in `roadmap.template.md` und im Lab
  bleiben unberührt — sie zeigen Wellen-Reihenfolgen, kein Slice-Routing.
- **Verzeichniskonvention entkoppelt.** Der Kommentar zu `docs/plan/planning/next/`
  lautete `# priorisiert für die nächste Welle` und band das Verzeichnis an einen
  Wellen-Betrieb, den es nicht voraussetzt — jetzt `# priorisiert/eingeplant`, in
  [`konventionen.md`](kurs/de/grundlagen/konventionen.md) und im Regelwerks-Spiegel.
  Normativ gewichtiger als die Diagramm-Labels darüber: Adopter kopieren diesen
  Block.
- **`welle-results.template.md`** zitierte die ersetzte Schritt-3-Formulierung
  wörtlich („Grundlage sind die Closure-Notizen der Slices dieser Welle") und
  kodierte damit den Ausschluss wellenloser Slices in genau dem Artefakt, das
  Adopter kopieren. `lab/templates/` ist gate-ignoriert — `make check` sieht das nie.
- **`slice.template.md`** trägt statt der unverankerten Klammer `(Wartung/Spike)`
  jetzt den Trigger-Grund und verweist auf den Regelwerks-Abschnitt. Die Klammer
  engte falsch ein: entscheidend ist die fehlende eigenständige Closure-Bedingung,
  nicht die Art der Arbeit.
- **README neu gefasst** (Commit `85d46f1`): Schnellstart-Block, eigener Abschnitt
  *Einordnung der Quellen* mit den Belegen zu Böckeler und Lopopolo, Adoptions-
  schritte inline. **Korrigiert dabei eine Falschaussage aus Welle 47**: dort stand,
  `ai-harness-init` führe „dieselben Schritte" aus wie der manuelle Weg. Das
  stimmt nicht — das CLI richtet ein Repo samt lauffähiger Gates ein, kennt
  `add-lang` für Mono-Repos und `--arch` für die Bauform, während das Baseline
  Bundle Regelwerk und Templates liefert. Eine Vergleichstabelle sagt das jetzt.
  Versionsgebundene Angaben (Versionsstand, Plattform-Zahl, Sprachliste) sind
  entfernt, damit der Text nicht bei jedem CLI-Release nachzieht.

## Welle 47 — 2026-07-26 · Bootstrap-Werkzeug verlinkt; Adopter-Zählung korrigiert

### Hinzugefügt

- **README §Adoptieren verweist auf [`ai-harness-init`](https://github.com/pt9912/ai-harness-init)** —
  das CLI führt dieselben Schritte aus, die der Abschnitt von Hand beschreibt
  (Skelette, Gate-Baseline, vendored Regelwerk unter `.harness/baseline/`,
  idempotent). Bewusst als **eigenes Projekt** ausgewiesen (MIT, Stand v0.x,
  nicht Bestandteil des Kurses) und mit der ehrlichen Gegenrechnung: es braucht
  Docker, Git und `make`, der manuelle Weg kommt ohne Installation aus. Dazu
  der Satz, der die Rollen trennt: *das Werkzeug nimmt die Handgriffe ab, nicht
  die Entscheidungen* — wer wissen will, was entsteht, liest Modul 2.

### Geändert

- **Faktenfehler in `docs/roadmap.md` korrigiert (aus Welle 45).** Der Faden
  *Discovery-Register* trug die Klammer „(heute nur `d-check`)" — falsch, und
  schon beim Schreiben falsch: Das CHANGELOG weist `ai-harness-init` **dreimal**
  als Adopter mit eigenen `MR-007`, `MR-008` und `MR-010` aus, der drei
  Kurs-Lücken aufdeckte (d-check.mk-Drift, Instanziierungs-Zeitpunkt,
  Baseline-Freshness). Es gibt also **zwei** Konsument-Repos, nicht eines.
  Der Faktencheck des Reviews hatte den Satzteil nicht erfasst, weil er die
  Welle-33-Formulierung verglich, nicht die Klammer.
  **Der Faden bleibt trotzdem vertagt** — und die Roadmap sagt jetzt genauer,
  warum: Der Trigger hat zwei Hälften. *Zweites Konsument-Repo* ist erfüllt;
  *derselbe Druck* ist es nicht — für einen Bedarf an einem
  Discovery-/Kandidaten-Register in `ai-harness-init` gibt es keinen Beleg. Die
  Verallgemeinerung braucht die wiederholte **Beobachtung**, nicht nur einen
  zweiten Adopter.

## Welle 46 — 2026-07-26 · „Jedes Artefakt hat einen Konsumenten" wird auffindbar — und ehrlich eingeordnet

Auslöser war die Rückfrage, wo dieser „Graph-Test" eigentlich steht. Antwort:
**nirgends in der Lehre.** Der Begriff kam ausschließlich in
CHANGELOG-Einträgen dieser Sitzung vor; im Kurs existierte **ein Satz** in
einer Diagramm-Nachbesprechung (`konventionen.md`) — ohne Namen, ohne eigene
Überschrift, ohne Anker, nicht im Regelwerk-Split. Damit war ausgerechnet die
Regel, die verlangt, dass jedes geschriebene Artefakt einen Leser hat, selbst
so abgelegt, dass der Adopter sie nicht liest.

### Hinzugefügt

- **`konventionen.md` §Jedes Artefakt hat einen Konsumenten** — eigener
  Abschnitt mit Anker statt Satz im Fließtext. Regel: Wer dem Harness ein
  Artefakt hinzufügt, benennt, *wer es liest und wann*; findet sich kein
  Leser, ist es Ablage, keine Steuerung. Das Fluss-Diagramm bleibt, wo es ist,
  und ist jetzt ausdrücklich die *Illustration* der Regel, nicht ihr Träger.
- **Zwei Ausnahmen benannt**, die in den Wellen 40–43 empirisch aufgetreten
  sind: **derivative Artefakte** (Index; braucht keinen Leser, aber eine
  Deckung — sonst schlägt die Probe falschen Alarm) und **Lauf-Belege**
  (Konsument ist der Vorgang und danach der Audit).
- **In den Regelwerk-Split übernommen** (Anker
  `#jedes-artefakt-hat-einen-konsumenten`) — die Regel ist operativ genug für
  einen Adopter, der seinen Harness erweitert. Das Diagramm bleibt draußen:
  Illustration ist Didaktik.

### Geändert

- **Ehrlich eingeordnet statt hochgestuft.** Die Regel ist *inferential
  feedforward* und greift zur **Entwurfszeit** — beim Erweitern des Harness,
  nicht in seinem Betrieb. Sie wird **ausdrücklich kein Prüfpunkt der
  Closure-Prozedur**: dort spräche sie in den meisten Wellen auf nichts an,
  würde nach der dritten Welle übersprungen und wäre danach eine Harness-Lüge
  (Modul 13: *„wenn ein Gate manchmal rot sein darf, ist es kein Gate"*). Der
  häufige Fall ist ohnehin gedeckt — eine Beobachtung, die die Schwelle
  erreicht, hat ihren Leser automatisch, und die Anker-Paarung prüft
  deterministisch, dass die Regel landete.
  Dazu die Grenze: Die Regel sagt **nicht**, ob ein genannter Konsument den
  Inhalt auch *nutzt*. *„Wird beim Audit gelesen"* ist eine gültige und
  zugleich die schwächste Antwort.

## Welle 45 — 2026-07-26 · Das Kurs-Repo bekommt eine Roadmap (und deklariert seine Reduktion)

### Hinzugefügt

- **`docs/roadmap.md`.** Befund beim Nachsehen: Das Repo hatte **keine Roadmap
  und überhaupt keine eigenen Harness-Artefakte** (kein `AGENTS.md`, kein
  `harness/`, kein `spec/`). Faktisch läuft hier aber ein *reduzierter* Harness
  — `CHANGELOG.md` als Wellen-Register, `make check` als Gates, d-check per
  Digest gepinnt. Der Harness war also nicht abwesend, sondern **unvollständig
  und undeklariert** — dieselbe Klasse wie eine unbegründete Grenze: liest sich
  als Rückstand statt als Entscheidung.
  Die Roadmap ist das **Gegenstück zum CHANGELOG**: dort steht, was geschlossen
  wurde, hier, was offen ist und *woran man erkennt, dass es dran ist*. Vorher
  lagen die offenen Fäden als Fließtext in alten Wellen-Einträgen —
  write-only, dieselbe Klasse, die die Wellen 38–44 fünfmal behoben haben.
  Geführt werden vier Fäden mit Trigger-Spalte; wo kein beobachtbarer Trigger
  existiert, steht ausdrücklich **„nicht gesetzt"** statt eines erfundenen
  Termins — ein Faden ohne Trigger ist ein Wunsch, kein Plan (Modul 6).
- **Die Pfad-Abweichung ist deklariert.** Der Kurs lehrt
  `docs/plan/planning/in-progress/roadmap.md`; dieses Repo führt die Roadmap
  **flach**, weil der gelehrte Pfad die vier Lifecycle-Verzeichnisse
  voraussetzt — die ohne Slice-Betrieb anzulegen wäre *„Struktur ohne
  Substanz"*, genau wovor die Sub-Area-Qualifikation warnt. Der Ausbau zu einem
  `harness/conventions.md` (Variante B der Diskussion) steht als eigener Faden
  in der Roadmap, **mit beobachtbarem Trigger**: *sobald die Roadmap eine
  zweite Adaption gegenüber dem gelehrten Aufbau braucht*.
- **Im README verdrahtet** — sonst wäre die Roadmap selbst write-only gewesen.

## Welle 44 — 2026-07-26 · Graph-Test systematisch: ein Trigger ohne Wächter

Der Konsumenten-Test aus Welle 39 wurde erstmals **über alle ~70
Template-Sektionen** gezogen statt punktuell. Die meisten sind trivial
konsumiert (Spec/ADR/AGENTS werden per Source Precedence in jedem Lauf
gelesen). Drei Befunde blieben — und der erste ist generalisierbar.

### Hinzugefügt

- **Trigger-Audit statt Carveout-Audit (Modul 6 Schritt 2).** Der Harness kennt
  **drei** Artefaktklassen mit einem Trigger; geprüft wurde bisher genau eine:

  | Artefakt | Trigger | Wächter vorher |
  |---|---|---|
  | Carveout | Auflösungs-Trigger | Carveout-Audit pro Welle ✓ |
  | Bootstrap-aware Gate | Hochschalt-Trigger | **keiner** |
  | ADR | Re-Evaluierungs-Trigger | **keiner** |

  Der Kurs benannte die Pathologie bereits — aber nur für Carveouts
  (*Carveout-Wildwuchs: temporäre Ausnahmen, deren Trigger längst eingetreten
  ist*). Dieselbe Verfallsform für Gates (ewig 40 %, obwohl M2 erreicht ist)
  und ADRs (Entscheidung, deren Re-Evaluierungs-Bedingung vor einem Jahr
  eintrat) hatte weder Namen noch Wächter. Schritt 2 prüft jetzt alle drei;
  `klassifikation.md` §Entropy Management führt die zwei fehlenden
  Verfallsformen (*Stehengebliebene Reifestufe*, *Abgelaufene Entscheidung*).
  Leitsatz: **ein Trigger ohne Wächter ist eine Absichtserklärung mit
  Verfallsdatum.**

### Geändert

- **`Re-Evaluierungs-Trigger` in Modul 4 verankert.** Er stand nur im
  ADR-Template und in der *Lösung* — Modul 4 nannte als MADR-Pflichtabschnitte
  nur Kontext · Optionen · Entscheidung · Konsequenzen. Template-Struktur ohne
  Quell-Verankerung, dieselbe Klasse wie der Welle-33-Defekt. Jetzt in
  §Kernidee erklärt, im Lernziel und in der Selbstcheck-Rubrik geführt.
- **`Out-of-Scope` für die Welle verankert.** `welle.template.md` §6 trug
  *„Out-of-Scope für diese Welle"* — der Kurs lehrt Out-of-Scope für das
  Lastenheft (Modul 3) und den Slice-Plan (Modul 9), für die **Welle
  nirgends**. Jetzt Teil von Schritt 1 der Wellen-Eröffnung, mit Begründung:
  was nicht ausdrücklich ausgeschlossen ist, dehnt die Welle, bis der
  Closure-Trigger unerreichbar wird.
- **Satelliten:** Regelwerk-Splits `modul-04`, `modul-06`,
  `grundlagen-klassifikation`.

**Geprüft und in Ordnung** (Nicht-Befunde des Sweeps): `roadmap`
§Historische Trigger-Verschiebungen ist als *Audit-Signal* deklariert —
Lauf-Beleg-Klasse wie `docs/reviews/`. ADR §Geschichte, Carveout §Geschichte
und die Spec-§Historie sind Audit- bzw. CR-Fußabdruck (Welle 34). Alle
Spec-/AGENTS-/`harness/README`-Sektionen werden per Source Precedence in jedem
Lauf gelesen. Skills §Pflege ist seit Welle 43 verdrahtet.

## Welle 43 — 2026-07-26 · Review-Findings finden ihren Zähler — ohne Archiv-Scan

Letzte offene Stelle aus dem Konsumenten-Audit: Modul 10 §Pflege verlangt
*„bei dreimaligem Auftreten desselben Findings"* zu schärfen — und dieser
3×-Regel fehlte der Zähler, genau wie der Steering-Loop-Regel vor Welle 38.
`docs/reviews/` wächst um eine Datei pro Lauf und wurde über Läufe hinweg von
niemandem gelesen.

### Geändert

- **`docs/reviews/` umgedeutet: Lauf-Beleg statt Wissensspeicher.** Der Report
  belegt *diesen Diff, mit diesem Skill, diesem Modell, diesem Verdikt*; sein
  Konsument ist der Implementer im selben Zyklus (bereits deklariert) und
  danach der Audit. **Er braucht keinen Leser über Läufe hinweg** — und einen
  zu bauen wäre der falsche Reflex gewesen (Archiv-Scan = vierter Mechanismus).
- **Das steuerungsrelevante Signal ist die Finding-Klasse, nicht der Report.**
  Neues Feld `klasse` pro Finding plus Summary-Zeile *Finding-Klassen dieses
  Laufs*; von dort über die Slice-Closure §7 in denselben Zähler, den Welle 38
  gebaut hat. **Niemand muss wissen, ob eine Klasse „schon mal" auftrat** —
  genau dafür ist der Zähler da: der Reviewer benennt einmal pro Lauf, die
  Häufung entsteht bei der Verdichtung über die Slices einer Welle.
- **Modul 10 Schritt 6 sagt jetzt, wer zählt.** Bisher stand dort „bei
  dreimaligem Auftreten" in einem Skill-Block — der Skill kann das gar nicht
  zählen, weil jeder Lauf für sich steht. Er formuliert nur noch, *was bei
  Erreichen der Schwelle zu tun ist*.
- **Damit hat der Closure-Eintrag drei deklarierte Quellen** (Modul 5): eigene
  Beobachtung · offenes Risiko aus §6 (Welle 40) · wiederkehrende
  Finding-Klasse (diese Welle). Alle drei nehmen dieselbe Route und brauchen
  dieselbe **stabile Bezeichnung** — zwei Namen für dasselbe Muster werden
  getrennt gezählt und erreichen die Schwelle nie.
- Damit wird auch der Graph aus Welle 39/41 wahr: Er nennt *Review-Findings*
  als Beobachtungs-Quelle, ohne dass es dafür bisher einen Weg gab.
- **Satelliten:** Regelwerk-Splits `modul-05`/`modul-10`; `lab/example` zeigt
  die dritte Quelle real (Finding-Klasse als 2×-Beobachtung).

## Welle 42 — 2026-07-26 · Validierung: Widerspruch aufgelöst, Abwesenheit begründet

Auslöser war die Frage „Validierung kommt nicht vor — warum nicht?". Antwort:
Es war **keine Entscheidung, sondern ein unabgeglichener Widerspruch** — drei
Aussagen, zwei davon im selben Modul, 35 Zeilen auseinander.

| Wo | Aussage |
|---|---|
| Modul 8 §Rollen-Sequenz | Validator sitzt **in jeder Slice-Sequenz** |
| Modul 8 §Fehlvorstellungen | Validierung gehört **vor** größere Wellen und **nach jedem MVP-Slice** — also nicht pro Slice |
| Modul 1 + `konventionen.md` | Validierung kommt in der Artefaktkette **gar nicht vor** |

Die Auflösung lag bereits im Repo, nur unausgesprochen: Die
Artefaktklassen-Tabelle (Welle 36) ordnet den Validator unter **„keins"** ein,
*weil die Prüfgrundlage außerhalb des Repos liegt*. Damit ist die Abwesenheit
aus der Artefaktkette sachlich richtig — die Kette ist eine Kette von
**Repo-Artefakten**, und Validierung hinterlässt keines.

### Geändert

- **Kadenz ehrlich gemacht:** Die beiden Validator-Kanten stehen im
  Sequenzdiagramm jetzt in einem `opt`-Block *„nur bei MVP-Slice — nicht in
  jeder Sequenz"*. Vorher zeigte das Diagramm den Validator in jedem Slice,
  während der Fließtext desselben Moduls das Gegenteil sagte. Begründung
  ergänzt: Validierung an jeden Slice zu hängen wäre so teuer, dass sie in der
  Praxis ganz entfiele. Selbstcheck-Rubrik („neun Übergabe-Artefakte") um die
  Bedingung ergänzt.
- **Abwesenheit begründet statt stumm gelassen** — Modul 1 §Lebenszyklus und
  `konventionen.md` §Kernbegriffe (SDLC-Zeile) sagen jetzt, *warum* Validierung
  keine Station hat, und verweisen auf die Rollen-Sequenz als ihren Ort. Eine
  unbegründete Abwesenheit ist dieselbe Klasse wie eine unbegründete Grenze:
  sie liest sich als Rückstand statt als Entscheidung.
- **Validierungsbeleg als repo-extern deklariert.** Er hat keine Ziel-Form und
  keinen Ort — **weil er keinen haben kann**, nicht weil eine Lücke besteht.
  Damit ist auch der Audit-Befund von vorhin aufgelöst. Was aus einer
  Validierung *ins Repo* zurückwirkt, ist eine **Spec-Änderung** (externer
  CR-Prozess, Welle 34) oder ein **Lerneintrag** in der Closure-Notiz; der
  Beleg selbst bleibt draußen.
- **Satelliten:** Regelwerk-Splits `modul-08` (Sequenz, Kadenz, repo-extern) und
  `grundlagen-konventionen` (SDLC-Zeile).

## Welle 41 — 2026-07-26 · Der fehlende Lese-Schritt: Slice-Closures werden verdichtet

### Hinzugefügt

- **Modul 6 Schritt 3 liest jetzt, bevor er schreibt.** Der Graph aus Welle 39
  zeichnet eine Kante *Slice-Closure §7 → „Wie oft?"* — für die es **keinen
  Schritt gab**. Verifiziert: null Treffer für eine Anweisung, die Closure-Notizen
  der Slices einer Welle zu lesen. Die Welle-Closure *schrieb*
  §Steering-Loop-Einträge und §Beobachtungen unter Schwelle; woher deren Inhalt
  kommt, sagte niemand. Folgen: (a) der **Slice**-Lerneintrag war selbst
  write-only — dasselbe Problem eine Ebene tiefer als Welle 38; (b) die
  3×-Zählung war gar **nicht durchführbar**, denn ob eine Beobachtung ein- oder
  dreimal auftrat, steht ausschließlich in den Slice-Closures. Welle 38 hat den
  Zähler gebaut und stillschweigend angenommen, die Einträge erschienen von
  selbst. Jetzt ist *Grundlage sind die Closure-Notizen der Slices dieser Welle*
  expliziter Vorlauf von Schritt 3: durchgehen und **verdichten** statt aus dem
  Gedächtnis zusammentragen — gleiche Beobachtungen zusammenfassen und zählen,
  3× → Steering-Loop-Einträge, darunter → Beobachtungen unter Schwelle, Risiken
  mit Ausgang „weiter offen" ebenfalls dorthin.
- **Gegenzeiger von der Schreibseite** (Modul 5): ein Absatz *„Wer liest das?"*
  benennt die Verdichtung und begründet daraus die Pflicht zur *gleichbleibenden
  Bezeichnung* — zwei Namen für dieselbe Sache werden getrennt gezählt und
  erreichen die Schwelle nie.
- **Der Graph trägt die Kante jetzt beschriftet** (`Welle-Closure Schritt 3:
  Slice-Closures verdichten`) statt sie unbenannt zu zeichnen. Eine unbeschriftete
  Kante war genau die Stelle, an der der fehlende Schritt unsichtbar blieb.
- **Zustandsmaschine: `done` ist kein Endzustand der Information.**
  `done --> [*]` behauptete, die Geschichte des Slice ende dort — seit dem
  Lese-Schritt ist `done/` ein *deklarierter Eingang* der Welle-Closure. Das
  Diagramm trägt jetzt eine Notiz am Zustand `done`, die Prosa benennt beide
  Enden: `Slice angelegt` speist sich über §8 aus den offenen Beobachtungen der
  letzten Welle-Closure (bei BF/Hybrid), `done` liefert sie zurück. Der
  Slice-Lifecycle ist an beiden Enden an den Wellen-Zyklus gekoppelt — vorher
  sah er aus wie ein geschlossener Kreis für sich.

### Geändert

- **Modul 1 §Lebenszyklus als Diagramm: der Lerneintrag zeigte an den falschen
  Zielen.** Die Rückwärtskanten gingen nur nach `Spec` und `ADR` — der Kurs
  definiert aber **drei Formen** (*geschärfte Regel · neuer Sensor · benannte
  Spec-Lücke*), und nur die dritte landet in der Spec. Die beiden häufigeren
  gehen in die **verkörperte Form** (`AGENTS.md`, Gate, Skill) — genau die
  Artefakte, auf denen Welle 39 den Herkunfts-Anker aufgebaut hat. Das
  Einstiegs-Diagramm des Kurses ließ sie weg und damit auch die Rückkante, die
  erklärt, *warum* ein Lerneintrag wirkt: die verkörperte Form liegt in jedem
  Lauf-Kontext und beeinflusst den nächsten Code, ohne dass jemand ein Archiv
  liest. Neuer Knoten plus Kante `wirkt auf jeden Lauf` → `Code`; die Prosa
  benennt die drei Formen und verweist für Zähler und Herkunft auf Modul 6 und
  `konventionen.md`.
- **Graph in `konventionen.md` nachgeschärft:** der Verdichtungs-Schritt war nur
  ein *Kantenlabel* — in einem Graphen, dessen Prüffrage auf Knoten-Farben
  beruht (gelb = geschrieben, blau = liest), entzieht sich ein Lese-Schritt als
  Kante genau dieser Prüfung. Jetzt eigener blauer Knoten. Und der Startknoten
  hieß „Agentenlauf", obwohl auch **Review-Findings, Verifikation und
  Validierung** den Loop speisen (Modul 10 §Pflege: *„bei dreimaligem gleichem
  Finding Klassifikation schärfen"*) — heißt jetzt *Beobachtungs-Quellen* und
  nennt alle vier.

## Welle 40 — 2026-07-26 · Graph-Test auf den Bestand angewandt: §6 Risiken war write-only

Der Mermaid-Fluss aus Welle 39 stellt eine Prüffrage — *hat das gelbe Kästchen
ein blaues?* Auf zwei bestehende Sektionen angewandt, die noch nie geprüft
wurden. Ergebnis: eine ist harmlos, eine war der nächste write-only-Fall.

### Hinzugefügt

- **Modul 5 §Offene Risiken werden bei Closure aufgelöst.** `slice.template.md`
  §6 *Risiken und offene Punkte* hatte **null Konsumenten** — `kurs/` und
  `lab/regelwerk/` abgesucht, kein Schritt liest die Sektion. Nicht einmal der
  naheliegende: §7 Closure fragt *„Was ging anders als geplant?"*, ohne §6 je zu
  erwähnen. Und sie ist **nicht derivativ** — ein beim Schnitt notiertes Risiko
  ist Originalinformation, die nirgendwo sonst steht. Damit dieselbe Klasse wie
  der Steering-Loop-Eintrag vor Welle 38: sauber erhoben, nie gelesen.
  Jetzt bekommt jedes Risiko beim Übergang nach `done/` genau **einen** Ausgang
  — *eingetreten* → Carveout oder Folge-Slice mit ID · *entfallen* → gestrichen
  **mit Begründung** (ohne sie ist es stilles Vergessen) · *weiter offen* →
  wandert in *Beobachtungen unter Schwelle* der Welle-Closure. Der dritte
  Ausgang ist der tragende: er hängt das Risiko an den **Zähler aus Welle 38**,
  statt einen zweiten Mechanismus zu erfinden. Ein Risiko, das drei Slices lang
  offen bleibt, erreicht damit die Schwelle — statt dreimal unabhängig notiert
  und dreimal vergessen zu werden. Ein Slice geht nicht nach `done/`, während
  ein Risiko ohne Ausgang dasteht.
- **Folge-Slice-Paarung** als zweite deterministische Prüfung im Carveout-Audit
  (Modul 6 Schritt 2), neben der Anker-Paarung aus Welle 39: jeder in einer
  Closure-Notiz genannte Folge-Slice **existiert als Datei in `open/`**. Beide
  folgen demselben Muster — *Nennung ohne Deckung ist eine Harness-Lüge*.

### Geändert

- **§Folge-Slices als *derivativ* gekennzeichnet** (`welle-results.template.md`,
  `slice.template.md` §7, Modul 6). Sie ist **kein** write-only-Fall: der
  Folge-Slice selbst ist eine Datei in `open/` und wird vom normalen Lifecycle
  konsumiert; die Liste zeigt nur darauf. Die Klasse existierte im Repo bereits
  (ADR-Index, Carveout-Index sind so gelabelt), nur die Kennzeichnung fehlte —
  ohne sie schlägt der Graph-Test hier falschen Alarm.
- **Die Zustandsmaschine nachgezogen.** Der neue Ausgangs-Zwang sitzt am
  Übergang `in-progress → done` — und **fünf** Beschreibungen dieses Übergangs
  sagten weiter nur „DoD erfüllt + Lerneintrag": das Mermaid-Diagramm in Modul 5,
  die Prosa darunter, die Selbstcheck-Rubrik, beide Stellen im Regelwerk-Split
  und die DoD-Checkliste in `slice.template.md`. Das ist **Entgleisung #2 aus
  Worked Example B** (*„der Hook wird geschärft, die Doku bleibt auf dem Stand
  von vorher"*) — begangen zwei Wellen nach dem Aufschreiben, gefunden durch die
  Rückfrage „ist das noch aktuell?". Alle fünf tragen jetzt
  `DoD + Lerneintrag + Risiko-Ausgänge`.
- **Satelliten:** Regelwerk-Splits `modul-05` (Risiko-Auflösung) und `modul-06`
  (zweite Paarung, Derivativ-Label); `lab/example` zeigt beide Formen real —
  `slice-009` §6 mit zwei Ausgängen (einer *entfallen* mit Messwert, einer
  *weiter offen*), und der offene wandert nachvollziehbar in die
  Beobachtungen-Tabelle von `welle-1-results.md`.

## Welle 39 — 2026-07-26 · Herkunfts-Anker: Regeln nennen die Welle, aus der sie stammen

### Hinzugefügt

- **`konventionen.md` §Herkunfts-Anker für Steering-Loop-Regeln.** Welle 38 hat
  die Beobachtungen *unter* der Schwelle abfragbar gemacht; offen blieb die
  andere Hälfte: Eine **verkörperte** Regel (AGENTS-Hard-Rule, Gate,
  Skill-Eintrag) trägt ihre Begründung nicht bei sich. Von der Regel aus führte
  kein Weg zur auslösenden Beobachtung — und Worked Example B (Welle 35) sagt,
  was dann passiert: *„beim nächsten Aufräumen wirkt sie wie Overengineering und
  fliegt raus."* Der Anker ist **kein neues Konstrukt**, sondern der
  Traceability-Constraint angewandt auf das *Artefakt* statt auf den *Commit*:
  ein Feld `seit welle-<NN>` im Make-Target-Kommentar, an der Hard-Rule-Zeile
  bzw. am Skill-Eintrag. Der Adaptions-Block trug das Muster über sein Feld
  *Begründung* bereits — der Anker verallgemeinert es.
  **Geltungsbereich bewusst eng:** nur Regeln aus dem Steering Loop (3× erreicht);
  was aus Lastenheft/Spec/ADR folgt, trägt schon eine ID.
  **Ziel ist die Welle, nicht der Slice** — `done/welle-<NN>-results.md`
  §Steering-Loop-Einträge nennt seit Welle 38 das Trio *Regel · stabile
  Bezeichnung · Slice-Belege*, der Anker löst also in **einem Hop** auf und ist
  grob genug, um nicht zu verrotten. **Ab Einführung, kein Nachrüsten:**
  `seit unbekannt` wäre eine Harness-Lüge, der leere Zustand ist die ehrliche
  Information.
- **Zwei Sensoren.** *Anker-Paarung* (computational feedback): Die Prüfung läuft
  **von der Closure-Notiz nach außen**, nicht von der Regel nach innen — von der
  Regel aus ist nicht entscheidbar, ob sie einen Anker braucht, von der Closure
  aus schon. Pro Steering-Loop-Eintrag: Zielort genannt · Pfad existiert · Ziel
  trägt `seit welle-<NN>`. Rot bei: Regel nie geschrieben, still gelöscht, Anker
  vergessen — dieselbe Klasse wie ein *halluziniertes Gate*, auf Regeln statt auf
  Make-Targets angewandt; läuft im Carveout-Audit der Welle-Closure mit.
  Grenze ehrlich benannt: erzwingt den Anker nur für **deklarierte** Regeln.
  *Retirement-Check* (inferential, **ereignis**-getriggert, kein periodischer
  Sweep — der Kurs verbietet Kalender-Trigger): Eine Regel mit Anker wird nicht
  entfernt oder gelockert, ohne dass die Herkunft konsultiert wurde
  (*„seit welle-3 — ist die Beobachtung wieder aufgetreten?"*). Gleiche Bauart
  wie „Gates dürfen nicht ohne ADR gelockert werden". Er ist der **Konsument**
  des Ankers; ohne ihn wäre der Anker eine zweite write-only-Ablage — genau der
  Fehler, den Welle 38 behoben hat.
- **Mermaid-Fluss „jedes Artefakt hat einen Konsumenten".** Beide Schleifen in
  einem Bild: links der Zähler für Beobachtungen unter der Schwelle
  (Welle-Closure → Wellen-Eröffnung → Slice-Planung), rechts die verkörperte
  Regel mit Anker (Closure → Regel → Retirement-Check → Closure). Gelb = wird
  geschrieben, blau = liest. Als Prüffrage für künftige Erweiterungen
  formuliert: *hat das neue gelbe Kästchen ein blaues?* Hat es keines, ist es
  Ablage, keine Steuerung.

### Geändert

- **`welle-results.template.md`: Zielort wird Pflichtfeld** im
  Steering-Loop-Eintrag (bisher freie Prosa) — er ist die eine Hälfte der
  maschinell prüfbaren Paarung. Abgewogen gegen Modul 16 (*„eine Checkliste ohne
  Belege ist Bürokratie"*): gerechtfertigt, weil das Feld **der Beleg selbst**
  ist und nicht ein Häkchen daneben.
- **Anker-Form in den drei Regel-Klassen verankert** — Modul 13 (Gate-Target-
  Kommentar), Modul 9 (Hard-Rule-Zeile), Modul 10 (Skill-Eintrag), je als
  Ein-Satz-Verweis. Die Regel selbst steht **einmal** in `konventionen.md`, nicht
  viermal — sonst hätte dieselbe Regel vier Orte und exakt das Drift-Problem,
  das der Kurs bekämpft.
- **Satelliten:** Regelwerk-Splits `grundlagen-konventionen` (Anker
  `#herkunfts-anker`), `modul-06`, `modul-09`, `modul-10`, `modul-13`;
  `lab/example/…/welle-1-results.md` zeigt die Paarung jetzt real (Zielort +
  Slice-Belege je Eintrag) statt sie nur zu behaupten.

## Welle 38 — 2026-07-26 · Der Steering Loop bekommt seinen Zähler — und einen Konsumenten

### Hinzugefügt

- **Sektion „Beobachtungen unter Schwelle" in der Welle-Closure (Modul 6
  Schritt 3).** Befund: Der Steering Loop schreibt seine eigene Zählregel vor
  (*1× notieren · 2× Symptom · 3× Lücke*) und lieferte **keinen Zähler**.
  Verifiziert: **kein einziger Workflow-Schritt liest `done/`** — Modul 9
  (8-Schritt-Workflow), Modul 2 (Bootstrap) und Modul 5 (Planung) auf
  Lese-Zugriffe abgesucht, null Treffer; einziger „Konsument" war die
  Roadmap-Tabelle, und die nimmt nur den Zeiger. Das Steering-Loop-Wissen war
  damit **write-only**. Die Trennlinie, die den Fix zuschneidet: Beobachtungen
  **≥ 3×** sind bereits *verkörpert* (AGENTS-Regel, Gate, Skill) und wirken von
  selbst — die **< 3×** sind nirgends verkörpert und versickerten in der
  Closure-Prosa, sodass der Zähler mit jeder Welle bei null anfing. Ein Fehler
  einmal pro Welle wäre nach fünf Wellen eine 5×-Lücke, die niemand je als
  Lücke sieht. Die neue Sektion wird bei der nächsten Closure **übernommen und
  hochgezählt**, nicht neu geschrieben; bei 3× wandert der Eintrag in die
  Steering-Loop-Einträge und verlässt die Liste. Pflicht: **stabile
  Bezeichnung** über Wellen hinweg (sonst zählt man zwei Namen für dieselbe
  Sache getrennt) und **kein stilles Streichen** (wer streicht, begründet,
  warum die Beobachtung nicht mehr auftreten kann).
- **`welle-results.template.md` — die fehlende Ziel-Form.** `welle-NN-results.md`
  war der **einzige normierte Artefakttyp ohne Template**: Modul 6 normierte
  seinen Inhalt im Fließtext, das Beispiel setzte ihn um, ein Adopter musste
  die Struktur aus einem Prosa-Absatz rekonstruieren. Genau dort driftete auch
  der Dateiname (siehe unten) — wo keine Ziel-Form die Form hält, driftet sie
  zuerst. Trägt die sechs Pflichtteile plus die neue Sektion; `welle.template.md`
  §7 verweist darauf statt nur auf den Dateinamen. `templates/README.md`:
  16 → **17 Skelette**.
- **Wellen-Eröffnungs-Prozedur (Modul 6).** Tieferer Befund hinter dem
  write-only-Problem: **Closure war prozedural ausbuchstabiert (fünf Schritte),
  Eröffnung überhaupt nicht** — weder Modul 5 noch Modul 6 hatten eine
  Anlege-Schrittfolge. Deshalb hatte der Konsum-Schritt keinen Ort zum
  Andocken. Jetzt drei Schritte, deren mittlerer der ist, den Teams zuerst
  weglassen: *offene Beobachtungen der letzten Closure sichten*. Explizit
  abgegrenzt: `done/` kommt **nicht** in den Lauf-Kontext des
  Implementer-Agenten — das ist Planungs-Leistung, und was die Schwelle
  erreicht hat, wirkt ohnehin über die verkörperte Form (Modul-0-Prinzip).

### Geändert

- **Slice-Eröffnung konsumiert die Beobachtungen (Modul 5 + `slice.template.md`).**
  Der Konsum sitzt in Kriterium 3 der Sub-Area-Modus-Begründung
  (*Evidenz- und Diskrepanz-Risiko*) — **kein fünftes Kriterium**, weil die
  Quelle „vier Pflichtkriterien (vier, nicht erweitern)" sagt. Ein Eintrag, der
  eine Sub-Area schon zweimal getroffen hat, *ist* das Diskrepanz-Risiko, nach
  dem das Kriterium fragt. Im Template zusätzlich eine zweite
  „Vorgelagert"-Zeile parallel zur bestehenden Sub-Area-Wahl-Prüfung.
  Keine Treffer sind ebenfalls eine Antwort und werden notiert.
- **Dateiname vereinheitlicht: `welle-<NN>-results.md`.** Zwei Ausreißer gegen
  neun konsistente Stellen plus das reale Beispiel: `planning/README.template.md`
  sagte `done/<welle-id>-results.md` (ergäbe `welle-1-mvp-results.md`, weil die
  Welle-ID einen Slug trägt), `loesungen/modul-07` sagte `done/<welle>-results.md`.
  Die `<welle-id>`-Form stammt aus Welle 33 — dem Commit, der `done/` als Heimat
  für Nicht-Slice-Records benannte.
- **Satelliten mitgezogen:** Regelwerk-Splits `modul-05` (Beleg-Quelle in
  Kriterium 3) und `modul-06` (Eröffnungs-Prozedur, neue Sektion,
  Ziel-Form-Verweis); `lab/example/…/welle-1-results.md` trägt die neue Sektion
  mit zwei Beispiel-Einträgen, sonst widerspräche das Beispiel Modul 6.

## Welle 37 — 2026-07-26 · Templates verweisen auf die vendorte Baseline statt in den Kurs

### Geändert

- **Alle 42 Kurs-Verweise in `lab/templates` aufgelöst — das Bundle ist jetzt
  vollständig netzlos.** Nach Welle 35 (Regelwerk) blieb die zweite Hälfte:
  Templates zeigten durchgängig in den Kurs, obwohl der Adopter das Regelwerk
  **lokal** unter `.harness/baseline/<tag>/regelwerk/` vendored liegen hat. Das
  widersprach der eigenen `MR-003`-Begründung (Modul-0-Prinzip:
  *Per-Lauf-Relevantes gehört verkörpert, nicht extern nachgeladen*) — ein
  Kurs-Verweis heißt Netz, und zwar auch dort, wo der Inhalt zwei Verzeichnisse
  weiter liegt. Drei Klassen, drei Behandlungen:
  - **Löschbare Blöcke (10)** — Kopf-Hinweise („lösche diesen Block") und
    HTML-Kommentare. Sie werden nie mitkopiert, also greift die
    Kopier-Einschränkung gar nicht: relativer Link auf `../regelwerk/…`, der im
    Kurs-Repo (`lab/regelwerk`) *und* im Bundle (`regelwerk/` neben
    `templates/`) auflöst — dieselbe Doppel-Auflösung wie die
    `../templates/`-Ziel-Form-Verweise in der Gegenrichtung.
  - **Bleibender Inhalt (13)** — landet dauerhaft im Adopter-Repo, wo weder
    Pfadtiefe noch `<tag>` bekannt sind. Deshalb **Abschnitts-Zitat statt Link**:
    „Baseline-Regelwerk `grundlagen-konventionen.md` §Source Precedence". Ohne
    Pfad, ohne Tag; wo die Baseline liegt, steht beim Adopter genau einmal in
    `MR-003`. Ein Baseline-Upgrade berührt damit **eine** Datei statt dreizehn.
  - **`templates/README.md` (17)** — Index der Sammlung, wird nicht kopiert;
    relative Links, Spaltenkopf „Kurs-Verweis" → „Regelwerk-Abschnitt".
  Dazu eine **zweite Schicht von 13 Klartext-Nennungen ohne Link**
  („siehe Kurs Modul 4", „Kurs §Referenz-Richtung", „Kurs-Glossar"), die keine
  `kurs/de`-Suche findet — ebenfalls auf Regelwerk-Abschnitte umgestellt.
  **Stehen bleibt „Kurs"** nur noch als Name der Baseline-Quelle (11 Stellen:
  Baseline-Aufzählungen, „Kurs-Welle 24" als Stand-Beispiel, CHANGELOG im
  Kurs-Repo, `lab/example` als Vorbild-Zeiger).
  Empirisch gegengeprüft am simulierten Release-Bundle: **19 `regelwerk/`-Links
  lösen auf, 0 kaputt, 0 verbliebene Kurs-URLs**; die übrigen offenen Ziele sind
  die bekannte symbolische Klasse (`spec/lastenheft.md`, `CO-<NNN>-<titel>.md` …),
  die erst beim Ausfüllen entsteht.
- **`tools/rewrite-template-links.sh` und `.d-check.yml`: Kommentare ehrlich
  gemacht.** Beide beschrieben den alten Zustand („Quelle behält relative
  `../../kurs/`-Links", „Verweise in den Kurs … werden beim Release gepinnt").
  Die kurs-`sed` ist jetzt im Normalfall ein No-op und bleibt als **Sicherheitsnetz**
  deklariert; `ignore-refs` prüft ab jetzt `../regelwerk/`-Anker scharf — eine
  umbenannte Regelwerk-Überschrift verschickt sonst unbemerkt einen toten Anker
  ins Adopter-Repo.

## Welle 36 — 2026-07-26 · Artefaktklasse pro Rolle: sechs Rollen sind nicht sechs Skills

### Hinzugefügt

- **Modul 8 §Welche Rolle braucht welche Artefaktklasse.** `lab/templates/.harness/skills`
  enthält zwei Skill-Templates, der Kurs nennt sechs Rollen — die Asymmetrie war
  **deklariert, aber unbegründet**, und las sich dadurch als Rückstand. Modul 8
  §Lab-Bezug sagte *„Das Lab enthält **keine** Skill-Dateien pro Rolle"*, und der
  Reflexions-Trigger schlug ausgerechnet *„Skill-Datei pro Rolle?"* vor — ein
  Adopter baut daraufhin vier Attrappen. Jetzt steht das Kriterium explizit, und
  es ist aus Modul 10 abgeleitet, nicht neu erfunden: **eine Rolle braucht genau
  dann eine Skill-Datei, wenn ihr Urteil *inferential* ist UND auf
  repo-spezifischem Wissen beruht, das aus keinem Artefakt ableitbar ist.**
  Zuordnung: Planner/Architect → **Template** (Slice, Roadmap, ADR);
  Implementation → **Briefing** (`AGENTS.md` + 8-Schritt-Workflow); Reviewer →
  **Skill-Datei** (HIGH-Liste steht in keiner Spec, `inferential feedback` driftet);
  Verifier/Validator → **keins** (Prüfgrundlage reist im Slice mit bzw. liegt
  außerhalb des Repos). Zusatz: **Skills wachsen pro Urteilstyp, nicht pro Rolle**
  — `closure-note-reviewer.md` (Modul 11) ist dieselbe Rolle mit anderem
  Urteilstyp, keine siebte Rolle. **Kein neues Template**: vier weitere
  Skill-Dateien trügen keinen nicht-ableitbaren Inhalt.

### Geändert

- **Drei Stellen, die „eine Skill-Datei pro Rolle" nahelegten, geschärft.**
  Modul 8 §Lab-Grenze von *„enthält keine"* auf *„braucht keine, weil…"*
  umformuliert (die *echte* Grenze — kein Replay eines kompletten
  Rollendurchlaufs — bleibt separat stehen); Reflexions-Trigger von
  *„Skill-Datei pro Rolle?"* auf *„ist ein neuer Urteilstyp entstanden, der
  driftet?"*; Fehlvorstellung „Eine Person spielt alle Rollen" von
  *„unterschiedlichen Skill-Dateien"* auf *„der je passenden Artefaktklasse"*
  (auch in `loesungen/modul-08` und im Regelwerk-Split). Regelwerk-Split
  `modul-08` trägt die operative Fassung mit stabilem Anker
  `#artefaktklasse-pro-rolle` und Ziel-Form-Verweis auf
  `../templates/.harness/skills/reviewer.template.md`.

## Welle 35 — 2026-07-26 · Guard-Härtung als Worked Example; Regelwerk-Deixis umgehängt

### Hinzugefügt

- **Modul 13 §Worked Example B — „Guard-Härtung als Steering-Loop am Wächter".**
  Schließt den seit Einführung der Durchsetzungsschicht offenen „(folgt)"-Verweis
  (`grundlagen/durchsetzungsschicht.md` §Die Schicht wird selbst gesteuert). Zwei
  Wellen an einem Befehls-Guard: Welle 1 (`MR-004`, Befehlspositions-Denylist nach
  3× direktem `pytest`-Aufruf), Welle 2 (`MR-005`, rekursives Auspacken der
  `-c`-Payloads inkl. `-lc`/`-ec`, fail-closed über Tiefenlimit) — je mit
  Beobachtungs-Beleg aus Lerneinträgen, *verworfener* Alternative (`bash` auf die
  Denylist: ein abgeschalteter Wächter ist schlechter als ein löchriger) und
  Landung als **neuer** `MR`, nie als Edit am akzeptierten Eintrag. Wellen-Tabelle
  mit bewusst leerer Zeile 3 („die nächste Welle wird beobachtet, nicht geplant"),
  drei Entgleisungen, und die Abgrenzung Gate (prüft ein *Ergebnis*, computational
  feedback) vs. Wächter (verhindert eine *Handlung*, computational feedforward) —
  deshalb steht der Guard bewusst **nicht** in §Gate-Typ ↔ Fehlerbild. Das
  bestehende Worked Example heißt jetzt **A** (Anker `worked-example-a-…`,
  3 Verweise in Modul 4 nachgezogen). Neue Analysieren-Übung (Welle 3 schreiben:
  Beleg → Abwägung → neue Grenz-Zeile) + Lösungshinweis, Reflexions-Trigger
  ergänzt. Die `Grenze:`-Zeile im `MR`-Block ist explizit als **repo-lokales
  Zusatzfeld** ausgewiesen — die Pflichtfelder des Adaptions-Blocks bleiben
  unangetastet, kein Template-Eingriff. Regelwerk-Split `modul-13` trägt die
  operative Fassung (`§Guard-Härtung`, stabiler Anker `#guard-haertung`), beide
  „(folgt)"-Enden geschlossen.

### Geändert

- **`lab/regelwerk`: Selbstverweise auf „Kurs" auf das Regelwerk umgehängt.** Sieben
  Stellen sagten im vendorten Betriebsregelwerk „in diesem Kurs" / „Bedeutung im
  Kurs" / „Kurs-Glossar" / „pro Kurs-Phase" — ein Referent, der im Adopter-Repo
  ins Leere zeigt (`grundlagen-konventionen` ×3, `grundlagen-klassifikation`,
  `modul-04`, `modul-14`, `modul-16`). Das ist **keine** Verletzung der
  Quelltreue-Regel, sondern dieselbe Operation, die beim Split ohnehin passiert:
  relative Links werden umgehängt, Deixis genauso — der Satz behält seine Aussage,
  nur sein Referent wandert mit dem Text. **Stehen bleibt „Kurs", wo es die
  Baseline-*Quelle* benennt** (Baseline-Aufzählungen in `modul-01`/`konventionen`,
  „neues Kurs-Release" als Drift-Trigger in `modul-02`, Baseline-Auswahl
  `modul-02` §Schritt 1, sowie das gesamte README: Framing, Stand-Zeile,
  Normativitäts-Klausel, Lizenz). Zusätzlich ein Didaktik-Rest entfernt
  (`grundlagen-klassifikation`: „…warum Replay und Golden Sets im Kurs ein eigenes
  Modul bekommen" — eine Aussage über den *Kursaufbau*, die nach der Weglass-Regel
  nicht ins Regelwerk gehört). Die Transformationsregel steht als eine Klausel im
  README-Extrakt-Satz, nicht als eigener Absatz: sie ist eine Maintainer-Regel für
  die *Herstellung* des Splits, und das README reist im Bundle zum Adopter mit.
  **Keine `kurs/`-Änderung** — die Quelle ist ein Kurs und sagt zu Recht „in diesem
  Kurs". `make check` grün (d-check 0 Befunde, docs 0/0, alignment 0 WARN).
- **`lab/regelwerk` verweist nicht mehr auf Kurs-Material — 14 Auswärts-Links
  aufgelöst.** Zweite Leck-Klasse an derselben Wurzel: Verweise aus dem netzlos
  ausgelieferten Bundle auf Dateien, die *nicht* mitreisen (`fallstudien.md`,
  `quellen.md`, `reflexion-vorlage.md`, `lernervorstellungen.md` liegen nicht in
  `lab/templates/`). Die betroffenen Ziele tragen **keine Regel**: Fallstudien
  sind vier konkrete Repos mit Stand-Momentaufnahme („Stand 2026-06") und einer
  Spalte *„Was der Kurs daraus zieht"*, `quellen.md` ist ein Literaturverzeichnis
  mit eigenem Abschnitt *„Didaktische Quellen"*, `reflexion-vorlage.md` eine
  Vorlage für Kurs-*Übungen*. Alle 14 Verweise standen in Beleg-Klammern; die
  tragenden Sätze bleiben wortgleich stehen (Beispiel: „Ein reifes Repo (Beispiel
  `pt9912/grid-gym`, siehe fallstudien.md) hat…" → „Ein reifes Repo (Beispiel
  `pt9912/grid-gym`) hat…"). Betroffen: 8× `fallstudien.md`, 2× `quellen.md`,
  1× `reflexion-vorlage.md`, 1× `lernervorstellungen.md`; dazu `modul-08`, dessen
  Steering-Loop-Verweis auf die **in-Bundle** stehende 1×/2×/3×-Regel in
  `grundlagen-klassifikation.md` §Steering Loop umgehängt wurde. Dazu die README
  selbst: ihr Absatz „Vendored gelesen?" — die Anrede an den Adopter, der das
  Bundle netzlos liest — schickte für *„Vorgehen beim Bootstrap"* nach draußen in
  den Kurs, obwohl `modul-02-harness-bootstrap.md` im Bundle liegt; auf den Split
  umgehängt. **Genau ein** Auswärts-Link bleibt: die Normativitäts-Klausel
  („maßgeblich für den Inhalt bleibt der Kurs unter `/kurs/de/`") — dort *ist* der
  Sprung nach draußen der Zweck. Alles andere im Regelwerk ist netzlos.
- **`konventionen.md`: neue `### Einführungs-Reihenfolge über mehrere Repos`.**
  Beim Entfernen der Fallstudien-Verweise fiel auf, dass `fallstudien.md`
  **gemischt** ist: neben Fallbeispielen trug sie eine echte Betriebsregel
  („Beginne immer beim Referenz-Repo, portiere erst nach erfolgreicher
  Steering-Loop-Iteration auf die Flagships; alle Repos parallel mit demselben
  Master-Prompt zu treiben skaliert nicht"), die **nirgends sonst stand** —
  verifiziert gegen Regelwerk *und* `konventionen.md`. Eine allgemeine Regel auf
  einer Fallbeispiel-Seite ist eine Quell-Fehlablage, deshalb Fix-Richtung
  **Quelle**: die Regel wandert wortgleich (plus Begründung aus §Konsequenzen pro
  Klasse) nach `konventionen.md` §Harness-Bootstrap; `fallstudien.md` behält den
  Absatz als Kontext-Hinweis mit Pointer, normativ ist ab jetzt der
  Konventions-Text. Damit trägt der Split `grundlagen-konventionen` die Regel
  quell-verankert — sie verschwindet nicht mit den Fallstudien-Verweisen. Die
  §Repo-Klassen-Hälfte brauchte keinen Umzug: sie steht als Kernbegriff und in
  den Source-Precedence-Konsequenzen bereits im Regelwerk.

## Welle 34 — 2026-07-24 · Change-Request-Landing-Disziplin: Fußabdruck statt Konstrukt

### Geändert

- **`konventionen.md` §Spec-Stratifizierung: „Change Request" als externer
  Prozess eingeordnet, nicht als Konstrukt.** Der Kurs benannte CR bisher nur
  als Änderungs-Prozess-Label des Vertrags-Stratums, ohne zu sagen, was er
  *ist* und was er im Repo hinterlässt — jedes adoptierende Repo hätte das
  anders gelöst (eigenes CR-Template? `spec/change-requests/`? Version-Bump
  ja/nein?). Ein Absatz nach der Hard Rule stellt klar: CR ist **bewusst kein
  Harness-Konstrukt** (kein `CR-*`-ID-Schema, keine Datei, kein Gate), sondern
  der externe Vorgang der Vertragsänderung mit dem Auftraggeber. In-Repo-
  Fußabdruck eines *angenommenen* CR = Version-Bump des Lastenhefts +
  Historie-Zeile mit CR-Verweis + geänderte `LH-*`/`HSM-*`;
  abgelehnte/schwebende CRs leben außerhalb. Die Hard Rule „ADR darf `LH-*` nie
  schärfen" wird explizit auf Slice ausgedehnt (über den SDP-Stabilitäts-Rang
  Vertrag › ADR › Slice bereits implizit). Verworfen: ein eigenes CR-Konstrukt
  (wäre ein viertes Änderungsmuster neben MR/ADR/supersede und bräche mit „ADR
  schärft das Lastenheft nicht") — die gewählte Option „Landing-Disziplin
  schärfen" ehrt Quelle-ist-Anker. Regelwerk-Split `grundlagen-konventionen`
  wortgleich mitgezogen; `lab/templates/spec/lastenheft.template.md` Historie-
  Kommentar schärft den Fußabdruck. `make check` grün (docs 0/0, alignment
  0 WARN). Auslöser: Adopter-Frage „brauchen wir ein CR-Template, sonst macht
  es jedes Zielprojekt anders?".

## Welle 33 — 2026-07-23 · README-Template: `done/` als Heimat abgeschlossener Nicht-Slice-Records ehrlich benennen

### Geändert

- **`planning/README.template.md`: „slice-reserviert"-Überbehauptung korrigiert.**
  Der Block „Slices vs. Wellen" behauptete pauschal „die Lifecycle-Verzeichnisse
  sind **slice-reserviert**" und legte zugleich `welle-<id>-results.md` (ein
  Nicht-Slice-Record) in `done/` — ein Widerspruch im selben Absatz. Jetzt
  getrennt: der aktive Durchlauf `open/` → `next/` → `in-progress/` nimmt
  ausschließlich Slices auf; `done/` archiviert zusätzlich abgeschlossene
  **Nicht-Slice-Records** (Welle-Closure `done/<welle-id>-results.md`; aufgelöste
  Carveouts, Modul 7). **Template-Drift-Korrektur:** „slice-reserviert" stand nur
  im Template, die Quelle (Modul 6 §Welle-Closure: aktive Welle flach, geschlossene
  → `done/` per `git mv`) war korrekt — Fix-Richtung Template→Quelle, **kein**
  `kurs/`-Eingriff, keine Lehre berührt. Auslöser: m-trace-Planning-Layout-Audit,
  bei dem Nicht-Slice-Register mangels sanktioniertem flachem Ort in ein
  Lifecycle-Verzeichnis gezwängt wurden. Die weitergehende Frage (eigener Kanal
  für Discovery-/Kandidaten-Register) ist bewusst **vertagt**, bis ein zweites
  Konsument-Repo denselben Druck unabhängig zeigt.

## Welle 32 — 2026-07-19 · regelwerk-drift-Sensor retired; d-check sources im Freshness-Audit eingeordnet

### Entfernt

- **`check_regelwerk_drift.py` + `make regelwerk-drift`** aus `lab/example`. Der
  Sensor war ein Asset-/Content-Hash-Vergleich — genau die Methode, die Modul 2
  §Freshness-Audit als unzureichend markiert („der Hash des gepinnten Assets fängt
  nur ein nachträglich verändertes Release, nicht einen neuen Tag") — und seit dem
  Split-Verzeichnis (Welle 24) ohnehin ein No-op. `conventions.md` §Baseline von
  „ausstehend/übersprungen" auf einen ehrlichen Verweis umgeschrieben: das
  In-Repo-Beispiel ist selbst am Kurs-Stand; die Upstream-Freshness-Frage
  (Release-Listen-Prüfung) stellt sich erst im adoptierenden Fremd-Repo.

### Geändert

- **Modul 2 §Freshness-Audit: d-check `sources` (v0.51.0) eingeordnet.** Ein
  präziser Satz: `sources` automatisiert die *Asset-/Integritäts*-Hälfte
  (`source-pin`/`source-drift`), ersetzt aber die Release-Listen-Prüfung nicht —
  klärt die Verwechslung „sources = Freshness-Audit". Regelwerk-Split `modul-02`
  quelltreu mitgezogen.
- **d-check-Pin v0.51.0 → v0.51.1** (Fragment regeneriert). PATCH: dpin-Befund
  führt jetzt den vollen `sha256` (pins-Ergonomie); verhaltensneutral, `make check`
  unverändert grün. Kurs-intern.

## Welle 31 — 2026-07-19 · lab/templates im Referenz-Gate (scoped ignore-refs) + d-check v0.51.0

### Geändert

- **`lab/templates` steht jetzt im Referenz-Gate.** Das Verzeichnis mischt
  symbolische Ziel-Repo-Pfade (lösen erst nach dem Ausfüllen auf) mit prüfbaren
  Verweisen — 39 Kurs-Links (inkl. Anker) und template-interne Navigation. Bisher
  opferte `scan.ignore` die zweite Klasse komplett: die beim Release auf
  `blob/<tag>/` eingefrorenen Kurs-Verweise waren ungeprüft (eine umbenannte
  Kurs-Überschrift verschickte unbemerkt einen toten Anker). Ersetzt durch scoped
  `ignore-refs` (top-level `in`/`refs`/`keep`, d-check v0.49.0+): die 42
  symbolischen Refs (37 links, 5 codepaths) bleiben ignoriert, der Rest wird scharf
  geprüft (`ignoriert ⇔ refs ∧ ¬keep`, `keep` reihenfolge-unabhängig). Damit ist
  `lab/templates` dauerhaft Teil von `make check`.
- **d-check-Pin v0.47.0 → v0.51.0** (Fragment via `--print-mk` regeneriert). Liefert
  das `ignore-refs`-`in`/`keep`-Feature (v0.49.0, Grundlage der Adoption) sowie die
  neuen opt-in-Module `citations`/`codepaths.check-lines` (v0.50.0) und `sources`
  (v0.51.0, Content-Pin externer Quellen gegen Upstream-Drift) — verfügbar, aber
  nicht aktiviert (`make check` verhaltensneutral grün). Kurs-intern: Fragment + Pin
  reisen auf `main` mit, sind nicht im Bundle.
- **Regelwerk-Anzeigetext auf `templates/`-Präfix vereinheitlicht.** Der sichtbare
  Linktext der Ziel-Form-Verweise zeigte bare Spiegel-Pfade
  (`docs/plan/planning/roadmap.template.md`) — das las sich wie eine Vorlage an
  einem `docs/`-Pfad, wo weder Kurs noch Adopter eine hält. Anzeigetext auf
  `templates/…` präfixiert (href unverändert), 10 Stellen; bundle-korrekt.

## Welle 30 — 2026-07-18 · Wellen zweistufig (flach → `done/`), Status-Feld retired

### Geändert

- **Welle-Zustand = Verzeichnis-Position, kein `Status`-Feld** — analog zum Slice
  (Welle 26). Die aktive Welle liegt flach unter `docs/plan/planning/`; bei
  Closure `git mv` der Plan-Datei nach `done/` (neben ihre `-results.md`). Zwei
  Zustände (flach = aktiv → `done/` = geschlossen) statt eines driftbaren Felds;
  die Roadmap (`Aktuelle`/`Nächste`/`Abgeschlossene Wellen`) bleibt die
  Sequenzierungs-Autorität — **kein** Vier-Zustands-Verzeichnis, das die
  Roadmap-Reihenfolge dupliziert. Löst zwei Probleme: abgeschlossene Wellen
  müllten den flachen `planning/`-Ordner zu, und das `Status`-Feld war dieselbe
  zweite, driftbare Wahrheit, die beim Slice retired wurde.
- `welle.template`: `**Status:**`-Feld → `**Lifecycle:**`-Hinweis; zusätzlich die
  **Slice-Status-Spalte** aus der §4-Tabelle entfernt (gleiche Drift-Klasse — der
  Slice-Zustand ist sein Lifecycle-Verzeichnis, nicht eine Tabellen-Zelle).
- `modul-06` (Kurs-Anker + Regelwerk-Split): Closure-Schritt 3 → „**Welle nach
  `done/` schließen**" (Ergebnis-Notiz **und** `git mv` der Plan-Datei); die Prosa
  verankert das Zwei-Zustands-Modell und die Roadmap als Reihenfolge-Autorität.
  Fünf-Schritte-Prozedur unverändert (git mv in Schritt 3 integriert).

## Welle 29 — 2026-07-18 · d-check-Gate-Fragment tool-generiert (include-Modell) + `--network none`

### Geändert

- **Doku-Gate-Fragment tool-generiert statt handgeschrieben.** Die Template-`Makefile`
  empfahl bereits `d-check --print-mk`, lieferte aber die handgepflegte Recipe, die
  das Tool längst überholt hatte (`--network none`, `DCHECK_DIGEST`-Override, neues
  Target-Set) — aufgedeckt durch einen Adopter (`ai-harness-init` `MR-010`). Umgestellt
  auf das **include-Modell**: das Fragment `d-check.mk` wird via `d-check --print-mk`
  erzeugt und per `include`/`-include` eingebunden; die Recipe-Form lebt in d-check,
  nichts driftet von Hand. Effekte: `--network none` auf jedem Run (LH-QA-01-Hermetik
  auf Container-Ebene, die der Kurs lehrte, aber am eigenen Gate nicht erzwang),
  `DCHECK_DIGEST`-Re-Pin (statt Digest-Chirurgie), volles Target-Set present-but-unclaimed.
- **d-check-Pin v0.43.1 → v0.47.0** (via `DCHECK_DIGEST`). Trockenlauf vorab: 139
  Dateien, 0 Befunde, verhaltensidentisch — der Kurs enthält keine der Muster, die
  v0.47.0 neu sichtbar macht (keine `| - |`-Trennzellen, keine Fence-Infozeilen mit
  Backtick).
- **Modul 13 — „Vorhanden ≠ behauptet".** Schärft „keine halluzinierten Gates": ein
  vorhandenes, nicht als Gate *behauptetes* Target (die advisory `doc-*`-Targets des
  Fragments, wie `regelwerk-check`) ist keine Lüge; nur ein behauptetes, nicht
  laufendes Gate ist eine.

### Geändert — Auslieferung (Bootstrap)

- **Das Gate-Fragment und der Pin sind tool-/versionsspezifisch → NICHT im Bundle.**
  Der Adopter erzeugt `d-check.mk` beim Bootstrap aus *seiner* gepinnten d-check
  (`d-check --print-mk`) und füllt den `DCHECK_DIGEST`-**Platzhalter** der Template-
  `Makefile` (Modul 2, Kurs + Regelwerk-Split lehren das). Das Bundle trägt nur
  versions-agnostischen Inhalt; keine Release-Ableitung, kein committetes Duplikat.

### Behoben

- Review-Pass (high effort) vor dem Commit: `d-check.mk`-Staging (harter `include`),
  Prosa-Zeilenlänge (Regelwerk-Modul-2), `include`→`-include`-Präzisierung (Modul 13).

**Hinweis für Konsumenten (kein Bruch nach Asset/Layout-Policy):** Die ausgelieferte
Template-`Makefile` ist jetzt ein Skelett mit `DCHECK_DIGEST`-Platzhalter und
`-include d-check.mk`; sie läuft nicht mehr out-of-box, sondern nach der
Bootstrap-Erzeugung von `d-check.mk`. Bundle-Layout und Asset-Name unverändert;
existierende Adopter-Repos bleiben unberührt.

## Welle 28 — 2026-07-18 · Instanziierungs-Zeitpunkt der Templates explizit (Modul 2)

### Hinzugefügt

- **Anmerkung zum Instanziierungs-Zeitpunkt an Modul-2-Schritt 2** (Kurs +
  Regelwerk-Split). Der Kurs sagte den Zeitpunkt der Skelett-Instanziierung
  bisher nur *strukturell* (Bootstrap-Tabelle listet Gründungs-Dokumente;
  „Bootstrap-Ende = bereit für ersten Slice"), nicht *explizit am
  Instruktions-Punkt*. Diese Lücke verleitete einen Adopter (`ai-harness-init`)
  dazu, alle Templates beim Bootstrap als `docs/…/*.template.md`-Blanks zu
  bevorraten — reine Wartungskosten, später per dessen `MR-008` wieder entfernt.
  Neue Anmerkung trennt jetzt explizit: **Gründungs-Dokumente** (je ein
  Singleton, beim Bootstrap instanziiert und gefüllt: Spec-Straten,
  `conventions`, `harness/README`, `AGENTS`, `roadmap`, Gründungs-ADR `0001`)
  gegen **wiederkehrende Artefakte** (`slice`, `welle`, weitere ADRs, `carveout`,
  `review-report` — pro Instanz aus der vendored Baseline kopiert, wenn der
  Workflow sie erreicht; keine Blank-Kopie vorhalten). Die ADR-Doppelnatur
  (`0001` beim Bootstrap, weitere wiederkehrend) ist explizit gemacht.
- **Review-verifiziert (high effort).** Vor dem Commit fing ein Diff-Review
  einen Faktenfehler (Repo-`README` fälschlich als Bootstrap-Gründung gelistet,
  obwohl in keinem Bootstrap-Schritt) plus drei Präzisierungen (ADR-Bereich
  `Modul 4–10` statt `5–10`; Skelette in Schritt 2 kopiert, in 3–8 gefüllt;
  Regelwerk-Split operativ an den Kurs angeglichen).

## Welle 27 — 2026-07-18 · Baseline-Freshness-Audit prozeduralisiert (Modul 2)

### Hinzugefügt

- **Freshness-Audit als Erweiterung der Modul-2-Baseline-Anmerkung.** Vendoring
  friert per Konstruktion eine Kopie ein, die still von Upstream driftet, sobald
  ein neues Kurs-Release erscheint. Der Kurs benannte die Gegenmaßnahme bisher
  nur als Listen-Phrase („Drift-Audit gegen die Baseline", `AGENTS.template.md`)
  und prozeduralisierte sie nirgends — Modul 16 leer dazu, Modul 2 nur das Warum
  des Vendorings. Neuer Absatz in `modul-02-harness-bootstrap.md` (Regelwerk-Split
  operativ mitgezogen) mit drei Eigenschaften: **beobachtbarer Auslöser** (keine
  Kalenderpflicht), **Netz-Operation außerhalb der Gates** (offline-grün bleibt
  unverletzt) und der nicht-offensichtliche Kern — die Release-**Liste** auf einen
  neueren Tag prüfen, **nicht** nur den Hash des gepinnten Assets (der fängt nur
  ein nachträglich verändertes Release, keinen neuen Tag). Ein neuer Tag löst
  einen Review mit eigenem Diff aus, keinen stillen Auto-Bump. An die kurs-eigene
  „pinnen **und** überwachen"-Doktrin (Modul 12 `image_hash`, Modul 14
  „unsichtbarste Drift") und an LZ 5 (aktives Überwachen) gekoppelt.
- **Anlass:** Adopter-Beobachtung, gegen `v3.1.0` auditiert. Ein Adopter
  (`ai-harness-init`, `MR-007`) dokumentiert die Lücke selbst als „offene Lücke,
  kein gelöstes Problem" — sein Sensor meldete „kein Drift" auf einem alten Pin,
  während zwei Major-Releases erschienen. Kurs-seitig verifiziert: Modul 16 ohne
  Baseline-Wartung, Modul 2 ohne Release-Erkennung. Der Kurs schreibt das
  Ergebnis (Prozedur) vor, keine Repo-Mechanik (kein Tool-/Target-Name).

## Welle 26 — 2026-07-17 · Slice-Zustand einwertig (Lifecycle-Verzeichnis), Baseline-Bundle von innen self-beschreibend

### Geändert

- **Slice-Status-Feld retired — das Lifecycle-Verzeichnis ist die Quelle.**
  Modul 5 definiert den Slice-Zustand ausschließlich als Verzeichnis (eines von
  `open/`, `next/`, `in-progress/`, `done/`); das `Status:`-Feld im
  `slice.template.md` hatte keine Quell-Verankerung und war eine zweite Wahrheit,
  die beim `git mv` driftet — ein Slice in `done/` mit `Status: open` ist genau
  der Zombie, den Modul 5 beklagt. Feld → **`Lifecycle:`**-Hinweis (Zustand =
  Verzeichnis, Wechsel nur per `git mv`); §4 Trigger benennt jetzt auch die zwei
  Rückführungen (`in-progress`→`next` zu groß, `in-progress`→`open` blockiert),
  verankert an §Lifecycle als State Machine. `welle.template.md`: Slice-Status-
  Zelle als `<einer von: …>` statt Slash-Liste (die Pfeilkette las sich als
  Ablauf statt als Auswahl); das *Welle*-Status-Feld bleibt — Wellen liegen flach
  ohne Lifecycle-Verzeichnis, dort trägt das Feld die Wahrheit. `lab/example/slice-014`
  nachgezogen. Fix-Richtung Quelle → Template → Beispiel; Modul 5 unberührt.
- **Modul 07 §Übungen — Pflichtfeld-Liste an Schritt 2 und Template angeglichen.**
  Die Übung nannte sechs Pflichtfelder inklusive `Auflösungs-Trigger` und ohne
  `Letzte Prüfung`; kanonisch sind sechs Pflicht-*Header*-Felder (Status, Datum
  angelegt, Letzte Prüfung, betroffenes Gate, Geltungsbereich, Folge-Slice) plus
  der Auflösungs-Trigger als eigener beobachtbarer Bestandteil.
- **`lab/regelwerk/README.md` beschreibt seinen Vendoring-Kontext selbst.** Wer
  das Regelwerk aus dem entpackten Bundle liest statt über das Kurs-README, fand
  keinen Hinweis darauf, worin die Datei liegt: neuer Absatz „Vendored gelesen?"
  — `regelwerk/` + `templates/` parallel unter `.harness/baseline/<tag>/`, daher
  netzlos auflösende `../templates/…`-Ziel-Form-Verweise; Einstieg ist `AGENTS.md`
  des Adopter-Repos, hierher wird pro Entscheidung nur der benötigte Abschnitt
  geladen. Damit ist der Bootstrap-Pfad auch von innen navigierbar, nicht nur vom
  Kurs-README aus. Zugleich der „Links."-Absatz korrigiert: er nannte Templates
  und Beispiel als beim Release gepinnt — seit Welle 25 hält
  `--keep-within=lab/templates` die Templates-Verweise relativ, und `lab/example`
  verlinkt das Regelwerk gar nicht (36× `../../kurs/`, 16× `../templates/`).

## Welle 25 — 2026-07-16 · Regelwerk agenten-tauglich (Ziel-Form statt Worked Examples) + self-contained Baseline-Bundle

### Geändert

- **Didaktik-Compliance der Regelwerk-Splits.** Das Regelwerk ist für Code-
  Agenten: **Regel + Ziel-Form** statt erzählter Worked-Example-Narrative. Über
  17 Dateien die Schritt-für-Schritt-Beispiele entfernt (netto −1045 Zeilen).
  Skelett, das ein `lab/templates`-Artefakt dupliziert → „Ziel-Form: X" = Verweis
  auf `../templates/…` + operative Kurzregeln (modul-03/04/05/06/07/10); kein
  Template (Code/Config/Prozess) → operative Regeln + Tabellen behalten
  (modul-08/11/12/14/16). modul-02: Worked Example 1/2 → operative Bootstrap-
  Schritt-Sequenzen (Mermaids + T1/T2-Markdown-Beispiele gestrippt; Detail-
  Tabellen, vendored-Baseline-Doktrin, Phasen×Modus-Matrix behalten).
- **Stabile HTML-Anker** (`<a id>`, von d-check erkannt) für viel-referenzierte
  Stellen: modul-07 `#werkzeug-wahl` (5 Verweise), modul-13
  `#adr-zur-fitness-function`, modul-01 `#source-precedence-block`; ~11
  eingehende Verweise umgebogen. modul-07 review-verifiziert.
- **Baseline vendored jetzt Regelwerk *und* Templates.** modul-02-Bootstrap
  (Quelle + Split): `.harness/baseline/<tag>/{regelwerk,templates}/` — Templates
  mit Doppelrolle (vendored Referenz-Form für die `../templates/`-Ziel-Form-
  Verweise + kopiert-und-ausgefüllt als eigene Artefakte). Adopter-Story
  (conventions.template `MR-003`, AGENTS.template, README.template, lab/example)
  durchgängig nachgezogen.
- **`lab-regelwerk.zip` ist ein self-contained Baseline-Bundle** (`regelwerk/` +
  `templates/` parallel). `templates-release.yml` packt beide; die Splits lösen
  `../templates/` netzlos gegen `templates/` auf.

### Hinzugefügt

- **`rewrite-doc-links.py --keep-within=<dir>`** — zusätzliche within-Bundle-
  Wurzel neben `--keep-within-src`, damit `../templates/`-Verweise in
  self-contained Bundles mit mehreren parallelen Verzeichnissen relativ mitreisen
  (netzlos auflösbar) statt auf eine blob-URL gepinnt zu werden; nur echte
  Außen-Verweise (Kurs, LICENSE) werden auf den Tag gepinnt.

### Entfernt

- **Release-Asset `lab-templates.zip`.** Die Templates liegen jetzt im
  self-contained `lab-regelwerk.zip` unter `templates/`; ein separates
  Template-ZIP wäre ein Duplikat. Wer nur die Skelette will, entpackt das Bundle
  und nimmt `templates/`. `README`, `lab/templates/README`,
  `rewrite-template-links.sh` und `templates-release.yml` entsprechend bereinigt.
  (Das `templates-zip`-Vorschau-Artifact auf `main` bleibt für Template-Autoren.)

**Bruch für Konsumenten:** (1) Das `lab-regelwerk.zip` wechselt vom flachen
Layout (`*.md` im Root, v2.0.0) auf `regelwerk/` + `templates/` parallel — nach
`.harness/baseline/<tag>/` entpacken (nicht mehr nach `…/regelwerk/`), dann lösen
die `../templates/`-Ziel-Form-Verweise netzlos auf. (2) Das Release-Asset
`lab-templates.zip` entfällt; Ersatz ist `templates/` im Baseline-Bundle. Der
Kurs-*Inhalt* bleibt maßgeblich unter `/kurs/de/`.

## Welle 24 — 2026-07-16 · Regelwerk konsumenten-sauber (A⁺), agents-regelwerk.md retired, d-check v0.43.1

### Geändert

- **Regelwerk-Splits von der Demo-App befreit (A⁺).** Das ausgelieferte
  `lab-regelwerk.zip` enthält nur `lab/regelwerk/*.md`, kein `lab/example` —
  DocSearch-/Lab-Referenzen im Split waren toter Ballast. modul-06 Worked
  Example → generisches Roadmap-Skelett; acht weitere Splits genericisiert
  (modul-02/07/10/12/14/16, grundlagen-konventionen/-klassifikation).
- **Modul 6 (Roadmap):** die Template-Abschnitte *Nächste Wellen* und
  *Abgeschlossene Wellen* in Quelle + Split verankert; normative
  **Wellen-Closure-Prozedur** (5 Schritte) ergänzt, kurs-intern verankert
  (kein externes Referenz-Repo als Autorität).
- **17 Modul-Splits auditiert** und Defekte behoben (verpatzter
  Fehlannahmen-Block modul-10, toter Selbstverweis modul-12, didaktische
  Reste modul-02/03/16; modul-03 Spec-Stratifizierung auf Kurzform + Verweis
  eingedampft).
- **Split-Selbst-Enthaltung:** 72 Kurs-Cross-Links → Geschwister-Links, damit
  sie im `lab-regelwerk.zip` mitreisen (`rewrite-doc-links.py --keep-within-src`).
- **Provenance-Zeilen (20×)** in `lab/regelwerk/` → HTML-Kommentar-Metadaten
  (nicht gerendert, aber weiter d-check-validiert).
- **d-check-Pin `v0.23.0` → `v0.43.1`** (Image-Digest) im `Makefile`;
  verhaltensgleich verifiziert.
- **`lab/regelwerk` ist jetzt das kanonische Betriebsregelwerk-Artefakt.** Die
  Adopter-Story (README, kurs/de/README, lab/README, Templates, lab/example)
  verweist durchgängig auf das `lab-regelwerk.zip` / den Split; die Stand-Zeile
  lebt jetzt in [`lab/regelwerk/README.md`](lab/regelwerk/README.md)
  (**Kurs-Welle 24**).

### Entfernt

- **`kurs/de/agents-regelwerk.md`** (Zwischen-Digest). Ersatz ist das per-Modul-
  Split `lab/regelwerk` bzw. das `lab-regelwerk.zip`. CI (`templates-release.yml`,
  `templates-zip.yml`) baut/releast die Einzeldatei nicht mehr; das
  `lab/example`-Drift-Tool zeigt aufs Split-Verzeichnis (inhaltsbasierte
  Verzeichnis-Hash-Migration deferred).
- **`lab/templates/harness.mk`** — der `docs-check`-Gate steht jetzt direkt im
  Template-`Makefile` (Adopter erzeugen ihn alternativ per `d-check --print-mk`).
- **`grundlagen-checkpoints.md` + `grundlagen-konzeptkarte.md`** aus dem
  Regelwerk (rein didaktische Lern-Navigation, kein operativer Inhalt).

**Bruch für Konsumenten:** Das Release-Asset `agents-regelwerk.md` und die
mitgelieferte `harness.mk` entfallen; wer die Einzeldatei per URL zog, wechselt
auf `lab-regelwerk.zip` (self-navigierbares Bundle). Der Kurs-*Inhalt* bleibt
maßgeblich unter `/kurs/de/`.

## Welle 23 — 2026-06-23 · Template-Feinschliff (ADR-Tabelle, Gate-Baseline) + d-check v0.23.0

### Geändert

- **ADR-Vorlage „Verglichene Alternativen" als Pro/Contra-Tabelle** — im
  [ADR-Datei-Template](lab/templates/docs/plan/adr/NNNN-titel.template.md) die
  drei `### Option A/B/C`-Blöcke (je eigene `- Pro:`/`- Contra:`-Liste) auf eine
  Markdown-Tabelle (`| Option | Pro | Contra |`) umgestellt, gewählte Option
  fett. Rein kosmetisch — kein Schema- oder Inhaltswechsel; die „mindestens drei
  Optionen mit Pro/Contra"-Regel bleibt.
- **d-check-Pin `v0.9.0` → `v0.23.0`** (Image-Digest neu gepinnt) im
  [`Makefile`](Makefile) (Single Source of Truth) und im
  `harness.mk` (`lab/templates/`); der Versions-Kommentar
  in `harness.mk` trug noch `v0.8.0` und wurde mitgezogen. Laut d-check-CHANGELOG
  keine Breaking-Config-Änderung v0.9.0→v0.23.0 — bestehende `.d-check.yml` bleibt
  gültig, `make check` grün (docs-check 0 Befunde, alignment-check 0 WARN).
- **Gate-Baseline um den Repo-Generator ergänzt** — der Regenerier-Hinweis in der
  [`lab/templates/README.md`](lab/templates/README.md) nannte nur das leere
  `d-check --print-config`-Gerüst; jetzt zusätzlich
  `d-check --suggest-config ai-harness-init --id-prefix <PRÄFIX>` (neu seit
  d-check v0.18.0/v0.22.0), das `ids`/`matrix`/`codepaths` mit den Kurs-Kennungen
  (`ADR-…`, `MR-…`, `slice-…`, `<PRÄFIX>-FA-…`/`-QA-…`) vorbelegt. `--id-prefix`
  als Begleitschalter dokumentiert: ohne ihn bleiben `<PREFIX>`-Platzhalter und
  `# TODO` stehen.

Alle drei Änderungen betreffen Templates bzw. Tooling — die Quelle
[`agents-regelwerk.md`](kurs/de/agents-regelwerk.md) bleibt unberührt
(**kein Stand-Bump**, vgl. Welle 20/21). Die Templates fließen mit dem
nächsten Release-Tag ins `lab-templates.zip`-Asset.

## Welle 22 — 2026-06-18 · ADR-ID-Schreibweise vereinheitlicht (vierstellig)

### Geändert

- **ADR-ID-Platzhalter durchgängig vierstellig (`ADR-<NNNN>`)** — die
  ADR-Kennung wurde zugleich zwei-, drei- und vierstellig geführt, während
  die realen ADRs unter
  [`lab/example/docs/plan/adr/`](lab/example/docs/plan/adr/), der ADR-Dateiname
  (`<NNNN>-titel`) und das ADR-README-Template bereits vierstellig waren.
  Vereinheitlicht auf vier Stellen: ADR-Bindung-Klasse der Konventionen-Seite
  ([`grundlagen/konventionen.md`](kurs/de/grundlagen/konventionen.md), Quelle)
  und ihre Derivate ([`agents-regelwerk.md`](kurs/de/agents-regelwerk.md) §463,
  [`lab/regelwerk/grundlagen-konventionen.md`](lab/regelwerk/grundlagen-konventionen.md)),
  die Observability-ID-Kette (Modul 15), das ADR-Datei-Template
  (`Status:`/`Bezug:`), das ADR-README-, AGENTS-, `harness/README`-,
  `harness/conventions`-, slice-, roadmap- und welle-Template sowie die
  `lab/example`-Spiegel (`AGENTS.md`, `harness/conventions.md`, `adr/README.md`).
  Reine Schreibweisen-Vereinheitlichung — **kein** Schema-Wechsel der
  Nummernvergabe; reale/fiktive vierstellige Nummern und die einstellige
  Prosa-Variable `ADR-N` (Fließtext „supersedes ADR-N") bleiben unverändert.
  Schließt die Quell-Wurzel der nachgelagerten Adaption **d-check `MR-008`**
  („Korrektur in der Kurs-Quelle steht aus"). `Stand:` von `agents-regelwerk.md`
  auf Welle 22 gezogen.

## Welle 21 — 2026-06-16 · Grundlagen-Rahmen im Regelwerk-Split + d-check v0.9.0

### Neu

- **Grundlagen-Rahmen im Split** — [`lab/regelwerk/`](lab/regelwerk/)
  trägt jetzt neben den 17 Modulen auch die drei Grundlagen-Abschnitte der Quelle als
  einzelne Dateien:
  [`grundlagen-konventionen.md`](lab/regelwerk/grundlagen-konventionen.md) (inkl.
  §Referenz-Richtung/SDP — wer darf wen referenzieren, also die ADR→Slice/Welle-
  Regel), [`grundlagen-klassifikation.md`](lab/regelwerk/grundlagen-klassifikation.md)
  und [`grundlagen-durchsetzungsschicht.md`](lab/regelwerk/grundlagen-durchsetzungsschicht.md).
  Wortgleicher Abschnittstext, kein Zusatz-Kopf; ein Agent kann so einen einzelnen
  Grundlagen-Abschnitt laden, ohne das ganze Regelwerk im Kontext zu halten. Die
  Quelle bleibt unberührt (kein Stand-Bump). Cross-Section-Anker (z. B.
  `#kernbegriffe`) zeigen auf die Geschwister-Datei, damit das
  `lab-regelwerk.zip`-Bundle self-navigierbar bleibt; Pfad-Verweise gehen auf den
  Kurs und werden beim Release auf den Tag gepinnt.

### Geändert

- **[`lab/regelwerk/README.md`](lab/regelwerk/README.md)** — Scope von „nur
  Modul-Sektionen" auf „Module + Grundlagen-Rahmen" erweitert (neue
  `### Grundlagen`-Liste); nur Quellen-Rang, Wartung und Stand bleiben der
  Quelldatei vorbehalten. Provenienz-Aufzählung in der Blockquote um
  Durchsetzungsschicht ergänzt (Doku-Drift behoben).
- **d-check-Pin `v0.8.0` → `v0.9.0`** im [`Makefile`](Makefile) (Image-Digest neu
  gepinnt); `make check` grün (140 Dateien, 0 Befunde, 0 ERROR/WARN).

### Korrektur · v1.2.1 — 2026-06-18

- **„Digeste" → „Grundlagen-Abschnitte"** in
  [`lab/regelwerk/README.md`](lab/regelwerk/README.md) (3×) und in der
  Welle-21-Notiz oben. Das Wort suggerierte eine Verdichtung und widersprach
  damit dem »wortgleichen« Charakter der Auszüge. Reine Terminologie — kein
  Inhalts-, kein Stand-Bump; ausgeliefert als Patch-Release `v1.2.1`
  (Assets tag-gepinnt neu gebaut).

## Welle 20 — 2026-06-15 · Regelwerk per Modul + SemVer-Release-Tags

### Neu

- **Regelwerk per Modul** in [`lab/regelwerk/`](lab/regelwerk/) — die 17
  Module (0–16) aus [`agents-regelwerk.md`](kurs/de/agents-regelwerk.md) als
  einzelne Dateien (Kurs-Slugs, wortgleicher Modultext, kein Zusatz-Kopf), plus
  [`README.md`](lab/regelwerk/README.md) als nach Phasen gruppierter Index. Die
  Quelle bleibt unberührt (kein Stand-Bump); ein Agent kann so ein einzelnes
  Modul laden, ohne das ganze Regelwerk im Kontext zu halten. Verweise bleiben
  in-repo relativ (gate-validiert, lokal navigierbar); beim Release pinnt
  `tools/rewrite-doc-links.py --keep-within-src` fürs `lab-regelwerk.zip`-Asset
  nur die Außen-Verweise (Kurs/Templates/Beispiel) auf den Tag — die
  Modul-Querverweise bleiben relativ, das Bundle ist self-navigierbar.

### Geändert

- **Release-Tags auf SemVer** — Schema von `templates-v*` auf `vX.Y.Z` (erstes
  `v1.0.0`). Der `templates-release.yml`-Trigger akzeptiert beide
  (`v[0-9]*` und `templates-v*`, abwärtskompatibel); die Release-Bedingung in
  `rewrite-template-links.sh` ist jetzt prefix-agnostisch (`ref != main`) und
  überlebt künftige Tag-Umbenennungen. Kopf-Kommentar in
  `rewrite-doc-links.py` aufs neue Schema nachgezogen. Adopter-Doku
  (Root-`README.md`, `lab/templates` §Download) auf das Schema und die drei
  Release-Assets (inkl. `lab-regelwerk.zip`) aktualisiert.
- **[`lab/README.md`](lab/README.md)** — `regelwerk/` in Intro-Liste und
  Aufbau-Baum ergänzt (Doku-Drift behoben).
- **`templates-release.yml`** liefert zusätzlich `lab-regelwerk.zip` (17 Module
  + README) als Release-Asset, parallel zu `lab-templates.zip`.

## Welle 19 — 2026-06-14 · C++/CMake-Skelett + Regelwerk-Drift-Sensor

### Neu

- **C++/CMake-Skelett** in [`lab/example/cpp/`](lab/example/cpp/) —
  sechstes Sprach-Skelett (C++20, hexagonal: `src/hexagon` + `src/adapters`),
  doctest via FetchContent (`GIT_TAG`-Pin), clang-tidy mit
  `WarningsAsErrors`, textbasierter `arch-check.sh` (ADR-0001) als
  CTest-Test, gcovr-Coverage. `make gates` grün im Docker (Coverage 94 %);
  Runtime-Image Distroless `cc` mit statisch gelinktem libstdc++ und
  glibc-Match (`debian:12` ↔ `distroless-debian12`, Base-Images per
  `@sha256` gepinnt).
- **Regelwerk-Drift-Sensor** — `make regelwerk-drift`
  ([`lab/example/tools/check_regelwerk_drift.py`](lab/example/tools/check_regelwerk_drift.py)):
  inhaltsbasierter sha256-Pin der adoptierten `agents-regelwerk.md` in
  `conventions.md` §Baseline; erkennt Upstream-Drift unabhängig vom
  `Stand:`-Marker (vgl. §„Nachweis über Inhalt, nicht Diff"). Kein
  `gates`-Glied — CI/periodisch, braucht die externe Quelle.
- **Regelwerk self-contained ausgeliefert** — `tools/rewrite-doc-links.py`
  schreibt die repo-internen Links der adoptierten `agents-regelwerk.md`
  beim Release auf absolute `blob/<tag>`-URLs um (fence- und
  existenz-gegated: illustrative Adopter-Pfade bleiben relativ). Das
  Regelwerk geht als eigenes Release-Asset neben `lab-templates.zip` raus
  (`releases/latest/download/agents-regelwerk.md`); `AGENTS.template`,
  Root-README-Adoption und `lab/templates` §Download zeigen dorthin statt
  auf Raw-`main`. Quelle bleibt relativ (kein
  Stand-Bump). Behebt tote Verweise beim Kopieren/Cachen in fremde Repos.

### Geändert

- Sprach-Skelett-Zählung durchgängig fünf → sechs: Lab-Satelliten
  ([`lab/README.md`](lab/README.md), `lab/example/` README/Makefile/AGENTS,
  ADR-0001-Fitness-Table) und Kurs-Prosa (grundlagen, modul-08, modul-14,
  `agents-regelwerk.md`, konventionen) sowie CO-001 / slice-013 /
  slice-014 / roadmap.

## Welle 18 — 2026-06-11 · Konsistenz-Welle + Agents-Regelwerk

*(Commits dieser Welle tragen das historische Label „Welle 8
(Konsistenz)" — die Kollision mit der älteren Welle 8 war der Anlass
für dieses Register.)*

### Behoben

- Fachdidaktisches Review (konstruktives Alignment, Anderson/Krathwohl,
  CLT, didaktische Rekonstruktion): ~45 Befunde — ungeprobte
  Spitzen-Verben mit `LZ <N>`-Items geschlossen, Tag-Fehler korrigiert,
  Engage-/Glossar-/Stimulus-Fixes.
- Lösungsschicht vollständig nachgezogen: jede Übung und jedes
  Selbstcheck-Item der Module 0–16 hat ein Musterantwort-Pendant.
- Off-by-one-Modulnummern der Modul-2-Einfügung repariert
  (`klassifikation.md`, `lernervorstellungen.md`, `kickoff-vorlauf.md`,
  Modul 9 „8a/8b", Root-README-Phasentabelle).
- Lab-Drift: alle fünf Dockerfiles per Registry-Digest gepinnt
  (inkl. Ersatz des toten C#-Tags `cbl-mariner` → `azurelinux`),
  `make plan-status` ergänzt, Modul-8-Lab-Bezug ehrlich gemacht.
- Richtungsfehler in der Lifecycle-Faustregel (`klassifikation.md`:
  „nach rechts" → „nach links").
- Phase-05-Assessment-Vakuum: Pflicht-Feature „Produktionsfreigabe"
  im Abschlussprojekt, Checkpoint A probt Modul 2, Checkpoint D die
  Sensor-Literacy; Kalibrierungsbeispiel B belegt alle Indikatoren.

### Neu

- **`kurs/de/agents-regelwerk.md`** — der Kurs als Betriebsregelwerk für
  Code-Agenten (derivatives Sicht-Artefakt mit Stand-Zeile), in den
  Session-Lesepfaden verdrahtet (AGENTS-/harness-README-Templates,
  Worked Example, `conventions`-Adoptionsquelle mit Raw-URL).
  Im Lauf der Welle umbenannt (vormals `agents-digest.md`) und
  methodisch neu aufgebaut: statt Hand-Verdichtung ein
  **didaktik-freier Extrakt in Quellformulierung** (~4.000 Zeilen —
  Grundlagen-Dossiers komplett, Module 0–16 als operative Extrakte
  mit Quell-Verweis pro Abschnitt; weggelassen ist die
  Didaktik-Schicht, nicht verdichtet der Inhalt).
- Modul 13: Sektion „Gate-Typ ↔ Fehlerbild" (Zuordnungstabelle).
- Templates: ID-Schema-Deklarations-Slot in
  `conventions.template.md`; AGENTS-Template §5 erklärt die
  ID-Vergabe.
- `docs-check`: nicht-kollabierender Slugger (erstmals 0 ERROR),
  `docs-check:ignore`-Marker, Modul-Nummern-Sensor gegen
  Off-by-one-Drift (Linktext = ERROR, Prosa-Titel = WARN).
- Root-`Makefile`: `make docs-check` · `make alignment-check` ·
  `make check` (Docker-basiert, `ARGS`-Durchreichung).
- GitHub-Actions-Workflow `.github/workflows/checks.yml`: beide
  Validatoren als CI-Gate bei Push/PR, über dieselben Make-Targets
  wie lokal (`alignment-check --strict`).
- Review-Report formalisiert: Vorlage
  `lab/templates/docs/reviews/review-report.template.md`, Ablageort
  `docs/reviews/` in der Verzeichniskonvention, Modul-10-Sektion
  „Reviewer berichtet auch, was er nicht gefunden hat" (schließt die
  bis dahin hängende §-Referenz im Reviewer-Skill).
- Dieses CHANGELOG als kanonisches Wellen-Register.

## Welle 17 — 2026-06-08 · Didaktik-Review

*(Commit-Label: „Didaktik-Review Welle 8" — achte Welle der
didaktischen Teilserie.)* Alignment-, Konsistenz- und CLT-Fixes über
32 Dateien: systemisches und-Verb-Audit, M13-Gate-Familien,
Kickoff-YAML-Zielmodule, M8-Übergabe-Zählung, Vier-Repos-Angaben.

## Wellen 1–16 — 2026-06-02 bis 2026-06-04

| Welle | Datum | Inhalt |
|---|---|---|
| 16 | 2026-06-04 | Fallstudien-Drift gegen Ist-Zustand der vier Beispiel-Repos behoben |
| 15 | 2026-06-04 | Englische Autorzitate ins DE übertragen, Given/When/Then-Notation verankert |
| 14 | 2026-06-03 | 12 Didaktik-Review-Findings (vier Linsen) behoben |
| 13 | 2026-06-03 | 16 Didaktik-Review-Findings behoben |
| 12 | 2026-06-02 | Modul 06: Übungen an beide Erschaffen-LZ gebunden |
| 11 | 2026-06-02 | Reflexionsvorlage: drei → vier Fragen angeglichen |
| 10 | 2026-06-02 | Lab um Module-10/11/14-Artefakte erweitert |
| 9 | 2026-06-02 | Worked Examples für fünf Erschaffen-Lernziele ergänzt |
| 8 | 2026-06-02 | Didaktik-Review-Findings (16 Befunde) behoben |
| 7 | 2026-06-02 | Didaktik-Review-Restposten behoben |
| 6 | 2026-06-02 | Didaktik-Review-Findings (4 Linsen) behoben |
| 5 | 2026-06-02 | Didaktik-Review-Findings (Alignment, Bloom, CLT) behoben |
| 4 | 2026-06-02 | Didaktik-Gutachten-Findings behoben |
| 3 | 2026-06-02 | docs-check-Validator-Findings behoben |
| 2 | 2026-06-02 | Sprach-Skelette-Review-Findings behoben |
| 1 | 2026-06-02 | Kurs-Inhalt-Review-Findings behoben |

Hinweis: Die Verweise „Welle 8" und „Welle 13" in
[`kurs/de/grundlagen/lernervorstellungen.md`](kurs/de/grundlagen/lernervorstellungen.md)
beziehen sich auf diese Zählung.
