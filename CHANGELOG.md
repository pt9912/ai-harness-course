# Changelog

Kanonisches Register der Überarbeitungs-Wellen dieses Kurses. Die
Stand-Zeile von [`lab/regelwerk/README.md`](lab/regelwerk/README.md)
referenziert diese Nummern; adoptierende Repos vergleichen ihren
Baseline-`Stand:`-Eintrag gegen dieses Register.

> **Zählung.** Fortlaufend über alle Wellen (Inhalt, Didaktik,
> Tooling). Vor Einführung dieses Registers liefen zwei parallele
> Zählungen in Commit-Messages (generisch „Welle 1–16" und
> „Didaktik-Review Welle N") — Commit-Labels können daher von der
> kanonischen Nummer abweichen; maßgeblich ist dieses Register.

## Welle 60 — 2026-07-29 · E-2 vollzogen, „berührt" definiert, die Zeitachse des Vorbilds geradegezogen

Review-Runde 10 abgearbeitet ([`docs/reviews/review-runde-10.md`](docs/reviews/review-runde-10.md)),
dazu drei Klassen von Befunden am Vorbild-Repo, die dieselbe Runde zutage
gefördert hat. Kein Befund dieser Runde war maschinell sichtbar — `make check`
und `make verify` waren die ganze Zeit grün.

### Entschieden

- **Was „berührt" heißt.** Der Begriff steht an rund fünfzehn Stellen im Kurs,
  löst jeden §8-Block aus und war nirgends definiert. Jetzt in
  [`konventionen.md` §Was ist eine Sub-Area?](kurs/de/grundlagen/konventionen.md):
  Ein Slice *berührt* eine Sub-Area, wenn er ihren **Doku-/Code-Abgleich
  bewegt**. Zwei Wege dorthin, nur einer steht im Diff — **Pfad-Berührung**
  (mechanisch ablesbar, aber *nicht hinreichend*: additive Arbeit innerhalb
  einer schon deklarierten Konvention zählt nicht) und **Aussagen-Berührung**.
  Grenze benannt: Der Diff liefert eine Kandidatenliste, kein Urteil.
- **Die Sub-Area-Spalte des Registers bekommt eine Befüllungs-Regel**
  ([Modul 6](kurs/de/02-planung/modul-06-roadmap.md)): Sie trägt die Sub-Area,
  deren Konventions-Härte oder Inventur-Linie die Beobachtung betrifft — nicht
  die, in deren Verzeichnis sie auffiel. Dieselbe Berührungs-Frage, rückwärts.
- **E-2 wird ausgeführt, nicht zurückgenommen.** Runde 10 hatte drei Optionen
  gestellt (zurücknehmen · Durchsetzung schaffen · Geltungsbereich
  verkleinern). Keine davon: Die Regel war nie falsch, sie war nur nie
  vollzogen.

### Hinzugefügt

- **Die Ruheort-Regel ist jetzt definiert**
  ([`konventionen.md` §Herkunfts-Anker](kurs/de/grundlagen/konventionen.md)).
  Quelle und Spiegel beriefen sich namentlich auf sie; `grep -rn "Ruheort"`
  lieferte zwei Zitate und keine Definition. Sie stand in einem
  Template-Kommentar, den Adoptions-Schritt 5 löscht.
- **Die zwei vorgelagerten Schritte der §8-Begründung** stehen in
  [Modul 5](kurs/de/02-planung/modul-05-planning-harness.md) — Sub-Area-Wahl
  prüfen · offene Beobachtungen sichten. Sie waren als Pflicht in *jedem*
  Slice-Plan verlangt und existierten ausschließlich im Template.
- **„Die leere Liste ist die Aussage"** (Modul 6): Ein Register ohne offene
  Beobachtungen trägt `— keine —` und bleibt stehen. Das adoptierte
  `observations.template.md` startet seither in genau diesem Zustand — vorher
  mit drei erfundenen Beobachtungen, weil Schritt 3 unbedingt befiehlt,
  Platzhalter zu ersetzen.

### Geändert

- **Alle sechs Planning-Templates tragen einen Regelwerk-Zeiger pro Sektion.**
  Gemessen nach Adoptions-Schritt 4 (Hinweis-Block weg) und 5 (Kommentare weg)
  standen `README.template.md`, `roadmap.template.md` und
  `welle.template.md` bei **null**, `slice.template.md` und
  `welle-results.template.md` bei eins. Ein Adopter verliert beim Kopieren
  keine Norm mehr.
- **Die *Lage*-Prüfung des Belegs läuft nach dem `git mv`**, zusammen mit der
  Register-Paarung (c). Vorher lief sie per Konstruktion bei jeder korrekt
  ausgeführten Closure rot: Der Beleg wird vor dem `mv` geschrieben, und der
  `mv` ist ein eigener Commit.
- **Zwei Leser statt einer.** Modul 6, Spiegel und Selbstcheck-Rubrik nannten
  nur den Lese-Schritt (Welle-Closure); der Sichtungs-Schritt (Slice-Planung
  §8) hält alles unter der Schwelle am Leben und fehlte.
- **Achse E-1 vereinheitlicht.** „Ohne laufende Welle" ist die falsche Achse —
  ein Repo mit Wellen hat regelmäßig keine laufende Welle und trotzdem eine
  nächste Welle-Closure. Korrigiert in Modul 6, im Spiegel und im laufenden
  CHANGELOG-Block; historische Einträge bewusst unangetastet.
- **Die Grenze der E-2-Feedback-Hälfte sagt jetzt das Entscheidende:** Der
  Reviewer-Skill ist eine *Ziel-Form für das adoptierende Repo*. Wo der
  Adopter kein Review einrichtet, hat die Hard Rule keinen Träger — das ist
  der Auslieferungszustand, kein Sonderfall.

### Nachgezogen

- **Eine Bezeichnung pro Agentenrolle.** Die kanonische Sechserliste stand im
  Repo in **vier** Fassungen; zwei Rollen hatten Doppelnamen
  (`Implementation`/`Implementer`, `Verification`/`Verifier`). Kanon ist jetzt
  durchgehend das Akteursnomen — **Planner · Architect · Implementer ·
  Reviewer · Verifier · Validator** —, denn fünf der sechs waren es schon; nur
  eines war ein Vorgangsnomen. Mitgezogen: 57 Komposita
  (`Implementation-Agent` → `Implementer-Agent`), die Mermaid-Teilnehmer, die
  Übergabe-Ketten, die Selbstcheck-Rubrik, die `agent.role`-Werte im
  Trace-Fixture und die Attributions-Tabelle in `modul-15-loesung.md`.
  *Implementation* und *Verification* bleiben, wo sie die **Tätigkeit** meinen
  (Modul 11 heißt weiter *Verification Harness*, das Begriffspaar
  Verification/Validation bleibt unangetastet).

### Lab

- **Der Closure-Note-Gate war grün auf dem blanken Template-Rumpf.** Break-Test
  reproduziert (exit 0), bestehender Checker um eine Platzhalter-Prüfung
  gehärtet — kein neues Skript. ADR-0011 führt das als geschärfte Fitness
  Function, nicht als neue Pflicht.
- **Die Zeitachse des Vorbild-Repos stand an 23 Stellen gegen sich selbst:**
  Slices zitierten ADRs aus ihrer Zukunft, ADRs schrieben ihre Urheberschaft
  Slices mit fremdem Titel zu, der Index-Pfad lautete je nach Datei anders, der
  Jetzt-Punkt lag mal im Juni, mal im Juli. Nachträge stehen jetzt sichtbar da
  statt als stille Rückdatierung.
- **Die Sub-Area-Tabelle deckt jeden Pfad-Cluster ab** — 186 von 186 verfolgten
  Dateien, entweder als Sub-Area oder in §Nicht als Sub-Area geführt mit Grund.
  Vorher hatten `tools/`, `runbooks/`, die Container-/Build-Dateien und jedes
  `<lang>/Makefile` keine Sub-Area, der ein Slice seinen §8-Block hätte
  zuordnen können.
- Alle vier Vorbild-Slices tragen beide *Vorgelagert*-Blöcke; der Blockname
  lautet überall wie in der Norm (*sichten*, nicht *gesichtet*).

## Welle 59 — 2026-07-27 · Der Steering-Loop-Zähler bekommt einen Ort, der Wellen überlebt

### Hinzugefügt

- **[Modul 6](kurs/de/02-planung/modul-06-roadmap.md) §Das Beobachtungs-Register.**
  Der Zähler (*1× notieren · 2× Symptom · 3× Lücke*) liegt jetzt als stehende
  Datei `docs/plan/planning/observations.md` — flach neben den offenen Wellen,
  nicht mehr als Sektion in `welle-NN-results.md`.
- **[`observations.template.md`](lab/templates/docs/plan/planning/observations.template.md)**
  mit sechs Spalten und einer eigenen Sektion für gestrichene Einträge.
- **Wer schreibt, wer liest.** Eingetragen wird bei der **Slice-Closure** —
  neuer Eintrag mit `BEO-<NNN>` oder Zähler +1 und Beleg. Die **Welle-Closure
  liest** nur noch: Was hat 3× erreicht → verkörpern. *Das* ist der Punkt, an dem
  der Zähler von der Welle unabhängig wird; ein Repo ohne Wellen-Betrieb zählt
  weiter. Der Pflichtschritt steht in
  `slice.template.md` §6/§7 — dort, wo er ausgeführt wird, nicht nur in der Lehre.
- **Dritte Paarung in der Welle-Closure (Schritt 3):** Jede genannte `BEO-<NNN>` existiert als
  Zeile im Register. *Nennung ohne Deckung ist eine Harness-Lüge* gilt jetzt auch
  hier.
- **Der wellenlose Fall gilt auch für den Lese-Schritt** — und dafür musste das
  **Herkunfts-Anker-Subsystem** mit: Ein Repo ohne Wellen-Betrieb löst den
  Lese-Schritt eigenständig aus; erreicht ein Eintrag 3×, wird er verkörpert, und
  der Anker lautet `seit slice-<NNN>` statt `seit welle-<NN>`. Nachgezogen wurden
  **alle** Normstellen dieses Subsystems, nicht nur die Einführung:
  §Herkunfts-Anker (der Absatz argumentierte bis dahin *gegen* den Slice), das
  Form-Beispiel, die **Anker-Paarung** (sie verlangte die Wellenform) und ihr
  **Einstiegspunkt** — der Sensor lief über die Welle-Closure-Notiz, die es ohne
  Welle nicht gibt; er kennt jetzt §7 der Slice-Closure als zweite Quelle. Dazu
  Modul 9, 10 und 13 mit ihren Formangaben, `welle-results.template.md` und der
  Fluss-Graph. Ohne diesen Durchgang hätte eine wellenlos verkörperte Regel den
  Paarungs-Sensor garantiert rot laufen lassen — oder er hätte sie gar nicht
  gesehen.
- **`BEO-<NNN>` als Kennung.** Bisher musste die *Bezeichnung* über Wellen
  hinweg wortgleich bleiben — das Template mahnte es in Großbuchstaben, weil es
  bricht. Jetzt wird beim Erstauftreten einmal benannt und eine ID vergeben;
  Wiederauftreten zitiert sie. Umformulierungen ändern nur noch das Label, nicht
  die Zählung. Damit ist die Beobachtung die letzte zählbare Klasse im Harness,
  die eine ID bekommt (neben `LH-*`, `ADR-*`, `MR-*`, `CO-*`).

### Geändert

- **Warum stehend statt in der Welle-Closure.** Die bisherige Sektion wurde von
  Closure zu Closure **übernommen** und hochgezählt. Das hängt an einer
  ungebrochenen Kette mit drei Bruchstellen: vergessene Übernahme setzt den
  Zähler auf null, die erste Welle braucht eine Sonderregel, und ohne
  Wellen-Betrieb gibt es gar keinen Träger. Der feste Ort streicht alle drei — die Datei existiert ab
  Repo-Beginn.
- **Arbeitsteilung benannt, Werkzeug offen gelassen:** Das Urteil — *ist das
  dieselbe Beobachtung?* — fällt beim Schreiben, durch den Menschen, der die
  Kennung vergibt oder zitiert. Maschinell entscheidbar ist nur die **Deckung**:
  eine in `done/` zitierte `BEO-<NNN>` hat eine Registerzeile, und jede
  Registerzeile trägt mindestens einen Beleg — *nicht* die Umkehrung „jede Zeile
  ist irgendwo zitiert", denn die allermeisten stehen unter der Schwelle.
  Der Beleg ist dabei formgebunden — **Form** (`slice-<NNN>`, kein Freitext) ·
  **Anzahl** (so viele wie der Zähler) · **Lage** (führt das Repo die
  Slice-Datei, liegt sie in `done/`). Die *Existenz* wird bewusst nicht
  verlangt, und diese Grenze steht benannt: Ein Repo darf Slices führen, die es
  nicht als Plan-Datei ablegt.
  Muster: schreiben → committen → Gate prüft Deckung. *Welches* Werkzeug, legt
  der Kurs nicht fest.
- **Verzeichniskonvention:** Die flache Ebene unter `planning/` ist jetzt
  deklariert — offene Wellen (`<welle-id>.md`) und das Register. Sie wurde
  bislang benutzt (Modul 6, Template), stand aber in keiner Konvention.
- **Die Verweise nachgezogen** — Risiko-Ausgänge in Modul 5 und
  `slice.template.md`, der Steering-Loop-Graph in `konventionen.md`, der
  Template-Index, der Planning-Index in Template und Lab, die
  Regelwerk-Spiegel von Modul 5, 6, 10 und den Konventionen. Auch die
  **Modul-10-Strecke** (Quelle, Spiegel, `review-report.template.md`) trug die
  alte Mechanik und ist mitgezogen — die Finding-Klasse wandert jetzt bei der
  Slice-Closure ins Register, nicht in eine Verdichtung.
  `welle-results.template.md` behält die Sektion als **Zeiger** ohne Daten,
  damit ein Leser der Closure-Notiz den Zähler findet.
- **Didaktik:** Themen-Bullet, Übung und Selbstcheck-Item (beide LZ 2, das dafür
  um *„einordnen, wo der Steering-Loop-Zähler geführt wird und wer ihn schreibt
  bzw. liest"* erweitert wurde), Rubrik-Zeile und zwei Lösungsblöcke. Dazu eine
  neue Kernbegriffs-Zeile `BEO-<NNN>` in Quelle und Spiegel und der Nachzug in
  `welle.template.md`.
- **Lab:** Die drei realen Zeilen aus `welle-1-results.md` sind nach
  `observations.md` umgezogen und haben Kennungen bekommen (`BEO-001` bis
  `BEO-003`); dazu neu `BEO-004` (Lerneintrag aus `slice-020` §7), `BEO-005`
  (der einzige reale 3×-Fall, verkörpert in `AGENTS.md` §2.7), `BEO-006`
  (offenes Risiko aus `slice-020` §6) und `BEO-007` (der Auslöser der benannten
  Spec-Lücke) — sieben Zeilen insgesamt.
  Das Register erklärt die retrospektive
  Kennungs-Vergabe. `slice-009` und `slice-020` zitieren ihre Kennungen,
  `welle-1-results.md` nennt `BEO-005` und `BEO-007` beim Auslöser — beide
  Hälften der Register-Paarung halten damit im Vorbild, Form und Anzahl der
  Belege eingeschlossen.
- **Der Welle-Plan ist im Vorbild jetzt vertreten:** `done/welle-1-mvp.md`
  (geschlossen, neben seiner Ergebnis-Notiz) und `welle-2-qualitaet.md` (flach,
  aktive Welle). Ohne sie behauptete die Regel eine Pflicht, die das eigene
  Vorbild nicht erfüllte. Der Planning-Index im Lab trägt die
  Slice-vs-Welle-Konvention dazu.

### Nachgezogen (Review-Runden 7 bis 9)

- **Neue Konvention: [§Template-Schichtung](kurs/de/grundlagen/konventionen.md)**
  samt Spiegel. Ein Template wird beim Adoptieren abgebaut — alle Kommentare
  fallen weg. Vier Schichten statt zwei: **Regelwerk** trägt den Normtext als
  einzige Quelle, der **Rumpf** nur Form plus einen Regelwerk-Zeiger pro
  Pflicht-Sektion, die **DoD** die abhakbare Prozedur, der **Kommentar** die
  Begründung. Hard Rule: *Kein Kommentar ist die einzige Fundstelle einer
  Norm.* Das war die gemeinsame Ursache von sieben Befunden der Runde 9 — die
  Runde 8 hatte Normlast verschoben, ohne einen Maßstab dafür zu haben.
  Die Feedback-Hälfte ist **inferential** (HIGH-Regel im Reviewer-Skill), nicht
  computational: „Ist dieser Satz eine Norm?" ist ein Urteil, und
  Template-Verzeichnisse sind für Referenz-Gates bewusst ausgenommen. Ein
  Sensor wäre hier ein halluziniertes Gate; die Grenze steht benannt.
- **„Ohne Welle" ist der Repo-Modus, nicht die Slice-Zugehörigkeit.** Ein Repo
  arbeitet mit Wellen und Slices oder nur mit Slices; daran hängt, wer
  Lese-Schritt, Sichtungs-Schritt, Trigger-Audit und die drei Paarungen trägt.
  Das Kopf-Feld `**Welle:**` eines Slice sagt nur, ob er in ein Bündel gehört —
  ein Repo mit Wellen prüft **auch Slices ohne Wellen-Zugehörigkeit** bei
  seiner nächsten Welle-Closure. Runde 8 hatte die beiden Achsen
  zusammengezogen; Template, Vorbild `slice-020` und der Lösungsblock (c) sind
  zurückgenommen.
- **Der Fluss-Graph** in `konventionen.md` zeigt jetzt beide Leser für
  Einträge unter der Schwelle — bisher führte die `1×/2×`-Kante allein zur
  Wellen-Eröffnung, die es im wellenlosen Repo nicht gibt.
- **Der Closure-Note-Gate im Lab misst §7 statt §5.** `find_closure_section`
  nahm die erste Überschrift mit „Closure" im Titel — das war
  *Closure-Trigger*, geschrieben bei der Planung. Ein Slice mit vollständig
  leerer Closure-Notiz lief grün; mit dem Fix läuft er rot (Break-Test).

### Nachgezogen (Review-Runden 7 und 8)

- **Zustands-Regel für Wellen vereinheitlicht:** `README.template.md` — der
  Welle-Zustand ist die Verzeichnis-Position, kein `Status:`-Feld, und der
  Welle-Plan ist nicht optional. Er durchläuft den aktiven Durchlauf
  `open/` → `next/` → `in-progress/` **nicht**; `done/` ist sein einziges
  Lifecycle-Verzeichnis.
- **„Drei Übergänge" nennt drei** (Modul 5 + Spiegel): `in_progress → done`
  ist als einziger Weg nach `done` benannt, die beiden **Rückführungen**
  stehen daneben und behalten ihren Ausnahmecharakter.
- **Der Auslöser der Anker-Paarung ist disambiguiert.** Das Feld `liegt in`
  löst **nur innerhalb** von `## Steering-Loop-Einträge` bzw. Slice-§7 aus —
  der Trigger-Sprachgebrauch „`SL-024` liegt in `done/`" aus demselben Modul
  also nicht. In den Backticks steht ein **Zielort**, nicht immer eine Datei:
  `AGENTS.md §<N>` · `Makefile:<target>` · `.harness/skills/<name>.md`; der
  Sensor trennt ein Suffix ab ` §` oder `:` ab, bevor er den Pfad prüft.
- **Die benannte Spec-Lücke ist entschieden:** Sie durchläuft das Register wie
  die anderen zwei Lerneintrags-Klassen und trägt eine `BEO-<NNN>`. Sie ist
  *verkörpert* — nur in einer versionierten Spec statt an einem Zielort, mit
  der `LH-*`-ID als Gegenstück. Damit ist sie kein Gegenstand der
  **Anker**-Paarung, sehr wohl aber der **Register**-Paarung. Die frühere
  Zuordnung *gezählt, nicht verkörpert* traf sie fälschlich und hätte
  verhindert, dass sie die Schwelle je erreicht.
- **Der wellenlose Betrieb hat für jeden Vorgang einen Träger und einen
  Moment** (Modul 6 + Spiegel, jetzt als Tabelle): Zähler und Lese-Schritt bei
  der Slice-Closure, **Sichtungs-Schritt bei der Slice-Planung** (§8,
  unabhängig vom Sub-Area-Modus — ohne ihn hätte alles unter der Schwelle
  keinen Leser), Trigger-Audit bei jeder Closure, und **alle drei Paarungen
  nach dem `git mv`**, weil sie in `done/` suchen.
- **Der Anker `seit slice-<NNN>` löst auf `done/slice-<NNN>-<kurzer-titel>.md`
  auf** — die reale Namensform aus `slice.template.md`, maschinell
  `done/slice-<NNN>-*.md`. Die verkürzte Angabe traf keine einzige Datei.
- **Die Normlast der Templates verlässt den Kommentar.** Schritt 5 der
  *Verwendung* entfernt alle Kommentare — was dort stand, war beim Adopter weg.
  `slice.template.md` §7 und `welle-results.template.md`
  §Steering-Loop-Einträge tragen seither **Form** als Body-Zeilen und einen
  **Regelwerk-Zeiger** auf den Normtext; der Kommentar hält nur noch die
  Begründung. Das ist dieselbe Setzung wie §Template-Schichtung oben, nicht
  ihre Gegenrede: Der Normtext selbst steht im Regelwerk, nicht im Rumpf.
  Dazu ein DoD-Item für die drei Paarungen und ein Ruheort-Carveout in
  `welle.template.md`.

## Welle 58 — 2026-07-27 · Discovery-Register geschlossen: eine Beobachtung unter Schwelle, kein Plan

### Geändert

- **Faden *Discovery-/Kandidaten-Register* geschlossen**, 25 Wellen nach seiner
  Vertagung. Nach dem Trigger-Neuschnitt (Welle 57) ist die Beleglage: **0**
  Beobachtungen des Drucks nach dem Welle-33-Fix, **1** Messung mit negativem
  Ergebnis. Die Ursprungs-Beobachtung entstand *vor* dem Fix und belegt nicht,
  dass er nicht reicht.
- **Der Grund ist die Zählregel des Kurses selbst.** Eine 1×-Beobachtung ist eine
  *Beobachtung unter Schwelle*, kein Steering-Loop-Eintrag — die Schwelle liegt
  bei 3×. Sie gehört damit nicht in eine Liste, die **Handlungen** verspricht.
  Dass sie 25 Wellen dort stand, liegt daran, dass dieses Repo mangels
  Wellen-Betrieb keinen Kanal für Beobachtungen unter Schwelle hat — die Roadmap
  war der einzige Ort, und dort las sie sich wie ausstehende Arbeit.
- **Wiedereintritt bleibt möglich und ist benannt:** Zeigt ein Repo den Druck
  *nach* Welle 33 — Nicht-Slice-Register werden mangels Ort in ein
  Lifecycle-Verzeichnis gezwängt, obwohl `done/` sanktioniert ist —, wird der
  Faden als **frische** Beobachtung neu eröffnet, nicht als Fortsetzung dieser.

### Nicht gemessen, und das steht so da

Ob der Welle-33-Fix bei `m-trace` gereicht hat, ist von hier nicht messbar (Repo
nicht greifbar). Die Schließung stützt sich deshalb ausdrücklich **nicht** auf
„vermutlich erledigt", sondern auf die fehlende Nach-Fix-Beobachtung.

## Welle 57 — 2026-07-27 · Ein Trigger, der seine eigene Korrektur nicht kannte

### Geändert

- **Faden *Discovery-/Kandidaten-Register*: Trigger neu geschnitten.** Er lautete
  „ein **zweites** Konsument-Repo zeigt denselben Druck unabhängig" — und zählte
  damit die Ursprungs-Beobachtung als erste von zwei. Die stammt laut Welle 33 aus
  einem `m-trace`-Planning-Layout-Audit und entstand **vor** der Korrektur, die
  genau darauf hin gemacht wurde (`done/` als sanktionierte Heimat abgeschlossener
  Nicht-Slice-Records). Eine Beobachtung von vor dem Fix belegt nicht mehr, dass
  der Fix nicht reicht. Der Trigger fragt jetzt danach: *zeigt ein Repo den Druck
  **nach** Welle 33?*
- **Beleglage ausgeschrieben statt angedeutet:** eine Vor-Fix-Beobachtung
  (`m-trace`, von hier nicht nachmessbar), eine Nach-Fix-Messung mit negativem
  Ergebnis (Welle 56). `d-check` stand als Beleg im Faden, war aber nie die
  Druckquelle — die Zeile las sich, als stützten zwei Repos die Verallgemeinerung.

### Warum nicht geschlossen

Der naheliegende Schluss wäre „ein Vor-Fix-Fall plus ein negativer Nach-Fix-Fall
= erledigt". Er trägt nicht: Ob der Welle-33-Fix bei `m-trace` gereicht hat, ist
von hier **nicht messbar**, und ein unbelegtes „vermutlich erledigt" wäre genau
die Vermutung, die diese Wellen-Serie aus der Roadmap entfernt hat.

## Welle 56 — 2026-07-27 · Wie ein Faden zu prüfen ist — und der erste, der es bekommt

### Hinzugefügt

- **Zweite Form-Disziplin in [`docs/roadmap.md`](docs/roadmap.md) §Offene Fäden.**
  Ein Faden trägt zwei Dinge: eine *Behauptung über den Ist-Zustand* und eine
  *vorgeschlagene Handlung*. Wer nur die Behauptung prüft, hat den Faden nicht
  geprüft. Das Audit vom selben Tag prüfte ausschließlich Behauptungen und
  meldete „fünf von sechs halten" — zwei fielen beim Anfassen trotzdem, bei
  beiden war die Behauptung **wahr** und die Folgerung falsch (*Mechanische
  Wächter*: „lässt sich prüfen" — nein, die Fehlerklassen sind semantisch;
  *Fork-Grenze*: „also Zeremonie" — nein, das Kriterium hätte die Regel
  erschlagen, auf die es sich beruft).

### Geändert

- **Faden *Discovery-/Kandidaten-Register* erstmals gemessen.** Er stand seit
  Welle 33 mit „kein Beleg, dass dort *derselbe* Druck auftrat" — was klang wie
  *nicht nachgesehen*, und das war es auch. Jetzt nachgesehen: Der zweite
  Adopter zeigt den Druck **nicht**. Sein `docs/plan/planning/` trägt nur Slices
  und die Roadmap, und ein Review hält als Repo-Praxis fest, dass `done/` die
  Nicht-Slice-Records archiviert — genau der Weg, den der Kurs seit Welle 33
  vorsieht. Das ist ein **negativer Beleg**, kein fehlender. Die früher zitierten
  `MR-007/008/010` belegen Adopter-Schaft, nicht diesen Druck.

## Welle 55 — 2026-07-27 · Die Fork-Grenze bekommt einen Eingang statt einer Streichung

### Behoben

- **Faden *Fork-Grenze ohne Konsument* geschlossen — sein Kriterium war zu
  scharf.** Er verlangte „Feld, Gate, Übung oder Rubrik-Zeile", sonst sei die
  Dreier-Taxonomie Kandidat zum Kürzen. Gegengeprüft: Die Regel, auf die er sich
  beruft — [§Jedes Artefakt hat einen Konsumenten](kurs/de/grundlagen/konventionen.md) —
  speist selbst **0** Übungen, **0** Rubrik-Zeilen, **0** Gates und bestünde ihre
  eigene Probe nicht. Sie greift ausdrücklich *zur Entwurfszeit*; ein Mensch ist
  ein zulässiger Konsument.
- **Der reale Unterschied war enger — und er ist behoben.** Auf die
  Konsumenten-Regel verweisen zwei Templates, jemand wird also dorthin geschickt.
  Auf die Fork-Grenze verwies **nichts**: keine Zeremonie, aber kein Eingang.
  Der Adaptions-Block von `conventions.template.md` trägt jetzt die Grenze als
  Schreib-Zeit-Probe — dort sitzt der Autor eines `MR`-Eintrags —, und die Grenze
  selbst benennt ihren Leser, wie die Konsumenten-Regel es verlangt
  („benennt, **wer es liest und wann**").

## Welle 54 — 2026-07-27 · Ein Faden, der nicht baubar ist — gemessen statt vermutet

### Geändert

- **Faden *Mechanische Wächter gegen Doku-Drift* geschlossen.** Er versprach zwei
  Prüfungen, die `make check` „heute nicht hat" — als wären sie nur zu bauen.
  Gegen das reale Repo geprüft, ist keine davon umsetzbar: §-Prosa-Zeiger melden
  18 von 31 (deutsche §-Verweise sind Kurzformen der Überschrift), die
  Aufzählungs-Gleichheit scheitert am Zahlwort als Attribut („Regeln für die
  *sechs* Schritte:" gefolgt von vier Regeln), und die naheliegende dritte Idee —
  gleiches Substantiv, andere Zahl — meldet 16 legitime Fälle. Die drei belegten
  Fehlerklassen sind **semantisch**, nicht syntaktisch.
- **Ersetzt durch einen engeren Faden:** die Link-Trümmer-Prüfung bei `d-check`
  anregen. Sie ist generisch und gehört nicht in `docs-check.js` — der Rest-Sensor
  prüft ausdrücklich nur repo-spezifische Semantik, die ein generischer
  Referenz-Checker nicht kennen kann. Ein Einbau dort hätte die Pilot-Migration
  rückabgewickelt.

### Nicht gebaut — und warum das der Ertrag ist

Beim Prototyp der Link-Trümmer-Prüfung fiel im **Break-Test** auf, dass die Regex
gar nicht auslösen konnte: Sie schloss `.` aus, um Satzpunkte zu vermeiden, die
realen Trümmer beginnen aber mit `../`. Die Meldung „0 Befunde auf grünem Repo"
war damit wertlos. Ohne den erzwungenen Fehlerfall wäre ein Halluzinations-Gate
eingebaut und als Erfolg gemeldet worden — genau das, was
[Modul 13](kurs/de/04-qualitaet/modul-13-quality-gates.md) als Disziplinregel
benennt: Ein Gate, das nicht rot werden kann, ist keins.

## Welle 53 — 2026-07-27 · Das ausgelieferte Bundle bekommt einen Wächter

### Hinzugefügt

- **`make bundle-check` und ein Prüfschritt im Release-Workflow.** `make check`
  prüft `lab/regelwerk/` im **Repo-Stand** — der Release-Workflow schreibt die
  Links danach mit `rewrite-doc-links.py` um, zippt und lädt hoch. Zwischen
  Rewrite und Upload prüfte **nichts**. Ein Rewrite-Fehler oder ein Link, der
  erst durch das Umschreiben bricht, ging unbemerkt an jeden Adopter. Der neue
  Schritt läuft **vor** dem Zippen: Geprüft werden die Bytes, die im ZIP landen.
- **[`tools/build-bundle.sh`](tools/build-bundle.sh)** — die Assemblierung stand
  bisher inline im Workflow. Damit war ein lokaler Check bestenfalls eine
  *Nachbildung*, und eine Nachbildung prüft nicht das, was ausgeliefert wird.
  Jetzt bauen Workflow und `make bundle-check` über dasselbe Skript. Nebeneffekt:
  Das Pinnen der Template-Links läuft auf der Kopie statt auf `lab/templates` im
  Arbeitsbaum — ein lokaler Lauf hinterlässt keine gepinnten Links mehr im Repo.
- **[`tools/bundle-d-check.yml`](tools/bundle-d-check.yml)** — Prüf-Konfiguration
  für den Bundle-Stand (Pfade eine Ebene flacher als im Repo). `regelwerk/` wird
  scharf geprüft; `templates/` mischt symbolische Ziel-Repo-Pfade mit prüfbaren
  Verweisen, deshalb dieselbe `in`/`refs`/`keep`-Trennung wie im Repo-Config.
  Der Kern ist `keep: ["regelwerk/**"]`: Eine umbenannte Regelwerk-Überschrift
  verschickt sonst unbemerkt einen toten Anker ins Adopter-Repo.

### Belege

- Grüner Fall: `make bundle-check` → 41 Dateien, 0 Befunde; ZIP 55 Dateien wie
  im Release, und die Prüf-Config landet **nicht** darin.
- Break-Test: ein toter Anker in `lab/regelwerk/modul-06-roadmap.md` → der Gate
  meldet `anchor-missing` und bricht mit Exit ≠ 0. Ein Gate, das nicht rot
  werden kann, ist keins (Modul 13).

### Nicht gemacht

Der zwischenzeitliche Vorschlag, die vendored Baseline aus dem **Adopter**-
Prüfumfang zu nehmen, ist verworfen: Er hätte fremde Defekte stillgelegt statt
behoben — Gate-Absenkung zur Befund-Vermeidung. Defekte im Kurs gehören vor der
Auslieferung gefangen, und genau dort sitzt der neue Wächter.

## Welle 52 — 2026-07-27 · Drei Fäden geschlossen — keiner durch Abarbeiten

Alle drei fielen, weil ihre **Prämisse** nicht hielt. Das ist der eigentliche
Ertrag dieser Welle: Ein Faden, dessen Trigger nie geprüft wird, altert genauso
still wie die Doku, die er beschreibt.

### Behoben

- **Phase C ist geliefert — sechs Stellen behaupteten das Gegenteil.**
  `make gates` über alle sechs Sprachskelette: **6/6 grün**, mit echten
  Toolchains und Coverage-Schwellen (Go 77,8 % · Python 76,99 % bei Schwelle
  70 % · Kotlin `koverVerify` · Java `mvn verify` · C# `dotnet test` · C++ 1/1).
  `kurs/de/grundlagen/README.md` nannte Phase C längst „ausgeliefert", während
  [Modul 13](kurs/de/04-qualitaet/modul-13-quality-gates.md), `lab/README.md`
  (3×), `lab/example/README.md`, `lab/example/AGENTS.md` und `CO-001` weiter
  „kommen in Phase C" sagten — Modul 13 zusätzlich mit falscher Zahl („fünf"
  statt sechs). Alle korrigiert. Dieselbe Klasse wie der Meilenstein `v3.7.0`,
  der auf „ausstehend" stand, obwohl er zweimal getaggt war.
- **Spec-Strata-Adaptionsrichtung: ein Zeiger widersprach seinem Ziel.**
  `harness/README.template.md` schickte Zwei-Straten-Repos zu `MR-001` als
  Beispiel — und `MR-001` dokumentiert den *Drei*-Straten-Fall.
  [`konventionen.md` §Spec-Straten](kurs/de/grundlagen/konventionen.md) entscheidet
  die Richtung längst („nur Vertrag und Sicht sind obligatorisch; das
  Technik-Stratum ist optional"), also **Baseline = zwei Straten, die
  Drei-Straten-Form ist die Adaption**. Der Hinweisblock sagt das jetzt und
  benennt, dass die Vorlage bereits die adaptierte Form zeigt.
- **Der Formcheck des Adaptions-Durchgangs war nie Prosa-Arbeit.**
  [Modul 2 §Freshness-Audit](kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md)
  verlangte von Hand zu prüfen, ob `Geltungsbereich`-Verweise nach dem Update
  noch auflösen. Messung an einer Fixture: Der ausgelieferte
  `lab/templates/.d-check.yml` hat `roots: ["."]`, ignoriert `.harness/` nicht,
  und d-check scannt Punktverzeichnisse — ein toter Anker meldet sich als
  `anchor-missing`. Der Text verweist jetzt aufs Gate; übrig bleibt die einmalige
  Prüfung, dass `.harness/baseline/` im Prüfumfang liegt.

### Geändert

- **Neuer Faden, eng geschnitten:** *Bootstrap-Übung im Lab fehlt.*
  `lab/example/exercises/` trägt Übungen zu anderen Modulen, aber keine zum
  Bootstrap — das ist wahr geblieben, hatte mit Sprach-Skeletten aber nie etwas
  zu tun und war nur mitgeschleppt unter *Lab Phase C*.

## Welle 51 — 2026-07-27 · Zwei Restbefunde aus der Review-Serie zu Welle 50

### Behoben

- **Die Selbstcheck-Präambel von [Modul 2](kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md)
  stimmte nach Welle 50 nicht mehr.** Sie behauptet, der Selbstcheck decke „alle
  fünf Lernziele plus die Conceptual-Change-Selbstvalidierung" ab — Welle 50 hat
  aber ein siebtes Item ergänzt, das an keinem Lernziel hängt. Statt es einem
  Lernziel anzuhängen, das es nicht trägt, sagt die Präambel jetzt, was der Fall
  ist: Der §Freshness-Audit trägt Regeln, die *nach* dem Bootstrap greifen und
  deshalb außerhalb der Lernziele liegen; geprüft werden sie trotzdem, weil eine
  Regel ohne Prüfung halbgesetzt wäre.
- **Rangzahlen in Prosa entfernt**
  ([Modul 1](kurs/de/01-spec-und-architektur/modul-01-entwicklungszyklus.md)):
  aus „ADRs sind Rang 4, AGENTS.md Rang 8" wurde „Die ADR rangiert höher als
  `AGENTS.md`". Dieselbe Kur wie in Welle 50 für `konventionen.md` — eine
  Rangzahl in Prosa gilt immer nur für *eine* Strata-Variante und altert mit
  jeder anderen. Der Regelwerk-Spiegel trägt die Zeile nicht.

### Nicht behoben — bewusst als Fäden geführt

Die übrigen Befunde der fünf Review-Runden stehen in
[`docs/roadmap.md`](docs/roadmap.md), weil sie eine **Entscheidung oder einen
Beleg** brauchen, keine Redaktion: die widersprüchliche Spec-Strata-
Adaptionsrichtung (welche Richtung gilt, ist eine Setzung), der Formcheck, der
erst ins Gate kann, wenn ein Adopter die vendored Baseline in seinen Prüfumfang
nimmt, und die Fork-Grenze, deren Konsument sich erst zeigen muss.

## Welle 50 — 2026-07-27 · Was mit `MR-*`-Adaptionen passiert, wenn die Baseline weiterzieht

### Hinzugefügt

- **[Modul 2](kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md)
  §Freshness-Audit: der Review geht durch die Adaptions-Liste, nicht nur durch
  den Diff.** Bisher stand dort nur „ein neuer Tag löst einen Review aus" — was
  dieser Review umfasst, war nirgends gesagt, und `MR` kam im ganzen Abschnitt
  nicht vor. Ein Adopter bekam also die Aufforderung zu reviewen, aber nicht den
  Hinweis, seine eigenen Abweichungen gegen die neue Fassung zu halten. Jede
  `MR-<NNN>` trägt ein Pflichtfeld *Auflösungs-Trigger oder „permanent"*, und ein
  neuer Baseline-Stand ist genau das Ereignis, das solche Trigger feuert — ein
  Trigger, den niemand abfragt, ist kein Wächter. Fünf Ausgänge pro Eintrag —
  gegenstandslos · bleibt gültig · teilweise überholt · Bezug ist entfallen ·
  widerspricht —, jeweils bezogen auf das **Delta** der neuen Fassung, nicht auf
  den Zustand der Baseline: Eine Adaption weicht definitionsgemäß von einer
  Baseline-Regel ab, eine Zustands-Frage hätte den Normalfall durchfallen lassen.
  Davor ein Formcheck: Ein toter Anker im Geltungsbereich ist
  kein Ausgang, sondern ein Formfehler.
  `permanent`-Einträge werden ausdrücklich mitgeprüft (*permanent* heißt „kein
  automatischer Trigger", nicht „unauflösbar"); war die Adaption eine *Lockerung*
  und die Baseline verschärft, ist ein **Carveout** die richtige Antwort, keine
  stille Dauer-`MR`.
- **Der Review vergleicht auch die Form, nicht nur die Regeln.** Regel-Drift hat
  seit jeher ein Signal (den `Auflösungs-Trigger` einer `MR-<NNN>`), Form-Drift
  hatte keines: Ändert ein neuer Stand die *Struktur* der Artefakte, meldet sich
  nichts. Der Fall ist nicht theoretisch — diese Welle selbst ergänzt zwei Felder
  in `conventions.template.md`, und `harness/conventions.md` ist ein **Singleton**
  (`lab/templates/README.md`: einmal füllen, Template verwerfen). Neu: Nach dem
  Re-Vendoring ist die vendored Referenz-Form unter
  `.harness/baseline/<tag>/templates/` die Vergleichsgrundlage — neue *optionale*
  Felder brauchen keinen Rückbau, neue **Pflicht**-Felder und umbenannte
  Sektionen schon; für wiederkehrende Templates gilt Append-only (neue Instanzen
  folgen der neuen Form, bestehende werden nicht umgeschrieben). Dazu präzisiert
  `lab/templates/README.md`, dass „`.template.md` verwerfen" die Kopie im
  Arbeitsbaum meint, nicht die vendored Referenz-Form.
- **Rückbau ist ein neuer Eintrag, kein Edit** — mit Slot im ausgelieferten
  Artefakt: `conventions.template.md` trägt jetzt die Felder *Löst auf* und
  *Ausgelöst durch Baseline-Stand*. Vorher hätte die Regel in ein Skelett
  geschrieben werden müssen, das dafür kein Feld hat.
- **Selbstcheck, Rubrik-Zeile, Themen-Bullet und die zugehörige Antwort in
  [`loesungen/modul-02-loesung.md`](kurs/de/loesungen/modul-02-loesung.md)** in Modul 2 — der ganze
  §Freshness-Audit war didaktisch ungedeckt (kein Thema, kein Item, keine
  Rubrik), und diese Welle hängt zwei weitere normative Regeln daran.

### Geändert

- **[`konventionen.md`](kurs/de/grundlagen/konventionen.md) §Source Precedence
  ordnet `harness/conventions.md` und die vendored Baseline ein** — beide
  bewusst **außerhalb** der Rangliste. Der Konventionsspeicher ist kein weiterer
  Rang, sondern die Stelle, an die die rangierten Dokumente Form- und
  Strukturfragen *abtreten*: Wo `AGENTS.md` oder `harness/README.md` dazu nichts
  sagen, entsteht kein Konflikt, sondern eine Zuständigkeit — die Rangliste
  entscheidet über *Inhalt*, der Konventionsspeicher über *Form*. Ein zehnter
  Rang wäre zudem praktisch falsch: Modul 1 nennt neun Ränge als Maximum, und
  die ausgelieferte Template-Form ist mit drei Spec-Straten bereits dort.
- **Die Anschlussregel steht jetzt da, wo sie gesucht wird:** Eine `MR-<NNN>`
  gilt innerhalb ihres deklarierten Geltungsbereichs vor der Baseline, außerhalb
  gilt die Baseline unverändert. Daraus die Grenze — eine `MR-<NNN>`, deren
  Geltungsbereich die *gesamte* Baseline umfasst, ist kein Adaptions-Eintrag
  mehr, sondern ein **Fork**; eine *fehlende* Angabe ist kein eigener Fall,
  sondern ein Formfehler (Pflichtfeld).
- **Pflichtfeld-Liste des Adaptions-Blocks vervollständigt** — das Feld
  *Adaption* fehlte, obwohl das Template es seit jeher führt.
- **Rangzahl-Kollision bereinigt:** `konventionen.md` bezeichnete an anderer
  Stelle `harness/README.md` als „Rang 9" — eine Zahl aus der Template-Form, die
  gegen die Default-Liste mit acht Rängen stand. Jetzt rangagnostisch („unterster
  Rang"). Dazu ergänzt `AGENTS.template.md` die fehlende `docs/user/*`-Zeile:
  Die ausgelieferten Träger einer Precedence-Tabelle — die drei Singleton-Templates
  **und** `lab/example/AGENTS.md` — trugen bis dahin zwei verschiedene
  Rangordnungen (8 vs. 9 Ränge, README einmal auf 6, einmal auf 7); im
  Begleit-Lab existiert `docs/user/` sogar, fehlte in `AGENTS.md` aber.
- **Ablösung und Schärfung getrennt:** `Löst auf` gilt für die Ablösung; eine
  bloße *Schärfung* (der alte Eintrag gilt weiter, enger) steht wie bisher im
  Titel — `(schärft MR-<NNN>)`, wie in Modul 13 §Worked Example B.
- **Regelwerk-Splits `grundlagen-konventionen` und `modul-02` mitgezogen**,
  Stand-Zeile auf Welle 50.
- **Vier offene Punkte als Fäden in [`docs/roadmap.md`](docs/roadmap.md)** statt
  in dieser Welle miterledigt: mechanische Wächter gegen Doku-Drift, die
  widersprüchliche Spec-Strata-Adaptionsrichtung in den Templates (vorbestehend),
  die Fork-Grenze ohne Konsument und der Formcheck, der ins Gate gehört. Fünf
  Review-Runden über diese Welle fanden dreimal dieselben Fehlerklassen — Echo
  nicht mitgezogen, Pointer ohne Ziel, Ausgang nicht ausführbar —, und mindestens
  vier Befunde wären maschinell gefallen. Das ist der Grund für den ersten Faden.
- **Diagramm und Konfliktregel nachgezogen:** Der Precedence-Graph zeigt die
  Harness-Schicht und die Baseline als eigene Ebene, die Legende kennt die neue
  graue Farbe, und die Konfliktregel nennt `harness/conventions.md` mit.

## Welle 49 — 2026-07-27 · Zwei Korrekturen nach v3.8.0: Quellen-Titel und ein Faden, der keiner war

### Behoben

- **Böckeler-Artikeltitel am Original geprüft.** Er lautet
  *„Harness engineering for coding agent users"* — klein geschrieben und mit
  „users". `quellen.md` trug seit jeher *„Harness Engineering for Coding Agents"*,
  und in Welle 48 wurde der README-Text nach dieser Abschrift „korrigiert" — eine
  richtige Fassung durch eine falsche ersetzt. Der Fehler ist methodisch: Für
  einen externen Titel ist eine repo-interne Datei kein Beleg. Beide Stellen
  stehen jetzt auf dem am Original geprüften Wortlaut, `quellen.md` zusätzlich mit
  Erscheinungsdatum. Die verlinkte URL war bereits die kanonische
  (`articles/harness-engineering.html` liefert HTTP 200; der
  `exploring-gen-ai/`-Pfad antwortet mit 301 auf ebendiese).

### Geändert

- **[Modul 6](kurs/de/02-planung/modul-06-roadmap.md) beantwortet den
  Vorwärts-Blick für wellenlose Arbeit.** Der nach Welle 48 offene Faden
  behauptete, wellenlose Arbeit habe kein „Soll" — nur ein „Ist" über
  `ls in-progress/`. Gegen Modul 5 gehalten hält das nicht: `next/` heißt
  *priorisiert/eingeplant*, und `open→next` **ist** die Priorisierungs-
  Entscheidung — seit Welle 48 wellenneutral formuliert. Der tragende Punkt liegt
  tiefer: Eine Reihenfolge *einzelner* Slices kennt der Harness überhaupt nicht,
  auch nicht für wellengebundene Arbeit. Die Roadmap ordnet **Wellen**, die Spalte
  *Wichtigste Slices* nennt Inhalt statt Rang, und `slice.template.md` hat kein
  Prioritätsfeld. Der Faden behauptete also einen Nachteil, den es nicht gibt; er
  ist **aufgelöst, nicht gelöst**. Modul 6 warnt an derselben Stelle davor, für
  wellenlose Arbeit eine Rangliste neben der Roadmap anzulegen — das wäre eine
  Sortierung, die es für Slices nie gab, und die zweite Quelle, die die Regel
  darüber gerade vermeidet. Regelwerk-Split mitgezogen.
- **`docs/roadmap.md`**: Faden entfernt, Drift-Tabelle trägt die Begründung
  (inklusive des Fehlers im Fadentext selbst, der `open/` statt `next/` nannte).

## Welle 48 — 2026-07-27 · Wellenlose Arbeit bekommt eine Regel; README neu gefasst

### Hinzugefügt

- **[Modul 6](kurs/de/02-planung/modul-06-roadmap.md) §Wann Arbeit eine Welle
  braucht — und wann nicht.** Das Roadmap-Format ist wellen-zentriert (fünf
  Abschnitte, alle über Wellen), und `slice.template.md` bot seit jeher den Wert
  `ohne Welle` an — ohne dass die Quelle den Begriff kannte. Für einen einzelnen
  Slice gab es damit keinen Ort, und der Fehlgebrauch ist beobachtet: Die Arbeit
  landet unter *Aktuelle Welle*, bis der Abschnitt seitenlang ist und zugleich
  meldet, dass keine Welle läuft. Die Regel ist aus dem Kernbegriff hergeleitet
  („Bündel von Slices, das gemeinsam **abgeschlossen** wird"): **Eine Welle liegt
  vor, wenn es eine beobachtbare Closure-Bedingung gibt, die mehr beobachtet, als
  die DoDs ihrer Slices schon belegen.** Kein Größen-Kriterium — ein
  Ein-Slice-Bündel bleibt eine Welle, wenn sein Trigger repo-weite Belege fordert.
- **Wellenlose Arbeit erscheint nicht in der Roadmap.** Ihr Zustand ist die
  Verzeichnis-Position ([Modul 5](kurs/de/02-planung/modul-05-planning-harness.md));
  ein Eintrag daneben wäre eine zweite Quelle für denselben Zustand. Einzige
  Berührung: liefert sie den letzten Beleg eines Meilensteins, bleibt die Spalte
  `Welle(n)` leer und der Beleg steht als Slice-ID daneben.
- **Übung, Selbstcheck und Lösung** zur neuen Regel (beide auf LZ 2, das dafür um
  *„erkennen, wann Arbeit ganz ohne Welle läuft"* erweitert wurde) — mit dem
  Gegenfall, an dem sich zeigt, ob jemand das Kriterium oder bloß die Slice-Zahl
  anwendet.
- **`lab/example/…/done/slice-020-referenz-richtung-repariert.md`** — erster
  wellenloser Slice im Begleit-Lab; der Template-Wert `ohne Welle` hatte bis dahin
  kein Vorbild. Reaktiv ausgelöst durch `make check-references`, mit einem Risiko
  im Ausgang *weiter offen*, das in die nächste Welle-Closure abliefert.

### Geändert

- **Welle-Closure Schritt 3 verdichtet jetzt *alle* Slice-Closures seit der letzten
  Welle-Closure**, die wellenlosen eingeschlossen — vorher nur „die Slices dieser
  Welle". Ohne diese Korrektur hätte die neue Regel drei Wächter still abgeschaltet:
  Der Steering-Loop-Zähler (1×/2×/3×) entsteht ausschließlich in diesem Schritt, der
  Risiko-Ausgang *weiter offen* hat dort sein einziges Ziel, und die Carveout-Frist
  („seit > 2 Wellen aktiv", [Modul 7](kurs/de/02-planung/modul-07-carveouts.md))
  misst in Wellen. Ein Modus ohne Wächter wäre genau die Pathologie, die Welle 44
  als *„ein Trigger ohne Wächter ist eine Absichtserklärung mit Verfallsdatum"*
  benannt hat.
- **Zwei Mermaid-Diagramme kodierten die Kopplung mit** und wurden nachgezogen: der
  Steering-Loop-Graph in
  [`konventionen.md`](kurs/de/grundlagen/konventionen.md) (Knoten „Welle-Closure
  Schritt 3") und das Lifecycle-Zustandsdiagramm in Modul 5 (`open --> next: in
  Welle priorisiert` → `priorisiert/eingeplant`; Note „bei der **nächsten**
  Welle-Closure"). Die Abhängigkeitsgraphen in `roadmap.template.md` und im Lab
  bleiben unberührt — sie zeigen Wellen-Reihenfolgen, kein Slice-Routing.
- **Verzeichniskonvention entkoppelt.** Der Kommentar zu `docs/plan/planning/next/`
  lautete `# priorisiert für die nächste Welle` und band das Verzeichnis an einen
  Wellen-Betrieb, den es nicht voraussetzt — jetzt `# priorisiert/eingeplant`, in
  [`konventionen.md`](kurs/de/grundlagen/konventionen.md) und im Regelwerks-Spiegel.
  Normativ gewichtiger als die Diagramm-Labels darüber: Adopter kopieren diesen
  Block.
- **`welle-results.template.md`** zitierte die ersetzte Schritt-3-Formulierung
  wörtlich („Grundlage sind die Closure-Notizen der Slices dieser Welle") und
  kodierte damit den Ausschluss wellenloser Slices in genau dem Artefakt, das
  Adopter kopieren. `lab/templates/` ist gate-ignoriert — `make check` sieht das nie.
- **`slice.template.md`** trägt statt der unverankerten Klammer `(Wartung/Spike)`
  jetzt den Trigger-Grund und verweist auf den Regelwerks-Abschnitt. Die Klammer
  engte falsch ein: entscheidend ist die fehlende eigenständige Closure-Bedingung,
  nicht die Art der Arbeit.
- **README neu gefasst** (Commit `85d46f1`): Schnellstart-Block, eigener Abschnitt
  *Einordnung der Quellen* mit den Belegen zu Böckeler und Lopopolo, Adoptions-
  schritte inline. **Korrigiert dabei eine Falschaussage aus Welle 47**: dort stand,
  `ai-harness-init` führe „dieselben Schritte" aus wie der manuelle Weg. Das
  stimmt nicht — das CLI richtet ein Repo samt lauffähiger Gates ein, kennt
  `add-lang` für Mono-Repos und `--arch` für die Bauform, während das Baseline
  Bundle Regelwerk und Templates liefert. Eine Vergleichstabelle sagt das jetzt.
  Versionsgebundene Angaben (Versionsstand, Plattform-Zahl, Sprachliste) sind
  entfernt, damit der Text nicht bei jedem CLI-Release nachzieht.

## Welle 47 — 2026-07-26 · Bootstrap-Werkzeug verlinkt; Adopter-Zählung korrigiert

### Hinzugefügt

- **README §Adoptieren verweist auf [`ai-harness-init`](https://github.com/pt9912/ai-harness-init)** —
  das CLI führt dieselben Schritte aus, die der Abschnitt von Hand beschreibt
  (Skelette, Gate-Baseline, vendored Regelwerk unter `.harness/baseline/`,
  idempotent). Bewusst als **eigenes Projekt** ausgewiesen (MIT, Stand v0.x,
  nicht Bestandteil des Kurses) und mit der ehrlichen Gegenrechnung: es braucht
  Docker, Git und `make`, der manuelle Weg kommt ohne Installation aus. Dazu
  der Satz, der die Rollen trennt: *das Werkzeug nimmt die Handgriffe ab, nicht
  die Entscheidungen* — wer wissen will, was entsteht, liest Modul 2.

### Geändert

- **Faktenfehler in `docs/roadmap.md` korrigiert (aus Welle 45).** Der Faden
  *Discovery-Register* trug die Klammer „(heute nur `d-check`)" — falsch, und
  schon beim Schreiben falsch: Das CHANGELOG weist `ai-harness-init` **dreimal**
  als Adopter mit eigenen `MR-007`, `MR-008` und `MR-010` aus, der drei
  Kurs-Lücken aufdeckte (d-check.mk-Drift, Instanziierungs-Zeitpunkt,
  Baseline-Freshness). Es gibt also **zwei** Konsument-Repos, nicht eines.
  Der Faktencheck des Reviews hatte den Satzteil nicht erfasst, weil er die
  Welle-33-Formulierung verglich, nicht die Klammer.
  **Der Faden bleibt trotzdem vertagt** — und die Roadmap sagt jetzt genauer,
  warum: Der Trigger hat zwei Hälften. *Zweites Konsument-Repo* ist erfüllt;
  *derselbe Druck* ist es nicht — für einen Bedarf an einem
  Discovery-/Kandidaten-Register in `ai-harness-init` gibt es keinen Beleg. Die
  Verallgemeinerung braucht die wiederholte **Beobachtung**, nicht nur einen
  zweiten Adopter.

## Welle 46 — 2026-07-26 · „Jedes Artefakt hat einen Konsumenten" wird auffindbar — und ehrlich eingeordnet

Auslöser war die Rückfrage, wo dieser „Graph-Test" eigentlich steht. Antwort:
**nirgends in der Lehre.** Der Begriff kam ausschließlich in
CHANGELOG-Einträgen dieser Sitzung vor; im Kurs existierte **ein Satz** in
einer Diagramm-Nachbesprechung (`konventionen.md`) — ohne Namen, ohne eigene
Überschrift, ohne Anker, nicht im Regelwerk-Split. Damit war ausgerechnet die
Regel, die verlangt, dass jedes geschriebene Artefakt einen Leser hat, selbst
so abgelegt, dass der Adopter sie nicht liest.

### Hinzugefügt

- **`konventionen.md` §Jedes Artefakt hat einen Konsumenten** — eigener
  Abschnitt mit Anker statt Satz im Fließtext. Regel: Wer dem Harness ein
  Artefakt hinzufügt, benennt, *wer es liest und wann*; findet sich kein
  Leser, ist es Ablage, keine Steuerung. Das Fluss-Diagramm bleibt, wo es ist,
  und ist jetzt ausdrücklich die *Illustration* der Regel, nicht ihr Träger.
- **Zwei Ausnahmen benannt**, die in den Wellen 40–43 empirisch aufgetreten
  sind: **derivative Artefakte** (Index; braucht keinen Leser, aber eine
  Deckung — sonst schlägt die Probe falschen Alarm) und **Lauf-Belege**
  (Konsument ist der Vorgang und danach der Audit).
- **In den Regelwerk-Split übernommen** (Anker
  `#jedes-artefakt-hat-einen-konsumenten`) — die Regel ist operativ genug für
  einen Adopter, der seinen Harness erweitert. Das Diagramm bleibt draußen:
  Illustration ist Didaktik.

### Geändert

- **Ehrlich eingeordnet statt hochgestuft.** Die Regel ist *inferential
  feedforward* und greift zur **Entwurfszeit** — beim Erweitern des Harness,
  nicht in seinem Betrieb. Sie wird **ausdrücklich kein Prüfpunkt der
  Closure-Prozedur**: dort spräche sie in den meisten Wellen auf nichts an,
  würde nach der dritten Welle übersprungen und wäre danach eine Harness-Lüge
  (Modul 13: *„wenn ein Gate manchmal rot sein darf, ist es kein Gate"*). Der
  häufige Fall ist ohnehin gedeckt — eine Beobachtung, die die Schwelle
  erreicht, hat ihren Leser automatisch, und die Anker-Paarung prüft
  deterministisch, dass die Regel landete.
  Dazu die Grenze: Die Regel sagt **nicht**, ob ein genannter Konsument den
  Inhalt auch *nutzt*. *„Wird beim Audit gelesen"* ist eine gültige und
  zugleich die schwächste Antwort.

## Welle 45 — 2026-07-26 · Das Kurs-Repo bekommt eine Roadmap (und deklariert seine Reduktion)

### Hinzugefügt

- **`docs/roadmap.md`.** Befund beim Nachsehen: Das Repo hatte **keine Roadmap
  und überhaupt keine eigenen Harness-Artefakte** (kein `AGENTS.md`, kein
  `harness/`, kein `spec/`). Faktisch läuft hier aber ein *reduzierter* Harness
  — `CHANGELOG.md` als Wellen-Register, `make check` als Gates, d-check per
  Digest gepinnt. Der Harness war also nicht abwesend, sondern **unvollständig
  und undeklariert** — dieselbe Klasse wie eine unbegründete Grenze: liest sich
  als Rückstand statt als Entscheidung.
  Die Roadmap ist das **Gegenstück zum CHANGELOG**: dort steht, was geschlossen
  wurde, hier, was offen ist und *woran man erkennt, dass es dran ist*. Vorher
  lagen die offenen Fäden als Fließtext in alten Wellen-Einträgen —
  write-only, dieselbe Klasse, die die Wellen 38–44 fünfmal behoben haben.
  Geführt werden vier Fäden mit Trigger-Spalte; wo kein beobachtbarer Trigger
  existiert, steht ausdrücklich **„nicht gesetzt"** statt eines erfundenen
  Termins — ein Faden ohne Trigger ist ein Wunsch, kein Plan (Modul 6).
- **Die Pfad-Abweichung ist deklariert.** Der Kurs lehrt
  `docs/plan/planning/in-progress/roadmap.md`; dieses Repo führt die Roadmap
  **flach**, weil der gelehrte Pfad die vier Lifecycle-Verzeichnisse
  voraussetzt — die ohne Slice-Betrieb anzulegen wäre *„Struktur ohne
  Substanz"*, genau wovor die Sub-Area-Qualifikation warnt. Der Ausbau zu einem
  `harness/conventions.md` (Variante B der Diskussion) steht als eigener Faden
  in der Roadmap, **mit beobachtbarem Trigger**: *sobald die Roadmap eine
  zweite Adaption gegenüber dem gelehrten Aufbau braucht*.
- **Im README verdrahtet** — sonst wäre die Roadmap selbst write-only gewesen.

## Welle 44 — 2026-07-26 · Graph-Test systematisch: ein Trigger ohne Wächter

Der Konsumenten-Test aus Welle 39 wurde erstmals **über alle ~70
Template-Sektionen** gezogen statt punktuell. Die meisten sind trivial
konsumiert (Spec/ADR/AGENTS werden per Source Precedence in jedem Lauf
gelesen). Drei Befunde blieben — und der erste ist generalisierbar.

### Hinzugefügt

- **Trigger-Audit statt Carveout-Audit (Modul 6 Schritt 2).** Der Harness kennt
  **drei** Artefaktklassen mit einem Trigger; geprüft wurde bisher genau eine:

  | Artefakt | Trigger | Wächter vorher |
  |---|---|---|
  | Carveout | Auflösungs-Trigger | Carveout-Audit pro Welle ✓ |
  | Bootstrap-aware Gate | Hochschalt-Trigger | **keiner** |
  | ADR | Re-Evaluierungs-Trigger | **keiner** |

  Der Kurs benannte die Pathologie bereits — aber nur für Carveouts
  (*Carveout-Wildwuchs: temporäre Ausnahmen, deren Trigger längst eingetreten
  ist*). Dieselbe Verfallsform für Gates (ewig 40 %, obwohl M2 erreicht ist)
  und ADRs (Entscheidung, deren Re-Evaluierungs-Bedingung vor einem Jahr
  eintrat) hatte weder Namen noch Wächter. Schritt 2 prüft jetzt alle drei;
  `klassifikation.md` §Entropy Management führt die zwei fehlenden
  Verfallsformen (*Stehengebliebene Reifestufe*, *Abgelaufene Entscheidung*).
  Leitsatz: **ein Trigger ohne Wächter ist eine Absichtserklärung mit
  Verfallsdatum.**

### Geändert

- **`Re-Evaluierungs-Trigger` in Modul 4 verankert.** Er stand nur im
  ADR-Template und in der *Lösung* — Modul 4 nannte als MADR-Pflichtabschnitte
  nur Kontext · Optionen · Entscheidung · Konsequenzen. Template-Struktur ohne
  Quell-Verankerung, dieselbe Klasse wie der Welle-33-Defekt. Jetzt in
  §Kernidee erklärt, im Lernziel und in der Selbstcheck-Rubrik geführt.
- **`Out-of-Scope` für die Welle verankert.** `welle.template.md` §6 trug
  *„Out-of-Scope für diese Welle"* — der Kurs lehrt Out-of-Scope für das
  Lastenheft (Modul 3) und den Slice-Plan (Modul 9), für die **Welle
  nirgends**. Jetzt Teil von Schritt 1 der Wellen-Eröffnung, mit Begründung:
  was nicht ausdrücklich ausgeschlossen ist, dehnt die Welle, bis der
  Closure-Trigger unerreichbar wird.
- **Satelliten:** Regelwerk-Splits `modul-04`, `modul-06`,
  `grundlagen-klassifikation`.

**Geprüft und in Ordnung** (Nicht-Befunde des Sweeps): `roadmap`
§Historische Trigger-Verschiebungen ist als *Audit-Signal* deklariert —
Lauf-Beleg-Klasse wie `docs/reviews/`. ADR §Geschichte, Carveout §Geschichte
und die Spec-§Historie sind Audit- bzw. CR-Fußabdruck (Welle 34). Alle
Spec-/AGENTS-/`harness/README`-Sektionen werden per Source Precedence in jedem
Lauf gelesen. Skills §Pflege ist seit Welle 43 verdrahtet.

## Welle 43 — 2026-07-26 · Review-Findings finden ihren Zähler — ohne Archiv-Scan

Letzte offene Stelle aus dem Konsumenten-Audit: Modul 10 §Pflege verlangt
*„bei dreimaligem Auftreten desselben Findings"* zu schärfen — und dieser
3×-Regel fehlte der Zähler, genau wie der Steering-Loop-Regel vor Welle 38.
`docs/reviews/` wächst um eine Datei pro Lauf und wurde über Läufe hinweg von
niemandem gelesen.

### Geändert

- **`docs/reviews/` umgedeutet: Lauf-Beleg statt Wissensspeicher.** Der Report
  belegt *diesen Diff, mit diesem Skill, diesem Modell, diesem Verdikt*; sein
  Konsument ist der Implementer im selben Zyklus (bereits deklariert) und
  danach der Audit. **Er braucht keinen Leser über Läufe hinweg** — und einen
  zu bauen wäre der falsche Reflex gewesen (Archiv-Scan = vierter Mechanismus).
- **Das steuerungsrelevante Signal ist die Finding-Klasse, nicht der Report.**
  Neues Feld `klasse` pro Finding plus Summary-Zeile *Finding-Klassen dieses
  Laufs*; von dort über die Slice-Closure §7 in denselben Zähler, den Welle 38
  gebaut hat. **Niemand muss wissen, ob eine Klasse „schon mal" auftrat** —
  genau dafür ist der Zähler da: der Reviewer benennt einmal pro Lauf, die
  Häufung entsteht bei der Verdichtung über die Slices einer Welle.
- **Modul 10 Schritt 6 sagt jetzt, wer zählt.** Bisher stand dort „bei
  dreimaligem Auftreten" in einem Skill-Block — der Skill kann das gar nicht
  zählen, weil jeder Lauf für sich steht. Er formuliert nur noch, *was bei
  Erreichen der Schwelle zu tun ist*.
- **Damit hat der Closure-Eintrag drei deklarierte Quellen** (Modul 5): eigene
  Beobachtung · offenes Risiko aus §6 (Welle 40) · wiederkehrende
  Finding-Klasse (diese Welle). Alle drei nehmen dieselbe Route und brauchen
  dieselbe **stabile Bezeichnung** — zwei Namen für dasselbe Muster werden
  getrennt gezählt und erreichen die Schwelle nie.
- Damit wird auch der Graph aus Welle 39/41 wahr: Er nennt *Review-Findings*
  als Beobachtungs-Quelle, ohne dass es dafür bisher einen Weg gab.
- **Satelliten:** Regelwerk-Splits `modul-05`/`modul-10`; `lab/example` zeigt
  die dritte Quelle real (Finding-Klasse als 2×-Beobachtung).

## Welle 42 — 2026-07-26 · Validierung: Widerspruch aufgelöst, Abwesenheit begründet

Auslöser war die Frage „Validierung kommt nicht vor — warum nicht?". Antwort:
Es war **keine Entscheidung, sondern ein unabgeglichener Widerspruch** — drei
Aussagen, zwei davon im selben Modul, 35 Zeilen auseinander.

| Wo | Aussage |
|---|---|
| Modul 8 §Rollen-Sequenz | Validator sitzt **in jeder Slice-Sequenz** |
| Modul 8 §Fehlvorstellungen | Validierung gehört **vor** größere Wellen und **nach jedem MVP-Slice** — also nicht pro Slice |
| Modul 1 + `konventionen.md` | Validierung kommt in der Artefaktkette **gar nicht vor** |

Die Auflösung lag bereits im Repo, nur unausgesprochen: Die
Artefaktklassen-Tabelle (Welle 36) ordnet den Validator unter **„keins"** ein,
*weil die Prüfgrundlage außerhalb des Repos liegt*. Damit ist die Abwesenheit
aus der Artefaktkette sachlich richtig — die Kette ist eine Kette von
**Repo-Artefakten**, und Validierung hinterlässt keines.

### Geändert

- **Kadenz ehrlich gemacht:** Die beiden Validator-Kanten stehen im
  Sequenzdiagramm jetzt in einem `opt`-Block *„nur bei MVP-Slice — nicht in
  jeder Sequenz"*. Vorher zeigte das Diagramm den Validator in jedem Slice,
  während der Fließtext desselben Moduls das Gegenteil sagte. Begründung
  ergänzt: Validierung an jeden Slice zu hängen wäre so teuer, dass sie in der
  Praxis ganz entfiele. Selbstcheck-Rubrik („neun Übergabe-Artefakte") um die
  Bedingung ergänzt.
- **Abwesenheit begründet statt stumm gelassen** — Modul 1 §Lebenszyklus und
  `konventionen.md` §Kernbegriffe (SDLC-Zeile) sagen jetzt, *warum* Validierung
  keine Station hat, und verweisen auf die Rollen-Sequenz als ihren Ort. Eine
  unbegründete Abwesenheit ist dieselbe Klasse wie eine unbegründete Grenze:
  sie liest sich als Rückstand statt als Entscheidung.
- **Validierungsbeleg als repo-extern deklariert.** Er hat keine Ziel-Form und
  keinen Ort — **weil er keinen haben kann**, nicht weil eine Lücke besteht.
  Damit ist auch der Audit-Befund von vorhin aufgelöst. Was aus einer
  Validierung *ins Repo* zurückwirkt, ist eine **Spec-Änderung** (externer
  CR-Prozess, Welle 34) oder ein **Lerneintrag** in der Closure-Notiz; der
  Beleg selbst bleibt draußen.
- **Satelliten:** Regelwerk-Splits `modul-08` (Sequenz, Kadenz, repo-extern) und
  `grundlagen-konventionen` (SDLC-Zeile).

## Welle 41 — 2026-07-26 · Der fehlende Lese-Schritt: Slice-Closures werden verdichtet

### Hinzugefügt

- **Modul 6 Schritt 3 liest jetzt, bevor er schreibt.** Der Graph aus Welle 39
  zeichnet eine Kante *Slice-Closure §7 → „Wie oft?"* — für die es **keinen
  Schritt gab**. Verifiziert: null Treffer für eine Anweisung, die Closure-Notizen
  der Slices einer Welle zu lesen. Die Welle-Closure *schrieb*
  §Steering-Loop-Einträge und §Beobachtungen unter Schwelle; woher deren Inhalt
  kommt, sagte niemand. Folgen: (a) der **Slice**-Lerneintrag war selbst
  write-only — dasselbe Problem eine Ebene tiefer als Welle 38; (b) die
  3×-Zählung war gar **nicht durchführbar**, denn ob eine Beobachtung ein- oder
  dreimal auftrat, steht ausschließlich in den Slice-Closures. Welle 38 hat den
  Zähler gebaut und stillschweigend angenommen, die Einträge erschienen von
  selbst. Jetzt ist *Grundlage sind die Closure-Notizen der Slices dieser Welle*
  expliziter Vorlauf von Schritt 3: durchgehen und **verdichten** statt aus dem
  Gedächtnis zusammentragen — gleiche Beobachtungen zusammenfassen und zählen,
  3× → Steering-Loop-Einträge, darunter → Beobachtungen unter Schwelle, Risiken
  mit Ausgang „weiter offen" ebenfalls dorthin.
- **Gegenzeiger von der Schreibseite** (Modul 5): ein Absatz *„Wer liest das?"*
  benennt die Verdichtung und begründet daraus die Pflicht zur *gleichbleibenden
  Bezeichnung* — zwei Namen für dieselbe Sache werden getrennt gezählt und
  erreichen die Schwelle nie.
- **Der Graph trägt die Kante jetzt beschriftet** (`Welle-Closure Schritt 3:
  Slice-Closures verdichten`) statt sie unbenannt zu zeichnen. Eine unbeschriftete
  Kante war genau die Stelle, an der der fehlende Schritt unsichtbar blieb.
- **Zustandsmaschine: `done` ist kein Endzustand der Information.**
  `done --> [*]` behauptete, die Geschichte des Slice ende dort — seit dem
  Lese-Schritt ist `done/` ein *deklarierter Eingang* der Welle-Closure. Das
  Diagramm trägt jetzt eine Notiz am Zustand `done`, die Prosa benennt beide
  Enden: `Slice angelegt` speist sich über §8 aus den offenen Beobachtungen der
  letzten Welle-Closure (bei BF/Hybrid), `done` liefert sie zurück. Der
  Slice-Lifecycle ist an beiden Enden an den Wellen-Zyklus gekoppelt — vorher
  sah er aus wie ein geschlossener Kreis für sich.

### Geändert

- **Modul 1 §Lebenszyklus als Diagramm: der Lerneintrag zeigte an den falschen
  Zielen.** Die Rückwärtskanten gingen nur nach `Spec` und `ADR` — der Kurs
  definiert aber **drei Formen** (*geschärfte Regel · neuer Sensor · benannte
  Spec-Lücke*), und nur die dritte landet in der Spec. Die beiden häufigeren
  gehen in die **verkörperte Form** (`AGENTS.md`, Gate, Skill) — genau die
  Artefakte, auf denen Welle 39 den Herkunfts-Anker aufgebaut hat. Das
  Einstiegs-Diagramm des Kurses ließ sie weg und damit auch die Rückkante, die
  erklärt, *warum* ein Lerneintrag wirkt: die verkörperte Form liegt in jedem
  Lauf-Kontext und beeinflusst den nächsten Code, ohne dass jemand ein Archiv
  liest. Neuer Knoten plus Kante `wirkt auf jeden Lauf` → `Code`; die Prosa
  benennt die drei Formen und verweist für Zähler und Herkunft auf Modul 6 und
  `konventionen.md`.
- **Graph in `konventionen.md` nachgeschärft:** der Verdichtungs-Schritt war nur
  ein *Kantenlabel* — in einem Graphen, dessen Prüffrage auf Knoten-Farben
  beruht (gelb = geschrieben, blau = liest), entzieht sich ein Lese-Schritt als
  Kante genau dieser Prüfung. Jetzt eigener blauer Knoten. Und der Startknoten
  hieß „Agentenlauf", obwohl auch **Review-Findings, Verifikation und
  Validierung** den Loop speisen (Modul 10 §Pflege: *„bei dreimaligem gleichem
  Finding Klassifikation schärfen"*) — heißt jetzt *Beobachtungs-Quellen* und
  nennt alle vier.

## Welle 40 — 2026-07-26 · Graph-Test auf den Bestand angewandt: §6 Risiken war write-only

Der Mermaid-Fluss aus Welle 39 stellt eine Prüffrage — *hat das gelbe Kästchen
ein blaues?* Auf zwei bestehende Sektionen angewandt, die noch nie geprüft
wurden. Ergebnis: eine ist harmlos, eine war der nächste write-only-Fall.

### Hinzugefügt

- **Modul 5 §Offene Risiken werden bei Closure aufgelöst.** `slice.template.md`
  §6 *Risiken und offene Punkte* hatte **null Konsumenten** — `kurs/` und
  `lab/regelwerk/` abgesucht, kein Schritt liest die Sektion. Nicht einmal der
  naheliegende: §7 Closure fragt *„Was ging anders als geplant?"*, ohne §6 je zu
  erwähnen. Und sie ist **nicht derivativ** — ein beim Schnitt notiertes Risiko
  ist Originalinformation, die nirgendwo sonst steht. Damit dieselbe Klasse wie
  der Steering-Loop-Eintrag vor Welle 38: sauber erhoben, nie gelesen.
  Jetzt bekommt jedes Risiko beim Übergang nach `done/` genau **einen** Ausgang
  — *eingetreten* → Carveout oder Folge-Slice mit ID · *entfallen* → gestrichen
  **mit Begründung** (ohne sie ist es stilles Vergessen) · *weiter offen* →
  wandert in *Beobachtungen unter Schwelle* der Welle-Closure. Der dritte
  Ausgang ist der tragende: er hängt das Risiko an den **Zähler aus Welle 38**,
  statt einen zweiten Mechanismus zu erfinden. Ein Risiko, das drei Slices lang
  offen bleibt, erreicht damit die Schwelle — statt dreimal unabhängig notiert
  und dreimal vergessen zu werden. Ein Slice geht nicht nach `done/`, während
  ein Risiko ohne Ausgang dasteht.
- **Folge-Slice-Paarung** als zweite deterministische Prüfung im Carveout-Audit
  (Modul 6 Schritt 2), neben der Anker-Paarung aus Welle 39: jeder in einer
  Closure-Notiz genannte Folge-Slice **existiert als Datei in `open/`**. Beide
  folgen demselben Muster — *Nennung ohne Deckung ist eine Harness-Lüge*.

### Geändert

- **§Folge-Slices als *derivativ* gekennzeichnet** (`welle-results.template.md`,
  `slice.template.md` §7, Modul 6). Sie ist **kein** write-only-Fall: der
  Folge-Slice selbst ist eine Datei in `open/` und wird vom normalen Lifecycle
  konsumiert; die Liste zeigt nur darauf. Die Klasse existierte im Repo bereits
  (ADR-Index, Carveout-Index sind so gelabelt), nur die Kennzeichnung fehlte —
  ohne sie schlägt der Graph-Test hier falschen Alarm.
- **Die Zustandsmaschine nachgezogen.** Der neue Ausgangs-Zwang sitzt am
  Übergang `in-progress → done` — und **fünf** Beschreibungen dieses Übergangs
  sagten weiter nur „DoD erfüllt + Lerneintrag": das Mermaid-Diagramm in Modul 5,
  die Prosa darunter, die Selbstcheck-Rubrik, beide Stellen im Regelwerk-Split
  und die DoD-Checkliste in `slice.template.md`. Das ist **Entgleisung #2 aus
  Worked Example B** (*„der Hook wird geschärft, die Doku bleibt auf dem Stand
  von vorher"*) — begangen zwei Wellen nach dem Aufschreiben, gefunden durch die
  Rückfrage „ist das noch aktuell?". Alle fünf tragen jetzt
  `DoD + Lerneintrag + Risiko-Ausgänge`.
- **Satelliten:** Regelwerk-Splits `modul-05` (Risiko-Auflösung) und `modul-06`
  (zweite Paarung, Derivativ-Label); `lab/example` zeigt beide Formen real —
  `slice-009` §6 mit zwei Ausgängen (einer *entfallen* mit Messwert, einer
  *weiter offen*), und der offene wandert nachvollziehbar in die
  Beobachtungen-Tabelle von `welle-1-results.md`.

## Welle 39 — 2026-07-26 · Herkunfts-Anker: Regeln nennen die Welle, aus der sie stammen

### Hinzugefügt

- **`konventionen.md` §Herkunfts-Anker für Steering-Loop-Regeln.** Welle 38 hat
  die Beobachtungen *unter* der Schwelle abfragbar gemacht; offen blieb die
  andere Hälfte: Eine **verkörperte** Regel (AGENTS-Hard-Rule, Gate,
  Skill-Eintrag) trägt ihre Begründung nicht bei sich. Von der Regel aus führte
  kein Weg zur auslösenden Beobachtung — und Worked Example B (Welle 35) sagt,
  was dann passiert: *„beim nächsten Aufräumen wirkt sie wie Overengineering und
  fliegt raus."* Der Anker ist **kein neues Konstrukt**, sondern der
  Traceability-Constraint angewandt auf das *Artefakt* statt auf den *Commit*:
  ein Feld `seit welle-<NN>` im Make-Target-Kommentar, an der Hard-Rule-Zeile
  bzw. am Skill-Eintrag. Der Adaptions-Block trug das Muster über sein Feld
  *Begründung* bereits — der Anker verallgemeinert es.
  **Geltungsbereich bewusst eng:** nur Regeln aus dem Steering Loop (3× erreicht);
  was aus Lastenheft/Spec/ADR folgt, trägt schon eine ID.
  **Ziel ist die Welle, nicht der Slice** — `done/welle-<NN>-results.md`
  §Steering-Loop-Einträge nennt seit Welle 38 das Trio *Regel · stabile
  Bezeichnung · Slice-Belege*, der Anker löst also in **einem Hop** auf und ist
  grob genug, um nicht zu verrotten. **Ab Einführung, kein Nachrüsten:**
  `seit unbekannt` wäre eine Harness-Lüge, der leere Zustand ist die ehrliche
  Information.
- **Zwei Sensoren.** *Anker-Paarung* (computational feedback): Die Prüfung läuft
  **von der Closure-Notiz nach außen**, nicht von der Regel nach innen — von der
  Regel aus ist nicht entscheidbar, ob sie einen Anker braucht, von der Closure
  aus schon. Pro Steering-Loop-Eintrag: Zielort genannt · Pfad existiert · Ziel
  trägt `seit welle-<NN>`. Rot bei: Regel nie geschrieben, still gelöscht, Anker
  vergessen — dieselbe Klasse wie ein *halluziniertes Gate*, auf Regeln statt auf
  Make-Targets angewandt; läuft im Carveout-Audit der Welle-Closure mit.
  Grenze ehrlich benannt: erzwingt den Anker nur für **deklarierte** Regeln.
  *Retirement-Check* (inferential, **ereignis**-getriggert, kein periodischer
  Sweep — der Kurs verbietet Kalender-Trigger): Eine Regel mit Anker wird nicht
  entfernt oder gelockert, ohne dass die Herkunft konsultiert wurde
  (*„seit welle-3 — ist die Beobachtung wieder aufgetreten?"*). Gleiche Bauart
  wie „Gates dürfen nicht ohne ADR gelockert werden". Er ist der **Konsument**
  des Ankers; ohne ihn wäre der Anker eine zweite write-only-Ablage — genau der
  Fehler, den Welle 38 behoben hat.
- **Mermaid-Fluss „jedes Artefakt hat einen Konsumenten".** Beide Schleifen in
  einem Bild: links der Zähler für Beobachtungen unter der Schwelle
  (Welle-Closure → Wellen-Eröffnung → Slice-Planung), rechts die verkörperte
  Regel mit Anker (Closure → Regel → Retirement-Check → Closure). Gelb = wird
  geschrieben, blau = liest. Als Prüffrage für künftige Erweiterungen
  formuliert: *hat das neue gelbe Kästchen ein blaues?* Hat es keines, ist es
  Ablage, keine Steuerung.

### Geändert

- **`welle-results.template.md`: Zielort wird Pflichtfeld** im
  Steering-Loop-Eintrag (bisher freie Prosa) — er ist die eine Hälfte der
  maschinell prüfbaren Paarung. Abgewogen gegen Modul 16 (*„eine Checkliste ohne
  Belege ist Bürokratie"*): gerechtfertigt, weil das Feld **der Beleg selbst**
  ist und nicht ein Häkchen daneben.
- **Anker-Form in den drei Regel-Klassen verankert** — Modul 13 (Gate-Target-
  Kommentar), Modul 9 (Hard-Rule-Zeile), Modul 10 (Skill-Eintrag), je als
  Ein-Satz-Verweis. Die Regel selbst steht **einmal** in `konventionen.md`, nicht
  viermal — sonst hätte dieselbe Regel vier Orte und exakt das Drift-Problem,
  das der Kurs bekämpft.
- **Satelliten:** Regelwerk-Splits `grundlagen-konventionen` (Anker
  `#herkunfts-anker`), `modul-06`, `modul-09`, `modul-10`, `modul-13`;
  `lab/example/…/welle-1-results.md` zeigt die Paarung jetzt real (Zielort +
  Slice-Belege je Eintrag) statt sie nur zu behaupten.

## Welle 38 — 2026-07-26 · Der Steering Loop bekommt seinen Zähler — und einen Konsumenten

### Hinzugefügt

- **Sektion „Beobachtungen unter Schwelle" in der Welle-Closure (Modul 6
  Schritt 3).** Befund: Der Steering Loop schreibt seine eigene Zählregel vor
  (*1× notieren · 2× Symptom · 3× Lücke*) und lieferte **keinen Zähler**.
  Verifiziert: **kein einziger Workflow-Schritt liest `done/`** — Modul 9
  (8-Schritt-Workflow), Modul 2 (Bootstrap) und Modul 5 (Planung) auf
  Lese-Zugriffe abgesucht, null Treffer; einziger „Konsument" war die
  Roadmap-Tabelle, und die nimmt nur den Zeiger. Das Steering-Loop-Wissen war
  damit **write-only**. Die Trennlinie, die den Fix zuschneidet: Beobachtungen
  **≥ 3×** sind bereits *verkörpert* (AGENTS-Regel, Gate, Skill) und wirken von
  selbst — die **< 3×** sind nirgends verkörpert und versickerten in der
  Closure-Prosa, sodass der Zähler mit jeder Welle bei null anfing. Ein Fehler
  einmal pro Welle wäre nach fünf Wellen eine 5×-Lücke, die niemand je als
  Lücke sieht. Die neue Sektion wird bei der nächsten Closure **übernommen und
  hochgezählt**, nicht neu geschrieben; bei 3× wandert der Eintrag in die
  Steering-Loop-Einträge und verlässt die Liste. Pflicht: **stabile
  Bezeichnung** über Wellen hinweg (sonst zählt man zwei Namen für dieselbe
  Sache getrennt) und **kein stilles Streichen** (wer streicht, begründet,
  warum die Beobachtung nicht mehr auftreten kann).
- **`welle-results.template.md` — die fehlende Ziel-Form.** `welle-NN-results.md`
  war der **einzige normierte Artefakttyp ohne Template**: Modul 6 normierte
  seinen Inhalt im Fließtext, das Beispiel setzte ihn um, ein Adopter musste
  die Struktur aus einem Prosa-Absatz rekonstruieren. Genau dort driftete auch
  der Dateiname (siehe unten) — wo keine Ziel-Form die Form hält, driftet sie
  zuerst. Trägt die sechs Pflichtteile plus die neue Sektion; `welle.template.md`
  §7 verweist darauf statt nur auf den Dateinamen. `templates/README.md`:
  16 → **17 Skelette**.
- **Wellen-Eröffnungs-Prozedur (Modul 6).** Tieferer Befund hinter dem
  write-only-Problem: **Closure war prozedural ausbuchstabiert (fünf Schritte),
  Eröffnung überhaupt nicht** — weder Modul 5 noch Modul 6 hatten eine
  Anlege-Schrittfolge. Deshalb hatte der Konsum-Schritt keinen Ort zum
  Andocken. Jetzt drei Schritte, deren mittlerer der ist, den Teams zuerst
  weglassen: *offene Beobachtungen der letzten Closure sichten*. Explizit
  abgegrenzt: `done/` kommt **nicht** in den Lauf-Kontext des
  Implementer-Agenten — das ist Planungs-Leistung, und was die Schwelle
  erreicht hat, wirkt ohnehin über die verkörperte Form (Modul-0-Prinzip).

### Geändert

- **Slice-Eröffnung konsumiert die Beobachtungen (Modul 5 + `slice.template.md`).**
  Der Konsum sitzt in Kriterium 3 der Sub-Area-Modus-Begründung
  (*Evidenz- und Diskrepanz-Risiko*) — **kein fünftes Kriterium**, weil die
  Quelle „vier Pflichtkriterien (vier, nicht erweitern)" sagt. Ein Eintrag, der
  eine Sub-Area schon zweimal getroffen hat, *ist* das Diskrepanz-Risiko, nach
  dem das Kriterium fragt. Im Template zusätzlich eine zweite
  „Vorgelagert"-Zeile parallel zur bestehenden Sub-Area-Wahl-Prüfung.
  Keine Treffer sind ebenfalls eine Antwort und werden notiert.
- **Dateiname vereinheitlicht: `welle-<NN>-results.md`.** Zwei Ausreißer gegen
  neun konsistente Stellen plus das reale Beispiel: `planning/README.template.md`
  sagte `done/<welle-id>-results.md` (ergäbe `welle-1-mvp-results.md`, weil die
  Welle-ID einen Slug trägt), `loesungen/modul-07` sagte `done/<welle>-results.md`.
  Die `<welle-id>`-Form stammt aus Welle 33 — dem Commit, der `done/` als Heimat
  für Nicht-Slice-Records benannte.
- **Satelliten mitgezogen:** Regelwerk-Splits `modul-05` (Beleg-Quelle in
  Kriterium 3) und `modul-06` (Eröffnungs-Prozedur, neue Sektion,
  Ziel-Form-Verweis); `lab/example/…/welle-1-results.md` trägt die neue Sektion
  mit zwei Beispiel-Einträgen, sonst widerspräche das Beispiel Modul 6.

## Welle 37 — 2026-07-26 · Templates verweisen auf die vendorte Baseline statt in den Kurs

### Geändert

- **Alle 42 Kurs-Verweise in `lab/templates` aufgelöst — das Bundle ist jetzt
  vollständig netzlos.** Nach Welle 35 (Regelwerk) blieb die zweite Hälfte:
  Templates zeigten durchgängig in den Kurs, obwohl der Adopter das Regelwerk
  **lokal** unter `.harness/baseline/<tag>/regelwerk/` vendored liegen hat. Das
  widersprach der eigenen `MR-003`-Begründung (Modul-0-Prinzip:
  *Per-Lauf-Relevantes gehört verkörpert, nicht extern nachgeladen*) — ein
  Kurs-Verweis heißt Netz, und zwar auch dort, wo der Inhalt zwei Verzeichnisse
  weiter liegt. Drei Klassen, drei Behandlungen:
  - **Löschbare Blöcke (10)** — Kopf-Hinweise („lösche diesen Block") und
    HTML-Kommentare. Sie werden nie mitkopiert, also greift die
    Kopier-Einschränkung gar nicht: relativer Link auf `../regelwerk/…`, der im
    Kurs-Repo (`lab/regelwerk`) *und* im Bundle (`regelwerk/` neben
    `templates/`) auflöst — dieselbe Doppel-Auflösung wie die
    `../templates/`-Ziel-Form-Verweise in der Gegenrichtung.
  - **Bleibender Inhalt (13)** — landet dauerhaft im Adopter-Repo, wo weder
    Pfadtiefe noch `<tag>` bekannt sind. Deshalb **Abschnitts-Zitat statt Link**:
    „Baseline-Regelwerk `grundlagen-konventionen.md` §Source Precedence". Ohne
    Pfad, ohne Tag; wo die Baseline liegt, steht beim Adopter genau einmal in
    `MR-003`. Ein Baseline-Upgrade berührt damit **eine** Datei statt dreizehn.
  - **`templates/README.md` (17)** — Index der Sammlung, wird nicht kopiert;
    relative Links, Spaltenkopf „Kurs-Verweis" → „Regelwerk-Abschnitt".
  Dazu eine **zweite Schicht von 13 Klartext-Nennungen ohne Link**
  („siehe Kurs Modul 4", „Kurs §Referenz-Richtung", „Kurs-Glossar"), die keine
  `kurs/de`-Suche findet — ebenfalls auf Regelwerk-Abschnitte umgestellt.
  **Stehen bleibt „Kurs"** nur noch als Name der Baseline-Quelle (11 Stellen:
  Baseline-Aufzählungen, „Kurs-Welle 24" als Stand-Beispiel, CHANGELOG im
  Kurs-Repo, `lab/example` als Vorbild-Zeiger).
  Empirisch gegengeprüft am simulierten Release-Bundle: **19 `regelwerk/`-Links
  lösen auf, 0 kaputt, 0 verbliebene Kurs-URLs**; die übrigen offenen Ziele sind
  die bekannte symbolische Klasse (`spec/lastenheft.md`, `CO-<NNN>-<titel>.md` …),
  die erst beim Ausfüllen entsteht.
- **`tools/rewrite-template-links.sh` und `.d-check.yml`: Kommentare ehrlich
  gemacht.** Beide beschrieben den alten Zustand („Quelle behält relative
  `../../kurs/`-Links", „Verweise in den Kurs … werden beim Release gepinnt").
  Die kurs-`sed` ist jetzt im Normalfall ein No-op und bleibt als **Sicherheitsnetz**
  deklariert; `ignore-refs` prüft ab jetzt `../regelwerk/`-Anker scharf — eine
  umbenannte Regelwerk-Überschrift verschickt sonst unbemerkt einen toten Anker
  ins Adopter-Repo.

## Welle 36 — 2026-07-26 · Artefaktklasse pro Rolle: sechs Rollen sind nicht sechs Skills

### Hinzugefügt

- **Modul 8 §Welche Rolle braucht welche Artefaktklasse.** `lab/templates/.harness/skills`
  enthält zwei Skill-Templates, der Kurs nennt sechs Rollen — die Asymmetrie war
  **deklariert, aber unbegründet**, und las sich dadurch als Rückstand. Modul 8
  §Lab-Bezug sagte *„Das Lab enthält **keine** Skill-Dateien pro Rolle"*, und der
  Reflexions-Trigger schlug ausgerechnet *„Skill-Datei pro Rolle?"* vor — ein
  Adopter baut daraufhin vier Attrappen. Jetzt steht das Kriterium explizit, und
  es ist aus Modul 10 abgeleitet, nicht neu erfunden: **eine Rolle braucht genau
  dann eine Skill-Datei, wenn ihr Urteil *inferential* ist UND auf
  repo-spezifischem Wissen beruht, das aus keinem Artefakt ableitbar ist.**
  Zuordnung: Planner/Architect → **Template** (Slice, Roadmap, ADR);
  Implementation → **Briefing** (`AGENTS.md` + 8-Schritt-Workflow); Reviewer →
  **Skill-Datei** (HIGH-Liste steht in keiner Spec, `inferential feedback` driftet);
  Verifier/Validator → **keins** (Prüfgrundlage reist im Slice mit bzw. liegt
  außerhalb des Repos). Zusatz: **Skills wachsen pro Urteilstyp, nicht pro Rolle**
  — `closure-note-reviewer.md` (Modul 11) ist dieselbe Rolle mit anderem
  Urteilstyp, keine siebte Rolle. **Kein neues Template**: vier weitere
  Skill-Dateien trügen keinen nicht-ableitbaren Inhalt.

### Geändert

- **Drei Stellen, die „eine Skill-Datei pro Rolle" nahelegten, geschärft.**
  Modul 8 §Lab-Grenze von *„enthält keine"* auf *„braucht keine, weil…"*
  umformuliert (die *echte* Grenze — kein Replay eines kompletten
  Rollendurchlaufs — bleibt separat stehen); Reflexions-Trigger von
  *„Skill-Datei pro Rolle?"* auf *„ist ein neuer Urteilstyp entstanden, der
  driftet?"*; Fehlvorstellung „Eine Person spielt alle Rollen" von
  *„unterschiedlichen Skill-Dateien"* auf *„der je passenden Artefaktklasse"*
  (auch in `loesungen/modul-08` und im Regelwerk-Split). Regelwerk-Split
  `modul-08` trägt die operative Fassung mit stabilem Anker
  `#artefaktklasse-pro-rolle` und Ziel-Form-Verweis auf
  `../templates/.harness/skills/reviewer.template.md`.

## Welle 35 — 2026-07-26 · Guard-Härtung als Worked Example; Regelwerk-Deixis umgehängt

### Hinzugefügt

- **Modul 13 §Worked Example B — „Guard-Härtung als Steering-Loop am Wächter".**
  Schließt den seit Einführung der Durchsetzungsschicht offenen „(folgt)"-Verweis
  (`grundlagen/durchsetzungsschicht.md` §Die Schicht wird selbst gesteuert). Zwei
  Wellen an einem Befehls-Guard: Welle 1 (`MR-004`, Befehlspositions-Denylist nach
  3× direktem `pytest`-Aufruf), Welle 2 (`MR-005`, rekursives Auspacken der
  `-c`-Payloads inkl. `-lc`/`-ec`, fail-closed über Tiefenlimit) — je mit
  Beobachtungs-Beleg aus Lerneinträgen, *verworfener* Alternative (`bash` auf die
  Denylist: ein abgeschalteter Wächter ist schlechter als ein löchriger) und
  Landung als **neuer** `MR`, nie als Edit am akzeptierten Eintrag. Wellen-Tabelle
  mit bewusst leerer Zeile 3 („die nächste Welle wird beobachtet, nicht geplant"),
  drei Entgleisungen, und die Abgrenzung Gate (prüft ein *Ergebnis*, computational
  feedback) vs. Wächter (verhindert eine *Handlung*, computational feedforward) —
  deshalb steht der Guard bewusst **nicht** in §Gate-Typ ↔ Fehlerbild. Das
  bestehende Worked Example heißt jetzt **A** (Anker `worked-example-a-…`,
  3 Verweise in Modul 4 nachgezogen). Neue Analysieren-Übung (Welle 3 schreiben:
  Beleg → Abwägung → neue Grenz-Zeile) + Lösungshinweis, Reflexions-Trigger
  ergänzt. Die `Grenze:`-Zeile im `MR`-Block ist explizit als **repo-lokales
  Zusatzfeld** ausgewiesen — die Pflichtfelder des Adaptions-Blocks bleiben
  unangetastet, kein Template-Eingriff. Regelwerk-Split `modul-13` trägt die
  operative Fassung (`§Guard-Härtung`, stabiler Anker `#guard-haertung`), beide
  „(folgt)"-Enden geschlossen.

### Geändert

- **`lab/regelwerk`: Selbstverweise auf „Kurs" auf das Regelwerk umgehängt.** Sieben
  Stellen sagten im vendorten Betriebsregelwerk „in diesem Kurs" / „Bedeutung im
  Kurs" / „Kurs-Glossar" / „pro Kurs-Phase" — ein Referent, der im Adopter-Repo
  ins Leere zeigt (`grundlagen-konventionen` ×3, `grundlagen-klassifikation`,
  `modul-04`, `modul-14`, `modul-16`). Das ist **keine** Verletzung der
  Quelltreue-Regel, sondern dieselbe Operation, die beim Split ohnehin passiert:
  relative Links werden umgehängt, Deixis genauso — der Satz behält seine Aussage,
  nur sein Referent wandert mit dem Text. **Stehen bleibt „Kurs", wo es die
  Baseline-*Quelle* benennt** (Baseline-Aufzählungen in `modul-01`/`konventionen`,
  „neues Kurs-Release" als Drift-Trigger in `modul-02`, Baseline-Auswahl
  `modul-02` §Schritt 1, sowie das gesamte README: Framing, Stand-Zeile,
  Normativitäts-Klausel, Lizenz). Zusätzlich ein Didaktik-Rest entfernt
  (`grundlagen-klassifikation`: „…warum Replay und Golden Sets im Kurs ein eigenes
  Modul bekommen" — eine Aussage über den *Kursaufbau*, die nach der Weglass-Regel
  nicht ins Regelwerk gehört). Die Transformationsregel steht als eine Klausel im
  README-Extrakt-Satz, nicht als eigener Absatz: sie ist eine Maintainer-Regel für
  die *Herstellung* des Splits, und das README reist im Bundle zum Adopter mit.
  **Keine `kurs/`-Änderung** — die Quelle ist ein Kurs und sagt zu Recht „in diesem
  Kurs". `make check` grün (d-check 0 Befunde, docs 0/0, alignment 0 WARN).
- **`lab/regelwerk` verweist nicht mehr auf Kurs-Material — 14 Auswärts-Links
  aufgelöst.** Zweite Leck-Klasse an derselben Wurzel: Verweise aus dem netzlos
  ausgelieferten Bundle auf Dateien, die *nicht* mitreisen (`fallstudien.md`,
  `quellen.md`, `reflexion-vorlage.md`, `lernervorstellungen.md` liegen nicht in
  `lab/templates/`). Die betroffenen Ziele tragen **keine Regel**: Fallstudien
  sind vier konkrete Repos mit Stand-Momentaufnahme („Stand 2026-06") und einer
  Spalte *„Was der Kurs daraus zieht"*, `quellen.md` ist ein Literaturverzeichnis
  mit eigenem Abschnitt *„Didaktische Quellen"*, `reflexion-vorlage.md` eine
  Vorlage für Kurs-*Übungen*. Alle 14 Verweise standen in Beleg-Klammern; die
  tragenden Sätze bleiben wortgleich stehen (Beispiel: „Ein reifes Repo (Beispiel
  `pt9912/grid-gym`, siehe fallstudien.md) hat…" → „Ein reifes Repo (Beispiel
  `pt9912/grid-gym`) hat…"). Betroffen: 8× `fallstudien.md`, 2× `quellen.md`,
  1× `reflexion-vorlage.md`, 1× `lernervorstellungen.md`; dazu `modul-08`, dessen
  Steering-Loop-Verweis auf die **in-Bundle** stehende 1×/2×/3×-Regel in
  `grundlagen-klassifikation.md` §Steering Loop umgehängt wurde. Dazu die README
  selbst: ihr Absatz „Vendored gelesen?" — die Anrede an den Adopter, der das
  Bundle netzlos liest — schickte für *„Vorgehen beim Bootstrap"* nach draußen in
  den Kurs, obwohl `modul-02-harness-bootstrap.md` im Bundle liegt; auf den Split
  umgehängt. **Genau ein** Auswärts-Link bleibt: die Normativitäts-Klausel
  („maßgeblich für den Inhalt bleibt der Kurs unter `/kurs/de/`") — dort *ist* der
  Sprung nach draußen der Zweck. Alles andere im Regelwerk ist netzlos.
- **`konventionen.md`: neue `### Einführungs-Reihenfolge über mehrere Repos`.**
  Beim Entfernen der Fallstudien-Verweise fiel auf, dass `fallstudien.md`
  **gemischt** ist: neben Fallbeispielen trug sie eine echte Betriebsregel
  („Beginne immer beim Referenz-Repo, portiere erst nach erfolgreicher
  Steering-Loop-Iteration auf die Flagships; alle Repos parallel mit demselben
  Master-Prompt zu treiben skaliert nicht"), die **nirgends sonst stand** —
  verifiziert gegen Regelwerk *und* `konventionen.md`. Eine allgemeine Regel auf
  einer Fallbeispiel-Seite ist eine Quell-Fehlablage, deshalb Fix-Richtung
  **Quelle**: die Regel wandert wortgleich (plus Begründung aus §Konsequenzen pro
  Klasse) nach `konventionen.md` §Harness-Bootstrap; `fallstudien.md` behält den
  Absatz als Kontext-Hinweis mit Pointer, normativ ist ab jetzt der
  Konventions-Text. Damit trägt der Split `grundlagen-konventionen` die Regel
  quell-verankert — sie verschwindet nicht mit den Fallstudien-Verweisen. Die
  §Repo-Klassen-Hälfte brauchte keinen Umzug: sie steht als Kernbegriff und in
  den Source-Precedence-Konsequenzen bereits im Regelwerk.

## Welle 34 — 2026-07-24 · Change-Request-Landing-Disziplin: Fußabdruck statt Konstrukt

### Geändert

- **`konventionen.md` §Spec-Stratifizierung: „Change Request" als externer
  Prozess eingeordnet, nicht als Konstrukt.** Der Kurs benannte CR bisher nur
  als Änderungs-Prozess-Label des Vertrags-Stratums, ohne zu sagen, was er
  *ist* und was er im Repo hinterlässt — jedes adoptierende Repo hätte das
  anders gelöst (eigenes CR-Template? `spec/change-requests/`? Version-Bump
  ja/nein?). Ein Absatz nach der Hard Rule stellt klar: CR ist **bewusst kein
  Harness-Konstrukt** (kein `CR-*`-ID-Schema, keine Datei, kein Gate), sondern
  der externe Vorgang der Vertragsänderung mit dem Auftraggeber. In-Repo-
  Fußabdruck eines *angenommenen* CR = Version-Bump des Lastenhefts +
  Historie-Zeile mit CR-Verweis + geänderte `LH-*`/`HSM-*`;
  abgelehnte/schwebende CRs leben außerhalb. Die Hard Rule „ADR darf `LH-*` nie
  schärfen" wird explizit auf Slice ausgedehnt (über den SDP-Stabilitäts-Rang
  Vertrag › ADR › Slice bereits implizit). Verworfen: ein eigenes CR-Konstrukt
  (wäre ein viertes Änderungsmuster neben MR/ADR/supersede und bräche mit „ADR
  schärft das Lastenheft nicht") — die gewählte Option „Landing-Disziplin
  schärfen" ehrt Quelle-ist-Anker. Regelwerk-Split `grundlagen-konventionen`
  wortgleich mitgezogen; `lab/templates/spec/lastenheft.template.md` Historie-
  Kommentar schärft den Fußabdruck. `make check` grün (docs 0/0, alignment
  0 WARN). Auslöser: Adopter-Frage „brauchen wir ein CR-Template, sonst macht
  es jedes Zielprojekt anders?".

## Welle 33 — 2026-07-23 · README-Template: `done/` als Heimat abgeschlossener Nicht-Slice-Records ehrlich benennen

### Geändert

- **`planning/README.template.md`: „slice-reserviert"-Überbehauptung korrigiert.**
  Der Block „Slices vs. Wellen" behauptete pauschal „die Lifecycle-Verzeichnisse
  sind **slice-reserviert**" und legte zugleich `welle-<id>-results.md` (ein
  Nicht-Slice-Record) in `done/` — ein Widerspruch im selben Absatz. Jetzt
  getrennt: der aktive Durchlauf `open/` → `next/` → `in-progress/` nimmt
  ausschließlich Slices auf; `done/` archiviert zusätzlich abgeschlossene
  **Nicht-Slice-Records** (Welle-Closure `done/<welle-id>-results.md`; aufgelöste
  Carveouts, Modul 7). **Template-Drift-Korrektur:** „slice-reserviert" stand nur
  im Template, die Quelle (Modul 6 §Welle-Closure: aktive Welle flach, geschlossene
  → `done/` per `git mv`) war korrekt — Fix-Richtung Template→Quelle, **kein**
  `kurs/`-Eingriff, keine Lehre berührt. Auslöser: m-trace-Planning-Layout-Audit,
  bei dem Nicht-Slice-Register mangels sanktioniertem flachem Ort in ein
  Lifecycle-Verzeichnis gezwängt wurden. Die weitergehende Frage (eigener Kanal
  für Discovery-/Kandidaten-Register) ist bewusst **vertagt**, bis ein zweites
  Konsument-Repo denselben Druck unabhängig zeigt.

## Welle 32 — 2026-07-19 · regelwerk-drift-Sensor retired; d-check sources im Freshness-Audit eingeordnet

### Entfernt

- **`check_regelwerk_drift.py` + `make regelwerk-drift`** aus `lab/example`. Der
  Sensor war ein Asset-/Content-Hash-Vergleich — genau die Methode, die Modul 2
  §Freshness-Audit als unzureichend markiert („der Hash des gepinnten Assets fängt
  nur ein nachträglich verändertes Release, nicht einen neuen Tag") — und seit dem
  Split-Verzeichnis (Welle 24) ohnehin ein No-op. `conventions.md` §Baseline von
  „ausstehend/übersprungen" auf einen ehrlichen Verweis umgeschrieben: das
  In-Repo-Beispiel ist selbst am Kurs-Stand; die Upstream-Freshness-Frage
  (Release-Listen-Prüfung) stellt sich erst im adoptierenden Fremd-Repo.

### Geändert

- **Modul 2 §Freshness-Audit: d-check `sources` (v0.51.0) eingeordnet.** Ein
  präziser Satz: `sources` automatisiert die *Asset-/Integritäts*-Hälfte
  (`source-pin`/`source-drift`), ersetzt aber die Release-Listen-Prüfung nicht —
  klärt die Verwechslung „sources = Freshness-Audit". Regelwerk-Split `modul-02`
  quelltreu mitgezogen.
- **d-check-Pin v0.51.0 → v0.51.1** (Fragment regeneriert). PATCH: dpin-Befund
  führt jetzt den vollen `sha256` (pins-Ergonomie); verhaltensneutral, `make check`
  unverändert grün. Kurs-intern.

## Welle 31 — 2026-07-19 · lab/templates im Referenz-Gate (scoped ignore-refs) + d-check v0.51.0

### Geändert

- **`lab/templates` steht jetzt im Referenz-Gate.** Das Verzeichnis mischt
  symbolische Ziel-Repo-Pfade (lösen erst nach dem Ausfüllen auf) mit prüfbaren
  Verweisen — 39 Kurs-Links (inkl. Anker) und template-interne Navigation. Bisher
  opferte `scan.ignore` die zweite Klasse komplett: die beim Release auf
  `blob/<tag>/` eingefrorenen Kurs-Verweise waren ungeprüft (eine umbenannte
  Kurs-Überschrift verschickte unbemerkt einen toten Anker). Ersetzt durch scoped
  `ignore-refs` (top-level `in`/`refs`/`keep`, d-check v0.49.0+): die 42
  symbolischen Refs (37 links, 5 codepaths) bleiben ignoriert, der Rest wird scharf
  geprüft (`ignoriert ⇔ refs ∧ ¬keep`, `keep` reihenfolge-unabhängig). Damit ist
  `lab/templates` dauerhaft Teil von `make check`.
- **d-check-Pin v0.47.0 → v0.51.0** (Fragment via `--print-mk` regeneriert). Liefert
  das `ignore-refs`-`in`/`keep`-Feature (v0.49.0, Grundlage der Adoption) sowie die
  neuen opt-in-Module `citations`/`codepaths.check-lines` (v0.50.0) und `sources`
  (v0.51.0, Content-Pin externer Quellen gegen Upstream-Drift) — verfügbar, aber
  nicht aktiviert (`make check` verhaltensneutral grün). Kurs-intern: Fragment + Pin
  reisen auf `main` mit, sind nicht im Bundle.
- **Regelwerk-Anzeigetext auf `templates/`-Präfix vereinheitlicht.** Der sichtbare
  Linktext der Ziel-Form-Verweise zeigte bare Spiegel-Pfade
  (`docs/plan/planning/roadmap.template.md`) — das las sich wie eine Vorlage an
  einem `docs/`-Pfad, wo weder Kurs noch Adopter eine hält. Anzeigetext auf
  `templates/…` präfixiert (href unverändert), 10 Stellen; bundle-korrekt.

## Welle 30 — 2026-07-18 · Wellen zweistufig (flach → `done/`), Status-Feld retired

### Geändert

- **Welle-Zustand = Verzeichnis-Position, kein `Status`-Feld** — analog zum Slice
  (Welle 26). Die aktive Welle liegt flach unter `docs/plan/planning/`; bei
  Closure `git mv` der Plan-Datei nach `done/` (neben ihre `-results.md`). Zwei
  Zustände (flach = aktiv → `done/` = geschlossen) statt eines driftbaren Felds;
  die Roadmap (`Aktuelle`/`Nächste`/`Abgeschlossene Wellen`) bleibt die
  Sequenzierungs-Autorität — **kein** Vier-Zustands-Verzeichnis, das die
  Roadmap-Reihenfolge dupliziert. Löst zwei Probleme: abgeschlossene Wellen
  müllten den flachen `planning/`-Ordner zu, und das `Status`-Feld war dieselbe
  zweite, driftbare Wahrheit, die beim Slice retired wurde.
- `welle.template`: `**Status:**`-Feld → `**Lifecycle:**`-Hinweis; zusätzlich die
  **Slice-Status-Spalte** aus der §4-Tabelle entfernt (gleiche Drift-Klasse — der
  Slice-Zustand ist sein Lifecycle-Verzeichnis, nicht eine Tabellen-Zelle).
- `modul-06` (Kurs-Anker + Regelwerk-Split): Closure-Schritt 3 → „**Welle nach
  `done/` schließen**" (Ergebnis-Notiz **und** `git mv` der Plan-Datei); die Prosa
  verankert das Zwei-Zustands-Modell und die Roadmap als Reihenfolge-Autorität.
  Fünf-Schritte-Prozedur unverändert (git mv in Schritt 3 integriert).

## Welle 29 — 2026-07-18 · d-check-Gate-Fragment tool-generiert (include-Modell) + `--network none`

### Geändert

- **Doku-Gate-Fragment tool-generiert statt handgeschrieben.** Die Template-`Makefile`
  empfahl bereits `d-check --print-mk`, lieferte aber die handgepflegte Recipe, die
  das Tool längst überholt hatte (`--network none`, `DCHECK_DIGEST`-Override, neues
  Target-Set) — aufgedeckt durch einen Adopter (`ai-harness-init` `MR-010`). Umgestellt
  auf das **include-Modell**: das Fragment `d-check.mk` wird via `d-check --print-mk`
  erzeugt und per `include`/`-include` eingebunden; die Recipe-Form lebt in d-check,
  nichts driftet von Hand. Effekte: `--network none` auf jedem Run (LH-QA-01-Hermetik
  auf Container-Ebene, die der Kurs lehrte, aber am eigenen Gate nicht erzwang),
  `DCHECK_DIGEST`-Re-Pin (statt Digest-Chirurgie), volles Target-Set present-but-unclaimed.
- **d-check-Pin v0.43.1 → v0.47.0** (via `DCHECK_DIGEST`). Trockenlauf vorab: 139
  Dateien, 0 Befunde, verhaltensidentisch — der Kurs enthält keine der Muster, die
  v0.47.0 neu sichtbar macht (keine `| - |`-Trennzellen, keine Fence-Infozeilen mit
  Backtick).
- **Modul 13 — „Vorhanden ≠ behauptet".** Schärft „keine halluzinierten Gates": ein
  vorhandenes, nicht als Gate *behauptetes* Target (die advisory `doc-*`-Targets des
  Fragments, wie `regelwerk-check`) ist keine Lüge; nur ein behauptetes, nicht
  laufendes Gate ist eine.

### Geändert — Auslieferung (Bootstrap)

- **Das Gate-Fragment und der Pin sind tool-/versionsspezifisch → NICHT im Bundle.**
  Der Adopter erzeugt `d-check.mk` beim Bootstrap aus *seiner* gepinnten d-check
  (`d-check --print-mk`) und füllt den `DCHECK_DIGEST`-**Platzhalter** der Template-
  `Makefile` (Modul 2, Kurs + Regelwerk-Split lehren das). Das Bundle trägt nur
  versions-agnostischen Inhalt; keine Release-Ableitung, kein committetes Duplikat.

### Behoben

- Review-Pass (high effort) vor dem Commit: `d-check.mk`-Staging (harter `include`),
  Prosa-Zeilenlänge (Regelwerk-Modul-2), `include`→`-include`-Präzisierung (Modul 13).

**Hinweis für Konsumenten (kein Bruch nach Asset/Layout-Policy):** Die ausgelieferte
Template-`Makefile` ist jetzt ein Skelett mit `DCHECK_DIGEST`-Platzhalter und
`-include d-check.mk`; sie läuft nicht mehr out-of-box, sondern nach der
Bootstrap-Erzeugung von `d-check.mk`. Bundle-Layout und Asset-Name unverändert;
existierende Adopter-Repos bleiben unberührt.

## Welle 28 — 2026-07-18 · Instanziierungs-Zeitpunkt der Templates explizit (Modul 2)

### Hinzugefügt

- **Anmerkung zum Instanziierungs-Zeitpunkt an Modul-2-Schritt 2** (Kurs +
  Regelwerk-Split). Der Kurs sagte den Zeitpunkt der Skelett-Instanziierung
  bisher nur *strukturell* (Bootstrap-Tabelle listet Gründungs-Dokumente;
  „Bootstrap-Ende = bereit für ersten Slice"), nicht *explizit am
  Instruktions-Punkt*. Diese Lücke verleitete einen Adopter (`ai-harness-init`)
  dazu, alle Templates beim Bootstrap als `docs/…/*.template.md`-Blanks zu
  bevorraten — reine Wartungskosten, später per dessen `MR-008` wieder entfernt.
  Neue Anmerkung trennt jetzt explizit: **Gründungs-Dokumente** (je ein
  Singleton, beim Bootstrap instanziiert und gefüllt: Spec-Straten,
  `conventions`, `harness/README`, `AGENTS`, `roadmap`, Gründungs-ADR `0001`)
  gegen **wiederkehrende Artefakte** (`slice`, `welle`, weitere ADRs, `carveout`,
  `review-report` — pro Instanz aus der vendored Baseline kopiert, wenn der
  Workflow sie erreicht; keine Blank-Kopie vorhalten). Die ADR-Doppelnatur
  (`0001` beim Bootstrap, weitere wiederkehrend) ist explizit gemacht.
- **Review-verifiziert (high effort).** Vor dem Commit fing ein Diff-Review
  einen Faktenfehler (Repo-`README` fälschlich als Bootstrap-Gründung gelistet,
  obwohl in keinem Bootstrap-Schritt) plus drei Präzisierungen (ADR-Bereich
  `Modul 4–10` statt `5–10`; Skelette in Schritt 2 kopiert, in 3–8 gefüllt;
  Regelwerk-Split operativ an den Kurs angeglichen).

## Welle 27 — 2026-07-18 · Baseline-Freshness-Audit prozeduralisiert (Modul 2)

### Hinzugefügt

- **Freshness-Audit als Erweiterung der Modul-2-Baseline-Anmerkung.** Vendoring
  friert per Konstruktion eine Kopie ein, die still von Upstream driftet, sobald
  ein neues Kurs-Release erscheint. Der Kurs benannte die Gegenmaßnahme bisher
  nur als Listen-Phrase („Drift-Audit gegen die Baseline", `AGENTS.template.md`)
  und prozeduralisierte sie nirgends — Modul 16 leer dazu, Modul 2 nur das Warum
  des Vendorings. Neuer Absatz in `modul-02-harness-bootstrap.md` (Regelwerk-Split
  operativ mitgezogen) mit drei Eigenschaften: **beobachtbarer Auslöser** (keine
  Kalenderpflicht), **Netz-Operation außerhalb der Gates** (offline-grün bleibt
  unverletzt) und der nicht-offensichtliche Kern — die Release-**Liste** auf einen
  neueren Tag prüfen, **nicht** nur den Hash des gepinnten Assets (der fängt nur
  ein nachträglich verändertes Release, keinen neuen Tag). Ein neuer Tag löst
  einen Review mit eigenem Diff aus, keinen stillen Auto-Bump. An die kurs-eigene
  „pinnen **und** überwachen"-Doktrin (Modul 12 `image_hash`, Modul 14
  „unsichtbarste Drift") und an LZ 5 (aktives Überwachen) gekoppelt.
- **Anlass:** Adopter-Beobachtung, gegen `v3.1.0` auditiert. Ein Adopter
  (`ai-harness-init`, `MR-007`) dokumentiert die Lücke selbst als „offene Lücke,
  kein gelöstes Problem" — sein Sensor meldete „kein Drift" auf einem alten Pin,
  während zwei Major-Releases erschienen. Kurs-seitig verifiziert: Modul 16 ohne
  Baseline-Wartung, Modul 2 ohne Release-Erkennung. Der Kurs schreibt das
  Ergebnis (Prozedur) vor, keine Repo-Mechanik (kein Tool-/Target-Name).

## Welle 26 — 2026-07-17 · Slice-Zustand einwertig (Lifecycle-Verzeichnis), Baseline-Bundle von innen self-beschreibend

### Geändert

- **Slice-Status-Feld retired — das Lifecycle-Verzeichnis ist die Quelle.**
  Modul 5 definiert den Slice-Zustand ausschließlich als Verzeichnis (eines von
  `open/`, `next/`, `in-progress/`, `done/`); das `Status:`-Feld im
  `slice.template.md` hatte keine Quell-Verankerung und war eine zweite Wahrheit,
  die beim `git mv` driftet — ein Slice in `done/` mit `Status: open` ist genau
  der Zombie, den Modul 5 beklagt. Feld → **`Lifecycle:`**-Hinweis (Zustand =
  Verzeichnis, Wechsel nur per `git mv`); §4 Trigger benennt jetzt auch die zwei
  Rückführungen (`in-progress`→`next` zu groß, `in-progress`→`open` blockiert),
  verankert an §Lifecycle als State Machine. `welle.template.md`: Slice-Status-
  Zelle als `<einer von: …>` statt Slash-Liste (die Pfeilkette las sich als
  Ablauf statt als Auswahl); das *Welle*-Status-Feld bleibt — Wellen liegen flach
  ohne Lifecycle-Verzeichnis, dort trägt das Feld die Wahrheit. `lab/example/slice-014`
  nachgezogen. Fix-Richtung Quelle → Template → Beispiel; Modul 5 unberührt.
- **Modul 07 §Übungen — Pflichtfeld-Liste an Schritt 2 und Template angeglichen.**
  Die Übung nannte sechs Pflichtfelder inklusive `Auflösungs-Trigger` und ohne
  `Letzte Prüfung`; kanonisch sind sechs Pflicht-*Header*-Felder (Status, Datum
  angelegt, Letzte Prüfung, betroffenes Gate, Geltungsbereich, Folge-Slice) plus
  der Auflösungs-Trigger als eigener beobachtbarer Bestandteil.
- **`lab/regelwerk/README.md` beschreibt seinen Vendoring-Kontext selbst.** Wer
  das Regelwerk aus dem entpackten Bundle liest statt über das Kurs-README, fand
  keinen Hinweis darauf, worin die Datei liegt: neuer Absatz „Vendored gelesen?"
  — `regelwerk/` + `templates/` parallel unter `.harness/baseline/<tag>/`, daher
  netzlos auflösende `../templates/…`-Ziel-Form-Verweise; Einstieg ist `AGENTS.md`
  des Adopter-Repos, hierher wird pro Entscheidung nur der benötigte Abschnitt
  geladen. Damit ist der Bootstrap-Pfad auch von innen navigierbar, nicht nur vom
  Kurs-README aus. Zugleich der „Links."-Absatz korrigiert: er nannte Templates
  und Beispiel als beim Release gepinnt — seit Welle 25 hält
  `--keep-within=lab/templates` die Templates-Verweise relativ, und `lab/example`
  verlinkt das Regelwerk gar nicht (36× `../../kurs/`, 16× `../templates/`).

## Welle 25 — 2026-07-16 · Regelwerk agenten-tauglich (Ziel-Form statt Worked Examples) + self-contained Baseline-Bundle

### Geändert

- **Didaktik-Compliance der Regelwerk-Splits.** Das Regelwerk ist für Code-
  Agenten: **Regel + Ziel-Form** statt erzählter Worked-Example-Narrative. Über
  17 Dateien die Schritt-für-Schritt-Beispiele entfernt (netto −1045 Zeilen).
  Skelett, das ein `lab/templates`-Artefakt dupliziert → „Ziel-Form: X" = Verweis
  auf `../templates/…` + operative Kurzregeln (modul-03/04/05/06/07/10); kein
  Template (Code/Config/Prozess) → operative Regeln + Tabellen behalten
  (modul-08/11/12/14/16). modul-02: Worked Example 1/2 → operative Bootstrap-
  Schritt-Sequenzen (Mermaids + T1/T2-Markdown-Beispiele gestrippt; Detail-
  Tabellen, vendored-Baseline-Doktrin, Phasen×Modus-Matrix behalten).
- **Stabile HTML-Anker** (`<a id>`, von d-check erkannt) für viel-referenzierte
  Stellen: modul-07 `#werkzeug-wahl` (5 Verweise), modul-13
  `#adr-zur-fitness-function`, modul-01 `#source-precedence-block`; ~11
  eingehende Verweise umgebogen. modul-07 review-verifiziert.
- **Baseline vendored jetzt Regelwerk *und* Templates.** modul-02-Bootstrap
  (Quelle + Split): `.harness/baseline/<tag>/{regelwerk,templates}/` — Templates
  mit Doppelrolle (vendored Referenz-Form für die `../templates/`-Ziel-Form-
  Verweise + kopiert-und-ausgefüllt als eigene Artefakte). Adopter-Story
  (conventions.template `MR-003`, AGENTS.template, README.template, lab/example)
  durchgängig nachgezogen.
- **`lab-regelwerk.zip` ist ein self-contained Baseline-Bundle** (`regelwerk/` +
  `templates/` parallel). `templates-release.yml` packt beide; die Splits lösen
  `../templates/` netzlos gegen `templates/` auf.

### Hinzugefügt

- **`rewrite-doc-links.py --keep-within=<dir>`** — zusätzliche within-Bundle-
  Wurzel neben `--keep-within-src`, damit `../templates/`-Verweise in
  self-contained Bundles mit mehreren parallelen Verzeichnissen relativ mitreisen
  (netzlos auflösbar) statt auf eine blob-URL gepinnt zu werden; nur echte
  Außen-Verweise (Kurs, LICENSE) werden auf den Tag gepinnt.

### Entfernt

- **Release-Asset `lab-templates.zip`.** Die Templates liegen jetzt im
  self-contained `lab-regelwerk.zip` unter `templates/`; ein separates
  Template-ZIP wäre ein Duplikat. Wer nur die Skelette will, entpackt das Bundle
  und nimmt `templates/`. `README`, `lab/templates/README`,
  `rewrite-template-links.sh` und `templates-release.yml` entsprechend bereinigt.
  (Das `templates-zip`-Vorschau-Artifact auf `main` bleibt für Template-Autoren.)

**Bruch für Konsumenten:** (1) Das `lab-regelwerk.zip` wechselt vom flachen
Layout (`*.md` im Root, v2.0.0) auf `regelwerk/` + `templates/` parallel — nach
`.harness/baseline/<tag>/` entpacken (nicht mehr nach `…/regelwerk/`), dann lösen
die `../templates/`-Ziel-Form-Verweise netzlos auf. (2) Das Release-Asset
`lab-templates.zip` entfällt; Ersatz ist `templates/` im Baseline-Bundle. Der
Kurs-*Inhalt* bleibt maßgeblich unter `/kurs/de/`.

## Welle 24 — 2026-07-16 · Regelwerk konsumenten-sauber (A⁺), agents-regelwerk.md retired, d-check v0.43.1

### Geändert

- **Regelwerk-Splits von der Demo-App befreit (A⁺).** Das ausgelieferte
  `lab-regelwerk.zip` enthält nur `lab/regelwerk/*.md`, kein `lab/example` —
  DocSearch-/Lab-Referenzen im Split waren toter Ballast. modul-06 Worked
  Example → generisches Roadmap-Skelett; acht weitere Splits genericisiert
  (modul-02/07/10/12/14/16, grundlagen-konventionen/-klassifikation).
- **Modul 6 (Roadmap):** die Template-Abschnitte *Nächste Wellen* und
  *Abgeschlossene Wellen* in Quelle + Split verankert; normative
  **Wellen-Closure-Prozedur** (5 Schritte) ergänzt, kurs-intern verankert
  (kein externes Referenz-Repo als Autorität).
- **17 Modul-Splits auditiert** und Defekte behoben (verpatzter
  Fehlannahmen-Block modul-10, toter Selbstverweis modul-12, didaktische
  Reste modul-02/03/16; modul-03 Spec-Stratifizierung auf Kurzform + Verweis
  eingedampft).
- **Split-Selbst-Enthaltung:** 72 Kurs-Cross-Links → Geschwister-Links, damit
  sie im `lab-regelwerk.zip` mitreisen (`rewrite-doc-links.py --keep-within-src`).
- **Provenance-Zeilen (20×)** in `lab/regelwerk/` → HTML-Kommentar-Metadaten
  (nicht gerendert, aber weiter d-check-validiert).
- **d-check-Pin `v0.23.0` → `v0.43.1`** (Image-Digest) im `Makefile`;
  verhaltensgleich verifiziert.
- **`lab/regelwerk` ist jetzt das kanonische Betriebsregelwerk-Artefakt.** Die
  Adopter-Story (README, kurs/de/README, lab/README, Templates, lab/example)
  verweist durchgängig auf das `lab-regelwerk.zip` / den Split; die Stand-Zeile
  lebt jetzt in [`lab/regelwerk/README.md`](lab/regelwerk/README.md)
  (**Kurs-Welle 24**).

### Entfernt

- **`kurs/de/agents-regelwerk.md`** (Zwischen-Digest). Ersatz ist das per-Modul-
  Split `lab/regelwerk` bzw. das `lab-regelwerk.zip`. CI (`templates-release.yml`,
  `templates-zip.yml`) baut/releast die Einzeldatei nicht mehr; das
  `lab/example`-Drift-Tool zeigt aufs Split-Verzeichnis (inhaltsbasierte
  Verzeichnis-Hash-Migration deferred).
- **`lab/templates/harness.mk`** — der `docs-check`-Gate steht jetzt direkt im
  Template-`Makefile` (Adopter erzeugen ihn alternativ per `d-check --print-mk`).
- **`grundlagen-checkpoints.md` + `grundlagen-konzeptkarte.md`** aus dem
  Regelwerk (rein didaktische Lern-Navigation, kein operativer Inhalt).

**Bruch für Konsumenten:** Das Release-Asset `agents-regelwerk.md` und die
mitgelieferte `harness.mk` entfallen; wer die Einzeldatei per URL zog, wechselt
auf `lab-regelwerk.zip` (self-navigierbares Bundle). Der Kurs-*Inhalt* bleibt
maßgeblich unter `/kurs/de/`.

## Welle 23 — 2026-06-23 · Template-Feinschliff (ADR-Tabelle, Gate-Baseline) + d-check v0.23.0

### Geändert

- **ADR-Vorlage „Verglichene Alternativen" als Pro/Contra-Tabelle** — im
  [ADR-Datei-Template](lab/templates/docs/plan/adr/NNNN-titel.template.md) die
  drei `### Option A/B/C`-Blöcke (je eigene `- Pro:`/`- Contra:`-Liste) auf eine
  Markdown-Tabelle (`| Option | Pro | Contra |`) umgestellt, gewählte Option
  fett. Rein kosmetisch — kein Schema- oder Inhaltswechsel; die „mindestens drei
  Optionen mit Pro/Contra"-Regel bleibt.
- **d-check-Pin `v0.9.0` → `v0.23.0`** (Image-Digest neu gepinnt) im
  [`Makefile`](Makefile) (Single Source of Truth) und im
  `harness.mk` (`lab/templates/`); der Versions-Kommentar
  in `harness.mk` trug noch `v0.8.0` und wurde mitgezogen. Laut d-check-CHANGELOG
  keine Breaking-Config-Änderung v0.9.0→v0.23.0 — bestehende `.d-check.yml` bleibt
  gültig, `make check` grün (docs-check 0 Befunde, alignment-check 0 WARN).
- **Gate-Baseline um den Repo-Generator ergänzt** — der Regenerier-Hinweis in der
  [`lab/templates/README.md`](lab/templates/README.md) nannte nur das leere
  `d-check --print-config`-Gerüst; jetzt zusätzlich
  `d-check --suggest-config ai-harness-init --id-prefix <PRÄFIX>` (neu seit
  d-check v0.18.0/v0.22.0), das `ids`/`matrix`/`codepaths` mit den Kurs-Kennungen
  (`ADR-…`, `MR-…`, `slice-…`, `<PRÄFIX>-FA-…`/`-QA-…`) vorbelegt. `--id-prefix`
  als Begleitschalter dokumentiert: ohne ihn bleiben `<PREFIX>`-Platzhalter und
  `# TODO` stehen.

Alle drei Änderungen betreffen Templates bzw. Tooling — die Quelle
[`agents-regelwerk.md`](kurs/de/agents-regelwerk.md) bleibt unberührt
(**kein Stand-Bump**, vgl. Welle 20/21). Die Templates fließen mit dem
nächsten Release-Tag ins `lab-templates.zip`-Asset.

## Welle 22 — 2026-06-18 · ADR-ID-Schreibweise vereinheitlicht (vierstellig)

### Geändert

- **ADR-ID-Platzhalter durchgängig vierstellig (`ADR-<NNNN>`)** — die
  ADR-Kennung wurde zugleich zwei-, drei- und vierstellig geführt, während
  die realen ADRs unter
  [`lab/example/docs/plan/adr/`](lab/example/docs/plan/adr/), der ADR-Dateiname
  (`<NNNN>-titel`) und das ADR-README-Template bereits vierstellig waren.
  Vereinheitlicht auf vier Stellen: ADR-Bindung-Klasse der Konventionen-Seite
  ([`grundlagen/konventionen.md`](kurs/de/grundlagen/konventionen.md), Quelle)
  und ihre Derivate ([`agents-regelwerk.md`](kurs/de/agents-regelwerk.md) §463,
  [`lab/regelwerk/grundlagen-konventionen.md`](lab/regelwerk/grundlagen-konventionen.md)),
  die Observability-ID-Kette (Modul 15), das ADR-Datei-Template
  (`Status:`/`Bezug:`), das ADR-README-, AGENTS-, `harness/README`-,
  `harness/conventions`-, slice-, roadmap- und welle-Template sowie die
  `lab/example`-Spiegel (`AGENTS.md`, `harness/conventions.md`, `adr/README.md`).
  Reine Schreibweisen-Vereinheitlichung — **kein** Schema-Wechsel der
  Nummernvergabe; reale/fiktive vierstellige Nummern und die einstellige
  Prosa-Variable `ADR-N` (Fließtext „supersedes ADR-N") bleiben unverändert.
  Schließt die Quell-Wurzel der nachgelagerten Adaption **d-check `MR-008`**
  („Korrektur in der Kurs-Quelle steht aus"). `Stand:` von `agents-regelwerk.md`
  auf Welle 22 gezogen.

## Welle 21 — 2026-06-16 · Grundlagen-Rahmen im Regelwerk-Split + d-check v0.9.0

### Neu

- **Grundlagen-Rahmen im Split** — [`lab/regelwerk/`](lab/regelwerk/)
  trägt jetzt neben den 17 Modulen auch die drei Grundlagen-Abschnitte der Quelle als
  einzelne Dateien:
  [`grundlagen-konventionen.md`](lab/regelwerk/grundlagen-konventionen.md) (inkl.
  §Referenz-Richtung/SDP — wer darf wen referenzieren, also die ADR→Slice/Welle-
  Regel), [`grundlagen-klassifikation.md`](lab/regelwerk/grundlagen-klassifikation.md)
  und [`grundlagen-durchsetzungsschicht.md`](lab/regelwerk/grundlagen-durchsetzungsschicht.md).
  Wortgleicher Abschnittstext, kein Zusatz-Kopf; ein Agent kann so einen einzelnen
  Grundlagen-Abschnitt laden, ohne das ganze Regelwerk im Kontext zu halten. Die
  Quelle bleibt unberührt (kein Stand-Bump). Cross-Section-Anker (z. B.
  `#kernbegriffe`) zeigen auf die Geschwister-Datei, damit das
  `lab-regelwerk.zip`-Bundle self-navigierbar bleibt; Pfad-Verweise gehen auf den
  Kurs und werden beim Release auf den Tag gepinnt.

### Geändert

- **[`lab/regelwerk/README.md`](lab/regelwerk/README.md)** — Scope von „nur
  Modul-Sektionen" auf „Module + Grundlagen-Rahmen" erweitert (neue
  `### Grundlagen`-Liste); nur Quellen-Rang, Wartung und Stand bleiben der
  Quelldatei vorbehalten. Provenienz-Aufzählung in der Blockquote um
  Durchsetzungsschicht ergänzt (Doku-Drift behoben).
- **d-check-Pin `v0.8.0` → `v0.9.0`** im [`Makefile`](Makefile) (Image-Digest neu
  gepinnt); `make check` grün (140 Dateien, 0 Befunde, 0 ERROR/WARN).

### Korrektur · v1.2.1 — 2026-06-18

- **„Digeste" → „Grundlagen-Abschnitte"** in
  [`lab/regelwerk/README.md`](lab/regelwerk/README.md) (3×) und in der
  Welle-21-Notiz oben. Das Wort suggerierte eine Verdichtung und widersprach
  damit dem »wortgleichen« Charakter der Auszüge. Reine Terminologie — kein
  Inhalts-, kein Stand-Bump; ausgeliefert als Patch-Release `v1.2.1`
  (Assets tag-gepinnt neu gebaut).

## Welle 20 — 2026-06-15 · Regelwerk per Modul + SemVer-Release-Tags

### Neu

- **Regelwerk per Modul** in [`lab/regelwerk/`](lab/regelwerk/) — die 17
  Module (0–16) aus [`agents-regelwerk.md`](kurs/de/agents-regelwerk.md) als
  einzelne Dateien (Kurs-Slugs, wortgleicher Modultext, kein Zusatz-Kopf), plus
  [`README.md`](lab/regelwerk/README.md) als nach Phasen gruppierter Index. Die
  Quelle bleibt unberührt (kein Stand-Bump); ein Agent kann so ein einzelnes
  Modul laden, ohne das ganze Regelwerk im Kontext zu halten. Verweise bleiben
  in-repo relativ (gate-validiert, lokal navigierbar); beim Release pinnt
  `tools/rewrite-doc-links.py --keep-within-src` fürs `lab-regelwerk.zip`-Asset
  nur die Außen-Verweise (Kurs/Templates/Beispiel) auf den Tag — die
  Modul-Querverweise bleiben relativ, das Bundle ist self-navigierbar.

### Geändert

- **Release-Tags auf SemVer** — Schema von `templates-v*` auf `vX.Y.Z` (erstes
  `v1.0.0`). Der `templates-release.yml`-Trigger akzeptiert beide
  (`v[0-9]*` und `templates-v*`, abwärtskompatibel); die Release-Bedingung in
  `rewrite-template-links.sh` ist jetzt prefix-agnostisch (`ref != main`) und
  überlebt künftige Tag-Umbenennungen. Kopf-Kommentar in
  `rewrite-doc-links.py` aufs neue Schema nachgezogen. Adopter-Doku
  (Root-`README.md`, `lab/templates` §Download) auf das Schema und die drei
  Release-Assets (inkl. `lab-regelwerk.zip`) aktualisiert.
- **[`lab/README.md`](lab/README.md)** — `regelwerk/` in Intro-Liste und
  Aufbau-Baum ergänzt (Doku-Drift behoben).
- **`templates-release.yml`** liefert zusätzlich `lab-regelwerk.zip` (17 Module
  + README) als Release-Asset, parallel zu `lab-templates.zip`.

## Welle 19 — 2026-06-14 · C++/CMake-Skelett + Regelwerk-Drift-Sensor

### Neu

- **C++/CMake-Skelett** in [`lab/example/cpp/`](lab/example/cpp/) —
  sechstes Sprach-Skelett (C++20, hexagonal: `src/hexagon` + `src/adapters`),
  doctest via FetchContent (`GIT_TAG`-Pin), clang-tidy mit
  `WarningsAsErrors`, textbasierter `arch-check.sh` (ADR-0001) als
  CTest-Test, gcovr-Coverage. `make gates` grün im Docker (Coverage 94 %);
  Runtime-Image Distroless `cc` mit statisch gelinktem libstdc++ und
  glibc-Match (`debian:12` ↔ `distroless-debian12`, Base-Images per
  `@sha256` gepinnt).
- **Regelwerk-Drift-Sensor** — `make regelwerk-drift`
  ([`lab/example/tools/check_regelwerk_drift.py`](lab/example/tools/check_regelwerk_drift.py)):
  inhaltsbasierter sha256-Pin der adoptierten `agents-regelwerk.md` in
  `conventions.md` §Baseline; erkennt Upstream-Drift unabhängig vom
  `Stand:`-Marker (vgl. §„Nachweis über Inhalt, nicht Diff"). Kein
  `gates`-Glied — CI/periodisch, braucht die externe Quelle.
- **Regelwerk self-contained ausgeliefert** — `tools/rewrite-doc-links.py`
  schreibt die repo-internen Links der adoptierten `agents-regelwerk.md`
  beim Release auf absolute `blob/<tag>`-URLs um (fence- und
  existenz-gegated: illustrative Adopter-Pfade bleiben relativ). Das
  Regelwerk geht als eigenes Release-Asset neben `lab-templates.zip` raus
  (`releases/latest/download/agents-regelwerk.md`); `AGENTS.template`,
  Root-README-Adoption und `lab/templates` §Download zeigen dorthin statt
  auf Raw-`main`. Quelle bleibt relativ (kein
  Stand-Bump). Behebt tote Verweise beim Kopieren/Cachen in fremde Repos.

### Geändert

- Sprach-Skelett-Zählung durchgängig fünf → sechs: Lab-Satelliten
  ([`lab/README.md`](lab/README.md), `lab/example/` README/Makefile/AGENTS,
  ADR-0001-Fitness-Table) und Kurs-Prosa (grundlagen, modul-08, modul-14,
  `agents-regelwerk.md`, konventionen) sowie CO-001 / slice-013 /
  slice-014 / roadmap.

## Welle 18 — 2026-06-11 · Konsistenz-Welle + Agents-Regelwerk

*(Commits dieser Welle tragen das historische Label „Welle 8
(Konsistenz)" — die Kollision mit der älteren Welle 8 war der Anlass
für dieses Register.)*

### Behoben

- Fachdidaktisches Review (konstruktives Alignment, Anderson/Krathwohl,
  CLT, didaktische Rekonstruktion): ~45 Befunde — ungeprobte
  Spitzen-Verben mit `LZ <N>`-Items geschlossen, Tag-Fehler korrigiert,
  Engage-/Glossar-/Stimulus-Fixes.
- Lösungsschicht vollständig nachgezogen: jede Übung und jedes
  Selbstcheck-Item der Module 0–16 hat ein Musterantwort-Pendant.
- Off-by-one-Modulnummern der Modul-2-Einfügung repariert
  (`klassifikation.md`, `lernervorstellungen.md`, `kickoff-vorlauf.md`,
  Modul 9 „8a/8b", Root-README-Phasentabelle).
- Lab-Drift: alle fünf Dockerfiles per Registry-Digest gepinnt
  (inkl. Ersatz des toten C#-Tags `cbl-mariner` → `azurelinux`),
  `make plan-status` ergänzt, Modul-8-Lab-Bezug ehrlich gemacht.
- Richtungsfehler in der Lifecycle-Faustregel (`klassifikation.md`:
  „nach rechts" → „nach links").
- Phase-05-Assessment-Vakuum: Pflicht-Feature „Produktionsfreigabe"
  im Abschlussprojekt, Checkpoint A probt Modul 2, Checkpoint D die
  Sensor-Literacy; Kalibrierungsbeispiel B belegt alle Indikatoren.

### Neu

- **`kurs/de/agents-regelwerk.md`** — der Kurs als Betriebsregelwerk für
  Code-Agenten (derivatives Sicht-Artefakt mit Stand-Zeile), in den
  Session-Lesepfaden verdrahtet (AGENTS-/harness-README-Templates,
  Worked Example, `conventions`-Adoptionsquelle mit Raw-URL).
  Im Lauf der Welle umbenannt (vormals `agents-digest.md`) und
  methodisch neu aufgebaut: statt Hand-Verdichtung ein
  **didaktik-freier Extrakt in Quellformulierung** (~4.000 Zeilen —
  Grundlagen-Dossiers komplett, Module 0–16 als operative Extrakte
  mit Quell-Verweis pro Abschnitt; weggelassen ist die
  Didaktik-Schicht, nicht verdichtet der Inhalt).
- Modul 13: Sektion „Gate-Typ ↔ Fehlerbild" (Zuordnungstabelle).
- Templates: ID-Schema-Deklarations-Slot in
  `conventions.template.md`; AGENTS-Template §5 erklärt die
  ID-Vergabe.
- `docs-check`: nicht-kollabierender Slugger (erstmals 0 ERROR),
  `docs-check:ignore`-Marker, Modul-Nummern-Sensor gegen
  Off-by-one-Drift (Linktext = ERROR, Prosa-Titel = WARN).
- Root-`Makefile`: `make docs-check` · `make alignment-check` ·
  `make check` (Docker-basiert, `ARGS`-Durchreichung).
- GitHub-Actions-Workflow `.github/workflows/checks.yml`: beide
  Validatoren als CI-Gate bei Push/PR, über dieselben Make-Targets
  wie lokal (`alignment-check --strict`).
- Review-Report formalisiert: Vorlage
  `lab/templates/docs/reviews/review-report.template.md`, Ablageort
  `docs/reviews/` in der Verzeichniskonvention, Modul-10-Sektion
  „Reviewer berichtet auch, was er nicht gefunden hat" (schließt die
  bis dahin hängende §-Referenz im Reviewer-Skill).
- Dieses CHANGELOG als kanonisches Wellen-Register.

## Welle 17 — 2026-06-08 · Didaktik-Review

*(Commit-Label: „Didaktik-Review Welle 8" — achte Welle der
didaktischen Teilserie.)* Alignment-, Konsistenz- und CLT-Fixes über
32 Dateien: systemisches und-Verb-Audit, M13-Gate-Familien,
Kickoff-YAML-Zielmodule, M8-Übergabe-Zählung, Vier-Repos-Angaben.

## Wellen 1–16 — 2026-06-02 bis 2026-06-04

| Welle | Datum | Inhalt |
|---|---|---|
| 16 | 2026-06-04 | Fallstudien-Drift gegen Ist-Zustand der vier Beispiel-Repos behoben |
| 15 | 2026-06-04 | Englische Autorzitate ins DE übertragen, Given/When/Then-Notation verankert |
| 14 | 2026-06-03 | 12 Didaktik-Review-Findings (vier Linsen) behoben |
| 13 | 2026-06-03 | 16 Didaktik-Review-Findings behoben |
| 12 | 2026-06-02 | Modul 06: Übungen an beide Erschaffen-LZ gebunden |
| 11 | 2026-06-02 | Reflexionsvorlage: drei → vier Fragen angeglichen |
| 10 | 2026-06-02 | Lab um Module-10/11/14-Artefakte erweitert |
| 9 | 2026-06-02 | Worked Examples für fünf Erschaffen-Lernziele ergänzt |
| 8 | 2026-06-02 | Didaktik-Review-Findings (16 Befunde) behoben |
| 7 | 2026-06-02 | Didaktik-Review-Restposten behoben |
| 6 | 2026-06-02 | Didaktik-Review-Findings (4 Linsen) behoben |
| 5 | 2026-06-02 | Didaktik-Review-Findings (Alignment, Bloom, CLT) behoben |
| 4 | 2026-06-02 | Didaktik-Gutachten-Findings behoben |
| 3 | 2026-06-02 | docs-check-Validator-Findings behoben |
| 2 | 2026-06-02 | Sprach-Skelette-Review-Findings behoben |
| 1 | 2026-06-02 | Kurs-Inhalt-Review-Findings behoben |

Hinweis: Die Verweise „Welle 8" und „Welle 13" in
[`kurs/de/grundlagen/lernervorstellungen.md`](kurs/de/grundlagen/lernervorstellungen.md)
beziehen sich auf diese Zählung.
