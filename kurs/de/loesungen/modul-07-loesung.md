# Lösung — Modul 7: Carveout Management

Zugehöriges Modul: [Modul 7 — Carveout Management](../02-planung/modul-07-carveouts.md).

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

### Drei Werkzeuge für gelockerte Gate-Disziplin — wann welches?

Drei legitime Alternativen — nicht eine Mehrfach-Variante derselben
Sache. Der Disambiguierungs-Reflex hängt am **Symptom**, nicht am
Werkzeug:

| Wahl                       | Symptom-Indikator (woran erkennst du es?)                                                                                          | Träger                            | Folge-Artefakt                                                                            |
|----------------------------|------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------|-------------------------------------------------------------------------------------------|
| **Carveout**               | *Eine* konkrete Gate-/Regelausnahme, klar abgrenzbar, mit Folge-Slice und Auflösungs-Trigger.                                      | einzelne Diskrepanz               | `docs/plan/carveouts/CO-<NNN>-*.md`                                                       |
| **BF-Sub-Area-Markierung** | Diskrepanz-**Häufung** im selben Geltungsbereich; oder generelles *"Code existiert vor Doku"*-Muster (z. B. 4 Carveouts auf `internal/index/`). | ganze Sub-Area                    | Modus-Deklaration im Adaptions-Block von `harness/conventions.md`, mit Graduation-Trigger |
| **Bootstrap-aware Gate**   | Gate, dessen Schwelle systemisch mit dem Repo-Reifegrad **mitwachsen** soll (Coverage 0 → 70 % bei M2), nicht einmalig gelockert.    | Gate-Stufung                      | Gate-Konfiguration mit Reifestufe + Trigger (Modul 13)                                    |

> *Warum diese Tabelle anders aussieht als die in Worked Example A
> Schritt 6:* Dort lautet die Frage *"wie löse ich eine konkrete
> Diskrepanz auf?"* — die dritte Option ist dann der **permanente ADR**,
> und das Bootstrap-aware Gate erscheint *absichtlich nicht* (es regelt
> Gate-Reifestufung, nicht Diskrepanz-Auflösung). Hier lautet die Frage
> *"wie gehe ich mit gelockerter Gate-Disziplin um?"* — dann gehört das
> Bootstrap-aware Gate dazu, und der permanente ADR ist der Sonderfall
> "Trigger nie erreichbar". Carveout und BF-Markierung sind in beiden
> Triaden dieselben; nur die dritte Option wechselt mit der Frage.

**Häufigste Verwechslung — und die Korrektur dazu:** wer ein Dutzend
Carveouts auf denselben Geltungsbereich (z. B. `internal/index/`)
anlegt, hat das trainierte Carveout-Verfahren auf einen Fall
übertragen, wo die einfachere **BF-Sub-Area-Markierung** genügt —
eine Deklaration im Adaptions-Block, die die ganze Sub-Area als BF
markiert und einen Graduation-Plan trägt. Anti-Pattern:
*Carveout-Kaskade* (viele Einzel-Carveouts für ein systemisches Muster)
und *Stufung-ohne-Trigger* (Bootstrap-aware Gate-Mimikry, dessen
Reifestufe nie eintreten kann — entweder Carveout-Wildwuchs oder
permanente ADR). Keine harte Carveout-Zahl als Schwelle — wer die
Diskussion am Zähler aufhängt, hat das Symptom-Muster mit einer Quote
verwechselt; die Faustregel ist der **gemeinsame Geltungsbereich**, nicht
*n ≥ 3*.

Vertiefung: [Modul 7 §Worked Example A Schritt 6](../02-planung/modul-07-carveouts.md#worked-example-a-einen-carveout-dokumentieren)
führt das Frage-Schema (Carveout? BF-Markierung? ADR?) als
Entscheidungsbaum durch.

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
- Bootstrap-aware Gates als verwandtes Muster: [Modul 13](../04-qualitaet/modul-13-quality-gates.md)
- Vorherige Lösung: [Modul 6](modul-06-loesung.md)
- Nächste Lösung: [Modul 8](modul-08-loesung.md)
