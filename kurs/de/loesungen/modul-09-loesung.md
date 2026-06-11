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

### (Anwenden — aktiviert LZ 1) Roter `arch-check` in Schritt 6 — welche Rücksprungkante?

Rücksprung zu **Schritt 4 (Plan verfeinern)**, nicht zu Schritt 1. Der
rote `arch-check` ist ein ADR-Verstoß durch einen direkten Import — der
Agent *kannte* die ADR (sie war im Kontext), hat aber den Diff falsch
geschnitten. Das ist ein **Plan-Defekt**, kein Kontext-Defekt. Konkrete
Korrektur: den direkten Import durch einen **Adapter-Wrapper** ersetzen,
sodass die Schichtung der ADR gewahrt bleibt — genau wie im Worked
Example Schritt 6, wo der direkte `net/http`-Import in
`service/auth/login.go` durch einen Adapter-Wrapper in
`adapter/jwt/sign.go` ersetzt wird.

Die Abgrenzung ist die eigentliche Diagnose: Nur wenn die ADR *gar nicht
im Kontext* war (der Agent konnte sie nicht kennen), wäre Schritt 1/2 die
richtige Kante — dann fehlt die kanonische Quelle, und die Aktion ist
"AGENTS.md/Source Precedence schärfen", nicht "Plan verfeinern". Die Wahl
der Kante *ist* die Ursachen-Diagnose.

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

### (Bewerten — aktiviert LZ 4) Wie misst du die Wirkung von AGENTS.md auf einen Agentenlauf?

Zwei Läufe, vier Achsen, alles andere konstant:

- **Lauf A (mit AGENTS.md):** vollständiges Kontextpaket —
  Spec-Auszug, betroffene ADRs, AGENTS.md, Tool-Allowlist.
- **Lauf B (ohne AGENTS.md):** *exakt* derselbe Aufbau, nur AGENTS.md
  aus dem Kontext entfernt.
- **Konstant gehalten:** Slice (ideal `SL-014a`), Spec-/ADR-Stand,
  Modellversion, Seed. Variiert wird *eine einzige* Variable — sonst
  ist der Vergleich keine Messung, sondern ein Bauchgefühl.

Gemessen wird entlang der vier Achsen aus dem Übungsskelett:

| Achse | Messgröße |
|---|---|
| Hard-Rule-Konformität | Anzahl Verstöße in Lauf B (vom Reviewer-Agent benannt) |
| Architektur-Konformität | `make arch-check` rot/grün |
| Plan-Qualität | Schritt-4-Ausgabe Wort für Wort vergleichen (Out-of-Scope, Risiken, Folge-Slices benannt?) |
| Bericht-Qualität | binär: Schritt 8 enthält Sensors + Restrisiken konkret / enthält nicht |

Auf Exzellent-Niveau: Befund einem Quadranten zuordnen (AGENTS.md ist
*inferential feedforward*) und vorhersagen, welche Achse am stärksten
reagiert. Der Sonderfall "A ≈ B" ist selbst ein Befund — die Defaults
des Modells decken die Regeln zufällig ab; beim nächsten Modellwechsel
können die *unausgesprochenen* Defaults andere sein (Modul 12:
Drift-Diagnose).

### (Bewerten + Metakognition) Welcher Schritt deines Workflows ist heute am schwächsten verankert — woran erkennst du das?

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

### AGENTS.md-Wirkungsmessung (Übungsskelett)

Folge dem sechsschrittigen Skelett aus dem Modul: Slice fixieren →
Lauf A (mit AGENTS.md) → Lauf B (ohne, sonst identisch: gleiches
Modell, gleicher Seed, gleicher Spec-/ADR-Stand) → Diff entlang der
vier Achsen messen → Quadranten-Zuordnung → Reflexionseintrag.

Maßstab (aus dem Modul):

- *Solide:* vier Achsen befüllt, Quadrant benannt, mindestens eine
  Differenz zwischen A und B mit Beleg im Diff.
- *Exzellent:* zusätzlich Hypothese, *welche* einzelne Hard Rule den
  größten Unterschied verursacht — und ein dritter Lauf, der diese
  Hard Rule isoliert prüft.

