# Modul 6 — Roadmap Engineering

> **Aufwand:** ca. 60 Min Lesen · 60 Min Übung. Die konzeptuelle Tiefe liegt in [Modul 5 (Slice-Schnitt)](modul-05-planning-harness.md) und [Modul 7 (Carveouts)](modul-07-carveouts.md); das siebenschrittige Worked Example zum Wellen-Schnitt unten trägt jedoch die Hauptlast dieses Moduls — plane die volle Stunde ein.

## Mini-Glossar für dieses Modul

Vier neue Begriffe — Volldefinitionen in
[`../grundlagen/konventionen.md`](../grundlagen/konventionen.md#kernbegriffe).

| Begriff | Ein-Satz-Definition | Bild im Kopf |
|---|---|---|
| **Welle** | Sequenz von Slices, geschlossen durch einen *Trigger*, nicht durch ein Datum. | eine Welle, die bricht, *wenn* das Wasser hoch genug ist — nicht *wann* die Uhr klingelt. |
| **Meilenstein** | Beobachtbarer Repo-Zustand am Ende einer Welle — nicht ein Datum, sondern ein Beleg. | das Kerbholz am Bergpfad: du bist *hier*, weil du *das* erreicht hast. |
| **Release** | Ein Artefakt, das in eine Umgebung wandert (Staging, Produktion) — kann mehrere Wellen umfassen oder eine. | das Päckchen, das das Lager verlässt, nicht der Pack-Vorgang. |
| **Trigger** | *Beobachtbare* Bedingung, mit der eine Welle closed (vgl. Carveout-Auflösungs-Trigger, Modul 7). | die Glocke, die *anzeigt*, dass es jetzt soweit ist — nicht "wenn wir Zeit haben". |

## Engage

Frage an drei Tech Leads: *"Wann ist Welle 3 fertig?"* — Antwort A:
*"Am 30. Juni."* Antwort B: *"Wenn SL-024 und SL-027 in done/ liegen
und der Replay-Lauf grün ist."* Antwort C: *"Wenn das Team durch ist."*
Welche Antwort ist eine Roadmap? Genau eine. Die anderen sind Wunsch
oder Status.

## Lernziele

Nach diesem Modul kannst du:

* eine Roadmap als Reihenfolge von Wellen mit Triggern *aufbauen* (Erschaffen · prozedural),
* Welle ↔ Meilenstein ↔ Release sauber *unterscheiden*, *erkennen*, wann Arbeit ganz ohne Welle läuft, und für ein Beispiel-Repo den jeweiligen Trigger *zuordnen* (Analysieren · konzeptuell),
* eine Welle, die 30 % über Schätzung liegt, *bewerten* (neu schneiden / neu planen / Carveout) (Bewerten · prozedural+metakognitiv),
* Welle-Abhängigkeiten *modellieren* und Blocker *identifizieren* (Analysieren · konzeptuell).

## Lab-Bezug

* `docs/plan/planning/in-progress/roadmap.md`

## Themen

* Meilensteine
* Releases
* Fortschrittskontrolle
* Abhängigkeiten zwischen Wellen
* Wann Arbeit eine Welle braucht — und wann nicht

## Kernidee

Eine Roadmap ist eine Reihenfolge von Wellen, keine Reihenfolge von
Terminen. Termine sind eine Folge der Wellen, nicht ihr Treiber.

## Typische Fehlvorstellungen

- **"Roadmap ist eine Datumsleiste."** — Datum ist Output, nicht Input. Wer Datumsleisten plant, plant Wunschdenken.
- **"Burndown ist Fortschritt."** — Burndown ist *Tempo*. Fortschritt ist, ob die Welle das verspricht, was sie sollte.
- **"Eine Roadmap ist statisch."** — Eine Roadmap, die nach drei Wellen nicht angepasst wurde, hat den Steering Loop nicht durchlaufen.
- **"Welle = Sprint."** — Ein Sprint endet durch *Datum* (zwei Wochen sind um). Eine Welle endet durch *Closure-Kriterien* (alle ihre Slices in `done/`, Replay-Lauf grün, Closure-Einträge geschrieben). Wer Wellen wie Sprints schneidet, kappt halbfertige Slices am Datum — und produziert genau die Auditierbarkeits-Lücke, die der Harness verhindern soll.
- **"Trigger = Datum."** — Ein Trigger ist eine *beobachtbare Bedingung* ("SL-024 liegt in `done/`", "Replay-Lauf gegen Golden Set grün", "Carveout `CO-007` aufgelöst"). Ein Datum ist kein Trigger, sondern eine Prognose. Wenn das einzige Trigger-Kriterium ein Kalendertag ist, plant die Roadmap nicht — sie hofft.

## Worked Example: einen Datumswunsch in eine Trigger-Welle übersetzen

> **Wenn du Wellen routiniert über Closure-Trigger und Abhängigkeiten definierst und Termine als Folge der Wellen sichtbar machst, springe zu [§Übungen](#übungen).** Worked Example zeigt den Pfad vom Datumswunsch zur Trigger-Welle; ist die Disziplin bereits da, kostet das Mitlesen Last (Expertise-Reversal).

**Ausgangssituation:** Ein Stakeholder sagt: *"Welle 3 muss bis Ende
Juli fertig sein, wir haben einen Audit-Termin."* Eine Datumsleiste ist
verlockend. Sie ist auch falsch — denn das Datum ist eine *externe*
Bedingung (Meilenstein M3), nicht die Welle.

**Schritt 1 — Wunsch in Inhalt zerlegen.** Frage zurück: *Was muss
*beim Audit* gezeigt werden?* Die Antwort ist immer eine Liste von
beobachtbaren Zuständen — und genau diese werden zu Closure-Triggern.
Stakeholder antwortet konkret: "ANN-Suche funktioniert auf 100k
Einträgen unter 1 s p95; Multi-Sprach-Adapter ist konsolidiert; OTel-
Pipeline zeigt End-to-End-Traces."

Drei Zustände, drei Trigger-Anker — und keiner davon enthält ein
Datum.

**Schritt 2 — Inhalt in Slices binden.** Jeder Closure-Trigger muss auf
einen oder mehrere Slices mit eigenem DoD verweisen. Sonst ist der
Trigger ein Wunsch, kein Beleg.

| Trigger-Anker (Stakeholder) | Slice(s) (Implementer-Ebene) |
|---|---|
| ANN-Suche < 1 s p95 bei 100k | `slice-014` (ANN-Bibliothek-Integration) + `slice-019` (Latenz-Replay gegen 100k-Korpus) |
| Multi-Sprach-Adapter konsolidiert | `slice-015` (Adapter-Cleanup) |
| OTel-Pipeline E2E | `slice-017` (OTel-Collector) + `slice-018` (Trace-Schema-Pflicht) |

Mehrfachbezüge sind erlaubt — *fehlende* Bezüge nicht. Wer einen
Trigger ohne Slice formuliert, hat einen Wunsch ohne Plan.

**Schritt 3 — Abhängigkeiten gegen vorhandene Wellen messen.** Eine
Welle, die ohne fertige Vorgängerin nicht starten kann, ist eine
Phantom-Welle. Lab-Beispiel: Welle 3 (`welle-3-skalierung`) hängt an
Welle 2 (`welle-2-qualitaet`) — Property-Tests müssen *vor* der
Skalierungs-Welle stehen, weil sonst die Skalierungs-Gates auf einer
nicht-property-getesteten Basis laufen.

Im Abhängigkeitsgraphen wird das eine gerichtete Kante; in der
Roadmap-Tabelle ein expliziter Eintrag in der `Trigger`-Spalte.

Diese Roadmap-Tabelle ist der Abschnitt **Nächste Wellen**; jede Zeile
trägt vier Spalten — Welle, Trigger (Abhängigkeit als beobachtbare
Bedingung), wichtigste Slices und geschätzter Aufwand (S/M/L, kein
Termin):

```markdown
## Nächste Wellen

| Welle | Trigger | Wichtigste Slices | Geschätzter Aufwand |
|---|---|---|---|
| welle-3-skalierung | welle-2 done + ADR-0004 (ANN-Bibliothek) accepted | slice-014 (ANN-Suche), slice-015 (Multi-Sprach-Adapter-Cleanup) | L |
| welle-4-betrieb | welle-3 done | slice-016 (k8s-Helm-Chart), slice-017 (OTel-Collector) | M |
```

Der Aufwand bleibt Schätzung (S/M/L) — dieselbe Größe, die in der
30-%-Bewertung wieder auftaucht; er triggert nichts.

**Schritt 4 — Welle-Eintrag mit den drei Pflicht-Bestandteilen
schreiben.** Closure-Kriterien · Slice-IDs · Abhängigkeits-Trigger.
Vorbild aus dem Lab
([`../../../lab/example/docs/plan/planning/in-progress/roadmap.md`](../../../lab/example/docs/plan/planning/in-progress/roadmap.md)):

```markdown
## Aktuelle Welle

**Welle-ID:** welle-3-skalierung
**Geplantes Ende:** 2026-07-24 (Schätzung)

**Closure-Trigger:**
- slice-014 (ANN-Bibliothek) done in allen Sprachen.
- slice-015 (Multi-Sprach-Adapter-Cleanup) done.
- slice-019 (Latenz-Replay) grün: p95 < 1 s bei 100k Korpus.
- ADR-0004 (ANN-Bibliothek-Wahl) `Accepted`.

**Vorgänger-Trigger:** welle-2-qualitaet done.
```

Datum *erscheint* als "Geplantes Ende (Schätzung)" — es triggert
nichts, es prognostiziert. Wenn die Schätzung kippt, kippt sie als
Schätzung, nicht als Closure-Kriterium.

**Schritt 5 — Meilenstein neben die Welle setzen, nicht in sie.** Der
Audit-Termin ist *Meilenstein M3*, nicht *Welle 3*. Welle und
Meilenstein verhalten sich orthogonal:

| Welle | Meilenstein |
|---|---|
| endet durch Closure-Kriterien (intern) | endet durch externe Bestätigung (Audit, Release, Kunde) |
| Inhalt vollständig im Repo | Inhalt zeigt sich an einer Außengrenze |
| `welle-3-skalierung` | M3 — Skalierbar |

Tabelle aus dem Lab:

```markdown
| Meilenstein | Welle(n) | Trigger | Status |
|---|---|---|---|
| M3 — Skalierbar | welle-3-skalierung | p95 < 1 s auch bei 100k Einträgen | offen |
```

Liefert **wellenlose Arbeit** den letzten Beleg eines Meilensteins, bleibt
die Spalte `Welle(n)` leer (`—`) und der Beleg steht als Slice-ID daneben.
Das ist der einzige Ort, an dem wellenlose Arbeit die Roadmap überhaupt
berührt — und auch hier nicht als Zustand, sondern als Beleg für eine
*externe* Bedingung, die ohnehin außerhalb der Welle liegt.

Der Audit-Termin (`2026-07-31`) ist Anhang im Meilenstein-Eintrag, nicht
Trigger der Welle. Das hat eine harte Konsequenz: wenn das Audit-Datum
gehalten werden *muss*, aber die Closure-Trigger nicht erreichbar sind,
ist die richtige Antwort ein *Carveout* (Modul 7), nicht ein halb
fertiges `done/`.

**Schritt 6 — Die zwei rückblickenden Anhänge: Closure-Log und
Drift-Log.** Eine geschlossene Welle verschwindet nicht aus der Roadmap —
sie wandert in den Abschnitt **Abgeschlossene Wellen**, den ruhenden
Audit-Bestand: welche Welle wann geschlossen wurde, mit Zeiger auf ihre
`done/welle-NN-results.md`.

```markdown
## Abgeschlossene Wellen

| Welle | Abschluss | Closure-Notiz |
|---|---|---|
| welle-1-mvp | 2026-05-28 | `done/welle-1-results.md` |
```

Daneben steht der *Bewegungs*-Anhang: eine Roadmap, die sich nie
korrigiert, hat den Steering Loop nicht durchlaufen. Pflicht-Block am Ende:

```markdown
## Historische Trigger-Verschiebungen

| Datum | Was wurde geändert? | Warum? |
|---|---|---|
| 2026-06-12 | slice-019 in welle-3 nachgenommen | Stakeholder ergänzte Audit-Anforderung; Trigger wäre sonst nicht beweisbar gewesen |
```

Die Drift-Tabelle ist nicht Hilfsmittel; sie ist das Audit-Signal. Wer sie
leer hat, hat eine starre Roadmap. Wer sie *jeden* Eintrag voll hat,
hat eine treibende Roadmap. Closure-Log (ruhender Bestand) und Drift-Log
(Bewegung) zusammen machen die Vergangenheit der Roadmap auditierbar.

**Schritt 7 — Bewusstes Brechen: Datum als Trigger schreiben.**
Formuliere einen Closure-Trigger absichtlich als Datum (*"welle-3-
skalierung schließt am 2026-07-24"*) und beobachte: am 24. Juli ist
slice-019 noch nicht grün — was passiert? Drei mögliche Antworten:

| Antwort | Diagnose |
|---|---|
| Welle wird trotzdem geschlossen, slice-019 wandert in welle-4. | Datum hat Closure überschrieben — der Audit fällt durch, weil slice-019 nicht belegt ist. Trigger-Disziplin ist Theorie geblieben. |
| Welle bleibt offen, das Datum wird verschoben. | Trigger-Disziplin wirkt, aber die Roadmap-Drift-Tabelle muss den Eintrag bekommen — sonst ist die Verschiebung still. |
| Carveout `CO-009` für die fehlende Latenz, Welle schließt mit Carveout. | Sauber: das Versprechen wird offen reduziert, Folge-Slice ist verdrahtet, Audit weiß, was er ansieht. |

Genau das Spannungsverhältnis zwischen Stakeholder-Datum und
Closure-Disziplin ist die Conceptual-Change-Stelle dieses Moduls: *Eine
Roadmap ist nicht "wann?", sondern "in welcher Reihenfolge wovon?"*.

Sieben Schritte, eine Welle, drei Trigger ohne Datum. Vergleich:
[`../../../lab/example/docs/plan/planning/in-progress/roadmap.md`](../../../lab/example/docs/plan/planning/in-progress/roadmap.md).

## Wann Arbeit eine Welle braucht — und wann nicht

Bevor eine Welle eröffnet wird, steht eine Vorfrage, die das
wellen-zentrierte Roadmap-Format nicht stellt: *Braucht diese Arbeit
überhaupt eine Welle?*

Der Kernbegriff antwortet bereits: Eine Welle ist ein *"Bündel von
Slices, das gemeinsam geplant und **abgeschlossen** wird"*
([`grundlagen/konventionen.md` §Kernbegriffe](../grundlagen/konventionen.md#kernbegriffe)).
Das gemeinsame Abschließen trägt das Kriterium — nicht die Größe der
Arbeit:

> **Eine Welle liegt vor, wenn es eine beobachtbare Closure-Bedingung
> gibt, die mehr beobachtet, als die DoDs ihrer Slices schon belegen.**

Ein Trigger, der nichts beobachtet, was die Slices nicht ohnehin belegen,
ist Zeremonie. Die kanonische Form dieses *Mehr* steht unten in
[§Die Wellen-Closure-Prozedur](#die-wellen-closure-prozedur), Schritt 1:
alle Slices in `done/` **und** `make gates` grün **und** der Replay-Lauf
grün — die beiden Gate-Bedingungen sind repo-weit und stehen in keiner
einzelnen DoD.

Fehlt dieses Mehr, gibt es keine Welle. Bei einem einzelnen Slice ist das
der Regelfall: Sein Closure-Trigger würde die eigene DoD abschreiben.
Solche Arbeit läuft **ohne Welle** — typisch für Reaktives (ein Sensor
hat gefeuert, ein Pin ist veraltet, ein Nutzer hat etwas gemeldet), aber
nicht darauf beschränkt: auch eine neue Fähigkeit kann ein einzelner
Slice sein. Umgekehrt bleibt ein Ein-Slice-Bündel eine Welle, wenn sein
Trigger repo-weite Belege fordert, die der Slice allein nicht liefert.

**Wellenlose Arbeit erscheint nicht in der Roadmap** — weder beim Start
noch beim Abschluss. Ihr Zustand ist die Verzeichnis-Position
([Modul 5](modul-05-planning-harness.md)); `ls docs/plan/planning/in-progress/`
beantwortet "was läuft gerade" autoritativ und ohne Pflegeaufwand. Ein
Eintrag daneben wäre eine zweite Quelle für denselben Zustand, und die
altert: Sie wird nachgezogen, solange jemand daran denkt, und meldet
danach einen Slice als laufend, der längst in `done/` liegt. Die Belege
eines geschlossenen wellenlosen Slice stehen in seiner Datei und in git;
das Closure-Log der Roadmap ist für Wellen.

**Und was kommt als Nächstes?** Diese Frage beantwortet `next/` — das
Lifecycle-Verzeichnis heißt *priorisiert/eingeplant*
([Modul 5](modul-05-planning-harness.md#lifecycle-als-state-machine)), und
der Übergang `open→next` ist die Priorisierungs-Entscheidung. Wellenlose
Arbeit steht hier **nicht schlechter da als wellengebundene**: Eine
Reihenfolge *einzelner Slices* kennt der Harness überhaupt nicht. Die
Roadmap ordnet **Wellen**; die Spalte *Wichtigste Slices* in §Nächste
Wellen nennt Inhalt, keinen Rang, und innerhalb einer Welle sind die
Slices ein Bündel, das gemeinsam schließt — eine interne Ordnung wäre
gegenstandslos. Wer für wellenlose Arbeit eine Rangliste neben der
Roadmap anlegt, führt eine Sortierung ein, die es für Slices nie gab, und
schafft sich die zweite Quelle, die der Absatz oben gerade vermeidet.

**Wellenlos heißt nicht wächterlos.** Der Slice schreibt seine
Closure-Notiz §7 wie jeder andere, und die Wellen-Closure verdichtet
unten in Schritt 3 *alle* Slice-Closures seit der letzten Welle-Closure —
die wellenlosen eingeschlossen. Damit zählt der Steering Loop weiter
vollständig und offene Risiken finden ihren Ausgang.

**Was die Regel dagegen nicht repariert, und das ehrlich:** Der
Trigger-Audit (Schritt 2 unten) und die Carveout-Frist („seit > 2 Wellen
aktiv", [Modul 7](modul-07-carveouts.md)) hängen weiter an der
Welle-Closure, und die Frist *misst in Wellen*. Wer lange wellenlos
arbeitet, dehnt sie damit — ein Carveout steht dann bei „0 Wellen aktiv",
obwohl Monate vergangen sind. **Ein Repo, das nur wellenlos arbeitet, hat
keinen Zähler und keine laufende Frist** — wer über Monate keine Welle
eröffnet, verliert den Steering Loop, nicht weil die Slices wellenlos
waren, sondern weil nie verdichtet wurde. Wer so arbeitet, muss den
Trigger-Audit eigenständig auslösen.

Der Fehlgebrauch, den diese Regel verhindert, ist beobachtet: Wer das
Format für vollständig hält, presst den einzelnen Slice in eine
Pseudo-Welle oder trägt ihn unter *Aktuelle Welle* ein — bis der
Abschnitt seitenlang ist und gleichzeitig meldet, dass keine Welle läuft.

## Das Beobachtungs-Register

Der Zähler des Steering Loops braucht einen Ort, der **zwischen** den Wellen
überlebt. Er liegt als stehende Datei flach im Planning-Layout, neben den
offenen Wellen:

```text
docs/plan/planning/observations.md
```

**Warum stehend und nicht in der Welle-Closure.** Eine Sektion, die von
Closure zu Closure weitergereicht wird, hängt an einer ungebrochenen Kette:
Wer die Übernahme vergisst, setzt den Zähler auf null; die erste Welle braucht
eine Sonderregel; und wer über längere Zeit keine Welle eröffnet, hat gar
keinen Träger. Ein fester Ort streicht alle drei Fälle — die Datei existiert ab
Repo-Beginn, unabhängig davon, ob je eine Welle geschnitten wurde.

**Form.** Fünf Spalten; die Kennung ist die erste:

```markdown
| Kennung | Beobachtung | Sub-Area | Zähler | Belege |
|---|---|---|---|---|
| BEO-001 | Golden-Set-Case ohne Boundary-Anteil aufgenommen | Test-Infrastruktur | 2× | slice-005, slice-011 |
| BEO-002 | ADR-Bezug im Commit vergessen, im Review nachgetragen | Spec-Schreibung | 2× | slice-008, slice-012 |
```

**`BEO-<NNN>` ersetzt die Namens-Disziplin.** Ohne Kennung muss die
*Bezeichnung* über Wellen hinweg wortgleich bleiben, sonst zählt man zwei
Namen für dieselbe Sache getrennt und keiner erreicht je 3×. Mit Kennung wird
beim Erstauftreten einmal benannt und eine ID vergeben; jedes Wiederauftreten
zitiert die ID. Umformulierungen ändern dann nur noch das Label, nicht die
Zählung. Das Register ist zugleich die Vergabestelle — ein Henne-Ei-Problem
entsteht nicht.

**Was Maschine kann und was nicht.** Die Steering-Loop-Einträge aus den
`done/`-Closures lassen sich mechanisch **einsammeln** — sie tragen ein
festes Label und ihre Herkunft ist der Dateiname. Was keine Maschine leisten
kann, ist die Entscheidung, ob zwei Einträge *dieselbe* Beobachtung meinen;
genau dort sitzt das Urteil, das den Zähler zählbar macht. Daraus folgt ein
Arbeitsteilung in drei Schritten:

1. **Generieren** — ein Werkzeug sammelt die Einträge aus `done/` und schlägt
   Kandidaten samt Belegen vor.
2. **Committen** — das Register liegt im Repo und ist lesbar, ohne es zu bauen.
3. **Prüfen** — ein Gate vergleicht Generat gegen Committetes und schlägt bei
   Abweichung an; ein Eintrag, der in `done/` steht und im Register fehlt,
   fällt damit auf.

*Welches* Werkzeug das ist, legt der Kurs nicht fest — das ist eine
Repo-Entscheidung wie die Wahl des Doku-Gates. Das Muster „tool-generiert,
committet, per Gate gegen Drift gesichert" ist dasselbe, das ein gepinntes
Gate-Fragment im Repo hält.

**Bei 3×** verlässt der Eintrag das Register nicht still: Er wandert in die
Steering-Loop-Einträge der laufenden Welle-Closure und wird dort zur
verkörperten Regel — mit Herkunfts-Anker
([`../grundlagen/konventionen.md` §Herkunfts-Anker](../grundlagen/konventionen.md#herkunfts-anker-für-steering-loop-regeln)).
Im Register bleibt die Zeile mit dem Vermerk stehen, wohin sie ging; gestrichen
wird nur mit Begründung, warum die Beobachtung nicht mehr auftreten kann.

## Die Wellen-Eröffnungs-Prozedur

Die Closure-Seite ist unten in fünf Schritten ausbuchstabiert — die
Eröffnung braucht drei, und der mittlere ist der, den Teams zuerst
weglassen:

1. **Welle-Ziel, Out-of-Scope und Closure-Trigger festlegen.**
   Beobachtbare Bedingung, kein Datum (§Aktuelle Welle). Erst danach
   werden Slices zugeordnet — sonst schneidet die Slice-Liste das Ziel
   statt umgekehrt. **Out-of-Scope gehört dazu**: dieselbe Disziplin wie
   im Lastenheft ([Modul 3](../01-spec-und-architektur/modul-03-lastenheft.md))
   und im Slice-Plan ([Modul 9](../03-agenten/modul-09-implementierung.md))
   — was nicht ausdrücklich ausgeschlossen ist, wandert im Zweifel in die
   Welle und dehnt sie, bis der Closure-Trigger unerreichbar wird.
2. **Offene Beobachtungen sichten.** Das Register
   [`docs/plan/planning/observations.md`](#das-beobachtungs-register) wird
   durchgegangen: Betrifft eine davon die Sub-Areas, die diese Welle
   berührt? Dann gehört sie in die Slice-Planung — entweder als Risiko im
   betroffenen Slice ([Modul 5 §Sub-Area-Modus-Begründung](modul-05-planning-harness.md#worked-mini-example-bootstrap-modus-pro-sub-area-für-einen-slice-begründen))
   oder, wenn sie mit dieser Welle 3× erreicht, als eigener Slice, der die
   Lücke schließt. **Das ist der einzige Schritt im ganzen Zyklus, der
   Closure-Wissen wieder als Eingabe nutzt** — ohne ihn ist die
   Closure-Notiz write-only, und die Zählregel des Steering Loops hat
   keinen Zähler. **Bei der ersten Welle entfällt dieser Schritt** — es
   gibt keine Vorgängerin; die Sektion entsteht dann erstmals bei deren
   Closure aus **allen bis dahin geschlossenen** Slice-Closures, auch den
   wellenlosen. Genau dafür ist das Fenster in Schritt 3 offen: „seit der
   letzten Welle-Closure" heißt bei der ersten Welle „seit Repo-Beginn" —
   sonst fiele reaktive Frühphasen-Arbeit aus der Zählung heraus.
3. **Welle-Datei flach anlegen** (`docs/plan/planning/<welle-id>.md`,
   Ziel-Form [`welle.template.md`](../../../lab/templates/docs/plan/planning/welle.template.md))
   **und in die Roadmap als *Aktuelle Welle* eintragen.** Der Zustand ist
   die Verzeichnis-Position, nicht ein Status-Feld.

**Was hier bewusst *nicht* passiert:** Der Implementation-Agent bekommt
`done/` nicht in seinen Lauf-Kontext. Schritt 2 ist eine
*Planungs*-Leistung — was die Schwelle erreicht hat, ist ohnehin in
AGENTS.md, Gates und Skills verkörpert und wirkt dort automatisch
(Modul-0-Prinzip: *Per-Lauf-Relevantes gehört verkörpert, nicht extern
nachgeladen*). Ein Archiv pro Lauf zu laden wäre Kontext-Verschwendung
für Wissen, das schon wirkt.

## Die Wellen-Closure-Prozedur

Modul 5 gibt den *Slice*-Zyklus als Zustandsmaschine vor (`open/` →
`next/` → `in-progress/` → `done/`). Die *Welle* liegt eine Ebene
darüber: Sie schließt nicht durch einen einzelnen Slice-Übergang, sondern
durch einen geordneten Ablauf, der alle ihre Slices bündelt. Fünf
Schritte — jeder hinterlässt einen Beleg, keiner ein Datum:

1. **Trigger prüfen.** Alle Slices der Welle liegen in `done/`,
   `make gates` und der Replay-Lauf sind grün. Das ist die *beobachtbare*
   Closure-Bedingung aus der Welle-Definition — nicht der Kalendertag.
2. **Trigger-Audit der Welle.** Der Harness kennt **drei** Artefaktklassen,
   die einen Trigger tragen — eine Bedingung, deren Eintreten eine Handlung
   auslösen soll. Alle drei werden hier geprüft, nicht nur die erste:

   | Artefakt | Trigger | Bei Eintreten |
   |---|---|---|
   | **Carveout** ([Modul 7](modul-07-carveouts.md)) | Auflösungs-Trigger | aufgelöst · verlängert (mit Folge-Slice) · permanent akzeptiert |
   | **Bootstrap-aware Gate** ([Modul 13](../04-qualitaet/modul-13-quality-gates.md#bootstrap-aware-gates)) | Hochschalt-Trigger | Stufe hochschalten — oder Carveout eröffnen, wenn die neue Schwelle rot ist |
   | **ADR** ([Modul 4](../01-spec-und-architektur/modul-04-architektur-adrs.md)) | Re-Evaluierungs-Trigger | Entscheidung neu bewerten → bestätigt oder Folge-ADR mit `supersedes` |

   Eine Welle darf *mit* dokumentiertem Carveout schließen — aber nie mit
   einem stillen roten Gate, einer stehengebliebenen Reifestufe oder einer
   Entscheidung, deren Re-Evaluierungs-Bedingung vor drei Wellen eintrat.
   Der Kurs benannte diese Pathologie bisher nur für Carveouts
   (*Carveout-Wildwuchs*, [`klassifikation.md`](../grundlagen/klassifikation.md#entropy-management));
   sie gilt für alle drei Klassen — **ein Trigger ohne Wächter ist eine
   Absichtserklärung mit Verfallsdatum.**

3. **Welle nach `done/` schließen.** *Grundlage sind die Closure-Notizen
   aller Slices, die seit der letzten Welle-Closure nach `done/`
   gewandert sind* — die dieser Welle **und** die wellenlos gelaufenen
   (§Wann Arbeit eine Welle braucht). Der Zähler unterscheidet nicht nach
   Welle-Zugehörigkeit, sonst zählte er an wellenloser Arbeit vorbei und
   eine Beobachtung, die überwiegend dort auftritt, erreichte die Schwelle
   nie. Grundlage ist §7 jeder dieser Dateien. Sie werden
   durchgegangen und **verdichtet**, nicht aus dem Gedächtnis
   zusammengetragen: gleiche Beobachtungen zusammenfassen und zählen ·
   was 3× erreicht → *Steering-Loop-Einträge* · was darunter bleibt →
   bleibt im **Beobachtungs-Register** stehen und wird dort hochgezählt
   (§Das Beobachtungs-Register) · Risiken mit Ausgang „weiter offen"
   ([Modul 5](modul-05-planning-harness.md#offene-risiken-werden-bei-closure-aufgelöst))
   ebenfalls dorthin. **Ohne diesen Lese-Schritt ist der Slice-Lerneintrag
   selbst write-only** — und die Zählung gar nicht durchführbar, denn ob
   eine Beobachtung ein- oder dreimal auftrat, steht nur in den
   Slice-Closures.
   Die Closure-Notiz
   `done/welle-NN-results.md` hält fest, *was gelernt wurde*: geliefert · was
   funktionierte · was anders lief · **Steering-Loop-Einträge** (geschärfte
   Regel / neuer Sensor / benannte Spec-Lücke) · **Beobachtungen unter
   Schwelle** · Folge-Slices (*derivativ* — der Slice selbst liegt in
   `open/`, die Liste zeigt nur darauf) · Verifikation (die Belege aus
   Schritt 1). Ohne
   Lerneintrag ist die Welle nicht „fertig", sondern nur „weg"
   ([Modul 1](../01-spec-und-architektur/modul-01-entwicklungszyklus.md)).
   Ziel-Form: [`/lab/templates/docs/plan/planning/welle-results.template.md`](../../../lab/templates/docs/plan/planning/welle-results.template.md).

   **Warum der Zähler ein eigenes Artefakt ist.** Der
   Steering Loop zählt *1× notieren · 2× Symptom · 3× Lücke*
   ([`klassifikation.md`](../grundlagen/klassifikation.md#steering-loop)) —
   das setzt ein Gedächtnis über Läufe hinweg voraus. Was die Schwelle
   erreicht hat, ist bereits **verkörpert** (AGENTS-Regel, Gate, Skill) und
   wirkt von selbst weiter. Was *darunter* liegt, ist nirgends verkörpert:
   ohne eigenes Register versickert es in der Closure-Prosa, und der Zähler
   fängt mit jeder Welle bei null an. Ein Fehler, der einmal pro Welle
   auftritt, wäre nach fünf Wellen eine 5×-Lücke, die niemand je als Lücke
   sieht. Die Sektion wird deshalb bei der nächsten Closure **übernommen und
   hochgezählt**, nicht neu geschrieben; erreicht ein Eintrag 3×, wandert er
   in die Steering-Loop-Einträge und verlässt die Liste.
   **Zugleich per `git mv` die Welle-Plan-Datei von flach nach `done/`** — neben
   ihre Ergebnis-Notiz. Der Zustand ist die Verzeichnis-Position, kein
   `Status`-Feld (wie beim Slice, [Modul 5](modul-05-planning-harness.md)): die
   aktive Welle liegt flach unter `docs/plan/planning/`, geschlossenes
   Planungs-Material in `done/`, und die Roadmap bleibt die
   Sequenzierungs-Autorität — so füllt sich der Ordner nicht mit Abgeschlossenem.

   **Zum Schluss beide Paarungen prüfen** — erst *jetzt*, weil sie die
   Einträge prüfen, die in diesem Schritt gerade entstanden sind; in
   Schritt 2 gäbe es sie noch nicht. Beide folgen dem Muster *Nennung
   ohne Deckung ist eine Harness-Lüge*: (a) **Anker-Paarung** — jeder
   Steering-Loop-Eintrag nennt einen Zielort, der Zielort existiert und
   trägt `seit welle-<NN>`
   ([`konventionen.md` §Herkunfts-Anker](../grundlagen/konventionen.md#herkunfts-anker-für-steering-loop-regeln));
   (b) **Folge-Slice-Paarung** — jeder genannte Folge-Slice existiert als
   Datei **im Planning-Lifecycle** (`open/`, `next/`, `in-progress/`,
   `done/`) — nicht nur in `open/`: bis zur Prüfung kann er bereits
   weitergewandert sein, der Zustand ist die Verzeichnis-Position.
   Rot heißt: etwas wurde versprochen und nicht angelegt — dieselbe
   Klasse wie ein halluziniertes Gate.
4. **Wave-Self-Close-Commit.** Ein einzelner, beobachtbarer Commit
   markiert den Abschluss — der Audit sieht *einen* Punkt, an dem die
   Welle schloss, statt eines verstreuten Verschwindens.
5. **Roadmap fortschreiben.** Die Welle wandert aus *Aktuelle Welle* in
   die Tabelle *Abgeschlossene Wellen* (mit Zeiger auf ihre
   Closure-Notiz); die erste Zeile aus *Nächste Wellen* wird zur neuen
   *Aktuellen Welle*. Löste dabei ein Trigger eine Umplanung aus, bekommt
   die *Historische Trigger-Verschiebungen*-Tabelle ihren Eintrag.

Erst wenn alle fünf Belege vorliegen, ist die Welle *auditierbar*
geschlossen.

## Übungen

> **Wenn du das Worked Example übersprungen hast:** hole
> [Schritt 7 — Bewusstes Brechen](#worked-example-einen-datumswunsch-in-eine-trigger-welle-übersetzen)
> als Fehlerfall nach, bevor du die Übungen startest — die einzige
> Fehler-Provokation dieses Moduls (Datum als Trigger schreiben und
> das Kippen beobachten) liegt dort.

* Aufbau einer produktiven Roadmap für das Begleit-Lab
* Modelliere eine Abhängigkeit, die eine spätere Welle blockiert
* **(Analysieren — aktiviert LZ 2)** *Welle oder keine Welle.* Vier
  Vorhaben in deinem Repo: (a) ein veralteter Tool-Pin soll nachgezogen
  werden; (b) eine zweite Zielsprache soll unterstützt werden, was drei
  Slices braucht, die zusammen erst Sinn ergeben; (c) ein Review-Finding
  verlangt genau eine Korrektur; (d) ein Slice, dessen Abschluss zusätzlich
  einen grünen Replay-Lauf gegen das Golden Set verlangt. Entscheide für
  jedes: Welle oder ohne Welle? Wende dabei ausschließlich das Kriterium
  aus [§Wann Arbeit eine Welle braucht](#wann-arbeit-eine-welle-braucht--und-wann-nicht)
  an — und benenne bei jeder Entscheidung *die Bedingung*, die über die
  DoDs der Slices hinausgeht, oder eben fehlt. Fall (d) ist der, an dem
  sich zeigt, ob du das Kriterium oder bloß die Slice-Zahl anwendest.
* **(Bewerten — aktiviert LZ 3)** *Welle über Schätzung bewerten.* Eine
  Welle deiner Roadmap liegt 30 % über der Schätzung. Bewerte begründet,
  ob du sie **neu schneidest**, **neu planst** oder einen **Carveout**
  setzt — und mach die Diagnose *vor* der Aktion: liegt die Abweichung an
  Slice-Größe (→ neu schneiden), an Reihenfolge/Abhängigkeit (→ neu
  planen) oder an unerwarteter Komplexität (→ Carveout)? Benenne zum
  Schluss *eine* Annahme, die beim Schätzen schon "weich" war — das ist
  dein metakognitives Steering-Signal für die nächste Schätzung.

## Reflexion

Vier Standardfragen aus [`reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md)
nach dem Roadmap-Bau. Modul-spezifische Trigger:

- **Beobachtung:** War dein erster Trigger ein Datum oder ein beobachtbarer Zustand? Welche Welle hattest du *nur* mit Datum gedacht?
- **2×2-Quadrant:** Trigger-Disziplin ist *inferential feedforward* (Roadmap-Skill).
- **Steering-Loop:** Welle-Eintrag-Template mit Trigger-Pflichtfeld? Closure-Kriterien als Selbst-Checkliste vor `done/`-Verschiebung?
- **Conceptual Change:** Kandidaten in [`lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "Welle = Sprint", "Trigger = Datum", "Roadmap ist eine Datumsleiste").

## Selbstcheck

* **(Erinnern)** Welche drei Bestandteile braucht ein Welle-Eintrag minimal, damit "fertig" beobachtbar wird?
* **(Erinnern)** Nenne drei Beispiele für *beobachtbare* Trigger aus diesem Modul — nicht erfundene, sondern aus den Engage-/Fehlvorstellungs-Blöcken.
* Was tust du, wenn eine Welle 30 % über der Schätzung liegt — neu schneiden, neu planen oder Carveout?
* Was unterscheidet eine Welle von einem Meilenstein?
* **(Analysieren — aktiviert LZ 2)** Ein einzelner Slice zieht einen
  veralteten Tool-Pin nach. Braucht er eine Welle? Begründe über die
  Closure-Bedingung, nicht über den Umfang — und sag, wo sein
  Steering-Loop-Eintrag verdichtet wird, wenn er zu keiner Welle gehört.
* **(Analysieren — aktiviert LZ 2)** Drei Ereignisse aus dem
  Fallstudien-Repo `pt9912/grid-gym`
  ([`fallstudien.md`](../grundlagen/fallstudien.md)): (a) Der
  Wave-Self-Close-Commit landet im Repo, nachdem alle Slices der
  laufenden Welle in `done/` liegen und die 10 A-1-Pflicht-Gates in
  `make gates` grün sind. (b) Der Repo-Zustand *"Simulator läuft
  deterministisch reproduzierbar"* ist erstmals extern vorzeigbar —
  die `determinism`/`replay`-Suiten laufen vollständig grün. (c) Ein
  Versions-Tag wird gesetzt und das Paket wandert nach Staging. Ordne
  jedes Ereignis genau einer Kategorie — Welle, Meilenstein, Release —
  zu und benenne je den Trigger, der es auslöst.
* **(Erschaffen — aktiviert LZ 1)** Gegeben drei Slices `SL-101` (API), `SL-102` (Cache, braucht die API), `SL-103` (Dashboard): entwirf den *ersten* Wellen-Eintrag als kompletten Mini-Block — Slice-IDs, *einen* beobachtbaren Trigger (kein Datum) und *ein* Closure-Kriterium. Begründe in einem Satz, warum genau diese Slices in *einer* Welle liegen und nicht über zwei verteilt sind.
* **(Analysieren — aktiviert LZ 4)** Welle 3 (`welle-3-skalierung`) kann erst starten, wenn Welle 2 (`welle-2-qualitaet`) fertig ist: Wie modellierst du diese Abhängigkeit *im Roadmap-Eintrag* von Welle 3 — und woran genau erkennst du, dass Welle 2 zum *Blocker* wird (nicht bloß Vorgängerin)?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Drei Bestandteile eines Welle-Eintrags? | "Slices und Datum." | Slice-IDs (Inhalt) · Trigger als beobachtbare Bedingung (kein Datum) · Closure-Kriterien (z. B. Replay grün, alle Slices in `done/`). | + Datum darf *erwähnt* werden (Prognose), darf aber nie Trigger sein — sonst kappt die Welle halbfertige Slices am Kalendertag und das Auditierbarkeits-Versprechen bricht. |
| Drei beobachtbare Trigger-Beispiele? | "Wenn etwas fertig ist." | Drei aus dem Modul: "SL-024 liegt in `done/`" · "Replay-Lauf gegen Golden Set grün" · "Carveout `CO-007` aufgelöst". | + Pointe: ein Trigger ist beobachtbar dann, wenn ein *anderer* Mensch ohne Rückfrage sagen kann, ob er eingetreten ist. "Sobald wir Zeit haben" scheitert daran; "SL-024 in `done/`" besteht. |
| Welle 30 % über Schätzung — was tun? | "Mehr Zeit geben." | Diagnose vor Aktion: liegt es an Slice-Größe (→ neu schneiden), an Reihenfolge (→ neu planen), oder an unerwarteter Komplexität (→ Carveout)? | + Hinweis, dass 30 % früh ein Steering-Loop-Signal sein können (Slice-Sizing-Regel schärfen), 30 % spät (vor Welle-Closure) eher Carveout. Metakognitiv: die *eigene* Schätzunsicherheit als Steering-Signal benennen — woran hätte man die Abweichung früher erkannt (welches Slice war schon beim Schätzen "weich", welche Annahme blieb ungeprüft)? — damit die nächste Schätzung kalibrierter ausfällt. |
| Welle vs. Meilenstein? | "Größe." | Welle = Bündel paralleler/serialisierter Slices mit Closure-Kriterien. Meilenstein = extern beobachtbarer Zustand (Release, Audit-Punkt). | + Eine Welle endet *durch* Closure-Kriterien; ein Meilenstein endet durch *Datum oder externe Bestätigung* — und genau deshalb leitet sich der Meilenstein aus Wellen ab, nicht umgekehrt. |
| Braucht ein Tool-Pin-Slice eine Welle? | "Ein Slice ist zu klein für eine Welle." — Größen-Argument, zufällig richtig. | Nein, begründet über die **Closure-Bedingung**: Der Trigger könnte nur die DoD des Slice abschreiben, es fehlt das *Mehr*. Der Slice läuft ohne Welle und erscheint nicht in der Roadmap; sein Steering-Loop-Eintrag wird in der **nächsten** Welle-Closure verdichtet (Schritt 3 nimmt alle Slice-Closures seit der letzten Welle-Closure). | + Gegenprobe am Größen-Argument: Ein *einzelner* Slice, dessen Abschluss zusätzlich einen grünen Replay-Lauf gegen das Golden Set verlangt, **ist** eine Welle — die Bedingung ist repo-weit und steht in keiner DoD. Wer „zu klein" antwortet, liegt hier falsch. |
| Drei `grid-gym`-Ereignisse Welle/Meilenstein/Release zugeordnet? | höchstens eine Zuordnung richtig, Trigger fehlen oder lauten "ist halt fertig". | (a) **Welle** — Trigger: Closure-Kriterien erfüllt (alle Slices in `done/`, Gates grün), beobachtbar am Wave-Self-Close-Commit. (b) **Meilenstein** — Trigger: extern beobachtbarer Repo-Zustand (Determinismus belegt), keine interne Closure nötig. (c) **Release** — Trigger: ein Artefakt verlässt das Repo in eine Umgebung (Tag + Staging). | + Begründung über die Orthogonalität: ein Release kann mehrere Wellen umfassen, der Meilenstein liegt *neben* der Welle (externe Bestätigung), die Welle endet *durch* Closure — deshalb kann (b) eintreten, ohne dass (a) oder (c) am selben Tag liegen. |
| Ersten Wellen-Eintrag aus `SL-101/102/103` entworfen? | Slices aufgelistet, aber Trigger ist ein Datum oder fehlt; kein Closure-Kriterium. | Vollständiger Mini-Block: Slice-IDs · *ein* beobachtbarer Trigger (kein Datum) · *ein* Closure-Kriterium; Bündelung begründet (z. B. "`SL-102` braucht `SL-101`, beide liefern erst zusammen prüfbaren Wert"). | + Schnitt-Begründung mit Gegenprobe: warum `SL-103` (Dashboard) *nicht* in dieselbe Welle gehört, wenn es ohne Cache keinen Mehrwert zeigt — und welcher Trigger es in die *nächste* Welle zieht. Der Entwurf nennt den Trigger so, dass ein Dritter ohne Rückfrage über "Welle fertig" entscheiden kann. |
| Abhängigkeit Welle 3 → Welle 2 modelliert, Blocker erkannt? | "Welle 3 kommt nach Welle 2." — Reihenfolge genannt, keine Modellierung. | Abhängigkeit als expliziter Abhängigkeits-Trigger in der `Trigger`-Spalte von Welle 3 (z. B. „startet, wenn `welle-2-qualitaet` in Closure") + gerichtete Kante im Abhängigkeitsgraphen. | + Blocker-Kriterium benannt: Welle 2 ist Blocker, sobald Welle 3 *ohne* deren Closure nicht starten kann (Phantom-Welle) — und der Test dafür: würde Welle 3 jetzt starten, liefe ein Gate auf nicht-property-getesteter Basis. Reine Vorgängerin ohne harte Kante wäre kein Blocker. |

## Weiterlesen

* Nächstes Modul: [Modul 7 — Carveout Management](modul-07-carveouts.md)
