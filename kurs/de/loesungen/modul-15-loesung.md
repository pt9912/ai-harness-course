# Lösung — Modul 15: Observability

Zugehöriges Modul: [Modul 15 — Observability](../05-betrieb/modul-15-observability.md).

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

### (Analysieren — aktiviert LZ 4, Erkennen-Hälfte) Wo schlägt sich ein Prompt-Cache-Miss in den Metriken nieder?

Drei Stellen, je nach Provider:

1. **`llm.cache.hit_ratio`** als laufender Wert (sinkt bei Miss).
2. **`llm.tokens_in.uncached`** + **`llm.tokens_in.cached`** als zwei separate Counter — die Summe ist die Eingabe, die Aufteilung zeigt den Cache-Effekt.
3. **`llm.cost.usd`** steigt erkennbar — Cache-Hits sind typisch 10x billiger als Misses.

Operative Konsequenz: Ein Span ohne Cache-Felder bedeutet *Blindflug*
über Kosten. Bei einem Steering-Loop-Schritt "Kosten zu hoch in
Welle X" ist der erste Blick: hat die Welle Cache-freundliche
Kontextstücke vorne, oder injiziert jeder Slice einen neuen Block, der
den Cache invalidiert?

### (Bewerten — aktiviert LZ 5, Detektieren-Hälfte) Doku-Konsistenz-Drift erkennen — Signal und Schwelle

**Konkretes Signal:** Der Doku-Konsistenz-Agent vergleicht AGENTS.md
(und `harness/README.md`) gegen den realen Stand und meldet
Widersprüche — das prototypische Signal ist ein **behaupteter Befehl
ohne passendes Make-Target**: AGENTS.md nennt `make fullbuild`, das
Makefile kennt nur `make build`. Weitere Signale derselben Klasse:
Skill-Datei referenziert eine ADR-ID, die nicht existiert;
Sensors-Tabelle listet ein Gate, das im Makefile fehlt.

**Als Metrik:** ein Konsistenz-Score wie
`agents_md.consistency_ratio` (bestätigte Aussagen ÷ geprüfte
Aussagen). Fällt der Score, driftet die Doku — der Trend ist das
Aggregat-Signal über Zeit.

**Schwelle — und ihre Asymmetrie:** Für die Gate-Relevanz zählt die
*Drift-Richtung*, nicht ein Prozentsatz:

