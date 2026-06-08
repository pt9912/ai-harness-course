# Konventionen und Begriffe

Damit der Kurs handlich bleibt, treffen wir an ein paar Stellen feste
Entscheidungen. Diese Begriffe gelten durchgängig.

## Kernbegriffe

| Begriff | Bedeutung im Kurs |
|---|---|
| LLM | Modell, das Text → Text abbildet. Stateless. |
| Agent | LLM + Tool-Schnittstelle + Schleife. Hält Zustand über mehrere Turns. |
| Tool-Call | Strukturierter Aufruf einer Funktion durch das LLM (`name`, `arguments`, `result`). |
| Spec | Lastenheft-Artefakt unter `spec/`. Quelle der Wahrheit für *was*. |
| ADR | Architecture Decision Record unter `docs/plan/adr/`. Quelle der Wahrheit für *warum so*. |
| Slice | Kleinste lieferbare Einheit eines Features. Hat eigenen Plan, eigene DoD. |
| Welle | Bündel von Slices, das gemeinsam geplant und abgeschlossen wird. |
| Trigger | Beobachtbare Bedingung, bei der ein Slice/Welle/Carveout in den nächsten Status wandert. |
| Closure | Abschluss eines Slice oder einer Welle, dokumentiert mit Lerneintrag in `done/`. |
| Gate | Automatisch prüfbares Qualitätskriterium (Linter, Typecheck, Architekturtest, Coverage). |
| Carveout | Dokumentierte Ausnahme von einem Gate oder einer Architekturregel. |
| Skill | Repo-spezifisches Markdown/JSON-Artefakt, das einer Agenten-Rolle Checkliste oder Verhalten beibringt. Lebt typischerweise in `.harness/`. |
| Replay | Deterministisch wiederholbarer Agentenlauf gegen fixierte Inputs. |
| Golden Set | Kuratiertes Eingabe/Erwartungs-Paar für Regressionstests. |
| Finding | Einzelne Beobachtung eines Reviewers, kategorisiert HIGH/MEDIUM/LOW/INFO. |
| DoD | Definition of Done. Liste der Bedingungen, die ein Slice erfüllen muss. |
| Guide | Feedforward-Kontrolle: lenkt den Agenten *vor* der Handlung (Spec, ADR, AGENTS.md, Skill, Tool-Constraint). |
| Sensor | Feedback-Kontrolle: prüft *nach* der Handlung (Linter, Test, ArchUnit, Reviewer-Agent). |
| Fitness Function | Maschinell prüfbare Architektur-Aussage (z. B. Modulgrenze, Latenzbudget). |
| Steering Loop | Wiederkehrendes Muster: beobachtetes Agenten-Versagen → Guide/Sensor verbessern → Wiederholung reduzieren. |
| AGENTS.md | Maschinell lesbare Projekt-Konventionen für Agenten (Codestil, Tool-Regeln, Layering, Verbote). Quasi-Standard nach OpenAI/Codex. |
| Constrain / Inform | OpenAI-Doppelaufgabe des Harness: *constrain* = Grenzen ziehen (Architektur, Tools, Layer), *inform* = Kontext liefern (Spec, ADR, AGENTS.md, Skills). |
| Entropy Management | Aktive Pflege des Harness gegen Doku-Drift, tote Constraints und veraltete Konventionen. |
| Source Precedence | Geordnete Liste der kanonischen Quellen. Bei Konflikt gewinnt die höher rangierende. |
| `harness/README.md` | Pro-Repo-Einstiegspunkt: bündelt Source Precedence, Guides, Sensors, Traceability- und Safety-Regeln. Dupliziert keine Spec-Inhalte. |
| `harness/conventions.md` | Repo-lokaler Konventionsspeicher: trägt Strukturregeln und Adaptionen ggü. der adoptierten Baseline (`MR-<NNN>`-Liste, Zusatzklassen für Sensors-Bindung, Modus-Deklaration pro Sub-Area). Pflicht; Form (Einzeldatei/Verzeichnis) ist Wahl. |
| Hard Rule | Negativregel, die der Agent nie brechen darf (z. B. "Optimierer darf nie direkt aufs Gerät schreiben"). Repo-spezifisch. |
| Repo-Klasse | Charakter eines Repos im Harness: *Referenz* · *Safety/Control* · *Policy/Compliance*. Bestimmt, wie scharf Hard Rules und Sensors gesetzt werden. |
| ID-Schema | Stabile Präfix-Klammer (`LH-*`, `HSM-*`, `GG-*`), die Spec-Anforderungen, Make-Target-Kommentare, ADRs und Commits verbindet. |
| Spec-Stratifizierung | Aufteilung der Spec in *vertraglich* (Lastenheft) und *technisch* (Spezifikation) mit eigener Precedence-Regel. |
| Bootstrap-aware Gate | Gate mit weicher Frühphase: kennt eine Reifestufe und greift erst ab Trigger hart. Dokumentiert, was die Stufe ist. |

