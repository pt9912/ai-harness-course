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
4. **Sicherheitsnetz**: Relative Pfade dürfen nicht aus dem Repo führen.

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

Warnungen unterdrücken (Exit-Code unverändert):

```bash
docker run --rm -v "$PWD":/work docs-check --no-warn
```

### Schweregrade

**ERROR** — Datei existiert nicht, Anker existiert nicht, Pfad zeigt
aus dem Repo. Exit-Code 1.

**WARN** — Ziel lesbar, aber Heading-Index nicht ermittelbar (defekte
Datei, Encoding-Problem). Exit-Code bleibt 0.

### Anker-Konvention

Anker werden nach GitHub-Slug-Regel berechnet:

- lowercase
- Whitespace → `-`
- HTML-Tags entfernt
- Markdown-Inline-Zeichen (` * _ ~`) entfernt
- Sonstige Interpunktion entfernt (Bindestrich und Unterstrich bleiben)
- Doppelte Heading-Titel: zweites bekommt `-1`, drittes `-2`, …

### Implementierungs-Hinweise

- Node 22, **keine externen Dependencies** — Validator ist eine einzelne `docs-check.js`-Datei.
- Code-Fences (` ``` `) und Inline-Code (`` ` ``) werden vor dem Link-Parsing entfernt, damit Beispiele in Codeblöcken nicht false-positives erzeugen.
- `node_modules/`, `.git/`, `target/`, `build/`, `.gradle/` werden beim rekursiven Walk übersprungen.

### Lokal ohne Docker

```bash
node tools/docs-check.js                      # ab CWD
node tools/docs-check.js kurs/de/             # gezielt
node tools/docs-check.js --verbose lab/       # mit OK-Output
```

Reicht Node 22+, keine Installation nötig.
