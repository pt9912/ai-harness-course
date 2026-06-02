# Modul 9 — Review Harness

> **Aufwand:** ca. 75 Min Lesen · 90 Min Übung.

## Engage

Reviewer-Agent meldet *17 Findings*. Implementer fängt mit dem ersten an
und steckt zwei Stunden im trivialen Tippfehler fest. Vier HIGH-Findings
weiter unten gehen unter. *Was war die eigentliche Frage?* Nicht "wie viele",
sondern *welche Kategorie zuerst*. Ohne Kategorisierung ist eine
Findings-Liste eine Mängelliste — mit Kategorisierung wird sie zur
Entscheidungsvorlage.

## Lernziele

Nach diesem Modul kannst du:

* Findings nach HIGH/MEDIUM/LOW/INFO *klassifizieren*, Plan-/Design-/Code-Reviews voneinander *unterscheiden* und Grenzfälle (LOW↔HIGH-Wanderung) *bewerten* (Bewerten · konzeptuell),
* einen Reviewer-Lauf so *einrichten*, dass er reproduzierbar wird (gleiche Eingabe → ähnliche Findings) (Anwenden · prozedural),
* einen Konflikt zwischen zwei Reviewer-Läufen (selbes Finding, unterschiedliche Kategorie) *diagnostizieren* (Analysieren · prozedural),
* einen Reviewer-Skill für ein konkretes Repo *schreiben*, der die Klassifikation HIGH/MEDIUM/LOW/INFO mit repo-spezifischen Anker-Regeln durchsetzt (Erschaffen · prozedural).

## Lab-Bezug

* [`../../../lab/example/Makefile`](../../../lab/example/Makefile), Target `make agent-review`
* fingierter "kaputter" Slice in
  [`../../../lab/example/exercises/09-review-fixture/`](../../../lab/example/exercises/09-review-fixture/)

## Themen

* Plan Reviews
* Design Reviews
* Code Reviews
* Findings und ihre Kategorien

## Finding-Kategorien

| Kategorie | Bedeutung |
|---|---|
| HIGH | blockiert Merge: Sicherheits-, Korrektheits- oder ADR-Verstoß |
| MEDIUM | sollte vor Merge geklärt werden |
| LOW | nice-to-fix, blockiert nicht |
| INFO | Hinweis, keine Aktion erwartet |

## Harness-Einordnung

