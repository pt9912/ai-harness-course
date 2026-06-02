# Lösung — Modul 6: Carveout Management

Zugehöriges Modul: [Modul 6 — Carveout Management](../02-planung/modul-06-carveouts.md).

## Selbstcheck-Antworten

### (Erinnern) Welche zwei Pflichtfelder hat jeder temporäre Carveout?

1. **Auflösungs-Trigger** — eine *beobachtbare* Bedingung. "Sobald wir
   Zeit haben" zählt nicht; "wenn `pkg/x` > 500 LOC", "Meilenstein M2",
   "Bibliothek Y bietet Funktion Z" zählen.
2. **Folge-Slice mit ID** — der Slice, der die Auflösung übernimmt
   (auch wenn er noch in `open/` liegt). Slice schlägt Memo.

Fehlt eines der beiden Felder, ist der Carveout *de facto* permanent —
er bleibt liegen, und das Repo lügt unter "temporär". Konsequenz: Wenn
ein temporärer Carveout mehrfach an seinem Auflösungs-Datum vorbei läuft,
ist er kein temporärer mehr und muss offen als permanent klassifiziert
oder in eine ADR überführt werden.

Permanente Carveouts brauchen *kein* Trigger-Feld und keinen Folge-Slice,
aber eine technische Begründung — sonst sind sie versteckte
Architekturentscheidungen.

### Wann darf ein Carveout das `make gates`-Ziel grün halten, und wann nicht?

Grün halten ist erlaubt, wenn:

1. Der Carveout *dokumentiert* ist (in `docs/plan/carveouts/`).
2. Er einen **Trigger** für die Auflösung benennt (z. B. "wenn `pkg/x` > 500 LOC", "Meilenstein M2", "Bibliothek Y bietet Funktion Z"). Der Trigger darf nicht "irgendwann" sein.
3. Er einem **Folge-Slice** zugeordnet ist, der die Auflösung übernimmt (auch wenn der noch in `open/` liegt).
4. Das Gate selbst ihn explizit kennt — z. B. `coverage-gate` weiß: "Pfad X ist temporär bei 0 % Coverage, Begründung in `docs/plan/carveouts/CO-007`".

Grün halten ist *nicht* erlaubt, wenn:

- Es keine Carveout-Datei gibt ("Wir machen mal eine Ausnahme").
- Der Trigger fehlt oder lautet "wenn Zeit ist".
- Der Folge-Slice fehlt.
- Mehrere Slices die gleiche Carveout-Begründung wiederverwenden, ohne dass jemand auflöst ("Cargo-Cult Carveout").

Faustregel: Ein Carveout ohne Auflösungs-Plan ist eine *permanente
Ausnahme*, die als *temporär* getarnt ist — und damit eine Harness-Lüge.

## Übungshinweise

### Dokumentiere einen Carveout für eine fehlende Coverage-Schwelle

Pflicht-Inhalt einer Carveout-Datei:

- **ID** (`CO-NNN`)
- **Betroffenes Gate** (`coverage-gate`, `coverage-gate-critical`)
- **Geltungsbereich** (Pfad, Modul, Datei)
- **Begründung** (technisch, nicht "noch nicht geschafft")
- **Auflösungs-Trigger** (Meilenstein, Code-Eigenschaft, externes Ereignis)
- **Folge-Slice-Referenz** (`slice-X-coverage-Y.md` in `open/` oder `next/`)
- **Datum** der Anlage und letzten Prüfung

Vergleich-Möglichkeit:
[`/lab/example/docs/plan/carveouts/`](../../../lab/example/docs/plan/carveouts/)
(im Lab nach Phase B).

### Verknüpfe ihn mit einem konkreten Folge-Slice

Der Folge-Slice sollte:

- Den Auflösungs-Trigger des Carveouts in seinen DoD übernehmen.
- Eine Closure-Notiz vorsehen, die den Carveout *schließt* (Datei nach `docs/plan/carveouts/done/` oder Markierung "RESOLVED").
- In der Roadmap im Block der Welle stehen, in der der Trigger erwartet wird.

## Häufige Fehler

- **Carveout = "noqa".** Carveouts sind nicht inline. Sie leben in der Plan-Doku und sind im Gate selbst verankert.
- **Carveouts ohne Audit-Termin.** Wenn niemand regelmäßig durch `docs/plan/carveouts/` geht, sammeln sich Karteileichen. Carveout-Audit sollte als eigene Welle oder als wiederkehrender Slice geplant sein.
- **Vergleichbare Carveouts vermehren sich.** Wenn mehrere Stellen denselben Carveout brauchen, ist die *Ursache* der gemeinsame Punkt — meist ein fehlendes ADR oder eine fehlende Bibliotheks-Wahl. Dort ansetzen, nicht überall Carveout setzen.

## Verweise

- Entropy Management als Konzept: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)
- Bootstrap-aware Gates als verwandtes Muster: [Modul 12](../04-qualitaet/modul-12-quality-gates.md)
- Vorherige Lösung: [Modul 5](modul-05-loesung.md)
- Nächste Lösung: [Modul 7](modul-07-loesung.md)
