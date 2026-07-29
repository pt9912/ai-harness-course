# Slice 013: Property-Based Tests für deterministische Sortierung

**Lifecycle:** Der Zustand dieses Slice ist das Verzeichnis, in dem diese
Datei liegt — eines von `open/`, `next/`, `in-progress/`, `done/`. Er wechselt
nur durch `git mv` (Kurs
[Modul 5 §Lifecycle als State Machine](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#lifecycle-als-state-machine)).

**Welle:** welle-2-qualitaet

**Bezug:** LH-QA-02 (Reproduzierbarkeit), LH-FA-02 (Suche)

**Autor:** Kurs-Lab. **Datum:** 2026-06-03.

## 1. Ziel

Property-Based Tests einführen, die die deterministische Sortierung der
Suchergebnisse über generierte Eingaben sicherstellen. Ergänzt
`test-determinism` (heute: fixierte Inputs) um Eigenschaft-Suite
(beliebige Inputs).

## 2. Definition of Done

- [ ] Pro Sprache ein Property-Test (z.B. `gopter` für Go, `hypothesis` für Python, `Kotest` für Kotlin, `jqwik` für Java, `FsCheck` für C#, `rapidcheck` für C++).
- [ ] Eigenschaft: Für beliebige Index-Inhalte und Anfragen ist die Reihenfolge bei gleichem Score reproduzierbar.
- [ ] Neues Make-Target `test-property` läuft in `make gates`.
- [ ] `test-property` läuft 100 Generationen, fail-closed.
- [ ] Closure-Notiz mit gefundenen Counter-Examples (falls welche).
- [ ] `docs/user/quality.md` angelegt; die drei Platzhalter-Vermerke nachgeführt: `AGENTS.md` §4, `docs/user/README.md`, `harness/README.md` Rang 6.

## 3. Plan (vor Code)

| Datei / Komponente | Änderungs-Art | Begründung |
|---|---|---|
| `<sprache>/Makefile` | update | `test-property`-Target, in `gates`-Liste |
| `<sprache>/tests/property/` | neu | Property-Test-Dateien |
| `docs/user/quality.md` | neu | `test-property` dokumentieren — der Ordner ist bis dahin Platzhalter |
| `AGENTS.md` | update | §4 nennt `quality.md` als ops-gerichteten Einstieg; die Bindungs-Kette bleibt |
| `docs/user/README.md` | update | Platzhalter-Vermerk entfernen |
| `harness/README.md` | update | Platzhalter-Vermerk in der Source-Precedence-Zeile (Rang 6) entfernen |

## 4. Trigger

- Welle 2 gestartet (2026-06-03); slice-012 liegt seit der Welle-1-Closure in `done/`.

## 5. Closure-Trigger

- DoD vollständig.
- `make gates` grün in allen sechs Sprachen.
- Mindestens *ein* Property-Test pro Sprache läuft 100 Generationen ohne Fail in CI.

## 6. Risiken und offene Punkte

- Property-Test in C#/.NET: `FsCheck` braucht Adaption für Generatoren.
- Performance: 100 Generationen × Embedding-Aufrufe können `make gates` verlängern. Ggf. Embedding-Mock im Property-Test, Konsistenz-Tests separat.

## 7. Closure-Notiz

<!-- Bei der Closure füllen — vor dem `git mv` nach `done/`, nicht danach. -->

## 8. Sub-Area-Modus-Begründung

**Status:** alle berührten Sub-Areas GF (siehe
`harness/conventions.md` §Modus-Deklaration pro Sub-Area: `*` = GF
für das DocSearch-Lab als Ganzes). Spec-Anker LH-QA-02 führt
(Determinismus-Anforderung), Code folgt — Test-Infrastruktur (`FsCheck`-
Adaption) hat zwar Adaptions-Aufwand, aber keinen Inventur-Auftrag
(es wird neu gebaut, nichts retrofittet).

**Vorgelagert — offene Beobachtungen gesichtet:** Register
(`../observations.md`) durchgegangen. Berührt sind drei Sub-Areas (§3):
*Test-Infrastruktur* (`<sprache>/tests/property/` — die `FsCheck`-Adaption ist
eine neue Konvention, keine additive Arbeit unter der alten),
*Sensor-Werkzeuge* (`test-property` in der `gates`-Liste) und
*Konventionen & Harness-Doku* (`AGENTS.md` §4, `harness/README.md`).
`docs/user/` ist Aspirantin und trägt keine Modus-Aussage.

**Keine Treffer auf den berührten Sub-Areas** — und das ist die Antwort, nicht
ihr Fehlen. Die beiden offenen Zeilen `BEO-001` (2×) und `BEO-002` (1×) liegen
auf *Replay-/Eval-Infrastruktur*: Sie betreffen den Zuschnitt des Golden Sets,
den dieser Slice nicht anfasst — er *misst* gegen den bestehenden Satz. Ihr
Zähler geht durch diesen Slice also nicht hoch.

Voraussetzung-Wissen für den Block-Aufbau: Kurs
[Modul 5 §Worked Mini-Example](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#worked-mini-example-bootstrap-modus-pro-sub-area-für-einen-slice-begründen).
