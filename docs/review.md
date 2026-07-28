# Review-Runde 7 — Welle 59, Nacharbeiten

**Stand:** 2026-07-27, Befund-Erhebung. **Behebung:** 2026-07-28 —
alle 20 Befunde behoben, dazu beide vorbestehenden Defekte
(siehe [§Behebung](#behebung) am Ende). Die Befundtexte unten stehen
unverändert; sie beschreiben den Zustand zum Zeitpunkt des Reviews.
Die **Design-Beobachtung** bleibt offen (kein Textfehler, kein Ort im
Register — dieses Repo führt kein eigenes `docs/plan/planning/`).

**Gegenstand:** der unkommittierte Diff gegen `adef210`
(„docs(planung): Steering-Loop-Zähler als stehendes Register (Welle 59)"),
27 Dateien.
Welle 59 selbst ist committet; geprüft wurden ausschließlich die
Reparaturen aus den Runden 4–6, die darauf liegen.

**Verfahren:** drei unabhängige Reviewer mit getrennten Linsen —
(1) Satz- und Struktur-Integrität innerhalb jeder Datei,
(2) Kongruenz zwischen Quelle, Spiegel, Template, Lösung und CHANGELOG,
(3) Mechanik-Tauglichkeit („funktioniert die Regel, wenn ein Adopter sie
befolgt?").
Die drei Blocker R7-01, R7-08 und R7-14/R7-15 wurden von mehr als einem
Reviewer unabhängig gefunden.

**Umfang:** 20 Befunde, dazu 2 vorbestehende Defekte und 1 Design-Beobachtung.
(In der mündlichen Zusammenfassung stand versehentlich „19".)

**Gates zum Zeitpunkt des Reviews:** `make docs-check` 0 ERROR / 0 WARN
(166 Dateien), `make alignment-check` 0 WARN, `lab/example` `make verify` grün.
Kein Befund dieser Runde ist maschinell sichtbar — alle liegen in der
Bedeutung, nicht in der Referenz.

---

## Blocker

### R7-01 — Die Anker-Paarung wird dort, wo sie angeordnet wird, noch semantisch ausgelöst

Runde 6 hat den Auslöser von der Semantik („der Eintrag nennt einen Zielort")
auf die **Form** umgestellt — aber nur in der Definition, nicht in der
Prozedur, die die Prüfung anordnet.

Neu, `kurs/de/grundlagen/konventionen.md` :843–845:

> Fehlt das Feld, ist der Eintrag *gezählt, nicht verkörpert* und kein
> Gegenstand der Paarung.

Unverändert, `kurs/de/02-planung/modul-06-roadmap.md` :487–489
(Welle-Closure, Schritt 3):

> (a) **Anker-Paarung** — jeder Steering-Loop-Eintrag nennt einen Zielort,
> der Zielort existiert und trägt `seit welle-<NN>` bzw. `seit slice-<NNN>`

Der Spiegel `lab/regelwerk/modul-06-roadmap.md` :156–158 trägt dieselbe alte
Fassung.

**Warum das ein Widerspruch und nicht nur eine Altlast ist:** Modul 6 zählt
die *benannte Spec-Lücke* selbst als Steering-Loop-Eintrag auf (:456–457),
verlangt in (a) aber von **jedem** Eintrag einen Zielort.
`lab/templates/docs/plan/planning/welle-results.template.md` :51–52 schließt
genau diesen Fall aus („eine benannte Spec-Luecke … ist kein Gegenstand der
Paarung"), ebenso das eigene Vorbild
`lab/example/docs/plan/planning/done/welle-1-results.md` :29–30.

**Szenario:** Wer die Prozedur aus Modul 6 implementiert, baut einen Sensor,
der auf `welle-1-results.md` :33 rot läuft — auf einer Zeile, die nach der
Definition korrekt ist.
Wer nur das Bundle hat, bekommt im netzlosen Spiegel ausschließlich die
semantische Fassung, also genau die, die laut `konventionen.md` :844 „auf
jeder gewöhnlichen Slice-Closure rot gelaufen wäre".

Zusatz: `CHANGELOG.md` :36–41 behauptet für diesen Umbau Vollständigkeit
(„Nachgezogen wurden **alle** Normstellen dieses Subsystems … die
**Anker-Paarung** … und ihr **Einstiegspunkt**").
Die Normstelle in Modul 6 ist nicht dabei.

### R7-02 — Das eigene Template enthält den Trigger als Dekoration

`lab/templates/docs/plan/planning/slice.template.md` :123–125, im **selben**
§7-Kommentarblock, fünfzehn Zeilen unter der kanonischen Form:

> - Folge-Slices: welche neuen open/-Einträge? (*derivativ* — der Slice
>   selbst **liegt in `open/`**, diese Zeile zeigt nur darauf …)

Das ist `liegt in` plus backtick-eingefasster Pfad — die Form, von der
:107 sagt, dass **nur** sie die Anker-Paarung auslöst.
Gelöscht werden soll laut Template nur der Kopfblock (:3–5); die
§7-Guidance-Kommentare bleiben ausdrücklich stehen.

**Szenario:** Ein Adopter kopiert das Template, schließt einen gewöhnlichen
Slice ohne jede Verkörperung, behält den Kommentar.
Der Sensor findet `liegt in` + `open/`, hält den Slice für einen wellenlos
verkörperten Fall und prüft, ob `open/` den Anker `seit slice-<NNN>` trägt —
rot, auf jedem Slice.

Dass es vermeidbar war, zeigt die Schwesterdatei:
`welle-results.template.md` :95 formuliert denselben Gedanken bewusst ohne das
Feld („der Folge-Slice selbst **ist eine Datei in** `open/`").
Die Umgehung ist in einer Datei gemacht, in der anderen nicht.

### R7-03 — Das einzige reale Vorkommen des Pflichtfelds weicht von der kanonischen Form ab

Kanonisch laut `kurs/de/grundlagen/konventionen.md` :838–841 („die kanonischen
Formen liefern `welle-results.template.md` bzw. `slice.template.md` §7"):

> liegt in `<AGENTS.md §X | Makefile-Target | .harness/skills/…>`

Real, `lab/example/docs/plan/planning/done/welle-1-results.md` :32:

> — liegt in \[`AGENTS.md`\]\(…\) §2.7 (trägt dort `seit welle-1`).

(Die Klammern sind hier maskiert, damit dieses Dokument selbst keinen toten
Link trägt — im Original ist es ein gewöhnlicher Markdown-Link auf `AGENTS.md`.)

Drei Abweichungen auf einmal:

- der Pfad steht als **Markdown-Link**, nicht in Backticks — ein Matcher auf
  ``liegt in ` `` trifft nicht, weil zwischen „in " und dem Backtick ein `[`
  steht;
- die Sektionsangabe `§2.7` steht **außerhalb** des Zielorts, im Template
  dagegen innerhalb (`<AGENTS.md §X>`) — zwei Extraktionsgranularitäten;
- im Template selbst ist das Feld durch einen **Zeilenumbruch** getrennt
  (`welle-results.template.md` :60–61: „liegt in" am Zeilenende, Pfad in der
  Folgezeile), ein zeilenweiser Sensor greift auch dort nicht.

**Szenario:** Ein Adopter baut das Gate exakt nach der kanonischen Form und
lässt es über sein Repo laufen, das nach dem `lab/example`-Vorbild geschrieben
ist.
Der Sensor findet null Einträge und meldet grün — obwohl die einzige
verkörperte Regel dasteht.
Das ist die Klasse „halluziniertes Gate", angewandt auf den Sensor selbst.

### R7-04 — Der wellenlose Pfad verkörpert, aber niemand prüft ihn

Alle drei Paarungen sind ausschließlich am Ende von Welle-Closure Schritt 3
angeordnet — `kurs/de/02-planung/modul-06-roadmap.md` :484–486:

> **Zum Schluss alle drei Paarungen prüfen** — erst *jetzt* …

Für den wellenlosen Betrieb wird namentlich nur zweierlei eigenständig
ausgelöst (:287–291): der Lese-Schritt und der Trigger-Audit.
Die Paarungen fehlen in dieser Aufzählung; keine Stelle in `kurs/` oder `lab/`
ordnet sie außerhalb der Welle-Closure an.

**Szenario:** Repo ohne Wellen. `BEO-007` erreicht 3×, die Slice-Closure
verkörpert selbst und setzt das Pflichtfeld, das Ziel bekommt
`seit slice-047`.
Genau dieser Fall — der in dieser Runde neu eingeführte — ist der einzige, in
dem der geschärfte §7-Auslöser überhaupt feuern kann, und er wird nie geprüft,
weil Schritt 3 nie läuft.
Dasselbe gilt für die Register-Paarung (c): eine `BEO-<NNN>` ohne Registerzeile
fällt in einem wellenlosen Repo nie auf.

**Vorgeschlagene Richtung:** die drei Paarungen in denselben Satz aufnehmen,
der Lese-Schritt und Trigger-Audit dem wellenlosen Repo zuweist.
Das ist keine neue Regel, sondern dieselbe, konsequent zu Ende geführt.

### R7-05 — Satzfragment (Fehlerklasse: zerrissener Satz)

`kurs/de/02-planung/modul-06-roadmap.md` :369–373:

> … wird dort zur verkörperten Regel — ohne laufende Welle beim eigenständig
> ausgelösten Lese-Schritt, Anker dann `seit slice-<NNN>`. Mit Herkunfts-Anker
> ([…] §Herkunfts-Anker).

Die Einfügung hat den Originalsatz („… wird dort zur verkörperten Regel — mit
Herkunfts-Anker ([Link]).") aufgetrennt.
Übrig bleibt „Mit Herkunfts-Anker ([Link])." als verbloses Fragment mit
Großschreibung und Punkt; der Verweis auf §Herkunfts-Anker hängt an keinem
Satz mehr.

### R7-06 — Widerspruch in benachbarten Sätzen

`kurs/de/02-planung/modul-06-roadmap.md` :284–287:

> … **Zähler und Lese-Schritt sind davon ausgenommen**: Der Zähler läuft im
> Beobachtungs-Register mit jeder Slice-Closure weiter …, unabhängig davon, ob
> je eine Welle geschnitten wurde. Was ohne Welle wartet, ist nicht das Zählen,
> sondern der **Lese-Schritt**.

Satz 1 nimmt den Lese-Schritt ausdrücklich aus der Wellen-Abhängigkeit aus;
Satz 2 sagt, er sei genau das, was ohne Welle *wartet*.
Satz 2 ist der stehengebliebene Rest der Fassung vor L1; Satz 3 („löst ihn
eigenständig aus") hebt ihn wieder auf.
Der Spiegel `lab/regelwerk/modul-06-roadmap.md` :38 trägt die Aussage korrekt
ohne diesen Satz.

### R7-07 — Falsches Subjekt und umgedrehter Beleg

`kurs/de/02-planung/modul-05-planning-harness.md` :63–64:

> `done` ist dabei **kein Endzustand der Information**: Die Closure-Notiz
> wandert bei der Slice-Closure ins Beobachtungs-Register (Notiz im Diagramm).

Zweierlei falsch: Nicht die *Closure-Notiz* wandert ins Register — sie bleibt
in der Slice-Datei; eingetragen werden die Beobachtungen aus §7 (die
Diagramm-Notiz sagt es korrekt: „§7 → Beobachtungs-Register").
Und der Satz belegt „`done` ist kein Endzustand" mit einem Vorgang, der laut
`lab/templates/docs/plan/planning/slice.template.md` :114–115 **vor** dem
`git mv` nach `done/` stattfindet.

### R7-08 — Entscheidungsraute mit nur einem Ausgang

`kurs/de/grundlagen/konventionen.md` :885–888:

```
V --> C{"Wie oft?"}
C -- "3x" --> E["Verkörperung…"]

V -- "1x / 2x: bleibt offen" --> F["Wellen-Eröffnung Schritt 2:…"]
```

Beim Umbau wurde der alte Knoten `D` entfernt und die Kante
`C -- "1x / 2x" --> D` durch `V -- … --> F` ersetzt.
Dadurch führt die Raute `C{"Wie oft?"}` nur noch **einen** Zweig, und der
Gegenzweig entspringt am Register-Knoten `V` und umgeht die Verzweigung.
Wer der Frage „Wie oft?" mit „2×" folgt, steht in einer Raute ohne Ausgang.
Die 1×/2×-Kante gehört an `C`.

### R7-09 — Zeiger in `welle.template.md` brechen durch den `git mv`, den derselbe Schritt anordnet

`lab/templates/docs/plan/planning/welle.template.md` :83–88 (§7, „Erst nach
Welle-Abschluss füllen"):

> Zeiger auf die Ergebnis-Notiz `done/welle-<NN>-results.md` … inklusive des
> Zeigers aufs Beobachtungs-Register (`observations.md`)

Dieselbe Datei sagt :10–12, dass sie bei Closure per `git mv` nach `done/`
wandert; die Norm ebenso (`kurs/de/02-planung/modul-06-roadmap.md` :477).
Der Ruheort dieser Datei ist also `done/`.
Von dort lösen die beiden Angaben nach `done/done/welle-<NN>-results.md` und
`done/observations.md` auf — beides existiert nicht.
Korrekt vom Ruheort wären das Geschwister `welle-<NN>-results.md` und ein
Verweis eine Ebene höher.

Der Diff hat hier `../done/…` (falsch von flach **und** von `done/`) durch
`done/…` ersetzt: richtig für den Schreibmoment, falsch für jeden Leser danach.

### R7-10 — Das Vorbild nennt den falschen Prüfzeitpunkt

`lab/example/docs/plan/planning/done/welle-1-results.md` :27–28:

> Eine **geschärfte Regel** nennt ihren **Zielort**, und das Ziel trägt den
> Herkunfts-Anker `seit welle-1` — **die Paarung wird im Trigger-Audit
> mitgeprüft**.

Der Trigger-Audit ist Schritt **2** (`kurs/de/02-planung/modul-06-roadmap.md`
:427).
Die Norm schließt das ausdrücklich aus (:484–486): „erst *jetzt* …, weil sie
die Einträge prüfen, die in diesem Schritt gerade entstanden sind; **in
Schritt 2 gäbe es sie noch nicht**."

**Szenario:** Der Leser des Vorbilds baut sein Gate in den Trigger-Audit und
prüft dort Einträge, die erst einen Schritt später geschrieben werden.
Ergebnis: grün, weil leer.
Derselbe Satz trägt zusätzlich die semantische Fassung aus R7-01.

---

## Weitere Befunde

### R7-11 — Zeitpunkt-Rest im Slice-Template

`lab/templates/docs/plan/planning/slice.template.md` :97 („## 7. Closure-Notiz
(bei Closure zu füllen)") und :100 („vor dem `git mv` nach `done/`") gegen den
unveränderten Platzhalter :133:

> `<!-- Erst nach Abschluss füllen. -->`

Wer nur den Marker direkt über dem auszufüllenden Feld sieht, füllt nach dem
`git mv` — und schreibt den Register-Eintrag außerhalb des Fensters, das diese
Runde gerade definiert hat.

### R7-12 — Der PFLICHTSCHRITT kennt keinen Null-Fall

`lab/templates/docs/plan/planning/slice.template.md` :114–120 kennt genau zwei
Zweige: „existiert die Beobachtung dort schon → Zähler +1 …; **sonst** → neue
`BEO-<NNN>` vergeben".
Ein dritter Zweig „keine Beobachtung angefallen → nichts eintragen" fehlt,
obwohl jede vergleichbare Stelle ihren Null-Fall benennt: Modul 6 :401–402
(„Ist es leer, ist *das* die Antwort"), dasselbe Template :157–158 („Keine
Treffer sind ebenfalls eine Antwort"), `observations.template.md` :38–39
(„Keine offenen Beobachtungen? Dann ‚— keine —' eintragen").

**Szenario:** Ein Slice schließt mit einem Lerneintrag der Klasse *benannte
Spec-Lücke* — laut `welle-results.template.md` :51 ausdrücklich **keine**
Beobachtung, weil sie eine `LH-*`-ID trägt.
Wer den PFLICHTSCHRITT stur liest, muss „sonst" befolgen und eine `BEO-<NNN>`
erfinden.
Das Register bekommt eine Zeile, die nie ein zweites Mal auftreten kann, und
der Zähler wird mit Rauschen verdünnt.

### R7-13 — Der Register-Pflichtschritt steht in keiner Checkliste

Der Schritt heißt „PFLICHTSCHRITT", steht aber nur im HTML-Kommentar.
Die DoD-Checkliste `lab/templates/docs/plan/planning/slice.template.md` :43–44
führt „Closure-Notiz mit Steering-Loop-Lerneintrag" und „Jedes Risiko aus §6
trägt einen Ausgang" — kein Register-Item.
Der Übergang nach `done/` ist damit erfüllbar, ohne das Register anzufassen:
genau die Bruchstelle, gegen die die Verlagerung des Zählers gebaut wurde, nur
eine Ebene tiefer.

### R7-14 — Der Spiegel verliert den Ziel-Form-Verweis für den wellenlosen Fall

Quelle `kurs/de/grundlagen/konventionen.md` :838–841:

> … und — für wellenlos verkörperte Regeln — in §7 jeder
> `done/slice-<NNN>.md`; **die kanonischen Formen liefern
> `welle-results.template.md` bzw. `slice.template.md` §7.**

Spiegel `lab/regelwerk/grundlagen-konventionen.md` :809–816 übernimmt die
Ortsangabe, lässt den Halbsatz zu den kanonischen Formen weg — und die einzige
Ziel-Form-Zeile des Abschnitts (:837–839) nennt nur `welle-results.template.md`.

Ein Adopter mit nur dem Bundle liest, dass das Pflichtfeld für wellenlos
verkörperte Regeln in §7 des Slice steht, bekommt für dessen kanonische Form
aber ausschließlich die Welle-Vorlage gezeigt.

### R7-15 — Zwei Namen für dasselbe Pflichtfeld

`lab/regelwerk/grundlagen-konventionen.md` :812 benennt das Feld formal
(„durch das Pflichtfeld `liegt in <Pfad>`"), der Ziel-Form-Zeiger 26 Zeilen
später (:838) nennt es weiter *Zielort*.

### R7-16 — CHANGELOG zitiert das Lernziel mit dem falschen Verb

`CHANGELOG.md` :79–81 zitiert wörtlich:

> „benennen, wo der Steering-Loop-Zähler geführt wird und wer ihn schreibt
> bzw. liest"

`kurs/de/02-planung/modul-06-roadmap.md` :30 lautet „… und *einordnen*, wo …".
Das Verb trägt die Bloom-Stufe — `benennen` ist Erinnern, `einordnen`
Analysieren — bei einem LZ, das der Eintrag selbst als „LZ 2 / Analysieren"
führt.
Die Korrektur des Verbs war Teil von Runde 6; das Zitat im CHANGELOG blieb
zurück.

### R7-17 — CHANGELOG zählt die Register-Zeilen falsch

`CHANGELOG.md` :84–87: „Die **drei** realen Zeilen … dazu neu `BEO-005` … und
`BEO-006`" — 3 + 2 = 5.
`lab/example/docs/plan/planning/observations.md` trägt **sechs** Zeilen;
`BEO-004` (aus `slice-020` §7, ebenfalls neu in dieser Welle) kommt in der
Aufzählung nicht vor.

### R7-18 — Rubrik-Kriterium ohne Deckung im Lösungsblock

Rubrik `kurs/de/02-planung/modul-06-roadmap.md` :597 verlangt für *exzellent*
zusätzlich:

> … **und die `BEO-<NNN>` macht die Zählung unabhängig vom Wortlaut der
> Bezeichnung.**

Der als „exzellent" markierte Block `kurs/de/loesungen/modul-06-loesung.md`
:195–199 enthält diesen Halbsatz nicht.

### R7-19 — Einfügung unter der falschen Überschrift

`lab/templates/docs/plan/planning/README.template.md` :23 deklariert
„## Slices vs. Wellen — **zwei** Status-Mechanismen" (Slice = Verzeichnis,
Welle = `Status:`-Feld).
Der neue dritte Bullet :35–38 beschreibt kein Status-Konstrukt, sondern eine
Layout-Angabe.
Im Zwilling `lab/example/docs/plan/planning/README.md` :32–35 steht derselbe
Text korrekt als eigener Absatz außerhalb dieser Systematik.

### R7-20 — Auszug-Kommentar unvollständig

`kurs/de/02-planung/modul-06-roadmap.md` :322: `<!-- Auszug: BEO-002..004 hier
weggelassen -->`.
Im gezeigten Register fehlt auch `BEO-006`
(`lab/example/docs/plan/planning/observations.md` :19).

---

## Vorbestehend — nicht aus diesem Diff

Beide Zeilen sind von den Nacharbeiten nicht berührt und daher nicht Teil der
Befundzählung.

- `kurs/de/02-planung/modul-05-planning-harness.md` :56 und
  `lab/regelwerk/modul-05-planning-harness.md` :27: „**Drei Übergänge** sind
  nichttrivial: `in_progress → next` (…) **und** `in_progress → open` (…)" —
  genannt werden zwei, der dritte folgt erst im nächsten Satz.
- `lab/templates/docs/plan/planning/README.template.md` :28–29: „ihr Status
  lebt im `Status:`-Feld, nicht im Verzeichnis. Ein **optionaler** Welle-Plan
  liegt flach …" — gegen `kurs/de/02-planung/modul-06-roadmap.md` :478–479
  („Der Zustand ist die Verzeichnis-Position, kein `Status`-Feld") und gegen
  Eröffnungs-Schritt 3 („Welle-Datei flach anlegen", nicht optional).

## Design-Beobachtung, kein Textfehler

Die Register-Paarung prüft nur „zitierte `BEO-<NNN>` → Zeile" und „Zeile →
nicht-leere Belege" (`kurs/de/02-planung/modul-06-roadmap.md` :360–362).
Dass ein Beleg als Datei *existiert*, prüft nichts — anders als bei der
Folge-Slice-Paarung.
Im `lab/example` haben 5 von 7 genannten Belegen keine Datei
(`slice-005`, `-006`, `-008`, `-011`, `-012`); das ist durch
`lab/example/docs/plan/planning/README.md` :29–31 gedeckt („nur exemplarisch
vertreten"), zeigt aber, dass die Belegspalte frei erfindbar bleibt.
Kandidat für das Beobachtungs-Register, nicht für eine Sofortmaßnahme.

---

## Geprüft und ohne Befund

- **Pfad-Korrektheit der Slice-/Register-Strecke.** Der Verweis aus
  `slice.template.md` :90, :114 und :153 löst aus jedem der vier
  Lifecycle-Verzeichnisse (`open/`, `next/`, `in-progress/`, `done/`) auf
  dieselbe Registerdatei auf — die Slice-Datei wandert durch alle vier
  Positionen, ohne dass der Verweis bricht.
  `welle-results.template.md` :57 und :88 sind aus `done/` korrekt; die realen
  Vorkommen in `lab/example` verwenden dieselbe Form.
- **Anker.** Quelle `## Das Beobachtungs-Register` → `#das-beobachtungs-register`;
  Spiegel `### Das Beobachtungs-Register (Modul 6)` →
  `#das-beobachtungs-register-modul-6`.
  Alle sieben neuen Verweise (Modul 1, 5, 10, Konventionen,
  `lab/templates/README.md`, beide Spiegel) benutzen die richtige Variante.
- **Register-Paarung im Vorbild, beide Richtungen.** In `done/` zitiert:
  `BEO-002`, `BEO-004`, `BEO-005`, `BEO-006`; im Register: `BEO-001` bis
  `BEO-006`.
  Jede zitierte Kennung hat eine Zeile, jede Zeile eine nicht-leere
  Belegspalte.
  Auch die Anker-Paarung hält **inhaltlich**: `welle-1-results.md` :32 nennt
  §2.7, und `lab/example/AGENTS.md` :78 trägt dort `(seit welle-1)`.
  Sie scheitert nur an der Form (R7-03).
- **Netzlosigkeit.** Kein geänderter Spiegel- oder Template-Abschnitt verweist
  auf Kurs-Material, das nicht mitreist.
- **Zahlwörter.** Nachgezählt: „sechs Spalten" (6), „alle drei Paarungen"
  (a/b/c), „Zwei Sensoren" (2), „Fünf Schritte" (5), „Eröffnung braucht drei"
  (3), „Vier neue Begriffe" (4), „drei Bruchstellen" (3), „drei Quellen" (3),
  „18 Dokument-Skelette / 22 Dateien" gegen das Verzeichnis, „drei
  Vorbild-Closures" gegen `done/`.
- **Reihenfolgen.** Selbstcheck (9 Items) ↔ Rubrik (9 Zeilen) ↔ Lösungsdatei
  deckungsgleich; Übungen ↔ Übungshinweise ebenso.
- **Quelle ↔ Spiegel** für Modul 5, 9, 10, 13 und die Konventionen, inklusive
  der in Runde 6 verlorenen und seither wiederhergestellten Regel „Wer nur
  wellenlos arbeitet, löst den Trigger-Audit eigenständig aus"
  (`lab/regelwerk/modul-06-roadmap.md` :38).
- **Code-Fences** paarig, Mermaid-Blöcke geschlossen, Tabellen
  spaltenzahl-korrekt.

---

## Behebung

**2026-07-28**, in der empfohlenen Reihenfolge (R7-01 zuerst, dann R7-04, dann
die übrigen). Gates danach: `make check` grün (`docs-check` 0 ERROR / 0 WARN,
`alignment-check` 0 WARN), `lab/example` `make verify` grün.

| Befund | Was geändert wurde |
|---|---|
| R7-01 | Anker-Paarung (a) in `modul-06-roadmap.md` und im Spiegel auf den **Form**-Auslöser `liegt in <Pfad>` umgestellt; Eintrag ohne Feld ausdrücklich ausgenommen. Damit stimmt auch die Vollständigkeits-Behauptung im `CHANGELOG.md`. |
| R7-02 | `slice.template.md` §7: Folge-Slice-Zeile auf die Formulierung der Schwesterdatei (*„ist eine Datei in"*) umgestellt, mit Begründung im Kommentar. Quelle und Spiegel gleich mitgezogen. |
| R7-03 | `welle-1-results.md` :32 auf die kanonische Form gebracht (Backticks statt Markdown-Link, `§2.7` innerhalb des Zielorts). `welle-results.template.md`: Feld und Pfad stehen auf **einer** Zeile, mit explizitem Hinweis. |
| R7-04 | `modul-06-roadmap.md` §Wann Arbeit eine Welle braucht + Spiegel: das wellenlose Repo löst neben Lese-Schritt und Trigger-Audit auch **alle drei Paarungen** eigenständig aus. Dazu ein Hinweis an der Arbeitsstelle in `slice.template.md` §7. |
| R7-05 | Satz wieder zusammengeführt: Herkunfts-Anker zurück an den Hauptsatz, der wellenlose Fall als eigener Satz. |
| R7-06 | Der stehengebliebene Satz *„Was ohne Welle wartet … der Lese-Schritt"* ist entfernt. |
| R7-07 | `modul-05-planning-harness.md`: Subjekt korrigiert (Beobachtungen aus §7, nicht die Closure-Notiz) und der Beleg umgedreht — `done` ist kein Endzustand, weil **von dort weitergelesen** wird. |
| R7-08 | Die `1× / 2×`-Kante entspringt wieder an der Raute `C`, nicht am Register-Knoten `V`. |
| R7-09 | `welle.template.md` §7: Pfade vom **Ruheort** aus (`welle-<NN>-results.md` als Geschwister, das Register eine Ebene höher), mit Begründung. |
| R7-10 | `welle-1-results.md`: Prüfzeitpunkt auf *Ende von Closure-Schritt 3* korrigiert, Trigger-Audit ausdrücklich ausgeschlossen; zugleich auf die Form-Fassung aus R7-01 umgestellt. |
| R7-11 | Der Platzhalter unter §7 nennt jetzt denselben Zeitpunkt wie Überschrift und Kommentar (*vor* dem `git mv`). |
| R7-12 | Der PFLICHTSCHRITT hat einen dritten Zweig: keine Beobachtung → nichts eintragen; die benannte Spec-Lücke zählt ausdrücklich nicht. |
| R7-13 | Neues DoD-Item in `slice.template.md` §2 für das Beobachtungs-Register, inklusive Null-Fall. |
| R7-14 | Der Spiegel nennt beide kanonischen Formen — `welle-results.template.md` für die Welle-Closure, `slice.template.md` §7 für den wellenlosen Fall. |
| R7-15 | Der Ziel-Form-Zeiger im Spiegel benennt das Feld wie die Definition (`liegt in <Pfad>` statt *Zielort*). |
| R7-16 | `CHANGELOG.md` zitiert das Lernziel wieder mit `einordnen`. |
| R7-17 | `CHANGELOG.md`: `BEO-004` ergänzt, Summe (sechs Zeilen) explizit. |
| R7-18 | Der `BEO-<NNN>`-Halbsatz steht jetzt im *exzellent*-Block von `modul-06-loesung.md`. |
| R7-19 | Der dritte Bullet steht als eigener Absatz außerhalb der Slice-vs-Welle-Systematik — wie im Zwilling `lab/example`. |
| R7-20 | Auszug-Kommentar nennt auch `BEO-006`. |
| vorbestehend 1 | „Drei Übergänge" nennt jetzt drei (`in_progress → done` ergänzt) — Quelle und Spiegel. |
| vorbestehend 2 | `README.template.md`: Welle-Zustand ist die Verzeichnis-Position, kein `Status:`-Feld; der Welle-Plan ist nicht optional. Überschrift entsprechend („zwei Ablagen, dieselbe Regel"). |

**Offen:** die Design-Beobachtung (Belegspalte der Register-Paarung ist frei
erfindbar). Sie ist kein Textfehler und hat in diesem Repo keinen Register-Ort.

**Empfohlen:** eine achte Runde — die sieben vorangegangenen haben je
Reparatur neue Fehler derselben fünf Klassen erzeugt.
