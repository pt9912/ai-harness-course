# Modul 14 — Observability

> **Aufwand:** ca. 75 Min Lesen · 90 Min Übung.

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

* OpenTelemetry-Traces eines Agentenlaufs *lesen* (Anwenden),
* Token-Kosten pro Slice *attribuieren* (Anwenden),
* Logs, Metriken und Traces *unterscheiden* und ein Telemetrie-Fehlszenario *zuordnen* (Analysieren),
* einen Prompt-Cache-Miss in den Metriken *erkennen* (Analysieren),
* Doku-Konsistenz-Drift mit einem Konsistenz-Agent *detektieren* (Bewerten — Brücke zu *Entropy Management*),
* ein Tool-Call-Audit-Span-Schema *entwerfen*, das Slice-ID, Agent-Rolle und Cache-Status trägt, sodass Token-Kosten und Forensik bis zur Anforderungs-ID rückverfolgbar sind (Erschaffen).

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
- **"Trace teurer Tool-Call ≠ unnötiger Tool-Call."** — Manche teuren Calls sind nötig. Frage: lässt er sich durch Caching, Vorab-Filter oder Kontext-Verdichtung billiger machen?

## Worked Example: ein Span zurück bis zur Lastenheft-ID

> **Wenn du End-to-End-Traces in deinem Repo bis zur Anforderungs-ID rückverfolgen kannst, springe zu [§Übungen](#übungen).** Die sechs Schritte sind die Schablone für den ersten oder zweiten Fall — wer die Kette beherrscht, gewinnt durch erneutes Mitlesen wenig (Expertise-Reversal). Übung 3 (End-to-End-Trace bis LH-ID) setzt das Worked Example sofort in die eigene Repo-Realität.

**Ausgangs-Span:** Du öffnest den Trace zu `sl-009-agent-run`. Der
teuerste Span trägt:

```json
{
  "name": "tool_call:writer.write_index",
  "duration_ms": 412,
  "attributes": {
    "slice.id": "SL-009",
    "agent.role": "implementation",
    "tool.name": "writer.write_index",
    "tool.arguments": "<redacted>",
    "tool.result.status": "ok",
    "cache.hit": false,
    "tokens.input": 2480,
    "tokens.output": 187
  }
}
```

**Schritt 1 — Slice-ID aus dem Span lesen.**
`attributes.slice.id = SL-009`. Das ist der Anker — *jede* spätere
Verbindung läuft über diese ID.

**Schritt 2 — Slice-Datei finden.**
`docs/plan/planning/done/SL-009-index-writer.md`. Frontmatter:
```yaml
---
id: SL-009
status: done
closed_at: 2026-06-14
adr_refs: [ADR-0012]
lastenheft_refs: [LH-FA-IDX-003]
---
```
Das `adr_refs`-Feld führt zur ADR, `lastenheft_refs` zur Anforderung.

**Schritt 3 — ADR aufrufen.**
`docs/plan/adr/0012-index-write-strategy.md`. Kopf:
```markdown
* Status: Accepted
* Bezug: LH-FA-IDX-003
* Konsequenz: Fitness Function `arch-index-writer` in
  arch-check, siehe Modul 12.
```
Bestätigt: die ADR begründet die Index-Schreib-Strategie, und sie
referenziert dieselbe LH-ID wie der Slice. Die Kette schließt sich.

**Schritt 4 — Lastenheft prüfen.**
`spec/lastenheft.md` § `LH-FA-IDX-003`:
```markdown
## LH-FA-IDX-003: Index-Schreiben
**Anforderung:** Index-Schreiboperationen sind idempotent und atomar.
**Akzeptanzkriterien:** Happy/Boundary/Negative ...
```
Bestätigt: der teuerste Tool-Call (im Span) bedient eine konkrete
Lastenheft-Anforderung mit Akzeptanzkriterien.

**Schritt 5 — Make-Target-Kommentar gegenprüfen.**
`make verify SLICE=slice-009` Targets im Makefile tragen `## LH-FA-IDX-003`
als Kommentar. Damit ist die Kette **auch maschinell prüfbar**: ein
Commit ohne `LH-FA-IDX-003` in der Message würde der Traceability-Hook
ablehnen
([`konventionen.md` §Traceability-Constraint](../grundlagen/konventionen.md#traceability-constraint)).

**Schritt 6 — Bruchpunkt benennen.**
Vollständige Kette:
```
span.attributes.slice.id  →  SL-009
                          →  done/SL-009-index-writer.md (adr_refs, lastenheft_refs)
                          →  ADR-0012 (Bezug: LH-FA-IDX-003)
                          →  LH-FA-IDX-003 (Akzeptanzkriterien)
                          ↩  Make-Target-Kommentar prüft Bezug
```
Schwächste Stelle in *diesem* Beispiel-Repo: das Tool-Call-Audit-Log
enthält `slice.id`, aber nicht direkt `lastenheft_refs`. Wenn die
Slice-Datei in einer späteren Welle umbenannt oder ohne Frontmatter
gepflegt wird, **bricht die Kette an Schritt 2**. Steering-Loop-Aktion:
Frontmatter-Pflichtfeld-Check als Gate (computational feedback)
ergänzen.

Sechs Schritte, eine durchgängige Traceability. Vergleich:
[`../../../lab/example/otel/`](../../../lab/example/otel/) (reduziertes
Fixture, dieselbe Strukturlogik).

## Übungen

* Analyse eines KI-Agenten-Laufs im Trace-Viewer
* Identifiziere den teuersten Tool-Call und begründe, ob er nötig war
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

## Reflexion

Nach der Trace-Analyse und der End-to-End-Trace-Übung kurz **schriftlich**:

1. **Was ist beobachtbar passiert?** — Welche Korrelations-ID hat die Kette getragen? An welcher Stelle hattest du die Kette nur erraten? Welcher teure Tool-Call hatte einen vermeidbaren Cache-Miss?
2. **Welcher 2×2-Quadrant war Ursache?** — siehe [`konzeptkarte.md §2x2-Schnellanker`](../grundlagen/konzeptkarte.md#2x2-schnellanker). Trace-Pflichtfelder sind *computational feedforward*; Doku-Konsistenz-Agent ist *inferential feedback*.
3. **Welche konkrete Steering-Loop-Aktion folgt?** — Span-Schema-Pflicht (`slice.id`, `agent.role`, `cache.hit`) als Gate? Frontmatter-Pflichtfeld im Slice-Markdown? Cache-Hit-Rate als Dashboard?
4. **Welche eigene Vorstellung wurde unzufriedenstellend?** — Conceptual Change; Kandidaten in [`lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "Logs reichen", "Metriken sind nur für Performance", "Prompt-Caching ist Modell-Sache").

Eintragsformat, "Wann *nicht* reagieren" und Anti-Antworten: [`reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md).

## Selbstcheck

* **(Erinnern)** Welche drei Telemetrie-Typen unterscheidet der Kurs, und welche Frage beantwortet jeder?
* Welche drei Felder muss ein Tool-Call-Span mindestens tragen?
* Wo schlägt sich ein Prompt-Cache-Miss in den Metriken nieder?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Drei Telemetrie-Typen + jeweilige Frage? | nur Logs genannt | Logs (*was passierte*) · Metriken (*wie oft, wie schnell, wie viel*) · Traces (*wer rief wen, in welcher Reihenfolge*). Drei verschiedene Fragen, drei verschiedene Werkzeuge. | + Operative Folge: Wer nur Logs hat, kann Cost-Attribution nicht durchführen (braucht Metriken) und Tool-Call-Ketten nicht rekonstruieren (braucht Traces). Ein Agent-System mit nur einem Typ ist forensisch nicht antwortfähig. |
| Drei Mindestfelder eines Tool-Call-Spans? | "Name, Zeit, Ergebnis." | `tool.name`, `tool.arguments` (redacted), `tool.result.status` plus Korrelations-IDs zu Slice/PR/Agent-Rolle. | + Begründung: Ohne `slice.id` / `requirement.id` ist Token-Attribuierung pro Slice nicht möglich; ohne `agent.role` bricht die Rollen-Trennung in der Forensik. |
| Prompt-Cache-Miss in den Metriken — wo? | "In den Kosten." | Anstieg der Token-Eingabe-Metrik *ohne* Anstieg der Cache-Hit-Rate-Metrik (`cache.hit_ratio` fällt). | + Zweck: Cache-Miss-Spikes sind oft Injection-Symptome (variable Eingaben umgehen Cache absichtlich) — Metrik dient also gleichzeitig Kosten- *und* Sicherheitsüberwachung. |

## Weiterlesen

* Nächstes Modul: [Modul 15 — Produktiver Betrieb](modul-15-produktiver-betrieb.md)
