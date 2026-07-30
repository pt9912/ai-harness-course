# Review-Runde 11 — offen

**Stand:** 2026-07-29. **Status:** noch kein Review-Lauf. Diese Datei sammelt,
Sie sammelt drei Dinge: was **vor** der Runde auffiel (`V11-01`, `V11-02` —
beide behoben), die **Befunde des Drei-Linsen-Reviews** (21 offen, 6 behoben)
und die übernommenen Ü-Posten (`Ü-02` behoben).

**Gegenstand, wenn die Runde läuft:** der Diff `5e061dc..HEAD` — die Nacharbeit
zu [Runde 10](review-runde-10.md) (dort abgelegt, vollständig behoben).

**Verfahrens-Vorgabe aus Runde 10:** Drei Reviewer mit getrennten Linsen und
getrenntem Kontext. Wer Break-Tests fährt, braucht ein **isoliertes Worktree** —
in Runde 10 hat ein schreibender Reviewer den Baum verschmutzt und ein anderer
die Verschmutzung als Befund gemeldet.

---

## Vorab-Befund — aus einer Nutzer-Frage, nicht aus einem Review-Lauf

### V11-01 — Der Slice-Zyklus hat eine Rollen-Sequenz, der Wellen-Zyklus keine ✅

Modul 8 trägt `## Rollen-Sequenz für einen Slice` (Quelle `:37`, Spiegel `:10`)
mit einem `sequenceDiagram` über sechs Teilnehmer und einer eigenen Sektion
*Die neun Übergaben und ihre Artefakte*. Die Regel dazu lautet: *„Ein
Rollen-Sprung ohne Artefakt ist der häufigste Pfad zu blinden Flecken."*

Die Wellen-Prozedur hat **drei Eröffnungs- und fünf Closure-Schritte** und
**keinen benannten Träger**. Die Rollen-Nennungen in Modul 6 sind vollständig
diese zwei — beide keine Zuweisung:

```
kurs/de/02-planung/modul-06-roadmap.md:83   | Trigger-Anker (Stakeholder) | Slice(s) (Implementer-Ebene) |
kurs/de/02-planung/modul-06-roadmap.md:489  Der Implementer-Agent bekommt … nicht
```

Im Spiegel `lab/regelwerk/modul-06-roadmap.md` genau eine, ebenfalls negativ
(`:139`).

**Warum das ein Befund ist und nicht eine Auslassung:** Die Schritte sind nicht
Planner-allein.

