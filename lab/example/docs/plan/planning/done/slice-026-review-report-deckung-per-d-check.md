# Slice 026: Review-Report-Deckung per d-check — die Review-Zusage bekommt ihren Wächter

**Lifecycle:** Der Zustand dieses Slice ist das Verzeichnis, in dem diese
Datei liegt — eines von `open/`, `next/`, `in-progress/`, `done/`. Er wechselt
nur durch `git mv` (Kurs
[Modul 5 §Lifecycle als State Machine](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#lifecycle-als-state-machine)).

**Welle:** ohne Welle — die Closure-Bedingung ist die DoD dieses Slice.

**Bezug:** — (reines Tooling-Slice, kein Lastenheft-Bezug). Kurs-Bezug:
[Modul 5 §Worked Example: einen zu großen Slice schneiden](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#worked-example-einen-zu-großen-slice-schneiden)
(Review-Report als konstante Closure-Pflicht, seit Welle 119) und
[Modul 10 §Harness-Einordnung](../../../../../../kurs/de/04-qualitaet/modul-10-review-harness.md#harness-einordnung)
(Kategorisierung bleibt inferential, Deckung wird computational).

**Berührte Spec-Stellen:** —

**Verantwortlich:** Kurs-Lab.

**Autor:** Kurs-Lab. **Datum:** 2026-09-05.

## 1. Ziel

Die Slice-DoD trägt seit Welle 119 eine Review-Zeile (Kurs Modul 5
§Ziel-Form: Slice): ein DoD-Haken, der "Review" nennt, verlangt einen Report
unter `docs/reviews/` mit derselben Slice-Kennung im Namen. Bis hierher war
das reine Konvention — kein Sensor prüfte, ob ein `done/`-Slice mit dieser
Zeile den Report auch tatsächlich trägt. Dieser Slice schaltet den
d-check-Wächter dafür ein (`reviews`, `DC-FA-RVW-001`, seit d-check v0.73.0)
und ist selbst der erste Slice dieses Repos, der die neue DoD-Zeile trägt —
Dogfooding statt Behauptung.

## 2. Definition of Done

- [x] `.d-check.yml`: Modul `reviews` aktiv (`done-dir:
      docs/plan/planning/done`, `reviews-dir: docs/reviews`), fünftes Modul
      neben `matrix`/`targets`/`planning`/`ids`.
- [x] `harness/README.md` §Sensors: `make doc-check`-Zeile nennt das fünfte
      Modul und seine Bindung.
- [x] `make gates` grün — als `make verify` gelaufen (106 Dateien, 0
      Befunde): reiner Doku-/Config-Slice, kein Sprachskelett berührt, das
      per-Sprach-`make gates COURSE_LANG=…` etwas prüfen würde.
- [x] Review durchgeführt, Report unter `docs/reviews/` liegt vor
      (`docs/reviews/2026-09-05-slice-026.md`, generisches
      Klassifikationsschema aus `lab/templates/.harness/skills/reviewer.template.md`
      — `lab/example` führt noch kein ausgefülltes `.harness/skills/reviewer.md`)
      — Rollenwechsel nach Schritt 8 des Minimal Agent Workflow (`AGENTS.md`
      §6), unabhängiger Lauf, kein Self-Review (Modul 8). 4 MEDIUM-Findings,
      0 HIGH, nicht merge-blockierend; alle vier in diesem Slice behoben
      (F-1/F-2: falsche Anker/Zitate korrigiert; F-3: Sub-Area-Zuordnung
      relativiert + als Beobachtung erfasst; F-4: fehlende Bindung in
      `harness/README.md` ergänzt).
- [x] Doku-Update: siehe `harness/README.md` oben.
- [x] Closure-Notiz mit Steering-Loop-Lerneintrag.
- [ ] Reconciliation-Register: entfällt — kein Inventur-Fund, dieser Slice
      löst keinen auf.
- [x] Beobachtungs-Register (`../observations/`) fortgeschrieben —
      `BEO-TOOLS/d-check-yml-sub-area-unklar/`, Beleg `evidence/slice-026.md`.
- [x] Jedes Risiko aus §6 trägt einen Ausgang.
- [ ] Die drei Paarungen — dieses Repo führt Wellen-Betrieb
      (`welle-2-qualitaet` läuft); geprüft von deren Closure, auch für
      diesen wellenlosen Slice.

## 3. Plan (vor Code)

| Datei / Komponente | Änderungs-Art | Begründung |
|---|---|---|
| `.d-check.yml` | update | Modul `reviews` aktivieren |
| `harness/README.md` | update | `make doc-check`-Zeile um fünftes Modul ergänzen |
| `docs/reviews/` | neu | erster Report dieses Repos, für diesen Slice selbst |

## 4. Trigger

**Start** (`next` → `in-progress`): Sofort — die Kurs-Konvention
(Review-DoD-Zeile) existiert bereits seit Welle 119, der Wächter dafür fehlte
nur noch in diesem Beispiel-Repo.

**Rückführungen:**

- `in-progress` → `next`: entfällt — ein Liefer-Punkt, eine Sub-Area, kein
  Zerlegungsbedarf.
- `in-progress` → `open`: entfällt — kein Carveout, keine Blockade.

## 5. Closure-Trigger

DoD vollständig (inkl. eingetroffenem Review-Report) + `make gates` grün +
Closure-Notiz geschrieben.

## 6. Risiken und offene Punkte

- **`reviews-dir` existiert noch nicht (`docs/reviews/` ist neu) — das Modul
  ist fail-closed: Es meldet `review-missing` mit "reviews-dir lesbar:
  false" schon bei 0 Review-Zusagen, nicht erst bei einer unbelegten.**
  Gemessen vor Anlage des Verzeichnisses: `d-check` meldet 1 Befund
  (`docs/plan/planning/done: review-missing — leere Pruefmenge: 7
  Kandidat(en), 0 Review-Zusage(n), reviews-dir lesbar: false`). — **Ausgang:**
  eingetreten, aufgelöst durch Anlage von `docs/reviews/` mit dem Report
  dieses Slice.
- **Die sieben bestehenden `done/`-Slices (plus zwei Welle-Dateien) tragen
  die neue Review-Zeile nicht rückwirkend** — sie entstanden vor Welle 119.
  — **Ausgang:** entfallen: bewusst grandfathered, keine rückwirkende
  Nachrüstung (dieselbe Präzedenz wie die ADR-`exempt-paths` für
  Alt-ADRs vor Konventions-Einführung); das Modul bleibt für sie stumm,
  weil keine von ihnen eine Review-DoD-Zeile trägt — kein `exempt-paths`
  nötig, solange kein Alt-Slice tatsächlich einen Treffer produziert.

## 7. Closure-Notiz

<!-- vor dem git mv nach done/ gefüllt; die drei Paarungen prüft die
Welle-2-Closure. -->

- **Was hat funktioniert:** Der Break-Test lief vor der Behauptung: erst
  `docs/reviews/` fehlend → `review-missing` (fail-closed, 1 Befund), dann
  Report angelegt → `make doc-check` grün. Die Fail-closed-Eigenschaft bei
  leerer Prüfmenge war beim Konfigurieren nicht offensichtlich und wäre ohne
  den Testlauf unbemerkt geblieben.
- **Was ging anders als geplant:** Der unabhängige Review (Rollenwechsel
  nach Schritt 8) fand vier MEDIUM-Findings am ersten Entwurf: zwei falsche
  Zitate (ein Anker, der nur im Regelwerk-Digest existiert, nicht im
  Kurs-Original; ein Abschnittsname vertauscht — "§Kernidee" statt
  "§Harness-Einordnung"), eine unbelegte Sub-Area-Zuordnung und ein
  DoD-Häkchen ohne tragende Zitation. Alle vier in diesem Slice behoben
  (§2). Zusätzlich deckte der Review-Report selbst eine
  Werkzeug-Interaktion auf: `Datei:Zeile`-Zitate der `pfad`-Felder in
  Rückwärts-Häkchen — genau die vom Report-Template empfohlene Form —
  brachen den `codepaths`-Sensor an der Kurs-Wurzel, weil das Modul den
  `:Zeile`-Suffix nicht abtrennt; behoben durch Trennung von Pfad (in
  Inline-Code) und Zeilenangabe (in Prosa).
- **Steering-Loop-Eintrag:** keiner — dieser Slice verkörpert eine bereits
  in Welle 119 geschärfte Regel, schärft selbst keine neue. Die
  Datei:Zeile-Interaktion mit `codepaths` ist repo-lokal in diesem Report
  gelöst, keine Regel geschärft (kein wiederkehrendes Muster bislang — bei
  3× wiederkehrend wäre die Report-Vorlage selbst der Ort).
- **Beobachtungs-Register (`../observations/`):** `BEO-TOOLS/
  d-check-yml-sub-area-unklar/` neu angelegt, Beleg `evidence/slice-026.md`
  (Fund F-3 des Reviews: `.d-check.yml` ist weder unter `Verifikation` noch
  unter `Sensor-Werkzeuge` in `harness/conventions.md` explizit abgedeckt).
- **Folge-Slices:** keine — die offene Sub-Area-Zuordnung wartet auf 3×
  im Register, bevor sie einen eigenen Slice rechtfertigt (Modul 6
  §Beobachtungs-Register).
- **Risiken aus §6:** beide mit Ausgang — siehe §6.
- **Drei Paarungen:** wird von der `welle-2-qualitaet`-Closure geprüft
  (Repo mit Wellen-Betrieb, auch für Slices ohne Wellen-Zugehörigkeit).

## 8. Sub-Area-Modus-Begründung

**Umfang.** `harness/README.md` liegt eindeutig unter `Konventionen &
Harness-Doku` (**Greenfield, 3/3**). `.d-check.yml` klassifiziert dieser
Slice — wie schon `slice-025` — als `Verifikation`; `harness/conventions.md`
deckt die Datei dort aber nicht explizit ab (auch nicht unter
`Sensor-Werkzeuge`) — siehe die neue Beobachtung unten. Beide Kandidaten
sind ohnehin **Greenfield**, die praktische Einordnung (Modus-Begründungs-
block entfällt) ist davon unberührt; offen bleibt nur das *Label*, nicht der
Modus.

**Vorgelagert — Sub-Area-Wahl prüfen:** `Konventionen & Harness-Doku` erfüllt
die Schwelle unverändert. `.d-check.yml` erfüllt sie ebenfalls (über
`Verifikation` oder `Sensor-Werkzeuge`, je nach Zuordnung) — keine
Ausdifferenzierung nötig, nur eine offene Zuordnungsfrage.

**Vorgelagert — offene Beobachtungen sichten:** Register durchgegangen — eine
neue Beobachtung entsteht mit diesem Slice selbst (§7), keine vorbestehende
mit Bezug auf Review-Deckung gefunden.
