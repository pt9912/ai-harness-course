# AGENTS.md — Arbeitskonventionen für dieses Repository

> **Dies ist nicht das gelehrte Artefakt.** Der Kurs lehrt `AGENTS.md` als
> Einstieg eines *adoptierenden* Repos ([README §Einstiegspunkt für
> Code-Agenten](README.md#einstiegspunkt-für-code-agenten)); die ausgefüllte
> Form dieser Lehre steht in [`lab/example/AGENTS.md`](lab/example/AGENTS.md).
> Diese Datei hier ist etwas anderes: die Konventionen, nach denen **am
> Kursmaterial selbst** gearbeitet wird. Dieses Repo ist die Quelle der Lehre,
> kein Adopter — es führt kein `spec/`, keine Slices, kein `harness/`. Wer die
> gelehrte Form sucht, ist hier falsch.

## 1. Rangfolge

`kurs/de` → `lab/regelwerk` → `lab/templates` → `lab/example`.

„Das Regelwerk ist derivativ — bei Konflikt gilt das Kursmaterial"
([README §Betriebsregelwerk](README.md#betriebsregelwerk)). Widersprechen sich
ein Modul und das Beispiel, ist **das Beispiel** kaputt. Die Fix-Richtung geht
immer zur Quelle, nie von der Ableitung zurück in die Lehre.

## 2. Der Spiegel unter `lab/regelwerk/`

Operatives wird **wortgleich** übernommen, Didaktik weggelassen — **nie
paraphrasiert**. Welche fünf Operationen der Spiegel ausführen darf und woran
sich das Ergebnis prüfen lässt, steht in
[`docs/regelwerk-extrakt.md`](docs/regelwerk-extrakt.md#teil-2--was-der-spiegel-tun-darf).

Der Spiegel ist netzlos: keine Verweise auf Kurs-Material, das nicht mit ins
Bundle reist.

## 3. Wellen

Jede Überarbeitung ist eine **Welle** mit einem Eintrag im
[`CHANGELOG.md`](CHANGELOG.md) — das Register ist kanonisch, nicht die
Commit-Labels.

Berührt eine Welle `lab/regelwerk/`, zieht die `Stand:`-Zeile in
[`lab/regelwerk/README.md`](lab/regelwerk/README.md) nach. Lab-only-Wellen
lassen sie stehen.

Behauptet eine Welle ein **beobachtbares Verhalten** — ein Sensor feuert, ein
Sensor bleibt still, eine Operation tut oder lässt etwas —, bekommt diese Aussage
eine Szenario-Gruppe in [`lab/team-sim/`](lab/team-sim/README.md), bevor sie
stehen bleibt: Das hebt sie von *entworfen* auf *geprobt*
([`docs/team.md`](docs/team.md)). **Erwartete Stille ist eine Aussage** und
braucht ihr Szenario genauso.

Behauptet die Welle kein beobachtbares Verhalten, steht das im Wellen-Eintrag —
sonst liest sich das Fehlen wie ein Versäumnis. **Urteile sind keine
Szenario-Fälle** („ist das ein Satz?", „trägt das der Bedienvertrag?"); ein
Szenario darüber wäre ein halluziniertes Gate.

Ein Verdikt, das durch **Abwesenheit** besteht, hängt an einer positiven
Vorbedingung über `schritt` — sonst besteht es auch über einem kaputten Aufbau
(gemessen in Welle 121).

Der Team-Sim ist **kein Gate**: Er läuft auf Anlass (`bash lab/team-sim/run.sh`),
steht nicht in `make check` und wird in §4 nicht geführt.

Was offen ist, führt [`docs/roadmap.md`](docs/roadmap.md).

## 4. Gates

`make check` vor jedem Commit — `docs-check` 0 ERROR, `alignment-check` 0 WARN.

| Target | Zweck |
|---|---|
| `make help` | Targets anzeigen |
| `make check` | beide Validatoren nacheinander — das Gate vor jedem Commit |
| `make gate-image` | Prüf-Image bauen: das Repo wandert per `COPY` hinein, kein Mount |
| `make docs-check` | Referenzen (d-check) + Modul-Nummern (Rest-Sensor) prüfen |
| `make alignment-check` | Lernziel-Alignment-Prüfschritt (Docker) |
| `make bundle-build` | Bundle nach `DEST` bauen (`DEST=<dir> REF=<tag\|main>`) |
| `make bundle-verify` | Referenzen eines gebauten Bundles prüfen (`DEST=<dir>`) |
| `make bundle-check` | Bundle bauen und prüfen, in einem Wegwerf-Verzeichnis |

Diese Tabelle ist die **Autorität**: Das Modul `targets` prüft beide
Richtungen — jedes hier behauptete Target ist eine Makefile-Regel, und jede
Regel steht hier. Die `doc-*`-Targets sind ausgenommen; sie kommen aus dem
tool-generierten `d-check.mk`, tragen dort ihre eigene `##`-Beschreibung und
werden von `make doc-help` gelistet. Sie hier zu wiederholen hieße, eine
generierte Datei ein zweites Mal zu führen. Die Ausnahmen stehen **namentlich**
in `.d-check.yml` — kommt bei einer Fragment-Regeneration ein Target dazu,
meldet das Gate es als `gate-undocumented`, statt es still durchzulassen.

`lab/templates/` ist in `.d-check.yml` bewusst scoped-ignoriert (die Dateien
mischen zwei Referenzklassen). **Keine neuen Prüf-Skripte anlegen** — d-check
ist das Werkzeug; ein Sensor-Vorschlag wird vorher gegen Ignores und Scan-Roots
auf Baubarkeit geprüft, sonst behauptet er ein Gate, das es nicht gibt.

## 5. Commits

```
feat(<bereiche>): Welle NN — Titel
fix(welle-NN): …
docs(roadmap): …
```

Bodies **ohne Umlaute** (ASCII-Transliteration: `Aenderung`, `Fussabdruck`).

**Kein `Co-Authored-By`-Trailer.** Entscheidung vom 2026-08-23 — ältere Commits
führen ihn, neue nicht. Das ist ein bewusster Bruch mit der bisherigen
Historie, kein Abbild von ihr.

Nicht ungefragt committen: Änderungen liegen lassen, Gates laufen lassen,
berichten — committen auf ausdrückliches Wort.

**Committen, Pushen und Taggen sind drei Freigaben, nicht eine.** Ein Wort, das
eine davon nennt, erstreckt sich nicht auf die nächste. Die Antwort auf eine
Doppelfrage reicht so weit wie ihr **Wortlaut**, nicht wie die Frage: „committen"
heißt committen, auch wenn gefragt war „committen und releasen". Im Zweifel gilt
die engere Lesart, und es wird nachgefragt — die Rückfrage kostet einen Zug, der
Tag ist draußen (§6). Eine frühere Freigabe für alle drei Schritte gilt für den
Vorgang, in dem sie gegeben wurde, nicht für den nächsten.

## 6. Release

Tag `vX.Y.Z` → Workflow `templates-release` → Roadmap-Zeile mit Lauf-ID
(in dieser Reihenfolge; die Zeile braucht die ID).

**MAJOR** bindet an Asset-Entfernung und Layout-Bruch auf Datei-Ebene,
**MINOR** an jede Regel-Änderung, **PATCH** nur an Korrekturen ohne
Regel-Änderung ([`docs/team-plan.md`](docs/team-plan.md)).

Der Meilenstein gilt erst als erreicht, wenn das **veröffentlichte** Bundle
stichprobenartig geprüft ist — nicht schon bei grünem Workflow.

**Ein veröffentlichter Tag wird weder bewegt noch zurückgezogen.** Adopter
vendorn den Baum unter seinem Tag und prüfen ihn gegen das `SHA256SUMS` des
Releases; nach einem Zug wäre `vX.Y.Z` bei ihnen etwas anderes als hier, und sie
erführen es erst beim nächsten `baseline-verify`. Ein Fehler im Release wird
durch das **nächste** Release behoben, nicht durch das vorige. Deshalb steht die
Freigabe für den Tag oben in §5 gesondert: Er ist der einzige Schritt der Kette,
den keiner zurücknehmen kann.
