# AGENTS.md — C#-spezifische Ergänzung

Ergänzt [`../AGENTS.md`](../AGENTS.md). Bei Konflikt gilt `../AGENTS.md`.
Anlehnung an `pt9912/bess-ems`.

## Hard Rules

### C-1 — `#pragma warning disable` und `[SuppressMessage]` verboten

Inline-Suppression bricht das `solid-suppression-gate`. Ausnahmen leben
in `.editorconfig` bzw. `Directory.Build.props` mit Begründung und
Slice-ID. Nach Vorbild bess-ems.

### C-2 — Layering via NetArchTest

ADR-0001 wird durch NetArchTest-Tests in `tests/DocSearch.Tests/ArchitectureTests.cs`
durchgesetzt.

### C-3 — Central Package Management ist Pflicht

`Directory.Packages.props` definiert alle `PackageVersion`-Pins.
Einzelne `.csproj`-Dateien nutzen `PackageReference` ohne `Version`-Attribut.
`RestoreLockedMode=true` verlangt aktuelle `packages.lock.json`.
Begründung: Reproduzierbarkeit (LH-QA-03).

### C-4 — Stable-Sort plus Tie-Break

LINQ `.OrderByDescending(x => x.Score)` ist nicht stable. Pflicht:
`.OrderByDescending(...).ThenBy(...).ThenBy(...)` mit explizitem Tie-Break.
LINQ `OrderBy` ist tatsächlich stable, aber expliziter Tie-Break ist
weiterhin Pflicht (slice-009).

### C-5 — `record` für Domain-Modell

Domain-Typen sind immutable `record`s. Mutable Klassen nur in Service/Index
mit Begründung.

## Pre-completion Checklist (C#)

- [ ] `dotnet format --verify-no-changes` grün.
- [ ] `dotnet build -warnaserror` grün.
- [ ] `dotnet test` grün, inkl. NetArchTest.
- [ ] `coverlet`-Schwelle erreicht.
- [ ] Test-Namen mit LH-Bezug: `Search_HappyPath_LHFA02`.
