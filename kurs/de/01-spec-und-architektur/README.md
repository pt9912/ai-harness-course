# Phase 1 — Spec und Architektur

Vier Module, die die Grundlage für jeden späteren Agentenlauf legen:
*wie alles zusammenhängt* (Lebenszyklus), *in welchem Modus
gearbeitet wird* (Harness-Bootstrap), *was* gebaut wird (Spec) und
*warum so* (ADR).

| Modul | Inhalt |
|---|---|
| [Modul 1](modul-01-entwicklungszyklus.md) | Lebenszyklus Spec → ADR → Plan → Code → Review → Verifikation → Closure; Source Precedence im Repo |
| [Modul 2](modul-02-harness-bootstrap.md) | Harness-Bootstrap-Modus pro Sub-Area: GF/BF/Hybrid-Diagnose, vier Trigger-Klassen, Phasen-Reife, Reconciliation bei BF-Diskrepanzen |
| [Modul 3](modul-03-lastenheft.md) | Lastenheft und Spezifikation: Akzeptanzkriterien, Stratifizierung, ID-Schema |
| [Modul 4](modul-04-architektur-adrs.md) | Architekturentscheidungen mit ADRs; Übersetzung in Fitness Functions |

Voraussetzung: [`grundlagen/`](../grundlagen/) gelesen, insbesondere
[`konventionen.md`](../grundlagen/konventionen.md) (Source Precedence,
Spec-Stratifizierung).

Nach dieser Phase: [Phase 2 — Planung](../02-planung/).
