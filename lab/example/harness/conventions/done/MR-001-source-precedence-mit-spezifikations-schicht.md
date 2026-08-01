# MR-001 — Source Precedence mit eigener Spezifikations-Schicht

**Status:** Accepted · aufgelöst durch MR-003

> **Aufgelöst durch [`MR-003`](../MR-003-mr-001-gegenstandslos.md)
> (2026-08-01).** Der Eintrag bleibt unverändert stehen — Adaptionen werden
> nicht überschrieben, sondern von einem Nachfolger abgelöst
> ([`source-precedence.md` §Source Precedence](../../../../../kurs/de/grundlagen/source-precedence.md#source-precedence)).

- **Datum:** 2026-05-15
- **Geltungsbereich:** [`harness/README.md` §Source precedence](../../README.md#source-precedence) und `AGENTS.md` §Kanonische Quellen
- **Adaption:** Die Source-Precedence-Tabelle führt
  [`spec/spezifikation.md`](../../../spec/spezifikation.md) als eigenen
  **Rang 2** zwischen Lastenheft (Rang 1) und Architektur (Rang 3).
  Der Kurs-Default
  ([`source-precedence.md` §Source Precedence](../../../../../kurs/de/grundlagen/source-precedence.md#source-precedence))
  setzt nur zwei Spec-Ränge (`lastenheft` → `architecture`); dieses
  Repo nutzt drei.
- **Begründung:** Das Repo verwendet die Spec-Stratifizierung
  ([`source-precedence.md` §Spec-Stratifizierung](../../../../../kurs/de/grundlagen/source-precedence.md#spec-stratifizierung))
  explizit mit drei Spec-Dateien — Lastenheft (vertraglich),
  Spezifikation (technisch fortschreibbar), Architektur (diagrammatisch).
  Damit die Source-Precedence-Tabelle die ADR-Schärfungs-Regel
  ("ADR darf Spezifikation schärfen, nicht Lastenheft") strukturell
  abbildet, muss die Spezifikation als eigener Rang sichtbar sein —
  sonst kollabiert die Trennschärfe zwischen "wir versprechen" und
  "wir liefern wie".
- **Auflösungs-Trigger:** permanent.
