# Differenzierte Lernpfade

Der Kurs adressiert eine heterogene Zielgruppe (Entwickler, Architekt,
Tech Lead, DevOps, KI-Plattform-Team). Alle 16 Module sind sinnvoll —
aber je nach Rolle liegen die Vertiefungen anders. Drei
empfohlene Schwerpunktpfade. Lies alle Module einmal; vertiefe entlang
deines Pfads.

## Pfad A — Architect / Tech Lead

Schwerpunkt: Spec-Disziplin, ADR-Schärfe, Verifikation,
Architecture-Fitness.

| Modul | Vertiefung |
|---|---|
| [2 — Lastenheft](../01-spec-und-architektur/modul-02-lastenheft.md) | Spec-Stratifizierung, Akzeptanzkriterien Boundary/Negative |
| [3 — ADRs](../01-spec-und-architektur/modul-03-architektur-adrs.md) | ADR ↔ Fitness Function, Hard Rule "Accepted-ADRs immutable" |
| [6 — Carveouts](../02-planung/modul-06-carveouts.md) | Kopplung Carveout ↔ Folge-Slice, Auflösungs-Trigger |
| [7 — Agentenrollen](../03-agenten/modul-07-agentenrollen.md) | Rollen-Übergaben, Konfliktauflösung |
| [10 — Verifikation](../04-qualitaet/modul-10-verification.md) | Plan-gegen-Code, DoD-Erkennung |
| [14 — Observability](../05-betrieb/modul-14-observability.md) | Architecture-Fitness-Telemetrie, OTel-Assertions |

Tieferes Lesen: [`fallstudien.md`](fallstudien.md) — Spec-Stratifizierung
in `c-hsm-doc`, Hard Rules in `bess-ems`.

## Pfad B — DevOps / KI-Plattform-Team

Schwerpunkt: Gates, Reproduzierbarkeit, Observability, Incident
Response.

| Modul | Vertiefung |
|---|---|
| [4 — Planning Harness](../02-planung/modul-04-planning-harness.md) | Lifecycle-Verzeichnisse als CI-Eingang |
| [12 — Quality Gates](../04-qualitaet/modul-12-quality-gates.md) | Make-Target-Vertrag, bootstrap-aware Gates |
| [13 — Docker Harness](../05-betrieb/modul-13-docker-harness.md) | Multi-Stage, Image-Pinning, Lock-Files |
| [14 — Observability](../05-betrieb/modul-14-observability.md) | OTel-Collector, Token-Attribuierung, Cache-Hit-Metriken |
| [15 — Produktiver Betrieb](../05-betrieb/modul-15-produktiver-betrieb.md) | Runbooks, Replay als Forensik, Rollback-Entscheidung |
| [11 — Replay](../04-qualitaet/modul-11-replay-evaluierung.md) | Determinism-Tests, Drift-Messung |

Tieferes Lesen: [`fallstudien.md`](fallstudien.md) — reichhaltige
Gate-Landschaft in `grid-gym` (18 Gates), Central Package Management
in `bess-ems`.

## Pfad C — Implementierender Entwickler

Schwerpunkt: Agentenbedienung, Review-Disziplin, Hard Rules.

| Modul | Vertiefung |
|---|---|
| [1 — Entwicklungszyklus](../01-spec-und-architektur/modul-01-entwicklungszyklus.md) | Traceability-Kette, Source Precedence |
| [4 — Planning Harness](../02-planung/modul-04-planning-harness.md) | Slice-Größe, "in einer Sitzung prüfbar" |
| [7 — Agentenrollen](../03-agenten/modul-07-agentenrollen.md) | Rollenbild beim eigenen Arbeiten |
| [8 — Implementierung](../03-agenten/modul-08-implementierung.md) | 8-Schritt-Workflow, Hard Rules, AGENTS.md |
| [9 — Review Harness](../04-qualitaet/modul-09-review-harness.md) | Finding-Kategorisierung, Reviewer-Skill |
| [12 — Quality Gates](../04-qualitaet/modul-12-quality-gates.md) | Lokales Vor-Merge-Gate-Set |

Tieferes Lesen: [`fallstudien.md`](fallstudien.md) — Hard Rules in
`grid-gym` (Docker-only, noqa-Verbot, git mv + Inhalt = zwei Commits).

## Hinweis

Die Pfade ersetzen die Module nicht — sie schlagen vor, wo du *zusätzlich
Zeit* investierst. Der Voraussetzungscheck im
[Kurs-README](../README.md#voraussetzungscheck) bleibt für alle gleich,
und das Abschlussprojekt prüft alle Achsen rollenneutral.
