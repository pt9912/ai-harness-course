# Modul 15 — Observability

> **Aufwand:** ca. 75 Min Lesen · 90 Min Übung.

> **Segmenting-Empfehlung (Sweller).** Dieses Modul trägt sechs Lernziele
> — das Maximum im Kurs — und zerfällt natürlich in zwei Hälften.
> **Teil A (Telemetrie lesen & diagnostizieren, LZ 1–4):** Mini-Glossar ·
> Engage · Lernziele · Themen · Kernidee · Typische Fehlvorstellungen ·
> Worked Example (ein Span zurück bis zur Lastenheft-ID). **Teil B
> (Sensoren & Schemata bauen, LZ 5–6):** Übungen · Reflexion · Selbstcheck.
> Lies Teil A und arbeite das Worked Example *durch*, bevor du Teil B
> öffnest — der Trenner steht sichtbar vor den Übungen
> ([§Pause-Punkt](#pause-punkt-lesen--bauen)). Wer A und B in einer
> Sitzung liest, hält am Ende sechs Konzepte gleichzeitig offen — genau
> die Überlast, die das Modul vermeiden will.

## Mini-Glossar für dieses Modul

Fünf neue Begriffe — Volldefinitionen in
[`../grundlagen/konventionen.md`](../grundlagen/konventionen.md#kernbegriffe).

| Begriff | Ein-Satz-Definition | Bild im Kopf |
|---|---|---|
| **Trace** | Geordnete Folge von Spans über mehrere Komponenten — Antwort auf "wer rief wen". | Telefonprotokoll: Anrufer, Empfänger, Reihenfolge. |
| **Span** | Ein einzelner Schritt im Trace mit Anfang, Ende und Attributen. | eine Zeile im Protokoll, mit Anhang. |
| **Korrelations-ID** | Schlüssel (z. B. `slice.id`), der Spans über Komponenten hinweg verbindet. | das Etikett am Paket, das es durch die Sortieranlage führt. |
| **Cache-Hit-Rate** | Anteil der Token-Eingaben, die aus dem Prompt-Cache bedient wurden — Kosten- *und* Sicherheits-Metrik. | Trefferquote eines Wörterbuchs vor dem Übersetzen. |
| **Token-Attribuierung** | Zuordnung der Token-Kosten eines Modelllaufs zu Slice, Rolle, Tool-Call. | Buchhaltungs-Splitting eines Sammelpostens auf Kostenstellen. |

## Engage

Buchhaltung fragt: *"Was hat der KI-Slice SL-024 gekostet?"* Du weißt:
es waren Modell-X-Tokens, aber wie viele und in welcher Verteilung über
die acht Tool-Calls? Wenn du nicht antworten kannst, bist du in einer
Klasse von KI-Projekten, die spätestens beim zweiten Kostenreport gestoppt
werden. Token-Attribuierung ist nicht Bonus — sie ist Voraussetzung,
damit KI-Slices als reguläre Engineering-Slices behandelt werden können.

## Lernziele

Nach diesem Modul kannst du:

* OpenTelemetry-Traces eines Agentenlaufs *lesen* (Anwenden · prozedural),
* Token-Kosten pro Slice *attribuieren* (Anwenden · prozedural),
* Logs, Metriken und Traces *unterscheiden* und ein Telemetrie-Fehlszenario *zuordnen* (Analysieren · konzeptuell),
* einen Prompt-Cache-Miss in den Metriken *erkennen* (Analysieren · prozedural),
* Doku-Konsistenz-Drift mit einem Konsistenz-Agent *detektieren* (Bewerten · prozedural — Brücke zu *Entropy Management*),
* ein Tool-Call-Audit-Span-Schema *entwerfen*, das Slice-ID, Agent-Rolle und Cache-Status trägt, sodass Token-Kosten und Forensik bis zur Anforderungs-ID rückverfolgbar sind (Erschaffen · prozedural).

## Lab-Bezug

* [`../../../lab/example/otel/`](../../../lab/example/otel/) — reduziertes Trace-Fixture
* [`../../../lab/example/Makefile`](../../../lab/example/Makefile), Target `make trace RUN=sl-009-agent-run`

## Themen

* OpenTelemetry
* Logs (was passierte)
* Metriken (wie oft, wie schnell)
* Traces (wer rief wen)
* Kostenkontrolle (Token, Modell, Cache-Hit)
* Doku-Konsistenz-Agent (AGENTS.md ↔ Code) als Drift-Detector

## Harness-Einordnung

Observability ist Eingangs- und Ausgangskanal für *Entropy Management*
(siehe [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)):
ohne Telemetrie weißt du nicht, wo der Harness rostet.

## Kernidee

Ein Agenten-Lauf ohne Trace ist ein Vorgang ohne Beleg. Du weißt, dass
es passiert ist; du weißt nicht, *was* passiert ist.

## Typische Fehlvorstellungen

- **"Logs reichen."** — Logs sagen *was passierte*, nicht *wer wen wann rief*. Trace ist die Antwort darauf.
- **"Metriken sind nur für Performance."** — Metriken sind auch für *Kosten* (Token, Cache-Hit-Rate) und *Drift* (AGENTS.md-Konsistenz-Score).
- **"Prompt-Caching ist Modell-Sache."** — Nein. Cache-Hits zeigen sich erst in Metriken, wenn du sie misst. Wer Cache-Miss-Spikes nicht beobachtet, sieht Injection-Versuche und Drift-Symptome nicht.
- **"Trace teurer Tool-Call = unnötiger Tool-Call."** — Falsch. Manche teuren Calls sind nötig. Frage: lässt er sich durch Caching, Vorab-Filter oder Kontext-Verdichtung billiger machen?

## Worked Example: ein Span zurück bis zur Lastenheft-ID

> **Wenn du End-to-End-Traces in deinem Repo bis zur Anforderungs-ID rückverfolgen kannst, springe zu [§Übungen](#übungen).** Die sechs Schritte sind die Schablone für den ersten oder zweiten Fall — wer die Kette beherrscht, gewinnt durch erneutes Mitlesen wenig (Expertise-Reversal). Übung 3 (End-to-End-Trace bis LH-ID) setzt das Worked Example sofort in die eigene Repo-Realität.

**Ausgangs-Span:** Du öffnest den Trace zu `sl-009-agent-run`. Der
teuerste Span trägt:

```json
{
  "span_id": "impl-2",
  "name": "tool_call:writer.write_index",
  "duration_ms": 412,
  "tool.name": "writer.write_index",
  "tool.arguments.redacted": {"docs": 100, "target": "internal/index/store.bin"},
  "tool.result.status": "ok",
  "requirement.id": "LH-FA-IDX-003",
  "adr.id": "ADR-0012",
  "tokens": {"input": 2480, "output": 187},
  "cache": {"hit": false}
}
```

**Schritt 1 — Slice-ID aus dem Trace lesen.**
Der Trace-Header trägt `slice.id = slice-009` (Lab-Schreibweise mit
Bindestrich) und `requirement.refs = ["LH-QA-02", "LH-FA-IDX-003"]`.
Innerhalb des Spans selbst hängt der teure `writer.write_index`-Call
zusätzlich an `requirement.id = LH-FA-IDX-003` — der direkte Anker
zur konkreten Anforderung.

**Schritt 2 — Slice-Datei finden.**
[`docs/plan/planning/done/slice-009-tie-break-determinismus.md`](../../../lab/example/docs/plan/planning/done/slice-009-tie-break-determinismus.md).
Die Lab-Datei trägt keine YAML-Frontmatter, sondern eine Klartext-
Bezug-Zeile:
```markdown
**Bezug:** LH-QA-02 (Reproduzierbarkeit, primär), LH-FA-IDX-003
(Index-Schreib-Idempotenz, sekundär — deterministischer Tie-Break ist
Voraussetzung für bit-identische Schreib-Ergebnisse), ADR-0003
(Index-Format), ADR-0012 (Index-Write-Strategie, sekundär).
```
Das ist eine *alternative Operationalisierung* zum Frontmatter-Schema
(siehe Notiz unten). Lesepfad bleibt derselbe: die Zeile führt zu den
ADRs und Anforderungen.

**Schritt 3 — ADR aufrufen.**
[`docs/plan/adr/0012-index-write-strategy.md`](../../../lab/example/docs/plan/adr/0012-index-write-strategy.md).
Kopf:
```markdown
**Status:** Accepted
**Bezug:** LH-FA-IDX-003 (Index-Schreib-Idempotenz und Atomarität),
ADR-0003 (Index-Storage-Format)
```
Bestätigt: die ADR begründet die Index-Write-Strategie (Temp-File +
Atomic Rename) und referenziert dieselbe LH-ID, die der Span trägt.
Die Kette schließt sich.

**Schritt 4 — Lastenheft prüfen.**
[`spec/lastenheft.md` § `LH-FA-IDX-003`](../../../lab/example/spec/lastenheft.md):
```markdown
### LH-FA-IDX-003 — Index-Schreib-Idempotenz und Atomarität
Anforderung: Index-Schreiboperationen sind idempotent (gleicher
Datei-Hash bei gleicher Eingabe) und atomar (kein partieller
Index-Stand beobachtbar).
Akzeptanzkriterien: Happy / Boundary (Crash-Recovery via fsync+rename)
/ Negative (E099 bei nicht beschreibbarem Verzeichnis).
```
Bestätigt: der teuerste Tool-Call (im Span) bedient eine konkrete
Lastenheft-Anforderung mit Akzeptanzkriterien.

**Schritt 5 — Make-Target-Kommentar gegenprüfen.**
ADR-0012 §Fitness Function definiert die maschinelle Prüfung:
Architekturtest pro Sprache erzwingt die `rename`-Sequenz im
Writer-Code; Property-Test (slice-013) vergleicht zwei aufeinander
folgende `writer.write_index`-Hashes. Damit ist die Kette **auch
maschinell prüfbar**: ein Commit, der den `rename`-Aufruf entfernt,
würde `make arch-check` rot machen
([`konventionen.md` §Traceability-Constraint](../grundlagen/konventionen.md#traceability-constraint)).

**Schritt 6 — Bruchpunkt benennen.**
Vollständige Kette:
```
trace.slice.id            →  slice-009
span.requirement.id       →  LH-FA-IDX-003
                          →  done/slice-009-tie-break-determinismus.md (Bezug-Zeile)
                          →  ADR-0012 (Bezug: LH-FA-IDX-003)
                          →  LH-FA-IDX-003 (Akzeptanzkriterien)
                          ↩  ADR-0012 §Fitness Function prüft Architekturregel
```
Schwächste Stelle in *diesem* Beispiel-Repo: der Lesepfad zwischen
Slice-Datei und ADRs läuft über eine *Klartext*-Zeile, nicht über ein
maschinell parsbares Frontmatter. Wenn die Bezug-Zeile umformuliert
wird, fehlt der direkte Anker. Steering-Loop-Aktion: entweder
Frontmatter-Pflichtfeld als Gate ergänzen (computational feedforward),
oder einen Doku-Konsistenz-Agenten die Bezug-Zeile prüfen lassen
(inferential feedback).

> **Operationalisierungs-Variante.** Ein anderes Repo kann denselben
> Lesepfad über YAML-Frontmatter abbilden:
> ```yaml
> ---
> id: SL-009
> adr_refs: [ADR-0012]
> lastenheft_refs: [LH-FA-IDX-003]
> ---
> ```
> Vorteil: maschinell trivial parsbar. Nachteil: zusätzliche Disziplin
> im Slice-Template. Das Lab wählt die Klartext-Variante, weil die
> bestehenden Slices ohne Frontmatter angelegt waren — Migration wäre
> teurer als der Komfort des Schemas. Die *Erschaffens-Leistung* dieses
> Moduls ist das Span-Schema mit IDs; *welche* Schreibvariante die
> Slice-Seite wählt, ist Repo-spezifisch.

Sechs Schritte, eine durchgängige Traceability. Vergleich im Lab:
[`../../../lab/example/otel/sl-009-agent-run.trace.json`](../../../lab/example/otel/sl-009-agent-run.trace.json)
(Span `impl-2` ist der `writer.write_index`-Call mit `requirement.id`
und `adr.id`).

## Pause-Punkt: lesen → bauen

> *Hier endet Teil A.* Wenn du der Segmenting-Empfehlung folgst (Box am
> Modul-Kopf), mach jetzt Pause und nimm Teil B (die Bau-Übungen) in einer
> *zweiten* Sitzung. Begründung: Das *Lesen* eines Spans (Teil A) und das
> *Entwerfen* eines Span-Schemas (Teil B) sind zwei verschiedene
> Tätigkeiten — in derselben Sitzung verschwimmen sie, und das
> Schema-Entwerfen gerät zur bloßen Nachahmung des gelesenen Beispiels
> statt zur eigenen Konstruktion.
>
> **Selbsttest vor Pause (60 Sekunden, ohne Spickzettel):**
>
> 1. Welche drei Telemetrie-Typen unterscheidet der Kurs, und welche Frage beantwortet jeder?
> 2. Welche drei Felder muss ein Tool-Call-Span mindestens tragen — und welches davon trägt die Token-Attribution?
> 3. Nenne die Kette vom Span bis zur Lastenheft-ID. An welcher Stufe würde sie in deinem Repo am ehesten reißen?
>
> Wenn du eine der drei Fragen unsicher beantwortest, wiederhole kurz das
> Worked Example — *nicht* in die Bau-Übungen weiterlesen. Sie setzen die
> Lese-Kette voraus.

## Übungen

* Analyse eines KI-Agenten-Laufs im Trace-Viewer
* **(Anwenden — aktiviert LZ 2)** *Token-Kosten attribuieren.* Identifiziere zunächst den teuersten Tool-Call und begründe, ob er nötig war. Dann *attribuiere* die Gesamt-Token des Laufs: summiere Input- und Output-Token pro `agent.role` (Planner · Architect · Implementer · Reviewer · Verifier) und gib an, welche Rolle den größten Anteil trägt — als Zahl *und* als Prozentsatz der Gesamtsumme. Wo ein Span keinen Rollen-Tag trägt (Sammelposten), entscheide begründet, wie du ihn aufteilst (anteilig nach Tool-Calls? dem auslösenden Slice zugeschlagen?) — genau das ist das Buchhaltungs-Splitting eines Sammelpostens auf Kostenstellen aus dem Mini-Glossar.
* **Cache-Hit-Rate spezifizieren** — aktiviert das Erschaffens-Lernziel
  zur Cache-Beobachtbarkeit und vorbereitet die Abschluss-Achse
  *Reproduzierbarkeit/exzellent* (siehe
  [`../abschluss/abschlussprojekt.md`](../abschluss/abschlussprojekt.md#achse-reproduzierbarkeit)).
  Skizziere die *drei* OTel-Counter, die du brauchst, um Cache-Hit-Rate
  *und* Cache-Miss-Spikes zu unterscheiden — und nenne pro Counter:

  | Frage | Antwort |
  |---|---|
  | Name | z. B. `prompt_cache_hits_total` |
  | Unit | Cardinality (Counter, Gauge, Histogram?) |
  | Labels | mindestens `slice.id`, `agent.role`, `model.version` |
  | Aggregation | Hit-Rate als `hits / (hits + misses)` — wo wird die Division ausgeführt: in der Metrik-DB oder im Dashboard? |

  Begründe, warum eine *einzelne* Metrik `cache.hit_ratio` nicht
  reicht: ohne separate Counter für Hits *und* Misses kannst du
  Cache-Miss-Spikes (Sicherheits-Indikator!) nicht von
  Cache-Hit-Rückgängen (Kosten-Indikator) trennen.

* **Doku-Konsistenz-Agent — Regeln formulieren** — aktiviert das
  Erschaffens-Lernziel zur Drift-Detektion und vorbereitet die
  Abschluss-Achse *Konsistenz/exzellent* (siehe
  [`../abschluss/abschlussprojekt.md`](../abschluss/abschlussprojekt.md#achse-konsistenz)).
  Schreibe **drei konkrete Konsistenz-Regeln**, die ein
  Doku-Konsistenz-Agent zwischen AGENTS.md und realen Make-Targets /
  Skill-Dateien / `harness/README.md` prüfen würde. Pro Regel:

  | Feld | Inhalt |
  |---|---|
  | **Regel-Name** | z. B. *"AGENTS.md-Befehl existiert im Makefile"* |
  | **Quelle** | welche Datei wird gelesen (z. B. `AGENTS.md` §Tool-Regeln) |
  | **Vergleichs-Ziel** | welche Datei wird dagegen geprüft (z. B. `Makefile`-Target-Namen) |
  | **Drift-Symptom** | wie sieht ein Drift-Treffer konkret aus (z. B. *"AGENTS.md nennt `make fullbuild`, Makefile kennt nur `make build`"*) |
  | **Lebenszyklus** | ist das ein Pre-commit-Check, Pre-integration, oder Continuous (vgl. [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md))? |

  Mindestens *eine* Regel muss die Hard Rule aus
  [Modul 13 §"Hard Rule (Doku-Disziplin)"](../04-qualitaet/modul-13-quality-gates.md#hard-rule-doku-disziplin)
  durchsetzen ("keine Befehle behaupten, die es nicht gibt").

* **End-to-End-Trace bis LH-ID** — aktiviert die Abschluss-Achse
  *Auditierbarkeit/exzellent* (siehe
  [`../abschluss/abschlussprojekt.md`](../abschluss/abschlussprojekt.md#achse-auditierbarkeit)).
  Nimm einen Span aus `make trace RUN=sl-009-agent-run`. Zeige
  **schriftlich** die vollständige Kette:

  ```
  span.attributes.slice.id  →  SL-<NNN>
                            →  Slice-Datei in docs/plan/planning/done/<NNN>.md
                            →  zugehöriger ADR-<NNN>
                            →  Lastenheft-ID LH-FA-<KÜRZEL>-<NNN>
  ```

  Für jede Pfeil-Stufe nenne die **konkrete Stelle**, an der die
  Verbindung dokumentiert ist (Feldname im Span, Frontmatter im
  Slice-Markdown, Bezug-Feld im ADR, ID-Tabelle im Lastenheft).

  Danach: **benenne die Stelle, an der die Kette in deinem eigenen Repo
  abreißen würde** — etwa wenn Make-Targets keine `## LH-...`-Kommentare
  tragen, oder wenn Slices nur Tickets im externen Tracker referenzieren.
  Die schwächste Stelle ist die einzige, die in der Abschluss-Bewertung
  zählt.

  Erwartetes Lernergebnis: Du kennst nach dieser Übung den
  *Bruchpunkt* deiner eigenen Traceability-Kette — nicht nur das
  Prinzip.

### Minimaler Übungspfad

```bash
cd lab/example
make trace RUN=sl-009-agent-run
```

Erwartete Beobachtung: Das Fixture enthält Rollen-, Slice-, Tool- und
Token-Felder. Beantworte zuerst nur drei Fragen: Welcher Span gehört zum
Reviewer? Wo ist der Cache-Miss? Welche ID verbindet Kosten mit dem
Slice? Danach erst lohnt ein voller Trace-Viewer.

> *Lab-Grenze:* Das Target *liest* ein fertiges Trace-Fixture. Das LZ
> "Tool-Call-Audit-Span-Schema *entwerfen*" (LZ 6, Erschaffen) wird
> erst durch die E2E-Trace-Übung oben (Span → Slice → ADR → LH-ID)
> abgerufen; das LZ "Doku-Konsistenz-Drift *detektieren*" (LZ 5) durch
> den Konsistenz-Agent-Lauf — der minimale Pfad ist Aufwärm-, nicht
> Ziel-Niveau.

## Reflexion

Vier Standardfragen aus [`../grundlagen/reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md)
nach der Trace-Analyse und der End-to-End-Trace-Übung.
Modul-spezifische Trigger:

- **Beobachtung:** Welche Korrelations-ID hat die Kette getragen? An welcher Stelle hattest du die Kette nur erraten? Welcher teure Tool-Call hatte einen vermeidbaren Cache-Miss?
- **2×2-Quadrant:** Trace-Pflichtfelder sind *computational feedforward*; Doku-Konsistenz-Agent ist *inferential feedback*.
- **Steering-Loop:** Span-Schema-Pflicht (`slice.id`, `agent.role`, `cache.hit`) als Gate? Frontmatter-Pflichtfeld im Slice-Markdown? Cache-Hit-Rate als Dashboard?
- **Conceptual Change:** Kandidaten in [`../grundlagen/lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "Logs reichen", "Metriken sind nur für Performance", "Prompt-Caching ist Modell-Sache").

## Selbstcheck

* **(Erinnern)** Welche drei Telemetrie-Typen unterscheidet der Kurs, und welche Frage beantwortet jeder?
* Welche drei Felder muss ein Tool-Call-Span mindestens tragen?
* Wo schlägt sich ein Prompt-Cache-Miss in den Metriken nieder?
* **(Bewerten — aktiviert LZ 5)** Woran erkennst du in Trace oder Metrik, dass AGENTS.md vom Code abgedriftet ist — welches konkrete Signal liest der Doku-Konsistenz-Agent (z. B. AGENTS.md-Befehl ohne passendes Make-Target), und ab welcher Schwelle (Konsistenz-Score) bewertest du den Drift als gate-relevant statt als Rauschen?
* **(Erschaffens-Prozess)** Welcher Schritt der End-to-End-Trace-Übung (Span → Slice → ADR → LH-ID) war bei dir der *unsicherste* — und woran lag es? (Erfahrungsgemäß: Frontmatter-Feldnamen oder die Make-Target-Kommentar-Konvention.)

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Drei Telemetrie-Typen + jeweilige Frage? | nur Logs genannt | Logs (*was passierte*) · Metriken (*wie oft, wie schnell, wie viel*) · Traces (*wer rief wen, in welcher Reihenfolge*). Drei verschiedene Fragen, drei verschiedene Werkzeuge. | + Operative Folge: Wer nur Logs hat, kann Cost-Attribution nicht durchführen (braucht Metriken) und Tool-Call-Ketten nicht rekonstruieren (braucht Traces). Ein Agent-System mit nur einem Typ ist forensisch nicht antwortfähig. |
| Drei Mindestfelder eines Tool-Call-Spans? | "Name, Zeit, Ergebnis." | `tool.name`, `tool.arguments` (redacted), `tool.result.status` plus Korrelations-IDs zu Slice/PR/Agent-Rolle. | + Begründung: Ohne `slice.id` / `requirement.id` ist Token-Attribuierung pro Slice nicht möglich; ohne `agent.role` bricht die Rollen-Trennung in der Forensik. |
| Prompt-Cache-Miss in den Metriken — wo? | "In den Kosten." | Anstieg der Token-Eingabe-Metrik *ohne* Anstieg der Cache-Hit-Rate-Metrik (`cache.hit_ratio` fällt). | + Zweck: Cache-Miss-Spikes sind oft Injection-Symptome (variable Eingaben umgehen Cache absichtlich) — Metrik dient also gleichzeitig Kosten- *und* Sicherheitsüberwachung. |
| Doku-Konsistenz-Drift in Trace/Metrik erkennen — Signal + Schwelle? | "AGENTS.md ist alt." | Konkretes Signal: Doku-Konsistenz-Agent meldet AGENTS.md-Befehl ohne passendes Make-Target (z. B. `make fullbuild` behauptet, Makefile kennt nur `make build`); Konsistenz-Score als Metrik (`agents_md.consistency_ratio`) fällt unter einen Schwellwert. | + Schwelle begründet: jeder behauptete-aber-fehlende Befehl ist *sofort* gate-relevant (Hard Rule Modul 13, keine Befehle erfinden), nicht erst ab einem Prozentsatz — Score-Verfall ist nur das Aggregat-Signal. Gegenbeispiel-Rauschen: ein neu hinzugefügtes Target ohne AGENTS.md-Eintrag ist *Vorwärts*-Drift (Doku hinkt nach), andere Härte als behauptete Geister-Befehle. |
| Unsicherster Schritt der E2E-Trace-Übung? | "Alles klar." (verdächtig) | Konkret benannter Schritt + Begründung (z. B. "Schritt 2 Slice-Datei finden, weil mein Repo kein einheitliches Frontmatter-Schema hat"). | + Pointe: der unsicherste Schritt *ist* der Bruchpunkt deiner Traceability-Kette. Wer ihn benennt, hat den ersten Steering-Loop-Eintrag schon halb formuliert. |

## Weiterlesen

* Nächstes Modul: [Modul 16 — Produktiver Betrieb](modul-16-produktiver-betrieb.md)
