# Beobachtungs-Register

**Status:** Aktiv. **Letzte Änderung:** 2026-06-03.

Der Zähler des Steering Loops (1× notieren · 2× Symptom · 3× Lücke).

Regeln dieses Registers: Kurs-Regelwerk `modul-06-roadmap.md`
§Das Beobachtungs-Register — wer schreibt, wer liest, wann gestrichen wird,
welche Form ein Beleg hat (Form · Anzahl · Lage) und dass eine leere Tabelle
`— keine —` trägt statt zu verschwinden.

> Die Kennungen wurden bei der Einführung des Registers **retrospektiv**
> vergeben (Kurs-Welle 59) und folgen deshalb nicht der Reihenfolge des
> Erstauftretens. Ab hier gilt: fortlaufend beim Erstauftreten.

| Kennung | Beobachtung | Sub-Area | Zähler | Belege | Stand |
|---|---|---|---|---|---|
| BEO-001 | Golden-Set-Case ohne Boundary-Anteil aufgenommen | Replay-/Eval-Infrastruktur | 2× | slice-005, slice-011 | offen |
| BEO-002 | Golden-Set deckt keine Gleichstands-Eingaben ab | Replay-/Eval-Infrastruktur | 1× | slice-009 | offen |
| BEO-003 | ADR-Bezug im Commit vergessen, im Review nachgetragen | Planning-Lifecycle | 2× | slice-008, slice-012 | offen |
| BEO-004 | Spec-Text wird zur Nachvollziehbarkeit um Slice-Bezüge ergänzt | Spec-Schreibung | 1× | slice-020 | offen |
| BEO-005 | Tie-Break in sortierender Operation nicht explizit dokumentiert | Implementierung | 3× | slice-006, slice-009, slice-012 | verkörpert in `AGENTS.md` §2.7 (`seit welle-1`) |
| BEO-006 | `check-references` prüft nur `spec/`, nicht `docs/plan/adr/` | Planning-Lifecycle | 1× | slice-020 | geschlossen in `slice-022`: `matrix` führt `adr` als Quellklasse |
| BEO-007 | Grenzwert der Suche im Lastenheft nicht behandelt | Spec-Schreibung | 3× | slice-003, slice-005, slice-007 | verkörpert als benannte Spec-Lücke in Lastenheft v0.2.0 (`LH-FA-02`, `welle-1-results.md`) |

## Gestrichene Einträge

| Kennung | Beobachtung | Gestrichen am | Warum sie nicht mehr auftreten kann |
|---|---|---|---|
| — | — | — | — |
