# AGENTS.md — Java-spezifische Ergänzung

Ergänzt [`../AGENTS.md`](../AGENTS.md). Bei Konflikt gilt `../AGENTS.md`.

## Hard Rules

### J-1 — `@SuppressWarnings` ist verboten

Ausnahmen leben in `checkstyle-suppressions.xml` mit Begründung und
Slice-ID.

### J-2 — Layering via ArchUnit

ADR-0001 wird durch ArchUnit-Tests in
`src/test/java/com/example/docsearch/ArchitectureTest.java` durchgesetzt.

### J-3 — Stable-Sort plus Tie-Break

`Collections.sort(..., Comparator.comparing(...).reversed())` ohne
expliziten Tie-Break ist verboten. Pflicht: zusätzlicher `.thenComparing`.

### J-4 — `record` für Domain-Modell

Domain-Typen sind immutable `record`s.

### J-5 — `var` ist erlaubt für lokale Variablen, NICHT für API

Public-API-Signaturen tragen explizite Typen; `var` ist nur in Methoden-
Körpern.

## Pre-completion Checklist (Java)

- [ ] `mvn checkstyle:check` grün.
- [ ] `mvn test` grün, inkl. ArchUnit-Tests.
- [ ] `mvn jacoco:check` grün.
- [ ] Test-Namen mit LH-Bezug: `searchHappyPath_LHFA02()`.
