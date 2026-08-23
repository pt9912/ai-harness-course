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

Was offen ist, führt [`docs/roadmap.md`](docs/roadmap.md).

## 4. Gates

`make check` vor jedem Commit — `docs-check` 0 ERROR, `alignment-check` 0 WARN.

| Target | Zweck |
|---|---|
| `make help` | Targets anzeigen |
| `make check` | beide Validatoren nacheinander — das Gate vor jedem Commit |
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

## 6. Release

Tag `vX.Y.Z` → Workflow `templates-release` → Roadmap-Zeile mit Lauf-ID
(in dieser Reihenfolge; die Zeile braucht die ID).

**MAJOR** bindet an Asset-Entfernung und Layout-Bruch auf Datei-Ebene,
**MINOR** an jede Regel-Änderung, **PATCH** nur an Korrekturen ohne
Regel-Änderung ([`docs/team-plan.md`](docs/team-plan.md)).

Der Meilenstein gilt erst als erreicht, wenn das **veröffentlichte** Bundle
stichprobenartig geprüft ist — nicht schon bei grünem Workflow.
