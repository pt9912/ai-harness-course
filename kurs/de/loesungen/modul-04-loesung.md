# Lösung — Modul 4: Architektur und ADRs

Zugehöriges Modul: [Modul 4 — Architektur und ADRs](../01-spec-und-architektur/modul-04-architektur-adrs.md).

## Selbstcheck-Antworten

### (Erinnern) Welche vier Pflichtabschnitte hat ein MADR-ADR?

**Kopf-Felder:** Titel mit ADR-Nummer, Status (Proposed/Accepted/
Deprecated/Superseded), Datum, Bezug (LH-/HSM-ID).

**Body-Blöcke:**

1. **Kontext** — was war die Situation, was hat die Entscheidung ausgelöst?
2. **Optionen** — *mit Trade-offs*, mindestens zwei, idealerweise drei.
3. **Entscheidung** — welche Option, warum (verweist auf Kontext und Trade-offs).
4. **Konsequenzen** — was folgt operativ daraus, idealerweise inklusive
   Fitness-Function-Verweis.

Die *Optionen*-Sektion ist der häufigste Drift-Punkt. Eine ADR ohne
Optionen ist ein Postulat — sie hält fest, *was* entschieden wurde, aber
nicht *warum gerade so und nicht anders*. Reviewer-Agenten können
solche ADRs nicht verteidigen, weil ihnen die Vergleichsbasis fehlt.

### (Analysieren) Drei Aussagen ADR/Spec/Plan zuordnen + Grenzfall

Zuordnung mit Begründung je Halbsatz:

1. *"Wir nehmen PostgreSQL statt MongoDB."* → **ADR** — eine
   Lösungs-Entscheidung zwischen Alternativen, die begründet und
   versioniert werden muss.
2. *"Die Antwortzeit der Suche bleibt unter 200 ms."* → **Spec**
   (nichtfunktionale Anforderung) — eine messbare Eigenschaft des
   Lieferversprechens, keine Lösungswahl.
3. *"Slice SL-014 implementiert den Trigram-Index."* → **Plan** —
   das *Wann/Wie* eines konkreten Arbeitspakets, das per ID-Bezug
   auf Spec (200-ms-NFA) und ADR (PostgreSQL/Trigram) verweist.

Damit ist auch Vorab-Frage 1 beantwortet: **Eine ADR begründet eine
Lösung, nie eine Anforderung.** Anforderungen begründet die Spec.

**Der Grenzfall** ist Aussage 1: *"Wir nehmen PostgreSQL"* wandert in
die **Spec**, sobald der Kunde die Datenbank *vertraglich vorgibt* —
dann ist PostgreSQL keine Entscheidung mehr, sondern eine Anforderung,
und die ADR begründet nur noch das *Wie* darunter (z. B. Trigram-Index
vs. externes Such-System *innerhalb* der PostgreSQL-Vorgabe).
Entscheidungs-Kriterium: **Wer trägt den Bedarf?** Kommt die Aussage
vom Auftraggeber, ist sie Spec; entstammt sie dem Lösungsraum des
Teams, ist sie ADR. Verknüpft wird per ID-Bezug, nie durch
Wiederholung — sonst driften die Kopien.

Anti-Antwort: "1 ADR, 2 Spec, 3 Plan." — die nackte Zuordnung ohne
Kriterium besteht den Grenzfall nicht: dieselbe Aussage kann je nach
Kontext das Artefakt wechseln, und ohne Kriterium ist das nicht
entscheidbar.

### Wann wird aus einer ADR eine Architekturtest-Regel?

Sobald die ADR-Entscheidung sich in einer maschinell prüfbaren
Eigenschaft niederschlägt — typischerweise eine *strukturelle*
Eigenschaft des Codes:

- "Schicht A darf nicht von Schicht B importieren" → ArchUnit / depguard / import-linter.
- "Modul X darf nicht mehr als 50 öffentliche Funktionen exportieren" → Komplexitäts-Lint.
- "Klassen, die `*Repository` heißen, müssen ein Interface implementieren" → ArchUnit-Predikat.
- "Alle Public-API-Klassen brauchen einen `@SuppressWarnings("unused")`-Verbot" → Custom-Linter-Regel.

Faustregel: Wenn ein Reviewer-Agent dieselbe Verletzung in jedem Lauf
wieder beanstanden müsste, hast du eine Fitness Function vergessen.
Wenn die Entscheidung nur "es soll sauber sein" ist, ist sie noch
keine ADR-würdige Regel.

