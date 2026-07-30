# Review-Runde 11 — offen

**Stand:** 2026-07-29. **Status:** noch kein Review-Lauf. Diese Datei sammelt,
was **vor** der Runde aufgefallen ist. `V11-01`, `V11-02` und `Ü-02` sind
behoben, die übrigen Ü-Posten offen.

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

**Behoben — (a) plus (b) als deklarierte Grenze; die Wahl war ableitbar, nicht
zu treffen.** Maßstab sind die Lernziele von Modul 15: *lesen · attribuieren ·
unterscheiden · erkennen · spezifizieren · entwerfen* — keines sagt
*instrumentieren*. Ein gelehrter Emissions-Pfad (Weg 1) hätte den Modul-Scope
erweitert, um einen Befund zu schließen; das wäre Fix-Richtung Befund → Lehre.

Encodiert als **Modul 15 §Lab-Grenze** (nach §Lab-Bezug, dem Muster von
`evals/golden/README.md` folgend): Das Fixture ist ein **Slice**-Trace mit der
Rolle am Span; in einer instrumentierten Umgebung sind es drei Ebenen, die Rolle
sitzt auf der **Resource** des Laufs und wird vom Starter gesetzt
(`OTEL_RESOURCE_ATTRIBUTES` spezifiziert, `TRACEPARENT` als Env-Var ausdrücklich
Konvention). Der Emissions-Pfad ist als Nicht-Lehrinhalt benannt: mitzunehmen
ist das Schema, nicht das Setup. Für (a) tragen Mini-Glossar und Übungsauftrag
jetzt „die Kostenstelle ist ein **Kontext**, kein Mensch"; Spiegel quelltreu,
Fixture-README sagt, was das Fixture ist.

**Nachgebessert — vier Folge-Commits, alle vom Nutzer angestoßen.** „Spiegel
quelltreu" oben war **falsch**, als es geschrieben wurde: Der Split trug die
komplette §Lab-Grenze samt Kurs-Rahmen („Das Kurs-Fixture ist handgeschriebenes
JSON …") — Didaktik über Material, das im netzlosen Bundle nicht existiert
(`492dffd`). Danach: Begründungs-Bullets aus dem Split entfernt, 27 → 14 Zeilen
(`907a287`) · „ein Mensch spielt mehrere Rollen" durch die Lauf-Formulierung
ersetzt — der Mensch kommt in der Bilanz nicht vor, eine Rolle wird von einem
Lauf getragen (`bea7c1d`) · „der Lauf hängt am Slice-Trace" als **Modellwahl**
benannt statt als Regel — die Korrelation trägt `slice.id` (Pflichtfeld jedes
Spans), die oberste Ebene heißt seither *Slice, als Attribut jedes Laufs*;
damit ist auch der Mechanismus-Bullet oben („hängt den Lauf als Kind an den
Slice-Trace") überholt (`29b4c16`). Der Split trägt seither vier Regel-Bullets
ohne Kurs-Bezug; `grep` auf Kurs-Fixture / `lab/example` über `lab/regelwerk/`
ist leer.

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
