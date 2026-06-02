# Lösung — Modul 3: Architektur und ADRs

Zugehöriges Modul: [Modul 3 — Architektur und ADRs](../01-spec-und-architektur/modul-03-architektur-adrs.md).

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

### Was ist der Unterschied zwischen *superseded* und *deprecated* ADR?

- **Deprecated**: Die Entscheidung gilt weiterhin für vorhandenen Code,
  aber für *neuen* Code nicht mehr. Es gibt (noch) keinen Nachfolger.
  Migration ist optional. Beispiel: "Wir nutzen JUnit 4. (Deprecated:
  neue Tests in JUnit 5.)"
- **Superseded by ADR-N**: Eine spätere ADR-N hat diese Entscheidung
  abgelöst. Die Begründung der Ablösung steht in ADR-N. Bestehender
  Code soll migriert werden, der Trigger steht in ADR-N. Beispiel:
  "ADR-7 Modellwahl Claude 3.5 (Superseded by ADR-12 Modellwahl
  Claude 4.5)."

Praxis: *Deprecated* ohne Folge-Plan ist meistens *Superseded* ohne
Nachfolger — also eine Lücke. Wenn du nur "deprecated" schreibst und
keine Migrationstrigger benennst, gehört das in den Steering Loop:
entweder ADR-Folge-Slice oder Carveout.

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
- Logging-Vertrag: was muss pro Tool-Call mindestens festgehalten werden (siehe Modul 14)?

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

### Provoziere eine ADR-Verletzung

Gute Trigger:

- Lass den Agenten "schnell mal eben" eine Service-Klasse direkt aus dem Runtime-Layer instanziieren.
- Lass ihn ein Repository-Interface direkt im UI-Layer importieren mit Begründung "ist doch nur ein DTO".

Frage: Wann (in welcher Phase) hat der Sensor das gemeldet? Pre-commit,
Pre-integration, erst im Reviewer-Agent? Je früher, desto billiger.

## Häufige Fehler

- **ADR beschreibt Implementierung statt Entscheidung.** ADR ist eine *Wahl zwischen Alternativen* mit Begründung, nicht eine "so geht's"-Beschreibung.
- **ADR ohne Annahmen.** Annahmen sind die Stellen, an denen die Entscheidung kippt. Ohne sie kann niemand entscheiden, ob die ADR noch gilt.
- **Accepted-ADR wird umgeschrieben.** Bricht das Geschichtsbuch-Prinzip ([c-hsm-doc-Beispiel](../grundlagen/fallstudien.md)). Korrektur als neue ADR mit "supersedes ADR-N".
- **ADR ohne Fitness Function.** "Wir machen Hexagonal Architecture" ohne Architekturtest ist Lippenbekenntnis. Spätestens beim dritten Refactor ist die Schicht durchlöchert.

## Verweise

- 2×2-Klassifikation (ADR als Feedforward + Quelle für Computational Feedback): [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)
- ADR-Beispiele: [`/lab/example/docs/plan/adr/`](../../../lab/example/docs/plan/adr/) (im Lab nach Phase B)
- Vorherige Lösung: [Modul 2](modul-02-loesung.md)
- Nächste Lösung: [Modul 4](modul-04-loesung.md)
