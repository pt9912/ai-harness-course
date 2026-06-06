# Lösung — Modul 5: Planning Harness

Zugehöriges Modul: [Modul 5 — Planning Harness](../02-planung/modul-05-planning-harness.md).

## Selbstcheck-Antworten

### (Erinnern) Nenne die vier Lifecycle-Verzeichnisse in Reihenfolge

`open/` → `next/` → `in-progress/` → `done/`.

Plus zwei Rückführungen, die im Lifecycle-State-Diagramm explizit sind:

- `in-progress/ → next/` — Slice ist zu groß, geht zurück zur Zerlegung.
- `in-progress/ → open/` — Slice ist blockiert (typisch mit Carveout,
  siehe Modul 7).

Faustregel: WIP-Limit auf 1 pro Implementer. Wer mehrere Slices
gleichzeitig in `in-progress/` hat, hat kein Lifecycle, sondern ein
Buffet — und keinen Punkt, an dem reproduzierbar geprüft wird, ob der
8-Schritt-Workflow durchlaufen wurde.

### Welcher Trigger bewegt einen Slice von `next/` nach `in-progress/`?

Der erste Commit, der die Arbeit am Slice startet — *nicht* der Wunsch,
ihn als nächstes machen zu wollen.

Konkret: Ein Slice wandert nach `in-progress/`, wenn ein Branch oder
PR existiert, der ihn umsetzt. Vorher gehört er in `next/`, mit
"als nächstes geplant" und idealerweise einem Verantwortlichen.

Anti-Pattern: "Ich verschiebe ihn in `in-progress/`, damit ich nicht
vergesse, dass ich ihn morgen anfange." Damit lügt das Lifecycle-System
— jemand könnte annehmen, der Slice sei im Fluss.

### Wann darf ein Slice in `done/` landen, obwohl ein Gate rot ist?

Eigentlich nie. Eine Ausnahme:

- Wenn das rote Gate von einem **Carveout** abgedeckt ist, der explizit dokumentiert ist und einen Auflösungs-Trigger nennt (siehe [Modul 7](../02-planung/modul-07-carveouts.md)).
- Wenn das Gate ein **Bootstrap-aware Gate** ist (siehe [Modul 13](../04-qualitaet/modul-13-quality-gates.md)) und der Slice noch in der Frühphase liegt — auch dann muss der Bootstrap-Stand dokumentiert sein.

In beiden Fällen ist nicht das Gate rot "trotz Closure", sondern das
Gate ist *im aktuellen Reifegrad nicht hart* — und das ist
dokumentiert. Wenn weder Carveout noch Bootstrap, dann ist Closure
falsch.

## Übungshinweise

### Planung eines Features über mehrere Wellen

Maßstab:

- Die *erste* Welle liefert etwas, was sichtbar grün läuft (`make gates` grün, mindestens ein Smoke-Test). Lieber kleiner als zu groß.
- Jede Welle hat einen Closure-Trigger ("wenn X grün und Y dokumentiert → Welle done").
- Wellen sind in *Reihenfolge* abhängig, nicht in *Termin*. Termine ergeben sich, sobald die Wellen geschnitten sind.
- Mindestens ein Slice pro Welle hat einen Verweis auf eine Anforderungs-ID (`LH-*`) — sonst ist die Welle "Wartungsarbeit", die nicht in die Roadmap gehört.

### Bewege einen Slice durch alle vier Verzeichnisse

Vier Commits ist die saubere Variante:

1. Erstelle Slice in `open/`.
2. `git mv open/X.md next/X.md` (Prioritäts-Trigger erfüllt).
3. `git mv next/X.md in-progress/X.md` (Start-Commit, oder Branch-Commit).
4. `git mv in-progress/X.md done/X.md` + Closure-Notiz.

Wichtig: Reine Move-Commits (Git-Rename-Detection braucht 50 %
Similarity, siehe Hard Rule aus grid-gym in [Modul 9](../03-agenten/modul-09-implementierung.md)).
Inhaltliche Edits dazwischen sind eigene Commits.

### Schneide einen zu großen Slice in zwei umsetzbare Slices

Kriterien für "zu groß":

- Mehr als eine Schicht der Architektur betroffen ohne klare Abstraktion dazwischen.
- DoD enthält "und" mehrfach (statt einer klaren Bedingung).
- Geschätzte Bearbeitungsdauer überschreitet, was ein Reviewer *in einer Sitzung* prüfen kann.

Schnitt-Strategien:

- **Vertikal**: Slice 1 liefert minimalen End-to-End-Pfad; Slice 2 erweitert.
- **Horizontal**: Slice 1 baut die Schicht, Slice 2 verkabelt sie.
- **Read-Write-Split**: Slice 1 nur Lesen, Slice 2 fügt Schreiben hinzu.

## Häufige Fehler

- **`done/` wird zur Mülltonne.** Slices wandern dort hin, weil "halt nicht mehr aktuell". Das ist kein Closure, sondern Verstecken.
- **`open/` enthält Wünsche, die nie umgesetzt werden.** Aufräumen ist Teil von Entropy Management — toter Backlog ist Rauschen.
- **Closure-Notiz fehlt oder ist generisch ("done").** Damit verlierst du den Steering-Loop-Lerneffekt.

## Verweise

- Carveouts: [Modul 7](../02-planung/modul-07-carveouts.md) und [Lösung Modul 7](modul-07-loesung.md)
- Welle-Self-Close-Konvention aus grid-gym: [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
- Vorherige Lösung: [Modul 4](modul-04-loesung.md)
- Nächste Lösung: [Modul 6](modul-06-loesung.md)
