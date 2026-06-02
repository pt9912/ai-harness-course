# Abschlussprojekt — AI Harness Platform

## Features

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
| **funktional** | Source Precedence dokumentiert; AGENTS.md ohne offene Widersprüche; aber `harness/README.md` nennt Befehle, die im Repo nicht oder rot existieren. |
| **solide** | Source Precedence ist `harness/README.md` voran­gestellt; AGENTS.md beschreibt nur real existierende Konventionen; rot laufende Gates sind *dokumentiert*, nicht versteckt. |
| **exzellent** | Zusätzlich: Doku-Konsistenz-Agent läuft als Drift-Sensor (Modul 14); Spec-Stratifizierung (Lastenheft/Spezifikation/Architektur) mit eigener Precedence ist umgesetzt. |

### Achse: Reproduzierbarkeit

| Stufe | Indikatoren |
|---|---|
| **rudimentär** | `make gates` läuft nur auf der Maschine des Autors; Toolchain ist nicht gepinnt. |
| **funktional** | Multi-Stage-Dockerfile vorhanden, Toolchain pinned; aber Image-Hashes oder Lock-Files fehlen. |
| **solide** | `make gates` läuft auf einem frischen Klon *und* im CI mit identischem Image-Hash; Lock-Files committet; reproduzierbares Replay (Modellversion + Seed festgehalten). |
| **exzellent** | Zusätzlich: Image-Hash im `harness/README.md` referenziert; bootstrap-aware Gates mit dokumentierter Hochschalt-Schwelle; Cache-Hit-Rate als Metrik. |

### Achse: Auditierbarkeit

| Stufe | Indikatoren |
|---|---|
| **rudimentär** | Commits ohne Bezugs-IDs; ADRs ohne Verweis auf Lastenheft. |
| **funktional** | Konsistentes ID-Schema (`LH-*`, `ADR-*`, `SL-*`); IDs erscheinen in Commits *oder* in Make-Targets, aber nicht durchgängig. |
| **solide** | ID-Schema in allen Artefakten konsequent: Lastenheft, Spec, ADRs, Make-Target-Kommentare, Commit-Messages, PR-Beschreibungen; Traceability-Hook prüft Commits maschinell. |
| **exzellent** | Zusätzlich: Tool-Call-Audit-Log pro Agentenlauf; jede Änderung lässt sich vom Trace bis zur Anforderungs-ID zurückverfolgen. |

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

## Hinweise

* Beginne klein. Ein Repo, eine Repo-Klasse, drei Slices reichen.
* Schreibe `harness/README.md` als *eines der letzten* Artefakte, nicht als erstes — sonst dokumentierst du Wunschdenken statt Realität (siehe [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)).
* Lass dich nicht von der Modulanzahl täuschen: Das Abschlussprojekt verlangt Tiefe in *einem* Repo, nicht Breite über drei.
