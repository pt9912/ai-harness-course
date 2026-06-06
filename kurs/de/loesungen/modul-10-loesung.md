# Lösung — Modul 10: Review Harness

Zugehöriges Modul: [Modul 10 — Review Harness](../04-qualitaet/modul-10-review-harness.md).

## Selbstcheck-Antworten

### (Erinnern) Welche vier Finding-Kategorien gibt es, und welche zwei blockieren typischerweise den Merge?

Die vier Kategorien:

- **HIGH** — blockiert Merge: Sicherheits-, Korrektheits- oder ADR-Verstoß.
- **MEDIUM** — sollte vor Merge geklärt werden; formal nicht *immer* Blocker, aber Standard-Erwartung.
- **LOW** — nice-to-fix, blockiert nicht.
- **INFO** — Hinweis ohne erwartete Aktion.

Harter Blocker: **HIGH**. Soll-Blocker: **MEDIUM**.

Die LOW/MEDIUM-Trennlinie ist *repo-spezifisch* und gehört in den
Reviewer-Skill (`.harness/skills/reviewer.md`). Ohne Skill-Eintrag
wandert dieselbe Beobachtung zwischen Läufen — und genau das war der
Anlass für das Skill-Konzept im Worked Example von Modul 10.

### Wann wird aus einem LOW-Finding ein HIGH-Finding?

Die Kategorie ist *kontextabhängig*. Ein und dasselbe Finding kann
wandern, wenn:

- Der **Geltungsbereich** sich erweitert. Eine unbenutzte Variable in einem Hilfsskript ist LOW. Dieselbe unbenutzte Variable in einem Sicherheits-Check-Pfad ist HIGH, weil sie nahelegt, dass ein Check vergessen wurde.
- Das **Wiederholungs-Muster** sichtbar wird. Ein einmaliges Typing-Lapsus ist LOW. Dasselbe Muster zum dritten Mal in derselben Sitzung ist ein Symptom — und damit MEDIUM oder HIGH, weil es auf eine Lücke in AGENTS.md oder einer ADR hinweist.
- **Externe Wirkung** sich ändert. Ein dokumentations-Tippfehler ist LOW. Derselbe Tippfehler in einer öffentlichen API-Beschreibung, die in eine Vertrags-Doku eingeht (Compliance-Repo), ist HIGH.
- Der **Slice in Produktion** geht. Was im Lab LOW war, kann im Release MEDIUM oder HIGH werden — Stichwort: fail-closed.

Faustregel: Wenn Reviewer und Implementer über die Kategorisierung
streiten, ist die Spec oder die ADR-Schicht zu vage. Streit über
Kategorisierung ist ein Steering-Loop-Signal: die Klassifikations-Regel
gehört geschärft.

### Was tust du, wenn der Reviewer-Agent dasselbe Finding zweimal mit unterschiedlicher Kategorie meldet?

Drei Schritte:

1. **Nicht eine der beiden Kategorien wählen** — beide ernst nehmen.
2. **Frage stellen: Welcher Kontext-Unterschied erklärt die Differenz?** Wenn beim ersten Lauf andere ADRs im Kontext waren als beim zweiten, ist die Differenz informativ — der Reviewer ist ohne Kontext strenger oder lascher. Das ist eine Lücke im *Reviewer-Eingang*, nicht im Code.
3. **Eintrag in den Steering Loop**: Reviewer-Skill braucht eine Schärfung — welche Kriterien die Kategorie HIGH von MEDIUM trennen, gehört ins Skill-Dokument.

Anti-Antwort: "Nehmen wir die mildere — Agent hat sich selbst korrigiert."
Das ist die Falle. Der Agent ist nicht "neutraler" geworden, sondern
sieht jetzt einen anderen Kontext — und du belohnst gerade Inkonsistenz.

### (Anwenden) 17 Findings — welche ersten drei Aktionen?

1. **Nach Kategorie sortieren, HIGH zuerst lesen.** Findings ohne
   Kategorie sind Mängelliste, nicht Entscheidungsvorlage — wenn der
   Reviewer-Agent das nicht liefert, ist sein Skill zu schwach (Modul 10
   §"Reviewer berichtet auch, was er nicht gefunden hat").
2. **HIGH-Findings prüfen — gegen welche Quelle?** Jedes HIGH muss eine
   *Quelle* nennen (ADR-ID, Hard Rule, LH-ID). Wenn keine Quelle:
   Reviewer-Skill hat keine "Klassifikations-Anker" — Steering-Loop-Eintrag.
