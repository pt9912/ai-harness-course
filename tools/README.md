# tools/

Hilfsskripte rund um den Kurs. Nicht Teil des Kursmaterials.

Beide Validatoren teilen sich einen **Multi-Stage-`Dockerfile`**: eine
gemeinsame `base`-Stage validiert die Skripte zur Build-Zeit
(`node --check`), zwei benannte Ziel-Stages liefern je ein
zweckgebundenes Image. Gebaut wird per `--target`:

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

`Dockerfile` + `docs-check.js` liefern einen reproduzierbaren
Markdown-Link-Validator für den Kurs. Vorbild:
[`/Development/math/euler-fourier-hilbert/tools/`](https://github.com/pt9912/euler-fourier-hilbert)
(ohne Math-Validierung, da der KI-Kurs keine Formeln nutzt).

Geprüft wird:

1. **Interne Markdown-Links** `[text](pfad.md#anker)` — Datei vorhanden? Bei Anker: gibt es die zugehörige Heading-ID?
2. **Bild-Referenzen** `![alt](pfad.png|jpg|svg|gif|webp)` — Datei vorhanden?
3. **Code-/Config-Referenzen** `[text](pfad.go|.py|.kt|.java|.cs|.yaml|...)` — Datei vorhanden?
4. **Explizite Inline-Code-Pfade** wie `` `../README.md` `` oder `` `lab/example/...` `` — Datei/Verzeichnis vorhanden?
5. **Sicherheitsnetz**: Relative Pfade dürfen nicht aus dem Repo führen. Absolute Pfade werden explizit abgelehnt. Symlinks werden auf den realpath aufgelöst — ein Symlink im Repo, der nach `/etc` zeigt, wird erkannt.

Externe Links (`http://`, `https://`, `mailto:`) werden ignoriert —
der Kurs verwendet sie selten und sie zu prüfen wäre flaky.

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

**ERROR** — Datei existiert nicht, Anker existiert nicht, Pfad zeigt
aus dem Repo, absoluter Pfad, Permission-Denied auf Ziel-Markdown.
Exit-Code 1.

**WARN** — Filesystem-Hickups beim Durchlauf, oder Heading-Index aus
nicht-Permission-Gründen unermittelbar. Exit-Code bleibt 0.

### Bewusste Einschränkungen

- **Nur Inline-Links** `[text](url)` werden geprüft. Reference-Style-Links `[text][ref]` und `[ref]: url` werden nicht geparst — der Kurs verwendet ausschließlich Inline-Links.
- **Anker nur in `.md`-Zielen** geprüft. Ein Link wie `[Zeile 42](src/foo.go#L42)` wird stillschweigend akzeptiert (Konvention für Source-Line-Anker).
- **Inline-Code-Pfadprüfung ist konservativ.** Geprüft werden nur explizite relative Pfade (`./`, `../`) und Repo-Root-Pfade (`lab/`, `kurs/`, `tools/`). Begriffe wie `LH-*`, `make gates`, `spec/`, `/etc/foo` oder `harness/README.md` ohne expliziten Kontext bleiben unberührt.
- **Heading-IDs** folgen GitHubs Slug-Regel: lowercase, Whitespace → `-`, HTML-Tags und Markdown-Inline-Code entfernt, Interpunktion entfernt (Bindestriche und Unterstriche bleiben), Unicode-Buchstaben/Zahlen behalten. ATX-Closing-Sequenzen (`## Heading ##`) werden vor der Slug-Erzeugung entfernt. Duplikate bekommen `-1`, `-2`, … als Suffix.

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
