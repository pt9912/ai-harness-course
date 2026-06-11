# Modul 9 — Implementierung durch KI-Agenten

> **Aufwand:** ca. 120 Min Lesen · 120 Min Übung. Dieses Modul ist absichtlich tief — der 8-Schritt-Workflow und die Hard Rules sind die operative Brücke zwischen Theorie (Module 1–8) und Gates (Module 10–13).
>
> **Segmenting-Empfehlung (Sweller).** Das Modul zerfällt natürlich in
> zwei Teile. **Teil A (9a — Workflow):** Engage · Lernziele ·
> Mini-Vorgriff · Kernidee · 8-Schritt-Workflow. Lies A und mache
> den [minimalen Übungspfad](#minimaler-übungspfad) — *bevor* du Teil B
> öffnest. **Teil B (9b — Regeln, Kontext, Worked Example):** Hard
> Rules · Typische Fehlvorstellungen · Kontext-Verdichtung · Worked
> Example · Übungen · Reflexion · Selbstcheck. Der Trenner steht
> sichtbar nach dem Workflow-Diagramm ([§Pause-Punkt 9a → 9b](#pause-punkt-9a--9b)).
> Wer A und B in einer Sitzung liest, wird die Hard Rules nicht mehr in
> die richtige Stelle des Workflows einordnen — sie sind ein zweiter,
> paralleler Mechanismus, kein nächster Schritt.

## Mini-Vorgriff: zwei Begriffe aus Modul 15

Dieser Modulteil referenziert zweimal Begriffe, deren Vollform in
[Modul 15 (Observability)](../05-betrieb/modul-15-observability.md)
liegt. Für den ersten Durchgang reichen Kurzdefinitionen — analog zum
Image-Hash-Vorgriff in
[Modul 12](../04-qualitaet/modul-12-replay-evaluierung.md#begriff-image-hash-vorgriff-aus-modul-14):

* **Cache-Hit-Rate** — Anteil der Eingabe-Tokens, die der LLM-Provider
  aus dem Prompt-Cache liefert (statt erneut zu berechnen). Hoher
  Anteil = niedrige Kosten und schnellere Antwort. In diesem Modul nur
  als Argument: wer Spec/ADR/AGENTS.md am Anfang des Kontexts hält,
  produziert hohe Cache-Hit-Raten; wer den Kontext zwischen Läufen
  durcheinanderwirbelt, produziert Cache-Misses. Volldefinition Modul
  15.
* **Doku-Konsistenz-Agent** — automatisierter Drift-Detektor, der
  AGENTS.md, `harness/README.md` und realen Code-/Gate-Stand
  vergleicht und Widersprüche meldet. In diesem Modul nur als
  Steering-Loop-Verweis: wenn Schritt 7 (Doku-Update) im Workflow
  schwach ist, ist der Doku-Konsistenz-Agent der Sensor, der Drift
  *findet*. Volldefinition Modul 15.

## Engage

Du gibst deinem Implementation-Agent einen Slice. Er liefert in vier
Minuten 800 Zeilen Diff. Du prüfst — und findest, dass er die Hälfte aus
einem ähnlichen Repo erfunden hat, weil deine AGENTS.md schwieg. Hätte
er stattdessen erst einen *Plan* ausgegeben, hätte er nach 30 Sekunden
einräumen müssen, dass er den Kontext nicht hat. Plan → Diff → Code ist
nicht eine Empfehlung; es ist *die Reihenfolge*, die "schreiben" von
"raten" trennt.

## Lernziele

Nach diesem Modul kannst du:

* einen Slice nach dem 8-Schritt-Workflow *umsetzen* und die Reihenfolge Plan → Diff → Code *einhalten* (Anwenden · prozedural),
* drei Hard Rules für ein Beispiel-Repo *formulieren*, jeweils mit Falsch/Richtig-Beispiel und Begründung (Erschaffen · prozedural),
* eine Hard Rule einem oder zwei Quadranten der 2×2-Matrix *zuordnen* (Analysieren · konzeptuell),
* die Wirkung von AGENTS.md auf einen Agentenlauf *messen*, indem du den Lauf mit und ohne AGENTS.md vergleichst (Bewerten · prozedural),
* den schwächsten Schritt des Workflows in deinem eigenen Repo *einschätzen* und einen konkreten Beleg dafür *benennen* (Bewerten · metakognitiv).

## Lab-Bezug

* [`../../../lab/example/Makefile`](../../../lab/example/Makefile), Target `make agent-implement SLICE=slice-009`
* [`../../../lab/example/exercises/08-implementation.md`](../../../lab/example/exercises/08-implementation.md)

## Themen

* Codegenerierung
* Änderungsplanung vor Code
* Refactoring
* Architekturkonformität
* Werkzeugbindung (welche Tools darf der Agent benutzen)
* AGENTS.md als zentrale, maschinell lesbare Konventionsdatei
* Pre-completion Checklist Middleware (Self-Check vor PR-Open)

## Kernidee

Ein Agent ohne Plan schreibt Code. Ein Agent mit Plan schreibt das
*Richtige*. Die Reihenfolge Plan → Diff → Code ist nicht optional.

## Minimal Agent Workflow (8 Schritte)

Der Pfad, den jeder Implementation-Agent pro Slice durchläuft — und der
in `harness/README.md` als Vertrag dokumentiert wird. Strukturfragen
(Bindung-Klassen für die Sensors-Tabelle, Source-Precedence-Begründung,
Modus pro Sub-Area, Adaptionen ggü. der adoptierten Baseline) leben
in `harness/conventions.md`:

1. `harness/README.md` lesen.
2. Relevante kanonische Quelle lesen (Source Precedence beachten).
3. Betroffene Requirement-/ADR-IDs identifizieren.
4. Kleinste sinnvolle Änderung planen.
5. Engsten nützlichen Sensor laufen lassen (z. B. nur eine Testdatei).
6. Repo-weiten Gate-Lauf vor Handoff (`make gates`).
7. Doku/Indizes aktualisieren, falls ein öffentlicher Vertrag berührt ist.
8. Ausgeführte Sensors und verbleibende Risiken berichten — keine Erfolgsmeldung ohne Gate-Ausführung.

### Workflow als Diagramm

```mermaid
flowchart TD
    Start([Slice startet]) --> S1["1. harness/README.md lesen"]
    S1 --> S2["2. kanonische Quelle lesen<br/>(Source Precedence)"]
    S2 --> S3["3. Requirement-/ADR-IDs<br/>identifizieren"]
    S3 --> S4["4. kleinste Änderung planen<br/>(Plan vor Code!)"]
    S4 --> S5["5. engsten Sensor laufen<br/>(eine Testdatei)"]
    S5 --> Check{Sensor grün?}
    Check -- nein --> S4
    Check -- ja --> S6["6. make gates (repo-weit)"]
    S6 --> CheckG{alle Gates grün?}
    CheckG -- nein --> S4
    CheckG -- ja --> S7["7. Doku/Indizes update<br/>(falls Vertrag berührt)"]
    S7 --> S8["8. Bericht:<br/>Sensors + Restrisiken"]
    S8 --> Done([Handoff an Reviewer])
```

Zwei Rücksprungkanten sind didaktisch wesentlich: 5→4 und 6→4. Nicht
zurück zu Schritt 1 — der Plan wird *verfeinert*, nicht der Kontext neu
gelesen.

## Pause-Punkt 9a → 9b

> *Hier endet Teil 9a.* Wenn du der Segmenting-Empfehlung folgst (siehe
> Anlauf-Box am Modul-Kopf), mach jetzt Pause und nimm Teil 9b in einer
> *zweiten* Sitzung. Begründung: Hard Rules sind ein paralleler
> Mechanismus, kein nächster Schritt im Workflow. In *derselben* Sitzung
> gelesen, kleben sie an Schritt 6 oder 7 — und das ist die
> häufigste Quelle der Fehlvorstellung *"Hard Rules in AGENTS.md
> reichen"* (Modul 9 §Typische Fehlvorstellungen).
>
> **Selbsttest vor Pause (60 Sekunden, ohne Spickzettel):**
>
> 1. Nenne die acht Schritte des Workflows in Reihenfolge.
> 2. Wo sind die zwei Rücksprungkanten? Wohin springst du *nicht* zurück, und warum?
> 3. Was ist die Eingabe von Schritt 1, und was bestimmt sie?
>
> Wenn du eine der drei Fragen unsicher beantwortest, ist das ein
> Signal, Teil 9a kurz zu wiederholen — nicht, in 9b weiterzulesen. Die
> Hard Rules in 9b setzen den Workflow voraus.
>
> Wer in *einer* Sitzung weiterliest: das ist okay, aber nimm das
> Selbsttest-Trio als Anker — das Modul ist explizit auf zwei Sitzungen
> ausgelegt (Sweller: Segmenting + Pre-Training).

## Hard Rules (repo-spezifisch)

Negativregeln, die der Agent nie brechen darf. Eine gute Hard Rule hat
*Falsch/Richtig*-Beispiele **und** eine *technische Begründung*.
Beispiele aus realen Repos (siehe
[`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)):

* **Docker-only** (grid-gym): kein lokales `.venv`, kein `pip install` außerhalb von Dockerfile-Stages.
  *Falsch:* `uv run python tools/foo.py`.
  *Richtig:* `docker compose run --rm test-runner uv run python tools/foo.py`.
  *Begründung:* Toolchain-Reproduzierbarkeit + Supply-Chain-Defense.
* **`# noqa` ist verboten** (grid-gym): bricht das `noqa-gate` in `make gates`. Ausnahmen werden in `pyproject.toml` mit Begründung dokumentiert.
* **Suppression-Verbot pro Sprache** — derselbe Mechanismus, andere Syntax:
  * Python: `# noqa` (grid-gym `noqa-gate`)
  * Go: `//nolint`
  * C#: `#pragma warning disable`, `[SuppressMessage]` (bess-ems `solid-suppression-gate`)
  * Kotlin: `@Suppress("...")`
  * Java: `@SuppressWarnings("...")`
  In jeder Sprache gilt: Inline-Suppression bricht das Suppression-Gate; Ausnahmen wandern in eine zentrale Konfigurations-Datei mit Begründung.
* **git mv + Inhaltsänderung = zwei Commits** (grid-gym): erst reiner `git mv` (Git erkennt R-Rename), dann Inhalt umschreiben.
  *Begründung:* Sonst fällt die Rename-Detection unter die 50 %-Similarity-Schwelle und `git log --follow` wird unzuverlässig.
* **Architektur ist sprach- und meilensteinfrei** (grid-gym, c-hsm-doc): `spec/architecture.md` referenziert ADRs und Modul-Pfade, aber keine Wellen, Slices oder Closure-Daten. Die zeitliche Schicht lebt in `docs/plan/planning/`.
* **Optimierer darf nie direkt aufs Gerät schreiben** (bess-ems-Klasse): Output fließt durch Statemachine, Constraint-Limiter, Ramp-Limiter.
* **Gates dürfen nicht ohne ADR gelockert werden**: jede Schwellen-Senkung ist ein ADR, kein PR-Kommentar.

Hard Rules sind *computational + inferential feedforward* zugleich: sie
stehen in AGENTS.md (Agent liest sie) **und** werden idealerweise durch
eine Fitness Function geprüft (Linter schlägt an). Wenn nur eines von
beiden existiert, ist die Regel nur halb durchgesetzt.

## Typische Fehlvorstellungen

- **"Agent liefert schnell, also ist der Workflow Overhead."** — Geschwindigkeit ohne Plan produziert Diffs, die später als Review-Last anfallen. Plan + Diff + Code kostet 20 % länger und spart 50 % Review.
- **"Hard Rules schreibe ich in AGENTS.md, und das reicht."** — Eine Hard Rule, die nur in AGENTS.md steht (inferential feedforward), ist halbgesetzt. Erst mit Fitness Function (computational feedback) ist sie *durchgesetzt*. Beides ist Pflicht.
- **"Wenn die Tests grün sind, ist der Slice fertig."** — Schritt 8 verlangt einen Bericht über *Sensors und verbleibende Risiken*. Grüne Tests sind notwendig, nicht hinreichend.
- **"Die Pre-completion Checklist ist Bürokratie."** — Sie ist der einzige Schritt, der vor Übergabe an Reviewer/Verifier eine *Selbstaussage* erzwingt. Wer keinen Selbst-Check macht, lädt jedes Risiko in die nächste Rolle.
- **"Mehr Kontext ist immer besser — siehe Lopopolo."** — Lopopolos *"Was der Agent nicht im Kontext erreicht, existiert für ihn nicht"* sagt: *fehlender* Kontext schadet. Es sagt **nicht**: *jeder zusätzliche* Kontext nützt. Siehe nächster Block.
- **"Ein Agent ist ein besserer/schnellerer Programmierer."** — Die Engage-Geschichte (800 Zeilen in 4 Minuten) suggeriert das. Falsch verstanden, kippt es ins Gegenteil: *Geschwindigkeit ohne Plan* erzeugt Review-Last, nicht Lieferung. Faustregel: Plan-vor-Code kostet 20 % mehr Zeit *im Lauf* und spart 50 % Review-Zeit *danach* — gemessen pro Slice, nicht pro Minute. Wer den Agenten als Speed-Tool denkt, mißt am falschen Hebel: nicht Diff-pro-Stunde, sondern Slice-bis-`done/`. Belegt durch Lopopolo (~1 Mio. Zeilen Code in ~1500 PRs über fünf Monate mit *drei* Engineers — Skalierung kommt aus dem Harness, nicht aus dem Modell).

## Kontext-Verdichtung (Kehrseite der Lopopolo-Maxime)

Die Maxime *"Was der Agent nicht im Kontext erreicht, existiert für ihn
nicht"* (Original: *"anything it can't access in-context doesn't exist"*)
ist im Kurs eine Hebellinse — sie erklärt, warum Spec, ADR und AGENTS.md *die
Hauptkontrolle* sind, nicht Beiwerk. Aber sie hat eine Kehrseite, die der
Reflex "mehr Kontext rein" gerne überliest:

- **Kontext-Pollution.** Wenn ein 14 Wochen alter ADR-Entwurf im Kontext
  steht, der mit `superseded` markiert ist, erfindet der Agent
  Begründungen *aus dem alten ADR*. Der Kontext besteht — die
  Information ist falsch. Mehr Tokens, schlechteres Ergebnis.
- **Lost in the Middle.** Auch bei großen Kontext-Fenstern fallen
  Informationen in der Mitte des Prompts deutlich seltener in den
  Output zurück als Anfang und Ende. Wer wichtige Anforderungen
  ungeordnet "dazwischen" platziert, hat sie technisch im Kontext und
  praktisch nicht.
- **Token-Kosten.** Jedes Token im Eingangskontext wird abgerechnet —
  pro Lauf, pro Tool-Call, pro Replay. Ein 30-zeiliger irrelevanter
  Block, der in 1500 PRs mitläuft (siehe Lopopolos empirischer Beleg in
  [`../abschluss/quellen.md`](../abschluss/quellen.md)), ist eine
  Rechnung mit vier Stellen vor dem Komma.

Folge: Context Engineering ist *auch* eine Reduktions-Aufgabe.
Konkret gehört in den Lauf-Kontext:

| Pflicht | Wer? |
|---|---|
| `harness/README.md` | jeder Lauf |
| relevante kanonische Quelle (Source Precedence) | jeder Lauf, gezielt |
| Requirement-/ADR-IDs des Slice | jeder Lauf |
| AGENTS.md (Hard Rules + Konventionen) | jeder Lauf |
| Tool-Allowlist | jeder Lauf |

| Nicht in den Lauf-Kontext (Anti-Pattern) |
|---|
| `superseded`/`deprecated` ADRs ohne Folge-Bezug |
| historische Spec-Diff-Notizen, die jetzt in ADR-Form gegossen sind |
| Skills, die nicht zu dieser Rolle gehören |
| ältere Carveouts, deren Auflösungs-Trigger bereits eingetreten ist |

Die Verdichtungs-Sensoren dafür sind in [Modul 15](../05-betrieb/modul-15-observability.md):
Token-Eingabe-Metrik pro Slice, Cache-Hit-Rate (siehe Mini-Glossar in
Modul 15), und der **Doku-Konsistenz-Agent** als Drift-Detektor für tote
Kontext-Stücke.

Faustregel für den 8-Schritt-Workflow: Schritt 2 ist *"kanonische Quelle
lesen"*, nicht *"alles lesen, was im Repo liegt"*. Wenn der Plan in
Schritt 4 nicht ohne Verweis auf einen Kontext-Block auskommt, gehört
dieser Block in den nächsten Lauf — alle anderen nicht.

## Worked Example: ein Slice durch den 8-Schritt-Workflow

> **Wenn du den 8-Schritt-Workflow in deinem eigenen Repo bereits routiniert läufst (Plan-vor-Code als Reflex, Sensor-Verfeinerung statt Kontext-Neulesen), springe zu [§Übungen](#übungen).** Das Worked Example unten ist die Schablone für den ersten oder zweiten Durchgang — wer den Workflow verinnerlicht hat, gewinnt durch erneutes Mitlesen wenig (Expertise-Reversal).

**Ausgangs-Slice:** `SL-014a` aus dem Worked Example in
[Modul 5](../02-planung/modul-05-planning-harness.md#worked-example-einen-zu-großen-slice-schneiden) —
*"Login-Endpoint akzeptiert User/Passwort, gibt JWT zurück,
Audit-Log-Eintrag entsteht. Bezug: LH-FA-AUTH-001 + ADR-0007
(Service-Adapter-Layer)."*

**Schritt 1 — `harness/README.md` lesen.**
Implementer-Agent öffnet `harness/README.md`. Stellt fest: Source
Precedence sagt *Spec → ADRs → Roadmap → AGENTS.md*. Tool-Allowlist
enthält keinen direkten HTTP-Client (folgt ADR-7).

**Schritt 2 — Kanonische Quelle lesen (gezielt).**
`spec/lastenheft.md` Abschnitt `LH-FA-AUTH-001` (drei
Akzeptanzkriterien). ADR-0007 (Service-Adapter-Layer). *Nicht* gelesen:
ältere ADRs, irrelevante Skills — siehe oben "Kontext-Verdichtung".

**Auch hier gelesen, falls vorhanden:** §8 *Sub-Area-Modus-Begründung*
des Slice-Plans (siehe [Modul 5 §Worked Mini-Example](../02-planung/modul-05-planning-harness.md#worked-mini-example-bootstrap-modus-pro-sub-area-für-einen-slice-begründen)).
Die in §8 benannten Sub-Areas tragen denselben Granularitäts-Maßstab wie
in Modul 2: das Inklusionskriterium aus
[`../grundlagen/konventionen.md` §Was ist eine Sub-Area?](../grundlagen/konventionen.md#was-ist-eine-sub-area)
(drei Achsen, Schwelle ≥ 2) — eine zu grobe Sub-Area (*"Backend"*) in §8
ist derselbe Fehler wie in der Modul-2-Diagnose.
Die BF/Hybrid-Einträge dort steuern, welche Sub-Areas Inventur-Beweis
in Schritt 5 brauchen (z. B. Audit-Logging als Hybrid →
Format-Standard-Test gehört in die Sensor-Wahl, nicht in Out-of-Scope).

**Schritt 3 — Requirement-/ADR-IDs identifizieren.**
`LH-FA-AUTH-001`, `ADR-0007`. Diese zwei IDs werden in den
Make-Target-Kommentar (für `make verify`) und in die Commit-Message
eingewoben.

**Schritt 4 — Kleinste Änderung planen.** Agent gibt **Plan vor Code**
aus:
> **Plan SL-014a:**
> 1. `service/auth/login.go` — Funktion `Login(creds)` mit
>    JWT-Erzeugung. Import nur aus `adapter/jwt/` (ADR-0007).
> 2. `adapter/audit/file.go` — `WriteLoginAttempt(ev)`.
> 3. Tests: `service/auth/login_test.go` (Happy/Boundary/Negative
>    nach LH-FA-AUTH-001).
> *Out-of-Scope dieses Slice:* Refresh-Token (SL-014b), Revocation
> (SL-014c).

**Schritt 5 — Engsten Sensor laufen (eine Testdatei).**
`make test FILE=service/auth/login_test.go`. Erste Iteration rot
(Negativtest schlägt durch). Plan in 4 verfeinern, *nicht* mehr Kontext
laden. Zweite Iteration: grün.

**Schritt 6 — `make gates` (repo-weit).**
Erste Iteration: `arch-check` rot, weil `service/auth/login.go` einen
direkten Import aus `net/http` trägt. Rückkante zu Schritt 4: Plan
korrigieren — Adapter-Wrapper in `adapter/jwt/sign.go`. Zweite
Iteration: grün.

**Schritt 7 — Doku/Indizes aktualisieren.**
`spec/lastenheft.md` — `LH-FA-AUTH-001` als implementiert markiert (mit
Slice-ID-Bezug). `harness/README.md` unverändert (keine neue
Tool-Familie). AGENTS.md unverändert (keine neue Hard Rule).

**Schritt 8 — Bericht: Sensors + Restrisiken.**
> **Sensors gelaufen:** `make test` (3 neue Tests, alle grün), `make
> gates` (alle grün, inkl. arch-check). **Restrisiken:**
> Refresh-Token-Flow (SL-014b) noch nicht implementiert — JWT läuft
> ohne Erneuerungspfad ab; das ist im Plan dokumentiert, *aber* das
> Audit-Log braucht später eine Rotations-Regel. Vorschlag: Folge-Slice
> SL-014b zuerst, Audit-Rotation als Hinweis in dessen DoD aufnehmen.

Acht Schritte mit zwei Rückkanten, ein nachvollziehbarer Slice. Beachte: **kein
Rücksprung zu Schritt 1**, sondern nur 5→4 (Plan verfeinern) und 6→4
(Plan korrigieren wegen Gate). Wer in Schritt 1 zurückspringt, hat einen
Kontext-Defekt, keinen Plan-Defekt — das ist eine andere Ursache und
gehört in den nächsten Steering-Loop-Eintrag.

Vergleich:
[`../../../lab/example/Makefile`](../../../lab/example/Makefile) Target
`make agent-implement SLICE=slice-009` zeigt das Kontextpaket aus
Schritten 1–3, bevor Schritt 4 anfängt.

## Übungen

* Implementierung eines Features aus einem Slice-Plan
* **AGENTS.md-Wirkungsmessung** — siehe Übungsskelett unten (operationalisiert das Bewerten-Lernziel "Wirkung von AGENTS.md messen")
* Formuliere drei Hard Rules für ein Beispiel-Repo und prüfe, ob mindestens eine maschinell durchsetzbar ist

### Minimaler Übungspfad

```bash
cd lab/example
make agent-implement SLICE=slice-009
```

Erwartete Beobachtung: Das Target erzeugt keinen Code. Es zeigt das
Kontextpaket, das ein Implementation-Agent vor dem Plan lesen muss. Erst
wenn du dieses Paket benennen kannst, ist der freie Agentenlauf sinnvoll.

> *Lab-Grenze:* Das Target zeigt nur das *Kontextpaket* (Schritte 1–3
> des Workflows), nicht den Plan-vor-Code-Lauf selbst. Das volle LZ
> "Slice nach dem 8-Schritt-Workflow *umsetzen*" wird erst durch den
> freien Agentenlauf gegen einen realen Slice abgerufen; das LZ "Wirkung
> von AGENTS.md *messen*" durch das Übungsskelett unten — der minimale
> Pfad ist Aufwärm-, nicht Ziel-Niveau.

### Übungsskelett: AGENTS.md-Wirkungsmessung

Das *Bewerten*-Lernziel (*"Wirkung von AGENTS.md auf einen Agentenlauf
messen, indem du den Lauf mit und ohne AGENTS.md vergleichst"*) braucht
ein definiertes Setup, sonst zerfällt es zu einem Bauchgefühl-Vergleich.
Folge diesem Skelett:

1. **Slice fixieren.** Wähle einen kleinen, gut abgegrenzten Slice —
   ideal `SL-014a` aus dem Worked Example oben. Friere Spec-/ADR-Stand
   und Modellversion ein.
2. **Lauf A (mit AGENTS.md).** Starte den Implementation-Agenten mit
   dem vollständigen Kontextpaket: Spec-Auszug, betroffene ADRs,
   AGENTS.md, Tool-Allowlist. Speichere Diff, Plan-Ausgabe und
   Schritt-8-Bericht in `runs/sl-014a-with-agents.md`.
3. **Lauf B (ohne AGENTS.md).** Wiederhole *exakt* — gleicher Slice,
   gleiches Modell, gleicher Seed, nur AGENTS.md aus dem Kontext
   entfernt. Speichere Ergebnisse in `runs/sl-014a-no-agents.md`.
4. **Diff entlang vier Achsen messen** — nicht freihändig vergleichen:

   | Achse | Frage | Messgröße |
   |---|---|---|
   | Hard-Rule-Konformität | Hält Lauf B *jede* Hard Rule, die in AGENTS.md steht? | Anzahl Verstöße (vom Reviewer-Agent benannt) |
   | Architektur-Konformität | Bleibt das Layering eingehalten? | `make arch-check` rot/grün |
   | Plan-Qualität | Benennt der Plan Out-of-Scope, Risiken, Folge-Slices? | Schritt-4-Ausgabe Wort für Wort vergleichen |
   | Bericht-Qualität | Schritt 8 enthält Sensors + Restrisiken konkret? | binär: enthält / enthält nicht |

5. **Quadranten-Zuordnung.** Welcher der vier Befunde liegt in welchem
   Quadranten der 2×2-Matrix? AGENTS.md ist *inferential feedforward* —
   wo erwartest du den größten Effekt, wo den kleinsten? Was sagt die
   Empirie deines Diffs?
6. **Reflexionseintrag.** Verwende die vier Standardfragen aus
   [`reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md). Frage
   4 (Conceptual Change) ist hier zentral: was hattest du *vor* Lauf B
   erwartet, was ist *durch* Lauf B unzufriedenstellend geworden?

Maßstab für eine *solide* Bearbeitung: vier Achsen befüllt, Quadrant
benannt, mindestens eine Differenz zwischen A und B mit Beleg im Diff.
*Exzellent*: zusätzlich Hypothese, *welche* einzelne Hard Rule in
AGENTS.md den größten Unterschied verursacht — und ein dritter Lauf, der
diese Hard Rule isoliert prüft.

Wenn dein Modell stark genug ist, dass A und B fast identisch
aussehen: das ist ebenfalls ein Befund. Notiere ihn — und sei vorsichtig
beim nächsten Modellwechsel, weil dann die *unausgesprochenen* Defaults
des neuen Modells andere werden können (Modul 12: Drift-Diagnose).

## Reflexion

Vier Standardfragen aus [`../grundlagen/reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md)
nach dem Slice-Umsetzungs-Lauf, dem AGENTS.md-Vergleich und den drei
Hard Rules. Modul-spezifische Trigger:

- **Beobachtung:** Welcher Schritt brauchte 5→4-Rücksprung? Wo war der Lauf *mit* AGENTS.md inhaltlich anders als ohne? Welche Hard Rule blieb halb durchgesetzt (kein Gate)?
- **2×2-Quadrant:** Hard Rules liegen typisch in *zwei* Quadranten gleichzeitig.
- **Steering-Loop:** AGENTS.md schärfen? Tool-Allowlist enger? Fitness Function für die schwächste Hard Rule?
- **Conceptual Change:** Kandidaten in [`../grundlagen/lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "Agent liefert schnell, also ist der Workflow Overhead", "Hard Rules in AGENTS.md reichen", "Mehr Kontext ist immer besser").

## Selbstcheck

* **(Erinnern)** Nenne die acht Schritte des Minimal Agent Workflow in Reihenfolge.
* **(Anwenden — aktiviert LZ 1)** Dein Implementation-Agent durchläuft den 8-Schritt-Workflow und stößt in Schritt 6 (`make gates`) auf einen roten `arch-check` (ADR-Verstoß durch einen direkten Import). Welche *Rücksprungkante* nimmst du — zurück zu Schritt 1 (Kontext neu lesen) oder Schritt 4 (Plan verfeinern)? Begründe die Wahl und nenne die konkrete Plan-Korrektur, die den Verstoß behebt.
* Welche Eingaben braucht ein Implementation-Agent minimal, um nicht zu halluzinieren?
* Wann ist ein Implementation-Agent fertig — wenn der Code kompiliert, oder wenn die DoD erfüllt ist?
* Welche deiner Hard Rules wandert in welche Quadranten der 2×2-Matrix?
* **(Bewerten — aktiviert LZ 4)** Wie misst du die Wirkung von AGENTS.md auf einen Agentenlauf — welche zwei Läufe vergleichst du, entlang welcher Achsen, und was hältst du dabei konstant?
* **(Bewerten + Metakognition)** Welcher Schritt des 8-Schritt-Workflows ist in deinem eigenen Repo heute am schwächsten verankert — und woran erkennst du das?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Acht Workflow-Schritte in Reihenfolge? | fünf oder weniger genannt | (1) `harness/README.md` lesen · (2) kanonische Quelle · (3) Requirement-/ADR-IDs · (4) kleinste Änderung planen · (5) engster Sensor · (6) `make gates` · (7) Doku/Indizes · (8) Bericht über Sensors + Restrisiken. | + Rücksprungkanten benannt: 5→4 und 6→4 (Plan wird *verfeinert*, nicht Kontext neu gelesen). Wer rückläufig zu Schritt 1 springt, hat keinen Plan-Defekt, sondern einen Kontext-Defekt — das ist eine andere Ursache. |
| Roter `arch-check` in Schritt 6 — welche Rücksprungkante? | "Nochmal von vorn." — kein konkreter Schritt. | Rücksprung zu **Schritt 4** (Plan verfeinern): der ADR-Verstoß ist ein *Plan*-Defekt, nicht ein Kontext-Defekt — der Agent kannte die ADR, hat den Diff aber falsch geschnitten. Konkrete Korrektur: z. B. Adapter-Wrapper statt direktem Import, sodass die Schichtung gewahrt bleibt. | + Abgrenzung: Rücksprung zu Schritt 1 wäre nur richtig, wenn der Agent die ADR gar nicht *im Kontext* hatte (Kontext-Defekt) — dann fehlt die kanonische Quelle, nicht der Plan. Die Wahl der Kante ist die Diagnose der Ursache. |
| Minimale Eingaben gegen Halluzination? | "Klare Anweisung." | `harness/README.md` + relevante kanonische Quelle + Requirement/ADR-IDs + AGENTS.md + Tool-Allowlist. | + Hinweis Lopopolo: "Was der Agent nicht im Kontext erreicht, existiert für ihn nicht." — fehlende Eingaben werden *durch Raten ersetzt*, nicht durch Schweigen. |
| Fertig: Code kompiliert oder DoD erfüllt? | "DoD." | DoD-erfüllt + Schritt 8 ausgeführt (Bericht über Sensors + Restrisiken). Kompilierender Code ist notwendig, nicht hinreichend. | + Folge: ohne Schritt-8-Bericht wird jedes Risiko in die nächste Rolle (Reviewer/Verifier) verlagert — das bricht die Kontext-Trennung der Rollen. |
| Hard Rules ↔ Quadranten der 2×2-Matrix? | "Inferentielle Feedforward." | Jede Hard Rule liegt in *zwei* Quadranten: inferential feedforward (steht in AGENTS.md) + computational feedback (Fitness Function/Linter-Gate). | + Hard Rule nur in einem Quadranten ist halb durchgesetzt; nur in AGENTS.md vergisst der Agent sie unter Druck, nur als Fitness Function ohne AGENTS.md-Eintrag versteht der Agent das *Warum* nicht. |
| Wirkung von AGENTS.md messen? | "Lauf mit und ohne vergleichen." | Lauf A (mit AGENTS.md) vs. Lauf B (ohne), entlang vier Achsen (Hard-Rule-/Architektur-Konformität, Plan-, Bericht-Qualität); konstant gehalten: Slice, Spec-/ADR-Stand, Modell, Seed — nur AGENTS.md variiert. | + Befund einem Quadranten zugeordnet (AGENTS.md = inferential feedforward) plus Vorhersage *welche* Achse am stärksten reagiert; Sonderfall A≈B ist selbst ein Befund — Warnung für den nächsten Modellwechsel (Modul 12: Drift). |
| Schwächster Schritt im eigenen Repo? | konkret benannt, aber ohne Beleg | Konkret benannter Schritt (z. B. Schritt 7: Doku-Update bleibt liegen) + Beleg (z. B. `harness/README.md` wurde seit 6 Wochen nicht angepasst, obwohl drei Gate-Targets sich änderten). | + Steering-Loop-Eintrag formuliert: was im Harness verändert wird, damit Schritt X beim nächsten Lauf nicht mehr schwächster Schritt ist (z. B. Doku-Konsistenz-Agent als Drift-Sensor, Modul 15). |

## Weiterlesen

* 2×2-Matrix für Quadranten-Zuordnung: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)
* Hard Rules und Workflow *ausführbar* gemacht — Tool-Call-Gate
  (Befehls-Guard) und Workflow-Skelett (Slash-Command) als
  Durchsetzungsschicht:
  [`../grundlagen/durchsetzungsschicht.md`](../grundlagen/durchsetzungsschicht.md).
* Nächstes Modul: [Modul 10 — Review Harness](../04-qualitaet/modul-10-review-harness.md)
