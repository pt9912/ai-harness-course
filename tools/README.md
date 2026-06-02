# tools/

Hilfsskripte rund um den Kurs. Nicht Teil des Kursmaterials.

## docs-check

`Dockerfile` + `docs-check.js` liefern einen reproduzierbaren
Markdown-Link-Validator für den Kurs. Vorbild:
[`/Development/math/euler-fourier-hilbert/tools/`](https://github.com/pt9912/euler-fourier-hilbert)
(ohne Math-Validierung, da der KI-Kurs keine Formeln nutzt).

Geprüft wird:

1. **Interne Markdown-Links** `[text](pfad.md#anker)` — Datei vorhanden? Bei Anker: gibt es die zugehörige Heading-ID?
2. **Bild-Referenzen** `![alt](pfad.png|jpg|svg|gif|webp)` — Datei vorhanden?
3. **Code-/Config-Referenzen** `[text](pfad.go|.py|.kt|.java|.cs|.yaml|...)` — Datei vorhanden?
4. **Sicherheitsnetz**: Relative Pfade dürfen nicht aus dem Repo führen. Absolute Pfade werden explizit abgelehnt. Symlinks werden auf den realpath aufgelöst — ein Symlink im Repo, der nach `/etc` zeigt, wird erkannt.

Externe Links (`http://`, `https://`, `mailto:`) werden ignoriert —
der Kurs verwendet sie selten und sie zu prüfen wäre flaky.

### Bauen

```bash
docker build -t docs-check tools/
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
