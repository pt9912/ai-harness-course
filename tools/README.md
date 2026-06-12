# tools/

Hilfsskripte rund um den Kurs. Nicht Teil des Kursmaterials.

Beide Validatoren teilen sich einen **Multi-Stage-`Dockerfile`**: eine
gemeinsame `base`-Stage validiert die Skripte zur Build-Zeit
(`node --check`), zwei benannte Ziel-Stages liefern je ein
zweckgebundenes Image.

**Bequemster Einstieg** ist das Root-`Makefile` (baut das Image und
führt es aus; `ARGS` reicht Flags und Pfade durch):

```bash
make docs-check                              # ganzes Repo
make alignment-check ARGS="--strict"
make docs-check ARGS="--verbose kurs/de/"
make check                                   # beide nacheinander
```

**CI:** [`.github/workflows/checks.yml`](../.github/workflows/checks.yml)
führt bei Push auf `main` und bei Pull Requests exakt dieselben
Make-Targets aus (`alignment-check` mit `--strict`: WARN = rot) —
lokal und im CI identisch, kein separater CI-Pfad, der driften könnte.

Manuell gebaut wird per `--target`:

```bash
docker build -t docs-check       --target docs-check       tools/
docker build -t alignment-check  --target alignment-check  tools/
```

## alignment-check

`alignment-check.js` operationalisiert den Alignment-Prüfschritt aus
[`kurs/de/grundlagen/README.md` §1](../kurs/de/grundlagen/README.md) auf
Lernziel-Granularität: für jedes Modul prüft es, ob jedes Lernziel (LZ)
im Übungs- *und* im Selbstcheck-Block aktiviert ist — entweder durch
einen expliziten Marker `LZ <N>` oder durch den Wortstamm eines kursiven
LZ-Verbs.

### Bauen und Verwenden (Docker)

```bash
docker build -t alignment-check --target alignment-check tools/
docker run --rm -v "$PWD":/work alignment-check            # Default: kurs/de
docker run --rm -v "$PWD":/work alignment-check --verbose   # auch volle Abdeckung
docker run --rm -v "$PWD":/work alignment-check --strict    # Exit 1 bei WARN
```

### Schweregrade

**WARN** — ein Höher-Bloom-LZ (Analysieren/Bewerten/Erschaffen/Überwachen)
trägt in *beiden* Blöcken keine Aktivierung. Das ist der heißeste Kandidat
für eine echte Alignment-Lücke (Lernziel ohne trainierende Aktivität). Mit
`--strict` Exit-Code 1.

**INFO** — partieller Fall (nur Übung *oder* nur Selbstcheck fehlt) oder
ein Erinnern/Verstehen-LZ. Exit-Code bleibt 0.

### Heuristik, kein Gate

Das Werkzeug ist ein **Frühwarner**, kein Beweis:

- **Verbstamm-Matching** ist heuristisch. Deutscher Ablaut (entwerfen →
  entwirf) und Synonyme (verfassen ↔ schreiben) erzeugen Falsch-Negative
  — ein flagged LZ kann in Prosa längst geprobt sein. Darum vor jeder
  Reaktion gegensteuern: das LZ im Modul nachlesen.
- **Konzept-knappe Selbstchecks sind Absicht** (siehe
  [`selbstcheck-rubrik.md`](../kurs/de/grundlagen/selbstcheck-rubrik.md)):
  die kognitive Tiefe trägt die Drei-Stufen-Rubrik, nicht das Item-Verb.
  Ein fehlender Selbstcheck-Marker ist darum nur INFO.
- **0 WARN ist der Zielzustand** und aktuell erreicht. Wer ein WARN
  erzeugt, hat entweder eine echte Lücke gebaut oder ein neues LZ-Verb
  eingeführt, dessen Aktivierung das Werkzeug nicht erkennt — beides ist
  einen Blick wert.

Node 22+, keine externen Dependencies — eine einzelne Datei, gleiche
Konvention wie `docs-check`.

## docs-check

