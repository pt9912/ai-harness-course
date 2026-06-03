# Differenzierte Lernpfade

Der Kurs adressiert eine heterogene Zielgruppe (Entwickler, Architekt,
Tech Lead, DevOps, KI-Plattform-Team). Alle 16 Module sind sinnvoll —
aber je nach Rolle liegen die Vertiefungen anders. Drei
empfohlene Schwerpunktpfade. Lies alle Module einmal; vertiefe entlang
deines Pfads.

## Schnell-Diagnose: welcher Pfad passt?

Vier Fragen mit drei Antwortmöglichkeiten. Markiere pro Frage, welcher
Buchstabe (A/B/C) am ehesten passt. Der Buchstabe, den du dreimal oder
viermal markiert hast, ist *dein Pfad*. Bei Gleichstand entscheidet
Frage 4.

| Frage | Wenn du eher … | Pfad |
|---|---|---|
| 1. *Wer entscheidet bei dir über Architektur?* | … selbst entscheidest oder entscheidende Stimme bist | A |
| | … die Plattform/CI für andere Teams baust | B |
| | … in einem bestehenden Architekturrahmen umsetzt | C |
| 2. *Was kostet dich heute am meisten Zeit?* | unklare Anforderungen / Spec-Lücken | A |
| | rote Builds / Reproduzierbarkeits-Drift | B |
| | Reviewer-Hin-und-Her / unklare Konventionen | C |
| 3. *Wo schlägt eine Halluzination am ehesten zu?* | im ADR-Wissen (Lösung erfunden) | A |
| | in der Build-/Deploy-Kette (Befehl erfunden) | B |
| | im Code (Funktion erfunden, Test umgangen) | C |
| 4. *Welches Modul liest du als Erstes mit Vorfreude?* | Modul 2 (Lastenheft) oder Modul 3 (ADRs) | A |
| | Modul 12 (Quality Gates) oder Modul 13 (Docker) | B |
| | Modul 8 (Implementierung) oder Modul 9 (Review) | C |

