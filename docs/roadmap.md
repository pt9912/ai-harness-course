# Roadmap — offene Fäden des Kurs-Repos

**Stand:** 2026-07-31.

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
| **`check_closure_notes.py` retiren — vertagt, gemessen** — d-check v0.52.0 bringt Closure-Notiz-Struktur als Fähigkeit von `planning` (`closure.dir`), also denselben Zweck wie das letzte handgeschriebene Prüfskript des Beispiels | **ein d-check-Release, das die zwei Lücken schließt** — oder eine Entscheidung, sie im Beispiel aufzugeben | offen seit Welle 72. Gegen den Bestand gemessen, je Verstoß beide Sensoren nebeneinander: Sektion entfernt, Notiz auf einen Satz, Floskel — beide rot. **Zwei Klassen fängt nur das Skript:** ein unausgefüllter Template-Platzhalter (`<ergebnis>`; die Regex des Skripts ist eigens gegen Falsch-Positive wie `p95 < 1 s` gebaut) und jede Nicht-`slice-*`-Datei in `done/` (die beiden `welle-*`). Anders als bei `check_references.py` ist das Modul **keine** Obermenge — retiren hieße Deckung verlieren. CR-Kandidaten an d-check: `closure.glob` neben `slice-glob`, und eine Platzhalter-Prüfung |
| **Bootstrap-Übung im Lab fehlt** — `lab/example/exercises/` trägt Übungen zu anderen Modulen, aber keine zum Bootstrap ([Modul 2](../kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md) verweist darauf) | **ein Leser meldet, dass die Modul-2-Übungen ohne dediziertes Lab nicht ausführbar sind** | offen seit Welle 52; vorher fälschlich unter *Lab Phase C* geführt, die inzwischen geliefert ist |
| **`kurs/en`** — englische Fassung | *nicht gesetzt* | Skelett vorhanden — `kurs/en/README.md` trägt nur einen Platzhalter-Text, keinen Kursinhalt; im [README](../README.md) als „derzeit *nicht* Bestandteil des Kurses" deklariert |
| **Link-Trümmer-Prüfung bei `d-check` anregen** — `](ziel)rest)` entsteht bei verunglückten Text-Ersetzungen; der Link löst auf, der Müll dahinter steht sichtbar im Fließtext. Generisch, gehört **nicht** in den Rest-Sensor `docs-check.js` (der prüft nur repo-spezifische Semantik) | **ein zweiter Trümmer-Fund in diesem Repo** oder ein `d-check`-Release, der Change Requests annimmt | offen seit Welle 54; CR formuliert und an das d-check-Projekt gegeben. Grenze gemessen: Die naive Regex kann nicht auslösen (reale Trümmer beginnen mit `../`, `.` war ausgeschlossen), die korrigierte meldet `[X](y.md)-Suffix)` falsch — die Prüfung braucht Markdown-Kontext, keine Zeilen-Regex |
| **Repo-eigener Harness ausbauen** — `harness/conventions.md` mit `MR-000` (Baseline) und einem `MR` für die Pfad-Abweichung oben | **die Roadmap braucht eine zweite Adaption gegenüber dem gelehrten Aufbau** — dann trägt die Prosa oben zu viel und gehört in einen Adaptions-Block | bewusst zurückgestellt: heute genügt der Kommentar in dieser Datei |
| **Provenance in der Historie — Beispiel und Gate ziehen nach.** Entschieden: Die Decken-Regel gilt **auch in der Historie**, für alle drei Spec-Straten gleich — kein Spec-Dokument nennt eine ADR oder einen Slice. Begründung ist nicht der Rang, sondern die *Unreparierbarkeit*: Eine Historie-Zeile wird nicht rückwirkend geändert, ein dort genannter ADR-Verweis rottet mit der Supersedure und kein Gate kann es melden. Norm-Texte nachgezogen ([`referenz-richtung.md` §Referenz-Richtung](../kurs/de/grundlagen/referenz-richtung.md#referenz-richtung-sdp-wer-darf-wen-referenzieren) Regel 5 + Gate-Absatz, [Modul 3](../kurs/de/01-spec-und-architektur/modul-03-spec.md), beide Spec-Templates) | **eingetreten** — Norm steht, Konsument zieht nach | **geschlossen in Welle 72**: Die Spec-Straten des Beispiels tragen keinen `ADR-`/`slice-`-Verweis mehr, und das Gate deckt die Historie jetzt mit — `matrix` nimmt bewusst nur `Geschichte` aus, nicht `Historie` (`lab/example/.d-check.yml`). Offene Teilfrage bleibt: ob die Technik-Historie eine `Verweis`-Spalte für **Aufwärts**-Bezüge (`LH-*`) behält — die Regel verbietet nur Abwärts |
| **`architecture.template.md` nennt die Spezifikation nicht.** Die Matrix führt `Sicht → Technik` als *Normativ: visualisiert*, und `lab/example/spec/architecture.md` §5 zeigt `E001`/`E003`/`E099` samt `event=`-Feldern aus `spezifikation.md` §4. Die Vorlage bietet dafür keinen Zeiger | **eingetreten** — die Kante ist seit Welle 61 in der Matrix benannt | offen, aber entscheidungsfrei: Die Sektionspaare stehen fest (§5 Fehlermodelle ← §4 Fehler-Codes; §3 Externe Abhängigkeiten ← §6 Externe Verträge) |

## Meilensteine

*Keiner offen.* Der letzte war `v5.3.1` (erreicht 2026-08-09) — Beleg in der
Drift-Tabelle unten, Inhalt im [`CHANGELOG.md`](../CHANGELOG.md).

## Abgeschlossene Wellen

*Derivativ* — die Closure-Historie steht vollständig in
[`CHANGELOG.md`](../CHANGELOG.md) und wird hier nicht dupliziert. Diese Datei
trägt nur den Vorwärts-Blick.

## Historische Trigger-Verschiebungen

Noch keine. Wird ein Trigger oben verschoben oder ersetzt, bekommt er hier eine
Zeile mit Datum, Änderung und Grund — sonst ist die Verschiebung still.

| Datum | Faden | Änderung | Grund |
|---|---|---|---|
| 2026-08-09 | Meilenstein **v5.3.1** | erreicht und eingetragen | Welle 72 (a-check als zweiter Layering-Sensor, fünf d-check-Module, ein retirtes Prüfskript), Inhalt im [`CHANGELOG.md`](../CHANGELOG.md). Belege: Tag `v5.3.1`, Workflow `templates-release` grün (Lauf 31320527437, 12 s), `checks` auf `main` grün (Lauf 31320526311) **inklusive des neuen Jobs `adr-immutability`** — dessen erster echter CI-Lauf, Asset `lab-regelwerk.zip` (186.461 Bytes, 51 Dateien), `releases/latest` zeigt auf `v5.3.1`. Stichprobe im **veröffentlichten** Bundle (nicht im lokalen Build): `regelwerk/README.md` steht auf Kurs-Welle 72, `regelwerk/modul-08-agentenrollen.md` trägt den quelltreu wiederhergestellten Satz samt dem Kriterium der Template-Zeile, und `check-references` kommt in **keiner** der 51 Dateien mehr vor. PATCH gewählt: Am ausgelieferten Artefakt zwei Korrekturen ohne Regel-Änderung — der Name eines retirten Targets und die Quelltreue in Modul 8; der Umfang der Welle liegt in `lab/example` und reist im Bundle nicht mit |
| 2026-08-08 | Meilenstein **v5.3.0** | erreicht und eingetragen | Welle 71 (Kommentar-Bestimmung), Inhalt im [`CHANGELOG.md`](../CHANGELOG.md). Belege: Tag `v5.3.0`, Workflow `templates-release` grün (Lauf 31273096617), Asset `lab-regelwerk.zip` (186.442 Bytes, 51 Dateien), `releases/latest` zeigt auf `v5.3.0`; Stichprobe im veröffentlichten Bundle: `regelwerk/grundlagen-harness-dateien.md` trägt §Was ein Kommentar trägt, `templates/AGENTS.template.md` die `3.7`. **MINOR**, weil rein additiv |
| 2026-08-08 | Meilenstein **v5.2.0** | erreicht und eingetragen | Drei Wellen seit `v5.1.0`: 68 (`SPEC-*`/`ARC-*` als Baseline-ID-Schema), 69 (siebte Freshness-Audit-Eigenschaft — Stichprobe gegen den Bestand), 70 (Reconciliation-Register). Belege: Tag `v5.2.0` gesetzt und gepusht, Workflow `templates-release` grün (Lauf 31261878445, 13s), Asset `lab-regelwerk.zip` (183.441 Bytes, 51 Dateien) gebaut, `releases/latest` zeigt auf `v5.2.0`; Stichprobe im veröffentlichten Bundle: `templates/docs/plan/planning/reconciliation.template.md` liegt bei und `regelwerk/modul-02-harness-bootstrap.md` trägt §Das Reconciliation-Register. **MINOR** gewählt: Alle drei Wellen sind additiv — ein Template und ein Regelwerks-Abschnitt kommen hinzu, das ID-Schema wird erweitert; nichts entfernt, kein Layout gebrochen. Der Wegfall von `CO-DS-*` ist eine Notation im Fließtext, kein Asset |
| 2026-07-27 | Faden **Discovery-/Kandidaten-Register** | geschlossen — nach dem Neuschnitt (Welle 57) ohne Beleg, **Wiedereintritt bleibt möglich** | Der Faden versprach einen eigenen Kanal für Nicht-Slice-Register. Beleglage nach dem Welle-33-Fix (`done/` als sanktionierte Heimat abgeschlossener Nicht-Slice-Records): **0** Beobachtungen des Drucks, **1** Messung mit negativem Ergebnis (`ai-harness-init`, Welle 56). Die Ursprungs-Beobachtung (`m-trace`) entstand *vor* dem Fix und belegt nicht, dass er nicht reicht; ob er dort gereicht hat, ist von hier nicht messbar. Damit ist nichts *offen*: Es gibt eine Lösung, und sie hält, soweit gemessen. Nach der Zählregel des Kurses wäre das eine **Beobachtung unter Schwelle** (1×, Schwelle 3×) — die gehört nicht in eine Liste, die Handlungen verspricht; dieses Repo hat den Kanal dafür nur nicht, weil es keinen Wellen-Betrieb führt. **Wiedereintritts-Bedingung:** Zeigt ein Repo den Druck *nach* Welle 33 — Nicht-Slice-Register werden mangels Ort in ein Lifecycle-Verzeichnis gezwängt, obwohl `done/` sanktioniert ist —, wird der Faden als frische Beobachtung neu eröffnet, nicht als Fortsetzung dieser |
| 2026-07-27 | Faden **Fork-Grenze ohne Konsument** | geschlossen — Kriterium war zu scharf, echte Lücke war der fehlende Eingang | Der Faden verlangte „Feld, Gate, Übung oder Rubrik-Zeile". Gemessen: Die Regel, auf die er sich beruft — *Jedes Artefakt hat einen Konsumenten* — speist selbst 0 Übungen, 0 Rubrik-Zeilen, 0 Gates und bestünde ihre eigene Probe nicht. Sie greift ausdrücklich *zur Entwurfszeit*, ein Mensch ist ein zulässiger Konsument. Der reale Unterschied war enger: Auf die Konsumenten-Regel verweisen zwei Templates, auf die Fork-Grenze verwies nichts. Behoben durch einen Eingang im Adaptions-Block der `conventions`-Vorlage — dort sitzt der Leser — und dadurch, dass die Grenze ihren Leser jetzt selbst benennt, wie die Regel es verlangt |
| 2026-07-27 | Faden **Mechanische Wächter gegen Doku-Drift** | geschlossen — als nicht baubar gemessen, ersetzt durch einen engeren Faden | Der Faden versprach zwei Prüfungen, die „`make check` heute nicht hat". Gegen das reale Repo geprüft: (a) §-Prosa-Zeiger meldet 18 von 31 — deutsche §-Verweise sind Kurzformen der Überschrift, exakter Vergleich ist Rauschen, Präfix-Vergleich lässt die Zielfälle durch. (b) Aufzählungs-Gleichheit scheitert daran, dass das Zahlwort oft Attribut ist („Regeln für die *sechs* Schritte:" + 4 Regeln). Eine dritte Idee — gleiches Substantiv, andere Zahl — meldet 16 legitime Fälle (Modul 6 hat *drei* Eröffnungs- und *fünf* Closure-Schritte). Die Fehlerklassen sind **semantisch**, nicht syntaktisch: „ein Pointer behauptet etwas über den Zielinhalt" ist keine Regex-Frage. Beim Prototyp der einzigen generischen Prüfung (Link-Trümmer) fiel zusätzlich auf, dass sie gar nicht auslösen konnte — der Break-Test hat ein Halluzinations-Gate verhindert, das ich sonst als Erfolg gemeldet hätte |
| 2026-07-27 | Faden **Lab Phase C** | geschlossen — geliefert, die Doku hatte es nicht nachgezogen | `make gates` über alle sechs Sprachen: **6/6 grün** mit echten Toolchains und Coverage-Schwellen (go 77,8 % · python 76,99 % bei Schwelle 70 % · kotlin `koverVerify` · java `mvn verify` · csharp `dotnet test` · cpp 1/1). `kurs/de/grundlagen/README.md` nannte Phase C längst „ausgeliefert", sechs andere Stellen behaupteten das Gegenteil — Modul 13 zusätzlich mit falscher Zahl („fünf"). Alle sechs korrigiert. Der Rest — die fehlende Bootstrap-Übung — ist als eigener Faden neu geschnitten, weil er nichts mit Sprach-Skeletten zu tun hat |
| 2026-07-27 | Faden **Spec-Strata-Adaptionsrichtung widersprüchlich** | geschlossen — als Defekt behoben, nicht als Setzung entschieden | Der Faden nannte die Richtung „eine Setzung, keine Redaktion". Falsch: `konventionen.md` §Spec-Straten entscheidet sie längst — „nur Vertrag und Sicht sind obligatorisch; das Technik-Stratum ist optional", also Baseline = zwei Straten. `conventions.template.md` und `lab/example` waren korrekt, `harness/README.template.md` invertiert: Es schickte Zwei-Straten-Repos zu `MR-001`, das den Drei-Straten-Fall dokumentiert. Der Zeiger widersprach seinem Ziel |
| 2026-07-27 | Faden **Formcheck ist Prosa statt Gate** | geschlossen — Prämisse durch Messung widerlegt | Der Trigger lautete „ein Adopter nimmt die vendored Baseline in seinen `d-check`-Prüfumfang auf". Messung an einer Fixture: Der ausgelieferte `lab/templates/.d-check.yml` hat `roots: ["."]` und ignoriert `.harness/` nicht — d-check scannt Punktverzeichnisse, der Prüfumfang war also längst gegeben. Ein toter `Geltungsbereich`-Anker meldet sich als `anchor-missing`. Modul 2 verweist jetzt aufs Gate, statt den Schritt von Hand zu verlangen |
| 2026-07-27 | Faden **Vorwärts-Blick für wellenlose Arbeit** | geschlossen — als Fehlannahme aufgelöst, nicht gelöst | Der Faden behauptete, wellenlose Arbeit habe keinen Vorwärts-Blick. Falsch: `next/` heißt *priorisiert/eingeplant* (Modul 5), und der Übergang `open→next` ist die Priorisierungs-Entscheidung — seit Welle 48 wellenneutral formuliert. Der Fadentext nannte zudem das falsche Verzeichnis (`open/` statt `next/`). Tragender Punkt: Eine Reihenfolge *einzelner Slices* kennt der Harness überhaupt nicht — die Roadmap ordnet Wellen, die Spalte *Wichtigste Slices* nennt Inhalt statt Rang, `slice.template.md` hat kein Prioritätsfeld. Wellenlose Arbeit steht damit nicht schlechter da als wellengebundene. Modul 6 beantwortet die Leserfrage jetzt an Ort und Stelle |
| 2026-07-27 | Meilenstein **v3.8.0** | erreicht und aus der Tabelle entfernt | Alle vier Teilbedingungen belegt: Welle 48 registriert und committet (`921e84f`), Tag `v3.8.0` gesetzt, Workflow `templates-release` grün, Asset `lab-regelwerk.zip` (137.532 Bytes, 55 Dateien) gebaut, `releases/latest` zeigt auf `v3.8.0`; Stichprobe im veröffentlichten Bundle: `regelwerk/modul-06-roadmap.md` trägt §Wann Arbeit eine Welle braucht. **MINOR** gewählt, weil Welle 48 eine normative Regel und einen Regelwerks-Abschnitt *hinzufügt*, ohne etwas zu entfernen oder ein Layout zu brechen — die MAJOR-Politik des Repos reserviert MAJOR für Asset-Entfernung und Layout-Bruch |
| 2026-07-27 | Meilenstein **v3.7.0** | erreicht und aus der Tabelle entfernt, ersetzt durch **v3.8.0** | `v3.7.0` wurde am 2026-07-26 getaggt (Wellen 39–45 plus Review-Befunde), `v3.7.1` am selben Tag (Wellen 46–47) — die Zeile stand danach noch auf „ausstehend" und war damit zweimal überholt. Erreichte Meilensteine wandern nicht in ein Log hier: Diese Datei trägt nur den Vorwärts-Blick, die Historie steht in `CHANGELOG.md` und in den Tags |
