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

### A — Gate mit Falsch-Positiven (1)

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

### B — CHANGELOG: das Register stimmt nicht (4)

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

### C — Template-Zeiger auf Abschnitte, die die Regel nicht tragen (6)

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

### D — Template-Schichtung verletzt (3)

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

### E — Quelle/Spiegel und Verweise (4)

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

### F — Rollen-Rename: sechs Reste (1)

**F-1** — `lab/example/Makefile:36` (`Implementation-Agent`, sichtbar in
`make help`) · `kurs/de/loesungen/modul-00-loesung.md:98`
(`Verification-Agent`) · `kurs/de/grundlagen/klassifikation.md:67` und `:86`
(`Validation-Agent`) samt Spiegel `grundlagen-klassifikation.md:63`, `:82`.
Alle in Rollen-Position, also nicht von der Tätigkeits-Ausnahme gedeckt.

### G — Buchführungs-Dokumente (2)

**G-1 · `review-runde-10.md:446` und `:495`** — „R10-01 fiel bei **Klasse 3**
mit weg". Behoben wurde es in `5e061dc`, zwei Commits **vor** Klasse 1; dieser
Commit fehlt in der Inventur-Tabelle ganz.

**G-2 · `review-runde-10.md:431`** — „Die Klassen 1–3 betreffen `lab/example`".
Klasse 3 (`3ac682f`) hat vier Kurs- und Spiegel-Dateien geändert — es sind die
Stellen, die §Entschieden als `E-4` führt.

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