### (Bewerten) `deprecated` ohne Nachfolger — korrekt gewählt oder verdeckte `superseded`-Lücke?

Das Urteil hängt an *einem* Kriterium: **Existiert der zugrunde liegende
Bedarf weiter?**

- **`deprecated` ist legitim**, wenn die Regel *ersatzlos* entfällt — der
  Bedarf ist weg. Beispiel: "Wir nutzten JUnit 4. (Deprecated: keine
  neuen JUnit-4-Tests.)" — JUnit 5 ist über einen *eigenen* ADR geregelt,
  der alte braucht keinen Nachfolger.
- **`deprecated` ist ein falsch etikettiertes `superseded`**, wenn der
  Bedarf *bleibt*, aber kein Nachfolger benannt ist. Dann ist
  "deprecated" nur ein Etikett für eine *offene Entscheidung* — die Regel
  ist weg, das Problem aber nicht. Genau das ist die verdeckte Lücke:
  jemand muss die Folgefrage noch entscheiden, und niemand sieht, dass
  sie offen ist.

Zur Erinnerung die Definitionen, an denen das Urteil hängt:

- **Superseded by ADR-N**: eine spätere ADR-N hat die Entscheidung
  abgelöst; Begründung und Migrationstrigger stehen in ADR-N. Beispiel:
  "ADR-7 Modellwahl Sonnet 4.5 (Superseded by ADR-12 Modellwahl
  Opus 4.8)."
- **Deprecated**: nicht mehr gültig, *kein* Ersatz benannt.

Folge für den Steering Loop: Bei verdeckter Lücke fordert der Reviewer
einen Folge-ADR (oder Carveout) und markiert HIGH. Tritt das Muster
dreimal auf, ist die ADR-*Status-Vergabe* selbst die Lücke — Guide:
Status-Definitionen mit dem Bedarf-Kriterium in die ADR-Vorlage ziehen.

### (Anwenden) Fitness-Function-Übersetzung in einem Satz

Eine gute Übersetzung hat drei Bestandteile:

1. **Strukturelle Aussage** — "Komponente/Datei/Layer X darf (nicht) Y".
2. **Werkzeug** — ArchUnit (Java/Kotlin), dep-cruiser (Node), import-linter
   (Python), depguard (Go).
3. **Gate-Verdrahtung** — als `make`-Target sichtbar (`make arch-check`),
   im CI gerötet wenn die Regel bricht.

Beispiele (jeweils ein Satz):

- ADR-7 ("Service über Adapter"): "Keine Datei unter `src/service/**`
  darf `requests`, `urllib3` oder `httpx` importieren — `import-linter`
  Contract, `make arch-check`."
- ADR "Modul Layering": "Klassen in `runtime.*` dürfen nicht von Klassen
  in `service.*` aufgerufen werden — ArchUnit-Predikat, `make arch-test`."

Wenn dir kein einzelner Satz einfällt: die ADR ist zu vage. "Lose
Kopplung anstreben" ist nicht prüfbar; "Layer A importiert nicht aus
Layer B" ist prüfbar. Vage ADRs erzeugen Reviewer-Last; präzise ADRs
erzeugen Gates.

### (Erschaffens-Prozess) Welcher Schritt deines ADR-Schreibens war der unsicherste — und warum?

Auch diese Frage hat keine universelle Lösung — sie fragt nach
*deinem* Schreibprozess. Was eine gute Antwort auszeichnet:

- Ein konkret benannter Schritt aus der Sieben-Schritt-Schablone
  plus Begründung. Modellierte Antwort: "Schritt 4 (Optionen mit
  Trade-offs) — zwei der drei Optionen habe ich erst beim
  Hinschreiben überhaupt erwogen; vorher hatte ich nur 'meine'
  Lösung im Kopf."
- Erfahrungsgemäß sind Schritt 4 (Optionen) und Schritt 6 (Fitness
  Function) die unsichersten. Die Pointe: Wer Schritt 4 überspringt
  oder schwammig hält, postet ein *Entscheidungs-Ergebnis* ohne
  *Entscheidungs-Belege* — genau das macht ADRs im Review
  unverteidigbar. Und wer bei Schritt 6 "lässt sich nicht prüfen"
  schreibt, hat oft nur zu vage formuliert.

Anti-Antwort: "Alles klar." — verdächtig. Wer keinen unsicheren
Schritt findet, hat die Schablone gelesen statt eine echte
Entscheidung hindurchgeschickt.

