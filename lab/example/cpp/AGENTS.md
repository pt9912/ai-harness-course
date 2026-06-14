# AGENTS.md — C++-spezifische Ergänzung

Dieser Anhang ergänzt [`../AGENTS.md`](../AGENTS.md) um C++-spezifische
Hard Rules. **Bei Konflikt gilt `../AGENTS.md`** (Source Precedence).

## Sprach-spezifische Hard Rules

### C-1 — Suppression-Verbot konkret

Inline-Marker brechen das `suppression-gate` (umgesetzt in
`cmake/suppression-gate.sh`): `// NOLINT`, `// NOLINTNEXTLINE`,
`// NOLINTBEGIN`, `#pragma GCC diagnostic ignored`,
`#pragma clang diagnostic`. Echte Ausnahmen werden mit Begründung und
ADR-/Slice-ID zentral in `.clang-tidy` dokumentiert.

### C-2 — Layering via arch-check

Die Architektur-Constraints aus ADR-0001 werden durch
`cmake/arch-check.sh` (Include-Heuristik) durchgesetzt. Verstöße brechen
`make arch-check`.

| Schicht | Darf NICHT importieren |
|---|---|
| `src/hexagon/**` | irgendetwas aus `adapters/` (Kern-Reinheit) |
| `src/hexagon/index/` | `hexagon/service/`, `hexagon/ports/` |
| `src/adapters/ui/` | `hexagon/index/`, `adapters/embedding/` |
| `src/adapters/embedding/` | `hexagon/index/`, `hexagon/service/`, `adapters/ui/` |

### C-3 — Stable-Sort plus Tie-Break

Aus `../AGENTS.md` §2.7 plus slice-009 (siehe
[`../docs/plan/planning/done/slice-009-tie-break-determinismus.md`](../docs/plan/planning/done/slice-009-tie-break-determinismus.md)):
**`std::sort` ohne expliziten Tie-Break ist verboten** (instabil →
nicht-deterministische Reihenfolge bei gleichem Score). Verwende
`std::stable_sort` mit explizitem Vergleich nach `(doc_path,
section_index)`.

### C-4 — Fehler tragen einen Code, kein roher Wurf

Service-Fehler sind `SearchError` mit Spec-Code (`E002`, `E003` aus
`spec/spezifikation.md` §4); der UI-Adapter mappt den Code auf den
HTTP-Status. Kein nacktes `throw std::runtime_error("...")` ohne Code im
Service-Layer.

## Pre-completion Checklist (C++)

Vor der `make test`-Erfolgsmeldung muss der Implementer prüfen:

- [ ] `make typecheck` grün (`-Werror`).
- [ ] `make lint` grün (clang-tidy + suppression-gate).
- [ ] `make arch-check` grün.
- [ ] `make coverage-gate` grün (oder Carveout dokumentiert).
- [ ] Spec-Bezug in Test-Namen (`LH-FA-02 Boundary …`, `slice-009 TieBreak`).
