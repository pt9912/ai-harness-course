# Lösung — Modul 14: Observability

Zugehöriges Modul: [Modul 14 — Observability](../05-betrieb/modul-14-observability.md).

## Selbstcheck-Antworten

### (Erinnern) Welche drei Telemetrie-Typen unterscheidet der Kurs?

| Typ | Antwortet auf | Werkzeug |
|---|---|---|
| **Logs** | *was* passierte | strukturierte Log-Aggregation |
| **Metriken** | *wie oft, wie schnell, wie viel* | Prometheus/OpenMetrics-Pendant |
| **Traces** | *wer rief wen, in welcher Reihenfolge* | OpenTelemetry/Jaeger |

Drei verschiedene Fragen, drei verschiedene Werkzeuge. Sie überlappen
sich nicht — Logs ersetzen Traces nicht, und Metriken ersetzen Logs
nicht. Ein Agent-System mit nur einem Typ ist forensisch nicht
antwortfähig:

- *Nur Logs:* Cost-Attribution unmöglich (das ist eine Metrik-Frage),
  Tool-Call-Ketten nicht rekonstruierbar (das ist eine Trace-Frage).
- *Nur Metriken:* der einzelne Vorfall lässt sich nicht erzählen.
- *Nur Traces:* die *Häufigkeit* eines Problems über Zeit verschwindet.

Im Kurs gilt: alle drei Typen mit demselben `slice.id`-Korrelations-Feld,
sodass eine Slice-Bearbeitung über Logs, Metriken und Traces hinweg
verfolgbar ist.

### Welche drei Felder muss ein Tool-Call-Span mindestens tragen?

Mindestens:

1. **`tool.name`** — welches Tool wurde aufgerufen.
2. **`tool.arguments`** — was waren die Eingabe-Parameter (ggf. redacted für PII, aber strukturell vorhanden).
3. **`tool.result.status`** — Erfolg/Fehler, idealerweise mit Fehlerklasse.

Üblich darüber hinaus:

- `tool.duration_ms` — Latenz.
- `tool.cost.tokens_in`/`tokens_out` (bei LLM-Tools).
- `tool.parent_span_id` — Verkettung in der Agenten-Schleife.
- `agent.role` — welche Rolle (Planner, Implementer, …) den Call gemacht hat.

Was *fehlen* darf:

- Der vollständige Output, wenn er groß ist. Hash und Truncation reichen für Forensik; den vollen Inhalt nur on-demand laden.

Wenn dein Tool-Call-Span weniger als die ersten drei Felder hat,
kannst du den Lauf nicht reproduzieren. Wenn er mehr als die genannten
fünf hat ohne Begründung, ist er zu teuer pro Span — Span-Kosten sind
selbst ein Budget.

### Wo schlägt sich ein Prompt-Cache-Miss in den Metriken nieder?

Drei Stellen, je nach Provider:

1. **`llm.cache.hit_ratio`** als laufender Wert (sinkt bei Miss).
2. **`llm.tokens_in.uncached`** + **`llm.tokens_in.cached`** als zwei separate Counter — die Summe ist die Eingabe, die Aufteilung zeigt den Cache-Effekt.
3. **`llm.cost.usd`** steigt erkennbar — Cache-Hits sind typisch 10x billiger als Misses.

Operative Konsequenz: Ein Span ohne Cache-Felder bedeutet *Blindflug*
über Kosten. Bei einem Steering-Loop-Schritt "Kosten zu hoch in
Welle X" ist der erste Blick: hat die Welle Cache-freundliche
Kontextstücke vorne, oder injiziert jeder Slice einen neuen Block, der
den Cache invalidiert?

## Übungshinweise

### Analyse eines KI-Agenten-Laufs im Trace-Viewer

Maßstab:

- Du kannst die *Sequenz* der Tool-Calls in Reihenfolge rekonstruieren.
- Du kannst zu jedem Tool-Call die Latenz benennen.
- Du findest den teuersten Tool-Call binnen einer Minute.
- Du erkennst Wiederholungen (gleicher Tool-Call mit gleichen Args) — ein Symptom für fehlendes Caching oder schlechten Loop-Abbruch.

### Identifiziere den teuersten Tool-Call und begründe, ob er nötig war

Drei Fragen, die der Lerner beantworten soll:

1. **Quelle**: Welches Step im Plan hat den Call ausgelöst?
2. **Ergebnis**: Was hat der Agent mit dem Ergebnis gemacht? Ging es ins Output ein?
3. **Vermeidbarkeit**: Wäre der Call mit besserem Kontext (AGENTS.md, ADR, Spec) vermeidbar gewesen? Wenn ja, ist das ein Steering-Loop-Eintrag.

Häufig zeigt sich: der teuerste Call ist ein File-Read, der dieselbe
Datei wie drei Schritte vorher liest. Caching im Tool-Layer fehlt —
oder der Agent hat das Result aus dem vorherigen Span nicht im
Kontext gehalten.

## Häufige Fehler

- **Span ohne Tool-Result-Hash.** → Forensik geht verloren, wenn das Ergebnis-Volumen das Logging-Budget sprengt.
- **Trace nur in Produktion, nicht in Lab.** → Replay-Läufe sind blind. Lab muss denselben OTel-Pfad haben wie Prod.
- **Budget-Alerts ohne Slice-Attribution.** → "Wir haben heute $400 verbraten" weiß niemand zuzuordnen. Spans brauchen ein `slice.id`-Attribut.

## Verweise

- Entropy Management als Observability-Konsument: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)
- Vorherige Lösung: [Modul 13](modul-13-loesung.md)
- Nächste Lösung: [Modul 15](modul-15-loesung.md)