Typische Erwartung an Lauf B: Der Code bleibt plausibel, aber die
Hard-Rule-Verstöße häufen sich genau dort, wo AGENTS.md *Negativregeln*
trug (z. B. Inline-Suppressions, direkter Import statt Adapter) — der
Agent ersetzt fehlende Regeln durch eigene Defaults, nicht durch
Schweigen. Häufiger Übungsfehler: zwischen A und B "nebenbei" auch den
Slice oder das Modell wechseln — dann misst du zwei Variablen und
kannst keinen Befund AGENTS.md zuschreiben.

### Formuliere drei Hard Rules für ein Beispiel-Repo

Maßstab für gute Hard Rules:

- Falsch/Richtig-Beispiel ist konkret und ausführbar.
- *Technische* Begründung (nicht "wir mögen das nicht").
- Mindestens *eine* der drei ist maschinell durchsetzbar — sonst ist die Liste reine Beschwörung.

Beispiel-Konstruktion für ein fiktives Python-Service-Repo
(`orders-api`), auf Übungs-Niveau ausgearbeitet:

1. **Kein direkter DB-Zugriff aus `api/`-Handlern.**
   *Falsch:* `from app.db import session` in `api/orders.py`.
   *Richtig:* `api/orders.py` ruft `service/orders.py`, das über
   `repository/orders.py` auf die DB geht.
   *Begründung:* Hexagonale Schichtung (ADR-Bezug); sonst wachsen
   Query-Logik und HTTP-Validierung zusammen und sind einzeln nicht
   testbar. **Maschinell durchsetzbar:** Import-Linter-Regel
   (`arch-check`-Gate: `api/* darf nicht repository/* importieren`).
2. **`# noqa` / `# type: ignore` sind verboten.**
   *Falsch:* `result = parse(data)  # type: ignore`.
   *Richtig:* Ausnahme zentral in `pyproject.toml` mit Begründung.
   *Begründung:* Inline-Suppressions sind unsichtbare Carveouts ohne
   Trigger; zentral dokumentiert bleiben sie auditierbar.
   **Maschinell durchsetzbar:** `noqa-gate` (grep-basiert) in
   `make gates`.
3. **Migrations-Dateien werden nie editiert, nur ergänzt.**
   *Falsch:* bestehende `migrations/0042_*.py` umschreiben.
   *Richtig:* neue Migration `0043_*` anlegen, die korrigiert.
   *Begründung:* Bereits ausgerollte Migrationen sind auf fremden
   Umgebungen gelaufen; ein Edit erzeugt divergente Schemata, die kein
   Gate mehr einfängt. **Maschinell durchsetzbar:** CI-Check, der im
   Diff `M`-Status auf `migrations/` verbietet.

Damit ist nicht nur *eine*, sondern jede der drei maschinell
durchsetzbar — das ist kein Zufall: Die Übung trainiert genau den
Reflex, jede Hard Rule in *zwei* Quadranten zu legen (AGENTS.md-Eintrag
= inferential feedforward, Gate = computational feedback). Eine Regel,
für die dir partout keine Fitness Function einfällt (wie "git mv +
Inhalt = zwei Commits"), bleibt zulässig — aber sie ist halb
durchgesetzt, und das sollte die Begründung ehrlich sagen.

## Häufige Fehler

- **Plan wird übersprungen** ("der Slice ist klein"). → Plan-Schritt ist die Stelle, an der der Agent die *eigene* Architektur-Entscheidung sichtbar macht. Ohne Plan kein Review-Material.
- **AGENTS.md wird gefüllt mit Beispielen statt Regeln.** → Die Datei wird länger, aber weniger durchsetzbar. Regeln gehören rein, Beispiele in den Kurs oder ins Lab.
- **Pre-completion Checklist wird zur Pflichtformel.** → Wenn der Agent *immer* dieselbe Checklist abhakt, ohne tatsächlich zu prüfen, ist es Kabuki. Checklist muss in jedem Lauf etwas Spezifisches enthalten (z. B. "geprüft: Akzeptanzkriterium LH-FA-3.b").

## Verweise

- 2×2-Matrix: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)
- Hard-Rule-Beispiele aus realen Repos: [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
- Vorherige Lösung: [Modul 8](modul-08-loesung.md)
- Nächste Lösung: [Modul 10](modul-10-loesung.md)
