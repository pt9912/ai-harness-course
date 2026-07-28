# Beobachtungs-Register

**Status:** Aktiv. **Letzte Änderung:** 2026-07-27.

Der Zähler des Steering Loops (1× notieren · 2× Symptom · 3× Lücke).
Regeln: Kurs-Regelwerk `modul-06-roadmap.md` §Das Beobachtungs-Register.

> Die Kennungen wurden bei der Einführung des Registers **retrospektiv**
> vergeben (Kurs-Welle 59) und folgen deshalb nicht der Reihenfolge des
> Erstauftretens. Ab hier gilt: fortlaufend beim Erstauftreten.

| Kennung | Beobachtung | Sub-Area | Zähler | Belege | Stand |
|---|---|---|---|---|---|
| BEO-001 | Golden-Set-Case ohne Boundary-Anteil aufgenommen | Test-Infrastruktur | 2× | slice-005, slice-011 | offen |
| BEO-002 | Golden-Set deckt keine Gleichstands-Eingaben ab | Test-Infrastruktur | 1× | slice-009 (§6, Ausgang „weiter offen") | offen |
| BEO-003 | ADR-Bezug im Commit vergessen, im Review nachgetragen | Spec-Schreibung | 2× | slice-008, slice-012 (Finding-Klasse aus Review) | offen |
| BEO-004 | Spec-Text wird zur Nachvollziehbarkeit um Slice-Bezüge ergänzt | Spec-Schreibung | 1× | slice-020 | offen |
| BEO-005 | Tie-Break in sortierender Operation nicht explizit dokumentiert | Sortier-Semantik | 3× | slice-006, slice-009, slice-012 | verkörpert in `AGENTS.md` §2.7 (`seit welle-1`) |
| BEO-006 | `check-references` prüft nur `spec/`, nicht `docs/plan/adr/` | Spec-Schreibung | 1× | slice-020 (§6, Ausgang „weiter offen") | offen |

## Gestrichene Einträge

| Kennung | Beobachtung | Gestrichen am | Warum sie nicht mehr auftreten kann |
|---|---|---|---|
| — | — | — | — |
