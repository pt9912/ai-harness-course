# `make doc-check` — sechs d-check-Module

Vertiefung zur Index-Zeile in [`../README.md` §Sensors](../README.md#sensors-feedback-gates).
Bindung je Modul unten — **eine** Zitation für sechs Module wäre für fünf davon
die falsche.

## Vertrag

**Sechs Module — fünf über Doku-Referenzen, eines über den Umfang einer
Guide-Datei.** Rot, wenn eines davon eine Festlegung verletzt; was jedes prüft
und wie es an seinen Randformen entscheidet, legen
[`SPEC-020` bis `SPEC-025` und `SPEC-027`](../../spec/spezifikation.md#7-festlegungen-der-harness-werkzeuge) fest; welche Kennung zu
welchem Modul gehört, steht unten unter [Bindung](#bindung).

## Grenze — was das Grün nicht abdeckt

1. **`ids` greift in `docs/plan/adr/` selbst nicht** — das Modul nimmt sein
   Ziel-Verzeichnis aus. Permanent, es ist die Bauform des Moduls.
2. **`reviews` deckt die *Existenz* eines Reports, nicht seine Güte.** Die
   Kategorisierung eines Findings bleibt inferential (Reviewer-Skill), diese
   Deckung ist computational — permanent, denn die Grenze zwischen beiden ist
   die Bauform der Prüfung, nicht ihre Konfiguration
   ([Kurs Modul 5 §Worked Example: einen zu großen Slice schneiden](../../../../kurs/de/02-planung/modul-05-planning-harness.md#worked-example-einen-zu-großen-slice-schneiden),
   [Modul 10 §Harness-Einordnung](../../../../kurs/de/04-qualitaet/modul-10-review-harness.md#harness-einordnung)).
3. **`reviews` findet nur die Zusage, deren Wortlaut es kennt.** Eine
   DoD-Zeile in eigener Formulierung trifft das Muster nicht; das fällt nur
   auf, solange *gar keine* Zusage mehr erkannt wird (`require-promises`),
   nicht bei einem einzelnen Slice neben anderen in Vorlagen-Form. Ein
   `promise-pattern` mit Alternation deckt bekannte Formulierungen ab; eine
   neue bleibt still. Permanent — das Muster kann nur kennen, was jemand
   hineingeschrieben hat.
4. **`reviews` prüft archivierte Slices nicht mehr.** Ein Stub mit
   `> **ARCHIVIERT**` fällt per `skip-pattern` heraus, und sind alle
   archiviert, ist die leere Menge der Ruhezustand (`skip-allows-empty`), kein
   Befund. Permanent und gewollt: Volltext und Report liegen im Archiv, geprüft
   wird vor dem Archivieren.
   Mit `require-promises` hat das eine Kehrseite hier im Beispiel: Nur ein
   Slice trägt die Review-Zeile, die sieben älteren stammen aus der Zeit davor.
   Wird er archiviert, bleiben Kandidaten ohne eine einzige Zusage, und das
   Modul meldet den Leerlauf, obwohl nichts fehlt. Heilbar in der
   Konfiguration: die Alt-Slices namentlich in `reviews.exempt-paths`, sobald
   es so weit ist — vorher wäre die Ausnahme eine Senkung ohne Anlass.
5. **`planning.waves` braucht `mode: many`.** Der Werkzeug-Default `one` hält
   den Block gegen *genau eine* Datei und meldet unter Offene Wellen legitime
   Zustände als Drift; der Ruhe-Marker geht in die Bijektion nicht ein. Heilbar
   — durch die Konfiguration, nicht durch das Werkzeug.
6. **`file` prüft nur `AGENTS.md`, nur die Zeilenzahl.** Keine Aussage über
   Inhalt/Qualität, kein Rückbau erzwungen, keine Staleness-Prüfung (ist die
   Zeile seit Langem unverändert rot). Nur diese eine Datei ist konfiguriert;
   `harness/README.md` §Sensors trägt keine eigene Obergrenze.

**Wie groß der Prüfbereich ist, sagen zwei Kommandos, nicht diese Datei:**
`make doc-check 2>&1 | tail -1` nennt die Zahl der geprüften Dateien, und
`sed -n '/^scan:/,/^[a-z]/p' ../../.d-check.yml` die Wurzeln und Ignores, aus
denen sie entsteht. Eine eingefrorene Zahl stünde hier falsch, sobald jemand
committet.

## Bindung

Alle sechs sind Konventions-Bindungen der Klasse `MR-002`
([`../conventions.md`](../conventions.md#mr-002)); ihre Form ist
`Kurs §<Abschnitt>` bzw. `Modul <N> §<Abschnitt>`. **Je Modul eine eigene** —
die Zeile trug lange nur die Bindung von `ids`/`matrix`, und die ist für
`reviews`, `planning` und `targets` fachlich unpassend (Review-Befund F-4 vom
2026-09-05).

| Modul | Festlegung | Bindung |
|---|---|---|
| `reviews` | [`SPEC-020`](../../spec/spezifikation.md#7-festlegungen-der-harness-werkzeuge) (seit slice-review-report-deckung-per-d-check) | [Modul 10 §Harness-Einordnung](../../../../kurs/de/04-qualitaet/modul-10-review-harness.md#harness-einordnung) — Review-Report-Deckung |
| `ids`, `matrix` | [`SPEC-021`, `SPEC-024`](../../spec/spezifikation.md#7-festlegungen-der-harness-werkzeuge) | [Kurs §Referenz-Richtung](../../../../kurs/de/grundlagen/referenz-richtung.md#referenz-richtung-sdp-wer-darf-wen-referenzieren) |
| `planning` | [`SPEC-022`, `SPEC-027`](../../spec/spezifikation.md#7-festlegungen-der-harness-werkzeuge) (Wellen-Invariante seit slice-wellen-invariante-per-d-check) | [Modul 6 §Die Wellen-Eröffnungs-Prozedur](../../../../kurs/de/02-planung/modul-06-roadmap.md#die-wellen-eröffnungs-prozedur) — Ruhe-Marker und Wellen-Invariante |
| `targets` | [`SPEC-023`](../../spec/spezifikation.md#7-festlegungen-der-harness-werkzeuge) | [Modul 13 §Hard Rule](../../../../kurs/de/04-qualitaet/modul-13-quality-gates.md#hard-rule-doku-disziplin) — halluzinierte Gates; verkoerpert in `AGENTS.md` §3 |
| `file` | [`SPEC-025`](../../spec/spezifikation.md#7-festlegungen-der-harness-werkzeuge) (seit Welle 147) | [Kurs §Entropy Management](../../../../kurs/de/grundlagen/klassifikation.md#entropy-management) — Guide-Datei-Wildwuchs |
