# Slice 013: Property-Based Tests für deterministische Sortierung

**Status:** in-progress

**Welle:** welle-2-qualitaet

**Bezug:** LH-QA-02 (Reproduzierbarkeit), LH-FA-02 (Suche)

**Autor:** Kurs-Lab. **Datum:** 2026-06-01.

## 1. Ziel

Property-Based Tests einführen, die die deterministische Sortierung der
Suchergebnisse über generierte Eingaben sicherstellen. Ergänzt
`test-determinism` (heute: fixierte Inputs) um Eigenschaft-Suite
(beliebige Inputs).

## 2. Definition of Done

- [ ] Pro Sprache ein Property-Test (z.B. `gopter` für Go, `hypothesis` für Python, `Kotest` für Kotlin, `jqwik` für Java, `FsCheck` für C#).
- [ ] Eigenschaft: Für beliebige Index-Inhalte und Anfragen ist die Reihenfolge bei gleichem Score reproduzierbar.
- [ ] Neues Make-Target `test-property` läuft in `make gates`.
- [ ] `test-property` läuft 100 Generationen, fail-closed.
- [ ] Closure-Notiz mit gefundenen Counter-Examples (falls welche).

## 3. Plan (vor Code)

| Datei / Komponente | Änderungs-Art | Begründung |
|---|---|---|
| `<sprache>/Makefile` | update | `test-property`-Target, in `gates`-Liste |
| `<sprache>/tests/property/` | neu | Property-Test-Dateien |
| `docs/user/quality.md` | update | `test-property` dokumentieren |

## 4. Trigger

- Welle 2 startet, slice-012 (Audit-Logging) ist done.

## 5. Closure-Trigger

- DoD vollständig.
- `make gates` grün in allen fünf Sprachen.
- Mindestens *ein* Property-Test pro Sprache läuft 100 Generationen ohne Fail in CI.

## 6. Risiken und offene Punkte

- Property-Test in C#/.NET: `FsCheck` braucht Adaption für Generatoren.
- Performance: 100 Generationen × Embedding-Aufrufe können `make gates` verlängern. Ggf. Embedding-Mock im Property-Test, Konsistenz-Tests separat.

## 7. Closure-Notiz

<!-- Erst nach Abschluss füllen. -->

## 8. Sub-Area-Modus-Begründung

**Status:** alle berührten Sub-Areas GF (siehe
`harness/conventions.md` §Modus-Deklaration pro Sub-Area: `*` = GF
für das DocSearch-Lab als Ganzes). Spec-Anker LH-QA-02 führt
(Determinismus-Anforderung), Code folgt — Test-Infrastruktur (`FsCheck`-
Adaption) hat zwar Adaptions-Aufwand, aber keinen Inventur-Auftrag
(es wird neu gebaut, nichts retrofittet).

Voraussetzung-Wissen für den Block-Aufbau: Kurs
[Modul 5 §Worked Mini-Example](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#worked-mini-example-bootstrap-modus-pro-sub-area-für-einen-slice-begründen).
