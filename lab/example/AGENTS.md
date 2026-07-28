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

Das **Betriebsregelwerk der adoptierten Baseline in Agenten-Kurzform**
ist das [Kurs-Regelwerk](../regelwerk/README.md) (pro Abschnitt eine Datei) —
den relevanten Abschnitt pro Session nachschlagen, bevor der Workflow (§5)
startet. Derivativ: bei Konflikt gelten die kanonischen Quellen; adoptierter
Stand steht in [`harness/conventions.md`](harness/conventions.md) §Baseline.

## 1. Kanonische Quellen (Source Precedence)

1. [`spec/lastenheft.md`](spec/lastenheft.md)
2. [`spec/spezifikation.md`](spec/spezifikation.md)
3. [`spec/architecture.md`](spec/architecture.md)
4. [`docs/plan/adr/README.md`](docs/plan/adr/README.md)
5. [`docs/plan/planning/in-progress/roadmap.md`](docs/plan/planning/in-progress/roadmap.md)
6. [`docs/user/`](docs/user/)
7. [`README.md`](README.md)
8. AGENTS.md (diese Datei)
9. [`harness/README.md`](harness/README.md)

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
| C++ | `// NOLINT`, `#pragma GCC diagnostic` | `.clang-tidy` |

Ausnahmen brauchen eine Begründung mit Verweis auf ADR oder Slice-ID.

### 2.3 git mv + Inhaltsänderung = zwei Commits

Reine Move-Commits zuerst, dann inhaltliche Änderungen. Sonst fällt
Git-Rename-Detection unter 50 %-Schwelle.

### 2.4 Architektur ist sprach- und meilensteinfrei

`spec/architecture.md` referenziert ADRs und Modul-Pfade, aber **keine**
Wellen, Slices, Commit-Hashes oder Closure-Daten.

### 2.5 ADRs sind nach `Accepted` immutable

Korrekturen entstehen als neue ADR mit `Supersedes ADR-NNNN`.

### 2.6 Gates dürfen nicht ohne ADR gelockert werden

Jede Schwellen-Senkung ist ein ADR plus Carveout, kein PR-Kommentar.

### 2.7 Tie-Break in sortierenden Operationen ist explizit   (seit welle-1)

Jede `sort`-Operation muss bei gleichem Sortier-Schlüssel einen
deterministischen Tie-Break benennen. Der Herkunfts-Anker `seit welle-1`
zeigt auf [`docs/plan/planning/done/welle-1-results.md`](docs/plan/planning/done/welle-1-results.md)
§Steering-Loop-Einträge — dort stehen die drei auslösenden Slices. Ohne
diesen Rückweg wäre beim nächsten Aufräumen nicht mehr erkennbar, welche
Beobachtung die Regel erzwungen hat.

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
| `make ci` | gates + `test-determinism` + `coverage-gate-critical` |
| `make fullbuild` | volle Closure inkl. Runtime-Image |

(Diese Targets sind in den Sprach-Skeletten unter `go/`, `python/`,
`kotlin/`, `java/`, `csharp/`, `cpp/` real implementiert. Das Root-`Makefile`
reicht davon nur `gates`, `ci` und `fullbuild` per `COURSE_LANG` durch; die
übrigen ruft man im jeweiligen Sprach-Verzeichnis auf.)

Weder **Golden-Set-Replay** noch **Image-Scan** hängen an `ci`. Einen
Image-Scan gibt es im Repo überhaupt nicht. Für das Golden Set existiert das
Root-Target `make replay RUN=<set-name>` (der Name unterhalb
`evals/golden/`, z. B. `welle-1-baseline`); es prüft, ob das Golden-Set-Verzeichnis vollständig ist (Manifest mit
`model:`- und `runtime:`-Block, `inputs/`, `expectations/`, mindestens drei
Cases, gleiche Anzahl beider Seiten) und **führt den Replay nicht aus** (Modul 12).

## 4. Dokumentations-Regeln

- Requirement- und Architektur-IDs müssen in PRs/Commits referenziert sein.
- Neue ADRs müssen `docs/plan/adr/README.md` aktualisieren.
- Roadmap/Status-Geschichte lebt in `docs/plan/planning/`, nicht in `spec/architecture.md`.
- **Ein Gate ist dort definiert, wo seine Bindung steht** — nicht an einem
  zentralen Ort. Welche Bindung ein Target hat, sagt die Spalte *Bindung* in
  [`harness/README.md` §Sensors](harness/README.md#sensors-feedback-gates);
  von dort führt der Weg weiter, z. B. `lint` → LH-QA-04, `arch-check` →
  ADR-0001, `test-determinism` → LH-QA-02, `coverage-gate` und
  `coverage-gate-critical` → ADR-0013 — und für die Ausnahme des kritischen
  Gates weiter zu
  [CO-001 §Geltungs-Konfiguration](docs/plan/carveouts/CO-001-index-coverage.md#geltungs-konfiguration).
  §3 dieser Datei listet die Targets nur auf; definiert wird dort nichts.
  Sprach-spezifische Ergänzungen stehen in `<sprache>/harness/README.md` —
  unvollständig, nicht jedes Skelett führt jedes Target.
- `docs/user/` ist **Platzhalter** (siehe [`docs/user/README.md`](docs/user/README.md)).
  Eine ops-gerichtete `docs/user/quality.md` entsteht mit `slice-013`.

## 5. Minimal Agent Workflow

1. `harness/README.md` lesen.
2. Relevante kanonische Quelle lesen.
3. Betroffene IDs identifizieren.
4. Kleinste Änderung planen.
5. Engsten nützlichen Sensor laufen lassen.
6. Repo-weiten Gate-Lauf vor Handoff (`make gates`).
7. Doku/Indizes aktualisieren, falls ein öffentlicher Vertrag berührt.
8. Ausgeführte Sensors und verbleibende Risiken berichten.
