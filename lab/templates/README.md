# Templates

Skelett-Vorlagen für die Dokumenttypen des Kurses. **Sprachneutral** —
unabhängig davon, ob dein Repo Go, Python, Kotlin, Java oder C# nutzt.

## Übersicht

| Template | Wofür | Kurs-Verweis |
|---|---|---|
| [`spec/lastenheft.template.md`](spec/lastenheft.template.md) | Vertraglich abnahmebindende Anforderungen (`LH-*`-IDs) | [Modul 3](../../kurs/de/01-spec-und-architektur/modul-03-lastenheft.md) |
| [`spec/spezifikation.template.md`](spec/spezifikation.template.md) | Technisch verbindlich, fortschreibbar — Algorithmen, Defaults, Codes | [Modul 3](../../kurs/de/01-spec-und-architektur/modul-03-lastenheft.md) (Spec-Stratifizierung) |
| [`spec/architecture.template.md`](spec/architecture.template.md) | Komponenten- und Sequenzsicht, sprach- und meilensteinfrei | [Modul 4](../../kurs/de/01-spec-und-architektur/modul-04-architektur-adrs.md) |
| [`docs/plan/adr/NNNN-titel.template.md`](docs/plan/adr/NNNN-titel.template.md) | Architecture Decision Record im MADR/Nygard-Stil | [Modul 4](../../kurs/de/01-spec-und-architektur/modul-04-architektur-adrs.md) |
| [`docs/plan/planning/slice.template.md`](docs/plan/planning/slice.template.md) | Slice-Plan mit DoD, Trigger, Closure | [Modul 5](../../kurs/de/02-planung/modul-05-planning-harness.md) |
| [`docs/plan/planning/welle.template.md`](docs/plan/planning/welle.template.md) | Welle als Bündel von Slices | [Modul 5](../../kurs/de/02-planung/modul-05-planning-harness.md) + [Modul 6](../../kurs/de/02-planung/modul-06-roadmap.md) |
| [`docs/plan/planning/roadmap.template.md`](docs/plan/planning/roadmap.template.md) | Roadmap als Reihenfolge von Wellen, nicht Termine | [Modul 6](../../kurs/de/02-planung/modul-06-roadmap.md) |
| [`docs/plan/carveouts/carveout.template.md`](docs/plan/carveouts/carveout.template.md) | Dokumentierte Ausnahme mit Auflösungs-Trigger | [Modul 7](../../kurs/de/02-planung/modul-07-carveouts.md) |
| [`AGENTS.template.md`](AGENTS.template.md) | Repo-weite Hard Rules und Source Precedence | [Modul 9](../../kurs/de/03-agenten/modul-09-implementierung.md) |
| [`harness/README.template.md`](harness/README.template.md) | Repo-Einstiegspunkt mit Guides, Sensors, Safety | [Konventionen](../../kurs/de/grundlagen/konventionen.md#harnessreadmemd-als-einstiegspunkt) |
| [`harness/conventions.template.md`](harness/conventions.template.md) | Repo-lokale Strukturregeln, Adaptions-Block (`MR-*`), Zusatzklassen-Deklaration, Modus-Deklaration pro Sub-Area | [Konventionen](../../kurs/de/grundlagen/konventionen.md#harnessconventionsmd-als-konventionsspeicher) |

## Verwendung

1. **Modul lesen** im Kurs.
2. **Template kopieren** in dein eigenes Repo:
   ```bash
   cp lab/templates/spec/lastenheft.template.md mein-repo/spec/lastenheft.md
   ```
3. **`<Platzhalter>`-Stellen ersetzen.**
4. **Template-Hinweis-Block oben entfernen** (er beginnt mit `> **Template-Hinweis.**`).
5. **HTML-Kommentar-Hilfen entfernen** (`<!-- ... -->`).
6. **Mit dem entsprechenden Pfad in `lab/example/` vergleichen** —
   so siehst du, wie ein voll ausgefülltes Artefakt aussieht.

## Pflichtgliederung vs. freie Form

Die Templates geben **Pflichtgliederung** vor (Abschnitte, IDs,
Verlinkung). Innerhalb der Abschnitte hast du Freiraum — was am
besten zu deinem Projekt passt. Pflicht-Strukturen sind:

- ID-Schema (z.B. `LH-*`) konsistent durchziehen.
- ADRs nach Accepted nicht überschreiben (Hard Rule aus c-hsm-doc).
- Carveouts brauchen immer Trigger + Folge-Slice.
- Slices brauchen DoD mit prüfbaren Kriterien.

## Ergänzungen

Wenn du eigene Template-Varianten brauchst (z.B. für ein
Compliance-Repo mit zusätzlichem Disclaimer-Block oder ein
Safety-Repo mit HIL-Test-Plan), lege sie in einem eigenen
`templates/`-Unterordner deines Repos an, *nicht* hier — diese Datei
ist die Referenz-Quelle.