## Verzeichniskonvention

```
spec/                       # Lastenhefte
docs/plan/adr/              # Architecture Decision Records
docs/plan/planning/open/    # geplante, noch nicht gestartete Slices
docs/plan/planning/next/    # priorisiert für die nächste Welle
docs/plan/planning/in-progress/  # aktive Slices
docs/plan/planning/done/    # abgeschlossene Slices
docs/plan/planning/in-progress/roadmap.md   # Meilensteine, Wellen, aktive Welle
docs/plan/carveouts/        # Ausnahmen mit Plan zur Auflösung
AGENTS.md                   # maschinell lesbare Projekt-Konventionen für Agenten
harness/README.md           # Repo-Einstiegspunkt: Source Precedence, Guides, Sensors, Safety
harness/conventions.md      # repo-lokale Strukturregeln und Adaptionen ggü. Baseline (MR-NNN, Modus pro Sub-Area)
.harness/                   # Skills, Tool-Allowlists, Checklisten-Middlewares
```

## Trennschärfen

- *Spec* beschreibt **was**, *ADR* begründet **warum so**, *Plan* legt **wann und wie** fest.
- *Review* prüft, ob Code gegen Plan und ADR konform ist; *Verifikation* prüft, ob das Ergebnis die DoD und die Spec erfüllt; *Validation* prüft, ob das Ergebnis den realen Bedarf trifft.
- *Linter*-Findings sind keine *Review*-Findings. Gates sind maschinell; Reviews sind agentisch.

## Source Precedence

Sobald mehr als ein Dokument existiert, gibt es Konflikte. Der Harness
muss vorher festlegen, wer gewinnt. Eine pragmatische Default-Reihenfolge
für ein typisches Repo:

1. `spec/lastenheft.md`
2. `spec/architecture.md`
3. `docs/plan/adr/README.md` und die darin referenzierten ADRs
4. `docs/plan/planning/in-progress/roadmap.md`
5. `docs/user/*.md` (Betriebs-/Operations-Docs — Quality-Definitionen, Releasing, Runbooks)
6. `README.md`
7. `AGENTS.md`
8. `harness/README.md`

```mermaid
flowchart TD
    L["1. spec/lastenheft.md<br/>(vertraglich)"] --> S["2. spec/architecture.md"]
    S --> A["3. docs/plan/adr/<br/>(ADRs)"]
    A --> R["4. roadmap.md"]
    R --> U["5. docs/user/*.md"]
    U --> RM["6. README.md"]
    RM --> AG["7. AGENTS.md"]
    AG --> H["8. harness/README.md"]
    style L fill:#fff4d6,stroke:#d4a017
    style S fill:#fff4d6,stroke:#d4a017
    style A fill:#fff4d6,stroke:#d4a017
    style AG fill:#dceaff,stroke:#3366cc
    style H fill:#dceaff,stroke:#3366cc

    Conflict[/"Konflikt zwischen<br/>AGENTS.md und Spec?"/] -. "AGENTS.md anpassen,<br/>nie die Spec" .-> AG
```

