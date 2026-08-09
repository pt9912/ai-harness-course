# Slice 023: ADR-Kennungen linkpflichtig machen

**Lifecycle:** Der Zustand dieses Slice ist das Verzeichnis, in dem diese
Datei liegt — eines von `open/`, `next/`, `in-progress/`, `done/`. Er wechselt
nur durch `git mv` (Kurs
[Modul 5 §Lifecycle als State Machine](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#lifecycle-als-state-machine)).

**Welle:** ohne Welle — die Closure-Bedingung ist die DoD dieses Slice.

**Bezug:** [Kurs §Referenz-Richtung](../../../../../../kurs/de/grundlagen/referenz-richtung.md#referenz-richtung-sdp-wer-darf-wen-referenzieren)
(`MR-002`-Bindung von `make doc-check`)

**Berührte Spec-Stellen:** —

**Autor:** Kurs-Lab. **Datum:** 2026-08-09.

## 1. Ziel

Jede `ADR-NNNN`-Kennung im Fließtext des Beispiels ist ein Link auf ihre
Definition, und das d-check-Modul `ids` hält das offen.

Der Anlass ist kein Ordnungssinn: `matrix` prüft den **Status** eines Ziels
nur an Links. Eine nackte Kennung ist für das Gate unsichtbar — gemessen,
`ADR-0015` (superseded) nackt in einem Slice ergibt 0 Befunde, derselbe
Verweis als Link `matrix-inactive`. `ids` erzwingt den Link, `matrix`
beurteilt ihn.

## 2. Definition of Done

- [x] Alle nackten `ADR-NNNN` im Beispiel sind Links.
- [x] Zwei Ausnahme-Klassen tragen einen Zeilen-Marker statt eines Links,
      **mit Begründung im Marker**: geplante Vorwärts-Verweise und
      Protokollzeilen in Geschichte-Sektionen.
- [x] Modul `ids` in `.d-check.yml` aktiv, nur für die ADR-Klasse.
- [x] Break-Test: nackte Kennung neu eingefügt → rot; als Link → grün;
      Ausnahme ohne Marker → rot.
- [x] `make verify` grün, alle neuen Links lösen auf.
- [x] `make gates` grün — trivial, der Slice berührt keine Datei eines
      Sprach-Skeletts außer deren Doku; belegt an `COURSE_LANG=go`. Genannt
      wird er trotzdem: Ein Gate, das trivial grün ist, ist nicht davon zu
      unterscheiden, ob es lief oder vergessen wurde (Nachtrag-Argument aus
      `slice-020`).
- [x] Closure-Notiz.

## 3. Plan (vor Code)

| Datei / Komponente | Änderungs-Art | Begründung |
|---|---|---|
| 27 Dateien im Beispiel | update | 62 Links, 5 Marker |
| `.d-check.yml` | update | Modul `ids`, ADR-Klasse; Scan-Wurzeln |

Nicht in diesem Slice: `LH-*` (65 Stellen) und `slice-*` (24). Dieselbe
Bauform, eigene Arbeit — und die ADR-Klasse ist die, in der eine nackte
Nennung real rottet, weil eine ADR superseded werden kann.

## 4. Trigger

- Auslöser ist die Messung zum Modul `ids`: 244 Treffer im Repo, davon 156 im
  Beispiel; die übrigen 88 liegen in Kurs, Regelwerk und Templates, wo eine
  Kennung ein **fiktives Beispiel** ist und ein Link die Normhierarchie
  umdrehen würde.

## 5. Risiken

| Risiko | Wahrscheinlichkeit | Gegenmaßnahme |
|---|---|---|
| Ein Skript zerlegt Tabellenzeilen oder verschachtelt Links | hoch | Trockenlauf mit Stichprobe vor dem Anwenden; Ersetzung nur an Fundstellen, die d-check selbst nennt, und nur an Vorkommen ohne umgebende Link-Syntax |
| Das Gate deckt weniger ab, als der Aufräum-Umfang suggeriert | eingetreten | siehe §7 |
| Die Ausnahmen schalten still ab | mittel | Break-Test *ohne* Marker muss rot sein, nicht nur der mit |

## 6. Offene Risiken zur Wellen-Abnahme

- Entfällt — Slice ohne Welle.

## 7. Steering-Loop-Beobachtungen

- **Der Break-Test hat ein zu enges Gate aufgedeckt, nicht das Konfigurieren.**
  Nach dem Verdrahten war `make doc-check` grün — aber eine neu eingefügte
  nackte Kennung in `AGENTS.md` blieb es auch. Die `scan.roots` standen auf
  `spec` und `docs/plan`; die Aufräumarbeit umfasste 27 Dateien, das Gate sah
  davon einen Bruchteil. Ein grüner Lauf nach dem Aufräumen beweist gar nichts
  — er ist mit einem blinden Sensor genauso grün.

## 8. Sub-Area-Modus-Begründung

Berührte Sub-Area: *Verifikation* (`.d-check.yml`) und die Doku-Fläche des
Beispiels. Modus **RK** — der Bestand ist gewachsen und muss eingeholt werden,
bevor die Regel greift.

## 9. Closure-Notiz

**Ergebnis.** 62 Links in 27 Dateien, 5 Zeilen-Marker, keine übersprungene
Fundstelle. `ids` ist für die ADR-Klasse aktiv; `make doc-check` prüft jetzt
69 statt 29 Dateien.

**Die zwei Ausnahme-Klassen**, beide als Marker im Text statt als Pfad-Liste in
der Config — die Begründung steht dann dort, wo jemand sie liest:

- **Geplante Vorwärts-Verweise** (4×): `ADR-0004` existiert nicht, `slice-014`
  *bringt* sie erst — „ADR-0004 'ANN-Bibliothek-Wahl' Accepted" steht in dessen <!-- d-check:ignore (Zitat der geplanten Kennung, kein Verweis) -->
  DoD. Ein Link wäre `target-missing`.
- **Protokollzeile in einer Geschichte-Sektion** (1×, `CO-001`): Regel 5 nennt
  die Historie die schlechteste Stelle für einen rottenden Zeiger, weil sie nie
  rückwirkend korrigiert wird.

**Break-Test, vier Richtungen:** nackte Kennung neu in `AGENTS.md` → rot;
nackte Kennung in `go/harness/README.md` → rot; dieselbe Stelle als Link →
grün; Vorwärts-Verweis **ohne** Marker → rot. Die letzte Zeile ist die
wichtige: Die Ausnahme ist deklariert, nicht still.

**Was der Break-Test aufdeckte** (§7): Das Gate war zunächst zu eng
geschnitten und hätte die Hälfte der aufgeräumten Dateien nie gesehen.
`scan.roots` steht jetzt auf dem ganzen Beispiel, mit `ignore` für die
Build-Verzeichnisse der Skelette.

**Nicht in diesem Slice:** `LH-*` (65 Stellen) und `slice-*` (24). Und die 88
Treffer außerhalb des Beispiels bleiben es dauerhaft — in Kurs, Regelwerk und
Templates ist eine Kennung ein fiktives Beispiel; ein Link dorthin drehte die
Normhierarchie um, und das Regelwerk darf `example/` überhaupt nicht nennen.

**Gates:** `make verify` grün (69 Dateien, 0 Befunde), Root `make check`
0 ERROR / 0 WARN — alle 62 neuen Links lösen auf.