| Schritt | verlangt | plausibler Träger |
|---|---|---|
| Closure 1 | „`make gates` und der Replay-Lauf sind grün" | Verifier |
| Closure 2 | Trigger-Audit, **ADR**-Zweig | Architect („Architect entscheidet", Modul 8) |
| Closure 3 | Verkörperung in `AGENTS.md`, Gates, Skills | nicht Planner allein |
| Eröffnung 2 | Sichtung — „ist Planungs-Leistung" | Planner *(der einzige angedeutete)* |

Vier Kontexte, kein benannter. Nach dem eigenen Maßstab des Kurses ist das
dieselbe Klasse wie ein Artefakt ohne Konsumenten
([`konventionen.md` §Jedes Artefakt hat einen Konsumenten](../../kurs/de/grundlagen/konventionen.md#jedes-artefakt-hat-einen-konsumenten)):
**ein Schritt ohne Träger.** Und Modul 8 argumentiert ausdrücklich, dass
Rollen-Trennung Kontext-Trennung ist — eine Prozedur, die vier Kontexte berührt
und keinen benennt, lädt zum Ein-Kontext-Durchlauf ein.

**Warum es keiner der drei Reviewer in Runde 10 gefunden hat:** Sie suchten
Widersprüche. Das hier ist keiner — es fehlt etwas. Zwei strukturelle Gründe
verstecken es zusätzlich: Modul 6 kommt *vor* Modul 8 und kann die Rollen noch
nicht zuweisen; und Modul 8 legt seinen Scope im Titel offen („für einen
Slice"), wodurch die Lücke wie Absicht aussieht.

**Behoben — die Vorfrage war zu messen, nicht zu entscheiden.** Sie lautete:
Soll die Wellen-Prozedur überhaupt Rollen tragen? Antwort: Sie tut es schon, nur
unvollständig und an der falschen Stelle. Zwei Belege:

1. Die **Validator-Kanten sind bereits wellen-skopiert** — *„Validierung greift
   nach einem MVP-Slice und vor der Implementation größerer Wellen"* steht mitten
   in einer Sektion, die „für einen Slice" heißt.
2. **Jeder Closure-Schritt hat einen aus dem Kurs ableitbaren Träger.** Die
   Tätigkeits-Tabelle in [Lösung Modul 8](../../kurs/de/loesungen/modul-08-loesung.md)
   ordnet die beiden schwersten schon zu: *„Aktualisiere AGENTS.md mit einer
   neuen Hard Rule" → Architect (ADR-Folge) + Planner (Slice)* und *„Entscheide,
   ob `coverage-gate` 70 % oder 80 % verlangt" → Architect (ADR) + Planner*. Es
   war keine neue Norm zu erfinden, sondern eine unausgesprochene Folge
   aufzuschreiben — derselbe Fall wie R10-04.

Encodiert als [Modul 8 §Rollen-Sequenz für eine Welle](../../kurs/de/03-agenten/modul-08-agentenrollen.md#rollen-sequenz-für-eine-welle),
Spiegel nachgezogen, Vorwärts-Verweis an beiden Prozedur-Überschriften in
Modul 6. Die Eröffnung ist Planner-Arbeit **ohne Übergabe** — eine Aussage, keine
Leerstelle. Die Closure hat **fünf** Übergaben in drei Zügen, gegen neun auf
Slice-Ebene; die Schritt-Nummern sind die von Modul 6, alle fünf.

**Beide Sequenzen sind nötig, weil ein Repo auch ohne Wellen arbeiten kann.**
Ohne Wellen-Betrieb bleiben vier der fünf Übergaben (getragen von Slice-Closure
und Slice-Planung), und die **Verifier→Planner-Kante entfällt** — der repo-weite
Beleg über die Slice-DoDs hinaus *ist* das *Mehr*, an dem sich entscheidet, ob
eine Welle vorliegt. Rollen-Sequenz und Wellen-Kriterium sind damit dieselbe
Aussage aus zwei Richtungen.

---

### V11-02 — Die Zuordnungs-Einheit der Token-Attribuierung ist nicht benannt, und es gibt keinen Emissions-Pfad ✅

*(Aus einer Nutzer-Frage, in zwei Schritten geschärft. Zwei Hälften mit
derselben Wurzel: Modul 15 sagt nicht, **worauf** attribuiert wird — und das
Repo zeigt nicht, **wie** die Angabe dorthin kommt.)*

#### (a) „Kostenstelle" holt das Personen-Framing zurück, das Modul 8 verwirft

`kurs/de/03-agenten/modul-08-agentenrollen.md:403` (und `:244`, Spiegel `:128`):

> „Rollen-Trennung ist **Kontext**-Trennung, nicht **Personen**-Trennung. Eine
> Person kann mehrere Rollen spielen — aber nicht im selben Kontextfenster."

`kurs/de/05-betrieb/modul-15-observability.md:29` (Mini-Glossar) und `:222`
(Übungsauftrag), Spiegel `:45`:

> „Token-Attribuierung … Buchhaltungs-Splitting eines Sammelpostens auf
> **Kostenstellen**."

**Logisch tragen beide.** Ist eine Rolle ein Kontext, dann etikettiert
`agent.role` das Kontextfenster, und die Bilanz pro Rolle ist eine Bilanz pro
Kontext — wohldefiniert auch dann, wenn ein Mensch alle sechs Rollen nacheinander
spielt. **Kein Widerspruch, aber ein Leck:** *Kostenstelle* ist
Organisations-Vokabular (Team, Abteilung, Person). Modul 15 benennt nirgends,
dass die Zuordnungs-Einheit ein **Kontext** ist und kein Mensch. Verschärft
wurde das in Welle 60: Der Übungsauftrag zeigt seither auf „die Rollen sind die
aus Modul 8" — die Kopplung ist enger, Modul 8s Kontext-statt-Person-Klarstellung
reist aber nicht mit.

#### (b) Das Schema hat keine Lauf-Ebene, und niemand sendet es

`lab/example/otel/sl-009-agent-run.trace.json` trägt `agent.role` **pro Span**:

```
trace_id: trace-sl-009-agent-run     ← Trace-Ebene, trägt slice.id
  plan-1    agent.role: Planner
  impl-1    agent.role: Implementer
  impl-2    agent.role: Implementer
  review-1  agent.role: Reviewer
  verify-1  agent.role: Verifier
```

Ein Trace, der sich „agent-run" nennt, enthält damit **vier** Rollen. Als „ein
Lauf, vier Rollen" gelesen ist das genau die Modul-8-Verletzung; als „ein Slice,
mehrere Läufe" gelesen ist es richtig — dann fehlt aber die Ebene dazwischen.
Mit `agent.role` am Span und nichts zwischen Span und Trace ist „ein
Implementer-Lauf mit zwei Tool-Calls" nicht von „zwei Implementer-Läufen mit je
einem" zu unterscheiden; `impl-1` und `impl-2` stehen genau so nebeneinander.

**Die Struktur, die fehlt** — drei Ebenen:

| Ebene | Was sie ist | Trägt |
|---|---|---|
| Trace | der Slice — Korrelations-Einheit | `slice.id`, `requirement.refs`, `adr.refs` |
| **Run** | **das Kontextfenster = die Rolle** | `run.id` + `agent.role` |
| Span | ein Schritt im Lauf | *erbt* die Rolle, setzt sie nicht |

**Und niemand sendet etwas.** Gemessen:

```
$ grep -rn "OTEL_\|traceparent\|resourceSpans" kurs/ lab/
(null Treffer)
```

`lab/example/Makefile:36` (`agent-implement`) gibt fünf Dateinamen per `echo`
aus — es startet keinen Agenten und setzt keine Umgebung. Das Fixture ist
handgeschriebenes JSON in einer Form, die **kein OTLP** ist. Modul 15 lehrt
Span-Schema, Cache-Counter und Token-Attribution und sagt nichts darüber, wie
die Daten entstehen oder transportiert werden.

**Der Mechanismus, falls die Entscheidung „lehren" lautet** — zwei
Umgebungsvariablen, gesetzt vom Starter, gelesen vom SDK des Agenten-Prozesses:

- `OTEL_RESOURCE_ATTRIBUTES="agent.role=Implementer,run.id=…,slice.id=…"` —
  **spezifiziert** (General SDK Configuration). Das SDK hängt die Werte an die
  `Resource`; im OTLP-Protokoll steht sie **einmal pro `ResourceSpans`-Block**,
  nicht pro Span. Sie wird also übertragen, ohne jeden Span zu belasten.
- `TRACEPARENT="00-<trace>-<parent-span>-01"` — hängt den Lauf als Kind an den
  Slice-Trace. **Grenze: als Env-Var ist das Konvention, nicht Spec** — die
  W3C-Trace-Context-Spec definiert HTTP-Header. `otel-cli`, das Jenkins-OTel-Plugin
  und CI-Integrationen benutzen es so; der Kurs müsste es als Konvention
  deklarieren.

Der tragende Punkt: **Der Agent setzt seine Rolle nicht selbst.** Er erbt sie aus
der Umgebung, in die er gestartet wurde. Ein Agent, der `agent.role` pro Span
schreibt, ist die einzige Instanz, die dabei auch driften kann; ein Env-Var vom
Starter hat dieselbe Autorität, die den Kontext erzeugt hat.

**Grenze auch dieser Lösung, ehrlich:** Das Resource-Attribut macht das Label
vertrauenswürdig und Rollen-Mischung *innerhalb eines Laufs* strukturell
unmöglich (ein Prozess, eine Resource). Ob ein Lauf seine deklarierte Rolle
**einhält** — ob der als Implementer gestartete Lauf nicht doch reviewt —, sagt
das Label nicht. Das wäre eine andere Prüfung (Tool-Nutzung gegen deklarierte
Rolle) und ist hier nicht versprochen.

#### Zuerst zu entscheiden, nicht zu reparieren

Die Lab-Grenze ist bei Modul 15 **nicht benannt** — anders als beim Replay
(`lab/example/evals/golden/README.md:29` §Lab-Grenze) oder beim Coverage-Gate
(`CO-001` §Offen). Ein Adopter, der Modul 15 durcharbeitet, hat am Ende ein
Schema und keinen Weg, es zu befüllen. Drei Wege:

1. **Emissions-Pfad lehren** — Modul 15 bekommt die Drei-Ebenen-Struktur und die
   zwei Env-Vars, das Fixture eine Lauf-Ebene, `TRACEPARENT` seine
   Konventions-Grenze. Teuerster Weg, aber der einzige, nach dem ein Adopter das
   Schema befüllen kann.
2. **Lab-Grenze deklarieren** — Modul 15 sagt ausdrücklich: das Fixture ist
   handgeschrieben, der Emissions-Pfad ist Repo-Entscheidung und nicht Teil des
   Kurses. Billig und ehrlich; die Lücke bleibt.
3. **Nur (a) beheben** — den Satz zur Zuordnungs-Einheit nachtragen und (b)
   offen lassen. Löst die Begriffsfrage, nicht die Umsetzungsfrage.

**Behoben** (`a70ceb6`, nachgebessert in `492dffd` · `907a287` · `bea7c1d` ·
`29b4c16`; Details in den Commit-Messages): (a) Mini-Glossar und Übung benennen
die Kostenstelle als **Kontext**, kein Mensch. (b) Modul 15 §Lab-Grenze
deklariert Fixture und Emissions-Pfad als Nicht-Lehrinhalt; „ein Trace pro
Slice" ist als **Modellwahl** benannt, die Korrelation trägt `slice.id`, die Rolle
eines Laufs steht durch das gestartete Rollen-Artefakt fest. Der
Regelwerk-Split trägt davon nur die zwei operativen Sätze in den bestehenden
Regel-Sektionen — die Ebenen-Mechanik ist Grenz-Didaktik und blieb in der
Quelle. Der Mechanismus-Vorschlag oben ist teilweise überholt.

---

## Review-Befunde — drei Linsen auf `3ac682f..HEAD`

**Verfahren:** Drei Reviewer, getrennte Linsen, getrennter Kontext, read-only;
Linse 3 in einem eigenen Worktree für Break-Tests. 26 Rohbefunde,
zusammengeführt. Sechs davon waren von mehreren Linsen unabhängig bestätigt und
sind **behoben** (`b4f5b1e`, `e8fa2ab`): Schritt-Numerierung gegen Modul 6 ·
`README.md` mit der alten Sechserliste · „drei statt fünf Übergaben" ·
Spiegel-Pronomen · ADR-0011 Norm-gegen-Code · `verify-slice` (= `Ü-02`).

Die folgenden **21 stehen offen.** Gates sind grün — keiner ist maschinell
sichtbar.

### A — Gate mit Falsch-Positiven (1) ✅

**A-1 · `lab/example/tools/check_closure_notes.py:27`** — `PLACEHOLDER_RE =
r"<[^<>\n]+>"` trifft belegte Schreibweisen außerhalb von Code:

```
'p95 < 1 s und Recall > 0,9'  ->  ['< 1 s und Recall >']   ← eine QA-Messung
'<https://example.org/x>'     ->  ['<https://example.org/x>']
'<br>'  ·  'vector<float>'  ·  '<!-- … -->'  ·  '<alice@example.org>'
```

Der Vergleichsoperator-Fall ist der gefährlichste: Er trifft das Format, in dem
eine Closure-Notiz eine QA-Erfüllung berichtet. Ein Gate mit Falsch-Positiven
auf dem eigenen Ziel-Inhalt erzieht zum Umgehen.

**Behoben** (`f0b4e7c`): Regex eng gefasst — kein Treffer mitten in einem
Identifier, keine führenden/schließenden Leerzeichen (Vergleichsoperatoren),
Autolinks und HTML-Tags per Nachfilter. Verifiziert in beide Richtungen: acht
Gegenbeispiele still, vier Platzhalter-Formen weiter getroffen, echtes Repo
grün, blanker Template-Rumpf rot (Break-Test im eigenen Worktree), und eine
echte Notiz mit `p95 < 1 s` plus Autolink bleibt grün.

### B — CHANGELOG: das Register stimmt nicht (4) ✅

**B-1 · `CHANGELOG.md:14`** — Welle 60 ist auf `2026-07-29` datiert; zwei ihrer
Commits (`4276fa4`, `132eebb`) tragen `2026-07-30`.

**B-2 · `CHANGELOG.md:14-110`** — **Klasse 1 fehlt vollständig.** Acht Commits
(`f251992`–`a17ba14`), darunter die neue **ADR-0013**. `grep` auf
`ADR-0013|make ci|quality.md` im Block → **0**. Ein Adopter sieht eine neu
hinzugekommene ADR im Vorbild nirgends verzeichnet.

**B-3** — Die **14 Commits von heute** stehen in keinem Wellen-Block; das
Regelwerk trägt Normtext, den keine Wellennummer deckt, und
`lab/regelwerk/README.md:3` steht auf Welle 60.

**B-4 · `CHANGELOG.md:59-63`** — „`slice.template.md` und
`welle-results.template.md` **bei eins**" gegen `review-runde-10.md:98-103`
(R10-02), das für dieselbe Messung **7** und **2** nennt. Der Ziel-Zustand
trägt; nur die Vorzustands-Zahl reproduziert nicht.

**Behoben** (`Welle 61`). `B-1` und `B-3` hatten eine gemeinsame Ursache: Die
Arbeit vom 2026-07-30 ist keine Nachlese von Welle 60, sondern eine eigene
Welle. **Welle 61** eingetragen — damit stimmt auch das Datum von Welle 60
wieder, und die 17 Commits des Tages haben einen Block (gegengeprüft: jeder ist
darin wiederfindbar). Regelwerk-`Stand:` auf Kurs-Welle 61 gezogen. `B-2`: Der
Welle-60-Block trägt jetzt Klasse 1 mit allen acht Inhalten, ADR-0013
verlinkt. `B-4`: Beide Zahlen sind richtig, die Zählbasis war es nicht — der
Satz nennt sie jetzt (Zeiger der Form *„Regeln dieser Sektion:"* gegen jede
Regelwerk-*Nennung*) und verweist auf R10-02.

### C — Template-Zeiger auf Abschnitte, die die Regel nicht tragen (6) ✅

**C-1 · `roadmap.template.md:20`** — „§Roadmap-Struktur — genau **eine**
aktuelle Welle." *„Genau eine"* existiert weder im Kurs noch im Regelwerk.

**C-2 · `roadmap.template.md:55`** und **`:82`** — beide nennen
§Roadmap-Regeln; die zitierten Sätze stehen in §Kernidee (`:7`) bzw.
§Roadmap-Struktur (Drift-Log, `:65`).

**C-3 · `roadmap.template.md:31`** — „geplante Wellen bekommen **keine** eigene
Datei" ist nur aus Eröffnung Schritt 3 ableitbar, nicht aus dem genannten
Bullet.

**C-4 · `welle-results.template.md:20`** — §Was wurde geliefert? zitiert
**Schritt 1**; „geliefert · was funktionierte · was anders lief" steht in
**Schritt 3**. Dieselbe Datei zitiert Schritt 1 an `:122` korrekt.

**C-5 · `welle.template.md:85`** — §Out-of-Scope zeigt auf §Roadmap-Regeln; die
Out-of-Scope-Disziplin steht in Eröffnung Schritt 1.

**C-6 · `welle.template.md:39`** — „ein Trigger ist eine **beobachtbare
Vorbedingung**, kein Ergebnis dieser Welle." Beide Formulierungen existieren im
Repo nur hier; die Beobachtbarkeits-Regel steht in §Roadmap-Regeln, und
§Wann Arbeit eine Welle braucht handelt vom *Closure*-Trigger.

**Behoben** (`Gruppe C`): Alle neun Zeiger zeigen jetzt auf den Abschnitt, der
die Regel wirklich trägt, und zitieren dessen Wortlaut statt einer eigenen
Fassung. Maschinell nachgeprüft: **38 Zeiger, 0 ohne Ziel**. Zwei Klauseln, die
das Regelwerk nirgends trug, sind ersatzlos gefallen — „genau **eine** aktuelle
Welle" (der Abschnitt sagt „**die laufende**") und „geplante Wellen bekommen
keine eigene Datei" (steht in Eröffnung Schritt 3 und gehört zu
`welle.template.md`, nicht in die Roadmap-Vorlage). Aus `C-4` wurden drei
Stellen: `welle-results.template.md` hängte auch §Was hat funktioniert? und
§Was ging anders? an Modul 5 §Closure-Regeln (Slice-Ebene), obwohl beide
wörtlich in Modul 6 Schritt 3 stehen.

Die dritte fallengelassene Klausel ist ein eigener Befund geworden: siehe
`C-7`.

**C-7 ✅ · „Ein Trigger ist kein Ergebnis dieser Welle" — Regel ohne Quelle** (neu,
aus der C-Behebung)

Die Klausel stand in `welle.template.md:39` und ist mit `C-6` gefallen, weil das
Regelwerk sie nicht trägt. Sie beschreibt aber einen realen Defekt: Ein Trigger,
der ein Ergebnis seiner eigenen Welle ist, macht die Welle selbstreferenziell.
Das Repo hat dafür Vorfälle — der zirkuläre M2-Trigger („Coverage-Gate
hochgeschaltet" als Trigger der Welle, die hochschaltet) wurde in Klasse 2 an
sechs Stellen behoben, und `welle-1-mvp.md` führt den Fall ausdrücklich vor
(*„Sie entstehen in dieser Welle und wären damit Ergebnisse, keine beobachtbaren
Vorbedingungen"*) — nur steht das im **Beispiel**, nicht in der Norm.

**Behoben** (`557296d`) — die Vorfrage war zu messen: Folgt die Regel aus der
Beobachtbarkeit? **Nein.** „Alle Slices dieser Welle in `done/`" ist beobachtbar
*und* ein Ergebnis — als Closure-Trigger richtig, als Start-Trigger zirkulär.
Zwei Prüfungen, nicht eine. Encodiert in Modul 6 §Typische Fehlvorstellungen
(*„Beobachtbar reicht."*) mit praktischem Test: Steht der Trigger in der
Slice-Liste dieser Welle, ist er falsch platziert. Spiegel in §Roadmap-Regeln,
Klausel im Template zurück — jetzt verankert.

### D — Template-Schichtung verletzt (3) ✅

**D-1 · `slice.template.md:57`** — „diese Liste ist die
**Pfad-Kandidatenliste** … welche Sub-Areas der Slice berührt, **liest sich hier
ab**." Der zweite Halbsatz macht die Pfad-Berührung hinreichend und schließt die
Aussagen-Berührung aus — dasselbe Muster wie die behobene „untere Schranke".

**D-2 · `slice.template.md:48`** — „**streiche diese Zeile beim Kopieren**"
steht in der **DoD**-Schicht, die das Adoptieren überlebt. Nach
`konventionen.md` §Template-Schichtung ist das Kommentar-Inhalt: *„Anleitung
gehört nie in den Rumpf."*

**D-3 · `observations.template.md:44`** — die zweite Tabelle startet nach
Adoption mit `| <BEO-NNN> | <Bezeichnung> | YYYY-MM-DD | … |`. Dieselbe Klasse
wie die drei erfundenen Beobachtungen, deren Entfernung Welle 60 als Behebung
führt — eine Tabelle tiefer.

**Behoben** (`Gruppe D`): `D-1` — der zweite Halbsatz ist weg; die §3-Liste
liefert jetzt „die **Pfad-Kandidaten**, nicht die Antwort: Pfad-Berührung ist
nicht hinreichend, und eine Aussagen-Berührung steht hier gar nicht." `D-2` —
nicht die Anweisung verschoben, sondern das Item **in beiden Modi abhakbar**
gemacht (*„sind getragen — ohne Wellen-Betrieb hier geprüft, mit Wellen von der
nächsten Welle-Closure"*); damit ist nichts zu streichen, und die Begründung
samt Drei-Commit-Folge steht im Kommentar, wo Bedienhinweise hingehören. `D-3` —
die zweite Register-Tabelle startet mit `— keine —`, die Form einer gefüllten
Zeile steht im Kommentar. Adoptions-Simulation für beide Dateien nachgestellt.

**D-4 ✅ · „≤ 3 DoD-Punkte" über acht Items** (neu, aus der D-Behebung)

Die Adoptions-Simulation zeigt den §2-Zeiger von `slice.template.md` direkt über
der Checkliste:

```
§Ziel-Form: Slice — **≤ 3 DoD-Punkte**; mehr heißt: der Slice ist zu groß …
- [ ] LH-FA-<NN> erfüllt, Test referenziert.
… acht Items insgesamt, davon vier Prozess-Items
```

Modul 5 nennt „mehr als drei DoD-Punkte" als **Faustregel für die
Slice-Größe** (`:180`, `:196`) und unterscheidet nicht zwischen liefernden und
prozessualen Punkten. Das Template führt vier liefernde (`LH-FA`, `LH-QA`,
`make gates`, Doku-Update) und vier prozessuale (Closure-Notiz, Register,
Risiko-Ausgänge, Paarungen). Nach dem Wortlaut wäre jeder Slice, der die Vorlage
ausfüllt, „zu groß".

**Behoben** (`557296d`) — ableitbar aus dem Zweck: Die Regel ist eine
**Größen**-Faustregel, also zählt sie nur, was mit dem Umfang *wächst*.
Gate-Läufe und Closure-Pflichten sind pro Slice konstant. Bestätigt durch die
eigene Übung — *„SL-031 (5-Punkte-DoD) bewerten und schneiden"* wäre sinnlos,
wenn die Vorlage jeden Slice schon auf vier brächte. Jetzt **Liefer-Punkte** mit
Nicht-Zähl-Liste in Modul 5, Spiegel und Template.

Meine erste Formulierung („liefernd vs prozessual") war noch zu grob; die Messung
am Vorbild ergab 4–5 und widerlegte sie — `make gates grün` ist nichts, was ein
Slice *liefert*.

**D-5 ✅ · Zwei Vorbild-Slices scheinen über der Schwelle zu liegen** (neu, aus
der D-4-Behebung)

Meine Schlüsselwort-Zählung ergab `slice-013` **4** und `slice-014` **4** — über
der Schwelle. **Der Befund war falsch, und zwar mein Messfehler, nicht das
Vorbild.** Von Hand gegen die Regel gezählt:

| `slice-013` | zählt? | Grund |
|---|---|---|
| Property-Test pro Sprache | **ja** | das gelieferte Artefakt |
| „Eigenschaft: Reihenfolge bei gleichem Score reproduzierbar" | nein | die Eigenschaft, die Punkt 1 prüft — abgehakt wird sie *mit* ihm |
| Make-Target `test-property`, in `make gates` eingehängt | **ja** | eigenes Artefakt |
| „läuft 100 Generationen, fail-closed" | nein | Konfiguration von Punkt 3 |
| Closure-Notiz | nein | prozessual |
| `docs/user/quality.md` + drei Platzhalter-Vermerke | **ja** | eigenes Artefakt |

| `slice-014` | zählt? | Grund |
|---|---|---|
| ADR-0004 Accepted | **ja** | eine Entscheidung ist ein Artefakt |
| Adapter `IndexSearcher` (Linear + ANN) | **ja** | das gelieferte Artefakt |
| „`make test-determinism` weiterhin grün" | nein | Nicht-Regression: hält eine *bestehende* Konvention ein, wächst nicht mit dem Umfang — konsistent mit §8 desselben Slice, der *Test-Infrastruktur* deshalb als **nicht berührt** führt |
| „recall@5 verschlechtert sich um maximal 5 %" | **ja** | Akzeptanzkriterium, das dieser Slice herstellt |
| `make gates` grün | nein | Gate-Lauf |
| Closure-Notiz | nein | prozessual |

**Beide liegen bei 3.** Alle vier Vorbild-Slices halten die Regel: 3 · 1 · 3 · 3.

Zwei Fehler in meinem Skript: Es schloss „Neues Make-Target `test-property` läuft
in `make gates`" aus, weil die Zeile `make gates` enthält — dabei ist das Target
der Liefer-Punkt; und es zählte `slice-014`s Nicht-Regression mit. Die Lehre ist
kein neuer Normtext: Modul 5 nennt die Schwelle eine **Faustregel**, und
Liefer-Punkte lassen sich nicht per `grep` zählen. Genau deshalb steht sie nicht
als Gate im Repo.

### E — Quelle/Spiegel und Verweise (4) ✅

**E-1 · `kurs/de/03-agenten/modul-08-agentenrollen.md:148`** — verweist für die
Tabelle *Träger im Repo ohne Wellen* auf `#die-wellen-closure-prozedur`; sie
liegt in §Wann Arbeit eine Welle braucht. Der Spiegel (`:71`) zeigt richtig.

**E-2 · `modul-08-agentenrollen.md:56` gegen `:110`** — dieselbe Kante
`Verifier → Planner` ist einmal `-->>` (gestrichelt = Rückgabe) und einmal
`->>`. Das Modul lehrt, dass die Pfeilart Bedeutung trägt.

**E-3 · `modul-08-agentenrollen.md:118`** — Träger von Schritt 5 ist eine
„maschinelle Deckungsprüfung" mit „Gate-Ausgabe"; Modul 6 lässt das Werkzeug
ausdrücklich offen (*„Welches Werkzeug, ist Repo-Entscheidung"*), und im Vorbild
existiert kein `BEO`-Prüfer (`grep -rn "BEO-" lab/example/Makefile
lab/example/tools/` → leer).

**E-4 · `lab/regelwerk/grundlagen-konventionen.md:102`** und
**`modul-06-roadmap.md:87`** — zwei operative Passagen sind gegenüber der Quelle
**paraphrasiert** statt weggelassen. Die Digest-Regel erlaubt Weglassen, nicht
Umformulieren.

**Behoben** (`Gruppe E`). `E-3` war schon mit `b4f5b1e` weggefallen: Der
Tabellen-Umbau hat „Gate-Ausgabe" durch „eine **Deckungs**-Prüfung, deren
Werkzeug der Kurs offen lässt" ersetzt. `E-1` — Verweis auf
`#wann-arbeit-eine-welle-braucht--und-wann-nicht` umgehängt, wo die Tabelle
tatsächlich liegt (`:299`). `E-4` — eine Passage wortgleich gemacht, die andere
**weggelassen**: Die Konsequenz-Erklärung („dieselbe Auslöschung eine Ebene
höher") ist Didaktik, die operative Regel („trägt `— keine —` und bleibt
stehen") stand schon da.

`E-2` war nicht die Pfeilart, sondern eine **fehlende Kante.** Der
Verifikations-Beleg war als erste Nachricht des Diagramms gezeichnet, also
initiativ — deshalb durchgezogen, während dieselbe Kante im Slice-Diagramm
gestrichelt ist. Beides ließ sich nur auflösen, indem die Anfrage sichtbar wird:
Die Wellen-Closure ist Planner-getrieben, der Verifier liefert **auf
Anfrage**. Jetzt `P->>Vf` und `Vf-->>P`, und die Notation stimmt wieder —
durchgezogen heißt Anfrage, gestrichelt heißt Antwort, in beiden Diagrammen.

Damit wird die Zählung erst richtig: **sechs Übergaben in drei Zügen** aus je
Anfrage und Antwort (statt fünf). Ohne Wellen-Betrieb entfällt ein ganzer Zug —
**zwei der drei bleiben**, nicht „vier der fünf". Nachgeprüft: Slice-Diagramm 11
Pfeile mit durchgezogen/gestrichelt konsistent, Wellen-Diagramm 6, dreimal das
Paar.

### F — Rollen-Rename: sechs Reste (1) ✅

**F-1** — `lab/example/Makefile:36` (`Implementation-Agent`, sichtbar in
`make help`) · `kurs/de/loesungen/modul-00-loesung.md:98`
(`Verification-Agent`) · `kurs/de/grundlagen/klassifikation.md:67` und `:86`
(`Validation-Agent`) samt Spiegel `grundlagen-klassifikation.md:63`, `:82`.
Alle in Rollen-Position, also nicht von der Tätigkeits-Ausnahme gedeckt.

**Behoben** (`6223ba3`): Alle sechs auf das Akteursnomen
gebracht; `make help` zeigt „Implementer-Agent". Vollprobe über alle verfolgten
Markdown-, JSON- und Makefile-Dateien nach Vorgangsnomen in Rollen-Position:
keine Treffer.

### G — Buchführungs-Dokumente (2) ✅

**G-1 · `review-runde-10.md:446` und `:495`** — „R10-01 fiel bei **Klasse 3**
mit weg". Behoben wurde es in `5e061dc`, zwei Commits **vor** Klasse 1; dieser
Commit fehlt in der Inventur-Tabelle ganz.

**G-2 · `review-runde-10.md:431`** — „Die Klassen 1–3 betreffen `lab/example`".
Klasse 3 (`3ac682f`) hat vier Kurs- und Spiegel-Dateien geändert — es sind die
Stellen, die §Entschieden als `E-4` führt.

**Behoben** (`ac35c58`): `G-1` — `5e061dc` als Zeile *vorab* in die
Inventur-Tabelle aufgenommen; R10-01 ist dort als vorab behoben geführt, mit
dem Zusatz, dass Klasse 3 die Blöcke später an die neuen Sub-Area-Namen
angepasst hat. `G-2` — die Aussage verwechselte zwei Achsen: Die Klassen
benennen, **wo der Defekt sichtbar war**, nicht wo der Fix landete. Bei
Klasse 3 stand die Fehlzuordnung im Register auf einer fehlenden Norm, also
ging der Fix an die Quelle.

### Nicht übernommen

**Modul 5 §Rückführungen** (Linse 1): Der Ort *ist* genannt
(`modul-05-planning-harness.md:71`, „**Vorab** benennt §4 des Slice-Plans die
*Bedingung*"). Offen bleibt nur, dass `slice.template.md:75-76` zwei Slots für
die Bedingung führt und keinen für den Grund — als Teil von **D** zu behandeln.

**Der fehlende `sequenceDiagram` im Modul-8-Split** (Linse 3, „unsicher"):
korrekt weggelassen — die Übergaben stehen dort als Tabelle vollständig.

---

## Übernommen aus der Stand-Sichtung — bekannt, nicht behoben

Diese Punkte sind keine Review-Befunde, sondern offene Posten aus früheren
Runden. Sie stehen hier, damit sie nicht wieder einzeln erhoben werden müssen.

### Ü-01 — Release-Rückstand: zwölf Wellen committet, nicht getaggt

```
letzter Tag:       v3.8.0  =  Welle 48
CHANGELOG jetzt:             Welle 60
Commits seit Tag:  33
```

Adoptierende Repos vergleichen ihren Baseline-`Stand:` gegen das Register
([`CHANGELOG.md`](../../CHANGELOG.md)) — sie sehen Welle 60 im Repo und
bekommen per Release-Asset Welle 48.

### Ü-02 — `verify-slice` meldet einen Mangel und sagt trotzdem `ok` ✅

```
$ make -C lab/example verify SLICE=slice-020
Missing gates evidence in DoD: …/slice-020-referenz-richtung-repariert.md
verify-slice ok: …/slice-020-referenz-richtung-repariert.md
exit=0
```

Dieselbe Klasse wie R10-21 (Gate grün auf unausgefülltem Rumpf), eine Ebene
weiter: Ein Prüfer, der einen Mangel benennt und `ok` sagt, ist schlimmer als
einer, der schweigt — er erzeugt Vertrauen und Ausgabe zugleich.

**Behoben — und der Befund war zu klein beschrieben.** Nicht eine Prüfung war
wirkungslos, sondern **alle vier**: `exit 1` stand in runden Klammern (Subshell)
und die Zeilen waren mit `;` verkettet, sodass make nur den Status von
`echo … ok` sah. `make verify-slice SLICE=slice-999` lief grün durch, mit vier
`grep: Datei nicht gefunden` davor. Jetzt `set -e` plus geschweifte Klammern,
mit Kommentar im Makefile, warum die Klammerform hier den Unterschied macht.

**Was der wirksame Gate sofort fand:** `slice-020` nennt `make gates` nicht,
obwohl `AGENTS.md` §4 es als *mandatory vor PR* führt. Der Lauf ist trivial grün
(kein Sprach-Skelett berührt), die fehlende Zeile trotzdem ein Mangel —
nachgetragen mit Vermerk. Die übrigen drei Vorbild-Slices sind grün.

### Ü-03 — C# hat kein wirksames Coverage-Gate

`csharp/Makefile:44` setzt `/p:Threshold=70`, was `coverlet.msbuild` voraussetzt;
`csharp/Directory.Packages.props:14` referenziert nur `coverlet.collector` — der
misst, wertet aber keine Schwelle aus. In
[`CO-001`](../../lab/example/docs/plan/carveouts/CO-001-index-coverage.md)
§Offen ehrlich benannt. Braucht ein lauffähiges `dotnet restore` zum Verifizieren.

### Ü-04 — `AGENTS.template.md` lehrt einen zentralen Ort für Qualitätsdefinitionen ohne Quell-Verankerung

`lab/templates/AGENTS.template.md:171`: *„Quality-Gate-Definitionen leben in
`<docs/user/quality.md` oder Äquivalent>."* Modul 13 sagt das so nicht.
Fix-Richtung wäre Quelle → Template, wie bei R10-04.

### Ü-05 — Die Drift-Übung in Modul 12 ist nicht ausführbar

`kurs/de/04-qualitaet/modul-12-replay-evaluierung.md:235` schickt in eine Kopie,
um einen Modellwechsel-Drift zu messen. Das Skelett kann den Replay nicht
ausführen (Lab-Grenze). Entweder als Lab-Grenze deklarieren oder die Übung auf
das Machbare zuschneiden.

### Ü-06 — Geparkt, bewusst

- Der `.harness/`-Beleg für die Durchsetzungsschicht im Kurs-Repo (siehe
  R10-30: Der Reviewer-Skill existiert nur als Adopter-Template).
- Die Discovery-Register-Frage — vertagt bis zum zweiten Konsument-Repo.