### (Erschaffen) Folge-ADR zu superseded ADR-0007 entwerfen

Ausgearbeiteter Beispiel-Entwurf (ADR-0007 *"In-Memory-Cache vor
Index-Layer"* steht auf `superseded`, der Nachfolger fehlt noch):

```markdown
# ADR-0012 — Read-through-Cache hinter dem Index-Layer

* Status: Proposed
* Datum: 2026-06-11
* Bezug: LH-QA-PERF-003
* Supersedes: ADR-0007

## Kontext
ADR-0007 platzierte einen In-Memory-Cache *vor* dem Index-Layer.
Replay-Läufe (Worked Example Modul 10) zeigen Stale-Reads nach
Index-Updates — die ADR-0007-Annahme "Cache kann nicht stale
werden" hält nicht.

## Optionen
1. Read-through-Cache *hinter* dem Index-Layer — Cache wird bei
   Index-Update invalidiert; etwas höhere Latenz beim ersten Read.
2. Cache ersatzlos entfernen — keine Stale-Reads, aber
   LH-QA-PERF-003 (p95 < 200 ms) wird unter Last verfehlt.

## Entscheidung
Option 1: Read-through hinter dem Index-Layer; Invalidierung am
Index-Update-Pfad.

## Konsequenzen
Die Fitness Function aus ADR-0007 (`arch_no_cache_in_handler`)
bleibt bestehen und wird verschärft: zusätzlich Contract "kein
Cache-Import im Index-Layer selbst"; Gate weiterhin
`make arch-check`.
```

Warum dieser Entwurf trägt:

- Der Kopf erfüllt die drei Pflicht-Anker: Status,
  `supersedes: ADR-0007`, `LH-*`-Bezug — damit ist die Kette
  auditierbar und die Hard Rule (Accepted wird nie umgeschrieben)
  gewahrt.
- Mindestens eine *explizit benannte* Option steht im Body, und der
  Trade-off gegen ADR-0007 ist ein *Beleg* (Stale-Reads im Replay),
  keine Geschmacksfrage.
- Die Konsequenzen-Zeile wirkt explizit auf die Fitness Function des
  Vorgängers zurück (bleibt sie? wird sie verschärft? entfällt sie?)
  — wer das offen lässt, verschiebt das Drift-Risiko nur in den
  nächsten Slice.

Anti-Antwort: ein Kopf plus Body "neue Entscheidung folgt". Das ist
kein Folge-ADR, sondern ein Platzhalter — die offene Entscheidung
bleibt offen, nur jetzt mit Nummer.

## Übungshinweise

### ADR für Modellwahl

Maßstab:

- Mindestens drei verglichene Alternativen (z. B. Claude Opus 4.7, GPT-5, Llama-Modell).
- Vergleich entlang messbarer Kriterien: Kosten/Token, Latenz, Context-Window, Tool-Use-Reife, On-Prem-Option.
- Annahmen explizit ("wir setzen Caching ein", "wir akzeptieren 1k Tool-Calls/Tag").
- Konsequenzen mit Trigger für Re-Evaluierung ("re-evaluieren, wenn Kosten > $X/Monat oder neue Modellgeneration erscheint").

### ADR für Tool Calling

Konkrete Entscheidungen, die in eine solche ADR gehören:

- Welche Tool-Schemas: OpenAI-Functions, JSON-Schema, Anthropic-Tools?
- Tool-Allowlist: was darf der Agent aufrufen, was nicht (Datenbank-Schreibzugriff, Shell-Exec, externe HTTP)?
- Fehlerverhalten bei abgelehntem Tool: hart abbrechen oder retry-mit-Erklärung?
- Logging-Vertrag: was muss pro Tool-Call mindestens festgehalten werden (siehe Modul 15)?

### ADR für Evaluierung

Konkrete Entscheidungen, die in eine solche ADR gehören:

- Evaluierungs-Methode: deterministische Checks (Replay gegen
  Akzeptanzkriterien), LLM-as-Judge, menschliches Stichproben-Review —
  oder welche Kombination, mit welcher Gewichtung?
- Golden-Set-Verwaltung: wo liegen die Referenzfälle, wer darf sie
  ändern, wie werden sie versioniert (ein stilles Golden-Set-Update
  ist ein unauditierter Maßstabswechsel)?
- Schwellen und Gate-Verdrahtung: ab welcher Pass-Rate ist ein Lauf
  grün, und welches Make-Target/CI-Gate setzt das durch?
- Re-Evaluierungs-Trigger: wann wird neu gemessen (Modellwechsel,
  Prompt-Änderung, Spec-Erweiterung)?

Falle: "Wir evaluieren mit einem LLM-Judge" ohne
Judge-Prompt-Versionierung — dann ist der Maßstab selbst nicht
reproduzierbar. Die Konsequenzen-Sektion sollte benennen, wie der
Judge eingefroren und auditierbar gehalten wird (siehe Modul 12).

### ADR für Layering

Beispiel-Schema:

```
Types  → keine Imports (atomarer Layer)
Config → darf Types
Repo   → darf Types, Config
Service → darf Types, Config, Repo
Runtime → darf alles oben
UI → darf alles oben außer Repo
```

Fitness Function:

- Go: `depguard` mit `denyList` pro Layer.
- Python: `import-linter` mit `forbidden`-Contracts.
- Java/Kotlin: ArchUnit `noClasses().that().resideIn("..service..").should().dependOn(..)`.

Erfolgskriterium: Verletzungs-Provokation in einem Test bricht `make arch-check`.

### Agent gegen eine vorhandene ADR-Verletzung laufen lassen (LZ 3)

Die Übung prüft *Erkennung*, nicht Provokation: Im Code existiert
bereits eine ADR-Verletzung (aus einem echten Repo — oder vorab
eingebaut, z. B. ein direkter `http.Client`-Import im Service-Layer
entgegen der Adapter-ADR). Der Agent läuft mit Zugriff auf die ADRs
darüber; geprüft wird, ob er die Verletzung *erkennt und benennt*.

Drei mögliche Ausgänge und ihre Diagnose:

| Beobachtung | Diagnose |
|---|---|
| Agent benennt die Verletzung *mit* ADR-Nummer und betroffener Stelle | ADR ist prüfbar formuliert und im Kontext erreichbar — die Vorstufe der Fitness-Function-Übersetzung steht. |
| Agent moniert das Symptom ("enge Kopplung"), nennt aber keine ADR | ADR-Aussage zu vage oder nicht auffindbar (fehlt im Kontext-Pfad: `harness/README.md` → `docs/plan/adr/`); Lopopolo: was der Agent nicht im Kontext erreicht, existiert für ihn nicht. |
| Agent sieht nichts — oder verteidigt den Verstoß ("schien einfacher") | Die ADR ist Absichtserklärung: ohne prüfbare Formulierung kann der Lauf sie nicht anwenden. Konsequenz: ADR-Satz präzisieren *und* Fitness Function nachziehen (Modul 13). |

Der Lernpunkt der Übung: Eine ADR-Verletzung wird nur erkannt, wenn
die ADR-Aussage *prüfbar formuliert* ist — genau das ist die Vorstufe
der Übersetzung in eine Fitness Function. Wo der Agent versagt, würde
auch ein menschlicher Reviewer raten.

Anschlussfrage für die Reflexion: Welcher Sensor *hätte* die
Verletzung deterministisch gemeldet (ArchUnit/import-linter im
Pre-commit statt Reviewer-Urteil)? Je früher und maschineller, desto
billiger.

## Häufige Fehler

- **ADR beschreibt Implementierung statt Entscheidung.** ADR ist eine *Wahl zwischen Alternativen* mit Begründung, nicht eine "so geht's"-Beschreibung.
- **ADR ohne Annahmen.** Annahmen sind die Stellen, an denen die Entscheidung kippt. Ohne sie kann niemand entscheiden, ob die ADR noch gilt.
- **Accepted-ADR wird umgeschrieben.** Bricht das Geschichtsbuch-Prinzip ([c-hsm-doc-Beispiel](../grundlagen/fallstudien.md)). Korrektur als neue ADR mit "supersedes ADR-N".
- **ADR ohne Fitness Function.** "Wir machen Hexagonal Architecture" ohne Architekturtest ist Lippenbekenntnis. Spätestens beim dritten Refactor ist die Schicht durchlöchert.

## Verweise

- 2×2-Klassifikation (ADR als Feedforward + Quelle für Computational Feedback): [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)
- ADR-Beispiele: [`/lab/example/docs/plan/adr/`](../../../lab/example/docs/plan/adr/) (im Lab nach Phase B)
- Vorherige Lösung: [Modul 3](modul-03-loesung.md)
- Nächste Lösung: [Modul 5](modul-05-loesung.md)
