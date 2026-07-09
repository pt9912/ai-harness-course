# Konzeptkarte

Diese Karte reduziert den Kurs auf die Beziehungen, die du beim Lernen
immer wieder brauchst. Wenn ein Modul unuebersichtlich wirkt, ordne es
zuerst hier ein.

## Artefaktkette

```text
Lastenheft -> Spezifikation -> Architektur -> ADR -> Slice -> Code
      -> Review -> Verifikation -> Replay/Gates -> Betrieb
```

Diese Kette ist der Lebenszyklus (engl. *SDLC*) dieses Kurses.

Lesart:

- **Lastenheft/Spezifikation** sagen, *was* gelten muss.
- **Architektur/ADR** sagen, *warum* eine Loesung so gebaut wird.
- **Slice** sagt, *welcher kleine Teil* jetzt umgesetzt wird.
- **Code** ist nur ein Artefakt in der Kette, nicht der Startpunkt.
- **Review/Verifikation** pruefen unterschiedliche Fragen:
  Review fragt "ist der Diff riskant?", Verifikation fragt "erfuellt der
  Diff Plan und DoD?"
- **Replay/Gates** machen Aussagen wiederholbar.
- **Betrieb** verlangt Belege, damit ein anderer Mensch nachts handeln
  kann.

Die 17 Module (0-16) sind entlang der Kette organisiert:

| Lebenszyklus-Station | Modul-Block | Harness / Schwerpunkt |
|---|---|---|
| Spec -> ADR | `01-spec-und-architektur/` (Mod. 1-4) | Lastenheft-, Architektur-/ADR-Disziplin, Harness-Bootstrap |
| Plan | `02-planung/` (Mod. 5-7) | Planning-Harness, Roadmap, Carveouts |
| Code | `03-agenten/` (Mod. 8-9) | Rollen + 8-Schritt-Workflow |
| Review -> Verifikation | `04-qualitaet/` (Mod. 10-13) | Review-, Verification-Harness, Replay, Quality Gates |
| Closure -> Betrieb | `05-betrieb/` (Mod. 14-16) | Docker-Harness, Observability, Produktion |

## Vier wiederkehrende Fragen

| Frage | Primaere Artefakte | Typische Module |
|---|---|---|
| Was soll gelten? | Lastenheft, Spezifikation | 3 |
| Warum gilt diese Loesung? | ADR, Architektur | 4 |
| Wie klein ist die naechste Aenderung? | Slice, Roadmap, Carveout | 5, 6, 7 |
| Woran erkenne ich, dass es stimmt? | Review, Verify, Replay, Gates, Trace | 10, 11, 12, 13, 15 |

## 2x2-Schnellanker

Vier Merksätze, einer pro Quadrant — die Vollform der Matrix mit
Werkzeug-Listen, Quadrant-Chart und Faustregel "so weit links und oben
wie möglich" steht **einmal** in
[`klassifikation.md`](klassifikation.md) im ersten Abschnitt. Hier
nur der Anker für den Schnellzugriff:

| Quadrant | Merksatz |
|---|---|
| inferential feedforward | Agent **vor** der Handlung informieren (Spec, ADR, AGENTS.md). |
| computational feedforward | Falsche Handlung **technisch erschweren** (Typen, Schemas, Tool-Allowlist). |
| computational feedback | Falsche Handlung **deterministisch erkennen** (Linter, Tests, ArchUnit). |
| inferential feedback | **Semantisch nachprüfen**, wo Gates nicht reichen (Reviewer, Verifier, Validator). |

Faustregel beim Lesen eines Moduls: erst Quadrant identifizieren, dann
zur Volltabelle in `klassifikation.md` springen, wenn du die konkrete
Werkzeug-Familie brauchst.

## Wann zurueckspringen?

Wenn du in einer Uebung haengenbleibst, spring nicht zum naechsten
Modul. Spring zu dem fehlenden Artefakt:

- Kein klares Expected Result -> zur Spec.
- Architekturstreit -> zur ADR.
- Diff zu gross -> zum Slice-Schnitt.
- Tests gruen, aber DoD unklar -> zur Verifikation.
- Replay gruen, Produktion rot -> zum Golden Set und zur
  Reflexionsvorlage.
