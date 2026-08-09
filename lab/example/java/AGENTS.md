# AGENTS.md — Java-spezifische Ergänzung

Ergänzt [`../AGENTS.md`](../AGENTS.md). Bei Konflikt gilt `../AGENTS.md`.

## Hard Rules

### J-1 — `@SuppressWarnings` ist verboten

Ausnahmen leben in `checkstyle-suppressions.xml` mit Begründung und
Slice-ID.

### J-2 — Layering via ArchUnit und a-check

ADR-0001 wird von **zwei** Sensoren durchgesetzt, beide hinter
`make arch-check`
([ADR-0016](../docs/plan/adr/0016-a-check-in-allen-skeletten.md)): die
ArchUnit-Tests in `src/test/java/com/example/docsearch/ArchitectureTest.java`
und die Deklaration in `.a-check.yml`.

Sie sehen Verschiedenes. ArchUnit importiert **Bytecode** und sieht deshalb
auch eine voll qualifizierte Nutzung ohne Import; a-check liest Import-Zeilen
und sieht sie nicht. Umgekehrt ist `.a-check.yml` eine **Allow-Liste**: Erlaubt
ist, was als Kante deklariert ist — auch dort, wo ArchUnit keine Regel führt
(`types` hat keine).

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
- [ ] `make arch-check` grün (ArchUnit **und** a-check).
- [ ] `mvn test` grün.
- [ ] `mvn jacoco:check` grün.
- [ ] Test-Namen mit LH-Bezug: `searchHappyPath_LHFA02()`.
