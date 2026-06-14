# CO-001: Bootstrap-Coverage `internal/index/`

**Status:** Aktiv.

**Datum angelegt:** 2026-05-20. **Letzte Prüfung:** 2026-06-01.

**Betroffenes Gate:** `coverage-gate-critical`.

**Geltungsbereich:** `internal/index/` (Index-Layer, alle Sprachen).

**Folge-Slice:** [`slice-013-property-tests.md`](../planning/in-progress/slice-013-property-tests.md)

---

## Begründung

`coverage-gate-critical` verlangt 90 % Zeilen-Coverage für
kritische Layer. Der Index-Layer enthält Binär-Format-Parser, deren
Fehlerpfade (`E099` bei korrupter Datei) durch Unit-Tests nur partiell
abgedeckt werden — eine Property-Test-Suite (slice-013) wird die
verbleibenden Pfade abdecken.

Aktueller Stand: 76 % statt 90 %. Ohne Property-Tests bleibt
`coverage-gate-critical` lokal rot oder muss diese Datei zur Carveout-
Liste haben.

## Auflösungs-Trigger

Welle 2 (welle-2-qualitaet) done — Property-Test-Suite läuft 100
Generationen und deckt die Fehlerpfade.

Konkret: `internal/index/`-Coverage erreicht ≥ 90 %, geprüft in
`make coverage-gate-critical` ohne Ausnahmen.

## Geltungs-Konfiguration

| Datei | Section | Wert |
|---|---|---|
| `<sprache>/coverage.config` | `critical_paths.exceptions` | `internal/index/` mit Kommentar `# CO-001` |

(Die konkrete Datei pro Sprache wird in Phase C des Lab-Aufbaus
ausgefüllt — Pfad-Konvention bleibt analog.)

## Verifikation (nach Auflösung)

- [ ] `internal/index/`-Coverage in allen sechs Sprach-Skeletten ≥ 90 %.
- [ ] Carveout-Konfiguration aus Coverage-Config entfernt.
- [ ] `make coverage-gate-critical` grün ohne Ausnahmen.
- [ ] Diese Datei nach `done/CO-001-index-coverage.md` bewegt (reiner `git mv`).
- [ ] slice-013 Closure-Notiz schließt diese Auflösung mit ein.

## Geschichte

| Datum | Ereignis | Verweis |
|---|---|---|
| 2026-05-20 | Angelegt | slice-005 (Index-Format) |
| 2026-06-01 | Geprüft, weiterhin gültig — Welle 2 läuft | slice-013 |