Die Diagnose ist *probabilistisch* — gleicher Logik wie die
Voraussetzungs-Selbst-Diagnose in
[`../README.md`](../README.md#selbst-diagnose-vom-voraussetzungscheck-zur-phase).
Bei Unsicherheit: Pfad A, weil Spec-Disziplin alle Rollen trägt.

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

## Domänen-Anker — welche Fallstudie passt zu dir?

Die Lernpfade sortieren nach *Rolle*, die folgende Tabelle nach *Domäne
deines Repos*. Beide Sortierungen sind orthogonal: ein DevOps-Engineer im
regulierten Umfeld liest Pfad B *und* zieht primär die Compliance-Fallstudien
heran.

| Domäne deines Repos | Primäre Fallstudien (in [`fallstudien.md`](fallstudien.md)) | Was du dort priorisierst |
|---|---|---|
| **Reguliert (Finanzen, Medizin, Behörden)** | `c-hsm-doc` (Policy/Compliance) | Spec-Stratifizierung, ID-Schema `HSM-*`, Hard Rule "Accepted-ADRs immutable", Traceability als Pflicht. |
| **Safety-/Control-kritisch (Industrie-, Energie-Systeme, Hardware)** | `bess-ems` (Safety/Control-Flagship) | Hard Rules (Optimierer schreibt nie direkt), `solid-suppression-gate`, Property-Based-Sensors, native Sanitizer-Gates. |
| **Embedded LLM-Anwendung (Cost/Latency-kritisch)** | `grid-gym` (Referenz, Domäne) + Modul 14 | Cost-Attribution pro Slice, Cache-Hit-Rate als Metrik, Determinism/Replay/Fault als eigene Test-Klassen. |
| **Internes Developer-Tool** | `grid-gym` (Referenz, Domäne) | AGENTS.md-Disziplin, Welle-Self-Close, Replay-Lauf gegen Modellwechsel. |
| **Plattform/Multi-Repo-Landschaft** | `grid-gym` + `bess-ems` + `c-hsm-doc` parallel | Repo-Klassen (Referenz/Safety/Compliance), Einführungsregel "erst Referenz, dann Flagship", Carveout-Management über Teams. |
| **Migration / Brownfield (kein Greenfield-Harness)** | alle drei Repos (Stand 2026-06 ohne `harness/README.md`) | Beobachtung in [`fallstudien.md` §Beobachtung aus dem Ist-Zustand](fallstudien.md#beobachtung-aus-dem-ist-zustand): kanonische Quellen existieren oft, ein formeller Einstiegspunkt fehlt — *das* ist der typische Ausgangspunkt. |

Die vollständige Liste der Branchen-Anwendungsanker steht in
[`fallstudien.md` §Branchen-Anwendungsanker](fallstudien.md#branchen-anwendungsanker).

## Selbstcheck-Anker pro Pfad

Damit die Pfade aus der Empfehlungs-Schicht in die Bewertungs-Schicht
hinüberreichen, hat jeder Pfad eine *Mindest-Stufen-Liste* für eine
Auswahl von Modul-Selbstchecks (Stufen-Schema in
[`selbstcheck-rubrik.md`](selbstcheck-rubrik.md): rudimentär · solide ·
exzellent). Lesart: *Wer Pfad X läuft, sollte am Ende mindestens die
gelistete Stufe in den genannten Selbstchecks erreichen — andernfalls ist
der Pfad nicht abgeschlossen, auch wenn die Module gelesen wurden.*

Die Anker sind bewusst **schmal** (4–6 Module pro Pfad), nicht alle 16 —
sonst zerfällt die Pfad-Idee. Module, die hier *nicht* gelistet sind, sind
für den Pfad nicht weniger wichtig, aber unter *rudimentär* akzeptabel.

### Pfad A — Architect / Tech Lead

| Modul | Mindest-Stufe | Begründung |
|---|---|---|
| 2 (Lastenheft) | **exzellent** | Spec-Disziplin ist die Achse, an der Pfad A hängt. |
| 3 (ADRs) | **exzellent** | ADR ↔ Fitness Function ist die Kernkompetenz. |
| 6 (Carveouts) | **solide** | Carveout-Audit als Architect-Pflicht. |
| 7 (Agentenrollen) | **solide** | Konfliktauflösung mit Übergabe-Artefakt. |
| 10 (Verifikation) | **solide** | ADR-Konformität als Fitness Function entwerfen. |
| 14 (Observability) | **rudimentär** | OTel-Assertions kennen, nicht selbst bauen. |

Frühwarnsignal: *rudimentär* in 2 oder 3 → kein Pfad A. Vertiefen, bevor
weitergegangen wird.

### Pfad B — DevOps / KI-Plattform-Team

| Modul | Mindest-Stufe | Begründung |
|---|---|---|
| 12 (Quality Gates) | **exzellent** | Gate-Vertrag und bootstrap-aware Gate. |
| 13 (Docker-Harness) | **exzellent** | Image-Hash und Lock-Files sind die Reproduzierbarkeits-Anker. |
| 14 (Observability) | **exzellent** | Cost-Attribution + Cache-Metrik + Doku-Konsistenz-Agent. |
| 11 (Replay) | **solide** | Drift-Diagnose-Reihenfolge beherrschen. |
| 15 (Produktiver Betrieb) | **solide** | Runbook-Trigger und Rollback-Anti-Reflex. |
| 4 (Planning Harness) | **rudimentär** | Lifecycle als CI-Eingang verstehen, nicht selbst schneiden. |

Frühwarnsignal: *rudimentär* in 12 oder 13 → kein Pfad B. Plattform ohne
Gates und Image-Pinning ist Wartung ohne Werkzeug.

### Pfad C — Implementierender Entwickler

| Modul | Mindest-Stufe | Begründung |
|---|---|---|
| 8 (Implementierung) | **exzellent** | 8-Schritt-Workflow als Reflex, AGENTS.md-Wirkungsmessung. |
| 9 (Review Harness) | **exzellent** | Reviewer-Skill schreiben, HIGH/MEDIUM/LOW/INFO sauber trennen. |
| 1 (Entwicklungszyklus) | **solide** | Source Precedence verinnerlicht. |
| 7 (Agentenrollen) | **solide** | Rollenbild für eigenes Arbeiten. |
| 4 (Planning Harness) | **solide** | Slice-Größe und Closure-Kriterien. |
| 12 (Quality Gates) | **solide** | Lokales Vor-Merge-Gate-Set lesen können. |

Frühwarnsignal: *rudimentär* in 8 oder 9 → kein Pfad C. Implementer ohne
Workflow-Reflex und ohne Reviewer-Skill liefert Diff-Last, nicht Slices.

### Was dieser Anker *nicht* leistet

- Keine *Bewertung* deines Projekts — die übernimmt das Abschlussprojekt
  ([`../abschluss/abschlussprojekt.md`](../abschluss/abschlussprojekt.md)).
- Keine *Begrenzung* deines Lernens — wer in seinem Pfad nicht gelisteten
  Modulen über *rudimentär* hinausgeht, gewinnt; er muss nur nicht.
- Keine *Zertifizierung* — die Selbstcheck-Stufen sind Selbsteinschätzung
  ([`selbstcheck-rubrik.md` §"Wie du dich selbst schärfer beurteilen kannst"](selbstcheck-rubrik.md#wie-du-dich-selbst-schärfer-beurteilen-kannst)).

Was er leistet: ein **konstruktives Alignment** zwischen Pfad-Empfehlung
und Selbstcheck-Rubrik (Biggs/Tang). Ohne diesen Anker bleibt "Pfad A"
ein Slogan; mit ihm ist es ein prüfbarer Lernkontrakt.

## Hinweis

Die Pfade ersetzen die Module nicht — sie schlagen vor, wo du *zusätzlich
Zeit* investierst. Der Voraussetzungscheck im
[Kurs-README](../README.md#voraussetzungscheck) bleibt für alle gleich,
und das Abschlussprojekt prüft alle Achsen rollenneutral.
