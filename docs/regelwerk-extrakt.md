# Regelwerk-Extrakt — Schnittregel und Prüfung

**Stand:** 2026-08-16.

Wie aus `kurs/de` der Betriebsregelwerk-Spiegel unter `lab/regelwerk/` entsteht,
woran sich das Ergebnis prüfen lässt und was daran offen ist. Die Regel steht
**positiv**: Erlaubt sind [fünf Operationen](#teil-2--was-der-spiegel-tun-darf),
alles andere ist ein Befund. **Leser ist, wer
den Spiegel pflegt** — nicht der Lernende und nicht der Adopter. Das *Was* steht
im [README](../README.md#betriebsregelwerk): didaktikfreier Extrakt in
Quellformulierung, derivativ, bei Konflikt gilt das Kursmaterial.

## Warum es überhaupt eine Regel braucht

Der Spiegel trägt je nach Datei **32–62 %** ihrer Quelle. Er ist also
konstruktionsbedingt *nicht* wortgleich — Didaktik entfällt, Verweise werden
umgehängt. Damit steht und fällt die Treue an der Frage, **was weggelassen
werden darf**, und die war bisher nirgends beantwortet.

Der Preis dafür ist gemessen: Die Review-Runden 7–11 enthalten zusammen 99
Erwähnungen des Spiegels, überwiegend Wortlaut-Korrekturen als Einzelfälle. Wo
kein Maßstab steht, schneidet jeder Durchgang ein wenig anders.

## Teil 1 — Was operativ ist

Drei Proben trennen operativ von didaktisch:

| Probe | operativ | didaktisch |
|---|---|---|
| **Adressat** | spricht den an, der *anwendet* | spricht den an, der *lernt* |
| **Weglass-Probe** | gestrichen ändert sich ein **Ausgang** — jemand handelt in einem konkreten Fall anders | gestrichen ändert sich nur das Verständnis |
| **Nachbarschaft** | steht für sich | braucht den Aufbau des Moduls (*„wie eben gesehen"*, Antwort auf eine erwartete Fehlvorstellung) |

## Teil 2 — Was der Spiegel tun darf

Die Regel stand zuerst als **Verbotsliste** da. Sechs Anwendungen, sechs
Formen, die sie nicht vorgesehen hatte — bei jeder war das Ergebnis richtig und
die Regel dagegen. Deshalb steht sie jetzt **positiv**: Erlaubt ist, was hier
steht; alles andere ist ein Befund.

Der Kern in einem Satz:

> **Der Spiegel formuliert nicht.** Er **wählt aus**, **setzt zusammen**,
> **bindet an** und **benennt**.

Daraus fünf Operationen:

| | Operation | erlaubt ist |
|---|---|---|
| **1** | **Weglassen** | ganze Einheiten: Satz, Teilsatz an einer syntaktischen Fuge, Listenpunkt, Tabellenzeile, Abschnitt. **Nicht** ein einzelnes Wort innerhalb einer bleibenden Einheit |
| **2** | **Zusammensetzen** | wörtliche Fragmente von verschiedenen Stellen der Quelle verbinden — auch aus Tabellenzellen, die der Spiegel zu Fließtext fügt. Die Fragmente bleiben unverändert, die Verbindung ist die des Spiegels |
| **3** | **Anbinden** | Verweise samt ihrer einleitenden Wörter umformen (*„siehe X"* → *„(X)"*), und ein Pronomen auflösen, dessen Bezug weggefallen ist (*„sie"* → *„die Regel"*) |
| **4** | **Benennen** | Vorspänne, die eine Aufzählung, Tabelle oder Sektion **benennen** (*„Drei legitime Verdikte."*). Probe: die [Weglass-Probe](#teil-1--was-operativ-ist) rückwärts — ändert der Vorspann einen Ausgang, ist er Aussage und unzulässig |
| **5** | **Aussageform** | eine didaktische Frage, die eine operative Aussage enthält, in diese Aussage überführen (*„Und im Repo ohne Wellen-Betrieb?"* → *„Im Repo ohne Wellen-Betrieb …"*) |

**Was damit ausgeschlossen ist**, ohne dass es einzeln aufgezählt werden müsste:
Ersetzen, Umstellen, Verallgemeinern (`slice-019` → *„Slices"*), Verdichten
eines bleibenden Satzes, und jede Aussage, die die Quelle nicht macht.

**Die Liste ist abschließend gemeint, nicht abschließend bewiesen** — sie ist
aus sechs Anwendungen am eigenen Bestand gewonnen. Wer eine sechste Operation
findet, die keine der fünf trägt, erweitert sie; das ist der reguläre Weg, nicht
die Ausnahme. Der Unterschied zur Verbotsliste ist die **Beweislast**: Dort war
eine unvorhergesehene Form stillschweigend erlaubt, hier ist sie ein Befund, bis
jemand die Liste erweitert.

## Teil 3 — Zwei Proben, und was keine von beiden fängt

Die fünf Operationen sind nicht als Ganzes maschinell prüfbar — Operation 4
verlangt ein Urteil. Zwei Hälften sind es aber, und sie fangen verschiedene
Fehler.

**Probe A — Teilfolge.** Weil nichts umgestellt und nichts ersetzt wird:

> Jeder Spiegel-Satz ist eine **Wort-Teilfolge** der Quellstelle, aus der er
> stammt.

Fängt Ersetzung und Umstellung. Fängt **nicht** Auslassungen unterhalb der
Satzglied-Ebene (ein gestrichenes `siehe` bleibt teilfolgen-legal) und muss
Verweis-Phrasen aus Operation 3 ausnehmen.

**Probe B — Wortdeckung.** Weil der Spiegel nichts formuliert:

> Jedes inhaltstragende Wort des Spiegels kommt in seiner Quelldatei vor.

Fängt **Zusätze** — die vier quellenlosen Aussagen in `modul-12` und
`„Make-Gate mit ADR-ID-Kommentar"` in `modul-13` sind so gefunden worden. Fängt
nicht, wenn ein Wort zwar vorkommt, aber etwas anderes bedeutet.

**Was keine von beiden fängt.** Ein gestrichener Teilsatz kann eine
**Bedingung** getragen haben — aus einer bedingten Regel wird eine unbedingte.
Das ist Operation 1, korrekt ausgeführt und trotzdem falsch. Es bleibt ein
Urteil; nur eines je Streichung statt eines je Satz, und im Diff sichtbar.

**Beide Proben brauchen absatzweise Extraktion.** Vier Anläufe scheiterten
daran, dass Quelle und Spiegel bei ~78 Zeichen an verschiedenen Stellen
umbrechen und der Spiegel sich teils aus Tabellenzellen speist. Wer sie baut,
vergleicht **Absatz-Knoten**, nicht Zeilen.

## Teil 4 — Durchsetzungsstand

**Es gibt keinen Sensor.** Geprüft wird von Hand, in Review-Runden. Das gehört
gesagt, statt ein Gate zu behaupten, das nicht existiert.

Und eine Runde reicht nachweislich nicht: Welle 72 ist `modul-08` eigens auf
Paraphrasen durchgegangen; zwei der drei bestätigten Fälle stehen in derselben
Datei.

**Warum das schwerer wiegt als Repo-Hygiene.** `tools/build-bundle.sh` kopiert
`lab/regelwerk/*.md` und `lab/templates` — **`kurs/de` reist nicht mit**. Wer die
Baseline vendort, hat Rang 2 und 3, nie Rang 1. Die Rangfolge
`kurs/de` → `regelwerk` → `templates` ist damit eine Aussage, die nur wir
überprüfen können; für den Adopter **ist** der Spiegel die Norm. Eine Paraphrase
macht den Korpus nicht bei uns inkonsistent — sie ändert den Normtext, den
jemand anderes bekommt, und kumuliert über Releases.

## Bestätigte Abweichungen — behoben

Am 2026-08-16 nach der Schnittregel korrigiert; jede Korrektur ist gegen die
Teilfolgen-Probe aus Teil 3 gegengeprüft und besteht sie.

| Datei | vorher | jetzt (Quellwortlaut) |
|---|---|---|
| `modul-08-agentenrollen.md` | „der nur bei fehlenden Artefakten existiert" | „das wäre der vierte, *falsche* Pfad, und **er existiert nur, weil Übergabe-Artefakte fehlen**" |
| `modul-10-review-harness.md` | „versioniert, nicht überschrieben" | „Skill-Datei selbst wird **nicht** überschrieben, sondern versioniert" |
| `modul-10-review-harness.md` | „Ein **so entstandener** HIGH-Eintrag" · fehlendes „siehe" | „Ein HIGH-Eintrag, **der aus dem Steering Loop kam**" · „(**siehe** ADR-Hard-Rule …)" |
| `grundlagen-traceability.md` | „Altbestand bleibt ohne Anker" | „**Bestehende Regeln haben keinen rekonstruierbaren Ursprung mehr**" |

Der zweite `modul-10`-Eintrag kam erst beim Review der Korrektur dazu: Er steht
im **unmittelbar anschließenden Satz** des ersten. Wer eine Fundliste abarbeitet
statt die Passage zu lesen, findet ihn nicht — dieselbe Arbeitsweise, die die
Review-Runden 7–11 zu Einzelfall-Korrekturen gemacht hat.

Zwei Nebenwirkungen, beide gewollt:

* Im `modul-08`-Fall entfällt der Vordersatz *„Keine dieser Sequenzen enthält …"*
  — er zeigt auf die Worked-Example-Sequenzen, die im Spiegel nicht mitreisen.
  Das ist die Deixis-Regel, nicht die Schnittregel.
* Im `traceability`-Fall kommt der Link auf *Harness-Lüge* zurück, den die
  Paraphrase fallen gelassen hatte — umgehängt auf `grundlagen-begriffe.md`.

## Kandidatenliste — Durchgang abgeschlossen

Ein enger Test — nur fettgesetzte Regel-Vorspänne, operativ per Konstruktion und
keine Tabellenzellen — lieferte **14 Treffer** in sieben Dateien. Stand
2026-08-16 sind alle entschieden: **3 Falsch-Positive · 5 zulässig · 6 Befunde.**

**Falsch-Positive der Erkennung — 3.** Volle Übereinstimmung in der Quelle; der
Normalisierer scheiterte an Zeilenumbrüchen: *Warum Architect und nicht Planner
allein* (`modul-08`) · *Ins Manifest gehört nur, was der Lauf selbst noch tut*
(`modul-12`) · *Cache-Miss in den Metriken erkennen* (`modul-15`).

**Zulässig — 5.** Vier sind reine Gliederung, die benennt statt zu behaupten:
*„Sensor 2 —"* (`grundlagen-traceability`) · *„Eröffnung — drei Schritte."*
(`modul-06`) · *„Wovon diese Regeln sprechen …"* (`modul-12`) ·
*„Drift-Signal und Schwelle:"* (`modul-15`, der Inhalt darunter ist quelltreu —
`Doku-Konsistenz-Agent` und `consistency_ratio` stehen so in der Quelle).

Der fünfte liegt am Rand: *„Mindestens drei Fälle — Happy · Boundary ·
Negative"* (`modul-12`) zieht **zwei Quellstellen** zusammen, beide wörtlich —
*„mindestens drei Fälle"* und *„Happy, Boundary, Negative"* stehen an
verschiedenen Orten der Quelle. Kein Wort ist geändert, aber die Verbindung ist
die des Spiegels. Siehe unten, Lücke 6.

**Befunde — 6, am 2026-08-16 behoben.**

| Datei | Spiegel | Quelle |
|---|---|---|
| `grundlagen-harness-dateien` | „würde **übersprungen**" | „würde **nach der dritten Welle** übersprungen" |
| `modul-06-roadmap` | Prosa mit *„drei Ausgängen (a)/(b)/(c)"* | eine **Übungs-Tabelle** *„Drei mögliche Antworten"* mit `slice-019`-Beispiel |
| `modul-08-agentenrollen` | „**Im Repo ohne Wellen-Betrieb** läuft…" | „**Und im Repo ohne Wellen-Betrieb?** Dort läuft…" |
| `modul-08-agentenrollen` | „**Der Validator gehört nicht** in diese Prozedur" · „(nach MVP-Slice, vor größeren Wellen)" | „**Wo der Validator bleibt.** … gehören aber **nicht** in diese Prozedur" · „Validierung greift **nach einem MVP-Slice und vor der Implementation größerer Wellen**" |
| `modul-12-replay-evaluierung` | „**Jeder Fall fängt eine andere Fehlerklasse.**" | „Drei Fälle sichern die *Abdeckung* — **je eine Fehlerklasse** Happy, Boundary, Negative" |
| `modul-13-quality-gates` | „**Make-Gate mit ADR-ID-Kommentar** … **bewusstes Brechen** … (`ADR-<NNNN> violated`)" | keine dieser Formulierungen kommt vor |

Zwei stechen heraus. **`harness-dateien`** streicht einen **Qualifikator**: aus
*„wird nach der dritten Welle übersprungen"* wird *„wird übersprungen"* — genau
die Klasse, die [Probe A](#teil-3--zwei-proben-und-was-keine-von-beiden-fängt) als Blindstelle der Teilfolgen-Probe
benennt. Und **`modul-12`** ist kein Paraphrase-Fall, sondern ein **verfasster**:
Vier Aussagen des Absatzes haben in der Quelle **keine Entsprechung** — *„Jeder
Fall fängt eine andere Fehlerklasse"*, *„Drei Varianten desselben Happy Path
sind ein Demo-Set"*, die Begründung zum Boundary-Fall und der `CHANGELOG.md` als
Ort des Kriteriums.

**Wie behoben wurde.** Vier Fälle sind auf Quellwortlaut gezogen. `modul-06`
bekommt die **Tabelle der Quelle zurück** statt der Prosa — sie steht jetzt
wörtlich dort, samt `slice-019` und `CO-009`; die Prosa hatte daraus unter
anderem *„Carveout für die fehlende **Latenz**"* zu *„für den fehlenden
**Beleg**"* gemacht. Und bei `modul-12` wurden die vier quellenlosen Aussagen
**entfernt statt umformuliert** — nach der Fix-Richtung *Quelle → Spiegel*. Sind
sie richtig, gehören sie zuerst in den Kurs.

Eine eigene Diagnose ist dabei gefallen: *„Trigger-Disziplin blieb Theorie"* war
als aus Zeile 2 verschoben und negiert notiert. Falsch — *„Trigger-Disziplin ist
Theorie geblieben"* steht in Zeile 1 der Quelltabelle.

**Trefferquote.** 6 von 14 des engen Tests sind echte Befunde; zusammen mit den
vier bereits behobenen sind damit **zehn Paraphrasen** im Spiegel belegt. Der
Test ist eng — er sieht nur fettgesetzte Vorspänne. Was in normaler Prosa steht,
hat ihn nie erreicht.

## Woraus die fünf Operationen gewonnen sind

Die Verbotsliste der ersten Fassung ist an **sechs** realen Formen gescheitert —
jedes Mal war das Ergebnis im Spiegel richtig und die Regel dagegen. Sie sind
die Vorlage der fünf Operationen in [Teil 2](#teil-2--was-der-spiegel-tun-darf):

| gescheiterte Verbots-Fassung | Fall | jetzt Operation |
|---|---|---|
| „nur ganze Teilsätze" — sagte nichts über Wörter | `siehe` aus *„(siehe ADR-Hard-Rule …)"* gestrichen | **1**, mit ausdrücklicher Wort-Grenze |
| sagte nichts über **Zusätze** | *„Drei legitime Verdikte."* als Tabellen-Vorspann | **4** |
| „umgehängt werden allein die Verweise" — ohne ihre einleitenden Wörter | *„— siehe [X]"* → *„([X])"*, im Spiegel **18-mal** | **3** |
| verbot jede Ersetzung | *„sie"* → *„die Regel"*, weil der Bezugssatz entfällt | **3** |
| „Didaktik weglassen" — ging nicht durch Streichen allein | *„Und im Repo ohne Wellen-Betrieb?"* → Aussage | **5** |
| „nie zusammengefasst" — traf auch Komposition | zwei wörtliche Fragmente verbunden | **2** |

Der Unterschied ist nicht die Länge der Liste, sondern die **Beweislast**. Eine
Verbotsliste erlaubt stillschweigend, was sie nicht vorhergesehen hat; die
positive Fassung macht daraus einen Befund, bis jemand die Liste erweitert.

## Offen

- **Probe A und B auf Absatz-Knoten bauen** — dann wären sie ein Gate. Beide
  brauchen dieselbe Extraktion; wer eine baut, hat die andere fast geschenkt.
- Die fünf Operationen an einer **anderen Datei** erproben als denen, aus
  denen sie gewonnen wurden. Bisher sind sie am eigenen Befund kalibriert.

Wird die Schnittregel zur **zweiten** repo-lokalen Strukturregel, wandert sie
nach `harness/conventions.md`; der Trigger dafür steht in der
[Roadmap](roadmap.md).
