# Review-Runde 8 — die Reparaturen der Runde 7

**Stand:** 2026-07-28. **Status:** vollständig behoben — siehe
[§Behebung](#behebung) am Ende.

**Gegenstand:** der Diff `adef210..ade3d67` — die Nacharbeiten zu Welle 59
plus die Reparaturen aus [Runde 7](review-runde-7.md) (dort abgelegt,
vollständig behoben; diese Datei führt ab hier den offenen Stand).

**Verfahren:** wie in den Vorrunden drei unabhängige Reviewer mit getrennten
Linsen — (1) Satz- und Struktur-Integrität innerhalb jeder Datei,
(2) Kongruenz zwischen Quelle, Spiegel, Template, Lösung, Lab-Vorbild und
CHANGELOG, (3) Mechanik-Tauglichkeit („funktioniert die Regel, wenn ein
Adopter sie wörtlich befolgt?").
Die Nummerierung ist beim Zusammenführen neu vergeben; wo mehr als eine Linse
denselben Defekt unabhängig fand, ist das vermerkt.

**Umfang:** 25 Befunde, dazu 2 vorbestehende Defekte.
**Davon 12 neu erzeugt durch die Reparaturen der Runde 7** — die Prognose der
Vorrunde („je Reparatur neue Fehler derselben fünf Klassen") hat sich erneut
bestätigt.

**Gates zum Zeitpunkt des Reviews:** `make check` grün (d-check 0 Befunde,
`docs-check` 0 ERROR / 0 WARN, `alignment-check` 0 WARN), `lab/example`
`make verify` grün. Kein Befund dieser Runde ist maschinell sichtbar.

**Korrektur an Runde 7:** Der Befund R7-02 stützte sich auf die Annahme,
„gelöscht werden soll laut Template nur der Kopfblock; die §7-Guidance-Kommentare
bleiben ausdrücklich stehen". Das ist falsch —
`lab/templates/README.md` :64–67 ordnet an, **alle** HTML-Kommentare zu
entfernen. Die Reparatur zu R7-02 bleibt richtig, ihre Begründung war es nicht;
der eigentliche Defekt ist R8-01.

---

## Blocker

### R8-01 — Die gesamte neue Normlast steht in Kommentaren, die das Bundle zu löschen anordnet

*(Linse 3; Linse 1 fand denselben Defekt unabhängig als internen Widerspruch.)*

`lab/templates/README.md` :64–67, Schritt 5 der *Verwendung*:

> 5. **HTML-Kommentar-Hilfen entfernen** (`<!-- ... -->`) — **außer**
>    `<!-- d-check:ignore … -->`-Marker …

Die Runde-7-Reparaturen haben praktisch die gesamte neue Normlast in genau
diese Kommentare gelegt — `lab/templates/docs/plan/planning/slice.template.md`
§7:

- :107–110 das **PFLICHTFELD** samt kanonischer Form,
- :115–117 „OHNE LAUFENDE WELLE … die drei Paarungen direkt hier prüfen"
  (Reparatur zu R7-04),
- :118–130 der **PFLICHTSCHRITT** mit allen drei Zweigen (Reparatur zu R7-12),
- :136–137 die Warnung „Bewusst NICHT `liegt in`" (Reparatur zu R7-02),
- :145–146 der Zeitpunkt-Hinweis (Reparatur zu R7-11).

**Szenario:** Ein Adopter kopiert das Template, führt Schritt 5 aus und schließt
den Slice Wochen später. Von §7 steht dann nur noch die leere Überschrift da.
Er erfährt nirgends mehr, dass es ein Pflichtfeld `liegt in` gibt, wie dessen
kanonische Form aussieht, dass er ohne Welle die Paarungen selbst prüfen muss
oder dass es einen Null-Fall gibt. Übrig bleibt einzig das DoD-Item :44.

Dass die Löschung real erfolgt, belegt das eigene Vorbild: **kein** Artefakt in
`lab/example/docs/plan/planning/` trägt einen Guidance-Kommentar.
Die Schwesterdatei zeigt die vermeidbare Asymmetrie erneut:
`welle-results.template.md` :60–61 hält das Pflichtfeld als **Body-Zeile** —
die überlebt Schritt 5.

**Interner Widerspruch als Symptom** (Linse 1): Derselbe Kommentarblock schreibt
:110 die Form `liegt in \`<AGENTS.md §X | …>\`` aus und begründet :136, man
verwende sie bewusst *nicht*, weil sie den Sensor auslöse. Entweder ist :110
harmlos — dann ist die Begründung :136 falsch; oder :136 stimmt — dann ist :110
derselbe Defekt an anderer Stelle.

### R8-02 — Der Sensor-Geltungsbereich `done/slice-<NNN>.md` trifft keine einzige reale Datei

*(Linse 3)*

Neu in diesem Diff, `kurs/de/grundlagen/konventionen.md` :838–841 (ebenso :823–824
und Spiegel `lab/regelwerk/grundlagen-konventionen.md` :801, :812):

> … und — für wellenlos verkörperte Regeln — in §7 jeder `done/slice-<NNN>.md`

Die verbindliche Namensform ist eine andere — `slice.template.md` :4:
„Kopiere nach `docs/plan/planning/open/slice-<NNN>-<kurzer-titel>.md`".
Real: `done/slice-009-tie-break-determinismus.md`,
`done/slice-020-referenz-richtung-repariert.md`.

**Szenario:** Der Adopter baut den Sensor nach der Norm und scannt
`done/slice-[0-9][0-9][0-9].md` — null Treffer, grün, obwohl der wellenlose
Verkörperungsfall der einzige ist, für den dieser Zweig existiert. Dieselbe
Angabe trägt der Retirement-Check: `seit slice-047` soll „in einem Hop" über
`done/slice-047.md` auflösen; die Datei heißt `slice-047-<titel>.md`.
Bei `welle-<NN>-results.md` stimmt die Angabe exakt — die Asymmetrie ist nicht
durchdacht.

### R8-03 — „Die Lifecycle-Verzeichnisse durchläuft er nicht" hebt den vorangehenden Satz auf

*(Linse 1; erzeugt in Runde 7, Reparatur des vorbestehenden Defekts 2)*

`lab/templates/docs/plan/planning/README.template.md` :27–31:

> Der Welle-Plan … wandert bei Closure per `git mv` nach `done/` … **Die
> Lifecycle-Verzeichnisse durchläuft er nicht.**

`done/` **ist** ein Lifecycle-Verzeichnis — dieselbe Datei führt es :8 und in
der Tabelle :21, und der Bullet :35–39 sagt ausdrücklich, dass `done/` den
Welle-Plan aufnimmt. Gemeint ist „den aktiven Durchlauf durchläuft er nicht".

### R8-04 — Die maschinelle Hälfte der Register-Paarung ist in Spiegel und CHANGELOG ein anderer Sensor

*(Linse 2)*

Quelle `kurs/de/02-planung/modul-06-roadmap.md` :363–365 und
`observations.template.md` :43–45:

> ein Gate meldet, wenn eine in `done/` zitierte `BEO-<NNN>` keine Registerzeile
> hat **oder eine Registerzeile keinen Beleg**

Spiegel `lab/regelwerk/modul-06-roadmap.md` :81 und `CHANGELOG.md` :63–64:

> ob eine in `done/` zitierte `BEO-<NNN>` eine Registerzeile hat **und umgekehrt**

„Und umgekehrt" heißt *jede Registerzeile ist in `done/` zitiert* — ein anderer
Sensor als *jede Zeile hat einen Beleg*.

**Szenario:** Der Adopter mit nur dem Bundle implementiert den Spiegel. Sein
Gate läuft am Kurs-Vorbild rot: `BEO-001` und `BEO-003` sind in keiner
`done/`-Datei zitiert. Dieselbe Klasse wie R7-01, eine Ebene tiefer.

Zusatz: Die Quelle ist mit sich selbst uneins — :364 nennt „Zeile ohne Beleg"
die maschinelle Hälfte von **(c)**, aber (c) in Closure-Schritt 3 (:498–501)
kennt nur die Richtung *zitierte `BEO` → Zeile*.

### R8-05 — Die benannte Spec-Lücke ist in der Quelle „gezählt", im Template „zählt NICHT"

*(Linse 2; erzeugt in Runde 7, Reparatur zu R7-12)*

Quelle `konventionen.md` :843–844, Modul 6 :494–496, Spiegel und Vorbild
`welle-1-results.md` :30–32 sagen von dieser Klasse übereinstimmend:

> *gezählt, nicht verkörpert* und kein Gegenstand der Paarung

Template `slice.template.md` :120–125 (neu):

> Ebenso zaehlt eine benannte Spec-Luecke NICHT: sie traegt ihre LH-*-ID

**Widerspruch:** „gezählt" heißt, die Beobachtung hat eine `BEO-<NNN>`-Zeile
durchlaufen — nur keine Verkörperung. Der neue dritte Zweig verbietet für
dieselbe Klasse jeden Registereintrag; damit kann sie die 3×-Schwelle nie
erreichen, obwohl sie in Modul 5, Modul 6 und `welle-results.template.md`
:45–46 als eine der **drei gleichrangigen** Lerneintrags-Klassen geführt wird.

Die Runde-7-Befunde R7-12 und die Runde-8-Linse lesen dieselbe Normstelle
gegensätzlich. **Das ist vor der Reparatur zu entscheiden, nicht per Mehrheit:**
Bekommt eine benannte Spec-Lücke eine `BEO-<NNN>` oder nicht? Das Vorbild sagt
implizit *nein* (`welle-1-results.md` :35 führt sie als Steering-Loop-Eintrag,
`observations.md` hat keine Zeile dafür) — dann ist „gezählt" in der Quelle das
Falsche.

---

## Weitere Befunde

### R8-06 — Die wellenlose Paarungs-Anordnung hängt an einer Bedingung, die im Normalfall „nein" ist

*(Linse 3; erzeugt in Runde 7, Reparatur zu R7-04)*

`slice.template.md` :104–117 ist **ein** Bullet: Die Anordnung „dann die drei
Paarungen direkt hier prüfen" steht als Fortsetzung der Frage „Wurde die Regel
HIER verkörpert?". Die Register-Paarung (c) und die Folge-Slice-Paarung (b)
betreffen aber *jede* wellenlose Closure — Modul 6 :502–504 bindet (c) an
„jede in einer Closure-Notiz **oder in einem Risiko-Ausgang** genannte
`BEO-<NNN>`".

**Szenario:** Wellenloses Repo, `slice-021` schließt mit `BEO-007` im
Risiko-Ausgang, ohne jede Verkörperung. Die Frage ist „nein" → der ganze Absatz
ist gegenstandslos → die dangling `BEO-007` fällt nie auf. Genau der Fall, den
R7-04 schließen sollte.

Dazu die R7-13-Klasse neu erzeugt: Die DoD-Liste :39–45 hat ein Item für das
Register, aber **keines für die drei Paarungen**.

### R8-07 — Widersprüchlicher Prüfzeitpunkt: „direkt hier" liegt vor dem `git mv`, der Sensor scannt `done/`

*(Linse 3; erzeugt in Runde 7)*

`slice.template.md` :98/:101/:119/:145 — §7 wird **vor** dem `git mv` gefüllt.
:116–117 — die Paarungen „**direkt hier** nach der Closure prüfen".
Modul 6 :290–292 — „unmittelbar nach der Slice-Closure", also **nach** dem
`git mv`.

**Szenario:** Der Adopter prüft die Anker-Paarung, während er §7 schreibt. Die
Datei liegt noch in `in-progress/`; der Sensor scannt `done/` → grün, weil leer.
R7-10-Klasse, eine Ebene tiefer.

### R8-08 — Meta-Anweisung im Artefakt-Rumpf statt im Kommentar

*(Linse 1 und Linse 3 unabhängig; erzeugt in Runde 7, Reparatur zu R7-03)*

`welle-results.template.md` :62–63:

> (Feld und Pfad stehen auf EINER Zeile — ein zeilenweiser Sensor greift sonst
> nicht; die Sektionsangabe steht INNERHALB der Backticks.)

Der Kommentarblock endet auf :58. Die Klammer ist gerenderter Inhalt, weder
`<Platzhalter>` noch Kommentar — sie überlebt Schritt 3 **und** Schritt 5.
Die veröffentlichte Closure-Notiz trägt damit eine Sensor-Bauanleitung mitten
im Eintrag, und zwar zwischen `liegt in` und `Auslöser:`.

### R8-09 — Die Deixis „davon" hängt nach dem R7-06-Umbau in der Luft

*(Linse 1; erzeugt in Runde 7)*

`kurs/de/02-planung/modul-06-roadmap.md` :280–285:

> Offen bleibt die **Carveout-Frist**: Sie misst in Wellen … **Zähler und
> Lese-Schritt sind davon ausgenommen**

Der Satz, auf den „davon" zeigte (die Wellen-Abhängigkeit), ist beim Entfernen
des Widerspruchs entfallen. Gelesen wie geschrieben: ausgenommen von der
*Carveout-Frist*.

### R8-10 — Der Spiegel-Bullet „Was offen bleibt" listet überwiegend, was nicht offen bleibt

*(Linse 1; erzeugt in Runde 7)*

`lab/regelwerk/modul-06-roadmap.md` :38 trägt nach der Ergänzung vier Dinge,
die ausdrücklich **nicht** offen bleiben (Zähler, Lese-Schritt, Trigger-Audit,
drei Paarungen). In der Quelle wurde die Überschrift dafür auf „Was der
wellenlose Betrieb selbst auslöst — und was offen bleibt" umgestellt; im
Spiegel blieb das alte Label stehen. Dieselbe „davon"-Deixis wie R8-09.

### R8-11 — „Drei Übergänge" nennt den dritten und führt ihn im Folgesatz erneut ein

*(Linse 1; erzeugt in Runde 7, Reparatur des vorbestehenden Defekts 1)*

`kurs/de/02-planung/modul-05-planning-harness.md` :56–59 und Spiegel :28–31:
Die Aufzählung nennt jetzt `in_progress → done`, der Folgesatz stellt „**Der
einzige Übergang** nach `done`" ein zweites Mal als neu vor. Nebeneffekt: der
Happy Path steht als „nichttrivial" neben den beiden Rückführungen, deren
Ausnahmecharakter das Wort trug.

### R8-12 — Zwei Leser aufgezählt, der zweite liest nicht „von dort"

*(Linse 1; erzeugt in Runde 7, Reparatur zu R7-07)*

`kurs/de/02-planung/modul-05-planning-harness.md` :64–68: Die Reihe nach dem
Gedankenstrich koppelt eine Präpositionalgruppe („vom Lese-Schritt …") mit
einem Hauptsatz, dessen Inhalt kein Leser *des Registers* ist — der
Herkunfts-Anker zeigt auf §7 in `done/`, nicht ins Register.

### R8-13 — Das Vorbild trägt weiter den alten Zeitpunkt, den R7-11 repariert hat

*(Linse 3; in Runde 7 übersehen)*

`lab/example/docs/plan/planning/in-progress/slice-013-property-tests.md` :51 und
`open/slice-014-ann-suche.md` :51 tragen wörtlich
`<!-- Erst nach Abschluss füllen. -->` — den Platzhalter, der im Template zu
„bei der Closure, vor dem `git mv`" geworden ist. `lab/templates/README.md`
Schritt 6 schickt den Adopter ausdrücklich zum Vergleich nach `lab/example/`.

### R8-14 — Der Welle-Plan ist jetzt Pflicht, und das Vorbild hat keinen

*(Linse 3; erzeugt in Runde 7, Reparatur des vorbestehenden Defekts 2)*

`README.template.md` :27–31 und Modul 6 :481–482 machen den Welle-Plan
verbindlich und lassen ihn bei Closure nach `done/` wandern.
`lab/example/docs/plan/planning/done/` enthält `slice-009`, `slice-020` und
`welle-1-results.md` — **kein `welle-1-mvp.md`**. Der Freibrief in
`README.md` :27–30 („nur exemplarisch vertreten") deckt Slices, nicht
Nicht-Slice-Records.

### R8-15 — In einem wellenlosen Repo hat kein Eintrag unter 3× einen Leser

*(Linse 3)*

Modul 6 :280–295 zählt auf, was der wellenlose Betrieb eigenständig auslöst:
Zähler, Lese-Schritt, Trigger-Audit, alle drei Paarungen. Die **Wellen-Eröffnung
Schritt 2** fehlt — obwohl :393–395 von ihr sagt: „Das ist der Schritt, der das
Register auf der Planungsseite konsumiert — ohne ihn bleibt es dort ohne Leser."
`observations.template.md` :21–24 nennt zwei Leser und ersetzt in der Zeile
„OHNE WELLE:" nur einen. Der Fluss-Graph führt Schritt 2 als einzigen Ausgang
für Einträge unter Schwelle.

Der einzige Ersatzleser wäre `slice.template.md` §8 — der ist aber nur
Pflicht-Sektion bei BF/Hybrid; beide GF-Vorbild-Slices sichten nichts.

**Szenario:** Wellenloses Repo, alle Sub-Areas GF. `BEO-001` bei 2×,
`BEO-004` bei 1×. Niemand liest sie je — das Register ist für alles unter
Schwelle write-only, der Zustand, gegen den es gebaut wurde.

### R8-16 — Das Feld heißt `<Pfad>`, aber eine der drei kanonischen Füllungen ist keiner

*(Linse 3; teilweise vorbestehend)*

Kanonische Form: `liegt in \`<AGENTS.md §X | Makefile-Target | .harness/skills/…>\``.
Prüfvorschrift `konventionen.md` :845–846: „(1) **der Pfad existiert**".

Ein Eintrag „liegt in `coverage-floor`" ist formal korrekt und läuft rot —
genau die Selbstwiderlegung, die :844 vermeiden wollte. Bei
„liegt in `AGENTS.md §2.7`" muss der Sensor am ` §` splitten; diese Regel steht
nirgends. Für die Make-Target-Variante ist nicht gesagt, in welcher Datei nach
`seit welle-<NN>` zu suchen ist. Die neue Formangabe `konventionen.md` :804
(`coverage-floor: ## LH-QA-SUP-004 · seit slice-047`) belegt, dass die Variante
gemeint ist.

### R8-17 — Rubrik-Kriterium ohne Deckung im Lösungsblock (Tool-Pin-Zeile)

*(Linse 2)*

Rubrik `modul-06-roadmap.md` :601 verlangt für *solide* beide Hälften
(„eingetragen bei der Slice-Closure, **gelesen wird es bei der nächsten
Welle-Closure**"); `kurs/de/loesungen/modul-06-loesung.md` :106–112 nennt nur
das Eintragen und benennt keinen Leser. R7-18-Klasse — und ausgerechnet an der
Stelle, die „Jedes Artefakt hat einen Konsumenten" prüft.

### R8-18 — Der Lösungsblock (c) kennt den wellenlosen Zweig nicht, den (b) gerade eröffnet hat

*(Linse 1)*

`modul-06-loesung.md` :293–300: (b) hält fest, dass der Slice zu keiner Welle
gehörte; (c) antwortet ausnahmslos mit der Wellen-Fassung
(`seit welle-<NN>`, „bis zur nächsten Welle-Closure"). Dieselbe Datei lehrt
:195–197 das Gegenteil für genau diesen Fall.

### R8-19 — „Zielort" wird verneint, aber nirgends mehr definiert

*(Linse 1)*

`konventionen.md` :841–842 und Spiegel :814–815 verneinen den Terminus
(„eine bloße Erwähnung … ist *kein* Zielort"), der Mermaid-Knoten `E` :886 führt
ihn („Steering-Loop-Eintrag + Zielort") — eingeführt wird er seit der
R7-01-Reparatur nirgends mehr. R7-15-Klasse; behoben wurde damals nur der
Ziel-Form-Zeiger des Spiegels.

### R8-20 — „Zugleich" hängt nach dem Umbau am falschen Vorgang

*(Linse 1)*

`modul-06-roadmap.md` :478–481: „Er wird bei jeder **Slice-Closure**
fortgeschrieben … **Zugleich per `git mv` die Welle-Plan-Datei** …" — „Zugleich"
bindet jetzt an die Slice-Closure und behauptet den `git mv` bei jedem
geschlossenen Slice. Zusätzlich steht der Satz unter der Zwischenüberschrift
„Warum der Zähler ein eigenes Artefakt ist", mit der er nichts zu tun hat.

### R8-21 — Zwei Normänderungen dieses Diffs stehen in keinem Wellen-Register-Eintrag

*(Linse 2)*

`CHANGELOG.md` verzeichnet weder die Zustands-Regel-Umstellung in
`README.template.md` (`Status:`-Feld abgeschafft, Welle-Plan nicht mehr
optional) noch die „Drei Übergänge"-Korrektur. Beide sind nur in
[`review-runde-7.md` §Behebung](review-runde-7.md#behebung) festgehalten — das ist kein
kanonisches Register.

### R8-22 — `liegt in \`done/\`` ist im selben Modul die kanonische Form eines *Triggers*

*(Linse 3; PLAUSIBEL)*

„SL-024 **liegt in `done/`**" steht als Trigger-Beispiel in
`modul-06-roadmap.md` :58 und :598, im Spiegel :20 und :187 und in der Lösung
:31. Reale Instanz außerhalb der Lehre:
`lab/example/docs/plan/adr/0002-modellwahl-embedding.md` :34 („liegt in
`internal/embedding/`"). Formidentisch mit dem Auslöser der Anker-Paarung, der
:492 als *rein formal* definiert ist. Ohne exakten Sektions-Scope ist der
Auslöser nicht disambiguierbar — und beide Formen werden im selben Modul
gelehrt.

### R8-23 — `welle.template.md` stellt die Ruheort-Regel auf und bricht sie zwei Absätze später

*(Linse 3; PLAUSIBEL; erzeugt in Runde 7, Reparatur zu R7-09)*

Der Ziel-Form-Zeiger :92 (`[welle-results.template.md](welle-results.template.md)`)
ist ein flacher Geschwister-Link und folgt der gerade aufgestellten
Ruheort-Regel nicht. Nachrangig, weil er im Kommentar steht — siehe R8-01.

### R8-24 — Der Trigger-Audit wird „eigenständig ausgelöst", ohne dass ein Moment genannt ist

*(Linse 3; PLAUSIBEL; teilweise vorbestehend)*

Modul 6 :289–292 und Spiegel :38 benennen für die drei Paarungen jetzt einen
Moment („unmittelbar nach der Slice-Closure"); für den Trigger-Audit steht
weiterhin nur „eigenständig ausgelöst" — kein Zeitpunkt, kein Träger. Der
Kontrast entsteht neu dadurch, dass die Paarungen im selben Satz eine Kadenz
bekommen haben.

### R8-25 — Modul 9: der Spiegel paraphrasiert eine operative Formangabe

*(Linse 2; gering)*

`kurs/de/03-agenten/modul-09-implementierung.md` :148 („`(seit welle-<NN>)`
— **ohne Welle** `(seit slice-<NNN>)`") gegen Spiegel :154 („`(seit welle-<NN>)`
**bzw.** `(seit slice-<NNN>)`"). Modul 10 und Modul 13 setzen dieselbe
Ein-Zeilen-Änderung in Quelle **und** Spiegel wortgleich; nur Modul 9 weicht ab.

---

## Vorbestehend — nicht aus diesem Diff

- `kurs/de/grundlagen/konventionen.md` :896–898: Die Raute
  `J{"Regel entfernen oder lockern?"}` trägt nur den Zweig „ja". Wer „nein"
  folgt, steht in einer Raute ohne Ausgang — dieselbe Klasse wie R7-08, im
  selben Diagramm, aber von diesem Diff nicht berührt.
- Die Design-Beobachtung aus Runde 7 (die Belegspalte der Register-Paarung
  bleibt frei erfindbar) ist unverändert offen.

---

## Geprüft und ohne Befund

- **Der Form-Auslöser hält.** Alle 30 `liegt in`-Vorkommen im Repo einzeln
  gegen einen Matcher `liegt in ` + Backtick-Pfad geprüft: kein
  semantischer Rest („nennt einen Zielort") mehr in `kurs/` oder `lab/`;
  die R7-02-Umgehung in `slice.template.md` :136 ist sauber gelöst; die
  einzige reale Instanz `welle-1-results.md` :34 trifft und ist korrekt.
  Fehltreffer nur in den unter R8-01, R8-08 und R8-22 genannten Fällen.
- **Pfad-Strecken vom Ruheort.** Der Register-Verweis löst aus allen vier
  Lifecycle-Positionen auf; `welle.template.md` :84/:88 ist nach der
  R7-09-Reparatur vom Ruheort `done/` korrekt; `welle-results.template.md`
  :57/:90 ebenso; die sechs Ebenen aus `lab/example/…/done/slice-020…md`
  stimmen.
- **Entscheidungsraute (R7-08).** Beide Kanten entspringen jetzt an
  `C{"Wie oft?"}`, `V` hat genau einen Ausgang, der entfernte Knoten `D` ist
  auch aus dem `style`-Block raus, die Legende passt zur neuen Einfärbung.
- **Null-Fälle.** Der PFLICHTSCHRITT hat drei Zweige, „sonst" steht als
  dritter; keine Formulierung zwingt mehr zu einer erfundenen `BEO-<NNN>`
  (offen bleibt allein die Sachfrage aus R8-05).
- **Zahlwörter und CHANGELOG-Zählung.** „sechs Spalten", „sechs Zeilen
  insgesamt", „`BEO-001` bis `BEO-003`", „alle drei Paarungen", „Fünf
  Schritte", „Eröffnung braucht drei", „Drei Übergänge" (jetzt 3), „Alle fünf
  Übergänge", „18 Skelette / 22 Dateien", „drei Vorbild-Closures" — alle
  nachgezählt und korrekt. Das Lernziel-Zitat :80–81 steht wieder auf
  *einordnen*, `BEO-004` ist ergänzt.
- **Selbstcheck ↔ Rubrik ↔ Lösung ↔ Übungen.** 9 ↔ 9 ↔ 9, Reihenfolge
  deckungsgleich; das R7-18-Kriterium steht jetzt im *exzellent*-Block.
- **Anker.** `#das-beobachtungs-register` (Quelle) und
  `#das-beobachtungs-register-modul-6` (Spiegel) sind an jeder der elf
  geprüften Verweisstellen in der richtigen Variante benutzt; der
  Spiegel-Anker `#herkunfts-anker` ist durch ein explizites `<a id>` gedeckt.
- **Netzlosigkeit.** Kein geänderter Spiegel- oder Template-Abschnitt verweist
  auf Kurs-Material, das nicht mitreist.
- **Code-Fences** paarig, Mermaid-Blöcke geschlossen, alle Tabellen
  spaltenzahl-korrekt (maschinell über alle 27 geänderten Dateien geprüft).
- **Register-Paarung im Vorbild, beide Richtungen.** Zitiert: `BEO-002`,
  `BEO-004`, `BEO-005`, `BEO-006`; Register führt `BEO-001`–`BEO-006`, jede
  Zeile mit nicht-leerer Belegspalte. Kein dangling Verweis.

---

## Behebung

**2026-07-28**, in der empfohlenen Reihenfolge: zuerst die beiden Sachfragen
entschieden, dann R8-01, dann die übrigen. Gates danach: `make check` grün
(d-check 0 Befunde, `docs-check` 0 ERROR / 0 WARN, `alignment-check` 0 WARN),
`lab/example` `make verify` grün.

### Die zwei Entscheidungen vorab

**R8-05 — bekommt eine benannte Spec-Lücke eine `BEO-<NNN>`? Ja.** Sie ist eine
der **drei gleichrangigen** Lerneintrags-Klassen und durchläuft das Register wie
die anderen zwei. Was sie unterscheidet, ist allein der **Ort** der
Verkörperung: eine versionierte Spec (Lastenheft-Version, Folge-ADR) statt ein
Zielort im Repo. Ihr Gegenstück ist deshalb die `LH-*`-ID und nicht der
Herkunfts-Anker — sie ist kein Gegenstand der **Anker**-Paarung, sehr wohl aber
der **Register**-Paarung.

Damit war die bisherige Zuordnung *gezählt, nicht verkörpert* für diese Klasse
schlicht falsch: Sie ist verkörpert, nur nicht an einem Pfad. Der dritte Zweig
des PFLICHTSCHRITTS („zählt NICHT") ist entfallen; „gezählt, nicht verkörpert"
bezeichnet ab jetzt genau einen Fall — den Eintrag *ohne* Feld und *ohne*
Verkörperung. Das Vorbild ist nachgezogen: `welle-1-results.md` nennt für die
Spec-Lücke jetzt einen Auslöser (`BEO-007`), das Register trägt die Zeile.

**R8-04 — welche Richtung prüft die Register-Paarung?** Zwei Hälften, und die
Umkehrung ist ausdrücklich **nicht** dabei: (1) jede in `done/` zitierte
`BEO-<NNN>` hat eine Registerzeile, (2) jede Registerzeile trägt mindestens
einen Beleg. *Nicht* geprüft wird „jede Zeile ist irgendwo zitiert" — die
allermeisten stehen unter der Schwelle und sind nirgends zitiert; ein Sensor,
der das verlangte, liefe auf jedem gesunden Register rot (und am Kurs-Vorbild
sofort). Spiegel und `CHANGELOG.md` sagen das jetzt wie die Quelle, und
Closure-Schritt 3 (c) trägt beide Hälften, statt nur die erste.

Dazu die vorbestehende Design-Beobachtung: Die zweite Hälfte wäre eine bloße
Nicht-leer-Prüfung, solange der Beleg Freitext sein darf. Der **Beleg ist
jetzt formgebunden** — eine Slice-Kennung `slice-<NNN>`, die als Datei im
Planning-Lifecycle auflöst, und so viele, wie der Zähler behauptet.

### Die Befunde

| Befund | Was geändert wurde |
|---|---|
| R8-01 | Die Normlast steht im **Rumpf**, nicht im Kommentar. `slice.template.md` §7 hat jetzt einen Body: eine Regel-Zeile (Pflichtfeld-Bedingung, Register-Pflicht, Zeiger ins Baseline-Regelwerk) plus sieben Form-Zeilen mit `<Platzhalter>`. Dieselbe Behandlung für `welle-results.template.md` §Steering-Loop-Einträge und `welle.template.md` §7 (die bisher komplett leer blieb). Die Kommentare halten nur noch die Begründung — sie dürfen mit Schritt 5 verschwinden. |
| R8-02 | Der Anker löst über `done/slice-<NNN>-<kurzer-titel>.md` auf, maschinell `done/slice-<NNN>-*.md` — die reale Namensform aus `slice.template.md` :4. Quelle und Spiegel, beide Fundstellen (Herkunfts-Absatz und Anker-Paarung). |
| R8-03 | „Den aktiven Durchlauf `open/` → `next/` → `in-progress/` durchläuft er nicht; `done/` ist sein einziges Lifecycle-Verzeichnis." |
| R8-04 | Siehe oben. |
| R8-05 | Siehe oben. |
| R8-06 | Die drei Paarungen sind ein **eigener** Punkt in §7 — nicht mehr Fortsetzung der Frage „Wurde die Regel HIER verkörpert?" — und haben ein eigenes DoD-Item. |
| R8-07 | Ein Zeitpunkt statt zweier: **nach** dem `git mv`, weil die Paarungen in `done/` suchen. Nachgezogen in Modul 6 — Tabelle *wellenloser Betrieb* und Closure-Schritt 3 —, im Spiegel, `slice.template.md` §2/§7 und im Vorbild `slice-020`. |
| R8-08 | Die Sensor-Bauanleitung ist aus dem Rumpf in den Kommentar gewandert; im Rumpf steht nur noch die Form. |
| R8-09 | Der Absatz ist in zwei mit je eigenem Label geteilt: *Was offen bleibt* (nur die Carveout-Frist) und *Was der wellenlose Betrieb selbst auslöst*. Kein „davon" mehr. |
| R8-10 | Der Spiegel führt dieselben zwei Labels — das falsch beschriftete Sammel-Bullet ist weg. |
| R8-11 | `in_progress → done` ist zuerst und als einziger Weg nach `done` benannt; die beiden Rückführungen stehen daneben und behalten ihren Ausnahmecharakter. Quelle und Spiegel. |
| R8-12 | Die zwei Leser des **Registers** stehen jetzt zusammen (Lese-Schritt · Sichtungs-Schritt); der Herkunfts-Anker, der auf `done/` zeigt, ist ein eigener Satz. |
| R8-13 | `slice-013` und `slice-014` tragen den Platzhalter-Text des Templates (vor dem `git mv`, Paarungen danach). |
| R8-14 | Das Vorbild hat jetzt beide Welle-Pläne: `done/welle-1-mvp.md` (geschlossen, neben seiner Ergebnis-Notiz) und `welle-2-qualitaet.md` (flach, aktive Welle). Der Planning-Index im Lab trägt die Slice-vs-Welle-Konvention. |
| R8-15 | Der **Sichtungs-Schritt** hat einen wellenlosen Träger: die Slice-Planung (`slice.template.md` §8), ausdrücklich **unabhängig vom Sub-Area-Modus**. Nachgezogen in Modul 5, Modul 6 (Eröffnung Schritt 2 + Tabelle), beiden Spiegeln und `observations.template.md` (`WER LIEST` / `OHNE WELLE`). |
| R8-16 | Das Feld heißt `liegt in <Zielort>`, und der Zielort ist definiert: `AGENTS.md §<N>` · `Makefile:<target>` · `.harness/skills/<name>.md`. Die Prüfvorschrift trennt ein Suffix ab ` §` oder `:` ab, bevor sie den Pfad prüft, und sagt für jede Variante, wo der Anker steht. |
| R8-17 | Der Lösungsblock benennt den **Leser** (Welle-Closure; ohne Welle die Slice-Closure selbst) — beide Hälften wie in der Rubrik. |
| R8-18 | (c) kennt den wellenlosen Zweig, den (b) eröffnet: Der Lese-Schritt liegt bei der Welle-Closure *oder*, ohne Welle, bei der Slice-Closure — mit dem jeweiligen Anker. |
| R8-19 | *Zielort* ist wieder definiert — als das, was in den Backticks des Pflichtfelds steht. Der Mermaid-Knoten `E` nennt das Feld selbst. |
| R8-20 | Der `git mv` der Welle-Plan-Datei steht als eigener Absatz beim Schließen der Welle, nicht unter *Warum der Zähler ein eigenes Artefakt ist*. Quelle und Spiegel. |
| R8-21 | `CHANGELOG.md` hat einen Abschnitt *Nachgezogen (Review-Runden 7 und 8)* — mit der Zustands-Regel für Wellen, der „Drei Übergänge"-Korrektur und den tragenden Entscheidungen dieser Runde. |
| R8-22 | Der Geltungsbereich ist die **Sektion**, nicht die Datei: `liegt in` löst nur in `## Steering-Loop-Einträge` bzw. Slice-§7 aus. Der Trigger-Sprachgebrauch „`SL-024` liegt in `done/`" ist dort ausdrücklich als Nicht-Auslöser benannt. |
| R8-23 | `welle.template.md` nennt die Ausnahme: Die Ruheort-Regel gilt für die Pfade, die der Adopter einträgt — nicht für den Zeiger auf die Schwester-Vorlage, der mit dem Kommentar ohnehin wegfällt. |
| R8-24 | Der Trigger-Audit hat einen Moment („bei jeder Closure, zusammen mit dem Lese-Schritt") — wie alle fünf Vorgänge in der neuen Tabelle. „Eigenständig ausgelöst" ohne Zeitpunkt steht nirgends mehr. |
| R8-25 | Modul-9-Spiegel wortgleich mit der Quelle (`— ohne Welle` statt `bzw.`). |
| vorbestehend 1 | Die Raute `J{"Regel entfernen oder lockern?"}` hat ihren „nein"-Ausgang (zurück zum Agentenlauf, der die verkörperte Form liest). |
| vorbestehend 2 | Die Belegspalte ist nicht mehr frei erfindbar — siehe R8-04 oben. |

**Nicht geändert:** die Trigger-Beispiele „`SL-024` liegt in `done/`" in Modul 6,
Spiegel, Lösung und Rubrik. Der Sektions-Scope (R8-22) macht sie eindeutig, und
sie sind an vier Stellen wortgleich zitiert — ein Umformulieren hätte vier
Kongruenz-Stellen bewegt, um ein Problem zu lösen, das der Scope bereits löst.

**Empfohlen:** eine neunte Runde. Diese hier hat wieder Normtext an denselben
fünf Klassen bewegt.
