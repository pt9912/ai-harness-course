# Hello-Harness — dein erstes grünes Gate in 30 Minuten

Ein Kurs über Harness Engineering, in dem die erste Hands-on-Übung erst
in Phase 04 kommt, frustriert. Diese Mini-Übung dient als
*Erfolgserlebnis vor Modul 1*: in 30 Minuten von "leeres Repo" zu
"grünes Gate mit Bezug auf eine Anforderungs-ID".

Sie ist nicht Pflicht. Sie ist das, was du tust, *bevor* du in den
Kurs einsteigst, wenn du etwas Greifbares unter den Händen haben willst.

## Lernziel

Du kannst nach 30 Minuten:

- ein Mini-Repo mit Spec-Eintrag, Anforderungs-ID, Make-Target und einem grünen Gate aufsetzen,
- den Trace Anforderung → Make-Target → Gate-Ergebnis konkret zeigen,
- erklären, *warum* dieselbe Übung ohne ID-Schema später nicht skaliert.

Bloom-Stufe: Anwenden — bewusst niedrig gewählt. Das Ziel ist
Selbstwirksamkeit, nicht Tiefe. Die Tiefe kommt in Modul 3, 12 und 13.

## Voraussetzungen

- Git ist installiert.
- Bash oder Zsh.
- Eine beliebige Sprache, die einen Linter mitbringt (Python+`ruff`,
  Go+`go vet`, Node+`eslint` … wähle deine vertrauteste).

## Schritte

### 1. Repo anlegen (2 Minuten)

```bash
mkdir hello-harness && cd hello-harness
git init -q
mkdir -p spec
```

### 2. Spec mit einer Anforderung (3 Minuten)

Schreibe `spec/lastenheft.md`:

```markdown
# Lastenheft — Hello-Harness

## LH-FA-001: Begrüßung
**Anforderung:** Das System gibt bei Aufruf den Text "Hello, Harness." aus.

**Akzeptanzkriterien:**
- Given das System wird ohne Argumente aufgerufen,
  When die Ausgabe gemessen wird,
  Then enthält sie exakt "Hello, Harness." auf stdout.
```

Eine ID, ein Given/When/Then — mehr nicht.

> **Kurz zur Notation:** *Given/When/Then* stammt aus **Behavior-Driven Development** (Dan North, 2006) und ist die Keyword-Syntax der **Gherkin-Sprache** (genutzt u. a. von Cucumber, pytest-bdd, SpecFlow). Wir bleiben bei den englischen Keywords, weil sie der Industriestandard sind: reale `.feature`-Dateien, Tool-Dokumentation und Beispiele im Netz verwenden fast ausnahmslos `Given/When/Then`. Gherkin kennt zwar lokalisierte Varianten (`Angenommen/Wenn/Dann`), die sind in der Praxis aber selten — und im deutschen Fließtext kollidiert *Wenn/Dann* mit jeder normalen Konditional-Konjunktion. Englisch erspart dir die Disambiguierung und macht dein Kurs-Wissen 1:1 auf Tooling übertragbar.

### 3. Code mit ID-Kommentar (5 Minuten)

Python-Beispiel — `hello.py`:

```python
"""LH-FA-001: Begrüßung."""

def main() -> None:
    print("Hello, Harness.")

if __name__ == "__main__":
    main()
```

Der Docstring nennt die ID. Das ist die Klammer zwischen Spec und Code.

### 4. Gate als Make-Target (10 Minuten)

`Makefile`:

```makefile
.PHONY: lint test gates

lint:  ## LH-FA-001 — Linter-Gate
	ruff check hello.py

test:  ## LH-FA-001 — Smoke-Test
	@output="$$(python hello.py)"; \
	  if [ "$$output" = "Hello, Harness." ]; then \
	    echo "ok: LH-FA-001 erfüllt"; \
	  else \
	    echo "FAIL: LH-FA-001 — got '$$output'"; exit 1; \
	  fi

gates: lint test  ## alle Gates
```

Achte auf die Make-Target-Kommentare: `## LH-FA-001 — ...`. Genau das ist
das ID-Schema aus [`../grundlagen/konventionen.md`](../grundlagen/konventionen.md#id-schema-als-klammer).
Wer das hier macht, kann es später in jedem Repo machen.

### 5. Erster Lauf (5 Minuten)

```bash
make gates
```

Erwartet: zwei grüne Schritte, am Ende `ok: LH-FA-001 erfüllt`.

### 6. Fehler provozieren (5 Minuten)

Ändere `print("Hello, Harness.")` zu `print("hi")`. Lauf erneut:

```bash
make gates
```

Erwartet: Der Test schlägt fehl mit Bezug auf `LH-FA-001`. Das *ist* der
Harness: das Gate kennt die Anforderungs-ID.

Stelle den Code wieder her.

## Was du gelernt hast

In 30 Minuten:

- **Quelle der Wahrheit** (`spec/lastenheft.md` mit `LH-FA-001`) ↔
- **Bezug im Code** (Docstring nennt die ID) ↔
- **Bezug im Gate** (Make-Target-Kommentar nennt die ID) ↔
- **Reproduzierbares Ergebnis** (`make gates`).

Vier Stellen, dieselbe ID — das ist die *Klammer*, die der Harness fester
zieht. Modul 3, 12 und 13 vertiefen jeden dieser vier Punkte.

## Was du *nicht* gelernt hast

Bewusst weggelassen:

- Spec-Stratifizierung (kommt in Modul 3),
- ADRs (kommt in Modul 4),
- Reviewer-/Implementation-Agent (kommt in Modul 8–10),
- Replay (kommt in Modul 12),
- Docker-Harness (kommt in Modul 14).

Das hier ist ein *Hello World für die Klammer*. Mehr nicht. Aber genug,
um zu wissen, was am Ende von Modul 13 in echt steht.

## Nächster Schritt

→ [Modul 0 — Einführung](modul-00-einfuehrung.md)