Review = *inferential feedback* (siehe
[`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)).
Teurer als ein Linter, billiger als Verifikation. Adressiert primär die
Maintainability-Kategorie.

## Kernidee

Ein Review ohne Kategorisierung ist eine Mängelliste. Ein Review mit
Kategorisierung ist eine Entscheidungsvorlage.

## Worked Example: eine Reviewer-Skill-Datei schreiben

> **Wenn du Reviewer-Skills bereits versioniert pflegst und HIGH/MEDIUM/LOW/INFO repo-spezifisch verankerst, springe zu [§Übungen](#übungen).** Die sechs Schritte unten sind die Schablone für den ersten oder zweiten Skill; ab dem dritten kostet sie eher Last als sie gibt (Expertise-Reversal).

Ein Reviewer-Agent ohne Skill-Datei driftet zwischen Sessions. Dieselbe
Eingabe → unterschiedliche Findings, unterschiedliche Kategorien.
Skill-Dateien leben in `.harness/` und sind das Repo-spezifische
"worauf achtest du" eines Agenten.

**Schritt 1 — Pfad und Kopf:**

```
.harness/skills/reviewer.md
```

```markdown
# Reviewer-Skill — DocSearch

* Status: Accepted
* Bezug: ADR-0007, AGENTS.md §"Review-Regeln"
* Gilt für: `agent-review`-Make-Target
```

**Schritt 2 — Eingangs-Kontext explizit machen.** Was der Reviewer
*immer* mitbringt, bevor er den Diff liest:

```markdown
## Kontext-Eingang (Pflicht)

- Diff des PR
- `spec/lastenheft.md` (für referenzierte LH-IDs)
- ADRs, deren ID im PR oder Commit-Message vorkommt
- AGENTS.md §"Hard Rules"
- vorherige Findings am gleichen Modul (letzte 5 PRs)
```

Ohne diesen Block sieht der Reviewer den Code, aber nicht *die Verträge,
gegen die er prüft*. Genau das war der Grund für die Konsistenz-Drift in
unserem Engage-Beispiel.

**Schritt 3 — Kategorien-Regeln *für dieses Repo*.** Nicht generisch,
sondern konkret:

```markdown
## Klassifikation

**HIGH** — eines der folgenden:
- ADR-Verstoß (Layer, Tool, Hard Rule)
- Sicherheits-Anti-Pattern (Injection, fehlende Auth-Prüfung)
- Korrektheitsfehler im *kritischen* Pfad (Index-Schreiben, Auth)
- Suppression eines Gates (#noqa, //nolint, [SuppressMessage]) ohne ADR

**MEDIUM** — eines der folgenden:
- unklare Fehlerbehandlung am Rand des Spec-Bereichs
- fehlende Negativtests bei neuem öffentlichen Vertrag
- Wiederholung eines Musters, das schon zweimal LOW war

**LOW** — stilistisch unschön ohne semantische Auswirkung,
einmalige Tippfehler, unbenutzte Imports.

**INFO** — Hinweis ohne erwartete Aktion (z. B. "diese Stelle hat
ein passendes ArchUnit-Pendant, das du nicht kennst").
```

Beachte: drei Kategorien-Anker (HIGH/MEDIUM/LOW) haben *jeweils* eine
konkrete Liste. INFO ist bewusst kurz — INFO ist Ergänzungs-Kanal, nicht
Hauptkanal.

**Schritt 4 — Anti-Pattern und "Was bist du nicht".** Verhindert, dass
der Reviewer zum zweiten Implementer wird:

```markdown
## Was dieser Skill NICHT macht

- Keine Lösungsvorschläge ("schreib das so") — Reviewer kategorisiert,
  Implementer entscheidet.
- Kein Refactoring-Vorschlag, der über den Diff hinausgeht.
- Keine Verifikation gegen DoD — das ist Verifier-Aufgabe (Modul 10).
- Keine Validation gegen reale Bedürfnisse — das ist Validator-Aufgabe.

Wenn etwas auffällt, das in diese Kategorien gehört, ein INFO-Finding
mit Verweis auf die zuständige Rolle.
```

**Schritt 5 — Output-Schema fixieren.** Findings sind strukturiert, nicht
Fließtext:

```markdown
## Output-Schema

Jedes Finding:

- `kategorie`: HIGH | MEDIUM | LOW | INFO
- `quelle`: ADR-ID, LH-ID, Hard-Rule-Name oder "Maintainability"
- `pfad`: Datei:Zeile
- `befund`: 1–2 Sätze, beobachtbar, ohne Lösungsvorschlag
- `verifizierbar`: ja/nein — gibt es einen Gate-Lauf, der es bestätigen würde?

Zusätzlich am Ende: eine Zeile "geprüft, ohne Befund" pro betrachtetem
Verzeichnis (Negativbefund-Zeile — siehe Modul 9 §"Reviewer berichtet
auch, was er nicht gefunden hat").
```

**Schritt 6 — Steering-Loop-Eintrag.** Skills sind nicht statisch:

```markdown
## Pflege

Bei dreimaligem Auftreten desselben Findings:
- ist die Kategorie noch richtig? → Klassifikation schärfen
- gibt es einen ADR/AGENTS.md-Eintrag, der das verhindert hätte?
  → Folge-ADR oder AGENTS.md-Update
- gibt es eine Fitness Function, die das prüfen würde?
  → Modul 12, Gate hinzufügen

Skill-Datei selbst wird **nicht** überschrieben, sondern versioniert
(siehe ADR-Hard-Rule, Modul 3).
```

Sechs Schritte, eine reproduzierbare Reviewer-Rolle. Vergleichbares
Skill-Pattern für *Verifier* und *Validator* in Modul 10 bzw. in
[Modul 7 §"Konfliktfall"](../03-agenten/modul-07-agentenrollen.md).

## Typische Fehlvorstellungen

- **"Reviewer ist ein zweiter Implementer."** — Reviewer kategorisiert. Vorschläge "wie ich es geschrieben hätte" sind nett, aber kein Reviewer-Ergebnis.
- **"Findings ohne Prioritätssortierung."** — Implementer arbeitet sequentiell ab und bleibt am LOW hängen. HIGH zuerst, immer.
- **"Reviewer-Agent läuft ohne Skill-Datei."** — Verhalten driftet zwischen Sessions. Jeder Reviewer-Agent braucht eine Skill-Datei in `.harness/` mit "worauf achtest du in diesem Repo".
- **"Wenn der Reviewer-Agent dasselbe zweimal anders kategorisiert, nehmen wir die mildere."** — Genau das belohnt Inkonsistenz. Stattdessen: Skill schärfen, bis die Klassifikation reproduzierbar ist.

## Übungen

* Review realer Änderungen im Begleit-Repo
* Reviewe den fingierten kaputten Slice — finde die drei eingebauten Fehler

## Reflexion

Vier Standardfragen aus [`../grundlagen/reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md)
nach dem Review-Lauf gegen den kaputten Slice und der Reviewer-Skill-
Schreibübung. Modul-spezifische Trigger:

- **Beobachtung:** Welche Kategorie hat der Reviewer-Agent vergeben? Welches Finding hast du erwartet, aber nicht bekommen? Welches Finding kam, das du nicht erwartet hast?
- **2×2-Quadrant:** Reviewer ist *inferential feedback*; Klassifikations-Drift ist meist Lücke in der Skill-Datei.
- **Steering-Loop:** Skill-Anker schärfen (HIGH-Liste konkreter)? Eingangs-Kontext-Pflicht erweitern? Negativbefund-Zeile erzwingen?
- **Conceptual Change:** Kandidaten in [`../grundlagen/lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "Reviewer ist ein zweiter Implementer", "Wenn der Reviewer-Agent zweimal anders kategorisiert, nehmen wir die mildere").

## Selbstcheck

* **(Erinnern)** Welche vier Finding-Kategorien gibt es, und welche zwei davon blockieren typischerweise den Merge?
* Wann wird aus einem LOW-Finding ein HIGH-Finding?
* Was tust du, wenn der Reviewer-Agent dasselbe Finding zweimal mit unterschiedlicher Kategorie meldet?
* **(Anwenden)** Du erhältst 17 Findings auf einen PR. Beschreibe deine ersten drei Aktionen — in dieser Reihenfolge.

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Vier Finding-Kategorien + welche blockieren? | drei genannt, ohne Blocker-Trennung | HIGH (blockiert Merge: Sicherheit, Korrektheit, ADR-Verstoß) · MEDIUM (sollte vor Merge geklärt sein, blockiert formal nicht immer) · LOW (nice-to-fix) · INFO (Hinweis, keine Aktion). HIGH ist der harte Blocker; MEDIUM ist Soll-Blocker. | + Trennlinie LOW/MEDIUM ist im Reviewer-Skill *repo-spezifisch* zu fixieren; ohne wandert dieselbe Beobachtung zwischen Läufen — das ist der Hauptgrund, warum Reviewer-Konsistenz ohne Skill-Datei bricht. |
| Wann LOW → HIGH? | "Wenn es wichtig wird." | Vier Trigger: Geltungsbereich erweitert (z. B. Sicherheits-Check-Pfad), Wiederholungs-Muster (3×), externe Wirkung (Compliance), Slice geht in Produktion. | + Hinweis: Wenn Reviewer/Implementer über die Kategorie streiten, ist die Klassifikations-Regel im Reviewer-Skill zu vage — das ist ein Steering-Loop-Signal, kein Reviewer-Fehler. |
| Reviewer meldet dasselbe Finding zweimal anders kategorisiert? | "Die strengere nehmen." | Beide ernstnehmen → Differenz erklären (Kontext-Unterschied?) → Reviewer-Skill schärfen, nicht mildere/strengere Antwort auswählen. | + Anti-Antwort "Agent hat sich selbst korrigiert" — das belohnt Inkonsistenz; mildere Antwort als Wahrheit zu akzeptieren ist *Reward Hacking* der Klassifikations-Disziplin. |
| 17 Findings — erste drei Aktionen? | sequentiell abarbeiten | (1) Nach Kategorie sortieren, HIGH zuerst lesen · (2) HIGH-Findings prüfen: ADR-Verstoß / Sicherheit / Korrektheit? gegen Plan oder gegen Spec? · (3) MEDIUM clustern, LOW/INFO erstmal überspringen — Reviewer-Skill anpassen, falls Cluster auf vage Regel hinweist. | + Falle: wer am ersten LOW-Finding hängenbleibt (typischer Fehler aus dem Engage), arbeitet HIGH-Findings nicht ab — und genau dadurch wird die Findings-Liste zur Mängelliste statt Entscheidungsvorlage. |

## Weiterlesen

* Nächstes Modul: [Modul 10 — Verification Harness](modul-10-verification.md)
