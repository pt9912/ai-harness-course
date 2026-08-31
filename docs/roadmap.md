# Roadmap — offene Fäden des Kurs-Repos

Dieses Repo führt einen **bewusst reduzierten Harness**: `CHANGELOG.md` ist das
Wellen-Register (Closure-Log), `make check` sind die Gates, d-check ist per
Digest gepinnt. Kein Slice-Lifecycle, keine ADRs, keine Spec — für ein
Doku-Repo wäre das Zeremonie ohne Substanz.

Eine Ausnahme steht neben `make check`: `make doc-immutable RANGE=base..head`
prüft, dass die ADRs des Beispiels nach `Accepted` unverändert bleiben. Es
braucht eine Commit-Range und läuft deshalb nicht im hermetischen Sammel-Target,
sondern als eigener CI-Job am Pull Request.

Diese Datei ist das **Gegenstück zum CHANGELOG**: dort steht, was geschlossen
wurde, hier, was offen ist und *woran man erkennt, dass es dran ist*. Ohne sie
liegen offene Fäden als Fließtext in alten Wellen-Einträgen und werden nie
wieder gelesen.

> **Pfad-Abweichung, deklariert.** Der Kurs lehrt
> `docs/plan/planning/in-progress/roadmap.md`
> ([`harness-dateien.md` §Verzeichniskonvention](../kurs/de/grundlagen/harness-dateien.md#verzeichniskonvention)).
> Dieses Repo führt die Roadmap **flach** unter `docs/roadmap.md`, weil der
> gelehrte Pfad die vier Lifecycle-Verzeichnisse voraussetzt — und die ohne
> Slice-Betrieb anzulegen wäre leere Form: Verzeichnisse, die keinen Betrieb
> tragen, behaupten Reife, die es nicht gibt. Das ist *analog* zur Warnung vor
> „Struktur ohne Substanz" in
> [`bootstrap.md` §Was ist eine Sub-Area?](../kurs/de/grundlagen/bootstrap.md#was-ist-eine-sub-area)
> — der dortige Drei-Achsen-Test wird hier **nicht** angewandt, er beantwortet
> eine andere Frage. Die Abweichung ist eine Entscheidung, kein Versehen.
>
> **Zweite Abweichung: Release wird unter *Meilensteine* geführt.** Modul 6
> trennt beides — ein *Meilenstein* ist ein extern beobachtbarer Zustand, ein
> *Release* ein Artefakt, das das Repo in eine Umgebung verlässt. Ein Tag mit
> gebautem Bundle ist danach ein Release. Dieses Repo führt dafür **keinen
> eigenen Abschnitt**: Es liefert genau eine Artefaktklasse (das
> Baseline-Bundle), und ein Abschnitt mit einer Zeile pro Tag wäre die
> Zeremonie, vor der die Roadmap-Lehre selbst warnt. Releases stehen deshalb
> unter *Meilensteine*. Auch das ist eine Entscheidung, kein Versehen.

## Offene Fäden

Form nach [Modul 6](../kurs/de/02-planung/modul-06-roadmap.md): **Trigger ist
ein beobachtbares Ereignis, kein Datum.** Ein Faden ohne Trigger ist ein
Wunsch, kein Plan — deshalb steht bei den betroffenen Zeilen ausdrücklich
*nicht gesetzt* statt eines erfundenen Termins.

**Zweite Disziplin, aus Welle 55 gelernt: Ein Faden trägt zwei Dinge — eine
*Behauptung über den Ist-Zustand* und eine *vorgeschlagene Handlung*. Wer nur
die Behauptung prüft, hat den Faden nicht geprüft.** Am 2026-07-27 wurden alle
sechs offenen Fäden auditiert; das Audit prüfte ausschließlich die
Behauptungen. Ergebnis damals: „fünf von sechs halten". Beim späteren Anfassen
fielen zwei davon trotzdem — bei beiden war die Behauptung *wahr* und die
Folgerung falsch:

- *Mechanische Wächter*: „`d-check` prüft keine Prosa-Behauptungen" — wahr.
  „Also lässt sich das prüfen" — falsch, die Fehlerklassen sind semantisch.
- *Fork-Grenze*: „speist kein Feld, kein Gate, keine Übung" — wahr. „Also ist
  es Zeremonie" — falsch, das Kriterium hätte die Regel erschlagen, auf die es
  sich beruft.

Die Behauptung prüft ein `grep` in Sekunden. Die Folgerung braucht einen
Prototyp oder die Gegenprobe am eigenen Maßstab. Beides gehört zum Audit,
sonst bestätigt es nur, dass der Faden ordentlich *formuliert* ist.

| Faden | Trigger | Stand |
|---|---|---|
| **Sensoren aus dem git-Index ableiten statt Scan-Listen zu pflegen** — `docs-check.js` (`SKIP_DIRS`) und die zwei `scan.ignore` sind handgepflegte **Näherungen** an das, was ein frischer Checkout enthält. `.gitignore` ist dabei nicht das dritte Duplikat, sondern die Quelle: Es definiert die Wahrheit, die anderen bilden sie nach. Die Wahrheit hat eine exakte Schreibweise — `git ls-files --cached --others --exclude-standard -- '*.md'` (getrackt **plus** neu und nicht ignoriert) **Handlung:** `docs-check.js` bekommt `--files-from` (sein Image hat kein git — die Liste berechnet das Makefile); an d-check geht ein CR für `scan.tracked-only` (`tracked` und `vcs` lesen `.git` schon read-only, `scan` kennt nur `roots` und `ignore`); danach tragen die `scan.ignore` nur noch **semantische** Ausnahmen (`CHANGELOG.md`, `lab/templates`) statt Artefakt-Buchhaltung. Nicht: die Listen aus `.gitignore` generieren — das hält die Näherung nur synchron, statt sie abzuschaffen | **eine zweite Divergenz zwischen lokalem Lauf und CI** — dann ist die Handprobe nachweislich zu schwach. (Beide Vorbedingungen sind bereits erfüllt, es fehlt keine: `docs-check.js` ist unser Werkzeug, und d-check nimmt Change Requests an — drei sind am 2026-08-10 geliefert worden. Zurückgestellt ist es aus Priorität, nicht aus Machbarkeit) | offen seit Welle 74; **1× beobachtet** — unter der 3×-Schwelle der Zählregel, deshalb bewusst kein Sensor. Messung (der Ausdruck liefert 176 Dateien, exakt die CI-Zahl, und fängt eine ungestagte Datei mit): Commit `33f5733` |
| **Team-Tauglichkeit des Korpus** — sechs Stellen, an denen eine Regel funktioniert, *weil* genau ein Mensch am Repo schreibt. Ordnendes Prinzip sind **drei Achsen, für die es nur ein Vokabular gibt**: *Rolle* ist voll ausgearbeitet, *Person* kommt nur als „eine Person, mehrere Rollen" vor — die Gegenrichtung **eine Rolle, mehrere Personen** nirgends —, und *Zuweisung* („wer hält diese Instanz") hat kein Wort. Darunter liegt eine Vorbedingung: Der Korpus behandelt das Repo als *einen* beobachtbaren Zustand (*„der Zustand ist das Verzeichnis"*), mit Pull Requests sind es n + 1 — `ls in-progress/` ist zweigelokal, der Sichtungs-Schritt liest veraltet, im Register mergen zwei Hälften derselben Beobachtung klaglos nebeneinander. Die Risiko-Regel dazu ist am realen Konsumenten belegt: **Ganz-Wert × nebenläufige Schreiber** — die Index-READMEs sind mit 2 Änderungen in 764 Commits die sichersten Dateien im Baum (sie führen bewusst keinen Stand), gefährlich sind nur `roadmap.md` (*Aktuelle Welle* + Ordnung, 127) und `observations.md` (Zähler, jede Closure); `spec/lastenheft.md` hat einen Ganz-Wert, aber nur einen externen sequentiellen Schreiber und ist deshalb unkritisch. Dazu: *Aktuelle Welle* ist gar keine Eigenschaft des Repos, sondern eine Aussage über die Aufmerksamkeit **einer** Person — bei mehreren gibt es keine oder mehrere, und der leere Fall ist schon bei einem Schreiber belegt; der Konflikt-Pfad behandelt eine Rolle als Orakel. Vollständig samt Negativbefunden und drei begründet gestrichenen Einträgen in [`team.md`](team.md); die Einträge tragen dort stabile Kennungen `TB-<NNN>`, gültig nur in jener Datei | **ein Repo mit ≥ 3 Schreibern adoptiert die Baseline und meldet einen der beschriebenen Ausfälle** | offen — SOLL-Stufen *entworfen* (Wellen 76–79) und *geprobt* (Welle 80, `lab/team-sim`) erreicht; der Trigger gilt der Stufe *belegt*. Verhaltens-Befunde 0× beobachtet. Beleglage, Befund-Register (`TB-`/`TA-`, darunter die team-unabhängig nachgemessenen Punkte Eigentums-Achse, `MR`-Vergabe-Klasse, Zählraum) und Stand je Eintrag: [`docs/team.md`](team.md) |
| **Bootstrap-Übung im Lab fehlt** — `lab/example/exercises/` trägt Übungen zu anderen Modulen, aber keine zum Bootstrap ([Modul 2](../kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md) verweist darauf) | **ein Leser meldet, dass die Modul-2-Übungen ohne dediziertes Lab nicht ausführbar sind** | offen seit Welle 52 |
| **`kurs/en`** — englische Fassung | *nicht gesetzt* | Skelett vorhanden — `kurs/en/README.md` trägt nur einen Platzhalter-Text, keinen Kursinhalt; im [README](../README.md) als „derzeit *nicht* Bestandteil des Kurses" deklariert |
| **Link-Trümmer-Prüfung bei `d-check` anregen** — `](ziel)rest)` entsteht bei verunglückten Text-Ersetzungen; der Link löst auf, der Müll dahinter steht sichtbar im Fließtext. Generisch, gehört **nicht** in den Rest-Sensor `docs-check.js` (der prüft nur repo-spezifische Semantik) Die Prüfung braucht Markdown-Kontext, keine Zeilen-Regex — gemessen: die naive Regex kann nicht auslösen (reale Trümmer beginnen mit `../`), die korrigierte meldet `[X](y.md)-Suffix)` falsch | **ein zweiter Trümmer-Fund in diesem Repo** oder ein `d-check`-Release, der Change Requests annimmt | offen seit Welle 54; CR formuliert und an das d-check-Projekt gegeben |
| **Repo-eigener Harness ausbauen** — `harness/conventions.md` mit `MR-000` (Baseline) und einem `MR` für die Pfad-Abweichung oben | **eine zweite Adaption gegenüber dem gelehrten Aufbau — oder eine zweite repo-lokale Strukturregel** | zurückgestellt — heute genügt der Kommentar in dieser Datei; die erste ausdrücklich als solche geführte Strukturregel ist die [Schnittregel des Regelwerk-Extrakts](regelwerk-extrakt.md) |
| **Technik-Historie: `Verweis`-Spalte für Aufwärts-Bezüge (`LH-*`) behalten?** Restfrage des in Welle 72 geschlossenen Fadens *Provenance in der Historie* — die Decken-Regel ([`referenz-richtung.md` §Referenz-Richtung](../kurs/de/grundlagen/referenz-richtung.md#referenz-richtung-sdp-wer-darf-wen-referenzieren), Regel 5) verbietet Abwärts-Zeiger in jeder Sektion, auch der Historie; über Aufwärts-Zeiger dort sagt sie nichts. Entweder die Spalte bleibt und die Regel sagt das ausdrücklich, oder sie fällt | *nicht gesetzt* — Entscheidung, kein Ereignis | offen seit Welle 72 (Commit `662b777`) |
| **`architecture.template.md` nennt die Spezifikation nicht.** Die Matrix führt `Sicht → Technik` als *Normativ: visualisiert*, und `lab/example/spec/architecture.md` §5 zeigt `E001`/`E003`/`E099` samt `event=`-Feldern aus `spezifikation.md` §4. Die Vorlage bietet dafür keinen Zeiger | **eingetreten** — die Kante ist seit Welle 61 in der Matrix benannt | offen, aber entscheidungsfrei: Die Sektionspaare stehen fest (§5 Fehlermodelle ← §4 Fehler-Codes; §3 Externe Abhängigkeiten ← §6 Externe Verträge) |

## Meilensteine

Form nach Modul 6 (Tabelle mit `Status`); Releases stehen hier (Abweichung,
oben deklariert). Erreichte Meilensteine bleiben mit ihrem Status in der
Tabelle; **Inhalt** je Welle im [`CHANGELOG.md`](../CHANGELOG.md), **Beleg**
Tag und Workflow-Lauf. Der Trigger jedes Release-Meilensteins ist derselbe:
Tag gesetzt, Workflow `templates-release` grün, Asset `lab-regelwerk.zip`
gebaut, `releases/latest` zeigt darauf, Stichprobe im veröffentlichten Bundle.
Releases vor `v3.7.0` liefen, bevor diese Datei Meilensteine führte — Tags und
CHANGELOG sind ihr Register.

| Meilenstein | Welle(n) | Trigger | Status |
|---|---|---|---|
| `v5.15.0` | 104–107 | erfüllt | erreicht 2026-08-31 (Lauf 33416460586) |
| `v5.14.0` | 103 | erfüllt | erreicht 2026-08-30 (Lauf 33326601046) |
| `v5.13.1` | 102 | erfüllt | erreicht 2026-08-30 (Lauf 33323242463) |
| `v5.13.0` | 99–101 | erfüllt | erreicht 2026-08-30 (Lauf 33321654491) |
| `v5.12.0` | 95–98 | erfüllt | erreicht 2026-08-26 (Lauf 32925979249) |
| `v5.11.0` | 91–94 | erfüllt | erreicht 2026-08-23 (Lauf 32625972394) |
| `v5.10.0` | 87–90 | erfüllt | erreicht 2026-08-23 (Lauf 32620668564) |
| `v5.9.0` | 84–86 | erfüllt | erreicht 2026-08-22 (Lauf 32559619366) |
| `v5.8.0` | 82–83 | erfüllt | erreicht 2026-08-22 (Lauf 32555176044) |
| `v5.7.0` | 81 | erfüllt | erreicht 2026-08-21 (Lauf 32513903731) |
| `v5.6.0` | 80 | erfüllt | erreicht 2026-08-16 (Lauf 31963368452) |
| `v5.5.0` | 75–79 | erfüllt | erreicht 2026-08-16 (Lauf 31960508689) |
| `v5.4.0` | 73 | erfüllt | erreicht 2026-08-15 (Lauf 31892626291) |
| `v5.3.1` | 72 | erfüllt | erreicht 2026-08-09 (Lauf 31320527437) |
| `v5.3.0` | 71 | erfüllt | erreicht 2026-08-08 (Lauf 31273096617) |
| `v5.2.0` | 68–70 | erfüllt | erreicht 2026-08-08 (Lauf 31261878445) |
| `v3.8.0` | 48 | erfüllt | erreicht 2026-07-27 |
| `v3.7.0` / `v3.7.1` | 39–45 / 46–47 | erfüllt | erreicht 2026-07-26 |

## Abgeschlossene Wellen

*Derivativ* — die Closure-Historie steht vollständig in
[`CHANGELOG.md`](../CHANGELOG.md) und wird hier nicht dupliziert. Diese Datei
trägt nur den Vorwärts-Blick.

## Historische Trigger-Verschiebungen

Nur **Umplanungen**: ein Trigger wird verschoben, präzisiert oder ersetzt, ein
Faden umgehängt ([Modul 6, Schritt 6](../kurs/de/02-planung/modul-06-roadmap.md#worked-example-einen-datumswunsch-in-eine-trigger-welle-übersetzen):
das Drift-Log ist Bewegungs-Anhang, nicht Closure-Log). Faden-Schließungen
stehen im CHANGELOG der Welle, die sie schließt; erreichte Meilensteine oben
unter §Meilensteine.

| Datum | Faden | Änderung | Grund |
|---|---|---|---|
| 2026-08-16 | CR-Kandidat *planning-Default `## Offene Wellen`* | verworfen ohne CR, ersetzt durch den Faden *`waves.dir` und das Offene-Wellen-Modell* (geschlossen in Welle 82) | das d-check-Handbuch führt `heading`/`marker` als vorgesehenen Weg für abweichende Layouts (Commit `1ae910b`) |
| 2026-08-16 | *Repo-eigener Harness ausbauen* | Trigger um die zweite Klasse erweitert: **auch** eine zweite repo-lokale Strukturregel | `harness/conventions.md` trägt nach Modul 2 beide Klassen; Strukturregeln sammelten sich sonst unbemerkt im README (Commit `69bb6d0`) |
| 2026-08-10 | *`check_closure_notes.py` retiren* | Trigger präzisiert: „ein d-check-Release, das die zwei Lücken schließt" → die CRs sind angenommen (`slice-097`/`slice-098`) | die Bedingung war von „irgendwann" auf zwei konkrete Lieferungen zu ziehen (Commit `4a6da78`; Faden geschlossen in Welle 73) |
| 2026-07-27 | *Mechanische Wächter gegen Doku-Drift* | ersetzt durch den engeren Faden *Link-Trümmer-Prüfung bei `d-check` anregen* | die versprochenen Prüfungen sind als nicht baubar gemessen — die Fehlerklassen sind semantisch, nur die Trümmer sind ein Match (CHANGELOG Welle 54) |
| 2026-07-27 | *Bootstrap-Übung im Lab fehlt* | aus *Lab Phase C* herausgelöst, eigener Faden | Phase C war geliefert, die Übung hing dort nur mit (Commit `3285950`) |
