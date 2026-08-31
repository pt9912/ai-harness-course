# Modul 6 — Roadmap Engineering

> **Aufwand:** ca. 60 Min Lesen · 60 Min Übung. Die konzeptuelle Tiefe liegt in [Modul 5 (Slice-Schnitt)](modul-05-planning-harness.md) und [Modul 7 (Carveouts)](modul-07-carveouts.md); das siebenschrittige Worked Example zum Wellen-Schnitt unten trägt jedoch die Hauptlast dieses Moduls — plane die volle Stunde ein.

## Mini-Glossar für dieses Modul

Vier neue Begriffe — Volldefinitionen in
[`begriffe.md`](../grundlagen/begriffe.md#kernbegriffe).

| Begriff | Ein-Satz-Definition | Bild im Kopf |
|---|---|---|
| **Welle** | Sequenz von Slices, geschlossen durch einen *Trigger*, nicht durch ein Datum. | eine Welle, die bricht, *wenn* das Wasser hoch genug ist — nicht *wann* die Uhr klingelt. |
| **Meilenstein** | Beobachtbarer Repo-Zustand am Ende einer Welle — nicht ein Datum, sondern ein Beleg. | das Kerbholz am Bergpfad: du bist *hier*, weil du *das* erreicht hast. |
| **Release** | Ein Artefakt, das in eine Umgebung wandert (Staging, Produktion) — kann mehrere Wellen umfassen oder eine. | das Päckchen, das das Lager verlässt, nicht der Pack-Vorgang. |
| **Trigger** | *Beobachtbare* Bedingung, mit der eine Welle closed (vgl. Carveout-Auflösungs-Trigger, Modul 7). | die Glocke, die *anzeigt*, dass es jetzt soweit ist — nicht "wenn wir Zeit haben". |

## Engage

Frage an drei Tech Leads: *"Wann ist Welle 3 fertig?"* — Antwort A:
*"Am 30. Juni."* Antwort B: *"Wenn slice-024 und slice-027 in done/ liegen
und der Replay-Lauf grün ist."* Antwort C: *"Wenn das Team durch ist."*
Welche Antwort ist eine Roadmap? Genau eine. Die anderen sind Wunsch
oder Status.

## Lernziele

Nach diesem Modul kannst du:

* eine Roadmap als Reihenfolge von Wellen mit Triggern *aufbauen* (Erschaffen · prozedural),
* Welle ↔ Meilenstein ↔ Release sauber *unterscheiden*, *erkennen*, wann Arbeit ganz ohne Welle läuft, für ein Beispiel-Repo den jeweiligen Trigger *zuordnen* und *einordnen*, wo der Steering-Loop-Zähler geführt wird und wer ihn schreibt bzw. liest (Analysieren · konzeptuell),
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
* Das Beobachtungs-Register: der Zähler außerhalb der Welle

## Kernidee

Eine Roadmap ist eine Reihenfolge von Wellen, keine Reihenfolge von
Terminen. Termine sind eine Folge der Wellen, nicht ihr Treiber.

## Typische Fehlvorstellungen

- **"Roadmap ist eine Datumsleiste."** — Datum ist Output, nicht Input. Wer Datumsleisten plant, plant Wunschdenken.
- **"Burndown ist Fortschritt."** — Burndown ist *Tempo*. Fortschritt ist, ob die Welle das verspricht, was sie sollte.
- **"Eine Roadmap ist statisch."** — Eine Roadmap, die nach drei Wellen nicht angepasst wurde, hat den Steering Loop nicht durchlaufen.
- **"Welle = Sprint."** — Ein Sprint endet durch *Datum* (zwei Wochen sind um). Eine Welle endet durch *Closure-Kriterien* (alle ihre Slices in `done/`, Replay-Lauf grün, Closure-Einträge geschrieben). Wer Wellen wie Sprints schneidet, kappt halbfertige Slices am Datum — und produziert genau die Auditierbarkeits-Lücke, die der Harness verhindern soll.
- **"Trigger = Datum."** — Ein Trigger ist eine *beobachtbare Bedingung* ("slice-024 liegt in `done/`", "Replay-Lauf gegen Golden Set grün", "Carveout `CO-007` aufgelöst"). Ein Datum ist kein Trigger, sondern eine Prognose. Wenn das einzige Trigger-Kriterium ein Kalendertag ist, plant die Roadmap nicht — sie hofft.
- **"Beobachtbar reicht."** — Für den **Start**-Trigger nicht: Er darf **kein Ergebnis dieser Welle** sein. „Alle Slices in `done/`" ist beobachtbar *und* ein Ergebnis — als Closure-Trigger richtig, als Start-Trigger zirkulär: Die Welle könnte erst beginnen, wenn sie fertig ist. Beobachtbarkeit und Vorbedingung sind zwei Prüfungen, nicht eine. Praktischer Test: Steht der Trigger in der Slice-Liste *dieser* Welle, ist er falsch platziert.

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

**Schritt 4 — Die Welle-Datei trägt die drei Pflicht-Bestandteile; die
Roadmap zeigt nur darauf.** Closure-Kriterien · Slice-IDs ·
Abhängigkeits-Trigger stehen in der **flachen Welle-Datei** (Ziel-Form
[`welle.template.md`](../../../lab/templates/docs/plan/planning/welle.template.md));
der Abschnitt **Offene Wellen** der Roadmap ist *derivativ*: Der Zustand sind
die flachen Welle-Dateien, und woran gerade gearbeitet wird, sagt das
`Welle:`-Feld der Slices in `in-progress/`
([Modul 5](modul-05-planning-harness.md#lifecycle-als-state-machine)). Vorbild
aus dem Lab
([`../../../lab/example/docs/plan/planning/in-progress/roadmap.md`](../../../lab/example/docs/plan/planning/in-progress/roadmap.md)):

```markdown
## Offene Wellen

*Derivativ* — Ziel, Trigger und Closure-Kriterien stehen in der Welle-Datei,
nicht hier.

- [welle-3-skalierung](../welle-3-skalierung.md)
```

Der Abschnitt trägt **zwei unabhängige Aussagen**. Die *Liste* folgt den
Dateien: ein Zeiger je offener Welle-Datei. Der Ruhe-Marker *Nichts in
Arbeit* folgt dem Anspruch: Er steht genau dann, wenn `in-progress/` keinen
Slice trägt — **zusätzlich zur Liste, nicht an ihrer Stelle**. Beides
zugleich ist der Normalfall direkt nach der
[Wellen-Eröffnung](#die-wellen-eröffnungs-prozedur): Die Welle ist eröffnet
(ihr Zeiger steht), beansprucht hat sie noch niemand (der Marker steht). Der
Marker sagt, was sein Wortlaut sagt — *nichts in Arbeit*, nicht *keine
offene Welle*.

Zwei Aussagen, zwei Wächter — und wer die Kopplung mechanisiert, muss
wissen, *welche* Hälfte sein Sensor prüft, sonst hält er einen halben
Wächter für einen ganzen. Die Marker-Hälfte ist die **deklarierte
Redundanz**: Ein Doku-Sensor hält den Marker gegen das Verzeichnis, und zwar
in **beide** Richtungen — ein fehlender Marker bei leerem `in-progress/` und
ein stehengebliebener Marker bei beanspruchtem Slice sind derselbe Defekt.
Die Listen-Hälfte ist kein Marker-Vergleich, sondern eine **Bijektion**: die
im Abschnitt genannten Wellen-Kennungen gegen die flachen Welle-Dateien,
ebenfalls in beide Richtungen — ein Zeiger ohne Datei und eine Datei ohne
Zeiger sind derselbe Defekt. Sie hat eine Vorbedingung, die der Marker nicht
hat: Der Sensor muss das **Kardinalitäts-Modell** kennen. Ein Wächter, der
den Abschnitt gegen *genau eine* Datei hält (Ein-Wellen-Betrieb), meldet
unter *Offene Wellen* legitime Zustände als Drift — zwei offene Wellen, oder
eine Welle eröffnet und nichts beansprucht (Zeiger und Marker nebeneinander);
gemessen im Kurs-Lab: [`lab/team-sim`](../../../lab/team-sim/README.md),
Szenarien s04b und s04g gegen s04e und s04h. Der Ruhe-Marker geht in die
Bijektion **nicht** ein; er bleibt Sache des Marker-Wächters. Wer eine Hälfte
ungewächtert lässt, benennt die Lücke — bekannt ist sie zulässig,
verschwiegen nicht. Vorbild aus dem Lab (werkzeugspezifisch): der
`planning`-Block in
[`lab/example/.d-check.yml`](../../../lab/example/.d-check.yml) hält beide
Hälften.

Das *Geplante Ende* in der Welle-Datei *erscheint* als Schätzung — es
triggert nichts, es prognostiziert. Wenn die Schätzung kippt, kippt sie als
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

Ein erreichter Meilenstein bleibt in der Tabelle: `Status` sagt *erreicht* mit
Datum und Beleg (Schritt 6).

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

**Was die Register tragen — und was nicht.** Die drei rückblickenden Stellen
der Roadmap beantworten je genau eine Frage. Das Closure-Log sagt, *was*
geschlossen ist: Welle, Datum, Zeiger auf die Ergebnis-Notiz — und es ist das
einzige Closure-Log der Roadmap. Das Drift-Log
sagt, *was umgeplant* wurde — ein Trigger verschoben, präzisiert oder ersetzt,
ein Slice oder eine Welle umgehängt — und sonst nichts: Eine Schließung ist
keine Umplanung, ein erreichter Meilenstein auch nicht; für den sagt die
`Status`-Spalte der Meilenstein-Tabelle *erreicht* mit Datum und Beleg. Wer
Schließungen oder Meilensteine ins Drift-Log schreibt, führt ein zweites
Closure-Log, und zwei Logs driften. Und jede `Stand`-/`Status`-Zelle — in der
Roadmap wie im Beobachtungs-Register — trägt den Zustand und den Beleg als
auflösbaren Anker, nie die Chronik
([`harness-dateien.md` §Was ein Kommentar trägt](../grundlagen/harness-dateien.md#was-ein-kommentar-trägt--code-konfiguration-skripte),
*Dieselbe Regel für Zustandsfelder*): *„verkörpert in `AGENTS.md` §2.7
(`seit welle-1`)"* ist eine Zustandszelle; ein Absatz darüber, wie die Regel
entstand, ist Herkunfts-Prosa im Rumpf.

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
([`begriffe.md` §Kernbegriffe](../grundlagen/begriffe.md#kernbegriffe)).
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
beantwortet "was läuft gerade" autoritativ und ohne Pflegeaufwand — gelesen auf
dem **Hauptzweig**: Der Übergang hierher landet dort, vor der Arbeit
([Modul 5 §Lifecycle als State Machine](modul-05-planning-harness.md#lifecycle-als-state-machine)). Ein
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
Closure-Notiz §7 wie jeder andere **und trägt seine Beobachtungen ins
[Beobachtungs-Register](#das-beobachtungs-register) ein** — der Zähler
unterscheidet nicht nach Welle-Zugehörigkeit. Damit zählt
der Steering Loop weiter vollständig und offene Risiken finden ihren Ausgang.

**Was offen bleibt.** Das ist genau eine Sache: die
**Carveout-Frist**. Sie misst in Wellen („seit > 2 Wellen aktiv",
[Modul 7](modul-07-carveouts.md)). Wer lange wellenlos arbeitet, dehnt sie
damit — ein Carveout steht dann bei „0 Wellen aktiv", obwohl Monate vergangen
sind. Für sie gibt es keinen wellenlosen Ersatz-Träger; das bleibt eine
benannte Lücke.

**Was der wellenlose Betrieb selbst auslöst.** Alles, was am Slice hängt — und
der Slice bleibt, auch wenn keine Welle läuft.

**Erst die Achse klären, sonst greift die Tabelle daneben.** *Wellenlos* ist
eine Eigenschaft des **Repos**, nicht des einzelnen Slice: Ein Repo arbeitet
mit Wellen und Slices, oder nur mit Slices. Das Kopf-Feld `**Welle:**` eines
Slice-Plans sagt etwas anderes — ob *dieser* Slice in ein Bündel gehört —, und
daraus folgt für die Vorgänge unten **nichts**. Ein Repo mit Wellen hat eine
Welle-Closure; die liest und prüft alles, was seit der letzten Welle in `done/`
gelandet ist, **auch Slices ohne Wellen-Zugehörigkeit**. Erst wenn es gar keine
Wellen gibt, fehlt dieser Sammelpunkt — und dann greift die Tabelle:

| Vorgang | Träger im Repo **ohne** Wellen | Wann |
|---|---|---|
| **Zähler** | Slice-Closure §7 | vor dem `git mv` nach `done/` |
| **Lese-Schritt** (was hat 3× erreicht → verkörpern) | Slice-Closure §7 | vor dem `git mv`; der Herkunfts-Anker lautet dann `seit slice-<NNN>` statt `seit welle-<NN>` |
| **Sichtungs-Schritt** (offene Beobachtungen unter der Schwelle) | Slice-**Planung**, §8 *Vorgelagert — offene Beobachtungen sichten* | beim Anlegen jedes Slice, unabhängig vom Sub-Area-Modus |
| **Trigger-Audit** (Carveout · Bootstrap-aware Gate · ADR) | Slice-Closure | bei jeder Closure, zusammen mit dem Lese-Schritt |
| **Alle drei Paarungen** (a/b/c aus Closure-Schritt 3) | Slice-Closure | **nach** dem `git mv` — die Paarungen suchen in `done/`, vorher liegt die Datei dort nicht |

Ohne den Lese-Schritt bliebe ausgerechnet der einzige Fall ungeprüft, in dem
`seit slice-<NNN>` überhaupt entsteht, und eine `BEO-<NNN>` ohne Registerzeile
fiele nie auf. Ohne den **Sichtungs-Schritt** hätte alles *unter* der Schwelle
gar keinen Leser mehr: In einem Repo mit Wellen trägt ihn die Wellen-Eröffnung
Schritt 2 (§Die Wellen-Eröffnungs-Prozedur) — im Repo ohne Wellen findet die
nicht statt, und das Register wäre unterhalb von 3× write-only. Und der
**Trigger-Audit** braucht seinen Moment genauso wie die Paarungen: „eigenständig
ausgelöst" ohne benannten Zeitpunkt ist selbst ein Trigger ohne Wächter.

Der Fehlgebrauch, den diese Regel verhindert, ist beobachtet: Wer das
Format für vollständig hält, presst den einzelnen Slice in eine
Pseudo-Welle oder trägt ihn in die Roadmap ein — bis der Abschnitt
seitenlang ist und gleichzeitig meldet, dass nichts in Arbeit ist.

## Das Beobachtungs-Register

Der Zähler des Steering Loops braucht einen Ort, der **zwischen** den Wellen
überlebt. Er liegt als stehende Datei flach im Planning-Layout, neben den
offenen Wellen:

```text
docs/plan/planning/observations.md
```

Ziel-Form:
[`../../../lab/templates/docs/plan/planning/observations.template.md`](../../../lab/templates/docs/plan/planning/observations.template.md).

**Warum stehend und nicht in der Welle-Closure.** Eine Sektion, die von
Closure zu Closure weitergereicht wird, hängt an einer ungebrochenen Kette:
Wer die Übernahme vergisst, setzt den Zähler auf null; die erste Welle braucht
eine Sonderregel; und wer über längere Zeit keine Welle eröffnet, hat gar
keinen Träger. Ein fester Ort streicht alle drei Fälle — die Datei existiert ab
Repo-Beginn, unabhängig davon, ob je eine Welle geschnitten wurde.

**Form.** Sechs Spalten; die Kennung ist die erste, die letzte trägt den
Verbleib — Zustand und Beleg als Anker, keine Chronik (Schritt 6):

```markdown
<!-- Auszug: BEO-002 bis BEO-004, BEO-006 und BEO-007 hier weggelassen -->
| Kennung | Beobachtung | Sub-Area | Zähler | Belege | Stand |
|---|---|---|---|---|---|
| BEO-001 | Golden-Set-Case ohne Boundary-Anteil aufgenommen | Replay-/Eval-Infrastruktur | 2× | slice-005, slice-011 | offen |
| BEO-005 | Tie-Break in sortierender Operation nicht explizit dokumentiert | Implementierung | 3× | slice-006, slice-009, slice-012 | verkörpert in `AGENTS.md` §2.7 (`seit welle-1`) |
```

**Die Sub-Area-Spalte** trägt die Sub-Area, deren Konventions-Härte oder
Inventur-Linie die Beobachtung betrifft — **nicht** die, in deren Verzeichnis
sie aufgefallen ist. Das ist dieselbe Berührungs-Frage wie beim §8-Block des
Slice-Plans ([`bootstrap.md` §Was ist eine Sub-Area?](../grundlagen/bootstrap.md#was-ist-eine-sub-area)),
nur rückwärts gestellt. Eine Lücke im Golden Set, die beim Schreiben eines
Tests auffällt, gehört zur *Replay-/Eval-Infrastruktur*, nicht zur
*Test-Infrastruktur*: dort steht die Konvention, die sie verletzt.

Die Spalte ist damit kein Ablage-Ort, sondern eine Aussage — und eine, die
sich prüfen lässt, sobald das Repo seine Sub-Areas deklariert hat
(`harness/conventions.md`). Steht in der Spalte ein Name, den die
Modus-Deklaration nicht führt, ist entweder die Zuordnung falsch oder die
Deklaration unvollständig; beides gehört gesehen.

Eine zweite Sektion **Gestrichene Einträge** nimmt auf, was nicht mehr auftreten
kann — mit Begründung. Wer eine Zeile still löscht, macht sie ununterscheidbar
von einer, die es nie gab.

**Und wenn nichts offen ist?** Dann trägt die Tabelle `— keine —` und bleibt
stehen. Die Tabelle zu löschen wäre dieselbe Auslöschung eine Ebene höher:
*nichts beobachtet* ist danach nicht mehr von *nie geführt* unterscheidbar.
Die leere Liste **ist** die Aussage — und sie ist die, mit der jedes Repo
anfängt.

**`BEO-<NNN>` ersetzt die Namens-Disziplin.** Ohne Kennung muss die
*Bezeichnung* über Wellen hinweg wortgleich bleiben, sonst zählt man zwei
Namen für dieselbe Sache getrennt und keiner erreicht je 3×. Mit Kennung wird
beim Erstauftreten einmal benannt und eine ID vergeben; jedes Wiederauftreten
zitiert die ID. Umformulierungen ändern dann nur noch das Label, nicht die
Zählung. Das Register ist zugleich die Vergabestelle — ein Henne-Ei-Problem
entsteht nicht.

**Wer schreibt, wer liest.** Eingetragen wird bei der **Slice-Closure** — von
dem, der die Beobachtung gerade notiert hat und im Register nachsehen kann, ob
es sie schon gibt: neuer Eintrag mit neuer `BEO-<NNN>`, oder Zähler erhöhen und
Beleg ergänzen. **Das ist der Punkt, an dem der Zähler von der Welle unabhängig
wird** — er läuft mit jedem geschlossenen Slice, ob dieser zu einer Welle gehört
oder nicht.

**Gelesen wird an zwei Stellen, nicht an einer.** Die **Welle-Closure** liest,
was 3× erreicht hat — das ist der *Lese-Schritt*, und er verkörpert. Die
**Slice-Planung** liest, was darunter steht — das ist der *Sichtungs-Schritt*
(§8 des Slice-Plans, [Modul 5](modul-05-planning-harness.md#zwei-schritte-vor-der-modus-begründung)),
und er hält die Einträge unter der Schwelle am Leben. Wer nur den ersten
kennt, hat ein Register, in dem alles unter 3× nie wieder angesehen wird —
und damit einen Zähler, der zählt, aber nichts steuert.

**Was Maschine kann und was nicht.** Das Urteil — *ist das dieselbe
Beobachtung wie beim letzten Mal?* — fällt beim Schreiben, durch den
Menschen, der die `BEO-<NNN>` vergibt oder zitiert. Keine Maschine kann es
ersetzen. Was sie kann, ist die **Deckung prüfen**: Die Closure-Notizen in
`done/` tragen ein festes Label, ihre Herkunft ist der Dateiname, und ob eine
dort zitierte Kennung im Register existiert, ist mechanisch entscheidbar.

Daraus folgt eine Arbeitsteilung:

1. **Schreiben** — Mensch, bei der Slice-Closure: Kennung vergeben oder
   zitieren, Zähler und Beleg fortschreiben.
2. **Committen** — das Register liegt im Repo und ist lesbar, ohne es zu bauen.
3. **Prüfen** — ein Gate meldet, wenn eine in `done/` zitierte `BEO-<NNN>`
   keine Registerzeile hat oder eine Registerzeile keinen Beleg. Das ist die
   maschinelle Hälfte der Register-Paarung (c) aus der Welle-Closure. Damit die
   zweite Hälfte mehr ist als eine Nicht-leer-Prüfung, ist der **Beleg
   formgebunden** — drei Prüfungen, die ohne Urteil auskommen:
   **Form** (die Kennung eines abgeschlossenen **Vorgangs**, kein Freitext) ·
   **Anzahl** (so viele Belege, wie der Zähler behauptet) ·
   **Lage** (führt das Repo die genannte Datei, liegt sie dort, wo ihre Klasse
   abgeschlossen wird — für den Regelfall Slice also in `done/`).

   > **Wann die Lage-Prüfung läuft — und warum das nicht beliebig ist.** Der
   > Beleg wird **vor** dem `git mv` geschrieben, und die Hard Rule *git mv +
   > Inhaltsänderung = zwei Commits* erzwingt, dass der `mv` ein eigener Commit
   > ist. Auf dem Schreib-Commit liegt die frisch belegte Slice-Datei also noch
   > nicht in `done/` — ein Sensor, der dort prüfte, meldete bei **jeder**
   > korrekt ausgeführten Closure rot. Die Lage-Prüfung gehört deshalb zur
   > Register-Paarung (c) und läuft mit ihr **nach** dem `git mv`, wie die
   > beiden anderen Paarungen auch. Form und Anzahl sind davon unabhängig; sie
   > prüfen den Registereintrag, nicht die Ablage.

   > **Ein Vorgang zählt einmal — und was keinen hat, zählt gar nicht.** Der
   > Regelfall eines Belegs ist die Slice-Kennung; auch eine Welle und ein
   > Review-Report sind abgeschlossene Vorgänge und taugen als Beleg. Zwei
   > Funde **im selben** Vorgang sind dagegen *eine* Gelegenheit, kein zweites
   > Auftreten: Der Zähler misst Wiederholung über Vorgänge hinweg, nicht die
   > Zahl der Funde — ein zweites Mal derselbe Kopf, derselbe Kontext, dieselbe
   > Sitzung belegt nichts über die Hartnäckigkeit des Phänomens. Und ein
   > Vorkommen **ohne** abgeschlossenen Vorgang — beim Lesen von Code, im
   > Gespräch, bei einer Freigabe — bekommt keinen Beleg und bewegt den Zähler
   > nicht. Es gehört trotzdem in den Eintrag: *benannt, nicht gezählt.* Der
   > Preis ist ein Zähler, der langsamer steigt als das Phänomen auftritt; der
   > Gegenwert ist einer, der nie mehr behauptet, als seine Belegliste trägt.

   > **Grenze — ehrlich benannt:** Die *Existenz* der Datei wird **nicht**
   > verlangt. Ein Repo darf Slices führen, die es nicht als Plan-Datei ablegt
   > (ältere Arbeit, importierter Bestand); ein Sensor, der sie einforderte,
   > liefe auf jedem gewachsenen Repo rot und wäre selbst das, wogegen er
   > gebaut ist. Damit bleibt ein erfundenes `slice-999` unentdeckt — das ist
   > die Grenze der Deklaration, dieselbe wie beim Anker-Sensor
   > ([`traceability.md` §Herkunfts-Anker](../grundlagen/traceability.md#herkunfts-anker-für-steering-loop-regeln)),
   > und sie gehört benannt statt überspielt.

*Welches* Werkzeug das ist, legt der Kurs nicht fest — das ist eine
Repo-Entscheidung wie die Wahl des Doku-Gates. Das Muster — von Hand
geschrieben, committet, per Gate auf **Deckung** geprüft — ist dasselbe, das
einen Carveout-Index oder einen ADR-Index ehrlich hält.

**Bei 3×** verlässt der Eintrag das Register nicht still: Er wandert in die
Steering-Loop-Einträge der laufenden Welle-Closure und wird dort zur
verkörperten Regel — mit Herkunfts-Anker
([`traceability.md` §Herkunfts-Anker](../grundlagen/traceability.md#herkunfts-anker-für-steering-loop-regeln)).
Ohne Wellen-Betrieb geschieht dasselbe beim Lese-Schritt, den dann die
Slice-Closure selbst auslöst (§Wann Arbeit eine Welle braucht); der Anker
lautet dann `seit slice-<NNN>`.

**Und der Stand wird dabei zu einem von drei Ausgängen** — dieselbe
geschlossene Menge wie beim offenen Risiko
([Modul 5 §Offene Risiken](modul-05-planning-harness.md#offene-risiken-werden-bei-closure-aufgelöst)),
eine Ebene höher:

| Ausgang | Wann | Wohin |
|---|---|---|
| **verkörpert** | die Regel steht | Zielort **und** Herkunfts-Anker (`seit welle-<NN>` bzw. `seit slice-<NNN>`) |
| **geplant** | die Regel ist beschlossen, aber noch nicht geschrieben | Kennung des Slice oder der Welle, die sie schreibt — mit ID, wie beim Risiko-Ausgang *eingetreten* |
| **gestrichen** | die Beobachtung kann nicht mehr auftreten | §Gestrichene Einträge, **mit Begründung** |

Unterhalb der Schwelle ist `offen` der Stand — dort ist er kein Ausgang,
sondern der Normalzustand. **Nur zwei der drei hängen an der Schwelle:**
*verkörpert* und *geplant* sind ihre Antwort. *Gestrichen* steht jederzeit
offen — fällt die Ursache weg, bevor der Zähler 3 erreicht, wandert die Zeile
mit Begründung in §Gestrichene Einträge, statt als *offen* weiterzuzählen für
etwas, das nicht mehr auftreten kann.

**Warum es einen dritten Ausgang braucht.** Die Schwelle fällt nicht immer
dort, wo die Regel geschrieben werden kann: Sie kann mitten in einer Welle
fallen, oder die fällige Regel braucht einen eigenen Slice. Ohne *geplant*
bliebe nur, den Eintrag `offen` stehen zu lassen — dann ist die Schwelle
folgenlos — oder eine Verkörperung zu behaupten, die es noch nicht gibt.
*Geplant* ist deshalb ein Ausgang **mit Kennung**, kein Vorsatz: Ein Stand,
der nur „wird gemacht" sagt, ist derselbe Freitext, den die drei Ausgänge
gerade ersetzen.

**Was Maschine hier kann** — dieselbe Trennung wie beim Risiko. **Urteilsfrei**
ist, *dass* ein Eintrag ab 3× einen Ausgang trägt, *welcher der drei* es ist,
und ob die genannte Kennung im Repo auflöst: Die drei sind eine geschlossene
Menge, kein Freitext. **Urteil** bleibt, ob der Ausgang trägt — ob die
Verkörperung das Phänomen wirklich deckt, ob die Beobachtung wirklich nicht
mehr auftreten kann.

Im Register bleibt die Zeile mit dem Vermerk stehen, wohin sie ging; gestrichen
wird nur mit Begründung, warum die Beobachtung nicht mehr auftreten kann.

## Die Wellen-Eröffnungs-Prozedur

Die Closure-Seite ist unten in fünf Schritten ausbuchstabiert — die
Eröffnung braucht drei, und der mittlere ist der, den Teams zuerst
weglassen:

1. **Welle-Ziel, Out-of-Scope und Closure-Trigger festlegen.**
   Beobachtbare Bedingung, kein Datum (§Roadmap-Regeln). Erst danach
   werden Slices zugeordnet — sonst schneidet die Slice-Liste das Ziel
   statt umgekehrt. **Out-of-Scope gehört dazu**: dieselbe Disziplin wie
   im Lastenheft ([Modul 3](../01-spec-und-architektur/modul-03-spec.md))
   und im Slice-Plan ([Modul 9](../03-agenten/modul-09-implementierung.md))
   — was nicht ausdrücklich ausgeschlossen ist, wandert im Zweifel in die
   Welle und dehnt sie, bis der Closure-Trigger unerreichbar wird.
2. **Offene Beobachtungen sichten.** Das Register
   [`docs/plan/planning/observations.md`](#das-beobachtungs-register) wird
   durchgegangen: Betrifft eine davon die Sub-Areas, die diese Welle
   berührt? Dann gehört sie in die Slice-Planung — entweder als Risiko im
   betroffenen Slice ([Modul 5 §Sub-Area-Modus-Begründung](modul-05-planning-harness.md#worked-mini-example-bootstrap-modus-pro-sub-area-für-einen-slice-begründen))
   oder, wenn sie mit dieser Welle 3× erreicht, als eigener Slice, der die
   Lücke schließt. **Das ist der Schritt, der das Register auf der
   Planungsseite konsumiert** — ohne ihn bleibt es dort ohne Leser, und was
   gezählt wurde, erreicht nie die Slice-Planung. **Ohne Wellen-Betrieb trägt
   ihn die Slice-Planung selbst** (§8 des Slice-Plans, Block *Vorgelagert —
   offene Beobachtungen sichten*, unabhängig vom Sub-Area-Modus) — sonst hätte
   in einem wellenlosen Repo alles unter der Schwelle keinen Leser.
   **Bei der ersten Welle entfällt dieser Schritt nicht** —
   das Register existiert ab Repo-Beginn und ist durch die bis dahin
   geschlossenen Slices bereits gefüllt, auch die wellenlosen. Ist es leer,
   ist *das* die Antwort und wird notiert.
3. **Welle-Datei flach anlegen** (`docs/plan/planning/<welle-id>.md`,
   Ziel-Form [`welle.template.md`](../../../lab/templates/docs/plan/planning/welle.template.md))
   **— ihre Zeile verlässt *Nächste Wellen*, unter *Offene Wellen* steht der
   Zeiger auf die Datei.** Der Zustand ist die Verzeichnis-Position, nicht ein
   Status-Feld. Ein etwaiger Ruhe-Marker **bleibt dabei stehen**: Die Welle ist
   eröffnet, beansprucht ist sie erst mit dem ersten Slice in `in-progress/`
   (§*Offene Wellen* — zwei unabhängige Aussagen).

**Was hier bewusst *nicht* passiert:** Der Implementer-Agent bekommt
`done/` nicht in seinen Lauf-Kontext. Schritt 2 ist eine
*Planungs*-Leistung — was die Schwelle erreicht hat, ist ohnehin in
AGENTS.md, Gates und Skills verkörpert und wirkt dort automatisch
(Modul-0-Prinzip: *Per-Lauf-Relevantes gehört verkörpert, nicht extern
nachgeladen*). Ein Archiv pro Lauf zu laden wäre Kontext-Verschwendung
für Wissen, das schon wirkt.

## Die Wellen-Closure-Prozedur

> **Wer führt die Schritte aus?** Die Eröffnung ist Planner-Arbeit, die Closure
> hat fünf Übergaben in drei Zügen — Träger und Übergabe-Artefakt für **jeden**
> der fünf Schritte stehen in
> [Modul 8 §Rollen-Sequenz für eine Welle](../03-agenten/modul-08-agentenrollen.md#rollen-sequenz-für-eine-welle).
> Dort und nicht hier, weil die sechs Rollen erst in Modul 8 eingeführt werden.

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
   | **ADR** ([Modul 4](../01-spec-und-architektur/modul-04-adrs.md)) | Re-Evaluierungs-Trigger | Entscheidung neu bewerten → bestätigt oder Folge-ADR mit `supersedes` |

   Eine Welle darf *mit* dokumentiertem Carveout schließen — aber nie mit
   einem stillen roten Gate, einer stehengebliebenen Reifestufe oder einer
   Entscheidung, deren Re-Evaluierungs-Bedingung vor drei Wellen eintrat.
   Der Kurs benannte diese Pathologie bisher nur für Carveouts
   (*Carveout-Wildwuchs*, [`klassifikation.md`](../grundlagen/klassifikation.md#entropy-management));
   sie gilt für alle drei Klassen — **ein Trigger ohne Wächter ist eine
   Absichtserklärung mit Verfallsdatum.**

3. **Welle nach `done/` schließen.** *Grundlage ist das
   [Beobachtungs-Register](#das-beobachtungs-register)* — nicht die einzelnen
   Closure-Notizen. Dort steht der Zähler bereits, fortgeschrieben von jeder
   Slice-Closure seit Repo-Beginn, wellenlose eingeschlossen. Die Welle-Closure
   ist der **Lese-Schritt**: Welche Einträge haben **3×** erreicht? Die werden zu
   *Steering-Loop-Einträgen* und verkörpert; im Register bleibt die Zeile mit dem
   Vermerk stehen, wohin sie ging. Was darunter liegt, bleibt offen und wartet.
   **Ohne diesen Lese-Schritt ist das Register write-only** — gezählt würde
   weiter, aber nichts würde je zur Regel.
   Die Closure-Notiz
   `done/welle-NN-results.md` hält fest, *was gelernt wurde*: geliefert · was
   funktionierte · was anders lief · **Steering-Loop-Einträge** (geschärfte
   Regel / neuer Sensor / benannte Spec-Lücke) · Zeiger aufs
   **Beobachtungs-Register** · Folge-Slices (*derivativ* — der Folge-Slice
   selbst ist eine Datei in `open/`, die Liste zeigt nur darauf) · Verifikation (die Belege aus
   Schritt 1). Ohne
   Lerneintrag ist die Welle nicht „fertig", sondern nur „weg"
   ([Modul 1](../01-spec-und-architektur/modul-01-entwicklungszyklus.md)).
   Ziel-Form: [`/lab/templates/docs/plan/planning/welle-results.template.md`](../../../lab/templates/docs/plan/planning/welle-results.template.md).

   **Und die Welle-Plan-Datei wandert per `git mv` von flach nach `done/`** —
   neben ihre Ergebnis-Notiz. Der Zustand ist die Verzeichnis-Position, kein
   `Status`-Feld (wie beim Slice, [Modul 5](modul-05-planning-harness.md)): offene
   Wellen liegen flach unter `docs/plan/planning/`, geschlossenes
   Planungs-Material in `done/`, und die Roadmap bleibt die
   Sequenzierungs-Autorität — so füllt sich der Ordner nicht mit Abgeschlossenem.

   **Warum der Zähler ein eigenes Artefakt ist.** Der
   Steering Loop zählt *1× notieren · 2× Symptom · 3× Lücke*
   ([`klassifikation.md`](../grundlagen/klassifikation.md#steering-loop)) —
   das setzt ein Gedächtnis über Läufe hinweg voraus. Was die Schwelle
   erreicht hat, ist bereits **verkörpert** (AGENTS-Regel, Gate, Skill) und
   wirkt von selbst weiter. Was *darunter* liegt, ist nirgends verkörpert:
   ohne eigenes Register versickert es in der Closure-Prosa, und der Zähler
   fängt mit jeder Welle bei null an. Ein Fehler, der einmal pro Welle
   auftritt, wäre nach fünf Wellen eine 5×-Lücke, die niemand je als Lücke
   sieht. Deshalb steht der Zähler außerhalb der Closure, im
   Beobachtungs-Register (§Das Beobachtungs-Register): Er wird bei jeder
   Slice-Closure fortgeschrieben, nicht von Closure zu Closure kopiert.

   **Zum Schluss alle drei Paarungen prüfen** — erst *jetzt*, weil sie die
   Einträge prüfen, die in diesem Schritt gerade entstanden sind; in
   Schritt 2 gäbe es sie noch nicht. (Die Closure-Notiz wird direkt nach
   `done/` geschrieben — sie muss nicht erst wandern; der `git mv` oben
   betrifft die Welle-*Plan*-Datei, die keine Paarung trägt.) Alle drei folgen
   dem Muster *Nennung
   ohne Deckung ist eine Harness-Lüge*: (a) **Anker-Paarung** — ausgelöst
   durch das Pflichtfeld `liegt in <Zielort>`, **innerhalb dieser Sektion**
   und nicht durch die Semantik des Eintrags (der Trigger-Sprachgebrauch
   „`slice-024` liegt in `done/`" aus §Roadmap-Regeln löst also nichts aus):
   Wo das Feld steht, existiert der Zielort und trägt
   `seit welle-<NN>` bzw. `seit slice-<NNN>`. Ein Eintrag **ohne** dieses
   Feld ist *gezählt, nicht verkörpert* und kein Gegenstand der Paarung.
   Die **benannte Spec-Lücke** ist der eine Fall, der ohne Feld trotzdem
   verkörpert ist — nur in einer versionierten Spec statt an einem Zielort;
   ihr Gegenstück ist die `LH-*`-ID
   ([`traceability.md` §Herkunfts-Anker](../grundlagen/traceability.md#herkunfts-anker-für-steering-loop-regeln));
   (b) **Folge-Slice-Paarung** — jeder genannte Folge-Slice existiert als
   Datei **im Planning-Lifecycle** (`open/`, `next/`, `in-progress/`,
   `done/`) — nicht nur in `open/`: bis zur Prüfung kann er bereits
   weitergewandert sein, der Zustand ist die Verzeichnis-Position.
   (c) **Register-Paarung** — zwei Hälften: jede in einer Closure-Notiz oder
   in einem Risiko-Ausgang genannte `BEO-<NNN>` existiert als Zeile im
   Beobachtungs-Register, **und** jede Registerzeile trägt mindestens einen
   Beleg. *Nicht* geprüft wird die Umkehrung „jede Zeile ist irgendwo
   zitiert" — die allermeisten stehen unter der Schwelle und sind nirgends
   zitiert; ein Sensor, der das verlangte, liefe auf jedem gesunden Register
   rot. Rot heißt in allen drei Fällen: etwas wurde
   versprochen und nicht angelegt — dieselbe Klasse wie ein halluziniertes
   Gate.
4. **Wave-Self-Close-Commit.** Ein einzelner, beobachtbarer Commit
   markiert den Abschluss — der Audit sieht *einen* Punkt, an dem die
   Welle schloss, statt eines verstreuten Verschwindens.
5. **Roadmap fortschreiben.** Die Welle bekommt ihre Zeile in der Tabelle
   *Abgeschlossene Wellen* (mit Zeiger auf ihre Closure-Notiz), ihr Zeiger
   verlässt *Offene Wellen*. **Befördert wird niemand**: Welche Wellen offen
   sind, sagen die flachen Dateien; woran gearbeitet wird, das `Welle:`-Feld
   der Slices in `in-progress/`. Löste ein Trigger eine Umplanung aus, bekommt
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
* **(Analysieren — aktiviert LZ 2)** *Wo landet die Beobachtung?* Ein Slice
  schließt und notiert in §7: „Golden-Set-Case ohne Boundary-Anteil
  aufgenommen." Im Register steht `BEO-001` mit derselben Beobachtung bei 2×.
  (a) Was trägst du wo ein? (b) Der Slice gehörte zu keiner Welle — ändert das
  etwas? (c) Der Eintrag steht danach bei 3×, aber die nächste Welle-Closure ist
  Wochen entfernt: Was passiert bis dahin, und was ist der Unterschied zwischen
  *gezählt* und *verkörpert*?
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
  Steering-Loop-Eintrag landet, wenn er zu keiner Welle gehört.
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
* **(Erschaffen — aktiviert LZ 1)** Gegeben drei Slices `slice-101` (API), `slice-102` (Cache, braucht die API), `slice-103` (Dashboard): entwirf den *ersten* Wellen-Eintrag als kompletten Mini-Block — Slice-IDs, *einen* beobachtbaren Trigger (kein Datum) und *ein* Closure-Kriterium. Begründe in einem Satz, warum genau diese Slices in *einer* Welle liegen und nicht über zwei verteilt sind.
* **(Analysieren — aktiviert LZ 2)** Warum steht der Steering-Loop-Zähler in
  einer eigenen Datei und nicht in der Welle-Closure? Nenne die Bruchstelle,
  die das behebt — und sag, wer einträgt und wer liest.
* **(Analysieren — aktiviert LZ 4)** Welle 3 (`welle-3-skalierung`) kann erst starten, wenn Welle 2 (`welle-2-qualitaet`) fertig ist: Wie modellierst du diese Abhängigkeit *im Roadmap-Eintrag* von Welle 3 — und woran genau erkennst du, dass Welle 2 zum *Blocker* wird (nicht bloß Vorgängerin)?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Drei Bestandteile eines Welle-Eintrags? | "Slices und Datum." | Slice-IDs (Inhalt) · Trigger als beobachtbare Bedingung (kein Datum) · Closure-Kriterien (z. B. Replay grün, alle Slices in `done/`). | + Datum darf *erwähnt* werden (Prognose), darf aber nie Trigger sein — sonst kappt die Welle halbfertige Slices am Kalendertag und das Auditierbarkeits-Versprechen bricht. |
| Drei beobachtbare Trigger-Beispiele? | "Wenn etwas fertig ist." | Drei aus dem Modul: "slice-024 liegt in `done/`" · "Replay-Lauf gegen Golden Set grün" · "Carveout `CO-007` aufgelöst". | + Pointe: ein Trigger ist beobachtbar dann, wenn ein *anderer* Mensch ohne Rückfrage sagen kann, ob er eingetreten ist. "Sobald wir Zeit haben" scheitert daran; "slice-024 in `done/`" besteht. |
| Welle 30 % über Schätzung — was tun? | "Mehr Zeit geben." | Diagnose vor Aktion: liegt es an Slice-Größe (→ neu schneiden), an Reihenfolge (→ neu planen), oder an unerwarteter Komplexität (→ Carveout)? | + Hinweis, dass 30 % früh ein Steering-Loop-Signal sein können (Slice-Sizing-Regel schärfen), 30 % spät (vor Welle-Closure) eher Carveout. Metakognitiv: die *eigene* Schätzunsicherheit als Steering-Signal benennen — woran hätte man die Abweichung früher erkannt (welches Slice war schon beim Schätzen "weich", welche Annahme blieb ungeprüft)? — damit die nächste Schätzung kalibrierter ausfällt. |
| Welle vs. Meilenstein? | "Größe." | Welle = Bündel paralleler/serialisierter Slices mit Closure-Kriterien. Meilenstein = extern beobachtbarer Zustand (Release, Audit-Punkt). | + Eine Welle endet *durch* Closure-Kriterien; ein Meilenstein endet durch *Datum oder externe Bestätigung* — und genau deshalb leitet sich der Meilenstein aus Wellen ab, nicht umgekehrt. |
| Braucht ein Tool-Pin-Slice eine Welle? | "Ein Slice ist zu klein für eine Welle." — Größen-Argument, zufällig richtig. | Nein, begründet über die **Closure-Bedingung**: Der Trigger könnte nur die DoD des Slice abschreiben, es fehlt das *Mehr*. Der Slice läuft ohne Welle und erscheint nicht in der Roadmap; sein Steering-Loop-Eintrag wird bei der **Slice-Closure** ins Beobachtungs-Register eingetragen, gelesen wird es bei der nächsten Welle-Closure. | + Gegenprobe am Größen-Argument: Ein *einzelner* Slice, dessen Abschluss zusätzlich einen grünen Replay-Lauf gegen das Golden Set verlangt, **ist** eine Welle — die Bedingung ist repo-weit und steht in keiner DoD. Wer „zu klein" antwortet, liegt hier falsch. |
| Drei `grid-gym`-Ereignisse Welle/Meilenstein/Release zugeordnet? | höchstens eine Zuordnung richtig, Trigger fehlen oder lauten "ist halt fertig". | (a) **Welle** — Trigger: Closure-Kriterien erfüllt (alle Slices in `done/`, Gates grün), beobachtbar am Wave-Self-Close-Commit. (b) **Meilenstein** — Trigger: extern beobachtbarer Repo-Zustand (Determinismus belegt), keine interne Closure nötig. (c) **Release** — Trigger: ein Artefakt verlässt das Repo in eine Umgebung (Tag + Staging). | + Begründung über die Orthogonalität: ein Release kann mehrere Wellen umfassen, der Meilenstein liegt *neben* der Welle (externe Bestätigung), die Welle endet *durch* Closure — deshalb kann (b) eintreten, ohne dass (a) oder (c) am selben Tag liegen. |
| Ersten Wellen-Eintrag aus `slice-101/102/103` entworfen? | Slices aufgelistet, aber Trigger ist ein Datum oder fehlt; kein Closure-Kriterium. | Vollständiger Mini-Block: Slice-IDs · *ein* beobachtbarer Trigger (kein Datum) · *ein* Closure-Kriterium; Bündelung begründet (z. B. "`slice-102` braucht `slice-101`, beide liefern erst zusammen prüfbaren Wert"). | + Schnitt-Begründung mit Gegenprobe: warum `slice-103` (Dashboard) *nicht* in dieselbe Welle gehört, wenn es ohne Cache keinen Mehrwert zeigt — und welcher Trigger es in die *nächste* Welle zieht. Der Entwurf nennt den Trigger so, dass ein Dritter ohne Rückfrage über "Welle fertig" entscheiden kann. |
| Warum steht der Zähler in einer eigenen Datei? | "Ist übersichtlicher." — Ordnungsargument, keine Mechanik. | Die Übernahme-Kette bricht an drei Stellen: vergessene Übernahme setzt den Zähler auf null, die erste Welle braucht eine Sonderregel, und ohne Welle gibt es gar keinen Träger. Eingetragen wird bei der **Slice-Closure**; gelesen an **zwei** Stellen — Welle-Closure (was hat 3× erreicht: *Lese-Schritt*) und Slice-Planung §8 (was steht darunter: *Sichtungs-Schritt*). | + Der Unterschied *gezählt* vs. *verkörpert*: Ohne Welle läuft der Zähler weiter; in einem Repo **ohne Wellen-Betrieb** löst die Slice-Closure den Lese-Schritt selbst aus, und der Anker lautet `seit slice-<NNN>` — und die `BEO-<NNN>` macht die Zählung unabhängig vom Wortlaut der Bezeichnung. |
| Abhängigkeit Welle 3 → Welle 2 modelliert, Blocker erkannt? | "Welle 3 kommt nach Welle 2." — Reihenfolge genannt, keine Modellierung. | Abhängigkeit als expliziter Abhängigkeits-Trigger in der `Trigger`-Spalte von Welle 3 (z. B. „startet, wenn `welle-2-qualitaet` in Closure") + gerichtete Kante im Abhängigkeitsgraphen. | + Blocker-Kriterium benannt: Welle 2 ist Blocker, sobald Welle 3 *ohne* deren Closure nicht starten kann (Phantom-Welle) — und der Test dafür: würde Welle 3 jetzt starten, liefe ein Gate auf nicht-property-getesteter Basis. Reine Vorgängerin ohne harte Kante wäre kein Blocker. |

## Weiterlesen

* Nächstes Modul: [Modul 7 — Carveout Management](modul-07-carveouts.md)
