# Lösung — Modul 9: Implementierung durch KI-Agenten

Zugehöriges Modul: [Modul 9 — Implementierung durch KI-Agenten](../03-agenten/modul-09-implementierung.md).

## Selbstcheck-Antworten

### (Erinnern) Nenne die acht Schritte des Minimal Agent Workflow

1. `harness/README.md` lesen.
2. Relevante kanonische Quelle lesen (Source Precedence beachten).
3. Betroffene Requirement-/ADR-IDs identifizieren.
4. Kleinste sinnvolle Änderung planen.
5. Engsten nützlichen Sensor laufen lassen (z. B. nur eine Testdatei).
6. Repo-weiten Gate-Lauf vor Handoff (`make gates`).
7. Doku/Indizes aktualisieren, falls ein öffentlicher Vertrag berührt ist.
8. Ausgeführte Sensors und verbleibende Risiken berichten — keine
   Erfolgsmeldung ohne Gate-Ausführung.

Wichtig sind die *Rücksprungkanten* aus dem Diagramm in Modul 9:
**5 → 4** (Sensor rot ⇒ Plan verfeinern, nicht Code blind reparieren) und
**6 → 4** (`make gates` rot ⇒ wieder Plan verfeinern). Es gibt *keine*
Rücksprungkante zu Schritt 1 oder 2 — wer dort hinspringt, hat keinen
Plan-Defekt, sondern einen Kontext-Defekt; das ist eine andere Ursache
und braucht eine andere Aktion (typisch: AGENTS.md schärfen).

Häufiger Fehler: Schritt 7 und 8 werden unter Zeitdruck weggelassen.
Damit wird das Modul-Versprechen "Plan → Diff → Code" zur "Diff →
Code"-Schleife — und die Risiken werden in die nächste Rolle verlagert.

### Welche Eingaben braucht ein Implementation-Agent minimal, um nicht zu halluzinieren?

Mindestens diese sechs:

1. **Den Slice-Plan** mit DoD.
2. **Die referenzierten Anforderungs-IDs** (`LH-*`/`HSM-*`) inklusive Akzeptanzkriterien — *nicht* nur die ID, der Text.
3. **Die relevanten ADRs** (zumindest die, deren Schichten oder Constraints berührt werden).
4. **`AGENTS.md`** für Hard Rules und Stil.
5. **`harness/README.md`** für Source Precedence und Sensors.
6. **Tool-Allowlist** — was darf der Agent ausführen (Shell, HTTP, DB-Schreibzugriff)?

Was *fehlt* und trotzdem oft erwartet wird:

- Bestehender Code als Vor-Lesen-Vorlage. Der Agent soll sich am Stil orientieren — sonst variiert er.
- Beispiel-Patches früherer Slices (one-shot Lerneffekt).
- Negativ-Beispiele: "so haben wir es nicht gemacht, weil…"

Wenn eine dieser Eingaben fehlt, ist Halluzinationswahrscheinlichkeit
nicht null, sondern systematisch erhöht in genau diesem Bereich.

### Wann ist ein Implementation-Agent fertig — wenn der Code kompiliert, oder wenn die DoD erfüllt ist?

DoD erfüllt. Kompilieren ist ein *einzelner* Sensor unter vielen
(Computational + Feedback). Der Agent darf "fertig" erst melden, wenn:

- `make gates` grün (oder Carveout dokumentiert),
- Pre-completion Checklist Middleware abgearbeitet,
- alle Akzeptanzkriterien der referenzierten IDs nachweisbar erfüllt,
- öffentliche Doku-Verträge aktualisiert (Modul 9, Schritt 7).

"Fertig wenn es kompiliert" ist der Erbsünden-Reflex der frühen
LLM-Coding-Zeit. Der Harness ersetzt ihn durch die 8-Schritt-Checkliste
aus [Modul 9](../03-agenten/modul-09-implementierung.md).

### Welche deiner Hard Rules wandert in welche Quadranten der 2×2-Matrix?

