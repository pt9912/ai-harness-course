# Die Harness-Dateien und ihre Form

## Verzeichniskonvention

```
spec/                       # Spec-Straten: Vertrag · Technik · Sicht
docs/plan/adr/              # Architecture Decision Records
docs/plan/planning/open/    # geplante, noch nicht gestartete Slices
docs/plan/planning/next/    # priorisiert/eingeplant
docs/plan/planning/in-progress/  # aktive Slices
docs/plan/planning/done/    # abgeschlossene Slices
docs/plan/planning/<welle-id>.md            # offene Wellen, flach (Modul 6)
docs/plan/planning/observations.md          # Beobachtungs-Register: der Steering-Loop-Zähler
docs/plan/planning/in-progress/roadmap.md   # Meilensteine, Wellen, aktive Welle
docs/plan/carveouts/        # Ausnahmen mit Plan zur Auflösung
docs/reviews/               # Review-Reports, ein Report pro Lauf (Modul 10)
AGENTS.md                   # maschinell lesbare Projekt-Konventionen für Agenten
harness/README.md           # Einstiegspunkt: Precedence, Guides, Sensors, Safety
harness/conventions.md      # Index: repo-lokale Regeln, Adaptionen, Modus pro Sub-Area
harness/conventions/        # ein MR je Datei; done/ = aufgelöst
.harness/                   # Skills, Tool-Allowlists, Checklisten-Middlewares
```

## Template-Schichtung — was der Rumpf trägt und was der Kommentar

Ein Template wird beim Adoptieren **abgebaut**: Platzhalter werden ersetzt, der
Hinweis-Block entfernt, **alle HTML-Kommentare gelöscht** — bis auf die
`d-check:ignore`-Marker, die Falsch-Positive unterdrücken und bleiben müssen
([`/lab/templates/README.md`](../../../lab/templates/README.md) §Verwendung,
Schritt 5).
Was danach noch dasteht, ist alles, was der Adopter Wochen später hat. Deshalb
ist die Frage *„Rumpf oder Kommentar?"* keine Stilfrage, sondern eine
Haltbarkeitsfrage — und sie hat vier Antworten, nicht zwei:

| Schicht | Inhalt | Überlebt das Adoptieren? |
|---|---|---|
| **Regelwerk** | Der Normtext. **Einzige** Quelle. | — es ist vendored (`.harness/baseline/<tag>/regelwerk/`) und lebt außerhalb des Artefakts |
| **Rumpf** | Nur, was das *fertige Artefakt* trägt: Feldnamen, Feldreihenfolge, `<Platzhalter>` — plus **genau ein** Regelwerk-Zeiger pro Pflicht-Sektion | ja |
| **DoD / Checkliste** | Jede Pflicht, die der Ausfüllende **abhaken** muss. Das ist die Prozedur | ja |
| **Kommentar** | Begründung und Bedienhinweis — *warum* die Form so ist, *in welcher Reihenfolge* zu arbeiten ist | nein |

**Der Test für den Rumpf:** *Liest sich das im veröffentlichten Artefakt als
Inhalt — oder als Anleitung an jemanden?* Anleitung gehört nie in den Rumpf.
Eine Closure-Notiz, die dem Leser erklärt, wie ein Sensor gebaut ist, hat ihre
Rolle verlassen. Und Normtext im Rumpf hat einen zweiten Defekt: Schritt 3
ersetzt die `<Platzhalter>` *darin* — aus der allgemeinen Regel wird eine
falsche Einzelaussage.

**Hard Rule.** *Kein Kommentar ist die einzige Fundstelle einer Norm.* Wer eine
Regel in einen Template-Kommentar schreibt, schreibt sie in den Papierkorb des
Adopters. Sie gehört ins Regelwerk; im Template steht der **Zeiger** darauf, im
Rumpf, bei der Sektion, für die sie gilt.