Gelb: kanonische Quellen — Spec, Architektur, ADRs. Blau: Harness-Index
und Agenten-Konventionen — sie *beschreiben* die kanonischen Quellen,
sie *ersetzen* sie nicht.

Regel: Widerspricht `AGENTS.md` oder `harness/README.md` einer kanonischen
Quelle, wird `AGENTS.md`/`harness/README.md` angepasst — nie die kanonische
Quelle. Der Harness folgt der Spec, nicht umgekehrt.

**Universal vs projektabhängig.** *Dass* eine Source Precedence existiert
und dass bei Konflikt die niedriger rangierte Quelle angepasst wird, ist
universal (Hard Rule). *Welche* Rangordnung konkret gilt, ist
projektspezifische Entscheidung — die obige Liste ist eine pragmatische
Default-Reihenfolge für ein typisches Referenz/Tooling-Repo, kein
Gesetz. Andere Repo-Klassen können abweichende Rangordnungen begründen:
ein Safety/Control-Repo kann Hardware-Specs vor Software-Specs ranken;
ein Policy/Compliance-Repo kann Regulatorik-Anforderungen vor das
Lastenheft ranken (weil "wir versprechen" durch "wir müssen" begrenzt
wird). Die konkret getroffene Rangwahl und ihre Begründung gehören in
den Adaptions-Block des repo-lokalen Konventionsdokuments (Default-Pfad
`harness/conventions.md`).

### Spec-Stratifizierung

In reiferen Repos zerfällt `spec/` selbst in mehrere Tiefen mit eigener
Precedence:

| Datei | Charakter | Änderungs-Prozess |
|---|---|---|
| `spec/lastenheft.md` | **vertraglich abnahmebindend** (`LH-*` / `HSM-*`-IDs) | Change Request |
| `spec/spezifikation.md` | **technisch verbindlich, fortschreibbar** (Algorithmen, Defaults, Protokolle) | ADR-Schärfung erlaubt |
| `spec/architecture.md` | Diagramme, Komponentensicht, **keine eigenen Anforderungen** | Diagramm-Update |

```mermaid
flowchart TD
    subgraph LH["lastenheft.md — vertraglich (wir versprechen)"]
        LH1["LH-FA-*, LH-QA-*<br/>Anforderungen mit ID<br/>Akzeptanzkriterien"]
    end
    subgraph SP["spezifikation.md — technisch (wir liefern wie)"]
        SP1["Algorithmen<br/>Defaults<br/>Protokolle"]
    end
    subgraph AR["architecture.md — diagrammatisch (so sieht es aus)"]
        AR1["Komponenten<br/>Schnittstellen<br/>keine eigenen Anforderungen"]
    end
    LH -- "begrenzt was<br/>geliefert werden darf" --> SP
    SP -- "wird visualisiert durch" --> AR
    ADR["ADR<br/>(begründet Lösungswahl)"] -. "darf schärfen" .-> SP
    ADR -. "darf NICHT schärfen" .-x LH
    style LH fill:#fff4d6,stroke:#d4a017
    style SP fill:#e0f0e0,stroke:#3a8a3a
    style AR fill:#dceaff,stroke:#3366cc
```

Drei Schichten, drei Änderungs-Prozesse. Die kritische Hard Rule
(Beispiel `c-hsm-doc`, siehe [`fallstudien.md`](fallstudien.md)):
**ADRs DÜRFEN die Spezifikation schärfen, DÜRFEN NICHT das Lastenheft
schärfen.** Diese eine Regel kapselt die gesamte Trennung von
"wir liefern" und "wir versprechen".

### ID-Schema als Klammer

Ein konsistentes Präfix (`LH-*`, `HSM-*`, `GG-*`) verbindet:

* Anforderung in `spec/lastenheft.md`
* Make-Target-Kommentar (`coverage-gate: ## LH-FA-BUILD-008`)
* ADR-Body (`Bezug: HSM-LESE-004`)
* Commit-Message
* PR-Beschreibung

