# Review-Runde 10 — die Reparaturen der Runde 9

**Stand:** 2026-07-28. **Status:** offen, nichts davon behoben.

**Gegenstand:** der Diff `b23706d..0b83624` — die Nacharbeit zu
[Runde 9](review-runde-9.md).

**Verfahren:** drei unabhängige Reviewer mit getrennten Linsen und getrenntem
Kontext — (1) Satz- und Struktur-Integrität, (2) Kongruenz zwischen Quelle,
Spiegel, Template, Lösung, Lab-Vorbild und CHANGELOG, (3) Mechanik-Tauglichkeit.
52 Rohbefunde, zusammengeführt auf 30 plus 1 vorbestehenden.

**Gates zum Zeitpunkt des Reviews:** `make check` grün, `lab/example`
`make verify` grün. Kein Befund dieser Runde ist maschinell sichtbar.

---

## Verfahrens-Befund — zuerst, weil er die Verlässlichkeit dieser Runde berührt

Die drei Reviewer liefen **parallel auf demselben Arbeitsbaum**, und Linse 3
führte Break-Tests mit Schreibzugriff aus. Linse 1 hat dadurch einen
transienten Zustand gesehen und als Befund gemeldet (`slice-020` mit
ausgeweideter §7, „uncommitted"). `git status` ist sauber; der Befund ist
**falsch** und nicht in diese Runde übernommen.

Das ist ein Fehler des Verfahrens, nicht des Repos: Wer Break-Tests fährt,
braucht einen eigenen Arbeitsbaum. Für Runde 11 gehört jeder Reviewer, der
schreibt, in ein isoliertes Worktree.

**Zweiter Verfahrens-Hinweis:** Bei der Verifikation von R10-06 war *mein*
Gegen-Grep falsch (case-sensitiv gegen „ohne laufende Welle", die Fundstelle
beginnt satzinitial mit „Ohne"). Ich hätte den Befund fast als widerlegt
abgetan. Die Reviewer hatten recht.

---

## Der Befund über den Befunden

Runde 9 hat mit **E-2** erstmals die *Ursache* einer Fehlerklasse encodiert
statt ihrer Symptome: die Template-Schichtung. Das Ergebnis dieser Runde ist
eindeutig — **die Regel hat ihre eigene Einführung nicht überlebt**:

| Was E-2 verlangt | Was der Commit liefert |
|---|---|
| „**genau ein** Regelwerk-Zeiger pro Pflicht-Sektion" | `slice.template.md` 7 Zeiger auf 8 Sektionen (nicht 1:1), `welle-results.template.md` 2 auf 7, `welle.template.md` **0** |
| „Kein Kommentar ist die einzige Fundstelle einer Norm" | fünf neue Fälle in denselben vier Dateien (R10-03, R10-05, R10-12, R10-16, R10-17) |
| „Normtext raus aus Rumpf **und** Kommentar" | `observations.template.md` hat den Zeiger bekommen und den Normtext behalten |

Das ist kein Ausführungsfehler an einer Stelle, sondern der Beleg, dass eine
Regel **ohne durchsetzende Instanz** eine Absichtserklärung bleibt — und die
Feedback-Hälfte, die Runde 9 dafür vorgesehen hat (HIGH-Regel im
Reviewer-Skill), existiert in diesem Repo nur als *Adopter-Template*, nicht als
laufendes Prüfinstrument (R10-30).

---

## Blocker

### R10-01 — Der neue Sichtungs-Block meldet im Vorbild „keine Treffer", wo das Register zwei Zeilen derselben Sub-Area führt

*(Alle drei Linsen unabhängig; neu erzeugt, Reparatur zu R9-16.)*

`slice-020` :96–99 und `slice-014` :61–63 sind zwei der drei Blöcke, die den
Schritt vorführen sollen:

> slice-020: „Keine der berührten Sub-Areas (*Spec-Schreibung*) stand beim
> Anlegen dieses Slice bereits im Register … **Keine Treffer** ist ebenfalls
> eine Antwort."
> slice-014: „`BEO-002` … **Sonst keine Treffer.**"

Gegenprobe im Register, das derselbe Autor geschrieben hat:

```
observations.md:19 | BEO-003 | … | Spec-Schreibung | 2× | slice-008, slice-012 | offen
observations.md:23 | BEO-007 | … | Spec-Schreibung | 3× | slice-003, slice-005, slice-007
```

`BEO-003` steht **offen bei 2×**, Belege aus Slices mit kleinerer Nummer.
Beide Slices führen *Spec-Schreibung* als berührte Sub-Area. Nach
`slice.template.md` :156–158 wäre die Schwellen-Frage zu stellen gewesen —
`BEO-003` hätte mit `slice-020` 3× erreicht und einen Folge-Slice gebraucht.

**Szenario:** Der Adopter lernt den neu vorgeschriebenen Schritt am einzigen
Vorbild und lernt: ein Blick, dann „keine Treffer". Der Block, der das Register
unter der Schwelle am Leben halten soll, wird als Formalie vorgeführt.

### R10-02 — „Genau ein Regelwerk-Zeiger pro Pflicht-Sektion" — die Regel wird von den Dateien, die sie einführt, nicht erfüllt

*(Linse 2 und Linse 3 unabhängig; neu erzeugt, Reparatur zu R9-02/R9-11.)*

`konventionen.md` :81 (in diesem Commit geschrieben):

> der **Rumpf**: Feldnamen, Feldreihenfolge, `<Platzhalter>` — plus **genau ein**
> Regelwerk-Zeiger pro Pflicht-Sektion

Gemessen nach Schritt 4 + 5 (Hinweis-Block und alle Kommentare entfernt):

| Template | Sektionen | überlebende Zeiger |
|---|---|---|
| `slice.template.md` | 8 | 7, aber nicht einer je Sektion — §4 und §6 verlieren ihre einzigen |
| `welle-results.template.md` | 7 | 2 |
| `observations.template.md` | 1 | 1 (dafür doppelt geführt, R10-15) |
| **`welle.template.md`** | 7 | **0** |

`welle.template.md` ist die Datei, die R9-05 angefasst hat: Ihr einziger Zeiger
stand im Template-Hinweis-Block, den Schritt 4 entfernt. Nach dem Adoptieren
hat der Adopter dort keinen Weg zurück zur Regel — genau der Zustand, den E-2
für `observations.template.md` als „das einzige Template ohne R8-01-Behandlung"
behoben hat.

### R10-03 — Die „Ruheort-Regel" wird in Quelle und Spiegel namentlich zitiert und ist nur in einem Template-Kommentar definiert

*(Linse 2 und Linse 3 unabhängig; neu erzeugt, Reparatur zu R9-21.)*

`konventionen.md` :920 und Spiegel :864 berufen sich auf „die Ruheort-Regel".
`grep -rn "Ruheort" kurs/ lab/regelwerk/` liefert **genau diese zwei Zitate und
keine Definition**. Definiert ist sie ausschließlich in
`welle.template.md` :88–97 — einem HTML-Kommentar, den Schritt 5 löscht.

Der netzlose Adopter liest im Spiegel den Namen einer Regel, die im Bundle
nirgends steht. Das verletzt die Hard Rule, die **derselbe Commit** einführt
(`konventionen.md` :92: *Kein Kommentar ist die einzige Fundstelle einer Norm*).

### R10-04 — Der Regelwerk-Abschnitt, auf den §8 zeigt, kennt die *Vorgelagert*-Blöcke nicht

*(Linse 2 und Linse 3 unabhängig; neu erzeugt, Reparatur zu R9-15.)*

`slice.template.md` :135–136 und `lab/templates/README.md` :162–163 machen
beide *Vorgelagert*-Blöcke für **jeden** Slice-Plan verbindlich und schicken
den Adopter für das Voraussetzung-Wissen nach
`modul-05-planning-harness.md` §Ziel-Form. Dort steht abschließend:

> Der Begründungsblock pro Sub-Area ist **§8** des Slice-Plans: Modus ·
> Konventionen-Dichte · Phase-Reife · Evidenz-/Diskrepanz-Risiko ·
> Reconciliation-Aufwand.

`grep -c "Vorgelagert" lab/regelwerk/modul-05-planning-harness.md` → **0**.
Die §Behebung behauptet „Template, Template-Index und **Spiegel**
gleichgezogen"; der Spiegel-Abschnitt wurde nicht angefasst. Damit ist der
Zeiger, den E-2 an die Stelle des gestrichenen Rumpf-Textes setzt, nicht
einlösbar — die Pflicht steht wieder nur im Template.

### R10-05 — Die Bedingtheit des Pflichtfelds `liegt in` ist beim E-2-Umbau zurück in den Kommentar gewandert

*(Linse 3, Linse 1 unabhängig; neu erzeugt — R9-04 mit vertauschten Vorzeichen.)*

`slice.template.md` :109–110 (Kommentar) gegen :126 (Rumpf):

> Kommentar: „Die Feld-Zeile `liegt in` **nur setzen, wenn** mit diesem Slice
> wirklich etwas verkoerpert wurde; sonst die Zeile streichen."
> Rumpf: „— liegt in `<AGENTS.md §X | Makefile:<target> | …>`."

**Szenario:** Gewöhnliche Closure ohne Verkörperung — der Normalfall, beide
Vorbild-Closures sind so. Nach Schritt 5 sieht der Adopter ein Feld mit
Platzhalter und die unbedingte Anweisung aus Schritt 3, Platzhalter zu
ersetzen. Nichts sagt ihm mehr, dass die Zeile entfallen darf. Er trägt einen
Zielort ein → die Anker-Paarung läuft rot auf einer gesunden Closure.

Runde 8 hatte diese Bedingung in den Rumpf gehoben; Runde 9 hat sie im Zuge von
E-2 wieder in den Kommentar gelegt. Das Vorbild `slice-020` :87 löst es korrekt
— mit einer Formulierung, die im Template nicht mehr vorkommt.

### R10-06 — E-1 ist spiegelverkehrt halb nachgezogen: jede Ablage trägt die verworfene Formulierung dort, wo die andere korrigiert wurde

*(Linse 1 und Linse 2 unabhängig; neu erzeugt.)*

| Stelle | Quelle | Spiegel |
|---|---|---|
| Sichtungs-Schritt | :311 „im Repo ohne Wellen findet die nicht statt" ✓ | :49 „**ohne Welle** findet die nicht statt" ✗ |
| Lese-Schritt bei 3× | :411 „**Ohne laufende Welle** geschieht dasselbe" ✗ | :95 „ohne **Wellen-Betrieb** beim Lese-Schritt" ✓ |

E-1 erklärt genau diese Wortwahl zur falschen Achse — ein Repo mit Wellen hat
regelmäßig *keine laufende* Welle und trotzdem eine nächste Welle-Closure. Der
Spiegel ist an einer Stelle korrekter als sein Anker und an der anderen
falscher. Die §Behebung führt den Abschnitt als zurückgenommen.

### R10-07 — Der Sichtungs-Block kippt sein Ergebnis in ein Feld, das bei GF und Refactor nicht existiert

*(Linse 1 und Linse 3 unabhängig; neu erzeugt.)*

`slice.template.md` :155–156 ordnet an, den Zähler-Stand „unten ins
*Evidenz-/Diskrepanz-Risiko*" zu schreiben. Dieses Feld liegt **innerhalb** des
`### Sub-Area:`-Blocks (:176) — der ist bei reinem GF durch einen einzeiligen
Hinweis ersetzt und bei reinem Refactor ganz weg (:140–141).

```
$ grep -rn "Evidenz-/Diskrepanz-Risiko:" lab/example/ | wc -l
0
```

Alle drei in diesem Commit geschriebenen Vorbild-Blöcke verweisen „unten" auf
ein Feld, das in ihrer Datei null Mal vorkommt. Der Sichtungs-Schritt ist damit
ein Artefakt ohne Konsumenten — in genau den Instanzen, die ihn vorführen.

### R10-08 — „Alle drei Vorbild-Slices" — es sind vier, und der zweite Pflichtblock fehlt in allen

*(Linse 2 und Linse 3 unabhängig; neu erzeugt.)*

```
$ find lab/example/docs/plan/planning -name 'slice-*.md' | wc -l   → 4
$ grep -rln "Vorgelagert" lab/example/docs/plan/planning/          → 3
```

`slice-009-tie-break-determinismus.md` hat §8 und keinen der Blöcke. R9-16
selbst zählte noch korrekt „alle **vier** Vorbild-Slices"; die §Behebung
schreibt „drei" und schließt die Lücke damit scheinbar.

Zweite Hälfte: den Block *Vorgelagert — Sub-Area-Wahl prüfen*, den
`lab/templates/README.md` seit diesem Commit als „immer auszufüllen" führt,
trägt **kein einziger** der vier.

### R10-09 — Das CHANGELOG trägt zwei gegensätzliche Template-Regeln im selben Wellen-Eintrag

*(Linse 2; neu erzeugt.)*

Beide unter `## Welle 59`, 57 Zeilen auseinander:

> :170 „**Die Normlast der Templates steht im Rumpf, nicht im Kommentar.**
> `slice.template.md` §7 … tragen **Form und Regel** jetzt als Body-Zeilen"
> :113 „der **Rumpf** nur Form plus einen Regelwerk-Zeiger pro Pflicht-Sektion"

Die zweite nimmt die erste zurück, unmarkiert. Für den aktuellen Stand ist die
erste schlicht falsch. Adoptierende Repos vergleichen ihren Baseline-`Stand:`
gegen dieses Register und bekommen zwei Sollzustände für dieselbe Welle.

---

## Weitere Befunde

### R10-10 — Die neue „Lage"-Prüfung ist bei jeder korrekt ausgeführten Closure rot

*(Linse 2 und Linse 3 unabhängig; neu erzeugt, E-3.)*

`modul-06-roadmap.md` :390 verlangt „**Lage** (führt das Repo die Slice-Datei,
liegt sie in `done/`)". Dieselbe Datei :301 sagt, der Beleg werde **vor** dem
`git mv` geschrieben — und die Hard Rule „git mv + Inhaltsänderung = zwei
Commits" erzwingt, dass der `mv` ein eigener Commit ist. Ein Lage-Sensor auf
dem Schreib-Commit meldet rot auf dem frischesten Beleg, jedes Mal. Die drei
Prüfungen sind als „ohne Urteil entscheidbar" eingeführt; die dritte ist
commit-zeitpunkt-abhängig.

### R10-11 — Der Planning-Index des Vorbilds trägt die Drei-Positionen-Regel weiter

*(Alle drei Linsen; neu erzeugt, Reparatur zu R9-27.)*

`lab/example/…/README.md` :44: „Ob eine **flache** Welle *aktuell* oder
*geplant* ist, sagt die Roadmap." — wortgleich der Satz, den R9-27 beanstandet
hat. `welle.template.md` :13 und `README.template.md` :33 sagen jetzt
„geplante Wellen bekommen noch keine Datei, zwei Positionen, nicht drei". Die
§Behebung nennt „`welle.template.md` und Planning-Index" — der Index des
*Vorbilds* wurde übersehen, und Schritt 6 schickt den Adopter genau dorthin.

### R10-12 — Der §7-Kommentar erklärt sich für norm-frei und trägt drei Zeilen später Norm

*(Linse 1)* `slice.template.md` :102–110: „BEDIENHINWEIS — **keine Norm** …
darf nichts Tragendes halten", gefolgt von der Pflichtfeld-Bedingung und der
Eine-Zeile-/Backtick-Form. Beides sind Prüfvorschriften aus §Herkunfts-Anker.

### R10-13 — `welle-results.template.md` beschreibt im Kopfsatz den Zustand vor der Reparatur

*(Linse 1 und Linse 2 unabhängig)* :42: „BEGRUENDUNG — **die verbindliche FORM
steht im Rumpf darunter**, nicht hier." Der Rumpf trägt seit diesem Commit nur
den Zeiger; die Formangaben (Eine-Zeile-Regel, Gegenanker am Ziel :67–71)
stehen ausschließlich in den Kommentaren. Die Schwesterdatei hat ihre
Kopfzeile umgestellt („BEDIENHINWEIS — keine Norm"), diese nicht.

### R10-14 — Der Fluss-Graph verbindet zwei Namen für denselben Schritt, einer ohne Fundstelle

*(Linse 1 und Linse 2 unabhängig; halb behoben)* Knoten `G` :981 nennt
„Kriterium 3"; `grep -rn "Kriterium 3" kurs/ lab/` liefert **genau diesen einen
Treffer**. Der neue Knoten `F2` darüber nennt denselben Vorgang „(§8,
Vorgelagert)", und `F2 --> G` verbindet beide. R9-08 hatte beide Hälften
benannt; gebaut wurde nur der zweite Ausgang.

### R10-15 — Das Register-Template führt den Zeiger doppelt und behält den Normtext

*(Alle drei Linsen)* `observations.template.md` :9–11 (Rumpf) und :15–16
(Kommentar) tragen denselben Zeiger — gegen „genau ein". Und der Kommentar
:24–62 schreibt anschließend im Volltext aus, was der Zeiger ankündigt. Die
§Behebung verbucht die Datei unter „Normtext raus aus Rumpf **und**
Kommentar"; gekürzt wurde er um zwei Sätze.

### R10-16 — „Die leere Liste ist die Aussage" existiert nur im Kommentar

*(Linse 3)* `observations.template.md` :52–53. `grep -rn '— keine —' kurs/
lab/regelwerk/` findet die Regel im Regelwerk nicht, und der neue Zeiger zählt
sie nicht mit auf. Das Register ist ein Singleton — nach Schritt 5 ist die
`.template.md` weg. Der Adopter mit leerem Register löscht die Tabelle; „nichts
beobachtet" ist danach nicht mehr von „nie geführt" unterscheidbar.

### R10-17 — Modul 5 erklärt §4 zum Träger des Rückführungs-Grundes; im Template trägt das ein Kommentar, im Vorbild niemand

*(Linse 1 und Linse 3 unabhängig; neu erzeugt, Reparatur zu R9-28.)*
`modul-05-planning-harness.md` :62: „verlangen den Grund **im Slice-Plan §4**,
wo die Rückführungs-Bedingungen vorab benannt sind." Die zwei Rückführungen
benennt nur `slice.template.md` :65–69 — ein Kommentar. Und keiner der vier
Vorbild-Slices nennt in §4 eine Rückführungs-Bedingung. Zusätzlich setzt der
Satz *Bedingung vorab* und *Grund im Nachhinein* gleich.

### R10-18 — Der Scope-Absatz wehrt einen Widerspruch ab, den es nicht mehr gibt

*(Linse 1)* `konventionen.md` :905: „er widerspricht dem Satz oben nicht …
*innerhalb* der Sektion entscheidet das Feld, **nicht die Sektion**." Der Satz
oben lautet seit der R9-19-Reparatur „nicht durch die **Semantik des
Eintrags**" — von der Sektion ist keine Rede mehr. Die Entwarnung ist ein
Strohmann.

### R10-19 — Die neue Konvention zitiert die Prozedur falsch, auf die sie sich beruft

*(Linse 1)* `konventionen.md` :71: „**alle** HTML-Kommentare gelöscht
(`README.md` §Verwendung)". Schritt 5 lautet: „entfernen — **außer**
`<!-- d-check:ignore … -->`-Marker … müssen bleiben."

### R10-20 — Das DoD-Item ist in einem Repo mit Wellen nie abhakbar

*(Linse 3 und Linse 1 unabhängig)* `slice.template.md` :46 („Nur in einem Repo
ohne Wellen-Betrieb"). Im Repo mit Wellen bleibt es dauerhaft `- [ ]`, während
der Closure-Trigger „DoD vollständig" verlangt. Das Vorbild löst es durch
**Löschen** der Zeile — eine Anweisung dazu überlebt Schritt 5 nirgends. Im
Repo ohne Wellen braucht der Ablauf drei Commits, die Hard Rule benennt zwei.

### R10-21 — Der geschärfte Closure-Note-Gate ist grün auf einem unausgefüllten Template-Rumpf

*(Linse 3; vorbestehend, in diesem Commit verschärft.)* Break-Test: §7 durch
den adoptierten Template-Rumpf ersetzt, kein Platzhalter gefüllt →
`check_closure_notes: ok`. `count_sentences()` zählt 4; **ohne** die in diesem
Commit eingefügte Zeile „Regeln dieser Sektion: Baseline-Regelwerk …" wären es
3. Der Gate erkennt die *gelöschte* Sektion, nicht die *unausgefüllte* — und
die E-2-Reparatur hat seine Umgehung um einen Satz bequemer gemacht.

### R10-22 — Das adoptierte Register startet mit drei erfundenen Beobachtungen

*(Linse 3; vorbestehend, in diesem Commit verschärft.)* Nach Schritt 3–5 steht
eine Tabelle mit `BEO-001` (1×), `BEO-002` (2×), `BEO-003` (3×, „verkörpert in
`AGENTS.md` §<N>"). Schritt 3 befiehlt unbedingt, Platzhalter zu ersetzen. Die
R9-12-Reparatur hat `<slice-NNN>, …` auf drei Platzhalter gebracht und damit
die Zahl der zu erfindenden Belege von einem auf drei erhöht.

### R10-23 — „Zwei Leser, nicht einer" steht in Lösung und Modul 5; Modul 6, Spiegel und Rubrik nennen einen

*(Linse 2)* Lösung :193–201 und Modul 5 :67–70 nennen Lese- **und**
Sichtungs-Schritt. Modul 6 :364 („Die Welle-Closure *liest* dann nur noch"),
Spiegel :91 und die Rubrik-Zelle *solide* :656 nennen weiter einen — bei einer
Selbstcheck-Frage, die ausdrücklich „wer einträgt und wer liest" verlangt.

### R10-24 — Der Blockname lautet in der Norm „sichten", in allen drei Instanzen „gesichtet"

*(Linse 2)* Norm und Template: *Vorgelagert — offene Beobachtungen **sichten***.
Vorbild dreimal: *…**gesichtet**:*. Dieselbe Klasse wie R9-26, eine Ebene
tiefer — der Blockname ist die einzige Fixform, an der ein Reviewer den
Pflichtblock erkennt.

### R10-25 — Der Planning-Index nennt `slice-020` „wellenlos" und nimmt es im selben Satz zurück

*(Linse 1)* `lab/example/…/README.md` :28: „Vorbild für einen **wellenlosen**
Slice … — **genauer:** für einen Slice **ohne Wellen-Zugehörigkeit** in einem
Repo, das Wellen schneidet." Nach E-1 gibt es keinen wellenlosen Slice. Dazu
`slice-020` :61 unverändert: „Auch ein **wellenloser Slice** trägt selbst ein".

### R10-26 — „Wer beides gleichsetzt" steht zweimal in zehn Zeilen mit verschiedenen Bezügen

*(Linse 1)* `modul-06-loesung.md` :311 (*gezählt vs. verkörpert*) und :321
(*Slice-Zugehörigkeit vs. Repo-Modus*).

### R10-27 — §8 sagt dieselbe Regel zweimal, die zweite Fassung belegt nur die Hälfte

*(Linse 1)* `slice.template.md` :136 und :161, 25 Zeilen auseinander. Die
zweite kündigt „beide" an und begründet nur den Sichtungs-Block, und das nur
für den wellenlosen Fall — der Halbsatz, der den Modus-Fall trug, ist beim
Umbau weggefallen.

### R10-28 — Das CHANGELOG führt drei Varianten der Achse nebeneinander

*(Linse 1 und Linse 2 unabhängig)* „ohne Wellen-Betrieb" :27, „ohne laufende
Welle" :34, „ohne Welle" :58 — und :122 erklärt die Korrektur, ohne die
widersprechenden Zeilen im selben Release-Block zu ziehen.

### R10-29 — Der Register-Zeiger im Vorbild zitiert statt zu zeigen — und lässt die neue dritte Prüfung weg

*(Linse 2)* `lab/example/…/observations.md` :6–9 schreibt zwei Drittel der
Beleg-Regel aus („`slice-<NNN>`, Anzahl = Zähler") — gegen „*Der Zeiger ist
kein Zitat*" :88. Die dritte Prüfung *Lage* fehlt in Vorbild **und** Template.
Dazu drei Abweichungen zum Template-Zeiger: anderer Regelwerk-Name, andere
Aufzählung.

### R10-30 — Die Feedback-Hälfte von E-2 hat in diesem Repo keinen Träger

*(Linse 3)* `konventionen.md` :98: „Die Feedback-Hälfte ist deshalb der
**Reviewer**." `find . -path "*skills*" -name "*.md"` liefert zwei Dateien,
beide unter `lab/templates/` — der Kurs-Repo hat kein `.harness/`. Die
HIGH-Regel steht in einem Adopter-*Template*, nicht in einem laufenden
Prüfinstrument. Der empirische Beleg: fünf frische Fälle der Klasse *Norm nur
im Kommentar* in denselben vier Dateien, die die Regel eingeführt haben. Die
benannte Grenze lautet „hängt an einem Review, nicht an einem Lauf" — nicht
benannt ist, dass es das Review-Instrument hier gar nicht gibt.

---

## Vorbestehend — nicht aus diesem Diff

- **Drei von vier Vorbild-Slices haben kein Register-DoD-Item**, das das
  Template seit Welle 59 trägt (`slice-009`, `slice-013`, `slice-014`); zwei
  von ihnen auch kein Item für die Risiko-Ausgänge. R9-18 hatte es benannt, die
  §Behebung hat nur den Kommentar-Teil erledigt. `slice-013` kündigt in seinem
  neuen §8-Block einen 3×-Übertritt an, den seine DoD nicht abhakt.

---

## Geprüft und ohne Befund

- **Gates:** `make check` und `lab/example` `make verify` grün; der in Runde 9
  geschärfte Closure-Note-Gate erkennt die *gelöschte* §7 tatsächlich
  (Break-Test reproduziert) — seine Lücke ist die *unausgefüllte* (R10-21).
- **E-3 Form und Anzahl** halten im Vorbild: alle sieben Registerzeilen tragen
  Kennungen ohne Freitext, Anzahl = Zähler.
- **Der Arbeitsbaum ist sauber** — der gegenteilige Befund aus Linse 1 war ein
  Artefakt des parallelen Break-Tests (siehe §Verfahrens-Befund).
- **Modul 9/10/13** tragen die Formangabe jetzt an allen sechs Stellen
  wortgleich (R9-30 hält).
- **Carveout-Ablage** und die Rücknahme der Snapshot-Tabelle im Vorbild halten.

---

## Nächster Schritt

Nichts davon ist behoben.

**Die Frage vor allen Reparaturen ist diesmal nicht inhaltlich, sondern
strukturell:** Runde 9 hat die Ursache encodiert und die Regel in derselben
Bewegung gebrochen — an vier von vier Templates. Drei Runden nacheinander haben
gezeigt, dass eine Norm ohne durchsetzende Instanz in diesem Repo nicht hält.
Die Optionen sind:

1. **E-2 zurücknehmen** und akzeptieren, dass Templates Normtext duplizieren.
2. **E-2 behalten und die Durchsetzung schaffen** — nicht als neues Skript
   (siehe Runde 9), sondern indem der Kurs-Repo selbst ein `.harness/skills/`
   bekommt und das Review vor dem Commit tatsächlich läuft.
3. **Den Geltungsbereich verkleinern:** die Schichtung nur für die Sektionen
   verlangen, die eine Norm tragen — und die Liste dieser Sektionen explizit
   führen, statt „jede Pflicht-Sektion" zu behaupten.

Danach erst die Einzelbefunde. R10-01 und R10-08 sind unabhängig davon sofort
zu korrigieren: Das Vorbild führt einen Pflichtschritt falsch vor, und das ist
die Klasse, die am direktesten beim Adopter ankommt.
