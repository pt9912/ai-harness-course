# Lösung — Modul 12: Replay und Evaluierung

Zugehöriges Modul: [Modul 12 — Replay und Evaluierung](../04-qualitaet/modul-12-replay-evaluierung.md).

## Selbstcheck-Antworten

### (Erinnern) Welche drei Felder muss ein Replay-Manifest mindestens festhalten?

1. **Modellversion** (konkrete API-Version oder Snapshot, nicht nur Familie).
2. **Seed** (falls der Provider Seed-Parameter unterstützt).
3. **Eingaben** als referenzierter Datensatz (Hash + Pfad), nicht inline-Text.

Pflichtfelder #4 und #5 in jedem ernsten Setup, wie im Modul-Abschnitt
[Begriff: Image-Hash](../04-qualitaet/modul-12-replay-evaluierung.md#begriff-image-hash-vorgriff-aus-modul-14)
erklärt:

4. **Image-Hash** der Toolchain — sonst lässt sich Modell-Drift nicht
   von Toolchain-Drift trennen.
5. **Aufnahme-Zeitpunkt** — damit spätere Läufe ihren Diff datieren
   können.

Wer nur Modell + Seed pinnt, hat ~60 % Determinismus (siehe Modul 12
§"Typische Fehlvorstellungen"). Die fehlenden 40 % erscheinen als
diffuse Drift, die niemand klar zuordnen kann.

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

### (Anwenden) Zwei Drift-Quellen — welche zuerst messen?

In der ersten Woche zwei konkrete:

1. **Modellversion-/Routing-Drift.** Der Provider routet "gleicher Tag"
   intern auf verschiedene Subversions — der API-Tag bleibt stabil, das
   Verhalten driftet. Sensor: zwei Replays desselben Manifests im Abstand
   von Tagen vergleichen, Diff betrachten.
2. **Toolchain-Drift.** Tool-Subversion oder Image-Hash anders als im
   Manifest — Test-Library aktualisiert, Linter strenger, Compiler
   anders. Sensor: Image-Hash-Vergleich zwischen Manifest und aktuellem
   Build.

Warum *diese* beiden zuerst:

- Beide haben einen *sofortigen* Sensor (Manifest-Vergleich).
- Beide sind in einer Woche messbar (drei Läufe reichen für ein Signal).
- Beide sind *Voraussetzungen* für andere Messungen. Eingabe-Distribution
  oder Cache-Verhalten zu messen, *bevor* Modell und Toolchain stabil
  sind, misst Rauschen.

Die Reihenfolge ist nicht beliebig. Wer zuerst Eingabe-Distribution
analysiert, sieht Drift — aber ohne Toolchain-Pinning kann er nicht
sagen, ob das an der Distribution oder am Linter liegt.

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

- Test-Diversität (Determinism/Replay/Fault): [Modul 12](../04-qualitaet/modul-12-replay-evaluierung.md)
- grid-gym als reales Beispiel: [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
- Vorherige Lösung: [Modul 11](modul-11-loesung.md)
- Nächste Lösung: [Modul 13](modul-13-loesung.md)