Damit wird der Traceability-Constraint maschinell prüfbar.

## harness/README.md als Einstiegspunkt

Pro Repo bündelt eine einzige Datei alles, was ein Agent oder ein neuer
Mensch zuerst lesen muss. Pflichtgliederung:

```
# Harness

## Purpose                  # ein Absatz, was diese Datei ist (und was nicht)
## Source precedence        # die obige Tabelle, repo-spezifisch
## Guides                   # Tabelle der Feedforward-Quellen
## Sensors                  # Tabelle der Feedback-Gates (nur real existierende!)
## Traceability rules       # Welche IDs müssen in Commits/PRs auftauchen?
## Safety and scope boundaries  # repo-spezifische Hard Rules
## Minimal agent workflow   # der 8-Schritt-Pfad (siehe Modul 9)
```

Wichtig: Die Sensors-Tabelle darf keine Befehle behaupten, die es im Repo
nicht gibt. Halluzinierte Gates sind die häufigste Form von Harness-Lüge.

Die Sensors-Tabelle trägt **keinen Lauf-Status** ("grün"/"rot"):
Lauf-Wahrheit pro Commit lebt in CI (Badges/Dashboard), also in höher
rangierten Quellen, nicht in `harness/README.md` (Rang 9). Strukturell
rote Gates werden als Carveout in `docs/plan/carveouts/` dokumentiert
(Modul 7); die Bindung-Spalte der Tabelle (`Target | Vertrag | Bindung`)
verweist auf die `CO-<NNN>`-ID, die Begründung lebt im Carveout, nicht
hier. Damit ist "rot dokumentieren, nicht verstecken" ortsdiszipliniert:
es geschieht im Carveout-Index, nicht in einer Status-Spalte, die sich
selbst grünfärben kann.

Die Bindung-Spalte trägt vier **kanonische Klassen**:

- **ADR-Bindung** (`ADR-<NNN>`) — Gate setzt eine Architektur-Entscheidung
  durch.
- **Carveout-Bindung** (`CO-<NNN>`) — Gate bewusst geschwächt, mit
  Auflösungs-Trigger und Folge-Slice (Modul 7).
- **Kalibrierungs-Bindung** (`Schwelle X %, M<n> → Y %`) — bewegliche
  Eichung mit Meilenstein-Schaltplan.
- **Reproduzierbarkeits-Bindung** (Image-Hash, Toolchain-Pin) — Gate
  hängt an bit-identischem Artefakt (Modul 14).

Repos können **weitere Klassen** einführen — etwa Anforderungs-Bindung
(`LH-…`), Compliance-Bindung (Regulatorik-Artikel) oder
Modell-Version-Bindung (für KI-Evals). Diese werden im **repo-lokalen
Konventionsdokument** deklariert (Default-Pfad `harness/conventions.md`,
Form projektabhängig), damit ein Reviewer sie als legitim erkennt und
nicht als Tippfehler abtut. Eine Bindung ohne Deklaration ist eine
stille Setzung — und damit eine Harness-Lüge in derselben Klasse wie
ein halluziniertes Gate.

## harness/conventions.md als Konventionsspeicher

`harness/conventions.md` trägt die **repo-lokalen Strukturregeln** und
Adaptionen ggü. der adoptierten Baseline (Kurs, interner Standard,
Industrie-Norm). Sie ist **Pflicht** (Existenz), ihre Form (Einzeldatei
vs. Verzeichnis, ADR-artig vs. Prosa) ist **Wahl** — projektabhängig
nach Projektgröße, Adaptions-Frequenz, Audit-Tiefe.

Pflichtgliederung (Default-Form als Einzeldatei):

