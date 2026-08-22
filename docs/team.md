# Team-Tauglichkeit — wo das Regelwerk einen einzelnen Schreiber voraussetzt

## IST, SOLL und was diese Datei dazwischen tut

**IST.** Der Korpus ist für **einen schreibenden Menschen plus Agenten** gebaut
— das Ergebnis der Bestandsaufnahme unten. Seit P0 ist das **deklariert**: im
Kurs ([README §Zielgruppe](../kurs/de/README.md#zielgruppe)) und im Bundle
(`lab/regelwerk/README.md` §Geltungsbereich); ein Adopter erfährt damit, dass
die Mehr-Schreiber-Fassung entworfen und nicht belegt ist.

**SOLL.** Teamfähigkeit — **in drei Stufen**, von denen nur die ersten beiden
von uns herstellbar sind. **Erreicht sind die ersten beiden** (Wellen 76–79;
Probelauf 2026-08-16):

* **entworfen** — alle Anpassungen sind in Kurs, Regelwerk und Templates
  verkörpert. Beobachtbar, und allein an uns. *Seit Welle 79.*
* **geprobt** — die **Nebenläufigkeits-Mechanik** der Anpassungen ist unter
  simuliertem Mehr-Schreiber-Betrieb provoziert worden und hat gehalten:
  [`lab/team-sim/`](../lab/team-sim/README.md), neun Szenarien, 9/9 — laute
  und *stille* Ausgänge je vorab notiert. Die Grenze gehört zur Stufe: geprüft
  ist die Mechanik mit kooperativen Akteuren; **Dissens, Lesarten-Divergenz
  zwischen Menschen und echte Einarbeitung bleiben bei 0×**, und es ist
  Eigenprüfung. *Seit 2026-08-16.*
* **belegt** — ein Repo mit ≥ 3 Schreibern adoptiert die Baseline und meldet
  keinen der beschriebenen Ausfälle. Ebenso beobachtbar, aber **nicht von uns
  herbeiführbar**.

Wir können also entwerfen und proben und es trotzdem nicht wissen. Das ist
kein Einwand gegen das Vorhaben, sondern der Grund, die Stufen zu trennen —
sonst liest jemand später *„SOLL erreicht"*, wo eine frühere Stufe gemeint
war. Der Probelauf lieferte nebenbei eine **Verfeinerung**: Die stille
Register-Doppel-Zählung ([TB-011](#tb-011)) braucht **Abstand** — in kleinen
Registern kollidiert sie laut, still wird sie erst in großen, also genau dort,
wo auch das Wiedererkennen am teuersten ist. Und die TA-7-Reibung mit
Branch-Protection ist gemessen, nicht mehr vermutet (s06).

**Diese Datei** misst den Abstand und schlägt vor, wie er geschlossen wird. Sie
hat zwei Hälften: die [sieben Änderungen](#die-sieben-änderungen), die das SOLL
herstellen würden, und die [Bestandsaufnahme](#bestandsaufnahme), aus der sie
folgen. Die Einträge dort sind die **Belege** der Änderungen, nicht die
Gliederung.

**Abgrenzung zur [Roadmap](roadmap.md).** Dort stehen offene Fäden **dieses
Repos** mit Trigger. Hier steht die Vorarbeit für eine Änderung am **Produkt**.
Wird eine Änderung beschlossen, bekommt sie dort eine Zeile — nicht hier.

**Gegenstand** ist der gelehrte Korpus: `kurs/de` als Quelle, `lab/regelwerk`
als Spiegel, `lab/templates` als Ziel-Formen. Erreichbar ist diese Datei über
die Faden-Zeile *Team-Tauglichkeit des Korpus* in [`roadmap.md`](roadmap.md).

## Beleglage — was hier *nicht* gemessen ist

**Alle Einträge folgen aus der Ein-Schreiber-Annahme.** Was sie unterscheidet,
ist die **Evidenz** — die Klasse-Spalte des Registers führt sie.

**Klasse *Verhalten*** braucht ein Team, um beobachtet zu werden. Gemessen ist
dort nur die Beleglage: `git shortlog -sne HEAD` über die vier bekannten Repos,
die die Baseline tragen oder vendorn — `d-check`, `ai-harness-init`, `a-check`
und dieses — liefert **je genau eine Autoren-Identität**. Nach der Zählregel
([§Steering Loop](../kurs/de/grundlagen/klassifikation.md#steering-loop) —
1× Vorfall · 2× Symptom · 3× Lücke) stehen diese Einträge **bei 0×**.

**Klasse *Text* und *Sensor*** sind heute prüfbar — Lücken im Korpustext und am
Bestand, nachlesbar und nachgemessen.

**Was 0× bedeutet und was nicht.** Bei erklärtem SOLL ist die fehlende
Feld-Evidenz **kein Veto**, sondern eine **Design-Auflage**: *Entwurf* jetzt,
*Verkörperung* auf Trigger. Wir entwerfen ohne Praxis-Rückmeldung, also muss
jede Änderung so gebaut sein, dass sie sich zurücknehmen lässt — additiv,
deklariert, ohne den Ein-Personen-Fall zu verschlechtern. Das ist die Bauform,
die [§Vergabe](../kurs/de/grundlagen/source-precedence.md#vergabe-woher-die-nächste-nummer-kommt)
bereits vorführt: Default für einen Schreiber, deklarierte Variante für mehrere.

**Eine Zwischenlage:** Die *Eigentums-Achse* unter [TB-001](#tb-001) fehlt
nachweislich — `ai-harness-init` hat sie gemessen und mit einer eigenen ADR
beantwortet. Belegt ist damit die Lücke, nicht ihre Team-Folge.

Vollen Lifecycle führt von den vier Repos nur `ai-harness-init` — **Stand
2026-08-16**: 83 Slice-Nummern (87 Dateien, vier davon `a`/`b`-Nachschnitte),
19 ADRs, 10 Wellen, 24 `MR`, 2 Carveouts. Alle Bestands-Zahlen unten stammen
von dort und sind auf diesen Tag gemessen; das Repo bewegt sich unabhängig.

**Aufnahmekriterium.** Ein Befund steht hier nur, wenn er eine *Lücke im
Korpus* benennt, die aus der Ein-Personen-Annahme folgt. Nicht aufgenommen wird,
was mit mehr Menschen bloß **lästiger** wird, ohne dass eine Regel fehlt — das
gilt für jedes Problem und trägt nichts bei.

**Grenze der Messung.** Sie zählt Commit-Identitäten, nicht Menschen — ein
Squash-Merge-Workflow oder ein geteiltes Konto verbärge ein Team. Ob die
Baseline außerhalb dieser vier adoptiert wurde, ist von hier nicht beobachtbar.

**Was einen Befund auf 1× hebt:** ein Repo mit ≥ 3 Schreibern adoptiert die
Baseline, und der beschriebene Ausfall tritt dort auf und wird berichtet.

**Abdeckung.** Vollständig gelesen sind fünf Spiegel-Dateien
(`grundlagen-harness-dateien`, `modul-05`, `modul-06`, `modul-08`, `modul-10`),
abschnittsweise `grundlagen-klassifikation` und `grundlagen-source-precedence`.
Die übrigen 19 der 26 deckt nur eine Lexik-Probe auf *parallel · gleichzeitig ·
Merge · Konflikt · Team · Person · Onboarding · Kollision · Eigentümer* — sie
zeigt, wo die Frage vorkommt, nicht, wo sie fehlt. Ein Befund, der ohne eines
dieser Wörter auskommt, kann dort unentdeckt liegen. Zitiert wird aus `kurs/de`
als Quelle, gelesen wurde der Spiegel, weil er beim Adopter ankommt.

## Was schon trägt — geprüft, ohne Befund

Ein Register, das nur Lücken listet, überzeichnet sie. Modul 10 verlangt
deshalb die
[Negativbefund-Zeile](../kurs/de/04-qualitaet/modul-10-review-harness.md#reviewer-berichtet-auch-was-er-nicht-gefunden-hat):
*„geprüft, ohne Befund"* macht die Abdeckung sichtbar. Drei Stellen halten dem
Mehr-Personen-Fall stand — dazu kommen die drei gestrichenen Einträge im
[Register](#register):

| Ort | Warum es trägt |
|---|---|
| [§Vergabe: woher die nächste Nummer kommt](../kurs/de/grundlagen/source-precedence.md#vergabe-woher-die-nächste-nummer-kommt) | Die Frage ist dort **ausdrücklich gestellt und beantwortet** — laute Ablage (`LH-*`, `SPEC-*`, `ARC-*`: viele IDs in einer Datei → Git-Konflikt) gegen stille (ADR, Slice, Carveout: je eigene Datei → lautloser Doppelvergabe-Merge), Bereichssegment als Antwort, Grenze benannt (*„Zwei in **derselben** schon — und das ist Absicht"*), Wahl deklarationspflichtig (*„Welche Form gilt, deklariert das Repo"*). Die Prognose für einen Schreiber — *„braucht kein Segment"* — trifft am Bestand zu: In `ai-harness-init` zählen ADR (`0001`–`0019`), Welle (`01`–`10`), `MR` (`000`–`023`) und Carveout (`CO-001`/`CO-002`) dicht und **ohne** Segment. Drei Einzelheiten hält der Abschnitt trotzdem nicht — [TB-009](#tb-009), [TB-010](#tb-010), [TB-013](#tb-013) |
| Index + eine Datei je `MR` ([§harness/conventions.md als Konventionsspeicher](../kurs/de/grundlagen/harness-dateien.md#harnessconventionsmd-als-konventionsspeicher)) | Begründet ist der Schnitt mit Agenten-Kontextkosten. Er hat einen **nicht genannten Nebeneffekt**: Zwei Leute können parallel an `MR-005` und `MR-006` schreiben, ohne dieselbe Datei zu berühren, während ihre beiden Index-Zeilen in *einer* Tabelle landen und dort als Git-Konflikt sichtbar werden. Der Index ist damit ein teilweiser Wächter — vollständig ist er nicht, siehe [TB-009](#tb-009) |
| Append-only für ADR und `MR` (Folge-ADR mit `supersedes`, Rückbau als neuer Eintrag) | Zwei Leute überschreiben nie denselben Text. Die Disziplin, die für Auditierbarkeit erfunden wurde, ist zugleich die konfliktärmste Schreibform, die es gibt |

Die Lücken unten sind also **keine Unkenntnis**. Es sind Stellen, an denen
dieselbe Frage nicht gestellt wurde.

## Rolle, Person, Zuweisung — drei Achsen, zwei ohne Wort

Vor allen Befunden steht eine Unterscheidung, ohne die mehrere von ihnen falsch
gelesen werden. Der Korpus arbeitet mit **drei** verschiedenen Größen, hat aber
nur für eine ein Vokabular:

| Achse | Frage | Im Korpus |
|---|---|---|
| **Rolle** | Aus welcher Urteilsperspektive, mit welchem Eingabe-Kontext? | vollständig ausgearbeitet — sechs Rollen, neun Übergaben, Artefaktklasse je Rolle |
| **Person** | Wer arbeitet tatsächlich? | nur in **einer** Richtung |
| **Zuweisung** | Wer hält *diese Instanz* gerade? | kein Wort |

**Die Richtung ist gemessen.** Jede Person-Nennung in `kurs/de` verläuft
*n Rollen ← 1 Person*: *„Eine Person kann mehrere Rollen spielen"* (Modul 8,
dreimal), *„Eine Person spielt alle Rollen"* (Lernervorstellung), und Modul 15
präzisiert *„Eine Rolle wird von einem **Lauf** getragen, nicht von der Person,
die ihn startet"*. Die **Gegenrichtung — eine Rolle, mehrere Personen — kommt
nirgends vor.** Das ist keine Auslassung im Detail: Es ist genau die
Multiplikation, die ein Team ausmacht.

**Warum das die Befunde ordnet.** Eine Regel der Form *„die Rolle X tut Y"* ist
bei einer Person eindeutig, weil Rolle und Person zusammenfallen. Sobald X von
mehreren gefüllt wird, zerfällt sie in zwei Lesarten — *pro Rolle* oder *pro
Person, die sie gerade füllt* —, und der Korpus hat kein Wort, um die gemeinte
zu bezeichnen. [TB-004](#tb-004) trägt diese Klasse,
[TB-001](#tb-001) die dritte Achse.

**Und es entwertet keine bestehende Regel.** *„Rollen-Trennung ist
Kontext-Trennung, nicht Personen-Trennung"* bleibt richtig — Rollen an Personen
zu binden wäre der Fehler, gegen den der Satz geschrieben ist. Was fehlt, steht
daneben, nicht dagegen.

## Was ein Gate davon sähe — und was nicht

Die drei Klassen des Registers beantworten zwei Fragen auf einmal — ob ein Team
nötig ist, um den Befund zu *sehen*, und ob eine Maschine ihn sehen könnte. Das
ist kein Zufall: Was ein Team hinzufügt, sind **Vorkommen**; was ein Sensor
braucht, sind **Artefakte**. Was heute im Artefakt steht, ist ohne Team sichtbar.

**Verhalten** — der Korpus teilt fast jede Regel in eine Hälfte, in der ein
Mensch urteilt, und eine, in der ein Sensor Deckung prüft. Diese Einträge fallen
ganz in die erste. Ein Sensor sieht einen fehlenden Anker, eine nach `Accepted`
veränderte ADR oder eine `BEO-<NNN>` ohne Registerzeile. Er sieht **nicht**, dass
eine Regel von zwei Personen verschieden gelesen wird, dass ein Streit nie
entschieden wurde oder dass niemand weiß, wem ein Slice gehört.

**Text** — auch hier fängt kein Gate etwas, aber aus anderem Grund: Es fehlt
kein Urteil, sondern ein **Satz**. *„Diese Aufzählung ist unvollständig"*
konfiguriert man nicht, das liest man.

**Sensor** — hier fehlt kein Sensor-*Prinzip*, sondern ein Sensor. Der Korpus
räumt es für die Doppelvergabe selbst ein: *„kein Modul des Doku-Gates prüft
Eindeutigkeit heute … ein Review-Griff."*

**Was daraus folgt.** Für die Klasse *Verhalten* — die Mehrheit — gilt: **Ein
Repo mit drei Schreibern wäre nach jeder Messung, die der Harness anbietet,
kerngesund**, während genau diese Stellen nachgeben. Das ist keine Schwäche der
Gates, sondern die Grenze, die der Korpus selbst zieht; sie gehört nur
mitgedacht, wenn man aus „alles grün" auf „trägt auch zu dritt" schließt. Die
Unterscheidung ist keine Feinheit: Sie entscheidet, ob ein Befund auf eine
Regeländerung wartet oder auf ein Target.

## Register

Die Einträge tragen **Kennungen statt Positionsnummern**. Grund ist gemessen und
nicht theoretisch: Diese Liste wurde beim Entstehen dreimal umnummeriert, weil
Einträge wegfielen — jeder Verweis auf „Befund 5" zeigte danach woanders hin.
Das ist genau der Fall, für den
[§ID-Schema als Klammer](../kurs/de/grundlagen/source-precedence.md#id-schema-als-klammer)
die stabile Kennung vorsieht, und adressiert wird deshalb die **Kennung, nicht
der Titel** — jeder Eintrag trägt ein `<a id="tb-NNN">`.

`TB-<NNN>` (Befund) und `TA-<N>` (Anpassung) werden **nur in dieser Datei
vergeben** und sind überall im Repo zitierbar (Plan, CHANGELOG); in keinem Gate.
Vergeben wird chronologisch nach Fund, Lücken werden nicht nachbelegt.
Die `TA-`-Spalte verweist auf die [Änderung](#die-sieben-änderungen), die den
Befund schließt — jeder offene Befund hat genau eine oder zwei.
Gestrichene Einträge bleiben mit Grund stehen — eine still gelöschte Zeile ist
von einer nie vergebenen nicht zu unterscheiden
([Modul 6 §Das Beobachtungs-Register](../kurs/de/02-planung/modul-06-roadmap.md#das-beobachtungs-register)),
und ohne den Grund prüft der Nächste dieselbe Sackgasse noch einmal.

**Die Abschnitte unten stehen numerisch, nicht nach Schwere.** Das ist
Absicht: Trüge die Position eine Bewertung, verschöbe jede Neubewertung
Abschnitte — genau die Wanderung, gegen die die Kennungen eingeführt wurden.
Die Rangfolge steht in [§Reihenfolge und Abhängigkeiten](#reihenfolge-und-abhängigkeiten), wo sie sich ändern
darf, ohne etwas zu bewegen.

| Kennung | Klasse | Änderung | Eintrag | Stand |
|---|---|---|---|---|
| [TB-001](#tb-001) | Verhalten | [TA-1](#ta-1) [TA-2](#ta-2) | Der Lifecycle ist ein Zustand ohne Subjekt | **umgesetzt (Welle 76/77)** — das Feld existiert; die TA-2-Restzeile (P3) betrifft [TB-014](#tb-014), nicht diesen Befund |
| TB-002 | — | — | *Der Zähler zählt Beobachtungen, nicht Beobachter* | **gestrichen** — der Zähler steht in einer stehenden Datei und wird bei jeder Slice-Closure fortgeschrieben, gleich von wem; das Register-Beispiel des Kurses ist selbst der Drei-Slices-Fall. Der Sichtungs-Schritt (§8) ist Pflicht in *jedem* Slice-Plan, und die Sub-Area-Spalte trägt bewusst die normative Sub-Area. Person-unabhängig gebaut |
| TB-003 | — | — | *Die Welle ist ein Join-Barrier* | **abgelöst** durch [TB-014](#tb-014) — die Barriere setzt voraus, dass die Einzahl von *Aktuelle Welle* bindet; sie bindet nicht |
| [TB-004](#tb-004) | Verhalten | [TA-1](#ta-1) | Eine Rolle, mehrere Personen | **umgesetzt (Welle 76)** |
| TB-005 | — | — | *Der Planner ist Single Writer* | **gestrichen** — kein eigener Befund: „Durchsatz-Engpass" ist Volumen, nicht Lücke; der Rest ist [TB-004](#tb-004) |
| [TB-006](#tb-006) | Verhalten | [TA-1](#ta-1) [TA-6](#ta-6) | Der Konflikt-Pfad hat kein Terminal | **umgesetzt (Welle 76)** |
| [TB-007](#tb-007) | Verhalten | [TA-5](#ta-5) | Einarbeitung wurde nie als Kosten geführt | **umgesetzt (Welle 79)** |
| TB-008 | — | — | *Lokale Gates mal drei Maschinen* | **gestrichen** — die Regel steht richtig da, und die Messung dazu (lokal gegen CI) betrifft zwei Umgebungen, nicht zwei Menschen. Reiner Druckunterschied |
| [TB-009](#tb-009) | Text | [TA-3](#ta-3) | MR steht in keiner der beiden Vergabe-Klassen | **umgesetzt (Welle 79)** |
| [TB-010](#tb-010) | **Sensor** | [TA-3](#ta-3) | „Lokal ableitbar" gilt nicht bei Vorvergabe | **umgesetzt (Welle 79)** — die Zusage trägt ihre Grenze; das Eindeutigkeits-Gate bleibt Option |
| [TB-011](#tb-011) | Verhalten | [TA-4](#ta-4) [TA-7](#ta-7) | Auswertbar erst nach dem Merge | **umgesetzt (Welle 77)** |
| [TB-012](#tb-012) | Text | [TA-2](#ta-2) [TA-4](#ta-4) | Die Planning-README trägt zwei Begriffe ohne Quelle | **umgesetzt (Welle 77)** |
| [TB-013](#tb-013) | Text | [TA-3](#ta-3) | Die Welle fällt aus dem Zählraum-Schema | **umgesetzt (Welle 79)** |
| [TB-014](#tb-014) | Verhalten | [TA-2](#ta-2) | „Aktuelle Welle" ist keine Eigenschaft des Repos | **umgesetzt (Welle 78)** — *Offene Wellen* derivativ, Beförderung entfällt |

## Die sieben Änderungen

Die zehn Einträge der Bestandsaufnahme fallen auf sieben Änderungen zusammen;
keiner fällt heraus. Jede ist **additiv und deklariert** — sie verschlechtert
den Ein-Personen-Fall nicht, und sie lässt sich zurücknehmen.

<a id="ta-1"></a>

### TA-1 — Ein Wort für die Person, die eine Rolle gerade füllt · **umgesetzt (Welle 76)**

**Deckt** [TB-004](#tb-004) (definitorisch) · [TB-001](#tb-001) (WIP-Lesart) ·
[TB-006](#tb-006) (welcher Architect).

**Was fehlt.** Der Korpus modelliert nur *n Rollen ← 1 Person*. Für die
Gegenrichtung — eine Rolle, mehrere Menschen — gibt es kein Wort, und deshalb
zerfällt jede Regel der Form *„die Rolle X tut Y"* in zwei Lesarten.

**Vorschlag.** Der Begriff **Rolleninhaber**: *wer eine Rolle in einem
konkreten Lauf füllt*. Im Korpus heute unbelegt; `Träger` scheidet aus, das ist
dort schon der Träger einer Pflicht.

**Wo es landet.**

| Ort | Änderung |
|---|---|
| Modul 8 §Rollen-Regeln | ein Satz: *Eine Rolle kann von mehreren Menschen gefüllt werden; wer sie in einem Lauf füllt, ist ihr Rolleninhaber.* |
| Modul 5 §Selbstcheck-Rubrik | „WIP-Limit pro Implementer" → **pro Rolleninhaber** |
| Modul 8 §Konflikt-Pfad | das Verdikt nennt den entscheidenden Rolleninhaber, nicht nur die Rolle |
| Modul 10, die zwei Drift-Sätze (Worked-Example-Intro · Fehlvorstellung) | Drift „zwischen Sessions" → „zwischen Sessions **und zwischen Rolleninhabern**"; Abweichung zwischen Inhabern ist **Dissens**, nicht Nicht-Determinismus |

**Preis.** Ein neuer Begriff in einem Korpus, der mit Vokabular sparsam ist.
Und er muss ausdrücklich *nicht* als Rückkehr zur Personen-Bindung gelesen
werden — *„Rollen-Trennung ist Kontext-Trennung"* bleibt unverändert gültig;
der Rolleninhaber steht daneben, nicht dagegen.

**Was es nicht löst.** Es macht die Zweideutigkeit *sagbar*, es entscheidet
nichts. [TB-006](#tb-006) braucht zusätzlich ein letztes Artefakt — das ist [TA-6](#ta-6).

<a id="ta-2"></a>

### TA-2 — Ein Ort für die Zuweisung · **umgesetzt (Welle 77/78)**

**Deckt** [TB-001](#tb-001) · [TB-014](#tb-014) · [TB-012](#tb-012) (erste Hälfte).

**Was fehlt.** *Wer hält diese Instanz gerade* hat im Korpus keinen Ort. Die
Verzeichnis-Position trägt den **Zustand**, nicht den **Inhaber**.

**Vorschlag.** Die Hälfte existiert bereits: `welle.template.md` führt
`**Verantwortlich:** <Name>`, `welle-results.template.md` ebenso. Der Slice —
das Artefakt, das den Lifecycle *trägt* — hat kein solches Feld. Also
**dasselbe Feld im Slice-Kopf**, symmetrisch zur Welle.

**Wo es landet.**

| Ort | Änderung |
|---|---|
| `slice.template.md` | Kopf-Feld `**Verantwortlich:** <Name>` oder `—` |
| Modul 5 §Trigger je Lifecycle-Übergang | `open→next` setzt es — was die Planning-README-Vorlage heute schon behauptet, ohne dass es ein Feld gäbe |
| Modul 6 §Aktuelle Welle | entfällt zugunsten der Ableitung, siehe [TB-014](#tb-014) |

**Warum das kein Status-Feld ist.** Modul 5 verbietet eine *zweite Quelle für
denselben Zustand*. Eigentümerschaft ist eine **orthogonale Achse** zur
Lifecycle-Position, keine zweite Fassung davon — die Warnung trifft sie nicht.

**Preis.** Ein Feld, das altern kann (jemand geht, übergibt). Gemildert
dadurch, dass es je Datei liegt und der Lifecycle-`git mv` die Datei ohnehin
anfasst.

**Was es nicht löst.** Auf einem Zweig ist das Feld so unsichtbar wie die
Verzeichnis-Position — das ist TA-4.

#### Die Welle braucht dafür kein Feld

Für die *Welle* ist die Zuweisung schon ableitbar — zwei positionale Tatsachen genügen, ein Feld braucht es dort nicht:

- **Welche Wellen offen sind** — die flachen Dateien unter `planning/`.
- **An welchen davon gearbeitet wird** — das Kopf-Feld `**Welle:**` der Dateien
  in `in-progress/`. Es existiert in jedem Slice-Plan
  ([`slice.template.md`](../lab/templates/docs/plan/planning/slice.template.md))
  und trägt entweder die Wellen-Kennung oder *„ohne Welle"*.

Damit braucht die Roadmap das Feld nicht. Keine der beiden Tatsachen ist ein
Ganz-Wert; beide liegen je Datei und können deshalb **nicht still falsch
mergen**.

**Warum „ableiten" vorher wie ein schlechter Weg aussah.** Der naheliegende
Einwand lautet, die Ableitung versage bei *keiner* und bei *mehreren* laufenden
Wellen. Unter diesem Befund sind das keine Fehlschläge, sondern die **richtigen
Antworten** — der Einwand lebte von genau der Einzahl-Annahme, die hier fällt.

**Was es kostet.** Das `**Welle:**`-Feld wird tragend, und
[Modul 6](../kurs/de/02-planung/modul-06-roadmap.md#wann-arbeit-eine-welle-braucht--und-wann-nicht)
spielt es derzeit herunter: *„Das Kopf-Feld `**Welle:**` eines Slice-Plans sagt
**etwas anderes** — ob *dieser* Slice in ein Bündel gehört —, und daraus folgt
für die Vorgänge unten **nichts**."* Das zielt auf eine andere Frage — ob das *Repo* Wellen führt —, ist
also kein Widerspruch; aber die neue Last müsste dort ausgesprochen werden.

**Was es nicht behebt.** `in-progress/` ist zweigelokal ([TB-011](#tb-011)), die
Ableitung erbt das. Sie verschlechtert nichts: Statt eines Feldes, in das zwei
Personen Wahres schreiben und eines davon verlieren, sieht man den Stand von
`main` — unvollständig, aber nie falsch. Die unauflösbare Konfliktklasse
verschwindet.


<a id="ta-3"></a>

### TA-3 — Kennungs-Vergabe unter Nebenläufigkeit · **umgesetzt (Welle 79)** — Text-Korrekturen; die Schema-Frage bleibt Abwägung

**Deckt** [TB-009](#tb-009) · [TB-010](#tb-010) · [TB-013](#tb-013).

**Was fehlt.** §Vergabe beantwortet die Kollisionsfrage für einige Kennungen,
nicht für alle — und eine seiner Zusagen hält nicht.

**Wo es landet.**

| Ort | Änderung |
|---|---|
| §Vergabe, Klassen-Aufzählung | `MR-<NNN>` aufnehmen und als **Hybrid** führen: Eintragsdatei still, Index-Zeile laut |
| §Vergabe, Zählraum | die Welle beantworten — repo-weit dicht, **kein** Bereichssegment, weil sie Slices über Sub-Areas hinweg bündelt |
| §Vergabe, Ableitbarkeit | die Zusage einschränken: Der Zählraum ist Verzeichnis **plus offene Wellen plus offene PRs**; letztere sind lokal nicht auflistbar |

**Optional, größer:** das Schema selbst. Die Abwägung dazu steht unten.

**Und ein Gate ist möglich.** Als einzige der sieben Änderungen hat diese eine
computationale Hälfte: Eindeutigkeit der Kennungen ist prüfbar, und der Korpus
räumt selbst ein, dass heute kein Modul es tut.

**Was es nicht löst.** Zwei Personen, die dasselbe unter verschiedenen Namen
tun, kollidieren in keinem Schema — das ist keine Frage des Schemas, sondern
der Sichtbarkeit des Plans, und damit [TA-7](#ta-7).

#### Die Abwägung — Skizze, keine Entscheidung

**Die Randbedingung streicht die Standardantwort.** Der übliche Weg gegen
Vergabe-Kollisionen ist ein zentraler Allokator (Sequenz, Ticket-System, Bot
beim Merge). Der [Traceability-Constraint](../kurs/de/grundlagen/traceability.md#traceability-constraint)
verbietet ihn: *„wer sie erst beim Landen bekommt, hat sie im entscheidenden
Moment nicht."* Die Kennung muss **lokal, offline, vor dem ersten Push**
ableitbar sein.

**Was der Zähler dafür einbringt — nachgerechnet:**

| | trägt es? |
|---|---|
| Reihenfolge | nein — Datum/Zeit, und ohnehin `git` |
| Anzahl | nein — `ls \| wc -l` |
| Kürze | nein — der nackte Zähler ist zwar kürzer (`slice-086`, 9 Zeichen), aber die **Reparatur des Schemas gibt sie auf**: `slice-IDX-007` (13) ist länger als eine segmentlose Zufalls-ID (`slice-7f3a2b`, 12). Verteidigt wird die Kürze also nicht vom Zähler, sondern von seiner ungelösten Fassung |
| Sub-Area | **ja — gehört aber dem Präfix**, nicht dem Zähler; jedes Schema kann es tragen |
| Lückenlosigkeit als Vollständigkeitsprobe | schwach: hat genau diesen Befund zutage gefördert, aber Lücken sind laut Korpus legitim |

Die einzige Eigenschaft, die **nur** der Zähler hat — man kennt die nächste
Nummer, ohne jemanden zu fragen —, *ist* der Defekt. Nutzen und Fehler sind
dieselbe Sache; deshalb kann keine Lösung innerhalb des Schemas mehr als
mildern.

**Drei Familien, nach der Randbedingung gefiltert.** *Partitionieren* (die Wahl
des Korpus) senkt die Wahrscheinlichkeit; *Block-Reservierung* (Hi/Lo) beseitigt
sie, koordiniert aber selten statt nie; *den geteilten Wert abschaffen*
(Zufall · Zeitstempel · Slug) braucht überhaupt keine Koordination. Quer dazu
liegt ein **Detektor**: ein Eindeutigkeits-Gate macht die stille Klasse laut,
ohne das Schema anzufassen — und der Korpus räumt selbst ein, dass es baubar
wäre: *„kein Modul des Doku-Gates prüft Eindeutigkeit heute … ein
Review-Griff."*

**Segment behalten, Zähler ersetzen.** Dass das Segment nicht dem Zähler
gehört, zeigt der Korpus selbst: Er verwirft ein Personen- oder Branch-Segment,
obwohl es *„die Garantie gäbe"* — weil es *„dem Reviewer nichts"* sagt.
Ausgewählt wird das Segment also nach **Lesbarkeit**, nicht nach
Kollisionsschutz. Zwei Kandidaten:

- `slice-IDX-7f3a` — kollisionsfrei, Länge wie heute, aber eine Kollision
  bliebe bedeutungslos.
- `slice-IDX-cache-invalidation` — **der Slug steht schon in jedem Dateinamen**
  (`slice-072-adr-verweist-nicht-auf-lifecycle.md`); die Umstellung *entfernt*
  den Zähler, statt etwas hinzuzufügen. Zwei Personen am selben Gegenstand
  erzeugen denselben Pfad und damit einen add/add-Konflikt — der Anspruch des
  Korpus, *„einen stillen Merge-Unfall in ein inhaltliches Signal"* zu
  verwandeln, vollständig eingelöst statt teilweise.

**Ehrliche Kosten.** Der Slug kostet Token-Länge (9 → 34–42 Zeichen, gemessen
an realen Slices) und hat eine gespiegelte Schwäche: Dieselbe Arbeit unter
verschiedenen Namen kollidiert **nicht**. Und zwei Stellen tragen die Form
maschinell — `token: 'slice-\d{3}'` im `matrix`-Modul beider Konfigurationen
sowie die Beleg-Formprobe des Registers; beide müssten dauerhaft *zwei* Muster
kennen.

**Migration ist keine Kostenposition.** Vergebene Nummern kollidieren nicht —
das Risiko liegt ausschließlich in der *nächsten* Vergabe, ein Wechsel wirkt
also sofort, obwohl er nur nach vorn gilt. Der Korpus schreibt genau das vor:
*„Mischung ist billiger als Migration … behält die alten Kennungen und vergibt
nur neue … Wer später wechselt, notiert den Wechselpunkt."* Der Ort dafür ist
die ID-Schema-Deklaration in `harness/conventions.md`. Bemerkenswert dabei:
Dass Kennungen nie umbenannt werden, sieht wie Starrheit aus — es ist die
Eigenschaft, die jeden Schema-Wechsel additiv und damit billig macht.

<a id="ta-4"></a>

### TA-4 — Sagen, über welchen Stand die Regeln sprechen · **umgesetzt (Welle 77)**

**Deckt** [TB-011](#tb-011) · [TB-012](#tb-012) (zweite Hälfte).

**Was fehlt.** Der Korpus behandelt das Repo als **einen** fortlaufend
beobachtbaren Zustand. Mit Pull Requests sind es n + 1, und jede Lese-Operation
der Planung trifft den gemergten.

**Vorschlag.** Keine neue Mechanik — eine **Deklaration**. Jede Aussage über
die Verzeichnis-Position bekommt ihren Geltungs-Stand.

**Wo es landet.**

| Ort | Änderung |
|---|---|
| Modul 5 §Lifecycle als State Machine | ein Absatz: Aussagen über die Verzeichnis-Position gelten für den **gemergten** Stand; auf einem Zweig sieht man den eigenen |
| Modul 6, `ls`-Zusage | „autoritativ und ohne Pflegeaufwand" um den Stand ergänzen |
| Modul 5/6, Sichtungs-Schritt | benennen, dass das Register beim Lesen so alt ist wie der letzte Merge |
| `planning/README.template.md` | `in-progress/` = *„Branch / PR existiert"* bekommt eine Quelle — heute steht das nur auf Rang 3 |

**Preis.** Eine bequeme Vereinfachung wird ausdrücklich, und mehrere Sätze
werden länger.

**Was es nicht löst.** Es macht Zweig-Stände nicht sichtbar — es hindert den
Korpus nur daran, mehr zu versprechen, als er halten kann. Sichtbar macht sie
[TA-7](#ta-7).

<a id="ta-5"></a>

### TA-5 — Leseordnung und Rückbau von Regeln · **umgesetzt (Welle 79)**

**Deckt** [TB-007](#tb-007).

**Was fehlt.** Zwei Dinge, die dieselbe Wurzel haben: Es gibt keine
**Leseordnung** für einen neuen Menschen, und es gibt für **Hard Rules und
Skill-HIGH-Einträge** keinen Rückbau — für `MR`, Carveout und ADR schon.

**Wo es landet.**

| Ort | Änderung |
|---|---|
| [§harness/README.md als Einstiegspunkt](../kurs/de/grundlagen/harness-dateien.md#harnessreadmemd-als-einstiegspunkt) | die **Pflichtgliederung** bekommt die Zeile *Leseordnung* — zuerst die Quelle, sonst wäre die Template-Sektion unten Template-Drift ([TB-012](#tb-012)-Klasse) |
| `harness/README.template.md` | die Pflicht-Sektion *Leseordnung* — was zuerst, was bei Bedarf; die sieben Nachschlage-Sektionen bleiben, was sie sind |
| Modul 9 / Modul 13, Hard Rules | jede Hard Rule bekommt wie ein Carveout einen **Auflösungs-Trigger oder die Kennzeichnung permanent** |
| Modul 10 §Pflege | dasselbe für HIGH-Einträge des Reviewer-Skills |

**Preis.** Der teuerste der sieben. Der Rückbau-Trigger belastet jede Hard Rule
mit einem Feld, und die Leseordnung ist ein Artefakt, das gepflegt werden will.

**Grenze, ausdrücklich deklariert.** Den **Bestand zu verkleinern ist nicht
Gegenstand dieser Anpassung** und auch nicht dieses Dokuments. Der
Rückbau-Trigger bremst das Wachstum, und das ist für Teamfähigkeit das Nötige;
eine Verschlankung des vorhandenen Korpus ist ein eigenes Vorhaben mit eigenem
Maßstab — was gestrichen werden darf, entscheidet nicht die Team-Frage. Wird sie
gebraucht, gehört sie als eigener Faden in die [Roadmap](roadmap.md), nicht
hierher.

<a id="ta-6"></a>

### TA-6 — Ein letztes Artefakt im Konflikt-Pfad · **umgesetzt (Welle 76)**

**Deckt** [TB-006](#tb-006).

**Was fehlt.** Modul 8 modelliert den Rollen-Konflikt als Sequenz mit
Übergabe-Artefakten und verbietet die Entscheidung nach Seniorität — benennt
aber kein **letztes** Artefakt. Zwischen Kontextfenstern fällt das nicht auf,
weil dort niemand widerspricht. Zwischen Menschen *dokumentiert* ein Artefakt
die Uneinigkeit; es beendet sie nicht.

**Vorschlag.** Kein neues Konstrukt: **Übersteht die Uneinigkeit das
Architect-Verdikt, wird das Verdikt zur ADR.** Der Vorgang endet dann nicht
dadurch, dass jemand recht bekommt, sondern dadurch, dass die Entscheidung
**immutabel** wird. Widerspruch muss danach den ADR-Weg gehen — Folge-ADR mit
`Supersedes` —, und der verlangt **neue Evidenz statt Wiederholung**. Die
abweichende Position verliert nichts: Sie steht in §Verglichene Alternativen.

**Warum das das Seniorität-Verbot nicht verletzt.** Der Korpus verbietet
Seniorität als *Argument*. Eine Instanz, die *abschließt*, ist etwas anderes —
und die ADR schließt nicht durch Autorität einer Person, sondern durch die
Immutabilitäts-Regel, die für alle gleich gilt.

**Wo es landet.**

| Ort | Änderung |
|---|---|
| Modul 8 §Konflikt-Pfad | ein vierter, *terminaler* Ausgang: Verdikt bestritten → Verdikt wird ADR; danach nur noch Folge-ADR mit neuer Evidenz |
| Modul 8, Verdikt-Tabelle | die drei Verdikte bleiben; das Terminal greift, wenn keines akzeptiert wird |
| Modul 4 | ein Satz, dass eine ADR auch aus einem beigelegten Rollen-Konflikt entstehen kann — heute entsteht sie nur aus Architektur-Entscheidungen |

**Preis.** ADR-Inflation, wenn der Weg zu leicht beschritten wird. Gemildert
dadurch, dass er erst greift, wenn ein Verdikt *bestritten* wird — nicht bei
jedem HIGH-Finding.

**Was es nicht löst.** Es erzwingt keine Einigkeit, sondern beendet die
Wiederholung. Wer die Entscheidung weiter für falsch hält, braucht Evidenz.

<a id="ta-7"></a>

### TA-7 — Der Lifecycle-Übergang landet auf dem Hauptzweig · **umgesetzt (Welle 77)**

**Deckt** den Rest von [TA-4](#ta-4) (Zweig-Stände unsichtbar) und den von
[TA-3](#ta-3) (dieselbe Arbeit unter verschiedenen Namen); Beleg ist
[TB-011](#tb-011).

**Was fehlt.** [TA-4](#ta-4) sagt ehrlich, über *welchen* Stand die Regeln
sprechen — es macht den Zweig-Stand aber nicht sichtbar. Solange der `git mv`
nach `in-progress/` im PR mitreist, ist `ls in-progress/` auf dem Hauptzweig
für laufende Arbeit leer, und niemand sieht, was ein anderer angefangen hat.

**Vorschlag.** Die Mechanik ist schon da, nur der Zeitpunkt fehlt: Der Übergang
ist bereits ein **reiner `git mv` in einem eigenen Commit**
([Modul 9 §Hard Rules](../kurs/de/03-agenten/modul-09-implementierung.md#hard-rules-repo-spezifisch)).
Ergänzt wird, **wann** er landet — **vor** der Arbeit und direkt auf dem
Hauptzweig, nicht im PR.

Damit wird `ls in-progress/` team-weit wahr, das `**Verantwortlich:**`-Feld aus
[TA-2](#ta-2) wird im Moment des Anspruchs sichtbar, und der Doppelarbeits-Fall
löst sich: Wer anfangen will, sieht den Anspruch, bevor er anfängt.

**Warum das den TA-3-Rest miterledigt.** Zwei Personen können nur dann unbemerkt
dasselbe tun, wenn **mindestens eine nicht geplant hat** — ein Slice muss
geschnitten sein, bevor er läuft. Der Rest war also nie ein Loch im
Kennungs-Schema, sondern eines in der Sichtbarkeit des Plans.

**Wo es landet.**

| Ort | Änderung |
|---|---|
| Modul 5 §Trigger je Lifecycle-Übergang | `next→in-progress` landet **auf dem Hauptzweig, vor der Arbeit** |
| Modul 5 §Lifecycle als State Machine | ein Satz, warum: sonst ist der Zustand zweigelokal und die `ls`-Zusage gilt nur für den eigenen Baum |
| Modul 9 §Hard Rules | der bestehende „reiner `git mv`"-Satz bekommt den Zeitpunkt dazu |

**Preis.** Schreibzugriff auf den Hauptzweig für einen inhaltslosen Commit. Das
berührt [§Vergabe](../kurs/de/grundlagen/source-precedence.md#vergabe-woher-die-nächste-nummer-kommt)
(*„braucht dafür weder eine Absprache noch einen Schreibzugriff auf den
Hauptzweig"*) — dort geht es aber um das **Ableiten einer Nummer**, nicht um
das **Beanspruchen einer Arbeit**. Die beiden Aussagen müssen im selben Zug
gegeneinander abgegrenzt werden, sonst widersprechen sie sich dem Anschein nach.

Und der gemessene Konsument tut es faktisch schon so: In `ai-harness-init` lagen
Slices historisch in `in-progress/` auf `main`.

**Was es nicht löst.** Das Beobachtungs-Register: `BEO`-Erhöhungen entstehen bei
der Closure und reisen weiter im PR mit. Der Sichtungs-Schritt liest also
weiterhin einen Stand, der bis zu einen Merge alt ist.

<a id="bestandsaufnahme"></a>

## Bestandsaufnahme

Die Belege der sieben Änderungen. Reihenfolge numerisch, nicht nach Schwere —
siehe [Register](#register).

<a id="tb-001"></a>

## TB-001 — Der Lifecycle ist ein Zustand ohne Subjekt

**Was dastand** (behoben in Welle 76/77 — die Zitate unten sind der Zustand davor). *„Der Zustand ist das Verzeichnis, nicht ein Kopffeld"*
([Modul 5 §Lifecycle als State Machine](../kurs/de/02-planung/modul-05-planning-harness.md#lifecycle-als-state-machine))
und *„`ls docs/plan/planning/in-progress/` beantwortet »was läuft gerade«
autoritativ und ohne Pflegeaufwand"*
([Modul 6](../kurs/de/02-planung/modul-06-roadmap.md#wann-arbeit-eine-welle-braucht--und-wann-nicht)).

**Warum es bei einem trägt.** Die Antwort ist vollständig. Es gibt nur einen
möglichen Bearbeiter.

**Was bei dreien bricht.** *„Was läuft"* ist nicht mehr die Frage — **„wer hat
es"** ist es, und die Ablage kann sie nicht beantworten. Der Trigger
`next→in-progress` sagt *„Implementer übernimmt"*, aber die Übernahme
hinterlässt keinen Beleg. Zwei Leute ziehen denselben Slice; der zweite
`git mv` kollidiert — laut, das ist der gute Fall — nur ist die Arbeit dann
schon doppelt getan. Und `WIP-Limit pro Implementer = 1` wird **unprüfbar**:
Man kann nicht pro Person zählen, wenn die Ablage keine Person kennt — die
Regel ist dann schon zweideutig ([TB-004](#tb-004)) *und* zusätzlich unbelegbar. Mit drei
Implementern liegen legitim drei Dateien in `in-progress/`, und die Aussage der
Ablage sinkt von *autoritativ* auf *nichtssagend*.

**Warum die naheliegende Lösung nur scheinbar verboten ist.** Ein
`Assignee:`-Feld sieht aus wie die *„zweite Quelle für denselben Zustand"*, vor
der Modul 5 warnt. Ist es nicht: Eigentümerschaft ist eine **orthogonale
Achse** zur Lifecycle-Position, nicht eine zweite Fassung davon.

**Und es gibt sie bereits — für die Welle.** `welle.template.md` trägt
`**Verantwortlich:** <Name>`, `welle-results.template.md` ebenso. Der Slice,
der den Lifecycle *trägt*, hat kein solches Feld: Sein Kopf führt Lifecycle,
Welle, Bezug und berührte Spec-Stellen. Die Achse fehlt also nicht im ganzen
Korpus, sondern genau am Artefakt, an dem sie gebraucht wird — und in
`kurs/de` wird sie nirgends gelehrt (siehe [TB-012](#tb-012)).

**Die fehlende Achse ist belegt, die Team-Folge nicht.** `ai-harness-init` hat
denselben Mangel an einer anderen Artefaktklasse getroffen und in
`docs/plan/adr/0015-rollen-eigentum-an-norm-artefakten.md` (Accepted,
2026-08-09) festgehalten: gemessen über alle 26 Regelwerk-Dateien:
*„**Keine** Datei benennt eine schreibende Rolle für `AGENTS.md` oder
`harness/conventions.md`."*. Die ADR benennt auch, warum die vorhandene Tabelle
nicht einspringt — [§Welche Rolle braucht welche Artefaktklasse](../kurs/de/03-agenten/modul-08-agentenrollen.md#welche-rolle-braucht-welche-artefaktklasse)
sagt, welche Klasse eine Rolle **führt**, nicht wer sie **schreibt**; sie als
Eigentums-Aussage zu lesen *„kehrte die Frage genau um"*.

**Und der Konsument hat einen Träger gewählt, den der Kurs nicht kennt: den
Commit.** Zweimal unabhängig — `MR-015` Setzung 2 (2026-07-26) und ADR-0015
Festlegung 2 — landet eine Norm-Änderung *„in einem eigenen Commit, der
ausschließlich Artefakte derselben schreibenden Rolle berührt und die Rolle in
seiner Message nennt"*. Eigentum liegt damit nicht in einem Feld, das gegen die
Ablage driftet, sondern in einer Struktur, die git ohnehin führt.

**Aber dieser Träger löst den Befund hier nicht — er beantwortet eine andere
Frage.**
ADR-0015 vergibt das Eigentum an eine **Rolle** (Architect) für eine
**Artefaktklasse**; der Commit nennt die Rolle, nicht die Person. Solange
Rolle und Person zusammenfallen, ist das dieselbe Auskunft. Sobald drei
Menschen Architect sein können, sagt der Commit *warum* die Änderung legitim
ist, aber nicht, *wer* sie hält — gefragt ist hier aber die dritte Achse,
der [Zuweisung einer Instanz](#rolle-person-zuweisung--drei-achsen-zwei-ohne-wort).
Zwei benachbarte Lücken, nicht eine.

**Was damit belegt ist und was nicht.** Belegt: Eine Eigentums-Achse fehlt im
Korpus — gemessen, mit ADR als Folge, und zwar schon bei **einem** Schreiber,
auf der Rollen-Ebene. Nicht belegt: die Zuweisungs-Ebene und die Team-Folgen
(doppelte Arbeit, unprüfbares WIP-Limit). Die bleiben Vorhersage.

**Warum dieser Befund zuerst steht.** Er greift täglich, nicht pro Welle, er
trägt die Befunde 3 und 5 mit — und er ist der einzige mit Konsumenten-Beleg.

<a id="tb-003"></a>

## TB-003 — Die Welle ist ein Join-Barrier

**Abgelöst durch [TB-014](#tb-014).** Der Eintrag argumentierte, der
Closure-Trigger zwinge die Schnellen zum Warten. Das setzt voraus, dass die
Einzahl von *Aktuelle Welle* bindet — sie tut es nicht, und damit wartet
niemand: Wer fertig ist, arbeitet an einer anderen offenen Welle weiter. Mit
der Barriere fällt auch der Zweitrundeneffekt, den der Eintrag daran hängte
(ein Carveout je Welle, gedehnte Carveout-Frist).

<a id="tb-004"></a>

## TB-004 — Eine Rolle, mehrere Personen

**Was dastand** (behoben in Welle 76 — die Zitate unten sind der Zustand davor). Der Korpus modelliert durchgängig *n Rollen ← 1 Person*
([Modul 8 §Typische Fehlvorstellungen](../kurs/de/03-agenten/modul-08-agentenrollen.md#typische-fehlvorstellungen),
Modul 15 §Lab-Grenze). Die Umkehrung fehlt, gemessen — siehe
[§Rolle, Person, Zuweisung](#rolle-person-zuweisung--drei-achsen-zwei-ohne-wort).

**Warum es bei einem trägt.** Rolle und Person fallen zusammen. Jede Regel
*„die Rolle X tut Y"* ist eindeutig, weil es genau ein X gibt.

**Was bei dreien bricht — die Regeln zerfallen in zwei Lesarten.** Der klarste
Fall ist das **WIP-Limit**: *„WIP-Limit pro Implementer = 1 ist eine harte
Größe, kein Vorschlag"*
([Modul 5 §Selbstcheck-Rubrik](../kurs/de/02-planung/modul-05-planning-harness.md#selbstcheck-rubrik)).
„Implementer" ist ein **Rollen**-Name, und der Korpus besteht darauf, dass
Rollen keine Personen sind — wörtlich gelesen darf also das *ganze Team* einen
Slice in `in-progress/` haben. Gemeint ist offensichtlich die andere Lesart,
und die Rubrik wechselt im selben Satz stillschweigend zu ihr: *„**wer**
mehrere Slices gleichzeitig in `in-progress/` hat"* — „wer" ist eine Person.
Die Regel kann nicht sagen, was sie meint, weil das Wort dafür fehlt.

**Zwei weitere Stellen derselben Klasse:**

- **Reviewer-Drift.** *„Ein Reviewer-Agent ohne Skill-Datei driftet zwischen
  Sessions"*, und bei zwei Kategorisierungen gilt *„Skill schärfen, bis die
  Klassifikation reproduzierbar ist"*
  ([Modul 10](../kurs/de/04-qualitaet/modul-10-review-harness.md#typische-fehlvorstellungen)).
  Mit mehreren Personen in der Rolle driftet es **zwischen Personen**, und die
  Abweichung ist dann keine Inkonsistenz, sondern ein Dissens. Die verordnete
  Gegenmaßnahme trifft nur den ersten Fall.
- **Der Architect als Orakel** — siehe [TB-006](#tb-006).

**Was hier ausdrücklich nicht steht.** Dass Personen-Trennung die bessere
Rollen-Trennung wäre. Der Satz *„Rollen-Trennung ist Kontext-Trennung"* ist
richtig; die Lücke liegt daneben, nicht dagegen.

<a id="tb-006"></a>

## TB-006 — Der Konflikt-Pfad hat kein Terminal

**Was dastand** (behoben in Welle 76 — die Zitate unten sind der Zustand davor). Modul 8 modelliert den Rollen-Konflikt als Sequenz mit
Übergabe-Artefakten (Reviewer-HIGH gegen Implementer → Architect → drei
legitime Verdikte), verbietet die Entscheidung nach Seniorität und nennt den
falschen vierten Ausgang, von dem es heißt, *„er existiert nur, weil
Übergabe-Artefakte fehlen"*
([§Worked Example](../kurs/de/03-agenten/modul-08-agentenrollen.md#worked-example-einen-konflikt-pfad-als-rollen-sequenz-mit-übergabe-artefakten-modellieren)).

**Warum es bei einem trägt.** Es gibt keinen echten Dissens. Der „Architect"
ist ein frisches Kontextfenster und folgt dem besseren Argument — und er ist
**einer**, weil Rolle und Person zusammenfallen.

**Was bei dreien bricht.** Die Regel entfernt den Stichentscheid, ohne ihn zu
ersetzen. Akzeptiert B das Verdikt von C nicht, benennt der Korpus kein
**letztes** Artefakt und keinen Abbruch. Die Diagnose *„er existiert nur, weil Übergabe-Artefakte fehlen"*
unterstellt, dass ein Artefakt die Uneinigkeit auflöst;
zwischen Personen **dokumentiert** ein Artefakt die Uneinigkeit, es beendet sie
nicht. Bei einer Person ist das unsichtbar, weil dort niemand widerspricht.

**Und die Instanz, die schlichten soll, ist selbst nicht eindeutig.** Ist
*Architect* von mehreren gefüllt ([TB-004](#tb-004)), können zwei Architects zwei
Verdikte geben. Die Sequenz behandelt die Rolle als **Orakel** — eine Adresse,
die genau eine Antwort zurückgibt. Das ist sie nur, solange sie eine Person
ist.

<a id="tb-007"></a>

## TB-007 — Einarbeitung wurde nie als Kosten geführt

**Was dastand** (behoben in Welle 79 — die Zitate unten sind der Zustand davor). Der Index/Eintrag-Schnitt ist ausdrücklich mit
Agenten-Kontextkosten begründet: *„`conventions.md` liest **jeder**
Agentenlauf"*
([§harness/conventions.md als Konventionsspeicher](../kurs/de/grundlagen/harness-dateien.md#harnessconventionsmd-als-konventionsspeicher)).
`harness/README.md` bündelt laut Kurs alles, *„was ein Agent oder ein neuer
Mensch zuerst lesen muss"*
([§harness/README.md als Einstiegspunkt](../kurs/de/grundlagen/harness-dateien.md#harnessreadmemd-als-einstiegspunkt)).

**Warum es bei einem trägt.** Einarbeitungskosten sind null. Die einzige
relevante Größe *ist* der Kontext pro Lauf.

**Der Auslöser ist hier die zweite Person, nicht die dritte** — und schon eine
Übergabe an einen Nachfolger genügt. Der Befund steht trotzdem in dieser Liste,
weil er dieselbe Wurzel hat: Der Korpus rechnet mit einem Leser, der alles
mitgebaut hat.

**Was bricht.** Ein neuer Mensch braucht nicht wenig pro Lauf,
sondern einmal alles. Die Pflichtgliederung von `harness/README.md` sind sieben
Nachschlage-Sektionen — eine **Referenzfläche, kein Lesepfad**. Der Begriff
„Lesepfad" kommt in `kurs/de` viermal vor: einmal für Agenten-Kontextkosten
(§harness/conventions.md) und dreimal in Modul 15 für den *Trace*-Pfad zwischen
Slice-Datei und ADRs. **Keine dieser Fundstellen ist eine Leseordnung für einen
Menschen**, und einen anderen Begriff dafür führt der Korpus nicht.

**Und die Kosten wachsen monoton.** Jede Welle darf per Lerneintrag eine Regel
verkörpern. Für `MR`, Carveout und ADR gibt es Auflösung, Frist und Supersede —
**für Hard Rules und Skill-HIGH-Einträge nicht** (geprüft: kein Rückbau-Vokabular
in `kurs/de`; die Gegenprobe zeigt 29 Nennungen von *Hard Rule*, der Grep könnte
also treffen). Das ist keine zweite Lücke, sondern dieselbe von der Zeitachse
gesehen: Ein Korpus, der nur wächst, kostet den nächsten Leser jedes Jahr mehr —
und *nur* ihn, weil niemand sonst ihn frisch liest.

Bei einer Person fällt das nie auf, weil niemand neu dazukommt.

<a id="tb-009"></a>

## TB-009 — MR steht in keiner der beiden Vergabe-Klassen

**Was dastand** (behoben in Welle 79 — die Zitate unten sind der Zustand davor).
[§Vergabe](../kurs/de/grundlagen/source-precedence.md#vergabe-woher-die-nächste-nummer-kommt)
teilt die Kennungen in zwei Klassen: die *laute* Ablage (`LH-*`, `SPEC-*`,
`ARC-*` — viele in einer Datei, Doppelvergabe erzeugt einen Git-Konflikt) und
die *stille* (*„ADR, Slice, Welle und Carveout sind **je eine eigene Datei**"*
— Doppelvergabe erzeugt `0012-cache.md` und `0012-index.md`, und *„Git meldet
nichts"*). Nur die stille Klasse bekommt das Bereichssegment.

**Was fehlt.** `MR-<NNN>` steht in keiner der beiden Aufzählungen. Seit dem
Verzeichnis-Schnitt (*„Ein Eintrag je Datei"*) gehört es zur Je-eigene-Datei-
Klasse und teilt damit deren stille Doppelvergabe: Zwei Leute ziehen `MR-005`,
es entstehen `MR-005-cache.md` und `MR-005-index.md`, und kein Sensor schlägt
an. Der Abschnitt kennt `MR` durchaus — der [Absatz direkt darüber](../kurs/de/grundlagen/source-precedence.md#id-schema-als-klammer)
begründet die expliziten Anker gerade *an den `MR`-Zeilen des
Adaptions-Index*. Die Vergabe-Frage überspringt es.

**Warum es ein Hybrid ist, den keine der beiden Klassen beschreibt.** `MR` hat
**beide** Ablagen zugleich: die Eintrags-Datei (still) *und* die Index-Zeile
(laut). Zwei gleichzeitige `MR-005` erzeugen zwei Dateien, die lautlos
nebeneinander liegen, aber zwei Index-Zeilen, die in derselben Tabelle
kollidieren. Der Fall ist damit *lauter* als ADR und Slice, aber nicht
garantiert laut — landen die Zeilen nicht benachbart, mergt Git sie
klaglos. Genau diese Zwischenlage behandelt der Abschnitt nicht, und sie ist
nicht durch „gilt analog" abgedeckt: Die Frage, ob `MR` ein Bereichssegment
braucht, hat je nach Lesart zwei verschiedene Antworten.

**Status.** Verifizierbar durch Lesen — die Aufzählung ist entweder abschließend
gemeint und dann unvollständig, oder beispielhaft und dann missverständlich.
Und das Gewicht ist gemessen: In `ai-harness-init` ist `MR` mit **24** Einträgen
(`MR-000`…`MR-023`) die zweitgrößte Kennungs-Klasse überhaupt — mehr als ADRs
(18), Wellen (10) und Carveouts (1). Die einzige Klasse ohne Vergabe-Regel ist
also die zweitmeistgenutzte.

<a id="tb-010"></a>

## TB-010 — „Lokal ableitbar" gilt nicht, wenn die Welle vorvergibt

**Was dastand** (behoben in Welle 79 — die Zitate unten sind der Zustand davor). §Vergabe begründet den Verzicht auf eine Absprache damit, dass
die nächste Nummer **lokal ableitbar** sei: *„Wer in `IDX` arbeitet, sieht im
eigenen Checkout, welche `IDX`-Kennungen vergeben sind, und braucht dafür weder
eine Absprache noch einen Schreibzugriff auf den Hauptzweig."*

**Was gemessen ist** (Stand 2026-08-16). In `ai-harness-init` laufen die
Slice-Nummern dicht von `001` bis `086` — mit **einer Lücke: `061`–`064`**.
Alle vier sind **im Wellen-Plan vergeben**: `welle-09-modul-15-konformitaet.md`
nennt sie. Für drei existiert nirgends eine Datei (`git log --all` über alle
Pfade: null Treffer). Die vierte, `062`, ist inzwischen entstanden und liegt
**untracked** im Arbeitsbaum — in keinem Commit, in keinem Klon.

Beides stützt denselben Punkt. Die Vorvergabe ist nicht hypothetisch, sondern
der normale Weg: Eine Nummer wird beim Wellen-Schnitt reserviert und später
materialisiert. Und `062` zeigt die Stufe *unterhalb* von
[TB-011](#tb-011) — nicht ein offener PR, sondern ein Arbeitsbaum: Für jeden
anderen ist die Nummer frei, auch `git ls-files` sieht sie nicht.

**Warum das die Begründung trifft.** Der Zählraum ist damit nicht das
Verzeichnis, sondern Verzeichnis **plus jede offene Welle**. Wer die vier
Lifecycle-Verzeichnisse auflistet, sieht die Lücke als frei und zieht `061` —
eine Nummer, die bereits vergeben ist. Der Konflikt ist die
*stille* Sorte: eigene Datei, kein Git-Konflikt, kein Sensor. Bei einem
Schreiber ist das folgenlos, weil er die Vorvergabe selbst vorgenommen hat; die
Ableitbarkeits-Zusage gilt aber gerade dem Fall, in dem das nicht so ist.

**Kein Widerspruch zur Vorvergabe selbst.** Nummern beim Wellen-Schnitt zu
vergeben ist richtig — der [Traceability-Constraint](../kurs/de/grundlagen/traceability.md#traceability-constraint)
verlangt die Kennung, *sobald die Arbeit läuft*. Unvollständig ist nur die
Beschreibung, wo man nachsieht.

**Der Entwurf dazu steht in [TA-3](#ta-3)** — er gilt der Vergabe insgesamt und
damit auch [TB-009](#tb-009), [TB-011](#tb-011) und [TB-013](#tb-013).

<a id="tb-011"></a>

## TB-011 — Auswertbar erst nach dem Merge

**Was dastand** (behoben in Welle 77 — die Zitate unten sind der Zustand davor). Der Korpus behandelt das Repo als **einen fortlaufend
beobachtbaren Zustand**: *„Der Zustand ist das Verzeichnis"*, und
*„`ls docs/plan/planning/in-progress/` beantwortet »was läuft gerade«
autoritativ"*. Ebenso die Vergabe: Die nächste Nummer sei *„lokal ableitbar … und braucht dafür weder eine Absprache noch einen
**Schreibzugriff auf den Hauptzweig**"*
([§Vergabe](../kurs/de/grundlagen/source-precedence.md#vergabe-woher-die-nächste-nummer-kommt)).
Und der Sichtungs-Schritt liest bei *jedem* Slice-Plan das Beobachtungs-Register
([Modul 5 §Zwei Schritte vor der Modus-Begründung](../kurs/de/02-planung/modul-05-planning-harness.md#zwei-schritte-vor-der-modus-begründung)).

**Warum es bei einem trägt.** Es gibt praktisch einen Zustand. Weicht der
Arbeitsbaum ab, ist es die eigene Abweichung — der Leser kennt sie.

**Was bei dreien bricht.** Mit Pull Requests gibt es **n + 1 Zustände**, und
jede Lese-Operation der Planung trifft den gemergten. Alles, was in einem
offenen PR steht, ist für die anderen **nicht vorhanden**:

- **`ls in-progress/` ist zweigelokal.** Der `git mv` nach `in-progress/`
  reist im PR mit; bis zum Merge sieht ihn niemand sonst. Das Verzeichnis, das
  laufende Arbeit benennt, ist damit genau für laufende Arbeit unzuverlässig —
  verlässlich wird es erst, wenn sie nicht mehr läuft.
- **Der Sichtungs-Schritt liest veraltet.** Schließt A einen Slice, der
  `BEO-014` auf 3× hebt, und plant B am selben Tag von `main` aus, sieht B
  `2×` und notiert *„unter Schwelle"*. Nach dem Merge trägt Bs Plan eine
  falsche Aussage, und nichts prüft sie nach.
- **Das Register kann still doppelt zählen.** Zwei gleiche Erhöhungen derselben
  Zeile kollidieren laut — gut. Legt A dagegen eine *neue* Zeile für dasselbe
  Phänomen an, während B die bestehende erhöht, sind es zwei verschiedene
  Zeilen: Der Merge gelingt, die Beobachtung steht zweimal, und keine der
  beiden Hälften erreicht die Schwelle.
- **Vergebene Nummern sind unsichtbar.** Eine Kennung, die in einem offenen PR
  gezogen wurde, steht in keinem Checkout. Das verschärft
  [TB-010](#tb-010): Dort war der Zählraum Verzeichnis *plus offene Wellen*,
  hier kommt *plus jeder offene PR* hinzu — und den kann man nicht auflisten, ohne die Forge zu fragen.

**Was der Korpus zu PRs sagt.** Sie kommen vor — als Übergabe-Artefakt
(*„PR mit Diff + Plan-Verweis"*), als Ort der Traceability-IDs und als
Self-Check-Punkt vor dem Öffnen. **Als Zustands-Divergenz nirgends**;
*vor Merge* und *nach Merge* stehen allein in der Gate-Timing-Tabelle
([§Lifecycle-Verteilung](../kurs/de/grundlagen/klassifikation.md#lifecycle-verteilung)),
also über den Zeitpunkt von Prüfungen, nicht über den Zustand der
Planungs-Artefakte.

**Welche Dateien es trifft — und die Regel dahinter.** Nicht die
Änderungshäufigkeit entscheidet, sondern ein Produkt:

> **Risiko = Wert über das Ganze × nebenläufige Schreiber.**

Ein **Ganz-Wert** ist alles, was sich nicht aus einer Zeile allein ergibt: ein
Zähler, eine Ordnung, ein „aktuell", eine Version. Fehlt er, stehen die Zeilen
unabhängig nebeneinander, zwei Ansprüche auf dieselbe Kennung landen an
derselben Tabellenposition, und git meldet — **laut, und danach stimmt es**.
Fehlt umgekehrt die Nebenläufigkeit, ist auch ein Ganz-Wert harmlos. Gefährlich
ist nur beides zusammen: Dann mergt git sauber und das Ergebnis ist falsch.

**Ein dritter Faktor entscheidet, ob der Konflikt überhaupt auflösbar ist:
bezeichnet der Ganz-Wert einen Sachverhalt?** Zähler, Version und
Supersede-Status tun es — bei ihnen gibt es eine *richtige* Auflösung, man muss
sie nur finden. *Aktuelle Welle* tut es nicht ([TB-014](#tb-014)): Schreiben
zwei Personen dorthin, sind **beide Angaben wahr**, und jede Auflösung verwirft
eine wahre Aussage. Ein solcher Konflikt ist kein Nebenläufigkeits-Problem,
sondern das Symptom eines Modellfehlers — und nicht durch Sorgfalt beim Mergen
zu vermeiden, sondern nur durch Streichen des Feldes.

**Eine dritte Art: der Ganz-Wert ohne Ort.** Die laufende Nummer — `slice-086`,
`welle-11`, `ADR-0019` — ist ebenfalls ein Wert über das Ganze („die höchste
vergebene plus eins"), aber sie steht in **keiner Zeile**. Es gibt keine Datei, die die
nächste freie Nummer führt; sie ist in der Sammlung implizit. Damit ist ein
Merge-Konflikt darauf nicht bloß unwahrscheinlich, sondern **unmöglich** — zwei
Ansprüche erzeugen zwei verschiedene Dateien, die klaglos nebeneinander liegen.
Für diese Klasse gibt es keinen lauten Ausgang, und genau deshalb existiert
[§Vergabe](../kurs/de/grundlagen/source-precedence.md#vergabe-woher-die-nächste-nummer-kommt)
als eigener Mechanismus: Die Vergabe-Regel ist der Ersatz für einen Konflikt,
der nie stattfinden kann.

Nach Verkehr geordnet ist die **Slice-Nummer** die größte stille Fläche des
Korpus — in `ai-harness-init` 83 Vergaben gegen 24 `MR`, 19 ADRs, 10 Wellen und
2 Carveouts, und ohne jeden Serialisierer. Die **Welle-Nummer** teilt die
Bauart, nicht das Risiko: Bei ihrer Eröffnung gilt *„Alle drei Schritte (…)
laufen in **einem** Kontext"*
([Modul 8](../kurs/de/03-agenten/modul-08-agentenrollen.md#rollen-sequenz-für-eine-welle)),
und wer eine Welle schneidet, schreibt die Roadmap, deren *Aktuelle Welle* der
laute Kollisionspunkt ist. Ganz-Wert ja, Nebenläufigkeit praktisch null — die
gleiche Lage wie beim Lastenheft.

Gemessen an `ai-harness-init` über 764 Commits:

| Datei / Ort | Ganz-Wert — und bezeichnet er etwas? | Schreiber | Risiko |
|---|---|---|---|
| **keine Datei** — `slice-<NNN>` | „die höchste vergebene plus eins"; bezeichnet einen Sachverhalt, hat aber **keine Zeile**. Der Slice ist die **einzige Kennungs-Klasse ohne Index** — das Verzeichnis *ist* ihr Register, und ein Verzeichnis kollidiert nicht | **83 Vergaben, kein Serialisierer** | **hoch** — die größte stille Fläche des Korpus; ein Konflikt ist nicht selten, sondern **unmöglich**. Heute schützt nur die Vergabe-Regel; Optionen in [TA-3](#ta-3) |
| **keine Datei** — `ADR-<NNNN>` · `MR-<NNN>` · `CO-<NNN>` | dieselbe Bauart, aber **jede hat einen Index**: die Eintragsdatei kollidiert still, die Index-Zeile laut | 19 · 24 · 2 | **mittel, halb laut** — zwei Ansprüche erzeugen zwei Dateien *und* zwei Index-Zeilen; letztere kollidieren, wenn sie benachbart landen. Genau diese Zwischenlage benennt [TB-009](#tb-009) |
| **keine Datei** — `welle-<NN>` | dieselbe Bauart, ohne Index | 10, durch die Planner-Eröffnung in *einem* Kontext serialisiert | **niedrig** — Ganz-Wert mit praktisch keiner Nebenläufigkeit. Dass das Schema für sie trotzdem keine Antwort hat, ist [TB-013](#tb-013) |
| `planning/in-progress/roadmap.md` | **zwei**: die Ordnung von *Nächste Wellen* (bezeichnet eine getroffene Entscheidung) · *Aktuelle Welle* — Singleton, **bezeichnet nichts** ([TB-014](#tb-014)) | 128 Änderungen — jede Welle, jede Umplanung | **hoch**; beim zweiten Wert unauflösbar. Entfällt mit der in [TB-014](#tb-014) benannten Auflösung, danach bleibt die Ordnung |
| `planning/observations.md` | der `BEO`-Zähler; bezeichnet einen Sachverhalt | per Konvention **jede** Slice-Closure | **hoch**, aber ungemessen — dieser Konsument hat das Register nicht adoptiert. Betrifft die *Merge*-Mechanik, nicht das Zählen selbst (dafür siehe das gestrichene TB-002) |
| `docs/plan/adr/README.md` | nur die Status-Spalte; bezeichnet einen Sachverhalt | 42 | mittel — die Zeilen selbst sind unabhängig, zwei Ablösungen derselben ADR mergen sauber |
| `harness/conventions.md` (MR-Index) | keiner — der Index selbst ist eine Zeilentabelle | 78 | niedrig — laut. Die halbstille `MR`-Nummer beurteilt die zweite Kennungs-Zeile, nicht diese |
| `AGENTS.md` §3 Hard Rules · `harness/README.md` §Sensors | keiner — nummerierte bzw. unabhängige Zeilen, Zusätze landen an derselben Stelle | 42 · 25 | niedrig — laut |
| `spec/lastenheft.md` | die Version im Kopf; bezeichnet einen Sachverhalt | **ein externer, sequentieller Prozess** — *„weder ADR noch Slice dürfen `LH-*` je ändern"* ([§Spec-Stratifizierung](../kurs/de/grundlagen/source-precedence.md#spec-stratifizierung)) | **niedrig**: Ganz-Wert ohne Nebenläufigkeit |
| `planning/README.md` · `carveouts/README.md` | keiner | **2** | vernachlässigbar |

Die drei Kennungs-Zeilen stehen bewusst oben: Nach Schadensart sind sie die
schwersten Einträge, und sie haben als einzige **keinen Ort**, an dem man
nachsehen könnte. Ihr Unterschied ist der **Index** — wer einen hat, bekommt
eine zweite, laute Chance; der Slice hat keinen und ist deshalb allein an der
Spitze.

**Die Index-READMEs sind die sichersten Dateien im Baum, und das ist kein
Zufall.** Die Planning-README trägt eine Sektion *Aktueller Stand*, und darin
steht kein Stand, sondern eine Absage: *„Nicht als Snapshot hier eintragen — der
Stand ergibt sich aus den `open/`/`next/`/`in-progress/`/`done/`-Verzeichnissen,
sonst driftet die Tabelle."* Das
ist *„der Zustand ist das Verzeichnis"*, angewandt auf einen Index — und die
2 von 764 sind die Auszahlung. Eine Datei ohne Ganz-Wert wird nicht angefasst.

Damit ist die Frage für die drei verbliebenen Ganz-Werte offen, nicht für die
Indizes: *Aktuelle Welle*, der `BEO`-Zähler und die Lastenheft-Version sind nie
nach demselben Maßstab geprüft worden wie der Slice-Status.

**Warum das unter den anderen sitzt.** Es ist keine weitere Lücke neben ihnen,
sondern eine Vorbedingung, die mehrere teilen: Wer *„der Zustand ist das
Verzeichnis"* liest, liest eine Zusage über **Beobachtbarkeit**. Die gilt nur
für gemergten Stand.

<a id="tb-012"></a>

## TB-012 — Die Planning-README trägt zwei Begriffe ohne Quelle

**Behoben in Welle 77** — die Tabelle unten zeigt den Zustand davor.

**Der Befund war Template-Drift.** Die Rangfolge des Korpus ist `kurs/de` →
`lab/regelwerk` → `lab/templates`. Die Lifecycle-Tabelle in
`lab/templates/docs/plan/planning/README.template.md` — wortgleich im realen
Konsumenten — definiert drei der vier Verzeichnisse über Begriffe, die **nur
auf Rang 3 stehen**:

| Verzeichnis | Bedeutung laut Vorlage | in `kurs/de` |
|---|---|---|
| `next/` | „Als Nächstes priorisiert. **Verantwortlicher zugeordnet**." | *priorisiert/eingeplant* — von einem Verantwortlichen keine Rede |
| `in-progress/` | „**Branch / PR existiert**." | kein Treffer für `Branch` oder `PR existiert` in Modul 5 oder 6 |
| `done/` | „DoD erfüllt, **gemerged**, Closure-Notiz vorhanden." | *Closure-Kriterien, Lerneintrag, Risiko-Ausgänge* — „gemerged" fehlt |

Eine Struktur ohne Quell-Verankerung ist keine Kleinigkeit: Sie reist ins
Adopter-Repo, wird dort normativ gelesen und hat keine Instanz, die sie
fortschreibt. Die Fix-Richtung ist **Quelle → Template**, nicht umgekehrt — die
drei Begriffe sind vermutlich genau richtig und gehören nach oben.

**Zwei Folgen, die andere Einträge konkret machen.** Sie sind keine Dubletten,
sondern die Stelle, an der jene operativ werden:

- *Eine Zuweisung ohne Ort.* Die Vorlage erklärt `open→next` zum Moment, in dem
  ein Verantwortlicher zugeordnet wird. `slice.template.md` hat dafür **kein
  Feld** — anders als `welle.template.md`, das `**Verantwortlich:** <Name>`
  führt. Der Index behauptet eine Zuordnung, die das Artefakt nicht aufnehmen
  kann ([TB-001](#tb-001)).
- *Der Lifecycle hängt an PR-Zuständen.* Wenn `in-progress/` heißt *„ein
  Branch/PR existiert"*, muss der `git mv` auf dem Hauptzweig liegen, **bevor**
  der PR merged — sonst ist das Verzeichnis dort dauerhaft leer und `ls`
  beantwortet nichts. Das sagt keine Quelle ([TB-011](#tb-011)).

**Status: kein Team nötig.** Am Text belegt, unabhängig von jeder Größe.

<a id="tb-013"></a>

## TB-013 — Die Welle fällt aus dem Zählraum-Schema

**Was dastand** (behoben in Welle 79 — die Zitate unten sind der Zustand davor).
[§Vergabe](../kurs/de/grundlagen/source-precedence.md#vergabe-woher-die-nächste-nummer-kommt)
zählt vier Artefakte zur stillen Klasse — *„ADR, Slice, **Welle** und Carveout
sind je eine eigene Datei"* — und gibt eine Antwort: *„Für die Artefakte mit je
eigener Datei ist der Zählraum die Sub-Area."* Das Beispiel dazu lautet
`ADR-IDX-0004 · ADR-AUTH-0001 · slice-IDX-007 · CO-AUTH-002`.

**Was fehlt.** Die Welle steht in der Aufzählung, aber **nicht im Beispiel** —
und die Antwort passt auch nicht auf sie. Eine Welle *bündelt* Slices, und ein
Slice berührt bereits mehrere Sub-Areas; es gibt für eine Welle also keine
Sub-Area, in der man zählen könnte. Ein `welle-IDX-03` wäre keine Verengung des
Zählraums, sondern eine falsche Behauptung über den Geltungsbereich.

**Was daraus folgt.** Für die Welle bleibt es beim dichten, repo-weiten
Zählraum — was **richtig** ist, nur steht es nirgends. Der Abschnitt liest sich,
als sei die Frage für alle vier beantwortet; für eines der vier ist sie es
nicht. Dasselbe Muster wie bei [TB-009](#tb-009), einen Schritt schärfer: Dort
fehlt das Artefakt in der Einteilung, hier ist es eingeteilt und die Antwort
trägt nicht.

**Warum es trotzdem nicht drängt.** Das *Risiko* ist gering — die Vergabe einer
Welle-Nummer ist durch die Planner-Eröffnung und die Roadmap serialisiert
(siehe die Regel unter [TB-011](#tb-011)). Es ist ein Defekt im Text, nicht in
der Praxis.

**Status: kein Team nötig.** Am Text belegt.

<a id="tb-014"></a>

## TB-014 — „Aktuelle Welle" ist keine Eigenschaft des Repos

**Was dastand** (behoben in Welle 78 — die Zitate unten sind der Zustand davor). Die Roadmap führt einen Abschnitt *Aktuelle Welle* mit drei
Pflicht-Bestandteilen, und Closure-Schritt 5 befördert die nächste
([Modul 6 §Die Wellen-Closure-Prozedur](../kurs/de/02-planung/modul-06-roadmap.md#die-wellen-closure-prozedur)):
*„Die Welle wandert aus Aktuelle Welle in die Tabelle Abgeschlossene Wellen
(…); die erste Zeile aus Nächste Wellen wird zur neuen Aktuellen Welle."*

**Warum es bei einem trägt.** Was eine Welle zur *aktuellen* macht, ist, dass
jemand an ihr arbeitet — eine Tatsache über **Aufmerksamkeit**, nicht über den
Repo-Zustand. Bei einem Schreiber gibt es genau einen Fokus; er fällt mit dem
Repo zusammen und lässt sich als dessen Eigenschaft aufschreiben.

**Was bei dreien bricht.** Aufmerksamkeit ist pro Person, also gibt es keine
„aktuelle" Welle mehr — sondern **keine oder mehrere**. Der Abschnitt zerfällt
in zwei Dinge, die es wirklich gibt:

- **welche Wellen offen sind** — die flachen Dateien; objektiv und positional,
  schon vorhanden;
- **wer woran arbeitet** — eine Zuweisung, und die hat im Korpus keinen Ort
  ([TB-001](#tb-001)).

*Aktuelle Welle* ist damit **Zuweisungs-Information im Roadmap-Gewand**. Sie
beantwortet nicht, welche Welle läuft, sondern woran der eine Mensch sitzt.

**Beide Fälle sind belegt — einer schon bei einem Schreiber.**

*Keine:* In `ai-harness-init` steht im Drift-Log *„ein Abschnitt, der »Keine
aktive Welle« meldet, war **23 Zeilen lang**"*. Der leere Fall hat keine Form;
eine Sektion, die eine Pflichtangabe verlangt, die es gerade nicht gibt, füllt
sich mit Prosa. Und der Zustand ist normal — zwischen zwei Wellen, oder wenn
gerade wellenlos gearbeitet wird, was der Kurs ausdrücklich vorsieht.

*Mehrere:* Modul 6 enthält **keine Regel**, die mehr als eine laufende Welle
verbietet; die Einzahl trägt allein die Überschrift. Derselbe Konsument führt
bereits zwei flache Welle-Dateien nebeneinander.

**Was gegenstandslos wird.** Die Beförderung in Closure-Schritt 5 setzt einen
einzigen Fokus voraus. Schließt A seine Welle, wird nicht „die nächste" zur
aktuellen — B und C arbeiten unverändert weiter. Der Schritt ist nicht falsch,
er hat keinen Gegenstand.

**Nachgeordnet, aber billig zu beheben: der Abschnitt ist überdies eine Kopie.**
Er wiederholt §2 Trigger, §3 Closure-Trigger und §4 Slices der Wellen-Plan-Datei.
Dieselbe Roadmap behandelt die *geplante* Welle gegenteilig — *„Trigger und
Closure-Kriterien stehen in der Plan-Datei, nicht hier"* —, warnt in der
Kandidaten-Tabelle ausdrücklich vor dieser Drift-Klasse *„(real passiert mit
slice-047/048)"* und muss im Abschnitt selbst dementieren: *„Ihr
Lifecycle-Zustand ist ihr Verzeichnis, nicht diese Zeile."* Ein Abschnitt, der
seine eigene Autorität bestreiten muss, trägt Information, die anderswo wohnt.

**Was unberührt bleibt.** Das Wellen-Konzept fällt nicht, und die Positionen
flach/`done/` sind echte Repo-Eigenschaften. Es fällt allein die Behauptung, es
gebe **eine** laufende — und mit ihr der Abschnitt, der sie trägt. Hier wird
auch **nicht** behauptet, parallele Wellen seien gut; nur, dass der Korpus sie
nicht modelliert.

**Und ausdrücklich unberührt: *Nächste Wellen*.** Derselbe Test fällt dort
umgekehrt aus, an beiden entscheidenden Punkten — wer diesen Befund als
Verdacht gegen Roadmap-Abschnitte überhaupt liest, liest ihn falsch.

| | *Aktuelle Welle* | *Nächste Wellen* |
|---|---|---|
| **Gegenstand** | ein Artefakt, das **existiert** (die flache Datei) → Kopie, ableitbar | Wellen, die **noch nicht existieren** → einziger Ort, nirgends ableitbar |
| **Ganz-Wert bezeichnet einen Sachverhalt?** | nein — zwei Angaben sind **beide wahr**, jede Auflösung verwirft eine | ja — eine getroffene Priorisierungs-Entscheidung |
| **Konflikt** | unauflösbar; Symptom eines Modellfehlers | auflösbar, und **erwünscht**: Uneinigkeit über die Reihenfolge *soll* sichtbar werden |

Der Kurs setzt das selbst als Ziel: *„Das Schema verwandelt einen stillen
Merge-Unfall in ein inhaltliches Signal."* Bei *Nächste Wellen* ist genau das
der Fall. Und abgeleitet werden kann die Reihenfolge auch aus den Slices nicht
— *„Eine Reihenfolge einzelner Slices kennt der Harness überhaupt nicht. Die
Roadmap ordnet **Wellen**"*
([Modul 6](../kurs/de/02-planung/modul-06-roadmap.md#wann-arbeit-eine-welle-braucht--und-wann-nicht)).

Nach dem Streichen wird die Benennung sogar schärfer: *offene* Wellen sind
geschnitten, *nächste* sind es nicht. Vorher lagen „aktuell" und „nächste" auf
zwei verschiedenen Achsen — Aufmerksamkeit gegen Existenz —, und das war Teil
der Verwirrung.

**Der Entwurf dazu steht in [TA-2](#ta-2)** — die Auflösung liegt bereits im
Repo und braucht keinen neuen Mechanismus.

**Nebenwirkungen.** `roadmap.md` verliert seinen Singleton und fällt in der
Risiko-Tabelle unter [TB-011](#tb-011) von *hoch* auf die bloße Ordnung von
*Nächste Wellen* zurück. Und Closure-Schritt 5 verliert seine zweite Hälfte:
Die Welle wandert nach `done/`, das Closure-Log bekommt seine Zeile —
**befördert wird niemand**.

## Reihenfolge und Abhängigkeiten

**TA-1 zuerst** — es ist die billigste Änderung und Vorbedingung für drei
Einträge. Solange es kein Wort für den Rolleninhaber gibt, lässt sich weder das
WIP-Limit eindeutig lesen noch der Architect als Instanz adressieren noch eine
Zuweisung sauber formulieren.

**Dann TA-2** — es hängt an TA-1 (das Feld benennt einen Rolleninhaber) und schließt
mit [TB-014](#tb-014) zugleich den Abschnitt, der die Zuweisung heute
ersatzweise trägt.

**TA-3 und TA-4 sind unabhängig** und können jederzeit laufen. TA-3 zerfällt in drei
billige Text-Korrekturen und eine große optionale Schema-Frage; TA-4 ist eine
Deklaration ohne Mechanik.

**TA-6 hängt an TA-1** — erst mit einem Wort für den Rolleninhaber lässt sich
sagen, *wessen* Verdikt bestritten wird. Danach ist es ein Absatz.

**TA-7 sofort nach TA-2** — es macht dessen Feld überhaupt erst sichtbar und
erledigt zugleich die Reste von TA-3 und TA-4. Von allen sieben die kleinste
Textänderung: ein Zeitpunkt zu einer Regel, die es schon gibt.

**TA-5 zuletzt** — eigenständig, am teuersten, und als einzige nicht durch einen
Team-Fall ausgelöst, sondern durch die zweite Person überhaupt.

**Was für alle sieben gilt.** Die Bauform steht bereits im Korpus:
[§Vergabe](../kurs/de/grundlagen/source-precedence.md#vergabe-woher-die-nächste-nummer-kommt)
hat die Mehr-Personen-Frage für Kennungen beantwortet, **ohne den
Ein-Personen-Fall zu verschlechtern** — Default für einen Schreiber,
deklarierte Variante für mehrere, Grenze offen benannt. Jede der sieben Änderungen
lässt sich so schneiden.

**Und eine Änderung fehlt in dieser Liste**, weil sie keine am Korpus ist,
sondern an seiner Selbstauskunft: Der IST — *ein Schreiber plus Agenten* — ist
nirgends deklariert. Solange das SOLL nicht erreicht ist, gehört der
Geltungsbereich ausgesprochen, damit ein Adopter mit drei Leuten weiß, woran er
ist. Das kostet einen Absatz und ist von allen fünf unabhängig.
