# AGENTS.md — Kotlin-spezifische Ergänzung

Ergänzt [`../AGENTS.md`](../AGENTS.md). Bei Konflikt gilt `../AGENTS.md`.

## Sprach-spezifische Hard Rules

### K-1 — `@Suppress` ist verboten

`@Suppress("...")` bricht das `suppression-gate`. Ausnahmen leben in
`config/detekt-baseline.xml` mit Begründung und Slice-ID.

### K-2 — Layering via Konsist und a-check

[ADR-0001](../docs/plan/adr/0001-hexagonale-architektur.md) Layering wird von **zwei** Sensoren durchgesetzt, beide hinter
`make arch-check`
([ADR-0016](../docs/plan/adr/0016-a-check-in-allen-skeletten.md)): die
Konsist-Tests in `src/test/kotlin/com/example/docsearch/ArchitectureTest.kt`
und die Deklaration in `.a-check.yml`. Verstöße brechen `make arch-check`.

`.a-check.yml` ist eine **Allow-Liste**: Erlaubt ist, was als Kante deklariert
ist — auch die Kanten, für die es keinen Konsist-Test gibt (`types` hat
keinen).

**Gemeinsame Grenze, hier wichtig.** Die Konsist-Regeln prüfen `file.imports`,
a-check liest Import-Zeilen. Eine **voll qualifizierte Nutzung ohne Import**
(`com.example.docsearch.ui.Handler` mitten im Code) sehen deshalb **beide
nicht** — gemessen: compiliert, a-check 0 Befunde, Konsist grün. Die
`constructs`-Regel in `.a-check.yml` schließt davon die Richtung auf `ui`; für
die übrigen Kanten bleibt die Lücke. Schreiben Sie schicht-übergreifende
Bezüge deshalb als Import.

### K-3 — Stable-Sort plus Tie-Break

`sortedByDescending { it.score }` ist nicht ausreichend. Pflicht:
expliziter `Comparator` mit Tie-Break.

### K-4 — `data class` für Domain-Modell

Domain-Typen sind immutable `data class`. Mutable Container nur in
Service-/Index-Schicht und nur dort, wo Performance es erzwingt
(mit ADR).

### K-5 — `internal`-Sichtbarkeit für Schicht-Interna

Klassen, die nur innerhalb einer Schicht genutzt werden, sind
`internal`. Konsist erzwingt die Schicht-Grenzen unabhängig davon —
`internal` ist defense in depth.

## Pre-completion Checklist (Kotlin)

- [ ] `./gradlew detekt` grün.
- [ ] `make arch-check` grün (Konsist **und** a-check).
- [ ] `./gradlew test` grün.
- [ ] `./gradlew koverVerify` grün.
- [ ] Test-Namen mit LH-Bezug: `searchHappyPath_LHFA02`.