| Abschnitt | Inhalt |
|---|---|
| Purpose | was die Datei trägt, was nicht |
| Baseline | welche Konvention adoptiert, mit Stand/Version |
| Adoptierte Konventions-Quellen | Pointer extern (Kurs/Standard) und in-Repo (Templates) |
| Adaptions-Block | ADR-artige Liste der Abweichungen ggü. Baseline (`MR-<NNN>` mit Datum, Geltungsbereich, Begründung, Auflösungs-Trigger oder "permanent") |
| Zusatzklassen-Deklaration für Sensors-Bindung | repo-spezifische Bindung-Klassen jenseits der vier kanonischen (`LH-…`, Compliance, Modell-Version) |
| Modus-Deklaration pro Sub-Area | Greenfield · Brownfield (mit Konvergenz-Auftrag) · Hybrid |
| Glossar (optional) | repo-spezifische Begriffe, die nicht im Kurs-Glossar stehen |

Wichtig: `harness/conventions.md` dupliziert keinen Baseline-Text — sie
verweist und ergänzt. Eine Kopie ginge gegen die Baseline in Drift,
sobald letztere sich weiterentwickelt. Zwei Quellen derselben
Konvention sind dasselbe Drift-Risiko, das die Source-Precedence-Regel
für Spec/ADR adressiert — hier in der Form-Ebene.

Vorlage:
[`/lab/templates/harness/conventions.template.md`](../../../lab/templates/harness/conventions.template.md).
Worked Example:
[`/lab/example/harness/conventions.md`](../../../lab/example/harness/conventions.md).

## Harness-Bootstrap