3. **MEDIUM-Findings clustern, LOW/INFO erstmal überspringen.** Wenn
   mehrere MEDIUM derselben Klasse vorliegen (z. B. "fehlende
   Negativtests in fünf Endpunkten"), wandert das Cluster nach oben — es
   ist ein Symptom einer Spec-Lücke, kein Einzelproblem.

Die Falle (siehe Engage von Modul 10): am ersten LOW-Finding hängenbleiben,
zwei Stunden Tippfehler beheben, vier HIGH-Findings unten gehen unter.
HIGH zuerst, immer — auch wenn die LOW-Findings einfacher aussehen.

## Übungshinweise

### Review realer Änderungen im Begleit-Repo

Maßstab:

- Reviewer-Lauf ist *reproduzierbar* (gleiche Eingabe, gleicher Diff, sehr ähnliche Findings).
- Jedes Finding ist *kategorisiert* — kein Finding ohne HIGH/MEDIUM/LOW/INFO.
- Jedes HIGH-Finding nennt die *Quelle* (ADR-ID, Anforderungs-ID oder Hard Rule).
- Reviewer berichtet auch das, was er *nicht* gefunden hat ("keine Sicherheits-Anti-Pattern in `internal/auth/`") — Negativbefunde sind Vertrauen.

### Reviewe den fingierten kaputten Slice

Der Slice unter
[`/lab/example/exercises/09-review-fixture/`](../../../lab/example/exercises/09-review-fixture/)
enthält drei eingebaute Fehler, die in *drei verschiedene Kategorien*
fallen sollen. Erwarteter Befund (bezogen auf das Cache/Service-Layer-Szenario):

- **Ein HIGH** — *ADR-Verstoß*: DoD-Item 2 *"Cache umgeht den Index-Layer komplett"* verletzt ADR-0001 (Hexagonale Architektur, [`/lab/example/docs/plan/adr/0001-hexagonale-architektur.md`](../../../lab/example/docs/plan/adr/0001-hexagonale-architektur.md)). Der Service-Layer darf den Index-Layer nicht überspringen. Korrektur: *Read-through-Cache* hinter dem Index-Layer, nicht davor. Reviewer muss ADR-0001 im Eingangs-Kontext haben — ohne ADR im Kontext bleibt der Verstoß unsichtbar (genau das ist Lehrstoff: Reviewer-Eingang ist Pflicht, nicht Komfort).
- **Ein MEDIUM** — *Spec-Lücken-Symptom plus Selbstabsolution*: Abschnitt 6 begründet das Stale-Read-Risiko mit *"… aber das ist OK, weil Cache eh nur 1 Minute TTL hat"*. Die Begründung absolviert sich selbst, ohne gegen LH-QA-01 (Performance + Korrektheit) evaluiert zu werden. Reviewer-Frage: was geschieht, wenn ein Reindex *gleichzeitig* mit Cache-Hits läuft? Wenn der Slice das nicht beantwortet, ist die Spec an dieser Stelle stumm — und 1 Minute TTL ist eine Setzung ohne Beleg.
- **Ein LOW** — *stilistisch ohne semantische Auswirkung*: Der Closure-Trigger (Abschnitt 5) lautet *"DoD vollständig, Cache funktioniert"*. Das ist tautologisch — ein Trigger soll ein *überprüfbares Ereignis* sein (Latenz-Messung im Closure-Eintrag, Cache-Hit-Rate über drei Tage), nicht ein Selbstbezug auf die DoD.

Wenn dein Reviewer-Agent nur HIGH-Findings produziert, ist er
übersensibilisiert; nur LOW deutet auf zu schwache Skills hin. Wenn er
das HIGH *nicht* findet, hatte er ADR-0001 nicht im Eingangs-Kontext —
prüfe die Reviewer-Eingabe, nicht das Modell.

## Häufige Fehler

- **Reviewer als zweiter Implementer.** "Hier ist mein Vorschlag, wie du es schreiben könntest." → Reviewer kategorisiert Findings; Lösungsvorschläge sind nett, aber kein Reviewer-Ergebnis.
- **Reviewer ohne Skill-Datei.** → Verhalten driftet zwischen Sessions. Jeder Reviewer-Agent braucht ein Skill-Dokument mit "worauf achtest du in diesem Repo".
- **Findings-Liste ohne Prioritätssortierung.** → Auftragnehmer arbeitet sequenziell ab und steckt oft beim LOW-Finding fest. HIGH zuerst, immer.

## Verweise

- 2×2-Klassifikation + Maintainability-Kategorie: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md) — Review ist Inferential + Feedback, primär in der Maintainability-Kategorie.
- Vorherige Lösung: [Modul 9](modul-09-loesung.md)
- Nächste Lösung: [Modul 11](modul-11-loesung.md)
