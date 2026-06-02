# Lösung — Modul 9: Review Harness

Zugehöriges Modul: [Modul 9 — Review Harness](../04-qualitaet/modul-09-review-harness.md).

## Selbstcheck-Antworten

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
(im Lab nach Phase B) enthält drei eingebaute Fehler, die in *drei
verschiedene Kategorien* fallen sollen. Erwarteter Befund:

- **Ein HIGH**: ADR- oder Hard-Rule-Verstoß (z. B. direkter Optimizer-zu-Gerät-Pfad).
- **Ein MEDIUM**: unklare Fehlerbehandlung am Rand des Spec-Bereichs.
- **Ein LOW**: stilistisch unschön ohne semantische Auswirkung.

Wenn dein Reviewer-Agent nur HIGH-Findings produziert, ist er
übersensibilisiert; nur LOW deutet auf zu schwache Skills hin.

## Häufige Fehler

- **Reviewer als zweiter Implementer.** "Hier ist mein Vorschlag, wie du es schreiben könntest." → Reviewer kategorisiert Findings; Lösungsvorschläge sind nett, aber kein Reviewer-Ergebnis.
- **Reviewer ohne Skill-Datei.** → Verhalten driftet zwischen Sessions. Jeder Reviewer-Agent braucht ein Skill-Dokument mit "worauf achtest du in diesem Repo".
- **Findings-Liste ohne Prioritätssortierung.** → Auftragnehmer arbeitet sequenziell ab und steckt oft beim LOW-Finding fest. HIGH zuerst, immer.

## Verweise

- 2×2-Klassifikation + Maintainability-Kategorie: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md) — Review ist Inferential + Feedback, primär in der Maintainability-Kategorie.
- Vorherige Lösung: [Modul 8](modul-08-loesung.md)
- Nächste Lösung: [Modul 10](modul-10-loesung.md)
