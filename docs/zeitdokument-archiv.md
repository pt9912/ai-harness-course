# Zeitdokumente archivieren — Entwurfsstand

> **Stand:** 2026-08-31 · **Status:** Diskussionsstand, nicht normativ.
>
> Diese Datei hält einen möglichen Umgang mit abgeschlossenen Zeitdokumenten
> fest — Review-Reports, geschlossene Slices, geschlossene Welle-Pläne. Sie
> ändert weder den Kurs noch den Regelwerk-Spiegel oder die Templates. Eine
> Verkörperung folgt der Rangfolge dieses Repos:
> `kurs/de` → `lab/regelwerk` → `lab/templates` → `lab/example`.

## Anlass

Das Problem ist nicht der Platz, sondern das **Rauschen im Agentenlauf**. Ein
Agent sucht mit `grep` nach einem Begriff und bekommt Treffer aus Dokumenten,
die den Begriff in einem Zustand tragen, den es nicht mehr gibt. Ein
Review-Satz von vor drei Monaten liest sich in einer Trefferzeile wie die
geltende Regel.

Der Korpus kennt diese Diagnose bereits — eine Ebene tiefer. Er begründet die
Aufteilung des Konventionsspeichers in eine Datei je Eintrag damit, dass ein
aufgelöster Eintrag sich wie ein geltender liest und das nicht nur
Kontext-Kosten sind, sondern ein Korrektheits-Risiko
([`harness-dateien.md` §Konventionsspeicher](../kurs/de/grundlagen/harness-dateien.md#harnessconventionsmd-als-konventionsspeicher)).
Gelöst wurde es dort über die Verzeichnis-Position: Aufgelöstes wandert nach
`conventions/done/`, und gelesen wird nur, was in Geltung ist.

Für Reviews und geschlossene Slices gibt es diese Bewegung nicht. Sie bleiben
liegen, wachsen linear mit der Arbeit und sprechen weiter mit.

### Gemessen an einem Adopter-Repo

Erhoben an `ai-harness-init` (Stand 2026-08-31): 245 Review-Reports (6,1 MB,
drei Monate, rund 2,7 pro Arbeitstag) und 113 geschlossene Slices (2,5 MB).
Zehn realistische Suchbegriffe über die 113 Slices ergeben **3320
Trefferzeilen**.

Werkzeugseitige Abhilfen scheiden aus, weil sie an der lokalen Installation
hängen und die sich nicht kontrollieren lässt:

| Ansatz | Ergebnis |
|---|---|
| `.ignore`-Datei | wirkt nur, wenn die Suche über ripgrep oder ein `ugrep` mit `--ignore-files` läuft; gegen GNU grep wirkungslos (gemessen) |
| `GREP_OPTIONS` | seit GNU grep 2.21 ignoriert (gemessen) |
| Wrapper-Funktion, Shell-Profil | wird im nicht-interaktiven Lauf nicht geladen (gemessen) |
| `--exclude-dir` als Konvention | portabel, aber Anweisung statt Durchsetzung |

Bleibt der einzige Hebel, der von keinem Werkzeug abhängt: **Was nicht im
Arbeitsbaum steht, kann nicht getroffen werden.**

## Zielform

Die Zeitdokumente einer Welle wandern mit ihrer Closure in ein
unveränderliches Archiv; die Dateien mit eigener Identität bleiben als
gekürzter Stub liegen.

```text
docs/plan/planning/done/
├── welle-07/                    die archivierte Welle, als Verzeichnis
│   ├── archiv.zip               alle Volltexte
│   ├── welle-07-cache.md        Stub
│   ├── slice-042-cache.md       Stub
│   └── slice-043-fixture.md     Stub
├── welle-07-results.md          BLEIBT vollständig, BLEIBT flach
└── slice-051-laufend.md         Slice der noch offenen Welle, unberührt
```

**Das Verzeichnis ist nicht Ordnungsliebe, sondern die Bedingung dafür, dass
der Sensor überhaupt baubar ist** — gemessen, siehe §Der Sensor.

Die **Ergebnisnotiz der Welle bleibt unangetastet**. Sie ist die Bedeutung,
die die archivierten Dateien ersetzt; das Archiv ist nur die Koordinate.

### Die zwei Stub-Formen

```markdown
# slice-<NNN> — <Titel>

> **ARCHIVIERT** — Volltext:
> `unzip -p done/welle-<NN>/archiv.zip done/slice-<NNN>-<slug>.md`

**Welle:** <welle-<NN> · oder `ohne Welle`>
**Archiviert mit:** welle-<NN> · **Geschlossen:** <JJJJ-MM-TT>
**Hervorgegangen:** <BEO-*, ADR-*, Folge-Slice — oder `— keine —`>
```

```markdown
# welle-<NN> — <Titel>

> **ARCHIVIERT** — Volltext:
> `unzip -p done/welle-<NN>/archiv.zip done/welle-<NN>-<slug>.md`

**Geschlossen:** <JJJJ-MM-TT> · **Ergebnisnotiz:** welle-<NN>-results.md
**Archivierte Vorgänge:** <N Slices, M Reviews>
```

**Warum `Welle:` und `Archiviert mit:` zwei Felder sind.** Sie tragen zwei
verschiedene Tatsachen: *Mitgliedschaft* — gehört dieser Slice in ein Bündel —
und *Einsammlung* — welche Closure hat ihn ins Archiv genommen. Für einen
Slice ohne Wellen-Zugehörigkeit fallen sie auseinander, und das ist kein
Randfall: In einem gemessenen Adopter-Repo sagen **40 von 95** geschlossenen
Slices ausdrücklich *„ohne Welle"*. Schriebe der Stub die einsammelnde Welle
in `Welle:`, behauptete ein **Zustandsfeld** eine Mitgliedschaft, die es nie
gab — und für Zustandsfelder gilt dieselbe Regel wie für die Stand-Spalte des
Beobachtungs-Registers: Zustand und Beleg, keine Chronik
([Modul 6 §Das Beobachtungs-Register](../kurs/de/02-planung/modul-06-roadmap.md#das-beobachtungs-register)).
Wo beide zusammenfallen — der Regelfall — stehen sie redundant nebeneinander.
Das ist der Preis dafür, dass der Sensor eine reine Form-Prüfung bleibt.

## Die Regel

> Mit der Closure einer Welle wandern ihre Zeitdokumente in ein
> unveränderliches Archiv. Dateien mit eigener Identität bleiben als Stub
> liegen; die Ergebnisnotiz bleibt vollständig.

| Klasse | Volltext | im Arbeitsbaum bleibt |
|---|---|---|
| Slice in `done/` | ins Archiv | Stub |
| Welle-Plan in `done/` | ins Archiv | Stub |
| Review-Report | ins Archiv | **nichts** |
| Welle-Ergebnisnotiz | bleibt | vollständig |

**Auslöser ist die Wellen-Closure**, kein Zeitraum und keine Mengen-Schwelle.
Eine Quote misst Volumen, der Vorgang ist aber die Bedeutung: Sie feuerte
mitten in einer offenen Welle oder ließe eine geschlossene liegen, und sie
bräche die Unveränderlichkeit des Archivs — ein Nachtrag verlangt ein neues
Zip.

**Erst die Achse klären, sonst greift die Regel daneben.** *Wellenlos* ist
eine Eigenschaft des **Repos**, nicht des einzelnen Slice — das Kopf-Feld
`**Welle:**` sagt nur, ob *dieser* Slice in ein Bündel gehört
([Modul 6 §Wann Arbeit eine Welle braucht](../kurs/de/02-planung/modul-06-roadmap.md#wann-arbeit-eine-welle-braucht--und-wann-nicht)).
Daraus folgen zwei verschiedene Fälle, und nur einer ist offen:

- **Repo mit Wellen, Slice ohne `Welle:`.** Kein Sonderfall. Die
  Welle-Closure liest und prüft ohnehin alles, was seit der letzten Welle in
  `done/` gelandet ist, *auch Slices ohne Wellen-Zugehörigkeit* — also nimmt
  sie das Archiv der Welle auf, deren Closure sie eingesammelt hat. Kein
  zweiter Mechanismus, keine Schwelle, keine fünfte Lifecycle-Position.
- **Repo ganz ohne Wellen.** Erst hier fehlt der Sammelpunkt. Modul 6 nennt
  für Zähler, Lese-, Sichtungs-Schritt und Trigger-Audit je einen
  Ersatz-Träger; für das Archivieren nennt es keinen. Eine Schwelle ist dort
  der ehrlichste Ersatz, den es gibt — als Fallback und nicht als Regelfall.
  Das bleibt die einzige offene Stelle dieser Regel.

**Ort ist der Hauptzweig**, als eigener Commit. Auf einem Feature-Branch
archiviert, kollidiert die Aktion mit jeder anderen Sicht auf `done/`: Der
Merge bringt gelöschte Dateien zurück oder erzeugt Konflikte an Dateien, um
die es inhaltlich nicht geht. Es ist dieselbe Begründung, aus der der
Lifecycle-`git mv` auf den Hauptzweig gehört.

**Die Operation ist mechanisch** — zippen, kürzen, Zip committen — und gehört
in ein Werkzeug, nicht in Handarbeit. Der Grund steht unter §Sensor.

### Der Kürzungs-Schnitt

Im Stub bleiben **Identität, Zustand und die Kennungen, die den Vorgang
überlebt haben**. Alles andere geht ins Archiv: Lerneintrag-Prosa,
Risiko-Ausgänge, DoD-Tabelle, Abnahme-Notizen.

Der Schnitt ist zulässig, weil er nichts entfernt, was gelesen wird: Was
weitergelesen wird, steht ohnehin schon dort, wo es gelesen wird — die
Beobachtung im Register, die Entscheidung als ADR, die Folgearbeit als Slice.
Die Zeile **Hervorgegangen** nennt genau diese Orte und macht den Schnitt
damit prüfbar statt behauptet.

**Das Kürzen ist eine Inhaltsänderung an einem abgeschlossenen Dokument** und
braucht deshalb eine ausdrückliche Erlaubnis in der Regel. Sie trägt, weil der
Volltext an zwei Orten weiterlebt — im Archiv und in der git-Historie —, aber
sie muss dastehen, sonst ist es das stille Überschreiben, das der Korpus sonst
verbietet.

## Zwei Entscheidungen, die anders ausfallen könnten

**Kein zentrales Register, sondern Stubs.** Ein Index-Dokument mit einer Zeile
je archiviertem Vorgang wäre beim Rauschen gleichwertig — dieselben rund 38
Trefferzeilen, nur in einer Datei statt in 113. Der Stub gewinnt an zwei
anderen Stellen: Die **Verzeichnis-Position bleibt der Zustand** (keine fünfte
Lifecycle-Position, keine Änderung an der Zustandsmaschine aus
[Modul 5](../kurs/de/02-planung/modul-05-planning-harness.md#lifecycle-als-state-machine)),
und **eingehende Verweise bleiben gültig**, ohne dass jemand sie anfasst. Beim
Register könnte außerdem eine Zeile fehlen und ein Vorgang unbemerkt
verschwinden; beim Stub sind Kürzen und Zeugnis derselbe Vorgang.

**Kein Stub für Review-Reports.** Ein Review hat keine Identität jenseits
seines Slice; er wird in dessen Archiv gefunden. Der Kurs führt ihn als
Lauf-Beleg, der über Läufe hinweg nicht gelesen wird — seine Klassen wandern
über den Lerneintrag in den Zähler
([Modul 5](../kurs/de/02-planung/modul-05-planning-harness.md#offene-risiken-werden-bei-closure-aufgelöst)).
Wo Rang-Dokumente heute einzelne Reports verlinken, ist das kein Argument für
einen Stub, sondern der Befund: Ein Stub würde eine Verweisform legitimieren,
die der Korpus ablehnt. Diese Verweise werden vor dem Archivieren eingelöst —
die Aussage wird am zitierenden Ort zitiert, die Report-Kennung bleibt im Text.

## Der Sensor

Die feste Stub-Form macht die Prüfung zu einer **Form-Prüfung**, nicht zu
einer Urteilsfrage. **Gemessen an d-check `v0.71.1`, Modul `structure`:**

> ```yaml
> - files: "docs/plan/planning/done/welle-*/slice-*.md"
>   section-pattern: '^# slice-'
>   require-pattern: '\*\*Archiviert mit:\*\*'
>   forbid-pattern: '(?m)^## '
> ```

**Zwei Bedingungen, weil die Marke allein die Kürzung nicht belegt.** Die erste
verlangt den Marker, die zweite verbietet eine **H2**: Ein Stub trägt eine
Überschrift und Felder, ein ungekürzter Slice-Plan trägt seine Abschnitte
(`## 7. Lerneintrag`, `## 8. Abnahme`). Damit meldet der Sensor beide Fälle —
den Slice ohne Marker und den **mit** Marker und vollem Text — und bleibt still
beim Slice der offenen Welle. Das `(?m)` ist nicht Kosmetik: Ohne
Multiline-Flag ankert RE2 am Textanfang, und die Bedingung schweigt (gemessen).

Die zweite Bedingung entstand aus einer Mutationsprobe: *Marker schreiben,
Kürzung auslassen* ließ die erste Fassung still — sie sah die Marke, nicht den
Volltext. Mit der H2-Bedingung wird derselbe Lauf rot.

**Was der Sensor weiterhin nicht sieht:** eine Kürzung, die die Überschriften
entfernt und den Fließtext stehen lässt. Geprüft ist die **Form**, nicht die
Länge. Das ist eine schwächere Lücke als die vorige, aber sie gehört benannt.

**Und genau daran ist die erste Fassung gescheitert.** Ohne das
Wellen-Verzeichnis lautet der Glob `done/slice-*.md`, und `require-pattern`
ist **unbedingt** über seinen Glob: Es kann *Slice einer archivierten Welle*
nicht von *Slice einer offenen Welle* unterscheiden. Gemessen meldete diese
Fassung beide — den vergessenen Slice richtig und den laufenden falsch. Ein
Sensor, der bei jeder korrekt geschlossenen Arbeit rot wird, ist genau das,
wogegen er gebaut ist. **Der Geltungsbereich muss also im Pfad stehen, weil
die Bedingung ihn nicht ausdrücken kann.**

**Die zweite Hälfte bleibt unbaubar.** Die Abzählung — *die Zahl der Stubs mit
`Archiviert mit: welle-<NN>` stimmt mit der im Welle-Stub deklarierten Zahl* —
verlangt einen Vergleich **über Dateien hinweg**; `structure` prüft je Datei
und Abschnitt. Sie bleibt damit eine Zusage des Archivierungs-Werkzeugs, kein
Gate.

**Und eine dritte Lücke:** Dass Review-Reports **keinen** Stub bekommen, prüft
nichts. Ein versehentlich erzeugter Review-Stub liegt einfach da; nur die fest
verdrahtete Zahl der Probe fällt darauf.

**Was auch damit nicht prüfbar bleibt:** Ein geschlossener Slice **ohne**
Zugehörigkeit, den beim Archivieren niemand eingesammelt hat, liegt weiter
flach in `done/` und fällt aus dem Glob. Er ist von keiner Form-Prüfung zu
finden. Ebenso wenig prüfbar ist, ob das Archiv **vollständig** ist. Beides
bezeugt nur der Archivierungs-Commit — deshalb gehört die Operation in ein
Werkzeug.

## Messungen

**Rauschen** (113 Slices aus `ai-harness-init`, zehn Suchbegriffe):

| | Trefferzeilen |
|---|---:|
| Volltext | 3320 |
| Stubs | 38 |

Die 38 Resttreffer liegen fast alle in der **Titelzeile** — ein Slice namens
*Baseline-Umzug*, der bei der Suche nach `Baseline` erscheint, ist kein
Rauschen, sondern der gesuchte Treffer. Und jeder trägt zwei Zeilen weiter das
Wort `ARCHIVIERT`. Für die Reviews ist die Zahl **null**: Sie bekommen keinen
Stub.

**Archiv-Format** (245 Reviews, drei Runden mit je 12 neuen Dateien):

| Format | git-Pack nachher | vor der Suche verborgen |
|---|---|---|
| Text (heute) | 2,93 MiB | nein |
| **Zip** | **2,94 MiB** | ja |
| tar | 2,57 MiB | **nein** — Klartext liegt roh im Archiv |
| tar.gz | **6,54 – 9,56 MiB** | ja |

**Die tar.gz-Zahl ist methodenabhängig, und das gehört dazu:** 9,56 MiB bei
Verzeichnis-Reihenfolge im `tar`, 7,26 mit `--sort=name`, 6,54 zusätzlich mit
`git repack -adq`. Ein Review konnte sie mit **synthetischen** Korpora nicht
reproduzieren und kam in die Gegenrichtung — an diesem realen Bestand hält die
Richtung dreimal. Die Aussage ist also *tar.gz kostet ein Vielfaches*, nicht
*tar.gz kostet 9,56 MiB*.

`tar.gz` scheidet aus: gzip komprimiert den ganzen Strom, jede Neuverpackung
ist ein neuer, nicht deltabarer Blob. Zip komprimiert je Eintrag, unveränderte
Einträge ergeben identische Byte-Folgen, und git deltat sie — deshalb kostet
Zip so viel wie der heutige Text-Bestand. Bei einem Archiv **je Welle**
entfällt die Frage ohnehin: Es wird einmal geschrieben und nie wieder
angefasst.

## Grenzen — ausdrücklich

- **Shallow-Klon.** Der Volltext liegt zwar im Archiv und damit auch in einem
  flachen Klon; der Rückgriff auf die git-Historie (`git show <hash>:<pfad>`)
  scheitert dort aber mit *„ungültiger Objektname"* und braucht
  `git fetch --unshallow`. Gemessen.
- **`grep -z` findet das Archiv trotzdem** — ugrep entpackt Zip. Das ist
  gewollt: Wer Historie sucht, hat einen Schalter. GNU grep meldet eine Zeile
  *„Übereinstimmungen in Binärdatei"*; das ist eine Zeile statt hunderter.
- **Das Archiv ist für jedes Gate opak.** Keine Link-, Anker- oder
  Pfadprüfung im Inneren. Was archiviert wird, ist vorher gate-grün und wird
  danach nicht mehr editiert.
- **Der Umzug ins Wellen-Verzeichnis ändert Pfade.** Das ist der Preis für den
  baubaren Sensor, und er trifft die Eigenschaft, die den Stub sonst auszeichnet:
  Eingehende Verweise auf einen archivierten Slice brechen, wenn das Werkzeug
  sie nicht mitzieht. Die Operation muss also nicht nur zippen und kürzen,
  sondern auch die Verweise nachziehen — dieselbe Bauform wie ein
  Lifecycle-`git mv`, der seine Referenzen mitnimmt.
- **Die Verzeichnis-Sicht wird dafür kürzer:** `done/` zeigt die Slices der
  offenen Welle plus eine Handvoll Wellen-Verzeichnisse statt aller
  geschlossenen Slices.

## Die Proben, gefahren

Alle sechs sind am 2026-08-31 in [`lab/team-sim`](../lab/team-sim/README.md)
als s19 gelaufen (d-check `v0.71.1`, 8 Verdikte, Gesamtlauf 44/44 · 0 KAPUTT):

| Probe | Szenario | Ergebnis |
|---|---|---|
| Archivierungs-Lauf mit Zählung | s19a | 6 Volltexte im Zip, 4 Stubs — Reviews bekommen keinen |
| Deckungs-Sensor gegen einen nicht gekürzten Slice | s19f | `section-pattern-missing`, mit `structure` allein |
| Rückgriff im `--depth 1`-Klon | s19h | Archiv liefert, `git show` scheitert |
| Trefferzahl vorher/nachher | s19b | 17 → 5 an der Fixture |
| Verweise lösen nach dem Umzug auf | s19d/e | grün — **nach einer Reparatur**, mit Gegenprobe |
| Slice ohne Wellen-Zugehörigkeit | s19c | `Welle:` bleibt `ohne Welle`, `Archiviert mit:` nennt die einsammelnde |

Dazu eine Gegenkontrolle, die im Entwurf nicht stand: **s19g** — der Slice der
noch **offenen** Welle wird nicht eingesammelt, bleibt flach in `done/` liegen
und wird nicht gemeldet. Ohne ihn wäre „der Sensor beißt" belegt, „er beißt nur
die Richtigen" aber nicht.

**Die Auswahl gehört in die Operation, nicht in ihren Aufrufer** — und das ist
ein Ergebnis der Probe, kein Entwurfs-Detail. Solange das Szenario der
Operation eine fertige Dateiliste übergab, war *sie greift den offenen Slice
nicht* per Konstruktion wahr und durch keine Mutation widerlegbar. Erst mit der
Auswahl in der Operation prüft s19g etwas: Sie sammelt die Slices der
geschlossenen Welle **und** die wellenlosen ein, aber nicht die einer offenen.
Gegengeprüft mit zwei Mutationen — *sammelt alles ein* macht s19g rot,
*vergisst den wellenlosen Slice* macht s19c rot.

### Was die Proben geändert haben

**Der Verweis-Nachzug braucht zwei Formen, nicht eine.** Der erste Lauf war
rot. Der Nachzug traf nur Verweise mit `done/`-Präfix, wie das Register sie
schreibt. Die **Ergebnisnotiz** schreibt aber geschwister-relativ — sie liegt
selbst in `done/` und **bleibt** dort, während ihre Slices ins
Wellen-Verzeichnis wandern. Das ist kein Sonderfall, sondern der garantierte
Fall dieses Entwurfs: Die Notiz bleibt per Regel flach, ihre Slices ziehen per
Regel um. Dieselbe Blindstelle benennt der Skriptkopf von `slice-mv.sh` im
Nachbar-Repo für sich selbst.

Für die Regel heißt das: Die Archivierungs-Operation zieht **beide** Formen
nach, und die Ergebnisnotiz ist ihr Pflichtfall — nicht ihr Randfall.

## Was noch offen ist

Zwei Dinge, beide benannt statt überspielt:

1. **Das Repo ganz ohne Wellen.** Dort fehlt der Sammelpunkt; eine Schwelle
   bleibt der Fallback. Unverändert offen.
2. **Die Vollständigkeit des Archivs** — jede gekürzte Datei liegt als
   Volltext darin — bezeugt nur der Archivierungs-Commit. s19a prüft beide Zahlen
   gegen die erwarteten Werte des Laufs — nicht gegeneinander; ein Gate danach
   kann sie ohnehin nicht wiederholen, weil das Zip opak ist.

Damit ist die Form geprobt. Ob sie in den Kanon geht, ist die nächste
Entscheidung; sie berührt Modul 5 (Lifecycle), Modul 6 (Wellen-Closure) und
Modul 10 (Review-Report als Lauf-Beleg) — Spiegel, Vorlagen und Beispiel
folgen, nicht umgekehrt.
