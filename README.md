# KI-Agenten-Kurs: Harness Engineering für Coding Agents

Dieser Kurs vermittelt einen vollständigen, auditierbaren Entwicklungsprozess mit KI-Agenten — nicht primär, wie man einen KI-Agenten bedient, sondern wie man die Umgebung gestaltet, in der ein Agent reproduzierbar, überprüfbar und konsequent entlang einer Spezifikation arbeitet.

**Harness Engineering** umfasst alles am Agentensystem außer dem Modell selbst.
Der Kurs konkretisiert diesen Rahmen durch Spezifikationen, ADRs, Slice-Pläne, Werkzeuge, Quality Gates, Telemetrie und Betriebsregeln.
**Guides und Sensors** klassifizieren die Kontrollen in einer 2×2-Matrix (Feedforward/Feedback × Computational/Inferential).
**Context Engineering**, **Architectural Constraints** und **Entropy Management** strukturieren die tägliche Harness-Arbeit.
Herkunft und Verbindung dieser Ansätze erläutert die [Einordnung der Quellen](#einordnung-der-quellen).

**Source Precedence**, **AGENTS.md** und `harness/README.md` bilden die konkreten Artefakte, mit denen diese Konzepte in einem Repository verankert werden.

---

## Schnellstart

* **Kurs absolvieren:** [Kursübersicht und Voraussetzungscheck](kurs/de/README.md)
* **Regelwerk nachschlagen:** [Betriebsregelwerk für Code-Agenten](lab/regelwerk/README.md)
* **Regelwerk und Templates ohne Installation ins eigene Repo holen:** [Baseline Bundle](#baseline-bundle)
* **Ein Repo komplett aufsetzen, Gates inklusive:** [`ai-harness-init`](#automatisierter-bootstrap)

---

## Zielgruppe

Der Kurs richtet sich an Softwareentwickler, Softwarearchitekten, Tech Leads, DevOps-Engineers sowie KI-Plattform-Teams, die KI-Agenten nicht als Demonstrationstechnologie, sondern als Bestandteil eines reproduzierbaren und überprüfbaren Softwareentwicklungsprozesses einsetzen möchten.

Du solltest Grundlagen in folgenden Bereichen mitbringen:

* Git (Branch, Commit, Pull Request, `git log --follow`)
* Docker (Image-Build, Multi-Stage-Builds, Docker Compose)
* Softwarearchitektur und mindestens eine Programmiersprache
* Grundverständnis von LLMs als Black Box (Prompt → Ausgabe)
* Lesen eines LLM-Tool-Call-Traces (Input · Tool-Call · Tool-Result · Output)
* Akzeptanzkriterien im Given/When/Then-Stil
* Unterschiede zwischen Linter, Typecheck und Integrationstest

Mit dem [Voraussetzungscheck](kurs/de/README.md#voraussetzungscheck) kannst du prüfen, welche Grundlagen du vor welchem Kursabschnitt auffrischen solltest.
Begriffe wie **Fitness Function**, **ADR**, **AGENTS.md**, **Replay** oder **Golden Set** werden im Kurs als Arbeitswerkzeuge eingeführt; entsprechendes Vorwissen ist nicht erforderlich.

---

## Lernziele

Nach Abschluss des Kurses kannst du

* Spezifikationen, ADRs und Slice-Pläne so formulieren, dass ein KI-Agent sie buchstabengetreu umsetzt, anstatt das Naheliegende zu halluzinieren,
* die sechs im Kurs verwendeten Agentenrollen (Planner, Architect, Implementation, Reviewer, Verification und Validation) klar voneinander trennen und ihre Übergaben definieren,
* reproduzierbare Quality Gates als `make`-Ziele entwickeln, die lokal und im CI identisch ausgeführt werden,
* Replay-Läufe mit Golden Sets durchführen, Regressionen messen und Modell-Drift erkennen,
* den Harness gegen Entropie pflegen, etwa durch das Entfernen veralteter Dokumentation, toter Constraints und wuchernder Carveouts,
* ein Repository so strukturieren, dass Incident Response und Weiterentwicklung unabhängig vom ursprünglichen Autor möglich bleiben.

---

## Kursinhalt

Der eigentliche Kurs befindet sich unter [`kurs/de/`](kurs/de/README.md) und gliedert sich in 17 Module (0–16) sowie Grundlagen- und Abschlussabschnitte.
Der vollständige Inhaltsindex, der Voraussetzungscheck und die Lernfortschrittsübersicht befinden sich in der [Kursübersicht](kurs/de/README.md).

Die Module sind in Entwicklungsphasen gegliedert:

| Phase | Module | Schwerpunkt |
| --- | --- | --- |
| [Grundlagen](kurs/de/grundlagen/) | — | Begriffe, Klassifikation, vier reale Fallstudien |
| [00 Einführung](kurs/de/00-einfuehrung/) | 0 | Agent · LLM · Harness |
| [01 Spezifikation und Architektur](kurs/de/01-spec-und-architektur/) | 1–4 | Lebenszyklus · Harness-Bootstrap · Lastenheft · ADRs |
| [02 Planung](kurs/de/02-planung/) | 5–7 | Slice-Lifecycle · Roadmap · Carveouts |
| [03 Agenten](kurs/de/03-agenten/) | 8–9 | Rollen · Implementation-Agent |
| [04 Qualität](kurs/de/04-qualitaet/) | 10–13 | Review · Verification · Replay · Quality Gates |
| [05 Betrieb](kurs/de/05-betrieb/) | 14–16 | Docker · Observability · Produktion |
| [Abschluss](kurs/de/abschluss/) | — | Abschlussprojekt · Quellen |

---

## Betriebsregelwerk

Für Code-Agenten steht der Kurs zusätzlich als Betriebsregelwerk unter [`lab/regelwerk/`](lab/regelwerk/README.md) zur Verfügung.

Das Regelwerk ist der didaktikfreie Extrakt des Kurses: Konventionen, Regeln und Abläufe in Quellformulierung, weggelassen ist die Didaktik-Schicht.
Für jedes Modul sowie jeden Grundlagenabschnitt existiert eine Regelwerksdatei.
Das Regelwerk ist derivativ — bei Konflikt gilt das Kursmaterial.

Die Überarbeitungs-Wellen des Kurses registriert das [`CHANGELOG.md`](CHANGELOG.md); was **offen** ist und woran man erkennt, dass es dran ist, steht in [`docs/roadmap.md`](docs/roadmap.md).

---

## Internationale Version

Ein Verzeichnis `kurs/en/` ist als Skelett vorhanden, enthält derzeit jedoch noch keine Inhalte.
Eine englische Ausgabe mit demselben Aufbau wie die deutsche Version ist vorgesehen, momentan jedoch *nicht* Bestandteil des Kurses.
Der Bearbeitungsstand wird gemeinsam mit den übrigen offenen Fäden in der [`docs/roadmap.md`](docs/roadmap.md) geführt.

---

## Den Prozess im eigenen Repository übernehmen

Der Kurs dient nicht nur als Lernmaterial.
Sein Entwicklungsprozess lässt sich in ein beliebiges Repository übernehmen — auf zwei Wegen, die **unterschiedlich weit führen**:

| | [Baseline Bundle](#baseline-bundle) | [`ai-harness-init`](#automatisierter-bootstrap) |
| --- | --- | --- |
| Voraussetzung | keine (ZIP herunterladen) | Docker, git, GNU `make`; einmalig Netz |
| Ergebnis | Regelwerk und Templates im Repo | eingerichtetes Repo, `make gates` läuft grün |
| Artefakte füllen | von Hand aus den Templates | von Hand aus den erzeugten Skeletten |
| Sprach-Grundgerüst | — | optional, wahlweise flach oder geschichtet |
| Gates | — | eingerichtet und lauffähig |

Das Bundle ist das installationsfreie Minimum: Regeln und Vorlagen zum Nachschlagen und Kopieren.
Das CLI setzt darauf auf und richtet zusätzlich das ein, was von Hand mechanisch und fehleranfällig ist — vor allem die Gates.

### Baseline Bundle

Für die manuelle Adoption enthält das Baseline Bundle:

* das Betriebsregelwerk (`regelwerk/`) — pro Modul und Grundlagenabschnitt eine Datei,
* Templates (`templates/`) für Lastenhefte, Spezifikationen, ADRs, Slice-Pläne und weitere Dokumente.

Das Bundle steht als [ZIP-Archiv](https://github.com/pt9912/ai-harness-course/releases/latest/download/lab-regelwerk.zip) ohne GitHub-Anmeldung bereit; interne Verweise sind auf den Release-Tag gepinnt.

Empfohlen wird, das Archiv nach

```text
.harness/baseline/<tag>/
```

zu entpacken und den verwendeten Release-Tag im Ziel-Repository zu dokumentieren.
`regelwerk/` und `templates/` liegen im Bundle parallel — genau wie `lab/regelwerk/` und `lab/templates/` im Kurs-Repository.
Dadurch lösen die Ziel-Form-Verweise des Regelwerks auf die parallel vendorten Templates ohne Netzwerkzugriff auf.

Für die manuelle Verwendung:

1. Den passenden Abschnitt im vendorten Regelwerk lesen.
2. Das benötigte Template aus `templates/` in den vorgesehenen Zielpfad kopieren.
3. Alle `<Platzhalter>` ersetzen.
4. Den Template-Hinweisblock und erklärende HTML-Kommentare entfernen; `<!-- d-check:ignore … -->`-Marker bleiben erhalten.
5. Das Ergebnis mit dem entsprechenden Artefakt unter `lab/example/` vergleichen.

Die vollständige Anleitung einschließlich der unterschiedlichen Lebenszyklen einmaliger und wiederkehrender Templates steht in [`lab/templates/README.md`](lab/templates/README.md) §Verwendung.

### Automatisierter Bootstrap

Das CLI [`ai-harness-init`](https://github.com/pt9912/ai-harness-init) richtet ein bestehendes Verzeichnis in einem Aufruf so ein, dass es dem Prozess folgt:

```bash
ai-harness-init --lang go --name "Mein Projekt"
```

Danach steht im Repo das vendorte Regelwerk unter `.harness/baseline/`, dazu Prozess-Regeln, Dokumentvorlagen, eingerichtete Gates und — mit `--lang` — ein lauffähiges Sprach-Grundgerüst.
`make gates` läuft dort **out of the box grün**, ohne Nacharbeit.
Ohne `--lang` entsteht ein rein dokumentgeführtes Repo.

Weitere Sprachmodule kommen wiederholbar dazu, auch gemischt — mehrere Aufrufe ergeben ein Mono-Repo:

```bash
ai-harness-init add-lang go apps/api
```

`--arch hexslice` erzeugt statt des flachen Layouts ein geschichtetes und bringt das Architektur-Gate mit; `--arch flat` ist der Default.
Welche Sprachen und Bauformen das Werkzeug beherrscht, wächst mit seinen Releases — die jeweils gültige Liste steht im Benutzerhandbuch.

Ein zweiter Lauf ist **idempotent**: das Werkzeug frischt seine eigenen Dateien auf und zieht ein neueres Regelwerk nach, lässt selbst gefüllte Dateien — Dokumente, `README.md`, Quellcode — aber unberührt.
Kein `--force`, kein Abbruch bei vorhandenen Dateien.

Das CLI ist ein **eigenständiges Projekt** (MIT) und nicht Bestandteil des Kurses.
Es braucht Docker, git und GNU `make` sowie beim ersten Lauf einmal Netz — danach arbeitet das Ziel-Repo netzunabhängig; eine Go-Installation ist nicht nötig.
Fertige Programme für die gängigen Plattformen und die Änderungshistorie stehen bei den [Releases des CLI-Projekts](https://github.com/pt9912/ai-harness-init/releases), die Schritt-für-Schritt-Anleitung im [Benutzerhandbuch](https://github.com/pt9912/ai-harness-init/blob/main/docs/user/benutzerhandbuch.md).

Wer verstehen will, *was* dabei entsteht und welche Entscheidungen dahinter stehen, liest [Modul 2 – Harness Bootstrap](kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md).
Das Werkzeug nimmt die Handgriffe ab, nicht die Entscheidungen.

---

## Einstiegspunkt für Code-Agenten

Nach der Adoption beginnt jeder Code-Agent bei der `AGENTS.md` des jeweiligen Repositories.
Sie trägt die repo-weiten Hard Rules und die Source Precedence und verweist auf das vendorte Regelwerk sowie die relevanten Templates.
Für Guides, Sensors, Traceability und Safety führt sie den Agenten weiter zur `harness/README.md`.
Dadurch kann sich ein Agent bootstrappen, ohne diesen Kurs zu kennen.

---

## Einordnung der Quellen

Der Kurs verbindet mehrere veröffentlichte Ansätze zu einem konsistenten Entwicklungsprozess:

* **Birgitta Böckeler** beschreibt in [*Harness Engineering for Coding Agents*](https://martinfowler.com/articles/harness-engineering.html) Harness Engineering sowie die Klassifikation von Guides und Sensors anhand der 2×2-Matrix (Feedforward/Feedback × Computational/Inferential).
* **Ryan Lopopolo** beschreibt im OpenAI-Beitrag [*Harness Engineering: Leveraging Codex in an Agent-First World*](https://openai.com/index/harness-engineering/) Context Engineering, Architectural Constraints und Entropy Management als operative Arbeitsschwerpunkte.
* Die konkrete Struktur des Kurses — insbesondere die Verbindung dieser Konzepte mit den sechs Agentenrollen und der Source Precedence — ist eine eigenständige didaktische und organisatorische Ausarbeitung.

Weitere fachliche und didaktische Belege stehen im [Quellenverzeichnis](kurs/de/abschluss/quellen.md).

---

## Lizenz

Dual-lizenziert: Markdown-Inhalte, Bilder und Diagramme unter **CC BY 4.0**, Code (Skripte, Lab, Makefile, Dockerfile, etc.) unter **MIT**.
Details und empfohlene Namensnennung: [`LICENSE.md`](LICENSE.md).
