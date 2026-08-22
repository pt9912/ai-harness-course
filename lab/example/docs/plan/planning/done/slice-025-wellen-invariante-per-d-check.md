# Slice 025: Wellen-Invariante per d-check — die Listen-Hälfte bekommt ihren Wächter

**Lifecycle:** Der Zustand dieses Slice ist das Verzeichnis, in dem diese
Datei liegt — eines von `open/`, `next/`, `in-progress/`, `done/`. Er wechselt
nur durch `git mv` (Kurs
[Modul 5 §Lifecycle als State Machine](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#lifecycle-als-state-machine)).

**Welle:** ohne Welle — die Closure-Bedingung ist die DoD dieses Slice.

**Bezug:** [Kurs Modul 6 §Offene Wellen (Worked Example, Schritt 4)](../../../../../../kurs/de/02-planung/modul-06-roadmap.md#worked-example-einen-datumswunsch-in-eine-trigger-welle-übersetzen)
(zwei Aussagen, zwei Wächter) und
[Kurs Modul 6 §Die Wellen-Eröffnungs-Prozedur](../../../../../../kurs/de/02-planung/modul-06-roadmap.md#die-wellen-eröffnungs-prozedur)
(Schritt 3: Zeile verlässt *Nächste Wellen*, Zeiger unter *Offene Wellen*)

**Berührte Spec-Stellen:** —

**Verantwortlich:** Kurs-Lab.

**Autor:** Kurs-Lab. **Datum:** 2026-08-22.

## 1. Ziel

Der Abschnitt `## Offene Wellen` der Roadmap trägt zwei unabhängige Aussagen:
Der Ruhe-Marker folgt dem **Anspruch** (`in-progress/` ohne Slice), die Liste
folgt den **Dateien** (ein Zeiger je flacher Welle-Datei). Bis hierher hielt
`make doc-check` nur die Marker-Hälfte (`planning-drift`); die Listen-Hälfte
war eine *bekannte* Lücke — benannt in der `.d-check.yml`, im Kurs und im
Team-Sim, aber ungewächtert. Dieser Slice schaltet die dritte Fähigkeit
desselben Moduls ein (`planning.waves`), und zwar unter dem
Kardinalitäts-Modell, das dieses Repo lebt: **`mode: many`** — Kennungs-Mengen
in beide Richtungen statt *genau eine* Datei.

Der Anlass ist kein Vollständigkeitsdrang. Die Fähigkeit gab es seit d-check
v0.59.0, und sie war für dieses Repo unbrauchbar: Ihr Default kodiert den
Singleton („der Aktiv-Block nennt eine Welle genau dann, wenn genau ein
flaches Wellendokument liegt") und meldet unter *Offene Wellen* zwei legitime
Zustände als Drift — zwei offene Wellen, und Welle eröffnet, aber noch nichts
beansprucht. Gemessen im Kurs-Team-Sim (s04b), als Change Request eingereicht,
geliefert als `waves.mode: one | many` in d-check v0.62.0. Erst damit ist das
Opt-in eine Wächter-Entscheidung und kein Dauerbefund.

## 2. Definition of Done

- [x] `planning.waves` in `.d-check.yml` aktiv mit `dir: docs/plan/planning`
      und `mode: many`; die übrigen Schlüssel treffen die Defaults dieses
      Repos (`welle-*.md`, `welle-*-results.md`, `## Nächste Wellen`,
      `## Abgeschlossene Wellen`, `done/`) und stehen deshalb nicht da — mit
      Begründung im Kommentar.
- [x] Bestand grün: `make doc-check` 73 Dateien, 0 Befunde (74 mit diesem
      Slice-Dokument) — ohne eine einzige Änderung an Roadmap oder
      Welle-Dateien. Das ist die Vorbedingung, nicht das Ergebnis: Ein
      Sensor, der den Bestand rot meldet, wird erst eingeschaltet, wenn der
      Bestand stimmt *oder* der Sensor widerlegt ist.
- [x] Break-Tests am echten Repo — vier Experimente, fünf Codes: Datei ohne
      Zeiger → `wave-drift` (`welle-3`) und als Beifang `wave-preview-exists`
      (`welle-3` steht noch in *Nächste Wellen*); Zeiger ohne Datei →
      `wave-drift` (`welle-5`); Ergebnisnotiz entfernt →
      `wave-results-missing` (`welle-1`); Ergebnisnotiz ohne Register-Zeile →
      `wave-unregistered`. Nach jedem Test Wiederherstellung, `git diff`
      leer, Nachlauf 73/0.
- [x] Kontrolle des Modells: derselbe Bestand unter `mode: one` ebenfalls
      grün — heute ist *genau eine* Welle offen, der Singleton gilt zufällig.
      Mit einer zweiten offenen Welle (flach **und** gelistet) beißt nur
      `one`; `many` bleibt grün. Das ist der Beleg, dass `many` die
      Bedingung ist und nicht Kosmetik.
- [x] Die Doku nennt den neuen Wächter: AGENTS.md §3 (`make doc-check`),
      `harness/README.md` (Sensor-Tabelle), `docs/plan/planning/README.md`
      (§Slices vs. Wellen).
- [x] `make verify` grün, `make gates COURSE_LANG=go` grün (trivial — der
      Slice berührt kein Skelett; genannt aus dem Nachtrag-Argument von
      `slice-020`: ein trivial grünes Gate ist nicht davon zu unterscheiden,
      ob es lief oder vergessen wurde).
- [x] Closure-Notiz.

## 3. Plan (vor Code)

| Datei / Komponente | Änderungs-Art | Begründung |
|---|---|---|
| `.d-check.yml` | update | `planning.waves` (`dir`, `mode: many`), Kommentar ersetzt die GRENZE-Notiz „bewusst kein Opt-in" |
| `AGENTS.md` §3 | update | `planning`-Zelle nennt die Wellen-Invariante |
| `harness/README.md` | update | Sensor-Tabelle, `make doc-check` |
| `docs/plan/planning/README.md` | update | §Slices vs. Wellen: „und `make doc-check` hält das" |

Nicht in diesem Slice: Roadmap und Welle-Dateien — sie waren schon
konsistent; der Slice ändert den Wächter, nicht den Bestand.

## 4. Trigger

- d-check v0.62.0 (2026-08-21) liefert `planning.waves.mode: many` — die
  Bijektion, die dieses Repo als Change Request erbeten hatte. Der Pin des
  Kurs-Repos springt am selben Tag wie dieser Slice von v0.59.0 auf v0.62.0;
  ohne den Sprung gäbe es den Schlüssel nicht, und ein unbekannter Schlüssel
  wäre Exit 2 (fail-closed), kein stilles Grün.

## 5. Risiken

| Risiko | Wahrscheinlichkeit | Gegenmaßnahme |
|---|---|---|
| Der Sensor ist eingeschaltet, prüft aber nichts (falsche Defaults: Überschrift, Glob, Ruheort) | mittel | Break-Test je Aussage am echten Repo, nicht nur am Seed — §2 |
| `mode: many` liest eine Kennung aus dem Erklärtext des Blocks als Zeiger | niedrig | Der Erklärtext unter `## Offene Wellen` ist kennungsfrei; die GRENZE steht im Config-Kommentar |
| Das Opt-in verdeckt, dass `one` heute zufällig auch grün wäre | eingetreten und genutzt | Kontroll-Lauf unter `one` mit zweiter offener Welle — §2 |

## 6. Offene Risiken zur Wellen-Abnahme

- Entfällt — Slice ohne Welle.

## 7. Steering-Loop-Beobachtungen

- **Ein grüner Opt-in-Lauf beweist nur, dass der Bestand konsistent ist —
  nicht, dass der Sensor das prüft.** Unter `mode: one` wäre das Repo heute
  ebenso grün gewesen, weil genau eine Welle offen ist. Erst die zweite
  offene Welle in einer Kopie trennt die beiden Modelle. Die Lehre aus
  `slice-023` (§7, „ein grüner Lauf nach dem Aufräumen beweist gar nichts")
  gilt auch, wenn es nichts aufzuräumen gab.
- **Der Break-Test „Datei ohne Zeiger" meldet zwei Codes auf einmal** —
  `wave-drift` und `wave-preview-exists` —, weil `welle-3` in diesem Repo
  noch in *Nächste Wellen* steht. Das ist kein Doppelbefund, sondern zwei
  Aussagen: Die Datei ist nicht gelistet, *und* sie widerspricht der
  Vorschau („zwei Positionen, nicht drei"). Wer nur auf den ersten Code
  schaut, repariert die Liste und lässt die Vorschau-Zeile stehen.

## 8. Sub-Area-Modus-Begründung

**Vorgelagert — Sub-Area-Wahl prüfen:** *Verifikation* ist eine bestehende
Sub-Area dieses Repos (eigene Konventionen in `.d-check.yml`, eigene Gates,
eigene Änderungsrate); nichts ist auszudifferenzieren.

**Vorgelagert — offene Beobachtungen sichten:** `BEO-003` (ADR-Bezug im
Commit vergessen) und `BEO-006` (geschlossen in `slice-022`) sind die
Planning-Lifecycle-Einträge des Registers; keiner betrifft die Wellen-Liste.
Neu zu zählen ist nichts — der Anlass war eine Werkzeug-Grenze, kein
wiederholtes Symptom.

Berührte Sub-Area: *Verifikation* (`.d-check.yml`) und die Doku-Fläche des
Beispiels. Modus **RK** — es gibt einen gewachsenen Bestand (Roadmap,
Welle-Dateien, Ergebnisnotiz), gegen den der neue Wächter zu rekonziliieren
ist; er war konsistent, also ohne Nacharbeit.

## 9. Closure-Notiz

**Ergebnis.** `planning.waves` ist aktiv (`dir: docs/plan/planning`,
`mode: many`). `make doc-check` meldet 0 Befunde auf dem Bestand (73 Dateien,
74 mit diesem Slice-Dokument) — der Bestand brauchte keine Änderung. Die
Listen-Hälfte des Abschnitts *Offene Wellen* hat damit ihren Wächter, die
Marker-Hälfte behält ihren; der Ruhe-Marker geht in die Bijektion nicht ein.

**Break-Tests am echten Repo — vier Experimente, fünf Codes:** flache
`welle-3-x.md` ohne Zeiger → `wave-drift` auf `welle-3` (als Beifang
`wave-preview-exists`, weil `welle-3` noch in der Vorschau steht — nicht
isoliert gebrochen); Zeiger auf `welle-5-x` ohne Datei →
`wave-drift` auf `welle-5`; `done/welle-1-results.md` entfernt →
`wave-results-missing` auf `welle-1`; `done/welle-9-results.md` ohne
Register-Zeile → `wave-unregistered`. Jede Richtung per Diff und Nachlauf
wiederhergestellt (73/0).

**Das Kardinalitäts-Modell ist gemessen, nicht gewählt:** derselbe Bestand
unter `mode: one` grün (genau eine offene Welle); mit zweiter offener Welle,
flach und gelistet, beißt nur `one` (`wave-drift` auf das Verzeichnis),
`many` bleibt grün. Dieselbe Trennung im Kurs-Team-Sim: s04b und s04g
(`one`, rot — zwei offene Wellen bzw. eine eröffnete, nicht beanspruchte)
gegen s04e und s04h (`many`, grün); s04f und s04i (Bijektion beißt unter
`many`, beide Richtungen).

**Nicht in diesem Slice:** die Kurs-Seite — Modul 6 §Offene Wellen,
Regelwerk-Split und `roadmap.template.md` ziehen nach, aber im Kurs-Repo
(Normhierarchie: Quelle vor Beispiel; dieses Repo ist das Vorbild, nicht
die Regel).

**Gates:** `make verify` grün (74 Dateien, 0 Befunde), `make gates
COURSE_LANG=go` grün (Coverage 85,8 %), Root `make check` 0 ERROR / 0 WARN.
