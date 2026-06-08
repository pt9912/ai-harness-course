# Lösung — Modul 0: Einführung

Zugehöriges Modul: [Modul 0 — Einführung](../00-einfuehrung/modul-00-einfuehrung.md).

## Selbstcheck-Antworten

### (Erinnern + Verstehen) Drei Bestandteile eines Tool-Calls + Abgrenzung Agent/LLM/Tool-Call

`name`, `arguments`, `result`. Das ist der strukturierte Aufruf einer
Funktion durch das LLM. Bildlich: das LLM zeigt mit dem Finger (`name`),
übergibt eine Liste Parameter (`arguments`), und bekommt eine Antwort
zurück (`result`).

Abgrenzung der drei Begriffe:

- **LLM** — erzeugt nur Text (auch der Tool-Call-Wunsch ist zunächst
  Text). Es kann nichts *tun*: keine Datei lesen, kein Gate aufrufen,
  nichts ins Repo schreiben.
- **Tool-Call** — die strukturierte Handlung, die aus dem Text-Wunsch
  des LLM wird, sobald sie ausgeführt und ihr `result` zurückgegeben
  wird.
- **Agent** — die Schleife *um* das LLM: sie nimmt den Tool-Call-Wunsch,
  führt ihn aus, gibt das `result` zurück in den Kontext und lässt das
  LLM weiterarbeiten. Erst der Agent macht aus Text eine auditierbare
  Handlungskette.

Kurz: Das LLM allein kann nicht handeln; der Tool-Call ist die Handlung;
der Agent ist die Schleife, die beide zu einem reproduzierbaren Lauf
verbindet.

In ernsten Setups kommen Korrelationsfelder hinzu — `agent.role`,
`slice.id`, `requirement.id` — aber das sind Erweiterungen, die in
Modul 15 behandelt werden. Die drei Pflichtfelder stehen darüber: ohne
sie ist es kein Tool-Call, sondern eine Texteingabe.

Falle: "vier Bestandteile" (mit Zeitstempel oder Status) ist nicht
*Definition*, sondern Telemetrie-Erweiterung. Das Minimum sind drei.

### (Analysieren) Ein Scheitermuster einem 2×2-Quadranten zuordnen

Beispiel: Der Agent hat eine nicht geforderte Cache-Variante gebaut,
weil die Spec an der Stelle stumm war. Quadrant: *inferential
feedforward* — gefehlt hat ein **Guide vor der Handlung** (Spec/ADR, die
die Entscheidung vorweggenommen hätte), nicht ein Sensor danach.

Disziplin der Antwort: genau *einen* Quadranten benennen und sagen,
*welche* Kontrolle gefehlt hat. Anti-Antwort "das Modell war schlecht"
ist kein Quadrant — Modelle werden besser oder schlechter, aber die
fehlende Kontrolle bleibt dieselbe. Gegenprobe (exzellent): dasselbe
Muster gegen *computational feedback* (ein Test/Gate) halten und
begründen, warum hier der billigere Hebel der Guide *vor* der Handlung
gewesen wäre — ein Gate hätte den Fehlbau erst nachträglich gefangen.

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

## Beispiel-Antwort auf Reflexionsfrage 4 (Conceptual Change)

Die vierte Reflexionsfrage — *"Welche eigene Vorstellung wurde
unzufriedenstellend?"* — ist die schwerste zum Ausfüllen, weil sie
einen ehrlichen Blick auf die eigenen Vor-Annahmen verlangt. Damit
sichtbar wird, *wie* eine gute Antwort aussieht, hier eine modellierte
Antwort zur Halluzinations-Provokations-Übung:

> **Vorstellung vor der Übung:** *"Halluzinationen sind ein Defekt des
> Modells — sie passieren, wenn das Modell 'nicht weiß'. Wenn ich ein
> stärkeres Modell nehme, passieren sie weniger."*
>
> **Was die Übung gezeigt hat:** Ich habe das Modell gezielt nach
> `os.deleteWithoutBackup()` gefragt. Es hat die Funktion *plausibel
> beschrieben*, einschließlich Signatur und Beispielnutzung. Beim
> Wechsel auf ein stärkeres Modell ist *dieselbe* erfundene Funktion
> wieder aufgetaucht, nur mit anderer (ebenfalls erfundener) Doku-URL.
> Das passte nicht zu meiner Vorstellung: das stärkere Modell hat
> nicht "weniger erfunden", sondern *konsistenter* erfunden.
>
> **Was jetzt besser passt:** Eine Halluzination ist nicht ein
> Wissens-Defekt des Modells, sondern eine *Kontext-Lücke*. Mein
> Prompt hat *nichts* gesagt, was der Funktion widerspräche. Beide
> Modelle haben den Kontext gleich gut (oder gleich schlecht) "gefüllt"
> — nur unterscheidet sich die Plausibilitäts-Oberfläche. Wer den
> Kontext stopft (Spec, ADR, AGENTS.md), reduziert Halluzinationen
> *unabhängig vom Modell*.
>
> **Wo diese neue Sicht selbst scheitern könnte
> (Fruchtbarkeits-Test):** Ich nehme jetzt an, dass *jede*
> Halluzination eine Kontext-Lücke ist. Das stimmt vielleicht nicht
> für reine *Faktenfragen* (Versionsnummer nach Trainingsschnitt) — da
> ist das Modell tatsächlich blind und kein Kontext kann das füllen.
> Diese Grenze muss ich noch klären.

Vier Bestandteile, die diese Antwort exemplarisch ausführt:

1. **Vorstellung vor der Übung** — wortwörtlich, peinlich klein.
2. **Diskrepanz-Beobachtung** — konkret, mit Belegen aus dem Lauf.
3. **Neue Sicht** — eine, die die Beobachtung *besser* erklärt
   (Posner: Verständlichkeit + Plausibilität).
4. **Eigene Grenze der neuen Sicht** — wo sie selbst scheitern könnte
   (Posner: Fruchtbarkeit).

Ohne den vierten Punkt ist es kein Conceptual Change, sondern eine
neue Festlegung. Conceptual Change *lädt zur nächsten Revision ein*.

## Häufige Fehler

- "Wir brauchen erst ein besseres Modell." — Häufig ist die Spec das Problem, nicht das Modell.
- "Wir bauen einen Mega-Prompt." — Skaliert nicht: der Prompt wird zur Anti-Spec, die niemand pflegt.
- "Der Agent muss nur freier entscheiden dürfen." — Genau das macht Auditierbarkeit unmöglich. Engineering-Systeme sind reproduzierbar, nicht kreativ.

## Verweise

- Klassifikation der Gegenmaßnahmen: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)
- Nächste Lösung: [Modul 1](modul-01-loesung.md)
