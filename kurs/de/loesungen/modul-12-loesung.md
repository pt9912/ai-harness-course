# Lösung — Modul 12: Quality Gates

Zugehöriges Modul: [Modul 12 — Quality Gates](../04-qualitaet/modul-12-quality-gates.md).

## Selbstcheck-Antworten

### Warum braucht es Critical Coverage zusätzlich zur Gesamt-Coverage?

Gesamt-Coverage ist ein Durchschnitt — sie ist über alle Dateien
gleichgewichtet, auch wenn 90 % der Codebase Beispiel-Daten oder
DTOs sind. Das verbirgt zwei Pathologien:

1. **Sicherheitsrelevanter Code mit niedriger Coverage neben Daten-Klassen mit 100 %.** Der Durchschnitt sieht gut aus, der kritische Pfad ist ungetestet.
2. **Coverage-Manipulation durch Trivialität.** Wer 100 Getter testet, kompensiert für ungeprüfte Geschäftslogik.

Critical Coverage schneidet aus: definierte Pfade (z. B. `auth/`,
`payment/`, `optimizer/`) müssen *einzeln* eine höhere Schwelle
erfüllen. Damit wird:

- Gesamt-Coverage zur *Gesundheits-Metrik* (langsame Drift),
- Critical Coverage zum *Vertragspunkt* (harte Schwelle, fail-closed),
- Carveouts pro kritischen Pfad sichtbar (mit Trigger und Folge-Slice).

### Welcher Gate-Typ erkennt eine SQL-Injection — Linter, Typecheck oder Security Gate?

Primär Security Gate (Semgrep, CodeQL, language-spezifische
SAST-Tools). Linter und Typecheck sehen meist nur Typen und Stil,
nicht Datenfluss.

Aber: Eine ADR mit "Alle DB-Zugriffe gehen über Repository-Klasse mit
parametrisierten Queries" plus depguard/import-linter, das direkte
SQL-String-Builds verbietet, ist die *präventive* Variante
(Computational + Feedforward). Das erste Gate, das anschlägt, ist dann
das Architektur-Gate — *vor* dem Security-Gate.

Faustregel: Wenn dein Security-Gate eine SQL-Injection im
Production-Code findet, war die Schichtung lückenhaft. Security-Gates
sollen Reste fangen, nicht das Hauptpensum tragen.

## Übungshinweise

### Schreibe einen Architekturtest, der ADR-3 als Regel umsetzt

Wenn ADR-3 z. B. besagt "Layer Service darf nur Repo importieren,
nicht Runtime", dann:

- **Go (depguard)**: `denyList: { "**/runtime/**": { "**/service/**" } }`.
- **Python (import-linter)**: `forbidden_modules = service` mit `from = runtime`.
- **Java/Kotlin (ArchUnit)**:
  ```
  noClasses().that().resideInAPackage("..service..")
    .should().dependOnClassesThat().resideInAPackage("..runtime..")
  ```

Erfolgskriterien:

- Test schlägt fehl, *bevor* du den Verstoß im Code einbaust (Vorab-Validierung).
- Test bricht `make arch-check` und damit `make gates` — nicht nur ein Warning.
- Test referenziert die ADR-ID im Kommentar.

### Provoziere absichtlich einen Coverage-Gate-Failure auf einer kritischen Datei

Vorgehen:

1. Lege eine neue Funktion in `optimizer/critical.go` (oder Äquivalent) ohne Test an.
2. Stelle sicher, dass `coverage-gate-critical` die Datei sieht.
3. Führe `make coverage-gate-critical` aus → muss rot werden.
4. Schreibe minimalen Test → grün.

Warum diese Übung wichtig ist: Sie validiert, dass dein
Critical-Coverage-Gate *funktioniert*. Häufiger Fehler: Gate ist
konfiguriert, aber Critical-Pfad ist im Glob falsch und matched
nichts — Gate ist also stumm.

## Häufige Fehler

- **Gate-Existenz wird mit Gate-Wirkung verwechselt.** `make coverage-gate` *gibt* es, aber prüft 0 %. → Halluzinations-Gate, siehe Disziplinregel aus Modul 12.
- **Schwelle in der Pipeline-YAML statt im Makefile.** → Lokales `make` und CI driften. Schwelle gehört dorthin, wo sie reproduzierbar gilt.
- **Bootstrap-aware-Marker fehlt.** → Wenn das Gate "aktuell 40 %" prüft, ohne den Trigger für "morgen 70 %" zu nennen, wird der Bootstrap zur permanenten Lüge.

## Verweise

- Reichhaltige Gate-Landschaft aus grid-gym: [Modul 12](../04-qualitaet/modul-12-quality-gates.md) und [Fallstudie](../grundlagen/fallstudien.md)
- Computational-Feedback-Quadrant: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)
- Vorherige Lösung: [Modul 11](modul-11-loesung.md)
- Nächste Lösung: [Modul 13](modul-13-loesung.md)
