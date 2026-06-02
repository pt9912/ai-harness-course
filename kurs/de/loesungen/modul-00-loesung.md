# Lösung — Modul 0: Einführung

Zugehöriges Modul: [Modul 0 — Einführung](../00-einfuehrung/modul-00-einfuehrung.md).

## Selbstcheck-Antworten

### (Erinnern) Welche drei Bestandteile hat ein Tool-Call laut Mini-Glossar?

`name`, `arguments`, `result`. Das ist der strukturierte Aufruf einer
Funktion durch das LLM. Bildlich: das LLM zeigt mit dem Finger (`name`),
übergibt eine Liste Parameter (`arguments`), und bekommt eine Antwort
zurück (`result`).

In ernsten Setups kommen Korrelationsfelder hinzu — `agent.role`,
`slice.id`, `requirement.id` — aber das sind Erweiterungen, die in
Modul 14 behandelt werden. Die drei Pflichtfelder stehen darüber: ohne
sie ist es kein Tool-Call, sondern eine Texteingabe.

Falle: "vier Bestandteile" (mit Zeitstempel oder Status) ist nicht
*Definition*, sondern Telemetrie-Erweiterung. Das Minimum sind drei.

### Wo verläuft die Grenze zwischen "guter Prompt" und "guter Harness"?

Ein guter Prompt verbessert *eine* Interaktion. Ein guter Harness
verbessert *jede* zukünftige Interaktion derselben Klasse.

Konkret: Wenn du denselben Zusatz immer wieder in den Prompt schreibst
(etwa "antworte auf Deutsch", "halte dich an die Schichten X, Y, Z",
"benutze keine externen APIs"), gehört das in AGENTS.md oder eine
Fitness Function, nicht in den Prompt. Der Test ist einfach: Wäre die
Anweisung in *jedem* Lauf relevant? Dann ist es Harness, nicht Prompt.

### Welche Fehlermodi eines Agenten kann ein Linter *nicht* fangen?

Linter prüfen syntaktische und lokale Eigenschaften. Sie übersehen
typischerweise:

- **Semantische Halluzinationen** — Agent erfindet eine API-Funktion, die nicht existiert. Compile-Schritt findet das, kein Linter.
- **ADR-Verstöße** — Agent baut Layer X mit direkter Abhängigkeit zu Y, obwohl ADR-3 sagt: nur über Adapter Z. Architekturtest fängt das, kein Linter.
- **Spec-Lücken-Symptome** — Agent implementiert eine plausible, aber nicht geforderte Variante. Verification-Agent gegen Akzeptanzkriterien fängt das.
- **Implizite Annahmen** — Agent geht davon aus, dass Cache aktiv ist, obwohl Spec ihn ausschließt. Nur Review oder Replay mit kaltem Cache fängt das.
- **Sicherheits-Anti-Pattern in fremdem Kontext** — z. B. SQL-Injection in einem Filter, den der Linter als regulären String sieht. Security-Gate (Semgrep) fängt das.

## Übungshinweise

### Analyse eines fehlgeschlagenen KI-Projekts

Maßstab für eine gute Postmortem-Analyse:

- Mindestens *drei* Fehlerklassen werden benannt — nicht eine ("LLM war schlecht").
- Für jede Klasse: Welcher Quadrant der 2×2-Matrix wäre die richtige Gegenmaßnahme? (Siehe [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md).)
- Mindestens eine Klasse wird *nicht* dem Modell zugeschrieben (sondern Spec, Tooling, Doku).

Häufiger Fehler: Alles wird "Halluzination" genannt. Tatsächlich sind
viele Halluzinationen Symptom einer Spec-Lücke — das Modell rät, weil
nichts in der Eingabe widerspricht.

### Provoziere absichtlich eine Halluzination

Gute Trigger:

- Frage nach einer Methode/Bibliothek, die wahrscheinlich nicht existiert (z. B. `os.deleteWithoutBackup()`).
- Bitte um Code "wie in der Standardbibliothek X" mit einer X, die du gerade erfunden hast.
- Stelle eine Frage, deren Antwort eine Versionsnummer benötigt, die nach dem Trainingsschnitt liegt.

Dokumentiere den Trigger so, dass er reproduzierbar ist — das ist die
erste kleine Replay-Übung des Kurses.

## Häufige Fehler

- "Wir brauchen erst ein besseres Modell." — Häufig ist die Spec das Problem, nicht das Modell.
- "Wir bauen einen Mega-Prompt." — Skaliert nicht: der Prompt wird zur Anti-Spec, die niemand pflegt.
- "Der Agent muss nur freier entscheiden dürfen." — Genau das macht Auditierbarkeit unmöglich. Engineering-Systeme sind reproduzierbar, nicht kreativ.

## Verweise

- Klassifikation der Gegenmaßnahmen: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)
- Nächste Lösung: [Modul 1](modul-01-loesung.md)
