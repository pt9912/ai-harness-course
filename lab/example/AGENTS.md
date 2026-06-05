# AGENTS.md — Briefing für AI-Coding-Agenten

Dieses Dokument ist das Onboarding für jede AI-Session, die in diesem
Beispiel-Repo Code oder Dokumentation ändert. Es trägt die **harten
Regeln** und **Pointer auf die kanonischen Quellen**, nicht deren
Inhalt.

**Bei Konflikt zwischen dieser Datei und einer kanonischen Quelle gilt
die kanonische Quelle.**

Strukturregeln (ID-Schemata, Verzeichniskonvention, Adaptionen ggü.
Baseline, Modus-Deklarationen pro Sub-Area, Zusatzklassen für
Sensors-Bindung) leben in
[`harness/conventions.md`](harness/conventions.md).

## 1. Kanonische Quellen (Source Precedence)

1. [`spec/lastenheft.md`](spec/lastenheft.md)
2. [`spec/spezifikation.md`](spec/spezifikation.md)
3. [`spec/architecture.md`](spec/architecture.md)
4. [`docs/plan/adr/README.md`](docs/plan/adr/README.md)
5. [`docs/plan/planning/in-progress/roadmap.md`](docs/plan/planning/in-progress/roadmap.md)
6. [`README.md`](README.md)
7. AGENTS.md (diese Datei)
8. [`harness/README.md`](harness/README.md)

## 2. Harte Regeln

### 2.1 Docker-only

Kein lokales SDK-Install. Alles über `make` (Docker im Hintergrund).

**Falsch:** `go run ./cmd/docsearch`
**Richtig:** `make run`

**Begründung:** Toolchain-Reproduzierbarkeit + Supply-Chain-Defense.

### 2.2 Suppression-Verbot

Inline-Suppression bricht das `suppression-gate`. Pro Sprache:

| Sprache | Markierung | Zentraler Pfad für Ausnahmen |
|---|---|---|
| Go | `//nolint` | `.golangci.yml` `issues.exclude-rules` |
| Python | `# noqa`, `# type: ignore` | `pyproject.toml` `[tool.ruff.lint.per-file-ignores]` |
| C# | `#pragma warning disable`, `[SuppressMessage]` | `.editorconfig` + `Directory.Build.props` |
| Kotlin | `@Suppress("...")` | `detekt.yml` (`baselines`) |
| Java | `@SuppressWarnings("...")` | `checkstyle-suppressions.xml` |

Ausnahmen brauchen eine Begründung mit Verweis auf ADR oder Slice-ID.

### 2.3 git mv + Inhaltsänderung = zwei Commits

Reine Move-Commits zuerst, dann inhaltliche Änderungen. Sonst fällt
Git-Rename-Detection unter 50 %-Schwelle.

### 2.4 Architektur ist sprach- und meilensteinfrei

`spec/architecture.md` referenziert ADRs und Modul-Pfade, aber **keine**
Wellen, Slices, Commit-Hashes oder Closure-Daten.

### 2.5 ADRs sind nach `Accepted` immutable

Korrekturen entstehen als neue ADR mit `Supersedes ADR-NN`.

### 2.6 Gates dürfen nicht ohne ADR gelockert werden

Jede Schwellen-Senkung ist ein ADR plus Carveout, kein PR-Kommentar.

### 2.7 Tie-Break in sortierenden Operationen ist explizit

Eingeführt durch slice-009 (siehe Closure-Notiz). Jede `sort`-Operation
muss bei gleichem Sortier-Schlüssel einen deterministischen Tie-Break
benennen.

### 2.8 Welle-Self-Close-Commit-Konvention

Sobald ein Slice-Plan den Status `Done` erreicht, schließt er seine
eigene Commit-Sequenz mit einem reinen `git mv` nach `done/`. Inhaltliche
Folge-Edits (relative Link-Anpassung, Closure-Notiz schreiben) landen
im **unmittelbar nachfolgenden** Commit.

## 3. Quality Gates

Nur Befehle, die im Makefile existieren (Stand 2026-06-02):

| Target | Zweck |
|---|---|
| `make lint` | Linter + Suppression-Gate |
| `make typecheck` | Statische Typprüfung |
| `make arch-check` | Layering-Constraints aus ADR-0001 |
| `make test` | Unit-Tests |
| `make test-determinism` | LH-QA-02: 100 identische Läufe |
| `make coverage-gate` | Gesamt-Coverage (bootstrap-aware) |
| `make coverage-gate-critical` | Critical-Path-Coverage (siehe CO-001) |
| `make gates` | alle inneren Gates (mandatory vor PR) |
| `make ci` | gates + Replay-Lauf + Image-Scan |
| `make fullbuild` | volle Closure inkl. Runtime-Image |

(Diese Targets sind in den Sprach-Skeletten unter `go/`, `python/`,
`kotlin/`, `java/`, `csharp/` real implementiert — kommen in Phase C.)

## 4. Dokumentations-Regeln

- Requirement- und Architektur-IDs müssen in PRs/Commits referenziert sein.
- Neue ADRs müssen `docs/plan/adr/README.md` aktualisieren.
- Roadmap/Status-Geschichte lebt in `docs/plan/planning/`, nicht in `spec/architecture.md`.
- Quality-Gate-Definitionen leben in `docs/user/quality.md` (sprach-übergreifend) bzw. sprach-spezifisch in `<sprache>/README.md`.

## 5. Minimal Agent Workflow

1. `harness/README.md` lesen.
2. Relevante kanonische Quelle lesen.
3. Betroffene IDs identifizieren.
4. Kleinste Änderung planen.
5. Engsten nützlichen Sensor laufen lassen.
6. Repo-weiten Gate-Lauf vor Handoff (`make gates`).
7. Doku/Indizes aktualisieren, falls ein öffentlicher Vertrag berührt.
8. Ausgeführte Sensors und verbleibende Risiken berichten.