Beispielzuordnung (Übung aus dem Modul). Quadranten gemäß
[`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md):

| Hard Rule | Quadrant |
|---|---|
| "Docker-only" (grid-gym) | Computational + Feedforward (Dockerfile macht Alternative unmöglich) + Computational + Feedback (Lint, das `python -m venv` aufruft, schlägt an) |
| "`# noqa` ist verboten" | Computational + Feedback (`noqa-gate` als Make-Target) |
| "git mv + Inhalt = zwei Commits" | Inferential + Feedforward (steht in AGENTS.md), schwer maschinell durchsetzbar |
| "Architektur ist meilensteinfrei" | Inferential + Feedback (Reviewer-Agent erkennt "Welle X" in `spec/architecture.md`) |
| "Optimierer schreibt nicht direkt aufs Gerät" | Computational + Feedforward (Layering verbietet Import) + Inferential + Feedback (Reviewer prüft semantisch) |

Die wertvollsten Hard Rules sind die, die *in mehrere Quadranten*
fallen — sie sind redundant durchgesetzt und überleben einen
einzelnen Tooling-Ausfall.

### (Anwenden) Welcher Schritt deines Workflows ist heute am schwächsten verankert — woran erkennst du das?

Eine ehrliche Antwort hat drei Bestandteile:

1. **Konkret benannter Schritt.** Nicht "Plan ist immer schwach", sondern
   "Schritt 7 (Doku/Indizes-Update) bleibt regelmäßig liegen" oder
   "Schritt 5 (engster Sensor) wird übersprungen, alle laufen direkt
   `make gates`".
2. **Beobachtbarer Beleg.** Beispiele: `harness/README.md` ist seit
   sechs Wochen unverändert, obwohl drei Gate-Targets sich geändert
   haben (Schritt 7); Mittlere Zeit pro Slice ist auf das Doppelte
   gestiegen, weil zu früh `make gates` läuft (Schritt 5 fehlt);
   Schritt-8-Bericht enthält in 4 von 5 PRs identischen Text (Kabuki).
3. **Steering-Loop-Eintrag.** Eine konkrete Harness-Änderung, die das
   beim nächsten Lauf verhindert — z. B. Doku-Konsistenz-Agent als
   Drift-Sensor (Modul 15), oder Pre-completion Checklist Middleware
   mit Pflichtfeld für *einen* spezifischen Akzeptanzkriterium-Beleg.

Falle: "Ich bin nicht diszipliniert genug" ist eine Anti-Antwort aus
der Reflexionsvorlage. Die Frage ist nicht *wer*, sondern *was am
Harness* den Schritt schwach hält.

## Übungshinweise

### Implementierung eines Features aus einem Slice-Plan

Maßstab:

- Der Agent durchläuft *sichtbar* die 8 Schritte des Minimal Agent Workflow.
- Der erzeugte Diff lässt sich auf den Slice-Plan zurückführen — kein Code, der nicht durch DoD gefordert ist.
- Der Agent berichtet am Ende *was er ausgeführt hat* (welche Sensors grün, welche rot, welche Doku aktualisiert).

### Lass den Agenten ohne ADR-Kontext laufen und vergleiche

Erwartung: Ohne ADR baut der Agent etwas Plausibles, aber typischerweise
falsch geschichtet (Service ruft direkt Repo auf, weil "kürzer" ist).
*Mit* ADR baut er den Adapter dazwischen — auch wenn der zunächst dünn
wirkt. Der Vergleich zeigt: ADR ist nicht Bürokratie, sondern
Trampelpfad-Verhinderung.

### Formuliere drei Hard Rules für ein Beispiel-Repo

Maßstab für gute Hard Rules:

- Falsch/Richtig-Beispiel ist konkret und ausführbar.
- *Technische* Begründung (nicht "wir mögen das nicht").
- Mindestens *eine* der drei ist maschinell durchsetzbar — sonst ist die Liste reine Beschwörung.

## Häufige Fehler

- **Plan wird übersprungen** ("der Slice ist klein"). → Plan-Schritt ist die Stelle, an der der Agent die *eigene* Architektur-Entscheidung sichtbar macht. Ohne Plan kein Review-Material.
- **AGENTS.md wird gefüllt mit Beispielen statt Regeln.** → Die Datei wird länger, aber weniger durchsetzbar. Regeln gehören rein, Beispiele in den Kurs oder ins Lab.
- **Pre-completion Checklist wird zur Pflichtformel.** → Wenn der Agent *immer* dieselbe Checklist abhakt, ohne tatsächlich zu prüfen, ist es Kabuki. Checklist muss in jedem Lauf etwas Spezifisches enthalten (z. B. "geprüft: Akzeptanzkriterium LH-FA-3.b").

## Verweise

- 2×2-Matrix: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)
- Hard-Rule-Beispiele aus realen Repos: [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
- Vorherige Lösung: [Modul 8](modul-08-loesung.md)
- Nächste Lösung: [Modul 10](modul-10-loesung.md)