`Dockerfile` + `docs-check.js` liefern den **Rest-Sensor** des Kurses:
die Modul-Nummern-Checks, deren Semantik ein generischer
Referenz-Checker nicht kennen kann. Die generischen Prüfungen
(Markdown-Links, Anker, Bild-/Code-Referenzen, explizite
Inline-Code-Pfade, Repo-Escape-/Symlink-Sicherheitsnetz) übernimmt
seit der Pilot-Migration 2026-06-12
[d-check](https://github.com/pt9912/d-check) — digest-gepinntes
Container-Image, konfiguriert in [`../.d-check.yml`](../.d-check.yml);
Zeilen-Opt-out für bewusste Beispiel-Pfade: `<!-- d-check:ignore
(Begründung) -->`. `make docs-check` führt beide aus.

Geprüft wird (von diesem Tool):

**Modul-Nummern-Sensor** (gegen Off-by-one-Drift nach
Modul-Einfügungen — die Fehlerklasse trat in Welle 8 an vier Stellen
auf):

- **A (ERROR, deterministisch):** Nennt ein Linktext `Modul N` (oder ist er eine reine Zahl `N`) und zeigt der Link auf `modul-MM-*.md` mit `N ≠ MM`, ist das ein Fehler. Opt-out pro Zeile: `<!-- docs-check:ignore -->`.
- **B (WARN, heuristisch):** Prosa-Erwähnungen `Modul N (Titel)` werden gegen den Dateinamens-Slug von Modul N geprüft (Prefix-Vergleich, Umlaut-normalisiert). Gewarnt wird **nur**, wenn der Titel auf ein *anderes* Modul passt — Nicht-Titel-Klammern („Bericht A", „FV3") passen auf kein Modul und bleiben stumm. Benötigt die Modul-Dateien im Scan-Umfang (bei Teilbaum-Läufen ohne `kurs/de/` bleibt B inaktiv).

Externe Links (`http://`, `https://`, `mailto:`) sind für die
Nummern-Checks irrelevant und werden ignoriert.

### Bauen

```bash
docker build -t docs-check --target docs-check tools/
```

### Verwenden

Vom Repo-Root aus, prüft alle `*.md` rekursiv:

```bash
docker run --rm -v "$PWD":/work docs-check
```

Nur einen Unterbaum prüfen:

```bash
docker run --rm -v "$PWD":/work docs-check kurs/de/
docker run --rm -v "$PWD":/work docs-check lab/
```

Mit OK-Meldungen:

```bash
docker run --rm -v "$PWD":/work docs-check --verbose
```

Eigenen Pfad ausnehmen (mehrfach erlaubt, beide Schreibweisen):

```bash
docker run --rm -v "$PWD":/work docs-check --ignore lab/templates
docker run --rm -v "$PWD":/work docs-check --ignore=lab/templates
```

Warnungen unterdrücken (Exit-Code unverändert):

```bash
docker run --rm -v "$PWD":/work docs-check --no-warn
```

### Schweregrade

**ERROR** — Modul-Nummern-Widerspruch (Prüfung A), Datei nicht lesbar.
Exit-Code 1.

**WARN** — Off-by-one-Verdacht in Prosa (Prüfung B),
Filesystem-Hickups beim Durchlauf. Exit-Code bleibt 0.

### Bewusste Einschränkungen

- **Nur Inline-Links** `[text](url)` werden geparst (für Prüfung A). Reference-Style-Links `[text][ref]` und `[ref]: url` werden nicht geparst — der Kurs verwendet ausschließlich Inline-Links.
- **Keine Existenz-/Anker-/Pfad-Prüfung mehr** — das ist seit der Migration Aufgabe von d-check (`../.d-check.yml`). Historische Fassung mit Vollausbau: Git-Historie dieses Repos bzw. konsolidiert in d-check.

### Implementierungs-Hinweise

- Node 22, **keine externen Dependencies** — eine einzelne `docs-check.js`-Datei.
- Code-Fences (` ``` ` und `~~~`, beide CommonMark-konform mit bis zu 3 Spaces Einrückung) und Multi-Backtick-Inline-Code werden vor dem Link-Parsing entfernt.
- Klammern in URLs werden mit Klammer-Balancing korrekt geparst (z. B. Wikipedia-Style `[text](url(part))`).
- `node_modules/`, `.git/`, `target/`, `build/`, `.gradle/`, `dist/`, `.next/`, `.venv/`, `__pycache__/`, `vendor/`, `bin/`, `obj/` werden beim rekursiven Walk übersprungen.
- Datei-Sortierung mit `Intl.Collator` für reproduzierbare Reihenfolge unabhängig vom Locale.
- Diagnostik (ERROR/WARN + Summary) immer auf `stderr`, OK-Meldungen mit `--verbose` auf `stdout` — geeignet für CI-Logs.

### Lokal ohne Docker

```bash
node tools/docs-check.js                      # ab CWD
node tools/docs-check.js kurs/de/             # gezielt
node tools/docs-check.js --verbose lab/       # mit OK-Output
node tools/docs-check.js --ignore=lab/templates lab/  # mit explizitem Ignore
```

Node 22+, keine Installation nötig.