**Warum das die Duplikat-Frage mitbeantwortet:** Der Zeiger ist kein Zitat. Ein
Template, das den Normtext ausschreibt, führt ihn ein zweites Mal — und zwei
Fassungen driften, das ist die Klasse, gegen die die ganze Spiegel-Disziplin
gebaut ist ([§Source Precedence](source-precedence.md#source-precedence)). Der Zeiger ist einlösbar,
weil das Bundle `regelwerk/` und `templates/` parallel ausliefert.

**Feedback-Hälfte — und warum sie *inferential* ist.** Die naheliegende
Mechanisierung wäre: *Trägt der Kommentar einer Sektion einen Regelwerk-Zeiger,
muss der Rumpf auch einen tragen.* Sie trägt nicht. Erstens ist „ist dieser
Satz eine Norm?" ein Urteil, kein Match — dieselbe Klasse wie *„ist das
dieselbe Beobachtung?"* beim Beobachtungs-Register
([Modul 6](../02-planung/modul-06-roadmap.md#das-beobachtungs-register)).
Zweitens sind Template-Verzeichnisse für Referenz-Gates **bewusst
ausgenommen** — ihre Pfade sind symbolisch, sie zeigen ins Ziel-Repo. Ein Gate,
das dort trotzdem prüft, prüft entweder nichts oder das Falsche.

Die Feedback-Hälfte ist deshalb der **Reviewer**: *Norm nur im
Template-Kommentar* steht als HIGH-Regel im Reviewer-Skill
([Ziel-Form](../../../lab/templates/.harness/skills/reviewer.template.md)).

> **Grenze — ehrlich benannt:** Damit hängt diese Regel an einem Review, nicht
> an einem Lauf. Wer ohne Review committet, wird nicht erwischt. Und der Skill
> oben ist eine **Ziel-Form für das adoptierende Repo** — ob dort ein Review
> mit dieser HIGH-Regel tatsächlich läuft, entscheidet der Adopter, nicht
> diese Konvention. Wo er es nicht einrichtet, hat die Hard Rule keinen
> Träger, und das ist kein Sonderfall: Es ist der Auslieferungszustand. Ein *Sensor*
> hier zu behaupten, wo keiner steht, wäre genau die Klasse *halluziniertes
> Gate* ([Modul 13](../04-qualitaet/modul-13-quality-gates.md#hard-rule-doku-disziplin))
> — auf die eigene Konvention angewandt.

## harness/README.md als Einstiegspunkt

Pro Repo bündelt eine einzige Datei alles, was ein Agent oder ein neuer
Mensch zuerst lesen muss. Pflichtgliederung:

```
# Harness

## Purpose                  # ein Absatz, was diese Datei ist (und was nicht)
## Source precedence        # die obige Tabelle, repo-spezifisch
## Guides                   # Tabelle der Feedforward-Quellen
## Sensors                  # Tabelle der Feedback-Gates (nur real existierende!)
## Traceability rules       # Welche IDs müssen in Commits/PRs auftauchen?
## Safety and scope boundaries  # repo-spezifische Hard Rules
## Minimal agent workflow   # der 8-Schritt-Pfad (siehe Modul 9)
```

Wichtig: Die Sensors-Tabelle darf keine Befehle behaupten, die es im Repo
nicht gibt. Halluzinierte Gates sind die häufigste Form von Harness-Lüge.

Die Sensors-Tabelle trägt **keinen Lauf-Status** ("grün"/"rot"):
Lauf-Wahrheit pro Commit lebt in CI (Badges/Dashboard), also in höher
rangierten Quellen, nicht in `harness/README.md` (unterster Rang). Strukturell
rote Gates werden als Carveout in `docs/plan/carveouts/` dokumentiert
(Modul 7); die Bindung-Spalte der Tabelle (`Target | Vertrag | Bindung`)
verweist auf die `CO-<NNN>`-ID, die Begründung lebt im Carveout, nicht
hier. Damit ist "rot dokumentieren, nicht verstecken" ortsdiszipliniert:
es geschieht im Carveout-Index, nicht in einer Status-Spalte, die sich
selbst grünfärben kann.

Die Bindung-Spalte trägt vier **kanonische Klassen**:

- **ADR-Bindung** (`ADR-<NNNN>`) — Gate setzt eine Architektur-Entscheidung
  durch.
- **Carveout-Bindung** (`CO-<NNN>`) — Gate bewusst geschwächt, mit
  Auflösungs-Trigger und Folge-Slice (Modul 7).
- **Kalibrierungs-Bindung** (`Schwelle X %, M<n> → Y %`) — bewegliche
  Eichung mit Meilenstein-Schaltplan.
- **Reproduzierbarkeits-Bindung** (Image-Hash, Toolchain-Pin) — Gate
  hängt an bit-identischem Artefakt (Modul 14).

Repos können **weitere Klassen** einführen — etwa Anforderungs-Bindung
(`LH-…`), Compliance-Bindung (Regulatorik-Artikel) oder
Modell-Version-Bindung (für KI-Evals). Diese werden im **repo-lokalen
Konventionsdokument** deklariert (Default-Pfad `harness/conventions.md`,
Form projektabhängig), damit ein Reviewer sie als legitim erkennt und
nicht als Tippfehler abtut. Eine Bindung ohne Deklaration ist eine
stille Setzung — und damit eine Harness-Lüge in derselben Klasse wie
ein halluziniertes Gate.

## harness/conventions.md als Konventionsspeicher

`harness/conventions.md` trägt die **repo-lokalen Strukturregeln** und
Adaptionen ggü. der adoptierten Baseline (Kurs, interner Standard,
Industrie-Norm). Sie ist **Pflicht** (Existenz), ihre Form (Einzeldatei
vs. Verzeichnis, ADR-artig vs. Prosa) ist **Wahl** — projektabhängig
nach Projektgröße, Adaptions-Frequenz, Audit-Tiefe.

Pflichtgliederung (Default-Form als Einzeldatei):

| Abschnitt | Inhalt |
|---|---|
| Purpose | was die Datei trägt, was nicht |
| Baseline | welche Konvention adoptiert, mit Stand/Version |
| Adoptierte Konventions-Quellen | Pointer extern (Kurs/Standard) und in-Repo (Templates) |
| Adaptions-Block | **Index** der Abweichungen ggü. Baseline, nicht die Einträge selbst: `MR-000` (Adoptions-Erklärung) plus je eine Tabellenzeile pro Adaption. Pflichtfelder eines Eintrags: Datum, Geltungsbereich, `Ersetzt-Baseline-Regel`, Adaption, Begründung, Auflösungs-Trigger oder "permanent". Löst ein Eintrag einen früheren **ab**, nennt er zusätzlich *Löst auf* und *Ausgelöst durch Baseline-Stand*; *schärft* er ihn nur (der alte gilt weiter, die Regel wird **strenger**), steht das im Titel — `(schärft MR-<NNN>)`. Verliert ein Eintrag durch die Baseline dagegen einen *Teil seines Geltungsbereichs*, ist das eine **Ablösung** mit engerem Nachfolger, keine Schärfung. Einträge werden nie überschrieben. |
| Zusatzklassen-Deklaration für Sensors-Bindung | repo-spezifische Bindung-Klassen jenseits der vier kanonischen (`LH-…`, Compliance, Modell-Version) |
| Modus-Deklaration pro Sub-Area | Greenfield · Brownfield (mit Konvergenz-Auftrag) · Hybrid |
| Glossar (optional) | repo-spezifische Begriffe, die nicht im Kurs-Glossar stehen |

**Ein Eintrag je Datei — und der Grund ist der Kontext des Agenten.**
Die Einträge selbst leben unter `harness/conventions/MR-<NNN>-<titel>.md`;
ist der Auflösungs-Trigger eingetreten, wandert die Datei nach
`conventions/done/`. Der Zustand ist die **Verzeichnis-Position**, kein
Status-Feld — dieselbe Lifecycle-Form wie bei Slices
([Modul 5](../02-planung/modul-05-planning-harness.md#lifecycle-als-state-machine)).

Der Schnitt folgt nicht der Ästhetik, sondern dem Lesepfad: `conventions.md`
liest **jeder** Agentenlauf. Steht der volle Text aller Adaptionen darin,
wächst der Pflichtanteil des Kontexts mit jeder Adaption — und trägt bald
mehrheitlich Einträge, die *aufgelöst* sind und trotzdem gelesen werden. Das
ist nicht nur Kontext-Kosten, sondern ein Korrektheits-Risiko: Ein
aufgelöster Eintrag liest sich wie ein geltender. Mit Index plus Dateien
zahlt jeder Lauf **eine Zeile pro aktiver Adaption**; geöffnet wird nur, was
den eigenen Geltungsbereich trifft. Es ist dieselbe Disziplin, die das
Regelwerk für sich selbst verlangt — *nur den benötigten Abschnitt laden,
nicht das Ganze im Kontext halten*.

Die Form bleibt Wahl: Ein Repo mit zwei permanenten Adaptionen darf sie
inline führen. Der **Default** ist die Verzeichnis-Form, weil sie mit der
Adaptions-Zahl nicht mitwächst.

Nebeneffekt, kein Selbstzweck: Ein Eintrag je Datei ist auch die einzige
Form, in der die Append-only-Disziplin *prüfbar* wird — eine wachsende
Sammeldatei lässt sich nicht gegen Core-Drift pinnen, eine akzeptierte
Einzeldatei schon.

Wichtig: `harness/conventions.md` dupliziert keinen Baseline-Text — sie
verweist und ergänzt. Eine Kopie ginge gegen die Baseline in Drift,
sobald letztere sich weiterentwickelt. Zwei Quellen derselben
Konvention sind dasselbe Drift-Risiko, das die Source-Precedence-Regel
für Spec/ADR adressiert — hier in der Form-Ebene.

Vorlagen:
[`/lab/templates/harness/conventions.template.md`](../../../lab/templates/harness/conventions.template.md)
(Index) und
[`/lab/templates/harness/conventions/MR-NNN-titel.template.md`](../../../lab/templates/harness/conventions/MR-NNN-titel.template.md)
(ein Eintrag).
Worked Example:
[`/lab/example/harness/conventions.md`](../../../lab/example/harness/conventions.md).

## Jedes Artefakt hat einen Konsumenten

**Regel.** Wer dem Harness ein Artefakt hinzufügt — eine Sektion, eine Liste,
eine Notiz —, benennt, **wer es liest und wann**. Findet sich kein Leser, ist
es Ablage, keine Steuerung, und gehört nicht angelegt.

Im Fluss-Diagramm der [§Traceability-Klammer](traceability.md#traceability-constraint) ist das die Probe *hat das neue gelbe Kästchen ein
blaues?* Der Steering-Loop-Eintrag war vor dem *Beobachtungs-Register* genau das: sauber erhoben, nie gelesen.

**Zwei Ausnahmen, die keine sind:**

- **Derivative Artefakte** — Indizes und Listen, deren Inhalt anderswo als
  Original liegt (ADR-Index, Carveout-Index, *Folge-Slices* in der
  Closure-Notiz). Sie brauchen keinen eigenen Leser, wohl aber eine
  **Deckung**: das Original muss existieren. Kennzeichne sie als *derivativ*,
  sonst schlägt die Probe falschen Alarm.
- **Lauf-Belege** — Artefakte, die belegen, *dass* etwas lief (Review-Report,
  Verifikations-Belege). Ihr Konsument ist der Vorgang selbst und danach der
  Audit; über Läufe hinweg werden sie nicht wieder gelesen, und sie müssen es
  nicht ([Modul 10](../04-qualitaet/modul-10-review-harness.md)).

**Einordnung — und ihre Grenze.** Die Regel ist *inferential feedforward* und
greift zur **Entwurfszeit**: wenn jemand den Harness *erweitert*, nicht wenn er
ihn *betreibt*. Sie ist ausdrücklich **kein Prüfpunkt der Closure-Prozedur** —
dort spräche sie in den meisten Wellen auf nichts an, würde nach der dritten
Welle übersprungen und wäre danach eine
[Harness-Lüge](begriffe.md#kernbegriffe). Der häufige Fall ist ohnehin gedeckt: Erreicht
eine Beobachtung die Schwelle und wird zur Regel, hat sie ihren Leser
automatisch — die verkörperte Form wird in jedem Lauf gelesen, und die
**Anker-Paarung** prüft deterministisch, dass sie wirklich landete.

Was die Regel *nicht* leistet: Sie sagt nicht, ob ein genannter Konsument den
Inhalt auch **nutzt**. „Wird beim Audit gelesen" ist eine gültige Antwort und
zugleich die schwächste — wer sie gibt, sollte wissen, dass er ein Archiv
anlegt.
