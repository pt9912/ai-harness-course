# Lösung — Modul 11: Replay und Evaluierung

Zugehöriges Modul: [Modul 11 — Replay und Evaluierung](../04-qualitaet/modul-11-replay-evaluierung.md).

## Selbstcheck-Antworten

### Was muss ein Replay festhalten, damit er deterministisch ist?

Mindestens diese Inputs eines Agentenlaufs:

- **Modell-ID und Version** (`claude-opus-4-7@2026-06-01` reicht nicht — auch der Release-Snapshot oder die API-Version).
- **Eingabe-Prompt** wörtlich, inklusive System-Prompt und aller injizierten Kontext-Stücke (AGENTS.md, ADRs, Spec).
- **Tool-Definitionen** wörtlich (Name, Schema, Allowlist-Stand).
- **Temperature, Top-P, Seed**, falls API das unterstützt.
- **Externe Antworten**, die der Agent während des Laufs erhielt: Tool-Results, HTTP-Antworten, Dateiinhalte. Diese werden für den Replay *gemockt*, nicht neu abgerufen — sonst ist der Replay kein Replay.

Was *nicht* in den Replay gehört, sondern aufgezeichnet wird:

- Aktueller Output des Agenten.
- Aktuelle Tool-Calls.
- Aktuelle Tokens-Verbrauch.

Wenn ein Replay nicht deterministisch ist, ist meist eine externe
Antwort *nicht* gemockt — der Agent ruft die Realität an, die sich
geändert hat. Häufiger Übeltäter: Filesystem-Stand oder Datums-Funktion.

### Wann wird ein Golden Set giftig (überfittet)?

Drei Symptome:

1. **Golden grün, Realität rot**: Du fügst Replays aus echten User-Beschwerden hinzu und siehst, dass Golden weiterhin grün, aber Fehler in Produktion auftreten. Das Golden Set kennt die Realität nicht mehr.
2. **Golden grün nur mit ein-Modell**: Du wechselst das Modell und alles ist rot. Das Set hat sich an Modell-Idiosynkrasien gewöhnt (Wort-Wahl, Reihenfolge der Tool-Calls).
3. **Golden wird selten erweitert**: Über Wochen keine neuen Einträge. → Steering Loop läuft nicht, jedes Versagen sollte ein neues Golden-Set-Item erzeugen.

Gegenmittel:

- Rotieren: alte Golden-Items, deren Klasse durch andere abgedeckt ist, retiren.
- Mischformen: semantische Bewertungsmetrik *zusätzlich* zur Exact-Match. Modelle ändern Formulierung, ohne Inhalt zu ändern.
- Mindestens eine Welle pro Quartal: "Golden-Set-Audit", wer hat zuletzt was eingespeist, was wurde nie getriggert?

## Übungshinweise

### Reproduzierbare Testläufe gegen ein Golden Set

Maßstab:

- Pro Run wird ein Run-Manifest erzeugt: Modell, Seed, alle Input-Hashes, alle gemockten Antworten, Output-Hashes.
- Zwei aufeinanderfolgende Runs derselben Eingabe erzeugen identische Manifest-Hashes (im Output) — *oder* ein semantischer Vergleicher meldet "Outputs sind äquivalent" (mit Begründung).
- Replay-Lauf hat keinen Netzzugriff — alles aus Mock-Files.

### Erzeuge eine Regression durch Modellwechsel

Vorgehen:

1. Replay-Lauf mit Modell A → grün.
2. Wechsel auf Modell B → was wird rot?
3. Klassifiziere die roten Fälle: Format-Drift (Reihenfolge, Tokens), semantische Verschiebung, neue Fehler.
4. Welche der drei Klassen ist akzeptabel, welche ist Show-Stopper?

Diese Übung ist gleichzeitig eine Modell-Migrations-Probe. In
Produktion bedeutet ein Modell-Update genau diesen Lauf — vorher.

## Häufige Fehler

- **Replay-Tests laufen mit echtem Netz**. → Kein Replay, sondern Live-Test mit alten Erwartungen. Wird flaky.
- **Exact-Match als einziges Erfolgskriterium.** → Modelle sind variabel; minimaler Format-Drift erzeugt False-Positive-Failures. Mindestens *eine* semantische Metrik dazu.
- **Golden Set wird in einem CSV gepflegt**, das niemand reviewt. → Wenn Golden-Set-Änderungen nicht durch denselben Slice-Lifecycle laufen wie Code, driften sie.

## Verweise

- Test-Diversität (Determinism/Replay/Fault): [Modul 11](../04-qualitaet/modul-11-replay-evaluierung.md)
- grid-gym als reales Beispiel: [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
- Vorherige Lösung: [Modul 10](modul-10-loesung.md)
- Nächste Lösung: [Modul 12](modul-12-loesung.md)
