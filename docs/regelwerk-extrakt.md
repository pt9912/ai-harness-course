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
> umgestellt, nie ersetzt, nie zusammengefasst.** Was stehen bleibt, steht in
> Reihenfolge und Wortlaut der Quelle. Umgehängt werden allein die Verweise,
> weil der Split ihre Nachbarschaft ändert.

Zulässig — ein ganzer Teilsatz entfällt:

> **Quelle:** „Die Eröffnung ist Planner-Arbeit — *und das ist eine Aussage,
> keine Leerstelle.* Alle drei Schritte (…) laufen in einem Kontext."
> **Spiegel:** „Die Eröffnung ist Planner-Arbeit — alle drei Schritte laufen in
> einem Kontext."

Unzulässig — umgestellt und ersetzt:

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
oben und weist alle drei bestätigten Paraphrasen unten zurück — deckungsgleich
mit dem Urteil beim Lesen.

**Nicht belegt im Maßstab.** Vier Anläufe scheiterten an der Text-Extraktion,
nicht an der Regel: Quelle und Spiegel sind bei ~78 Zeichen umgebrochen, an
verschiedenen Stellen; dazu speist der Spiegel sich teils aus Tabellenzellen der
Selbstcheck-Rubriken. Ein tragfähiger Lauf muss **ganze Absatz-Knoten**
vergleichen statt Zeilen und Tabellen gesondert behandeln.

**Was die Probe nicht fängt.** Ein gestrichener Teilsatz kann eine **Bedingung**
getragen haben; aus einer bedingten Regel wird dann eine unbedingte. Das bleibt
ein Urteil — aber eines je Streichung statt eines je Satz, und im Diff sichtbar.

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

## Bestätigte Abweichungen

Von Hand geprüft, noch nicht behoben:

| Datei | Spiegel | Quelle |
|---|---|---|
| `modul-08-agentenrollen.md` | „der nur bei fehlenden Artefakten existiert" | „er existiert nur, weil Übergabe-Artefakte fehlen" |
| `modul-10-review-harness.md` | „versioniert, nicht überschrieben" | „nicht überschrieben, sondern versioniert" |
| `grundlagen-traceability.md` | „Altbestand bleibt ohne Anker" | „Bestehende Regeln haben keinen rekonstruierbaren Ursprung mehr" |

Die dritte wiegt am schwersten: Sie ersetzt eine **Begründung** durch eine
**Behauptung** und lässt den Verweis auf *Harness-Lüge* fallen.

## Kandidatenliste

Ein enger Test — nur fettgesetzte Regel-Vorspänne, operativ per Konstruktion und
keine Tabellenzellen — liefert **14 Treffer** in sieben Dateien:
`grundlagen-harness-dateien` · `grundlagen-traceability` · `modul-06` ·
`modul-08` (3) · `modul-12` (4) · `modul-13` · `modul-15` (2).

**Das ist eine Kandidatenliste, keine Defektzahl.** In einer Stichprobe von fünf
war einer ein Falsch-Positiv (*„Warum Architect und nicht Planner allein"* steht
sehr wohl in der Quelle); andere könnten legitime Gliederungs-Zusätze sein. Jeder
Eintrag braucht die Proben aus Teil 1 und 2.

## Offen

- Die drei bestätigten Abweichungen beheben.
- Die 14 Kandidaten mit dem Maßstab aus Teil 1/2 durchgehen.
- Den Teilfolgen-Test auf Absatz-Knoten bauen — dann wäre er ein Gate.

Wird die Schnittregel zur **zweiten** repo-lokalen Strukturregel, wandert sie
nach `harness/conventions.md`; der Trigger dafür steht in der
[Roadmap](roadmap.md).
