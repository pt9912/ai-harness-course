# Regelwerk-Extrakt — Schnittregel und Prüfung

**Stand:** 2026-08-16.

Wie aus `kurs/de` der Betriebsregelwerk-Spiegel unter `lab/regelwerk/` entsteht,
woran sich das Ergebnis prüfen lässt und was daran offen ist. **Leser ist, wer
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

## Teil 2 — Wie ein gemischter Satz geschnitten wird

Viele Sätze tragen beides. Für sie gilt:

> **Gestrichen werden nur ganze Teilsätze, an syntaktischen Fugen** —
> Gedankenstrich, Semikolon, Doppelpunkt, Komma vor Nebensatz. **Nie
> umgestellt, nie ersetzt, nie zusammengefasst**, und **kein einzelnes Wort
> innerhalb eines bleibenden Teilsatzes**. Was stehen bleibt, steht in
> Reihenfolge und Wortlaut der Quelle. Umgehängt werden allein die Verweise,
> weil der Split ihre Nachbarschaft ändert.

**Ein Verweis ist dabei als Ganzes eine Einheit** — die einleitenden Wörter
(*„siehe"*, *„vgl."*) gehören dazu und werden mit ihm umgeformt. Das ist keine
Ausnahme, sondern gelebte Form: Der Spiegel setzt Verweise **18-mal** in
Klammern ans Satzende, wo die Quelle sie in den Satz einbindet; `siehe [` fällt
dabei von 37 Vorkommen auf 7. Ohne diese Klarstellung verböte die Wort-Regel
oben eine Konvention, die der Spiegel braucht, weil seine Verweise ohne die
Modul-Erzählung stehen müssen.

**Und was hinzukommen darf.** Die Regel oben sagt, was *entfällt*. Der Spiegel
muss aber auch etwas *hinzufügen*, weil er anders gegliedert ist als die
Quelle — `modul-08` etwa braucht einen Vorspann, der die Verdikt-Tabelle
einleitet. Dafür gilt:

> **Zusätze sind nur Gliederung, nie Aussage.** Erlaubt ist, was eine
> Aufzählung, Tabelle oder Sektion *benennt* (*„Drei legitime Verdikte."*).
> Unzulässig ist jeder Satz, der etwas behauptet, was in der Quelle nicht
> steht — auch ein zusammenfassender. Die Probe dafür ist die
> **Weglass-Probe aus Teil 1, rückwärts**: Ändert der Zusatz einen Ausgang, ist
> er Aussage und gehört in die Quelle, nicht in den Spiegel.

Ohne diese Hälfte ist die [Kandidatenliste](#kandidatenliste--durchgang-abgeschlossen) nicht
abarbeitbar: Ein fettgesetzter Vorspann ohne Quelle wäre sonst weder erlaubt
noch verboten.

Zulässig — ein ganzer Teilsatz entfällt:

> **Quelle:** „Die Eröffnung ist Planner-Arbeit — *und das ist eine Aussage,
> keine Leerstelle.* Alle drei Schritte (…) laufen in einem Kontext."
> **Spiegel:** „Die Eröffnung ist Planner-Arbeit — alle drei Schritte laufen in
> einem Kontext."

Unzulässig — umgestellt und ersetzt (der Fall ist inzwischen behoben, siehe
unten; er steht hier als Beispiel):

> **Quelle:** „er existiert nur, weil Übergabe-Artefakte fehlen"
> **Spiegel:** „der nur bei fehlenden Artefakten existiert"

## Teil 3 — Die Probe

Wenn nur ganze Teilsätze entfallen und nichts umgestellt wird, folgt daraus eine
maschinell entscheidbare Eigenschaft:

> **Jeder Regelwerks-Satz ist eine Wort-Teilfolge eines Quellsatzes.**

Damit wandert die Treue-Regel aus der inferentiellen in die computationale
Hälfte — der Spiegel bekäme den Sensor, den er heute nicht hat, und die
Review-Runden müssten keinen Wortlaut mehr vergleichen.

**Belegt an vier Fällen von Hand:** Die Probe akzeptiert den Planner-Schnitt
oben und weist die drei Paraphrasen zurück, die unten behoben sind —
deckungsgleich mit dem Urteil beim Lesen. Auch die drei Korrekturen selbst sind
gegen sie geprüft und bestehen sie.

**Nicht belegt im Maßstab.** Vier Anläufe scheiterten an der Text-Extraktion,
nicht an der Regel: Quelle und Spiegel sind bei ~78 Zeichen umgebrochen, an
verschiedenen Stellen; dazu speist der Spiegel sich teils aus Tabellenzellen der
Selbstcheck-Rubriken. Ein tragfähiger Lauf muss **ganze Absatz-Knoten**
vergleichen statt Zeilen und Tabellen gesondert behandeln.

**Was die Probe nicht fängt — zwei Dinge.**

*Erstens: Sie prüft die Reihenfolge, nicht die Vollständigkeit.* Ein einzelnes
gestrichenes Wort — `siehe` aus *„(siehe ADR-Hard-Rule, Modul 4)"* — ist
teilfolgen-legal und nach Teil 2 trotzdem unzulässig, weil es kein ganzer
Teilsatz ist. Die Probe ist damit **notwendig, nicht hinreichend**; sie fängt
Umstellungen und Ersetzungen, nicht Auslassungen unterhalb der Satzglied-Ebene.
Eine Vollständigkeits-Probe muss **Verweis-Phrasen ausnehmen**, sonst meldet sie
jede der 18 Klammer-Umformungen als Defekt.

*Zweitens: Ein gestrichener Teilsatz kann eine Bedingung getragen haben*; aus
einer bedingten Regel wird dann eine unbedingte. Das bleibt ein Urteil — aber
eines je Streichung statt eines je Satz, und im Diff sichtbar.

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

**Befunde — 6, noch nicht behoben.**

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
die Klasse, die [Teil 3](#teil-3--die-probe) als Blindstelle der Teilfolgen-Probe
benennt. Und **`modul-06`** wandelt eine *didaktische Übungstabelle* in
operative Prosa: Dabei wird `slice-019` zu „Slices" generalisiert und
*„Trigger-Disziplin wirkt"* aus der zweiten Zeile als *„blieb Theorie"* nach (a)
verschoben und negiert.

**Trefferquote.** 6 von 14 des engen Tests sind echte Befunde; zusammen mit den
vier bereits behobenen sind damit **zehn Paraphrasen** im Spiegel belegt. Der
Test ist eng — er sieht nur fettgesetzte Vorspänne. Was in normaler Prosa steht,
hat ihn nie erreicht.

## Die Regel ist noch nicht fertig

Der Durchgang hat **zwei weitere Lücken** offengelegt, zusätzlich zu den drei
aus der ersten Anwendung:

* **Pronomen-Auflösung.** Fällt der Bezugssatz weg, muss *„sie"* zu *„die
  Regel"* werden — notwendig, und nach der Regel eine verbotene Ersetzung.
  Braucht dieselbe Behandlung wie die Verweis-Phrasen.
* **Didaktische Frageform.** *„Und im Repo ohne Wellen-Betrieb?"* → Aussage ist
  Didaktik-Weglassen, geht aber nicht durch Streichen allein.
* **Zusammenziehen zweier Quellstellen.** *„Mindestens drei Fälle — Happy ·
  Boundary · Negative"* verbindet zwei wörtliche Fragmente von verschiedenen
  Orten. Kein Wort geändert, und trotzdem von *„nie zusammengefasst"* verboten.
  Das Verbot zielt auf Umformulieren, nicht auf Komposition — es trennt beides
  nicht.

Sechs Nachschärfungen in zwei Runden. Das Muster ist deutlich: **Die Regel ist
als Verbotsliste gebaut und stößt bei jedem realen Fall auf eine Form, die sie
nicht vorgesehen hat.** Sie wird deshalb **nicht weiter angestückelt**, sondern
nach dem vollständigen Durchgang **einmal neu formuliert** — vermutlich
positiv (*was der Spiegel tun darf*) statt negativ.

## Offen

- Die **sechs Befunde** aus dem Durchgang beheben.
- Die Regel **neu formulieren** statt weiter nachzuschärfen — siehe oben.
- Den Teilfolgen-Test auf Absatz-Knoten bauen — dann wäre er ein Gate.

Wird die Schnittregel zur **zweiten** repo-lokalen Strukturregel, wandert sie
nach `harness/conventions.md`; der Trigger dafür steht in der
[Roadmap](roadmap.md).