*Harness-Bootstrap* bezeichnet den **Einstiegsprozess** in den
Harness-Lebenszyklus eines Repos — der Weg von "leeres Repo" oder
"Repo ohne Harness" bis zur Stelle, an der inhaltliche Arbeit (Slices,
Code) auf einem etablierten Harness aufsetzt. Es ist eine *Trajektorie
durch Dokument-Zustände*, kein *Ereignis*. Konkreter Walkthrough mit
Schritten in [Modul 1](../01-spec-und-architektur/modul-01-entwicklungszyklus.md#worked-example-einen-source-precedence-block-aus-einem-konfliktbehafteten-repo-destillieren).

> **Begriffsklärung:** "Harness-Bootstrap" meint hier den
> Einstiegsprozess in den Harness. Nicht zu verwechseln mit
> *Bootstrap-aware Gate* ([Modul 13](../04-qualitaet/modul-13-quality-gates.md)) — das ist ein
> einzelnes Gate mit Reifestufe und Hochschalt-Trigger (Coverage 0 →
> 70 %). Beide Begriffe teilen das Wort, sind strukturell verschieden:
> *Harness-Bootstrap* betrifft den **Repo-Lebenszyklus**,
> *Bootstrap-aware Gate* die **Reifestufe eines Sensors**.

### Was ist eine Sub-Area?

Eine *Sub-Area* ist eine **Doku-/Code-Sektion, die als Träger einer
Modus-Entscheidung dient** — mit eigener Konventions-Härte (eigene
`MR-NNN` möglich), eigener Inventur-Linie und eigener Pfad-/Datei-Familie
im Repo. Sie ist nicht das Repo (zu grob) und nicht der Slice (ein Slice
*berührt* Sub-Areas, *trägt* aber keinen Modus).

*Modul, Verzeichnis, Komponente* (siehe §Modus pro Sub-Area unten) sind
die **typischen Träger** — sie nennen, *welche Strukturen* eine Sub-Area
sein können. Ob eine konkrete Struktur als Sub-Area **qualifiziert**,
entscheiden drei Inklusions-Achsen (bottom-up):

| Achse | Test | erfüllt, wenn … |
|---|---|---|
| **1 — Konventions-Härte** | Ist eine eigene `MR-NNN`-Adaption plausibel formulierbar? | … die Sektion eine eigene Strukturregel tragen *könnte* (nicht: schon trägt). |
| **2 — Inventur-Linie** | Ist eine eigene Diskrepanz-Bericht-Zeile sinnvoll? | … Code-Bestand und Doku-Aussage dieser Sektion als Paar abgleichbar sind, ohne dass eine Nachbar-Sub-Area mitgezogen werden muss. |
| **3 — Struktureller Cluster** | Gibt es eine eigene Pfad-/Datei-Familie? | … ein eigenes Verzeichnis, Dateimuster oder Konventions-Präfix die Sektion trägt. |

**Schwelle: mindestens zwei der drei Achsen.** Eine Achse allein ist zu
schwach — der typische Fall ist *Struktur ohne Substanz*: ein Verzeichnis
existiert (Achse 3), hat aber keine eigene Konvention (Achse 1) und keine
eigenständig abgleichbare Inventur-Linie (Achse 2). Das ist noch keine
Sub-Area, sondern eine **Sub-Area-Aspirantin** — in winzigen Repos
normal, mit wachsender Struktur wird daraus eine Sub-Area.

**Positiv-Beispiele:**

- *Audit-Logging* — eigene MR-Adaption denkbar (Format-Standard für
  Log-Einträge, Achse 1), eigene Inventur-Linie (entstehen alle
  Audit-Events wie spezifiziert?, Achse 2), eigener `services/audit/`-
  Pfad-Cluster (Achse 3). Alle drei → klar Sub-Area.
- *Test-Infrastruktur* — eigenes Pfadnaming-Schema (Achse 3) und eine
  eigene Inventur-Linie (Tests ohne `LH-*`-ID als Diskrepanz, Achse 2).
  Zwei von drei → Sub-Area.

**Negativ-Beispiele:**

- *"Backend"* ist zu grob — verletzt Achse 1 (keine *einzelne*
  `MR-NNN`-Adaption denkbar; API-Pattern, Persistence-Layout und
  Hintergrund-Jobs bräuchten je eigene) und Achse 3 (mehrere
  Pfad-Familien). *"Backend"* bündelt typischerweise *drei* Sub-Areas.
- *"Frontend"* — analog: eigene Konventionen pro Schicht (Komponenten,
  State, Styling), keine gemeinsame Inventur-Linie. Auch hier:
  ausdifferenzieren, nicht als *eine* Sub-Area führen.

> **Abgrenzung zu den vier Modus-Pflichtkriterien.** Die drei Achsen
> hier beantworten *ob eine Struktur eine Sub-Area ist* (Granularitäts-
> Gate). Sie sind **nicht** zu verwechseln mit den vier Pflichtkriterien,
> mit denen [Modul 5](../02-planung/modul-05-planning-harness.md#worked-mini-example-bootstrap-modus-pro-sub-area-für-einen-slice-begründen)
> begründet, *welcher Modus* (GF/BF/Hybrid) für eine bereits erkannte
> Sub-Area gilt (Konventionen-Dichte · Phase-Reife · Evidenz-/Diskrepanz-
> Risiko · Reconciliation-Aufwand). Erst Inklusion (hier), dann
> Modus-Wahl (Modul 5).

**Aggregation — die Kehrseite der Inklusion.** Wie die Schwelle ein
*Zuviel an Struktur* abweist (die Aspirantin oben), weist dieselbe Logik
rückwärts gelesen ein *Zuwenig an Trennung* ab: Zwei Sub-Areas, die
**permanent dieselben Trigger** erzeugen *und* **dieselbe Modus-Aussage**
tragen, sind in Wahrheit *eine* — sie getrennt zu führen erzeugt zwei
Inventur-Linien ohne eigene Diskrepanz (Anti-Refactoring). Die
Diagnose-Frage ist die Achsen-Frage rückwärts: *„Feuern die beiden je
**unabhängig** — eigener Trigger, eigene `MR-NNN`?"* Über mehrere Wellen
nein → zusammenführen; sobald eine Hälfte eine eigene Adaption oder
Inventur-Linie bekommt (Achse 1/2 divergiert) → trennen. Aggregation ist
damit keine Einmal-Entscheidung, sondern eine wiederkehrende
Wartungs-Praxis. Faustregel: *zwei Aspirantinnen, die nie getrennt feuern,
sind eine Sub-Area; eine Sub-Area, deren Hälften auseinanderdriften, sind
zwei.* Beispiel aus dem Lab: `harness/conventions.md` führt `tests/`,
`evals/` und `verification/` als *eine* Sub-Area, weil sie dieselbe
Determinismus-/Golden-Konvention teilen und nie unabhängig feuern; bekäme
`evals/` eine eigene Golden-Set-Rotations-`MR`, die `tests/` nicht teilt,
wäre genau das der Trigger zur Trennung.

### Modus pro Sub-Area: Greenfield vs Brownfield

Pro Sub-Area eines Repos (Modul, Verzeichnis, Komponente) wird ein
**Modus** deklariert (im Adaptions-Block von
`harness/conventions.md`). Die Modus-Wahl bestimmt die
*Trigger-Richtung* — wer wem folgt:

| Modus | Trigger-Richtung | Bild im Kopf |
|---|---|---|
| **Greenfield** (GF) | Doc → Code | Spec führt, Code folgt. "Wir versprechen X, dann liefern wir X." Steady-State. |
| **Brownfield** (BF) | Code → Doc | Code existiert, Doku folgt. Inventur des Bestands. **Übergangs-Modus mit Konvergenz-Auftrag** zu GF. |
| **Hybrid** | gemischt pro Sub-Sub-Area | Realistisch: alte Komponenten BF, neue GF. |

**Konvergenz-Auftrag.** BF ist *keine Daueroption*. Jede BF-Sub-Area
trägt eine **Graduation-Bedingung** (im Adaptions-Block dokumentiert):
*was muss erfüllt sein, damit die Sub-Area in GF-Modus wechselt?*
Typisch: alle entdeckten Diskrepanzen aufgelöst (als Carveouts oder
Reconciliation-Slices); Spec/ADR/Sensors decken Code-Stand ab;
ID-Schema retrofitted. Eine BF-Sub-Area ohne Graduation-Plan ist eine
*permanente Ausnahme als temporär getarnt* — analog zur
Carveout-Disziplin in [Modul 7](../02-planung/modul-07-carveouts.md).

Permanente BF-Erklärung (für Code, der absehbar entfernt wird —
Legacy, Drittsystem-Adapter) ist möglich, mit Begründung und
Folge-Slice.

### Sektionsweise Reife: Phasen pro Dokument

Ein Harness-Dokument ist während Bootstrap nicht "entweder leer oder
fertig". Sektionen reifen mit unterschiedlichem Tempo durch fünf
Phasen:

| Phase | Beschreibung |
|---|---|
| 0 — leer | Datei existiert nicht |
| 1 — Skelett | Template kopiert, Pflichtgliederung mit Platzhaltern |
| 2 — Outline | Top-Level ausformuliert, Details `<…>` |
| 3 — partiell | einige Sektionen voll, andere noch `<…>` |
| 4 — kohärent | alle Sektionen gefüllt, intern konsistent — *freigegeben* für Verweise von außen |
| 5 — stabil | Änderungen nur über Change-Process |

*Sektionen* eines Dokuments können in unterschiedlichen Phasen sein.
Beispiel: §Source precedence von `harness/README.md` kann durch
Template-Adoption früh auf Phase 2 sein, während §Sensors auf Phase 1
verharrt, bis das Makefile existiert. **Sektionsweise Reife ist Regel,
nicht Ausnahme** — Schreibreife wird sektionsweise beurteilt, nicht
dateiweise.

### Vier Trigger-Klassen

Während Bootstrap (und auch danach im Steering-Loop) lösen Änderungen
in einem Dokument *Folgeaktionen* in anderen aus. Vier Klassen:

| Klasse | Wirkung | Beispiel |
|---|---|---|
| **Sync-Trigger** | Pointer in einem Dokument muss in einem anderen ergänzt werden | Neuer Eintrag in `conventions.md` → Pointer in `harness/README.md` |
| **Promotion-Trigger** | Eintrag wandert aus "Nicht behauptet"-Block in Haupt-Tabelle | Make-Target real im Makefile entstanden → Sensor-Zeile gepromoted |
| **Cross-Reference-Trigger** | Wechselseitige Verlinkung zwischen Dokumenten | Neue ADR → Spec/Architektur verweisen darauf |
| **Acceptance-Trigger** | Phase-Übergang via Sign-off (z. B. ADR Proposed → Accepted) | ADR-Review-Runde abgeschlossen → bindend |

Trigger werden zwischen Bootstrap-Schritten ausgewertet — sie sind die
"Inbox" der nicht-Vorderscene-Arbeit. Eine zwischen Schritten
übersehene Trigger-Pflicht ist ein häufiges Drift-Symptom.

### Harness-Bootstrap-Ende vs Workflow-Beginn

Harness-Bootstrap ist *abgeschlossen*, wenn der Repo bereit ist für
inhaltliche Slices. In **Greenfield**: erster ADR akzeptiert,
Roadmap-Outline mit Welle-Sequenz, Sensors-Roster als "Nicht
behauptet"-Block. In **Brownfield**: Reconciliation-Backlog steht,
Konvergenzpfad zu GF ist sichtbar (mit ersten Reconciliation-Slices in
`open/`). Ab dann übernimmt der **Workflow** (Slice-Lebenszyklus,
Modul 5–9). Bootstrap und Workflow sind getrennte Lebenszyklen — kein
Übergang ohne Sichtbarkeit.

### Verbindung zum Steering-Loop

Harness-Bootstrap ist im Grunde der **Steering-Loop ([Modul 11](../04-qualitaet/modul-11-verification.md)),
einmal in Folge angewendet, bis Graduation erreicht ist**. Das
Werkzeug ist identisch (Beobachtung → Guide/Sensor); was sich
unterscheidet, ist die Anwendungsphase: Bootstrap = initial bis
Steady-State; Steering-Loop = laufend im Steady-State. Wer den
Steering-Loop versteht, versteht Bootstrap — und umgekehrt.

### Querverweise

- **[Modul 2 — Harness-Bootstrap](../01-spec-und-architektur/modul-02-harness-bootstrap.md)**: ausgearbeiteter Lehrtext mit GF/BF-Walkthroughs, Trigger-Klassen-Inline-Ankern und Phasen-Karten-Übung — Vollform des Bootstrap-Konzepts.
- **Modul 1 §Schritt 0** ([§Source precedence](../01-spec-und-architektur/modul-01-entwicklungszyklus.md#worked-example-einen-source-precedence-block-aus-einem-konfliktbehafteten-repo-destillieren)): kompakter Vorgriff auf das Modus-Konzept als Eingang in den Lebenszyklus (Baseline und Modus festlegen plus den sechs Folge-Schritten); Vollform in Modul 2.
- **[`fallstudien.md` §Beobachtung aus dem Ist-Zustand](fallstudien.md#beobachtung-aus-dem-ist-zustand)**: die vier Beispiel-Repos in GF-/BF-Modus klassifiziert.
- **§harness/conventions.md als Konventionsspeicher** (oben): Adaptions-Block trägt Modus-Deklaration pro Sub-Area; Graduation-Bedingung wird dort dokumentiert.

## Traceability-Constraint

Keine relevante Änderung ohne Bezug zu mindestens einem der folgenden Punkte:

* Requirement-ID
* Architektur-ID oder Architekturprinzip
* ADR-ID
* Test, Gate oder Demo-Artefakt
* Dokumentations-Update, falls ein öffentlicher Vertrag betroffen ist

Das ist eine *computational feedforward*-Kontrolle (siehe
[`klassifikation.md`](klassifikation.md)): ein Commit-Hook prüft, dass
die Nachricht mindestens eine ID enthält. Billig, deterministisch, und
sie zwingt den Implementation-Agent in die Source-Precedence-Kette zurück.
