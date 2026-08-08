# Slice 015: Replay-Runner mit Ergebnis-Vergleich

**Lifecycle:** Der Zustand dieses Slice ist das Verzeichnis, in dem diese
Datei liegt — eines von `open/`, `next/`, `in-progress/`, `done/`. Er wechselt
nur durch `git mv` (Kurs
[Modul 5 §Lifecycle als State Machine](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#lifecycle-als-state-machine)).

**Welle:** ohne Welle — die Closure-Bedingung ist die DoD dieses Slice, es
gibt keine darüber hinausgehende repo-weite Zusage.

**Bezug:** LH-QA-02 (Determinismus), [CO-002](../../carveouts/CO-002-replay-verifikation.md)

**Berührte Spec-Stellen:** —

**Autor:** Kurs-Lab. **Datum:** 2026-07-31.

## 1. Ziel

`make replay` von der Struktur-Prüfung zur Ergebnis-Prüfung heben: Cases
ausführen, gegen `expectations/` vergleichen, Case-Hash bilden — damit ein
Modellwechsel das Target rot macht.

## 2. Definition of Done

- [ ] Korpus unter `evals/corpus/` mit den Dokumenten, die die Erwartungen referenzieren (`docs/init.md` u. a.).
- [ ] Runner `tools/replay.py` liest `manifest.yaml`, indexiert das Korpus, führt die Cases aus und vergleicht gegen `expectations/`. <!-- d-check:ignore (entsteht erst in diesem Slice) -->
- [ ] `top_score_min` je Case gegen die tatsächliche `MockEmbedder`-Ausgabe kalibriert, nicht geraten.
- [ ] `verification.per_case_hash` eingelöst: SHA-256 je Case über die normalisierte Ergebnisliste.
- [ ] `verification.determinism_check` eingelöst: zwei Läufe, gleicher Hash.
- [ ] Break-Test dokumentiert: geändertes `model.version` → **rot**; verfälschte Erwartung → **rot**.
- [ ] `make gates` grün.
- [ ] Closure-Notiz mit den zwei Break-Test-Ausgaben.

## 3. Plan (vor Code)

| Datei / Komponente | Änderungs-Art | Begründung |
|---|---|---|
| `evals/corpus/` | neu | Ohne Korpus ist kein Lauf ausführbar |
| `tools/replay.py` <!-- d-check:ignore (entsteht erst in diesem Slice) --> | neu | Runner; Python steht schon als Toolchain im Manifest |
| `Makefile` Target `replay` | update | Struktur-Prüfung bleibt Vorstufe, Lauf kommt dazu |
| `evals/golden/welle-1-baseline/expectations/*.json` | update | Kalibrierte Schwellen |
| `evals/golden/welle-1-baseline/manifest.yaml` | update | `# CO-002`-Markierung entfernen |
| `docs/plan/carveouts/CO-002-replay-verifikation.md` | `git mv` → `done/` | Auflösung |

## 4. Trigger

- Kein Vorläufer-Slice nötig. Auslöser ist [CO-002](../../carveouts/CO-002-replay-verifikation.md).

## 5. Risiken

| Risiko | Wahrscheinlichkeit | Gegenmaßnahme |
|---|---|---|
| Kalibrierte Schwellen zementieren die Mock-Implementierung statt das Verhalten | mittel | Erwartungen als Verhalten formulieren (`must_include`, `top_section_title_contains`), Score nur als Untergrenze |
| Der Runner wird sechssprachig gefordert | mittel | Bewusst eine Referenz-Sprache (Go, wie im Manifest unter `runtime.implementation`); die anderen Skelette bleiben außen vor |

## 6. Offene Risiken zur Welle-Closure

- Entfällt — Slice ohne Welle.

## 7. Steering-Loop-Beobachtungen

- Noch keine.

## 8. Sub-Area-Modus-Begründung

Berührte Sub-Area: *Evaluierung* (`evals/`, `tools/`). Modus **GF** — das
Verzeichnis trägt heute nur ein Fixture, kein ausführendes Werkzeug; es gibt
keinen gewachsenen Code-Stand, gegen den zu rekonziliieren wäre. Die
Konvention (Manifest-Schema) steht bereits und führt.

## 9. Closure

- Noch offen.
