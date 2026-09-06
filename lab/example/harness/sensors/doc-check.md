# `make doc-check` — fünf d-check-Module über die Doku-Referenzen

Vertiefung zur Index-Zeile in [`../README.md` §Sensors](../README.md#sensors-feedback-gates).
Bindung je Modul unten — **eine** Zitation für fünf Module wäre für vier davon
die falsche.

## Vertrag

**Fünf Module.**

- **`reviews`** (seit slice-026): Ein `done/`-Slice mit Review-DoD-Zeile
  („Review durchgeführt …") braucht einen Report unter `docs/reviews/` mit
  derselben Slice-Kennung im Dateinamen — fail-closed auch bei 0
  Review-Zusagen, solange `docs/reviews/` fehlt oder unlesbar ist.
- **`ids`**: Jede `ADR-NNNN`-Kennung im Fließtext ist ein Link — nicht
  Kosmetik, denn `matrix` prüft den Status eines Ziels nur an Links; eine
  nackte Kennung ist für die Richtungs-Prüfung unsichtbar.
- **`planning`**: Der Ruhe-Marker der Roadmap steht im Block
  `## Offene Wellen` genau dann, wenn kein Slice in `in-progress/` liegt
  (Config-Override `heading:`/`marker:`; der Werkzeug-Default ist noch
  `## Aktuelle Welle`) — hält zusammen, was sonst beim `git mv`
  auseinanderläuft. Dazu die **Wellen-Invariante** (`planning.waves`, seit
  slice-025): die Zeiger unter `## Offene Wellen` ↔ die flachen Welle-Dateien,
  in beide Richtungen; keine Vorschau-Zeile für eine Welle, die schon eine
  Datei hat; jede Zeile unter `## Abgeschlossene Wellen` hat ihre
  Ergebnisnotiz in `done/` und umgekehrt.
- **`targets`**: jedes in einer Doku-Tabelle behauptete `make X` ist eine reale
  Regel (`gate-phantom`), und jede Regel steht in der Autoritäts-Doku
  (`gate-undocumented`) — AGENTS.md §3 nennt halluzinierte Gates die häufigste
  Form von Harness-Lüge, bis hierher prüfte das niemand.
- **`matrix`**: Referenz-Richtung als Deklaration: kein Spec-Stratum nennt ADR
  oder Slice — **in keinem Abschnitt, auch nicht in seiner Historie**; kein
  Slice referenziert eine superseded ADR; eine ADR nennt einen Slice nur als
  Provenance, markiert mit `<!-- d-check:status-provenance -->`.

## Grenze — was das Grün nicht abdeckt

1. **`ids` greift in `docs/plan/adr/` selbst nicht** — das Modul nimmt sein
   Ziel-Verzeichnis aus. Permanent, es ist die Bauform des Moduls.
2. **`reviews` deckt die *Existenz* eines Reports, nicht seine Güte.** Die
   Kategorisierung eines Findings bleibt inferential (Reviewer-Skill), diese
   Deckung ist computational — permanent, denn die Grenze zwischen beiden ist
   die Bauform der Prüfung, nicht ihre Konfiguration
   ([Kurs Modul 5 §Worked Example: einen zu großen Slice schneiden](../../../../kurs/de/02-planung/modul-05-planning-harness.md#worked-example-einen-zu-großen-slice-schneiden),
   [Modul 10 §Harness-Einordnung](../../../../kurs/de/04-qualitaet/modul-10-review-harness.md#harness-einordnung)).
3. **`planning.waves` braucht `mode: many`.** Der Werkzeug-Default `one` hält
   den Block gegen *genau eine* Datei und meldet unter Offene Wellen legitime
   Zustände als Drift; der Ruhe-Marker geht in die Bijektion nicht ein. Heilbar
   — durch die Konfiguration, nicht durch das Werkzeug.

**Wie groß der Prüfbereich ist, sagen zwei Kommandos, nicht diese Datei:**
`make doc-check 2>&1 | tail -1` nennt die Zahl der geprüften Dateien, und
`sed -n '/^scan:/,/^[a-z]/p' ../../.d-check.yml` die Wurzeln und Ignores, aus
denen sie entsteht. Eine eingefrorene Zahl stünde hier falsch, sobald jemand
committet.

## Bindung

Alle fünf sind Konventions-Bindungen der Klasse `MR-002`
([`../conventions.md`](../conventions.md#mr-002)); ihre Form ist
`Kurs §<Abschnitt>` bzw. `Modul <N> §<Abschnitt>`. **Je Modul eine eigene** —
die Zeile trug lange nur die Bindung von `ids`/`matrix`, und die ist für
`reviews`, `planning` und `targets` fachlich unpassend (Review-Befund F-4 vom
2026-09-05).

| Modul | Bindung |
|---|---|
| `reviews` | [Modul 10 §Harness-Einordnung](../../../../kurs/de/04-qualitaet/modul-10-review-harness.md#harness-einordnung) — Review-Report-Deckung |
| `ids`, `matrix` | [Kurs §Referenz-Richtung](../../../../kurs/de/grundlagen/referenz-richtung.md#referenz-richtung-sdp-wer-darf-wen-referenzieren) |
| `planning` | [Modul 6 §Die Wellen-Eröffnungs-Prozedur](../../../../kurs/de/02-planung/modul-06-roadmap.md#die-wellen-eröffnungs-prozedur) — Ruhe-Marker und Wellen-Invariante |
| `targets` | [`../../AGENTS.md`](../../AGENTS.md) §3 — halluzinierte Gates |
