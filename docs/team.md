# Team-Tauglichkeit — wo das Regelwerk einen einzelnen Schreiber voraussetzt

**Stand:** 2026-08-15.

## Was diese Datei ist

**Gegenstand ist der gelehrte Korpus** — `kurs/de` als Quelle, `lab/regelwerk`
als Spiegel —, nicht der Harness dieses Repos. Die Frage lautet: *Welche Regeln
funktionieren, weil genau ein Mensch am Repo schreibt, und was passiert bei
drei?*

**Abgrenzung zur [Roadmap](roadmap.md).** Dort stehen offene Fäden **dieses
Repos**, jeder mit einem Trigger, an dem man erkennt, dass er dran ist. Hier
steht ein **Befund-Register über das Produkt**. Keine Zeile hier verspricht
eine Handlung, keine hat einen Trigger. Wird ein Befund zur Arbeit, bekommt er
dort eine Zeile — nicht hier.

**Konsument.** Der Kurs-Autor zur **Entwurfszeit** — wenn entschieden wird, ob
der Korpus die Mehr-Personen-Frage aufnimmt. Erreichbar ist er über die
Faden-Zeile *Team-Tauglichkeit des Korpus* in [`roadmap.md`](roadmap.md); ohne
sie wäre diese Datei Ablage
([*Jedes Artefakt hat einen Konsumenten*](../kurs/de/grundlagen/harness-dateien.md#jedes-artefakt-hat-einen-konsumenten)).

## Beleglage — was hier *nicht* gemessen ist

**Alle offenen Befunde sind aus dem Text abgeleitet, keiner an einem realen Team
gemessen.** Gemessen ist nur die Beleglage: `git shortlog -sne HEAD` über die
vier bekannten Repos, die die Baseline tragen oder vendorn — `d-check`,
`ai-harness-init`, `a-check` und dieses — liefert **je genau eine
Autoren-Identität**. Nach der Zählregel
([§Steering Loop](../kurs/de/grundlagen/klassifikation.md#steering-loop) —
1× Vorfall · 2× Symptom · 3× Lücke) stehen sie damit **bei 0×**, nicht einmal
bei 1×: Vorhersagen, keine Beobachtungen. Wer das überliest, verkörpert eine
Regel gegen ein Problem, das noch niemand gehabt hat.

**Zwei Dinge sind trotzdem belegt**, beide an `ai-harness-init` — dem einzigen
der vier mit vollem Lifecycle (85 Slices, 18 ADRs, 10 Wellen, 24 `MR`):

- Die **Eigentums-Achse** unter [TB-001](#tb-001) fehlt dort nachweislich und wurde mit
  einer eigenen ADR beantwortet. Nur die *Team*-Folge bleibt Vorhersage.
- [TB-009](#tb-009) und [TB-010](#tb-010) hängen an keiner Team-Größe; beide
  sind am realen Bestand nachgemessen.

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
| [§Vergabe: woher die nächste Nummer kommt](../kurs/de/grundlagen/source-precedence.md#vergabe-woher-die-nächste-nummer-kommt) | Die Frage ist dort **ausdrücklich gestellt und beantwortet** — laute Ablage (`LH-*`, `SPEC-*`, `ARC-*`: viele IDs in einer Datei → Git-Konflikt) gegen stille (ADR, Slice, Carveout: je eigene Datei → lautloser Doppelvergabe-Merge), Bereichssegment als Antwort, Grenze benannt (*„Zwei in derselben Sub-Area können kollidieren — und das ist Absicht"*), Wahl deklarationspflichtig (*„Welche Form gilt, deklariert das Repo"*). Die Prognose für einen Schreiber — *„braucht kein Segment"* — trifft am Bestand zu: In `ai-harness-init` zählen ADR (`0001`–`0018`), Welle (`01`–`10`), `MR` (`000`–`023`) und Carveout (`CO-001`) dicht und **ohne** Segment. Zwei Einzelheiten hält der Abschnitt trotzdem nicht, siehe [TB-009](#tb-009) und [TB-010](#tb-010) |
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

## Warum kein Gate das je meldet

Alle Befunde unten liegen in der **inferentiellen Hälfte** des Harness — dort,
wo ein Mensch urteilt. Der Korpus teilt fast jede Regel in diese Hälfte und
eine **computationale**, in der ein Sensor Deckung prüft; die Arbeitsteilung ist
richtig und die computationale Hälfte ist stark. Nur fällt keiner dieser
Befunde in sie.

Ein Sensor kann sehen, dass ein Anker fehlt, eine ADR nach `Accepted` verändert
wurde oder eine `BEO-<NNN>` ohne Registerzeile zitiert wird. Er kann nicht
sehen, dass eine Regel von zwei Personen verschieden gelesen wird, dass ein
Streit nie entschieden wurde oder dass niemand weiß, wem ein Slice gehört.

**Ein Repo mit drei Schreibern wäre daher nach jeder Messung, die der Harness
anbietet, kerngesund** — während genau diese Stellen nachgeben. Das ist keine
Schwäche der Gates; es ist die Grenze, die der Korpus selbst zieht. Sie gehört
nur mitgedacht, wenn man aus „alles grün" auf „trägt auch zu dritt" schließt.

## Register

Die Einträge tragen **Kennungen statt Positionsnummern**. Grund ist gemessen und
nicht theoretisch: Diese Liste wurde beim Entstehen dreimal umnummeriert, weil
Einträge wegfielen — jeder Verweis auf „Befund 5" zeigte danach woanders hin.
Das ist genau der Fall, für den
[§ID-Schema als Klammer](../kurs/de/grundlagen/source-precedence.md#id-schema-als-klammer)
die stabile Kennung vorsieht, und adressiert wird deshalb die **Kennung, nicht
der Titel** — jeder Eintrag trägt ein `<a id="tb-NNN">`.

`TB-<NNN>` gilt **nur in dieser Datei**, steht in keinem Commit und in keinem
Gate; vergeben wird chronologisch nach Fund, Lücken werden nicht nachbelegt.
Gestrichene Einträge bleiben mit Grund stehen — eine still gelöschte Zeile ist
von einer nie vergebenen nicht zu unterscheiden
([Modul 6 §Das Beobachtungs-Register](../kurs/de/02-planung/modul-06-roadmap.md#das-beobachtungs-register)),
und ohne den Grund prüft der Nächste dieselbe Sackgasse noch einmal.

| Kennung | Eintrag | Stand |
|---|---|---|
| [TB-001](#tb-001) | Der Lifecycle ist ein Zustand ohne Subjekt | offen · Achse am Konsumenten belegt |
| TB-002 | *Der Zähler zählt Beobachtungen, nicht Beobachter* | **gestrichen** — der Zähler steht in einer stehenden Datei und wird bei jeder Slice-Closure fortgeschrieben, gleich von wem; das Register-Beispiel des Kurses ist selbst der Drei-Slices-Fall. Der Sichtungs-Schritt (§8) ist Pflicht in *jedem* Slice-Plan, und die Sub-Area-Spalte trägt bewusst die normative Sub-Area. Person-unabhängig gebaut |
| TB-003 | *Die Welle ist ein Join-Barrier* | **abgelöst** durch [TB-014](#tb-014) — die Barriere setzt voraus, dass die Einzahl von *Aktuelle Welle* bindet; sie bindet nicht |
| [TB-004](#tb-004) | Eine Rolle, mehrere Personen | offen |
| TB-005 | *Der Planner ist Single Writer* | **gestrichen** — kein eigener Befund: „Durchsatz-Engpass" ist Volumen, nicht Lücke; der Rest ist [TB-004](#tb-004) |
| [TB-006](#tb-006) | Der Konflikt-Pfad hat kein Terminal | offen |
| [TB-007](#tb-007) | Einarbeitung wurde nie als Kosten geführt | offen · Auslöser ist die *zweite* Person |
| TB-008 | *Lokale Gates mal drei Maschinen* | **gestrichen** — die Regel steht richtig da, und die Messung dazu (lokal gegen CI) betrifft zwei Umgebungen, nicht zwei Menschen. Reiner Druckunterschied |
| [TB-009](#tb-009) | MR steht in keiner der beiden Vergabe-Klassen | offen · **kein Team nötig**, am Text belegt |
| [TB-010](#tb-010) | „Lokal ableitbar" gilt nicht bei Vorvergabe | offen · **kein Team nötig**, am Bestand gemessen |
| [TB-011](#tb-011) | Auswertbar erst nach dem Merge | offen · Vorbedingung mehrerer anderer |
| [TB-012](#tb-012) | Die Planning-README trägt zwei Begriffe ohne Quelle | offen · **kein Team nötig**, Template-Drift |
| [TB-013](#tb-013) | Die Welle fällt aus dem Zählraum-Schema | offen · **kein Team nötig**, Risiko gering |
| [TB-014](#tb-014) | „Aktuelle Welle" ist keine Eigenschaft des Repos | offen · löst [TB-003](#tb-003) ab; leerer Fall bei *einem* Schreiber belegt. **Auflösung benannt:** flache Dateien + `**Welle:**` in `in-progress/` — das Feld entfällt |

<a id="tb-011"></a>

## TB-011 — Auswertbar erst nach dem Merge

**Was dasteht.** Der Korpus behandelt das Repo als **einen fortlaufend
beobachtbaren Zustand**: *„Der Zustand ist das Verzeichnis"*, und
*„`ls docs/plan/planning/in-progress/` beantwortet »was läuft gerade«
autoritativ"*. Ebenso die Vergabe: Die nächste Nummer sei *„lokal ableitbar …
ohne Absprache und ohne **Schreibzugriff auf den Hauptzweig**"*
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
sondern das Symptom eines Modellfehlers — und deshalb der einzige in dieser
Tabelle, den man nicht durch Sorgfalt beim Mergen vermeidet, sondern nur durch
Streichen des Feldes.

**Eine dritte Art: der Ganz-Wert ohne Ort.** Die laufende Nummer — `slice-086`,
`welle-11`, `ADR-0019` — ist ebenfalls ein Wert über das Ganze („die höchste
plus eins"), aber sie steht in **keiner Zeile**. Es gibt keine Datei, die die
nächste freie Nummer führt; sie ist in der Sammlung implizit. Damit ist ein
Merge-Konflikt darauf nicht bloß unwahrscheinlich, sondern **unmöglich** — zwei
Ansprüche erzeugen zwei verschiedene Dateien, die klaglos nebeneinander liegen.
Für diese Klasse gibt es keinen lauten Ausgang, und genau deshalb existiert
[§Vergabe](../kurs/de/grundlagen/source-precedence.md#vergabe-woher-die-nächste-nummer-kommt)
als eigener Mechanismus: Die Vergabe-Regel ist der Ersatz für einen Konflikt,
der nie stattfinden kann.

Nach Verkehr geordnet ist die **Slice-Nummer** die größte stille Fläche des
Korpus — in `ai-harness-init` 85 Vergaben gegen 24 `MR`, 18 ADRs, 10 Wellen und
einen Carveout, und ohne jeden Serialisierer. Die **Welle-Nummer** teilt die
Bauart, nicht das Risiko: Ihre Eröffnung ist *„Planner-Arbeit — alle drei
Schritte laufen in **einem** Kontext"*
([Modul 8](../kurs/de/03-agenten/modul-08-agentenrollen.md#rollen-sequenz-für-eine-welle)),
und wer eine Welle schneidet, schreibt die Roadmap, deren *Aktuelle Welle* der
laute Kollisionspunkt ist. Ganz-Wert ja, Nebenläufigkeit praktisch null — die
gleiche Lage wie beim Lastenheft.

Gemessen an `ai-harness-init` über 764 Commits:

| Datei | Ganz-Wert | Schreiber | Risiko |
|---|---|---|---|
| `planning/in-progress/roadmap.md` | **zwei, verschiedener Art**: die Ordnung von *Nächste Wellen* (bezeichnet eine echte Planungs-Entscheidung) und *Aktuelle Welle* — ein Singleton, der **keinen Sachverhalt bezeichnet** ([TB-014](#tb-014)) | 127 Änderungen — jede Welle, jede Umplanung | **hoch**, und beim zweiten Ganz-Wert von besonderer Art: siehe unten |
| `planning/observations.md` | der `BEO`-Zähler | per Konvention **jede** Slice-Closure | **hoch**, aber ungemessen — dieser Konsument hat das Register nicht adoptiert |
| `docs/plan/adr/README.md` | nur die Status-Spalte (zwei Ablösungen derselben ADR mergen sauber) | 40 | mittel; die Zeilen selbst sind unabhängig |
| `harness/conventions.md` (MR-Index) | keiner | 78 | niedrig — laut, bis auf die halbstille Nummer aus [TB-009](#tb-009) |
| `spec/lastenheft.md` | die Version im Kopf | **ein externer, sequentieller Prozess** — *„weder ADR noch Slice dürfen `LH-*` je ändern"* ([§Spec-Stratifizierung](../kurs/de/grundlagen/source-precedence.md#spec-stratifizierung)) | **niedrig**: Ganz-Wert ohne Nebenläufigkeit |
| `planning/README.md` · `carveouts/README.md` | keiner | **2** | vernachlässigbar |

**Die Index-READMEs sind die sichersten Dateien im Baum, und das ist kein
Zufall.** Die Planning-README trägt eine Sektion *Aktueller Stand*, und darin
steht kein Stand, sondern eine Absage: *„Nicht als Snapshot hier eintragen —
der Stand ergibt sich aus den Verzeichnissen, sonst driftet die Tabelle."* Das
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

**Was dasteht.** Die Lifecycle-Tabelle in
`lab/templates/docs/plan/planning/README.template.md` — wortgleich im realen
Konsumenten — definiert drei der vier Verzeichnisse über Begriffe, die der
Kurs nicht führt:

| Verzeichnis | Bedeutung laut Vorlage | in `kurs/de` |
|---|---|---|
| `next/` | „Als Nächstes priorisiert. **Verantwortlicher zugeordnet**." | *priorisiert/eingeplant* — von einem Verantwortlichen keine Rede |
| `in-progress/` | „**Branch / PR existiert**." | kein Treffer für `Branch` oder `PR existiert` in Modul 5 oder 6 |
| `done/` | „DoD erfüllt, **gemerged**, Closure-Notiz vorhanden." | *Closure-Kriterien, Lerneintrag, Risiko-Ausgänge* — „gemerged" fehlt |

**Warum das zählt — zweimal.**

*Erstens: eine Zuweisung ohne Ort.* Die Vorlage erklärt `open→next` zum
Moment, in dem ein Verantwortlicher zugeordnet wird. `slice.template.md` hat
dafür **kein Feld** — anders als `welle.template.md`, das
`**Verantwortlich:** <Name>` führt. Der Index behauptet eine Zuordnung, die das
Artefakt nicht aufnehmen kann. Das ist [TB-001](#tb-001), einen Schritt
konkreter: nicht „die Achse fehlt", sondern „sie ist am falschen Artefakt".

*Zweitens: der Lifecycle hängt an PR-Zuständen, ohne dass es die Lehre sagt.*
Wenn `in-progress/` heißt *„ein Branch/PR existiert"*, muss der `git mv` auf
dem Hauptzweig liegen, **bevor** der PR merged — sonst ist `in-progress/` dort
dauerhaft leer und `ls` beantwortet nichts. Genau das sagt keine Quelle. Es ist
[TB-011](#tb-011) an der Stelle, an der es operativ wird.

**Einordnung: Template-Drift.** Die Rangfolge des Korpus ist
`kurs/de` → `lab/regelwerk` → `lab/templates`; eine Struktur, die nur auf
Rang 3 steht, hat keine Quell-Verankerung, und die Fix-Richtung ist
**Quelle → Template**, nicht umgekehrt. Die drei Begriffe sind nicht falsch —
sie sind vermutlich genau richtig und gehören nach oben.

**Status: kein Team nötig.** Am Text belegt, unabhängig von jeder Größe.

<a id="tb-013"></a>

## TB-013 — Die Welle fällt aus dem Zählraum-Schema

**Was dasteht.**
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

<a id="tb-001"></a>

## TB-001 — Der Lifecycle ist ein Zustand ohne Subjekt

**Was dasteht.** *„Der Zustand ist das Verzeichnis, nicht ein Kopffeld"*
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
2026-08-09) festgehalten: gemessen über alle 26 Regelwerk-Dateien
*„benennt **keine** Datei eine schreibende Rolle für `AGENTS.md` oder
`harness/conventions.md`"*. Die ADR benennt auch, warum die vorhandene Tabelle
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

<a id="tb-014"></a>

## TB-014 — „Aktuelle Welle" ist keine Eigenschaft des Repos

**Was dasteht.** Die Roadmap führt einen Abschnitt *Aktuelle Welle* mit drei
Pflicht-Bestandteilen, und Closure-Schritt 5 befördert die nächste
([Modul 6 §Die Wellen-Closure-Prozedur](../kurs/de/02-planung/modul-06-roadmap.md#die-wellen-closure-prozedur)):
*„Die Welle wandert aus Aktuelle Welle in die Tabelle Abgeschlossene Wellen;
die erste Zeile aus Nächste Wellen wird zur neuen Aktuellen Welle."*

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
— *„eine Reihenfolge einzelner Slices kennt der Harness überhaupt nicht; die
Roadmap ordnet Wellen"*
([Modul 6](../kurs/de/02-planung/modul-06-roadmap.md#wann-arbeit-eine-welle-braucht--und-wann-nicht)).

Nach dem Streichen wird die Benennung sogar schärfer: *offene* Wellen sind
geschnitten, *nächste* sind es nicht. Vorher lagen „aktuell" und „nächste" auf
zwei verschiedenen Achsen — Aufmerksamkeit gegen Existenz —, und das war Teil
der Verwirrung.

**Die Auflösung steht schon im Repo: zwei positionale Tatsachen genügen.**

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
nur, ob dieser Slice in ein Bündel gehört; daraus folgt für die Vorgänge unten
nichts."* Das zielt auf eine andere Frage — ob das *Repo* Wellen führt —, ist
also kein Widerspruch; aber die neue Last müsste dort ausgesprochen werden.

**Was es nicht behebt.** `in-progress/` ist zweigelokal ([TB-011](#tb-011)), die
Ableitung erbt das. Sie verschlechtert nichts: Statt eines Feldes, in das zwei
Personen Wahres schreiben und eines davon verlieren, sieht man den Stand von
`main` — unvollständig, aber nie falsch. Die unauflösbare Konfliktklasse
verschwindet.

**Nebenwirkungen.** `roadmap.md` verliert seinen Singleton und fällt in der
Risiko-Tabelle unter [TB-011](#tb-011) von *hoch* auf die bloße Ordnung von
*Nächste Wellen* zurück. Und Closure-Schritt 5 verliert seine zweite Hälfte:
Die Welle wandert nach `done/`, das Closure-Log bekommt seine Zeile —
**befördert wird niemand**.

<a id="tb-004"></a>

## TB-004 — Eine Rolle, mehrere Personen

**Was dasteht.** Der Korpus modelliert durchgängig *n Rollen ← 1 Person*
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

**Was dasteht.** Modul 8 modelliert den Rollen-Konflikt als Sequenz mit
Übergabe-Artefakten (Reviewer-HIGH gegen Implementer → Architect → drei
legitime Verdikte), verbietet die Entscheidung nach Seniorität und nennt den
falschen vierten Ausgang, der *„nur bei fehlenden Artefakten existiert"*
([§Worked Example](../kurs/de/03-agenten/modul-08-agentenrollen.md#worked-example-einen-konflikt-pfad-als-rollen-sequenz-mit-übergabe-artefakten-modellieren)).

**Warum es bei einem trägt.** Es gibt keinen echten Dissens. Der „Architect"
ist ein frisches Kontextfenster und folgt dem besseren Argument — und er ist
**einer**, weil Rolle und Person zusammenfallen.

**Was bei dreien bricht.** Die Regel entfernt den Stichentscheid, ohne ihn zu
ersetzen. Akzeptiert B das Verdikt von C nicht, benennt der Korpus kein
**letztes** Artefakt und keinen Abbruch. Die Diagnose *„existiert nur bei
fehlenden Artefakten"* unterstellt, dass ein Artefakt die Uneinigkeit auflöst;
zwischen Personen **dokumentiert** ein Artefakt die Uneinigkeit, es beendet sie
nicht. Bei einer Person ist das unsichtbar, weil dort niemand widerspricht.

**Und die Instanz, die schlichten soll, ist selbst nicht eindeutig.** Ist
*Architect* von mehreren gefüllt ([TB-004](#tb-004)), können zwei Architects zwei
Verdikte geben. Die Sequenz behandelt die Rolle als **Orakel** — eine Adresse,
die genau eine Antwort zurückgibt. Das ist sie nur, solange sie eine Person
ist.

<a id="tb-007"></a>

## TB-007 — Einarbeitung wurde nie als Kosten geführt

**Was dasteht.** Der Index/Eintrag-Schnitt ist ausdrücklich mit
Agenten-Kontextkosten begründet: *„`conventions.md` liest **jeder**
Agentenlauf"*
([§harness/conventions.md als Konventionsspeicher](../kurs/de/grundlagen/harness-dateien.md#harnessconventionsmd-als-konventionsspeicher)).
`harness/README.md` gilt als Einstiegspunkt für *„einen Agenten oder einen
neuen Menschen"*
([§harness/README.md als Einstiegspunkt](../kurs/de/grundlagen/harness-dateien.md#harnessreadmemd-als-einstiegspunkt)).

**Warum es bei einem trägt.** Einarbeitungskosten sind null. Die einzige
relevante Größe *ist* der Kontext pro Lauf.

**Der Auslöser ist hier die zweite Person, nicht die dritte** — und schon eine
Übergabe an einen Nachfolger genügt. Der Befund steht trotzdem in dieser Liste,
weil er dieselbe Wurzel hat: Der Korpus rechnet mit einem Leser, der alles
mitgebaut hat.

**Was bricht — zwei Dinge.**

*Erstens die Kostenfunktion.* Ein neuer Mensch braucht nicht wenig pro Lauf,
sondern einmal alles. Die Pflichtgliederung von `harness/README.md` sind sieben
Nachschlage-Sektionen — eine **Referenzfläche, kein Lesepfad**. Der Begriff
„Lesepfad" kommt in `kurs/de` viermal vor: einmal für Agenten-Kontextkosten
(§harness/conventions.md) und dreimal in Modul 15 für den *Trace*-Pfad zwischen
Slice-Datei und ADRs. **Keine dieser Fundstellen ist eine Leseordnung für einen
Menschen**, und einen anderen Begriff dafür führt der Korpus nicht.

*Zweitens die Richtung.* Jede Welle darf per Lerneintrag eine Regel
verkörpern. Für `MR`, Carveout und ADR gibt es Auflösung, Frist und Supersede —
**für Hard Rules und Skill-HIGH-Einträge nicht**. Ein Korpus, der durch
Verkörperung wächst und nie schrumpft, macht Einarbeitung monoton teurer.

Bei einer Person fällt das nie auf, weil niemand neu dazukommt.

<a id="tb-009"></a>

## TB-009 — MR steht in keiner der beiden Vergabe-Klassen

**Was dasteht.**
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

**Was dasteht.** §Vergabe begründet den Verzicht auf eine Absprache damit, dass
die nächste Nummer **lokal ableitbar** sei: *„Wer in `IDX` arbeitet, sieht im
eigenen Checkout, welche `IDX`-Kennungen vergeben sind, und braucht dafür weder
eine Absprache noch einen Schreibzugriff auf den Hauptzweig."*

**Was gemessen ist.** In `ai-harness-init` laufen die Slice-Nummern dicht von
`001` bis `085` — mit **einer Lücke: `061`–`064`**. Diese vier sind nicht
gestrichen und haben nie existiert (`git log --all` über alle Pfade: null
Treffer). Sie sind **im Wellen-Plan vergeben**: `welle-09-modul-15-konformitaet.md`
nennt `slice-061` bis `slice-064`, eine Datei trägt keine von ihnen.

**Warum das die Begründung trifft.** Der Zählraum ist damit nicht das
Verzeichnis, sondern Verzeichnis **plus jede offene Welle**. Wer `open/`,
`next/`, `in-progress/` und `done/` auflistet, sieht `060` als höchste und
zieht `061` — eine Nummer, die bereits vergeben ist. Der Konflikt ist die
*stille* Sorte: eigene Datei, kein Git-Konflikt, kein Sensor. Bei einem
Schreiber ist das folgenlos, weil er die Vorvergabe selbst vorgenommen hat; die
Ableitbarkeits-Zusage gilt aber gerade dem Fall, in dem das nicht so ist.

**Kein Widerspruch zur Vorvergabe selbst.** Nummern beim Wellen-Schnitt zu
vergeben ist richtig — der [Traceability-Constraint](../kurs/de/grundlagen/traceability.md#traceability-constraint)
verlangt die Kennung, *sobald die Arbeit läuft*. Unvollständig ist nur die
Beschreibung, wo man nachsieht.

## Wo man anfinge

**Zuerst die Beobachtbarkeit.** Ob eine Zusage wie *„der Zustand ist das
Verzeichnis"* überhaupt gilt, entscheidet sich vor jeder Regel darüber, wer was
wann sieht — [TB-011](#tb-011) sitzt deshalb unter den übrigen und wird von
keiner Formulierung erledigt.

**Dann das Vokabular.** [TB-004](#tb-004) ist die billigste Lücke und trägt die
meisten anderen: Solange es kein Wort für *„die Person, die diese Rolle gerade
füllt"* gibt, lässt sich weder das WIP-Limit eindeutig lesen noch der Architect
als Instanz adressieren noch eine Zuweisung notieren.

**Dann** [TB-001](#tb-001) und [TB-014](#tb-014) — beide sind dieselbe
Zuweisungs-Frage an zwei Artefakten. [TB-006](#tb-006) ist ein
Absatz, sobald die Achse steht; [TB-007](#tb-007) ist eigenständig, teuer und
hängt an keinem anderen.

Und die Bauform steht bereits im Korpus:
[§Vergabe](../kurs/de/grundlagen/source-precedence.md#vergabe-woher-die-nächste-nummer-kommt)
hat die Mehr-Personen-Frage für Kennungen beantwortet, **ohne den
Ein-Personen-Fall zu verschlechtern** — Default für einen Schreiber,
deklarierte Variante für mehrere, Grenze offen benannt. Dieselbe Form passt auf
die Eigentums- und die Wellen-Frage.

Was sie **nicht** ersetzt, ist die Beleglage oben. Solange kein Repo mit drei
Schreibern die Baseline adoptiert hat, wäre der Ausbau der übrigen eine Regel
gegen ein ungemessenes Problem. Drei Einträge warten dagegen auf nichts:
[TB-009](#tb-009), [TB-010](#tb-010) und die Eigentums-Achse aus
[TB-001](#tb-001) — die ist am Konsumenten belegt und dort bereits mit einer
eigenen ADR beantwortet worden.
