# Abschlussprojekt — AI Harness Platform

## Aufgabe

Baue einen vollständigen, auditierbaren Entwicklungsprozess mit KI-Agenten
für *ein konkretes Repo* auf. Die Bewertung greift fünf Achsen ab
(Vollständigkeit · Konsistenz · Reproduzierbarkeit · Auditierbarkeit ·
Steering-Loop-Reife) — siehe Bewertungsraster unten.

### Wenn du kein eigenes Mitbringprojekt hast

Wähle eines der beiden Starter-Szenarien. Beide sind klein genug für ein
Solo-Abschluss, groß genug, um alle Achsen abdecken zu können.

**Szenario A — DocSearch-Mini-Service** (Default für Pfad B/C).
Erweitere [`/lab/example/`](../../../lab/example/) (Volltext-Suche über
Markdown-Dateien) um *ein* neues Feature in einer der fünf
Sprach-Skelette: *Rate-Limit pro IP* oder *Query-Caching mit TTL*. Dein
Repo trägt am Ende eine ADR (Read-through-Cache vs. Look-aside),
mindestens drei Slices in den vier Lifecycle-Verzeichnissen, ein Replay
mit drei Golden-Set-Fällen und einen dokumentierten Failure → Sensor-Schritt.

**Szenario B — Reguliertes Compliance-Repo** (Default für Pfad A).
Lege ein neues kleines Repo an, das eine *Policy* maschinell prüfbar
macht (z. B. *"Jedes API-Endpoint trägt eine `X-Compliance-Class`-ID
mit Whitelist-Werten"*). Erforderlich: Spec-Stratifizierung
(Lastenheft/Spezifikation/Architektur), ID-Schema `POL-*`, ADR für
*Accepted-immutable*-Regel, Fitness Function als CI-Gate. Vorbild ist
`pt9912/c-hsm-doc` (siehe
[`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)).

Beide Szenarien sind *Default*, kein Pflicht-Pfad. Wer ein eigenes
Mitbringprojekt nutzt, soll mindestens die Achsen-Tiefe der Szenarien
erreichen — nicht das spezifische Feature.

## Features

Aus den 17 Modulen muss das Repo am Ende belegbar enthalten:

* Harness-Bootstrap-Klassifikation pro Sub-Area (GF/BF/Hybrid-Modus,
  Phasen-Reife, Trigger-Klassen) — entweder in `harness/conventions.md`
  als Modus-Block oder als externes Reifegrad-Inventar
* Spezifikation
* ADRs
* Planning Lifecycle
* Agentenrollen
* Reviews
* Verifikation
* Replay
* Evaluierung
* Quality Gates
* Observability

## Abgabe

Vollständiges Repository inklusive Dokumentation, Gates, Roadmap,
Reviews und Abschlussbericht. Das Repository muss:

* `make gates` grün durchlaufen
* einen Replay-Lauf gegen ein Golden Set reproduzieren
* mindestens eine ADR, einen Carveout und einen geschlossenen Slice in `done/` enthalten
* einen Trace eines kompletten Agenten-Durchlaufs (Plan → Implement → Review → Verify) im Anhang dokumentieren

## Bewertungsachsen

| Achse | Frage |
|---|---|
| Vollständigkeit | Sind alle Phasen-Artefakte vorhanden (Spec, ADR, Plan, Code, Review, Verifikation, Replay)? |
| Konsistenz | Stimmt Source Precedence? Widerspricht AGENTS.md keiner kanonischen Quelle? |
| Reproduzierbarkeit | Läuft `make gates` auf einem frischen Klon — und im CI — identisch durch? |
| Auditierbarkeit | Lässt sich jede relevante Änderung über eine Requirement-/ADR-ID zurückverfolgen? |
| Steering-Loop-Reife | Gibt es mindestens einen dokumentierten Failure → Guide/Sensor-Schritt? |

## Bewertungsraster (Rubric)

Pro Achse vier Stufen. Eine Stufe gilt, wenn *alle* Indikatoren erfüllt
sind. Lücke in einem Indikator → eine Stufe niedriger.

Zur Kalibrierung vor der Abgabe: drei kurze Beispielbewertungen stehen in
[`kalibrierungsbeispiele.md`](kalibrierungsbeispiele.md).

### Achse: Vollständigkeit

| Stufe | Indikatoren |
|---|---|
| **rudimentär** | Spec und Code vorhanden; ADR und Plan nur skizziert; kein Replay-Lauf. |
| **funktional** | Alle Artefakttypen vorhanden, aber nicht durchgängig verknüpft (Slice ohne ADR-Bezug, Replay ohne Golden Set). |
| **solide** | Alle Artefakte vorhanden und verknüpft; je mindestens ein abgeschlossener Slice in `done/`, eine ADR mit `Accepted`-Status, ein Replay-Lauf, ein Carveout. |
| **exzellent** | Zusätzlich: mindestens ein *Failure → Steering-Loop-Eintrag* dokumentiert; mindestens eine ADR `supersedes` eine frühere; mindestens ein Reviewer-Skill liegt unter `.harness/`. |

### Achse: Konsistenz

| Stufe | Indikatoren |
|---|---|
| **rudimentär** | Source Precedence existiert nur implizit; AGENTS.md widerspricht der Spec oder beschreibt nicht-existierende Tools. |
| **funktional** | Source Precedence dokumentiert; AGENTS.md ohne offene Widersprüche; aber `harness/README.md` nennt Befehle, die im Repo nicht existieren, oder dauerhaft rote Gates haben keinen Carveout-Eintrag in `docs/plan/carveouts/`. |
| **solide** | Source Precedence ist `harness/README.md` voran­gestellt; AGENTS.md beschreibt nur real existierende Konventionen; dauerhaft rote Gates sind als Carveouts dokumentiert (Modul 7) und in der Bindung-Spalte der Sensors-Tabelle per `CO-<NNN>`-ID verlinkt; `harness/conventions.md` existiert mit Baseline-Aussage (`MR-000`) und Modus-Deklaration pro Sub-Area. |
| **exzellent** | Zusätzlich: Doku-Konsistenz-Agent läuft als Drift-Sensor (Modul 15); Spec-Stratifizierung (Lastenheft/Spezifikation/Architektur) mit eigener Precedence ist umgesetzt; `harness/conventions.md` Adaptions-Block trägt mindestens eine bewusste `MR-<NNN>`-Adaption mit Praxis-Begründung und Auflösungs-Trigger (oder explizit als permanent markiert). |

### Achse: Reproduzierbarkeit

| Stufe | Indikatoren |
|---|---|
| **rudimentär** | `make gates` läuft nur auf der Maschine des Autors; Toolchain ist nicht gepinnt. |
| **funktional** | Multi-Stage-Dockerfile vorhanden, Toolchain pinned; aber Image-Hashes oder Lock-Files fehlen. |
| **solide** | `make gates` läuft auf einem frischen Klon *und* im CI mit identischem Image-Hash; Lock-Files committet; reproduzierbares Replay (Modellversion + Seed festgehalten). |
| **exzellent** | Zusätzlich: dokumentierte Drift-Erkennung über mindestens zwei Modellversionen am Replay (Wann hat sich was geändert?); Image-Hash im `harness/README.md` referenziert; bootstrap-aware Gates mit dokumentierter Hochschalt-Schwelle. |

> *Hinweis Pass-Through:* Image-Hash-Identität (Schwelle *solide*) wird erst in [Modul 14](../05-betrieb/modul-14-docker-harness.md) gelehrt. Wer Checkpoint D durchläuft, ohne Modul 14 absolviert zu haben, bleibt auf *funktional* gedeckelt — siehe [`../grundlagen/checkpoints.md`](../grundlagen/checkpoints.md#pass-through-logik-zum-abschlussprojekt).

### Achse: Auditierbarkeit

| Stufe | Indikatoren |
|---|---|
| **rudimentär** | Commits ohne Bezugs-IDs; ADRs ohne Verweis auf Lastenheft. |
| **funktional** | Konsistentes ID-Schema (`LH-*`, `ADR-*`, `SL-*`); IDs erscheinen in Commits *oder* in Make-Targets, aber nicht durchgängig. |
| **solide** | ID-Schema in allen Artefakten konsequent: Lastenheft, Spec, ADRs, Make-Target-Kommentare, Commit-Messages, PR-Beschreibungen; Traceability-Hook prüft Commits maschinell. |
| **exzellent** | Zusätzlich: mindestens *ein dokumentierter Fall*, in dem das Tool-Call-Audit-Log einen Pre-completion-Verstoß *retrospektiv* aufgedeckt hat — Eintrag enthält Trace-ID, betroffene Anforderungs-ID, die *aus dem Audit* gewonnene Erkenntnis und den daraus abgeleiteten Steering-Loop-Schritt. Tool-Call-Audit existiert nicht als Sammlung, sondern als forensischer Hebel mit Beleg. |

### Achse: Steering-Loop-Reife

| Stufe | Indikatoren |
|---|---|
| **rudimentär** | Kein dokumentierter Failure → Aktion. |
| **funktional** | Ein dokumentierter Failure mit *vorgeschlagener* Aktion, aber ohne umgesetzten Guide/Sensor. |
| **solide** | Mindestens ein Failure → Guide/Sensor-Schritt vollständig: Beobachtung beschrieben, Quadrant der 2×2-Matrix benannt, Guide oder Sensor implementiert, Wiederholung gemessen seltener. |
| **exzellent** | Zusätzlich: mindestens drei Steering-Loop-Iterationen über den Projektzeitraum; eine davon hat einen *bestehenden* Guide/Sensor verschärft, nicht nur einen neuen erzeugt; Reflexion nach [`grundlagen/reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md) für jeden Eintrag. |

## Bestanden

- Mindestens **solide** in *allen* fünf Achsen.
- Höchstens *eine* Achse darf bei **funktional** liegen, wenn die anderen vier **solide** oder **exzellent** sind — und dann nur, wenn die Lücke dokumentiert und mit einem Folge-Slice verknüpft ist.

Wer dreimal **rudimentär** oder zweimal **rudimentär + zweimal funktional**
abgibt, hat das Abschlussprojekt nicht bestanden — aber typischerweise
auch nicht die Phasen-Checkpoints geschafft. In dem Fall:
[`../grundlagen/checkpoints.md`](../grundlagen/checkpoints.md) als
Diagnose-Werkzeug nutzen, eine Phase identifizieren, dort vertiefen.

Eine Übersichts­tabelle, welche Abschluss-Achse welcher Phase entstammt,
steht im Abschnitt [Pass-Through-Logik zum
Abschlussprojekt](../grundlagen/checkpoints.md#pass-through-logik-zum-abschlussprojekt)
in `checkpoints.md`. Damit kann eine rudimentär-Bewertung gezielt einer
Phase zugeordnet werden, statt zur Pauschal-Wiederholung des ganzen
Kurses zu führen.

## Hinweise

* Beginne klein. Ein Repo, eine Repo-Klasse, drei Slices reichen.
* Schreibe `harness/README.md` als *eines der letzten* Artefakte, nicht als erstes — sonst dokumentierst du Wunschdenken statt Realität (siehe [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)).
* Lass dich nicht von der Modulanzahl täuschen: Das Abschlussprojekt verlangt Tiefe in *einem* Repo, nicht Breite über drei.