- **Behauptete-aber-fehlende Befehle** (Geister-Befehle) sind *sofort*
  gate-relevant — Schwelle 1, nicht X % — denn das ist die Hard Rule
  aus Modul 13 §Doku-Disziplin ("keine Befehle behaupten, die es nicht
  gibt"), und der Implementation-Agent vertraut ihnen.
- **Vorwärts-Drift** (neues Target ohne AGENTS.md-Eintrag — die Doku
  hinkt nach) ist Rauschen bzw. MEDIUM-Pflegebedarf: niemand wird in
  die Irre geführt, es fehlt nur Abdeckung.

Wer beide Richtungen in einen einzigen Score mischt und erst "ab 80 %"
reagiert, lässt Geister-Befehle wochenlang stehen, weil viel
harmloser Vorwärts-Drift den Score trägt.

### (Erschaffens-Prozess) Welcher Schritt der E2E-Trace-Übung war der unsicherste?

Maßstab ist wieder: ein *konkreter* Schritt mit Begründung — "alles
klar" ist die verdächtigste Antwort. Die zwei erfahrungsgemäß
häufigsten Kandidaten:

- **Schritt 2 (Slice-Datei finden / Bezug lesen):** wenn das eigene
  Repo kein einheitliches Schema hat (Frontmatter vs. Klartext-
  Bezug-Zeile wie im Lab), ist die Verbindung Span → Slice-Datei nur
  durch Lesen rekonstruierbar, nicht maschinell — genau die
  Schwachstelle, die das Worked Example in Schritt 6 benennt.
- **Schritt 5 (Make-Target-Kommentar-Konvention):** wenn Targets keine
  `## LH-…`-Kommentare tragen, lässt sich die Fitness-Function-Seite
  der Kette nicht belegen.

Pointe: der unsicherste Schritt *ist* der Bruchpunkt deiner
Traceability-Kette. Wer ihn benennt, hat den ersten
Steering-Loop-Eintrag schon halb formuliert (Frontmatter-Pflichtfeld
als Gate, oder Doku-Konsistenz-Agent auf die Bezug-Zeile ansetzen).

## Übungshinweise

### Analyse eines KI-Agenten-Laufs im Trace-Viewer

Maßstab:

- Du kannst die *Sequenz* der Tool-Calls in Reihenfolge rekonstruieren.
- Du kannst zu jedem Tool-Call die Latenz benennen.
- Du findest den teuersten Tool-Call binnen einer Minute.
- Du erkennst Wiederholungen (gleicher Tool-Call mit gleichen Args) — ein Symptom für fehlendes Caching oder schlechten Loop-Abbruch.

### (Anwenden — aktiviert LZ 2) Token-Kosten attribuieren

**Teil 1 — teuerster Tool-Call.** Im Lab-Fixture
(`lab/example/otel/sl-009-agent-run.trace.json`) ist es `impl-2`
(`writer.write_index`): 2480 Input- + 187 Output-Token = 2667, dazu
412 ms und `cache.hit: false`. (Der Reviewer-Span `review-1` trägt
zwar mehr Token — 3110 —, ist aber kein Tool-Call, sondern ein
Semantic-Review-Span.) Drei Fragen zur Notwendigkeit:

1. **Quelle**: Welches Step im Plan hat den Call ausgelöst? Hier:
   das Index-Schreiben ist der Kern des Slice (`requirement.id =
   LH-FA-IDX-003`) — der Call ist nötig.
2. **Ergebnis**: Was hat der Agent mit dem Ergebnis gemacht? Ging es ins Output ein?
3. **Vermeidbarkeit**: Nicht der Call, aber sein *Cache-Miss* ist
   verdächtig — wäre er mit stabilerem Kontext-Präfix (AGENTS.md/ADR
   vorne, variable Teile hinten) ein Hit gewesen? Wenn ja, ist das
   ein Steering-Loop-Eintrag.

Häufig zeigt sich in realen Traces: der teuerste Call ist ein
File-Read, der dieselbe Datei wie drei Schritte vorher liest. Caching
im Tool-Layer fehlt — oder der Agent hat das Result aus dem
vorherigen Span nicht im Kontext gehalten.

**Teil 2 — Attribution pro Rolle.** Summe Input + Output je
`agent.role` im Fixture:

| Rolle | Spans | Input | Output | Summe | Anteil |
|---|---|---|---|---|---|
| Planner | `plan-1` | 1800 | 240 | 2040 | ~21 % |
| Implementation | `impl-1`, `impl-2` | 3430 | 307 | 3737 | **~38 %** |
| Reviewer | `review-1` | 2600 | 510 | 3110 | ~32 % |
| Verification | `verify-1` | 820 | 90 | 910 | ~9 % |
| **Gesamt** | | **8650** | **1147** | **9797** | 100 % |

Größter Anteil: **Implementation** mit 3737 Token (~38 %). Hinweis
zum Rollen-Raster: Das Fixture kennt keinen Architect-Span und
etikettiert die Verifier-Rolle als `Verification` — die Attribution
folgt den *vorhandenen* Tags, fehlende Rollen erscheinen als 0, nicht
als geratene Aufteilung.

**Teil 3 — Sammelposten.** Im Fixture trägt jeder Span einen
Rollen-Tag, ein Sammelposten kommt nicht vor. In realen Traces gilt:
die Aufteilungs-Regel *vor* der Abrechnung festlegen und begründen —
z. B. anteilig nach Tool-Calls der umliegenden Spans, oder vollständig
dem auslösenden Slice zugeschlagen (konservativ, weil es keinen
Phantom-Genauigkeits-Eindruck erzeugt). Ad-hoc-Splitting pro Report
ist genau das, was Buchhaltung an KI-Kosten nicht akzeptiert.

### (Erschaffen — aktiviert LZ 4, Spezifizieren-Hälfte) Cache-Counter spezifizieren

Drei Counter — Beispiel-Spezifikation:

| Name | Typ | Labels | Zweck |
|---|---|---|---|
| `prompt_cache_hits_total` | Counter (monoton) | `slice.id`, `agent.role`, `model.version` | Zähler der aus dem Cache bedienten Anfragen |
| `prompt_cache_misses_total` | Counter (monoton) | `slice.id`, `agent.role`, `model.version` | Zähler der Cache-Misses — eigenes Signal, nicht nur Komplement |
| `prompt_cache_input_tokens` | Counter, je Label `cached="true|false"` (alternativ zwei Counter `…_cached`/`…_uncached`) | `slice.id`, `agent.role`, `model.version` | Token-Volumen hinter den Hits/Misses — zwei Misses à 200 Token sind harmloser als einer à 20 000 |

**Aggregation:** Hit-Rate = `hits / (hits + misses)`. Die Division
gehört ins **Dashboard** (bzw. in die Abfrage-Schicht), nicht in die
Metrik-DB: Counter bleiben roh und monoton, damit Rate über beliebige
Zeitfenster und Label-Schnitte (pro Slice, pro Rolle) nachträglich
berechenbar ist. Eine vorberechnete Ratio lässt sich nicht mehr nach
`slice.id` zerlegen.

**Warum eine einzelne Metrik `cache.hit_ratio` nicht reicht:** Eine
Ratio verliert die *Absolutwerte* — und damit die Unterscheidung der
zwei Alarme: ein **Cache-Miss-Spike** (Misses-Counter springt bei
konstanten Hits; Sicherheits-Indikator — variable Eingaben, die den
Cache absichtlich umgehen, sind ein Injection-Symptom) sieht in der
Ratio genauso aus wie ein **Hit-Rückgang** (Hits sinken bei konstanten
Misses; Kosten-Indikator — Kontext-Präfix wurde instabil). Zwei
verschiedene Reaktionen, eine Ratio: nicht unterscheidbar.

### (Erschaffen — aktiviert LZ 5, Formulieren-Hälfte) Drei Konsistenz-Regeln für den Doku-Konsistenz-Agenten

| Feld | Regel 1 | Regel 2 | Regel 3 |
|---|---|---|---|
| **Regel-Name** | AGENTS.md-Befehl existiert im Makefile | Sensors-Tabelle ohne Geister-Gates | Skill-Datei referenziert nur existierende ADRs |
| **Quelle** | AGENTS.md §Tool-Regeln (alle `make …`-Nennungen) | `harness/README.md` Sensors-Tabelle | `.harness/skills/*.md` (alle `ADR-…`-Nennungen) |
| **Vergleichs-Ziel** | `Makefile`-Target-Namen | `Makefile`-Target-Namen + CI-Workflow-Schritte | Datei-Liste `docs/plan/adr/` + deren Status-Feld |
| **Drift-Symptom** | AGENTS.md nennt `make fullbuild`, Makefile kennt nur `make build` | Tabelle listet `coverage-gate-critical`, das Target existiert nicht oder läuft nirgends | Skill zitiert `ADR-0019`, die Datei fehlt — oder die ADR ist `superseded`, der Skill prüft die alte Regel |
| **Lebenszyklus** | Pre-integration (jeder PR, der AGENTS.md oder Makefile berührt) | Pre-integration + Continuous (Geister-Gates entstehen auch durch CI-Umbau ohne Doku-PR) | Continuous (ADR-Status ändert sich ohne Skill-Berührung) |

Regel 1 und Regel 2 setzen die Hard Rule aus Modul 13 §Doku-Disziplin
durch ("keine Befehle behaupten, die es nicht gibt") — damit ist die
Pflicht-Anforderung der Übung doppelt erfüllt. Regel 3 zeigt die
zweite Drift-Klasse: nicht Geister-*Befehle*, sondern veraltete
*Verweise* — der Skill prüft dann gegen einen Stand, den niemand mehr
beschlossen hat.

Maßstab: Jede Regel hat ein *beobachtbares* Drift-Symptom (greppbarer
Widerspruch zwischen zwei Dateien), keine Gefühls-Regel ("Doku wirkt
veraltet"). Der deterministische Teil (Name existiert?) kann als
Skript laufen; nur der semantische Rest (beschreibt die Doku das
Target *richtig*?) braucht die inferentielle Schicht.

### (Erschaffen — aktiviert LZ 6) Audit-Span-Schema für `write_file`

| Attribut | Pflicht/Optional | Incident-Frage, die es beantwortet |
|---|---|---|
| `tool.name` (= `write_file`) | Pflicht | Welches Tool hat geschrieben? |
| `tool.arguments.redacted` (Pfad + Diff-Hash/Stats, keine Inhalte) | Pflicht | Was wurde wohin geschrieben — ohne Secrets im Log? |
| `tool.result.status` (+ Fehlerklasse) | Pflicht | Hat der Schreibzugriff stattgefunden — oder ist er gescheitert, und wie? |
| `slice.id` | Pflicht | Auf wessen Rechnung lief der Schreibzugriff — welcher Auftrag legitimiert ihn? |
| `agent.role` | Pflicht | Welche Rolle hat geschrieben? (Ein schreibender *Reviewer* ist selbst der Incident — Rollen-Trennung forensisch prüfbar.) |
| `cache.hit` | Pflicht | War der zugehörige Modell-Aufruf cache-bedient? (Miss-Spikes auf Schreib-Calls sind ein Injection-Indikator.) |
| `requirement.id` | Pflicht | Welche Anforderung rechtfertigt die Änderung — Anker der Kosten-↔-Anforderungs-Kette (Worked Example). |
| `tokens.input` / `tokens.output` | Pflicht | Was hat der Call gekostet — Token-Attribuierung pro Slice/Rolle? |
| `diff.content_hash` | Pflicht | Ist der geschriebene Stand später byte-genau identifizierbar (Forensik ohne Voll-Log)? |
| `duration_ms` | Optional | War der Call ein Latenz-Ausreißer? |
| `tool.parent_span_id` | Optional (Pflicht, sobald Calls verschachtelt sind) | In welcher Kette steckte der Call — wer hat ihn ausgelöst? |
| `adr.id` | Optional | Gegen welche Architektur-Entscheidung lässt sich der Schreibort prüfen? |

Begründung gegen das Pflicht-Minimum aus dem Worked Example: Slice-ID,
Agent-Rolle, Cache-Status und `requirement.id` sind unverändert
übernommen. *Erweitert* um `tokens` und `diff.content_hash` — beides
mit Abnehmer: ohne `tokens` keine Attribution (Engage-Frage der
Buchhaltung), ohne Content-Hash keine Forensik, wenn das
Logging-Budget den vollen Diff verbietet. Bewusst *nicht* im Schema:
der vollständige Datei-Inhalt (Hash + Stats reichen, Voll-Inhalt
on-demand) und ein freies `notes`-Feld — es hätte keine
Incident-Frage, und Schema-Felder ohne Abnehmer sind
Telemetrie-Boilerplate, kein Audit.

### (Analysieren — aktiviert LZ 3) Fehlerfall: ein Span-Attribut fehlt

Beide Varianten der Übung (in einer *Kopie* des Fixtures — das
Original bleibt unverändert):

**Variante 1 — `tokens`-Feld von `impl-2` entfernt.** Unbeantwortbar
wird der **Kosten-Drill-down des teuersten Calls** und damit die
vollständige Token-Attribuierung pro Slice: Die Implementation-Rolle
schrumpft scheinbar von 3737 auf 1070 Token, der Lauf von 9797 auf
7130 — die Buchhaltungs-Frage aus dem Engage ("Was hat SL-024 / hier
slice-009 gekostet?") bekommt eine *falsche*, keine fehlende Antwort.
Das ist die gefährlichere Form: nichts sieht kaputt aus.
Kompensation: **Metriken** könnten den Verlust auffangen — wenn ein
separater Token-Counter (`llm.tokens_in` mit `slice.id`-Label) am
Provider-Gateway mitzählt, existiert die Summe unabhängig vom Span.
Logs helfen nicht (sie tragen typischerweise keine Token-Zahlen),
Traces sind die verlorene Quelle selbst.

**Variante 2 — `slice.id` im Trace-Kopf gefälscht** (z. B.
`slice-010`). Unbeantwortbar wird die **Zuordnung Kosten ↔
Anforderung**: alle fünf Spans buchen auf den falschen Slice; die
Kette Span → Slice-Datei → ADR → LH-ID startet beim falschen
Dokument. Teil-Kompensation: *innerhalb* des Traces trägt `impl-2`
noch `requirement.id = LH-FA-IDX-003` — über die Anforderung lässt
sich der echte Slice rekonstruieren, aber nur für diesen einen Span;
die übrigen vier sind fehlgebucht. Keiner der drei Telemetrie-Typen
kompensiert vollständig: Logs und Metriken übernehmen ihre
`slice.id` aus derselben Quelle — eine gefälschte Korrelations-ID
vergiftet alle drei Kanäle gleichzeitig. Genau deshalb gehört die
Span-Schema-Pflicht (`slice.id` maschinell gesetzt, nicht
agent-berichtet) in den Steering Loop.

### End-to-End-Trace bis zur LH-ID

Die vollständige Kette für den Span `impl-2` aus
`make trace RUN=sl-009-agent-run`, pro Pfeil-Stufe mit der konkreten
Dokumentations-Stelle:

```
span impl-2 (trace-Kopf: slice.id)   →  slice-009
                                     →  docs/plan/planning/done/slice-009-tie-break-determinismus.md
                                     →  ADR-0012 (Index-Write-Strategie)
                                     →  LH-FA-IDX-003 (Lastenheft)
```

| Pfeil | Konkrete Stelle der Verbindung |
|---|---|
| Span → Slice | Trace-Kopf `"slice.id": "slice-009"`; der Span selbst trägt zusätzlich `requirement.id` und `adr.id` als Direkt-Anker |
| Slice → ADR | **Bezug-Zeile** (Klartext, kein Frontmatter) in der Slice-Datei: "… ADR-0012 (Index-Write-Strategie, sekundär)" |
| ADR → LH-ID | Bezug-Feld im ADR-Kopf: "**Bezug:** LH-FA-IDX-003 (Index-Schreib-Idempotenz und Atomarität)" |
| LH-ID → Akzeptanzkriterien | `spec/lastenheft.md` § LH-FA-IDX-003 (Happy / Boundary / Negative) |
| Rückbindung maschinell | ADR-0012 §Fitness Function: Architekturtest erzwingt die `rename`-Sequenz — ein Commit ohne `rename` macht `make arch-check` rot |

**Bruchpunkt im Lab-Repo:** die Slice→ADR-Stufe — sie hängt an einer
*Klartext*-Bezug-Zeile, nicht an parsbarem Frontmatter. Wird die
Zeile umformuliert, reißt die Kette, ohne dass ein Gate es merkt.
Im eigenen Repo typische Pendants: Make-Targets ohne
`## LH-…`-Kommentare, oder Slices, die nur Tickets im externen
Tracker referenzieren (die Kette verlässt das Repo und ist nicht mehr
replayfähig). Erwartetes Lernergebnis ist genau dieser *eigene*
Bruchpunkt — er ist die einzige Stelle, die in der Abschluss-Bewertung
(Achse Auditierbarkeit) zählt, und der nächste Steering-Loop-Eintrag
(Frontmatter-Pflicht als Gate oder Konsistenz-Agent auf der
Bezug-Zeile).

## Häufige Fehler

- **Span ohne Tool-Result-Hash.** → Forensik geht verloren, wenn das Ergebnis-Volumen das Logging-Budget sprengt.
- **Trace nur in Produktion, nicht in Lab.** → Replay-Läufe sind blind. Lab muss denselben OTel-Pfad haben wie Prod.
- **Budget-Alerts ohne Slice-Attribution.** → "Wir haben heute $400 verbraten" weiß niemand zuzuordnen. Spans brauchen ein `slice.id`-Attribut.

## Verweise

- Entropy Management als Observability-Konsument: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)
- Vorherige Lösung: [Modul 14](modul-14-loesung.md)
- Nächste Lösung: [Modul 16](modul-16-loesung.md)
