# KI-Agenten-Kurs: Harness Engineering für Coding Agents

Dieser Kurs lehrt einen **vollständigen, auditierbaren
Entwicklungsprozess mit KI-Agenten** — nicht "wie man einen KI-Agenten
benutzt", sondern wie man die Umgebung baut, in der ein Agent
reproduzierbar, prüfbar und entlang einer Spec arbeitet:

1. **Harness Engineering** ist alles am KI-System außer dem Modell selbst — Spec, ADRs, Plan, Tools, Gates, Telemetrie.
2. **Guides und Sensors** klassifizieren jede Kontrolle nach Böckelers 2×2 (Feedforward/Feedback × Computational/Inferential).
3. **Context Engineering, Architectural Constraints, Entropy Management** sind die drei Säulen, die die tägliche Harness-Arbeit strukturieren (Lopopolo/OpenAI).
4. **Source Precedence, AGENTS.md, `harness/README.md`** sind die konkreten Artefakte, mit denen das im Repo landet.

## Zielgruppe

Der Kurs richtet sich an Softwareentwickler, Architekten, Tech Leads,
DevOps-Engineers und KI-Plattform-Teams, die KI-Agenten nicht im
Demo-Modus, sondern in einem prüfbaren Lieferprozess betreiben wollen.

Konkret solltest du vor dem Kurs sicher sein in:

- Git (Branch, Commit, PR, `git log --follow`),
- Docker (Image bauen, Multi-Stage, Compose),
- Lesen eines LLM-Tool-Call-Traces (Input · Tool-Call · Tool-Result · Output),
- Akzeptanzkriterien im Given/When/Then-Stil,
- Grundunterschied zwischen Linter, Typecheck und Integrationstest.

Begriffe wie *Fitness Function*, *ADR*, *AGENTS.md*, *Replay*, *Golden Set*
werden im Kurs als Werkzeugbegriffe eingeführt; Vorwissen dazu ist nicht
nötig.

## Lernziele

Nach dem Kurs kannst du:

- Spec, ADRs und Slice-Pläne so schreiben, dass ein KI-Agent sie
  buchstabengetreu umsetzt — und nicht das Naheliegende halluziniert,
- die sechs Agentenrollen (Planner, Architect, Implementation, Reviewer,
  Verification, Validation) sauber trennen und ihre Übergaben entwerfen,
- Quality Gates als reproduzierbare `make`-Ziele aufsetzen, die lokal
  und im CI identisch laufen,
- Replay-Läufe mit Golden Sets fahren, Regressionen messen und Modell-Drift
  erkennen,
- den Harness gegen Entropie aktiv pflegen (Doku-Drift, tote Constraints,
  Carveout-Wildwuchs),
- ein Repo so für den produktiven Betrieb freigeben, dass Incident
  Response in der Nacht möglich ist, ohne den Autor zu kennen.

## Kursinhalt

Der eigentliche Kurs liegt unter [`kurs/de/`](kurs/de/README.md) und ist
in 17 Module (0–16) plus Grundlagen- und Abschluss-Sektionen
unterteilt. Den vollständigen Inhaltsindex, den Voraussetzungscheck und
die Lernfortschritts-Tabelle findest du in der
[Kurs-Übersicht](kurs/de/README.md).

Die Module sind nach Phasen gruppiert:

| Phase | Module | Schwerpunkt |
|---|---|---|
| [Grundlagen](kurs/de/grundlagen/) | — | Begriffe, Klassifikation, vier reale Fallstudien |
| [00 Einführung](kurs/de/00-einfuehrung/) | 0 | Agent · LLM · Harness |
| [01 Spec und Architektur](kurs/de/01-spec-und-architektur/) | 1–4 | Lebenszyklus · Harness-Bootstrap · Lastenheft · ADRs |
| [02 Planung](kurs/de/02-planung/) | 5–7 | Slice-Lifecycle · Roadmap · Carveouts |
| [03 Agenten](kurs/de/03-agenten/) | 8–9 | Rollen · Implementation-Agent |
| [04 Qualität](kurs/de/04-qualitaet/) | 10–13 | Review · Verifikation · Replay · Gates |
| [05 Betrieb](kurs/de/05-betrieb/) | 14–16 | Docker · Observability · Produktion |
| [Abschluss](kurs/de/abschluss/) | — | Abschlussprojekt · Quellen |

Für **Code-Agenten** gibt es den Kurs zusätzlich als destilliertes
Betriebsregelwerk: [`kurs/de/agents-digest.md`](kurs/de/agents-digest.md)
— Konventionen und Workflows ohne Didaktik-Schicht, derivativ (bei
Konflikt gilt das Kursmaterial). Die Überarbeitungs-Wellen des Kurses
registriert das [`CHANGELOG.md`](CHANGELOG.md).

> **Roadmap-Hinweis.** `kurs/en/` ist als Skelett angelegt, aber noch
> nicht inhaltlich befüllt. Eine englische Übersetzung folgt demselben
> Aufbau, ist aber derzeit *nicht* Bestandteil des Kurses.

## Lizenz

Dual-lizenziert: Markdown-Inhalte, Bilder und Diagramme unter
**CC BY 4.0**, Code (Skripte, Lab, Makefile, Dockerfile, etc.) unter
**MIT**. Details und empfohlene Namensnennung: [`LICENSE.md`](LICENSE.md).
