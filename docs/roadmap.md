# Roadmap — offene Fäden des Kurs-Repos

**Stand:** 2026-07-27.

Dieses Repo führt einen **bewusst reduzierten Harness**: `CHANGELOG.md` ist das
Wellen-Register (Closure-Log), `make check` sind die Gates, d-check ist per
Digest gepinnt. Kein Slice-Lifecycle, keine ADRs, keine Spec — für ein
Doku-Repo wäre das Zeremonie ohne Substanz.

Diese Datei ist das **Gegenstück zum CHANGELOG**: dort steht, was geschlossen
wurde, hier, was offen ist und *woran man erkennt, dass es dran ist*. Ohne sie
liegen offene Fäden als Fließtext in alten Wellen-Einträgen und werden nie
wieder gelesen.

> **Pfad-Abweichung, deklariert.** Der Kurs lehrt
> `docs/plan/planning/in-progress/roadmap.md`
> ([`konventionen.md` §Verzeichniskonvention](../kurs/de/grundlagen/konventionen.md#verzeichniskonvention)).
> Dieses Repo führt die Roadmap **flach** unter `docs/roadmap.md`, weil der
> gelehrte Pfad die vier Lifecycle-Verzeichnisse voraussetzt — und die ohne
> Slice-Betrieb anzulegen wäre leere Form: Verzeichnisse, die keinen Betrieb
> tragen, behaupten Reife, die es nicht gibt. Das ist *analog* zur Warnung vor
> „Struktur ohne Substanz" in
> [`konventionen.md` §Was ist eine Sub-Area?](../kurs/de/grundlagen/konventionen.md#was-ist-eine-sub-area)
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
| **Bootstrap-Übung im Lab fehlt** — `lab/example/exercises/` trägt Übungen zu anderen Modulen, aber keine zum Bootstrap ([Modul 2](../kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md) verweist darauf) | **ein Leser meldet, dass die Modul-2-Übungen ohne dediziertes Lab nicht ausführbar sind** | offen seit Welle 52; vorher fälschlich unter *Lab Phase C* geführt, die inzwischen geliefert ist |
| **`kurs/en`** — englische Fassung | *nicht gesetzt* | Skelett vorhanden — `kurs/en/README.md` trägt nur einen Platzhalter-Text, keinen Kursinhalt; im [README](../README.md) als „derzeit *nicht* Bestandteil des Kurses" deklariert |
| **Link-Trümmer-Prüfung bei `d-check` anregen** — `](ziel)rest)` entsteht bei verunglückten Text-Ersetzungen; der Link löst auf, der Müll dahinter steht sichtbar im Fließtext. Generisch, gehört **nicht** in den Rest-Sensor `docs-check.js` (der prüft nur repo-spezifische Semantik) | **ein zweiter Trümmer-Fund in diesem Repo** oder ein `d-check`-Release, der Change Requests annimmt | offen seit Welle 54; CR formuliert und an das d-check-Projekt gegeben. Grenze gemessen: Die naive Regex kann nicht auslösen (reale Trümmer beginnen mit `../`, `.` war ausgeschlossen), die korrigierte meldet `[X](y.md)-Suffix)` falsch — die Prüfung braucht Markdown-Kontext, keine Zeilen-Regex |
| **Repo-eigener Harness ausbauen** — `harness/conventions.md` mit `MR-000` (Baseline) und einem `MR` für die Pfad-Abweichung oben | **die Roadmap braucht eine zweite Adaption gegenüber dem gelehrten Aufbau** — dann trägt die Prosa oben zu viel und gehört in einen Adaptions-Block | bewusst zurückgestellt: heute genügt der Kommentar in dieser Datei |

## Meilensteine

*Keiner offen.* Der letzte war `v3.8.0` (erreicht 2026-07-27) — Beleg in der
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
| 2026-07-27 | Faden **Discovery-/Kandidaten-Register** | geschlossen — nach dem Neuschnitt (Welle 57) ohne Beleg, **Wiedereintritt bleibt möglich** | Der Faden versprach einen eigenen Kanal für Nicht-Slice-Register. Beleglage nach dem Welle-33-Fix (`done/` als sanktionierte Heimat abgeschlossener Nicht-Slice-Records): **0** Beobachtungen des Drucks, **1** Messung mit negativem Ergebnis (`ai-harness-init`, Welle 56). Die Ursprungs-Beobachtung (`m-trace`) entstand *vor* dem Fix und belegt nicht, dass er nicht reicht; ob er dort gereicht hat, ist von hier nicht messbar. Damit ist nichts *offen*: Es gibt eine Lösung, und sie hält, soweit gemessen. Nach der Zählregel des Kurses wäre das eine **Beobachtung unter Schwelle** (1×, Schwelle 3×) — die gehört nicht in eine Liste, die Handlungen verspricht; dieses Repo hat den Kanal dafür nur nicht, weil es keinen Wellen-Betrieb führt. **Wiedereintritts-Bedingung:** Zeigt ein Repo den Druck *nach* Welle 33 — Nicht-Slice-Register werden mangels Ort in ein Lifecycle-Verzeichnis gezwängt, obwohl `done/` sanktioniert ist —, wird der Faden als frische Beobachtung neu eröffnet, nicht als Fortsetzung dieser |
| 2026-07-27 | Faden **Fork-Grenze ohne Konsument** | geschlossen — Kriterium war zu scharf, echte Lücke war der fehlende Eingang | Der Faden verlangte „Feld, Gate, Übung oder Rubrik-Zeile". Gemessen: Die Regel, auf die er sich beruft — *Jedes Artefakt hat einen Konsumenten* — speist selbst 0 Übungen, 0 Rubrik-Zeilen, 0 Gates und bestünde ihre eigene Probe nicht. Sie greift ausdrücklich *zur Entwurfszeit*, ein Mensch ist ein zulässiger Konsument. Der reale Unterschied war enger: Auf die Konsumenten-Regel verweisen zwei Templates, auf die Fork-Grenze verwies nichts. Behoben durch einen Eingang im Adaptions-Block der `conventions`-Vorlage — dort sitzt der Leser — und dadurch, dass die Grenze ihren Leser jetzt selbst benennt, wie die Regel es verlangt |
| 2026-07-27 | Faden **Mechanische Wächter gegen Doku-Drift** | geschlossen — als nicht baubar gemessen, ersetzt durch einen engeren Faden | Der Faden versprach zwei Prüfungen, die „`make check` heute nicht hat". Gegen das reale Repo geprüft: (a) §-Prosa-Zeiger meldet 18 von 31 — deutsche §-Verweise sind Kurzformen der Überschrift, exakter Vergleich ist Rauschen, Präfix-Vergleich lässt die Zielfälle durch. (b) Aufzählungs-Gleichheit scheitert daran, dass das Zahlwort oft Attribut ist („Regeln für die *sechs* Schritte:" + 4 Regeln). Eine dritte Idee — gleiches Substantiv, andere Zahl — meldet 16 legitime Fälle (Modul 6 hat *drei* Eröffnungs- und *fünf* Closure-Schritte). Die Fehlerklassen sind **semantisch**, nicht syntaktisch: „ein Pointer behauptet etwas über den Zielinhalt" ist keine Regex-Frage. Beim Prototyp der einzigen generischen Prüfung (Link-Trümmer) fiel zusätzlich auf, dass sie gar nicht auslösen konnte — der Break-Test hat ein Halluzinations-Gate verhindert, das ich sonst als Erfolg gemeldet hätte |
| 2026-07-27 | Faden **Lab Phase C** | geschlossen — geliefert, die Doku hatte es nicht nachgezogen | `make gates` über alle sechs Sprachen: **6/6 grün** mit echten Toolchains und Coverage-Schwellen (go 77,8 % · python 76,99 % bei Schwelle 70 % · kotlin `koverVerify` · java `mvn verify` · csharp `dotnet test` · cpp 1/1). `kurs/de/grundlagen/README.md` nannte Phase C längst „ausgeliefert", sechs andere Stellen behaupteten das Gegenteil — Modul 13 zusätzlich mit falscher Zahl („fünf"). Alle sechs korrigiert. Der Rest — die fehlende Bootstrap-Übung — ist als eigener Faden neu geschnitten, weil er nichts mit Sprach-Skeletten zu tun hat |
| 2026-07-27 | Faden **Spec-Strata-Adaptionsrichtung widersprüchlich** | geschlossen — als Defekt behoben, nicht als Setzung entschieden | Der Faden nannte die Richtung „eine Setzung, keine Redaktion". Falsch: `konventionen.md` §Spec-Straten entscheidet sie längst — „nur Vertrag und Sicht sind obligatorisch; das Technik-Stratum ist optional", also Baseline = zwei Straten. `conventions.template.md` und `lab/example` waren korrekt, `harness/README.template.md` invertiert: Es schickte Zwei-Straten-Repos zu `MR-001`, das den Drei-Straten-Fall dokumentiert. Der Zeiger widersprach seinem Ziel |
| 2026-07-27 | Faden **Formcheck ist Prosa statt Gate** | geschlossen — Prämisse durch Messung widerlegt | Der Trigger lautete „ein Adopter nimmt die vendored Baseline in seinen `d-check`-Prüfumfang auf". Messung an einer Fixture: Der ausgelieferte `lab/templates/.d-check.yml` hat `roots: ["."]` und ignoriert `.harness/` nicht — d-check scannt Punktverzeichnisse, der Prüfumfang war also längst gegeben. Ein toter `Geltungsbereich`-Anker meldet sich als `anchor-missing`. Modul 2 verweist jetzt aufs Gate, statt den Schritt von Hand zu verlangen |
| 2026-07-27 | Faden **Vorwärts-Blick für wellenlose Arbeit** | geschlossen — als Fehlannahme aufgelöst, nicht gelöst | Der Faden behauptete, wellenlose Arbeit habe keinen Vorwärts-Blick. Falsch: `next/` heißt *priorisiert/eingeplant* (Modul 5), und der Übergang `open→next` ist die Priorisierungs-Entscheidung — seit Welle 48 wellenneutral formuliert. Der Fadentext nannte zudem das falsche Verzeichnis (`open/` statt `next/`). Tragender Punkt: Eine Reihenfolge *einzelner Slices* kennt der Harness überhaupt nicht — die Roadmap ordnet Wellen, die Spalte *Wichtigste Slices* nennt Inhalt statt Rang, `slice.template.md` hat kein Prioritätsfeld. Wellenlose Arbeit steht damit nicht schlechter da als wellengebundene. Modul 6 beantwortet die Leserfrage jetzt an Ort und Stelle |
| 2026-07-27 | Meilenstein **v3.8.0** | erreicht und aus der Tabelle entfernt | Alle vier Teilbedingungen belegt: Welle 48 registriert und committet (`921e84f`), Tag `v3.8.0` gesetzt, Workflow `templates-release` grün, Asset `lab-regelwerk.zip` (137.532 Bytes, 55 Dateien) gebaut, `releases/latest` zeigt auf `v3.8.0`; Stichprobe im veröffentlichten Bundle: `regelwerk/modul-06-roadmap.md` trägt §Wann Arbeit eine Welle braucht. **MINOR** gewählt, weil Welle 48 eine normative Regel und einen Regelwerks-Abschnitt *hinzufügt*, ohne etwas zu entfernen oder ein Layout zu brechen — die MAJOR-Politik des Repos reserviert MAJOR für Asset-Entfernung und Layout-Bruch |
| 2026-07-27 | Meilenstein **v3.7.0** | erreicht und aus der Tabelle entfernt, ersetzt durch **v3.8.0** | `v3.7.0` wurde am 2026-07-26 getaggt (Wellen 39–45 plus Review-Befunde), `v3.7.1` am selben Tag (Wellen 46–47) — die Zeile stand danach noch auf „ausstehend" und war damit zweimal überholt. Erreichte Meilensteine wandern nicht in ein Log hier: Diese Datei trägt nur den Vorwärts-Blick, die Historie steht in `CHANGELOG.md` und in den Tags |
