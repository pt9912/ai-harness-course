# Slice 022: Referenz-Richtung per d-check statt eigenem Skript

**Lifecycle:** Der Zustand dieses Slice ist das Verzeichnis, in dem diese
Datei liegt — eines von `open/`, `next/`, `in-progress/`, `done/`. Er wechselt
nur durch `git mv` (Kurs
[Modul 5 §Lifecycle als State Machine](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#lifecycle-als-state-machine)).

**Welle:** ohne Welle — die Closure-Bedingung ist die DoD dieses Slice.

**Bezug:** [Kurs §Referenz-Richtung](../../../../../../kurs/de/grundlagen/referenz-richtung.md#referenz-richtung-sdp-wer-darf-wen-referenzieren)
(`MR-002`-Bindung des Gates), [BEO-006](../observations.md)

**Berührte Spec-Stellen:** —

**Autor:** Kurs-Lab. **Datum:** 2026-08-09.

## 1. Ziel

`tools/check_references.py` <!-- d-check:ignore (in diesem Slice entfernt) --> durch das d-check-Modul `matrix` ersetzen. Das
Skript trägt zwei Zellen der Referenz-Matrix und erklärt die dritte im eigenen
Kopf für nicht grep-bar — der Kurs löst sie längst über den umgekehrten
Default (Kante verboten, Ausnahme am Ort deklariert), und genau diese Bauform
hat `matrix`.

## 2. Definition of Done

- [x] `.a-check.yml`-Analogon: `.d-check.yml` im Beispiel, **nur** Modul
      `matrix`. Link- und Anker-Prüfung bleibt an der Kurs-Wurzel — das
      Beispiel ist ein Teilbaum und verlinkt bewusst in den Kurs, ein
      `links`-Lauf im Beispiel-Scope meldet dafür 63 Repo-Escapes.
- [x] `d-check.mk` per `d-check --print-mk`; Pin im `Makefile`, nicht im
      Fragment.
- [x] `include` **hinter** `help` — sonst wird das erste Fragment-Target das
      Default-Goal.
- [x] `verify` ruft das neue Target statt `check-references`.
- [x] Kongruenz belegt: je Verstoß der beiden bisherigen Regeln beide Sensoren
      nebeneinander, plus die Zelle, die nur `matrix` trägt.
- [x] `tools/check_references.py` <!-- d-check:ignore (in diesem Slice entfernt) --> entfernt.
- [x] Nachgezogen: `AGENTS.md` §3, `harness/README.md` §Sensors,
      `harness/conventions.md` (Beispiel der `MR-002`-Klasse), `MR-002`.
- [x] `BEO-006` geschlossen — `matrix` prüft ADRs als Quellklasse mit.
- [x] `make verify` grün.
- [x] Closure-Notiz mit den Kongruenz-Ausgaben.

## 3. Plan (vor Code)

| Datei / Komponente | Änderungs-Art | Begründung |
|---|---|---|
| `.d-check.yml` | neu | Klassen, Regeln, Ausnahmen — die Matrix als Deklaration |
| `d-check.mk` | neu | tool-generiert, kein handgepflegtes Recipe |
| `Makefile` | update | Pin, `include`, `verify`-Abhängigkeit; Ziel-Set sonst unverändert |
| `tools/check_references.py` <!-- d-check:ignore (in diesem Slice entfernt) --> | entfernt | von `matrix` vollständig gedeckt |
| `AGENTS.md`, `harness/README.md`, `harness/conventions.md`, `MR-002` | update | Target-Name und Bindung |
| `docs/plan/planning/observations.md` | update | `BEO-006` geschlossen |

## 4. Trigger

- Auslöser ist der Befund aus der Arbeit an ADR-0016: Ein Pfad-Link von einer
  ADR auf einen Slice blieb unbemerkt, weil kein Sensor die Zelle trug.

## 5. Risiken

| Risiko | Wahrscheinlichkeit | Gegenmaßnahme |
|---|---|---|
| Die Konfiguration schaltet das Gate leiser, statt es zu ersetzen | mittel | Kongruenz-Nachweis je Verstoß, nicht nur ein grüner Lauf |
| Die erklärenden Meldungen des Skripts gehen verloren | hoch | Die Regel steht in `harness/README.md` §Sensors, wo die Bindung ohnehin sitzt |
| Ein zweiter Pin altert | mittel | Anheben trifft Wurzel und Beispiel in einem Commit |

## 6. Offene Risiken zur Wellen-Abnahme

- Entfällt — Slice ohne Welle.

## 7. Steering-Loop-Beobachtungen

- Noch keine.

## 8. Sub-Area-Modus-Begründung

Berührte Sub-Area: *Verifikation* (`tools/`, `Makefile`). Modus **RK** — es
gibt einen gewachsenen Prüf-Stand, gegen den zu rekonziliieren ist; die neue
Deklaration muss ihn einholen, bevor er entfällt.

## 9. Closure-Notiz

**Ergebnis.** `tools/check_references.py` <!-- d-check:ignore (in diesem Slice entfernt) --> ist entfernt; die Referenz-Richtung
prüft das d-check-Modul `matrix` aus `.d-check.yml`. Das Beispiel trägt dafür
ein eigenes d-check — mit **nur** diesem Modul, weil ein `links`-Lauf im
Beispiel-Scope 63 Repo-Escapes meldete: Dieses Verzeichnis ist ein Teilbaum und
verlinkt bewusst in den Kurs, die Link- und Anker-Prüfung gehört deshalb an die
Kurs-Wurzel, die den ganzen Baum sieht.

**Kongruenz, je Verstoß beide Sensoren nebeneinander** (Scratch-Kopie aus
`git ls-files`, altes Skript zurückkopiert):

| Verstoß | `matrix` | altes Skript |
|---|---|---|
| sauberer Baum (Kontrolle) | grün | grün |
| Lastenheft, Körper: `ADR-0001` | rot | rot |
| Lastenheft, `## 7. Historie`: `ADR-0001` | rot | rot |
| Spezifikation, Körper: `slice-009` | rot | rot |
| Slice → superseded `ADR-0015` | rot | rot |
| `ADR-0016` → `slice-021` | rot | **grün** |

Die letzte Zeile ist der Grund für den Tausch: Das Skript erklärte diese Zelle
im eigenen Kopf für nicht grep-bar und überließ sie dem Review-Agenten. Der
Kurs löst sie über den umgekehrten Default — Kante verboten, Ausnahme am Ort
deklariert —, und genau diese Bauform hat `matrix` samt Marker
`<!-- d-check:status-provenance -->`.

**Eine Falle beim Konfigurieren.** `exclude-sections` gilt global, nicht je
Klasse. Mit `Historie` in der Liste bliebe ein ADR-Verweis in der Historie
eines Spec-Stratums unentdeckt — dort verlangt der Kurs ausdrücklich keine
Ausnahme. Dass der erste Lauf trotzdem rot war, lag allein an der
Nummerierung der Überschrift (`## 7. Historie`); ohne Nummer war derselbe
Verstoß still. Die Erhebung ergab einen sauberen Schnitt: `Geschichte` gibt es
nur in ADRs, `Historie` nur in Spec-Straten. `exclude-sections: [Geschichte]`
ist damit durch Konstruktion richtig statt durch Zufall.

**`BEO-006` ist geschlossen:** `matrix` führt `adr` als Quellklasse, das Skript
prüfte nur `spec/`.

**Was verloren geht, bewusst:** Die Meldungen des Skripts erklärten die Regel;
`matrix` nennt Befundtyp, Datei und Zeile. Die Erklärung steht jetzt in
`harness/README.md` §Sensors, wo die Bindung ohnehin sitzt.

**Gates:** `make verify` grün (Closure-Pflicht + `doc-check`, 29 Dateien, 0
Befunde), Root `make check` 0 ERROR / 0 WARN.
