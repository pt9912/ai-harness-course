# Steering Loop im Team — Entwurfsstand der Beobachtungsablage

> **Stand:** 2026-08-31 · **Status:** Diskussionsstand, nicht normativ;
> die sieben Fälle des Schluss-Abschnitts sind geprobt
> ([`lab/team-sim`](../lab/team-sim/README.md) s12–s18: 13 Verdikte,
> Gesamtlauf 36/36).
>
> Diese Datei hält einen möglichen Ersatz für das stehende
> `docs/plan/planning/observations.md` in Repos mit mehreren Schreibern fest.
> Sie ändert weder den Kurs noch den Regelwerk-Spiegel oder die Templates.
> Dort gilt weiter die in
> [Modul 6 §Das Beobachtungs-Register](../kurs/de/02-planung/modul-06-roadmap.md#das-beobachtungs-register)
> gelehrte Form. Eine Verkörperung folgt der Rangfolge dieses Repos:
> `kurs/de` → `lab/regelwerk` → `lab/templates` → `lab/example`.

## Ausgangspunkt

Der Steering-Loop-Zähler steht heute in einer gemeinsamen Datei:

```text
docs/plan/planning/observations.md
```

Bei jeder Slice-Closure entscheidet ein Mensch, ob ein Fund eine neue
Beobachtung ist oder eine bestehende `BEO-<NNN>` wiederholt. Danach schreibt er
Zähler und Slice-Beleg in dieselbe Tabellenzeile. Das Modell zählt
Beobachtungen statt Beobachter und ist damit fachlich personenunabhängig.

Die Ablage ist es nicht. In einem Team, in dem jede Aufgabe auf einem eigenen
Feature- oder Bugfix-Branch läuft, entstehen mehrere Sichten auf das Register:

- Ein Branch liest nur den zuletzt gemergten Stand. Erhöhungen in offenen PRs
  sind unsichtbar; der Sichtungs-Schritt ist so alt wie der letzte Merge
  ([Modul 5](../kurs/de/02-planung/modul-05-planning-harness.md#zwei-schritte-vor-der-modus-begründung)).
- Zwei Änderungen derselben Tabellenzeile kollidieren meist laut. Die richtige
  Konfliktauflösung muss beide Belege übernehmen und den Zähler additiv bilden.
- Erhöht ein Branch eine vorhandene Zeile und legt ein anderer dasselbe
  Phänomen unter einer neuen Kennung an, kann Git beide Änderungen still
  mergen. Die Beobachtung ist danach geteilt und erreicht die 3×-Schwelle
  nicht. [`team-sim` s03](../lab/team-sim/README.md) reproduziert diesen
  Ausgang.
- `BEO-<NNN>` braucht eine nächste freie Nummer. Was in offenen PRs vergeben
  wurde, ist lokal nicht vollständig auflistbar.

Der Entwurf ersetzt deshalb den gemeinsamen Ganz-Wert — fortlaufende Kennung
und gespeicherten Zähler — durch stabile, getrennte Artefakte.

## Ziel und Grenze

Der Entwurf soll:

1. parallele Slice-Closures auf getrennte Dateien schreiben lassen,
2. keine globale Nummernvergabe benötigen,
3. den Zähler aus den Belegen ableiten,
4. die Identität einer Beobachtung stabil und verlinkbar halten,
5. einen stillen technischen Merge-Unfall möglichst in einen lauten Konflikt
   oder einen Gate-Befund verwandeln.

Er soll **nicht** behaupten, semantische Gleichheit maschinell entscheiden zu
können. Ob zwei unterschiedlich formulierte Funde dasselbe Phänomen meinen,
bleibt ein menschliches Urteil — dieselbe Grenze wie beim heutigen Register.

## Zielstruktur

Eine Beobachtung erhält einen Sub-Area-Namensraum und darunter einen
semantischen Slug:

```text
docs/plan/planning/observations/
└── BEO-REPLAY/
    └── golden-set-ohne-boundary/
        ├── observation.md
        ├── state.md
        └── evidence/
            ├── slice-IDX-005.md
            ├── slice-IDX-011.md
            └── slice-AUTH-003.md
```

Die kanonische Kennung ist zugleich aus dem Pfad ableitbar:

```text
BEO-REPLAY/golden-set-ohne-boundary
```

`BEO-REPLAY` soll kein frei erfundener Ablagebegriff sein: `REPLAY` steht für
eine Sub-Area, die `harness/conventions.md` deklariert. **Ein Kürzel dieser
Form deklariert dort heute allerdings niemand** — die Modus-Deklaration führt
Pfade und Prosa-Namen (§8). Der Namespace setzt damit eine Quell-Regel voraus,
die noch zu schreiben ist. Der Namespace hält die
**Herkunft** fest: Wird eine Sub-Area später geteilt oder umbenannt, wandert
die Beobachtung nicht. Weitere betroffene Bereiche stehen als Metadatum wie
`Betrifft: REPLAY, TEST` im Artefakt; sie erzeugen weder eine Kopie noch einen
zweiten kanonischen Pfad.

### Verantwortlichkeit der drei Artefaktklassen

| Artefakt | Trägt | Änderungsmodell |
|---|---|---|
| `observation.md` | stabile Kennung, Herkunfts-Sub-Area und Definition des Phänomens | Core und Pfad nach dem ersten Merge immutabel |
| `state.md` | aktueller Stand, Folgeaktion, Verkörperungs- oder Streichungsgrund | explizite, geprüfte Statusübergänge |
| `evidence/<slice-id>.md` | genau ein belegtes Auftreten bei einer Slice-Closure | eine neue Datei je Slice; nach dem Merge append-only/immutabel |

Ein gepflegtes `README.md` als Index gehört **nicht** zur Quelle der Wahrheit.
Es führte den gemeinsamen Schreib-Hotspot wieder ein. Eine Übersicht wird aus
den Verzeichnissen erzeugt und nicht als zweiter Zustand von Hand
fortgeschrieben.

## Zähl- und Schreibregel

Der Zähler steht nirgends als Zahl. Er ist:

```text
Anzahl der gültigen Evidence-Dateien einer BEO
```

Ein Slice zählt eine BEO höchstens einmal; deshalb ist seine stabile
Slice-Kennung der Dateiname des Belegs. Mehrere Findings im selben Slice sind
keine mehreren Wiederholungen des Steering Loops.

Bei der Slice-Closure gilt:

1. Den **gemergten** Bestand aller BEO-Namespaces sichten.
2. Ist das Phänomen vorhanden, dessen kanonische Kennung zitieren und eine
   Evidence-Datei für den schließenden Slice ergänzen.
3. Ist es nicht vorhanden, Namespace und Slug bestimmen, `observation.md`,
   `state.md` und den ersten Beleg anlegen.
4. Den Zähler aus den gültigen Evidence-Dateien bilden.
5. Erreicht der zusammengeführte Stand 3×, eine konkrete Folgeaktion oder
   Verkörperung verlangen. Eine bloße dritte Datei ohne Ausgang ist rot.

Die team-weite Wahrheit ist der potenzielle Merge-Stand, nicht der isolierte
Feature-Branch.

## Nebenläufigkeitsverhalten

| Fall | Ausgang |
|---|---|
| Zwei Branches ergänzen verschiedene Slices zu derselben BEO | getrennte Evidence-Dateien; der Zähler ergibt sich nach dem Merge korrekt (gemessen: s12) |
| Zwei Branches legen im selben Namespace denselben Slug neu an | derselbe Pfad; add/add-Konflikt wird laut und zwingt zur Zusammenführung (gemessen: s13) |
| Zwei Branches benennen dasselbe Phänomen mit verschiedenen Slugs | stilles semantisches Duplikat bleibt möglich (gemessen: s17) |
| Zwei Branches ordnen dasselbe Phänomen verschiedenen Sub-Areas zu | stilles bereichsübergreifendes Duplikat bleibt möglich |
| Stand ist 1×, zwei Branches ergänzen je einen Beleg | beide sehen lokal 2×, der Merge-Stand erreicht 3×; Merge-Queue oder aktueller Branch plus Gate muss die Aktion erzwingen (gemessen: s14a/b) |
| Zwei Branches ändern gleichzeitig `state.md` | möglicher, inhaltlich sinnvoller Konflikt; Statusentscheidung muss serialisiert werden |

Der kritische Schwellen-Fall lautet:

```text
main       1 Beleg
Branch A  +1 Beleg  → lokal 2
Branch B  +1 Beleg  → lokal 2
Merge A+B           → tatsächlich 3
```

Ein Gate nur gegen die beiden isolierten Branch-Spitzen kann diesen Übergang
nicht sehen. Der zweite PR muss gegen den aktuellen Hauptzweig beziehungsweise
in einer Merge-Queue auf dem synthetischen Merge-Ergebnis geprüft werden.

## Was d-check bereits leisten kann

d-check führt zwei unterschiedliche Immutabilitätsmechanismen. Sie dürfen
nicht unter dem Namen des Make-Targets vermischt werden:

| Mechanismus | Eingabe | Aussage für diesen Entwurf |
|---|---|---|
| Modul `vcs`, verteilt als `doc-immutable` | `.git` plus `--range base..head` oder `--staged` | schützt den Core und meldet **Löschung wie Umbenennung** einer immutablen Datei als `core-drift-vcs` — die Umbenennung über `--range` allerdings erst seit `v0.71.1` (gemessen, s. u.) |
| Modul `immutable` | Arbeitsbaum plus `<!-- immutable: sha256:… -->` | schützt den normalisierten Datei-Core hermetisch ohne Git; eine reine Umbenennung bindet es nicht, weil der Marker mit der Datei wandert |

**Für die Unveränderlichkeit des BEO-Pfads reicht `vcs` — seit `v0.71.1`.**
Bis dahin behauptete dieser Absatz es zu Unrecht. Die normative Anforderung
[`DC-FA-VCS-001`](https://github.com/pt9912/d-check/blob/main/spec/lastenheft.md#dc-fa-vcs-001--git-diff-immutabilität-des-core-über-eine-commit-range-modul-vcs-opt-in)
und das
[d-check-Handbuch §Immutabilität über eine Commit-Range](https://github.com/pt9912/d-check/blob/main/docs/user/benutzerhandbuch.md#immutabilität-über-eine-commit-range-prüfen-modul-vcs)
nennen den Rename-Fall ausdrücklich; gemessen hing er am **Eingabe-Modus**.
Über `--staged` meldete die Umbenennung, über `--range` — den CI-Pfad — blieb
sie still; erst eine mitgeführte Umformulierung erzeugte den Befund. Als
Werkzeug-Befund an `vcs` gemeldet, dort bestätigt und in `v0.71.1` behoben
(Range-Diff ohne Rename-Erkennung, alle vier Fälle nachgefahren, kein
Lastenheft-Bump: die Anforderung war nicht falsch, sie war nicht eingelöst).
Dieses Repo pinnt seither `v0.71.1`; [`lab/team-sim`](../lab/team-sim/README.md)
s15a/b/c und s16a/b/c messen den Fix. Der Schutz von Namespace und Slug
braucht damit keine Erweiterung des beantragten Vertrags — und die Zusage ist
jetzt gemessen statt zitiert.

Auch vorhandene Module helfen bei Teilinvarianten:

- `links`/`ids`: BEO- und Slice-Verweise müssen auflösen.
- `structure`: Pflichtabschnitte und Form der Markdown-Artefakte.
- `spans`: Ein ungeschlossener Fence darf die Abschnittserkennung eines
  Immutabilitätslaufs nicht blind machen.
- `tracked`: verlinkte Belege dürfen nicht nur lokal vorhanden sein.

### Was d-check dafür noch nicht ausdrückt

Der heutige Modulsatz kann nicht allein aus der Verzeichnisstruktur:

- Evidence-Dateien je BEO zählen,
- die 3×-Schwelle an eine Folgeaktion koppeln,
- Pfadbestandteile mit Feldern in `observation.md` vergleichen,
- eine Evidence-Datei genau einer gültigen, abgeschlossenen Slice-Kennung
  zuordnen,
- Alias-/Supersede-Ketten von BEOs beim Zählen auflösen.

Zwei dieser Punkte sind inzwischen gemessen statt vermutet: Die Schwelle im
Merge-Stand (s14b) und die Alias-/Invalidierungs-Auflösung samt Zyklus (s18)
laufen heute vollständig still — alle Eingaben liegen im Baum, niemand liest
sie.

Diese deterministische Hälfte braucht vor einer normativen Einführung einen
Change Request an d-check oder eine vorhandene generische Fähigkeit, die
diese Invarianten vollständig und fail-closed ausdrückt. Ein neues
repo-lokales Prüfsystem wäre mit der Werkzeugregel dieses Repos nicht
vereinbar: Erst sind Scan-Roots, Ignores und die Baubarkeit im vorhandenen
Werkzeug zu prüfen.

Semantische Duplikate sind ausdrücklich **kein** Kandidat für ein
entscheidendes Gate. Ein Ähnlichkeitslauf könnte warnen; zusammenführen darf
nur ein Mensch.

## Schwachstellen, Lösungen und Restgrenzen

Die Lösungen unten sind Teil des Entwurfs, noch keine Baseline-Regel. Eine
Lösung gilt hier nur dann als vollständig, wenn sie neben dem Schreibweg auch
den Merge-Zeitpunkt und die maschinell entscheidbare Hälfte benennt.

| # | Schwachstelle | Vorgeschlagene Lösung | Maschinelle Absicherung | Verbleibende Restgrenze |
|---|---|---|---|---|
| 1 | Dasselbe Phänomen erhält verschiedene Slugs oder Sub-Areas | Jede neue BEO braucht vor dem Merge einen BEO-Reviewer mit Sicht auf die erzeugte Gesamtliste; Suche über alle Namespaces und ein Ähnlichkeitshinweis sind Pflichtgriffe. Später erkannte Duplikate werden per `alias-of` zusammengeführt. | Exakte Pfadduplikate werden durch Git laut; ein Ähnlichkeitslauf darf advisory warnen. | Semantische Gleichheit bleibt menschliches Urteil. Ein Reviewer kann sich irren. |
| 2 | Zwei isoliert grüne Branches heben 1× gemeinsam auf 3× | Eine Merge-Queue prüft den synthetischen Merge-Stand. Ab drei gültigen Belegen muss `state.md` den Zustand `planned` und einen auflösbaren Aktionszeiger tragen; sonst darf der PR nicht mergen. | Evidence-Zählung plus Invariante `count >= 3 ⇒ state = planned|embodied und action/embodied-in löst auf`. | Die inhaltliche Eignung der gewählten Aktion bleibt Review. |
| 3 | `state.md` wird ein neuer veränderlicher Ganz-Wert | Kleine Zustandsmaschine: `open` → `planned` → `embodied`; alternativ `open` → `retired`, für Duplikate → `alias`. `action-required` ist ein Befund, kein dauerhaft gültiger Zustand. | Erlaubte Übergänge, Pflichtfelder und Zielauflösung über Merge-Range prüfen; gleichzeitige Änderungen bleiben als sinnvoller Git-Konflikt laut. | Wie eine Beobachtung nach erneuter Wiederholung einer bereits verkörperten Regel behandelt wird, braucht noch eine Regel. |
| 4 | Ein falscher Beleg dürfte in einem append-only Modell nicht gelöscht werden | Korrektur als neue Datei `invalidations/<slice-id>.md` mit Grund und Korrekturbeleg. Der ursprüngliche Beleg bleibt unverändert; der Zähler bildet `evidence − invalidations`. | Genau eine Invalidierung je vorhandenem Beleg, Pflichtgrund, stabiler Korrekturverweis; Evidence und Invalidierung nach dem Merge immutabel — gegen Änderung, Löschung und Umbenennung gehalten (s16a/b/c). | Ob die fachliche Zurücknahme berechtigt ist, entscheidet Review. |
| 5 | Später erkannte BEO-Duplikate würden zwei stabile Pfade hinterlassen | Der nicht kanonische Pfad bleibt bestehen und erhält den Terminalzustand `alias` mit genau einem `alias-of`-Ziel. Neue Belege sind dort verboten; gezählt wird die Vereinigung eindeutiger Slice-IDs am kanonischen Ziel. | Alias-Ziel existiert, Graph ist azyklisch, genau ein terminales kanonisches Ziel, keine doppelten Slice-Belege. | Die Wahl, welche BEO kanonisch bleibt, ist eine menschliche Entscheidung. |
| 6 | Syntaktisch gültige Evidence kann erfunden oder falsch zugeordnet sein | Beidseitige Paarung: Evidence verlinkt die `done/`-Slice-Closure, und diese zitiert dieselbe BEO. Ein Beleg zählt nur bei vollständiger Paarung. | Existenz, Lage, Kennungsgleichheit und Bijektion prüfen. | Ob der Vorfall wirklich eintrat und fachlich zur BEO gehört, bleibt Review. |
| 7 | Ohne zentrale Tabelle fehlt der schnelle Überblick | Eine read-only, deterministisch erzeugte Sicht listet BEO, Sub-Area, Zustand, abgeleiteten Zähler und Aktion; Filter mindestens nach Sub-Area und Zustand. Sie erscheint als d-check-Ausgabe oder CI-Artefakt, nicht als gepflegte Repo-Datei. | Der Erzeuger liest ausschließlich die Artefakte und schreibt nicht ins Repo; Snapshot-/Determinismus-Test gegen denselben Baum. | Darstellungsform und genauer d-check-Einstieg sind noch zu entscheiden. |
| 8 | Uneinheitliche oder nicht portable Slugs | Deklarierte Form `BEO-<SUB-AREA>/<slug>`; Sub-Area aus `harness/conventions.md`, Slug 3–80 Zeichen, lowercase ASCII-Kebab-Case, keine führenden, abschließenden oder doppelten Bindestriche. Namespace und Slug sind nach dem ersten Merge unveränderlich. | Pfad-Grammatik und Deckung Pfad ↔ `observation.md`; Delete und Rename über `vcs` (gemessen, s15 — Rename im Range-Modus seit `v0.71.1`). Die Prüfung gegen den deklarierten Sub-Area-Bestand braucht ein Kürzel, das heute keine Modus-Deklaration führt. | Gute, fachlich treffende Benennung lässt sich nicht mechanisieren. |
| 9 | Bestehende `BEO-<NNN>` dürfen nicht umbenannt werden | Ein deklarierter Cutover konvertiert jede bestehende Zeile einmalig in einen BEO-Ordner unter ihrer Herkunfts-Sub-Area, behält aber `BEO-<NNN>` als kanonische Alt-Kennung. `observations.md` wird danach nur ein statischer Migrationszeiger; neue BEOs verwenden ausschließlich Slugs. | Gate akzeptiert beide Kennungsformen, verbietet neue numerische Kennungen nach dem Cutover und prüft die vollständige Übernahme aller alten Belege. | Der einmalige Konverter und das genaue Legacy-Pfadformat müssen im Replay festgelegt werden. |

### 1. Semantische Duplikate

`BEO-REPLAY/golden-set-ohne-boundary` und
`BEO-TEST/grenzfall-fehlt-im-golden-set` können dasselbe Phänomen meinen.
Namespace und Slug erhöhen die Chance eines lauten Pfadkonflikts, garantieren
ihn aber nicht. Vor dem Anlegen werden deshalb die erzeugte Gesamtliste und
alle Sub-Areas durchsucht; eine neue BEO braucht einen Reviewer, der diese
Klassifikation ausdrücklich bestätigt. Ein Ähnlichkeitslauf kann die Suche
priorisieren, aber nicht entscheiden.

### 2. Exakter 3×-Übergang

Ab 3× muss `state.md` mindestens `planned` und einen auflösbaren Aktionszeiger
tragen; eine bereits verkörperte Regel erfüllt die stärkere Form
`embodied`. **Blockierend** ist das nur auf dem synthetischen Merge-Stand: Dort
stoppt der Lauf den PR, der die Schwelle im Gesamtstand überschreitet, bevor
ein unvollständiger Zustand auf dem Hauptzweig landet. Ohne diese Zusage der
CI läuft dieselbe Prüfung erst auf dem Hauptzweig und wird dort rot — spät,
aber nicht mehr still; heute erzeugt der Übertritt gar kein Rot (s14b). Offen
bleibt, welche Zielklassen außer Folge-Slice und verkörperter Regel als Aktion
zulässig sind — und diese Menge ist Quell-Arbeit, keine Konfiguration.

### 3. Statusmodell

Vorgeschlagen ist `open` → `planned` → `embodied`, daneben `open` → `retired`
und aus jedem noch nicht verkörperten Zustand → `alias`. `planned` verlangt
einen Aktionszeiger, `embodied` das verkörperte Ziel mit Herkunfts-Anker,
`retired` den Grund, warum das Phänomen nicht mehr auftreten kann, und `alias`
genau ein kanonisches Ziel. `action-required` ist der Name des Befunds bei
unerfüllter 3×-Invariante, kein speicherbarer Dauerzustand. Noch offen ist der
Rückweg, wenn eine bereits verkörperte Regel das Phänomen später erneut
zulässt.

### 4. Falsche oder zurückgenommene Belege

Eine Evidence-Datei darf nicht still gelöscht oder überschrieben werden. Ein
falscher Beleg erhält eine neue Datei `invalidations/<slice-id>.md` mit Grund
und Verweis auf den korrigierenden Slice oder PR. **Die dritte Richtung ist die
schärfste:** Weil der Dateiname eines Belegs *die* Slice-Kennung ist, machte
eine reine Umbenennung den Zähler nicht falsch, sondern den Beleg — die Datei
behauptete danach einen anderen Slice. Seit `v0.71.1` meldet auch das (s16c,
dieselbe Ursache wie s15b). Der abgeleitete Zähler zählt
nur Evidence-Dateien ohne gleichnamige Invalidierung. Die Form ist damit
append-only; die fachliche Berechtigung der Invalidierung bleibt
review-pflichtig.

### 5. Später erkannte BEO-Duplikate

Beide stabilen Pfade bleiben erhalten. Der nicht kanonische erhält in
`state.md` den Zustand `alias` und genau einen `alias-of`-Zeiger. Er nimmt
keine neuen Belege mehr an. Der abgeleitete Zähler folgt der Alias-Kette,
vereinigt die Belege am kanonischen Ziel nach Slice-Kennung und verwirft keine
Historie. Ein Gate verhindert Zyklen, tote Ziele und mehrere terminale Ziele.

### 6. Beleg-Wahrheit

Jede Evidence-Datei verlinkt die Closure-Notiz des Slice; die Closure-Notiz
zitiert dieselbe BEO. Nur die vollständige Paarung zählt. Dateiname, Linkziel,
Slice-Lage und Kennungsgleichheit sind mechanisch prüfbar. Ob der behauptete
Vorfall tatsächlich im Slice auftrat und derselben BEO entspricht, bleibt
Review. Das neue Layout verschärft die Provenienz, ersetzt sie aber nicht durch
Wahrheit.

### 7. Auffindbarkeit

Das Verzeichnis ist die Autorität, aber kein guter Überblick. Der
Sichtungs-Schritt erhält eine deterministisch erzeugte Ansicht mit Kennung,
Sub-Area, Zustand, Zähler und Aktion, filterbar mindestens nach Sub-Area und
Zustand. Sie erscheint als read-only d-check-Ausgabe oder CI-Artefakt und wird
nicht als gepflegte zweite Wahrheit ins Repo zurückgeschrieben. Der genaue
CLI-Einstieg ist noch zu entscheiden.

### 8. Slug-Grammatik

Die portable Form ist lowercase ASCII-Kebab-Case für den 3–80 Zeichen langen
Slug und ein deklarierter, uppercase Sub-Area-Code. Führende, abschließende
und doppelte Bindestriche sind verboten:

```text
BEO-[A-Z][A-Z0-9-]*/[a-z0-9]+(?:-[a-z0-9]+)*
```

Der Namespace und der Slug sind Herkunftsanker und werden nach dem ersten
Merge nicht umbenannt — **maschinell gehalten seit `v0.71.1`**: Löschung wie
Umbenennung meldet `vcs` in beiden Eingabe-Modi (s15a/b).
Die Deckung Kennung ↔ Pfad ist Gegenstand des Antrags. Die Zusage, d-check
prüfe zusätzlich den Namespace gegen `harness/conventions.md`, setzt ein
**Sub-Area-Kürzel** voraus, das dort heute niemand deklariert: Die
Modus-Deklaration führt Pfade, das Register führt Prosa-Namen, und
[`source-precedence.md` §Vergabe](../kurs/de/grundlagen/source-precedence.md#vergabe-woher-die-nächste-nummer-kommt)
verwendet Kürzel in Kennungen. **Den Ort benennt der Kanon durchaus** — es
seien „die Sub-Areas, die `harness/conventions.md` ohnehin einzeln
deklariert"; was dort steht, sind aber Pfade und Prosa-Namen, kein Kürzel. Die
Lücke ist also nicht der fehlende Ort, sondern die fehlende **Gestalt** an
ihm. Sie zu schließen ist Quell-Arbeit und geht dem Sensor voraus.

### 9. Migration und Geltungsbereich

Bestehende `BEO-<NNN>` werden nicht umbenannt: historische Slice-, Commit- und
Closure-Verweise bleiben gültig. Beim deklarierten Cutover wird jede bestehende
Zeile einmalig unter ihrer Herkunfts-Sub-Area in die Verzeichnisform
übernommen; `observation.md` trägt weiterhin die alte kanonische Kennung, und
die vorhandene Belegliste wird in einzelne Evidence-Dateien zerlegt.
`observations.md` bleibt danach nur als statischer Migrationszeiger bestehen.

Sensoren verstehen dauerhaft beide Kennungsformen, verbieten aber neue
numerische Kennungen nach dem Cutover. Neue Beobachtungen erhalten nur noch
`BEO-<SUB-AREA>/<slug>`. Offen sind das genaue Legacy-Pfadformat und der
Replay-belegte Konverter; eine Massenumbenennung ist ausgeschlossen.

## Der belastbare Schritt, gefahren

Die sieben Fälle, gegen die der Entwurf zu proben war, sind am 2026-08-31 in
[`lab/team-sim`](../lab/team-sim/README.md) als s12–s18 gelaufen
(d-check v0.67.0; 13 neue Verdikte, Gesamtlauf 36/36 · 0 KAPUTT):

| Fall | Szenario | Ergebnis |
|---|---|---|
| zwei Evidence-Dateien mergen und korrekt zählen | s12 | git allein: Merge glatt, abgeleiteter Zähler 3 |
| gleichzeitige Neuanlage desselben Namespace/Slug-Pfads wird laut | s13 | git allein: add/add-Konflikt auf `observation.md` |
| paralleler Übergang von 1× auf zusammen 3× erzwingt eine Aktion | s14a/b | **offen**: der Merge-Stand zählt 3, kein Sensor hält die Schwelle |
| Rename und Delete von Namespace oder Slug melden `core-drift-vcs` | s15a/b/c | **Werkzeug-Befund, behoben**: der reine Rename blieb im Range-Modus still; gemeldet und in `v0.71.1` gefixt |
| Änderung oder Löschung eines bestehenden Belegs wird gemeldet | s16a/b/c | `core-drift-vcs` wie zugesagt — die **Umbenennung** eines Belegs seit `v0.71.1` ebenfalls (s16c) |
| zwei Slugs für dasselbe Phänomen bleiben sichtbar | s17 | still, wie beabsichtigt |
| Invalidierung und Alias-Auflösung zählen deterministisch und zyklusfrei | s18a/b | **offen**: alle Eingaben liegen vor, niemand liest sie |

**Der CR ist inzwischen beantwortet: angenommen — und aufgeschoben**, auf
unseren eigenen Vorschlag hin. d-check baut §1–§5 nach unseren zwei
Quell-Wellen, setzt die Sub-Area-Autorität und die CI-Voraussetzung als
gesetzt, nimmt §6 als eigenen Ausgabemodus entgegen — und lehnt die
Anzahl-Prüfung am flachen Register ab, weil unsere zwei geschuldeten Regeln
sie heute blockieren würden.

Das ordnet die Sensorfläche neu. **Drei** Aussagen trägt git ohne jedes
Werkzeug und ohne jede CI-Zusage über den Merge-Stand (s12, s13, s16a/b) — sie
gehören nicht in einen Change Request. **Eine** ist bewusst still (s17).
**Zwei** sind der Gegenstand des Antrags und haben heute keinen Leser (s14b,
s18). **Eine** galt als gelöst, war es nicht — und ist es seit `v0.71.1` (s15b): Sie
brauchte keine neue Fähigkeit, sondern eine Reparatur an einer vorhandenen.

Offen bleibt damit dasselbe wie vorher, nur genauer benannt: Ziel-Form und
Zustandsmaschine sind Quell-Arbeit an `kurs/de` — die geschlossene Menge der
Ausgänge bei 3×, die Sub-Area-Kürzel und die zwei Beleg-Fälle, die ein
abgeleiteter Zähler nicht mehr abbilden kann (Vorkommen außerhalb einer
Slice-Closure; zweites Vorkommen derselben Klasse im selben Slice). Erst wenn
diese Hälfte steht, wird entschieden, ob die Form den heutigen Default ersetzt
oder als deklarierte Team-Variante danebensteht. Danach beginnt eine eigene
Regel-Welle an der Quelle `kurs/de`; Spiegel, Templates und Beispiel folgen,
nicht umgekehrt.
