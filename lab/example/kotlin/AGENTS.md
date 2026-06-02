# AGENTS.md — Kotlin-spezifische Ergänzung

Ergänzt [`../AGENTS.md`](../AGENTS.md). Bei Konflikt gilt `../AGENTS.md`.

## Sprach-spezifische Hard Rules

### K-1 — `@Suppress` ist verboten

`@Suppress("...")` bricht das `suppression-gate`. Ausnahmen leben in
`config/detekt-baseline.xml` mit Begründung und Slice-ID.

### K-2 — Layering via Konsist

ADR-0001 Layering wird durch Konsist-Tests in `src/test/kotlin/com/example/docsearch/ArchitectureTest.kt`
durchgesetzt. Verstöße brechen `make arch-check`.

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
- [ ] `./gradlew test` grün, inkl. Konsist-Tests.
- [ ] `./gradlew koverVerify` grün.
- [ ] Test-Namen mit LH-Bezug: `searchHappyPath_LHFA02`.
