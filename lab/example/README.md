# Example — DocSearch

Ein **fiktiver, aber realistischer** KI-Mini-Service als Beispiel-Repo
zum Kurs. Genug Komplexität, um die Konzepte des Kurses am konkreten
Artefakt zu erleben — bewusst kein produktiver Code.

## Was DocSearch tut

DocSearch indexiert eine Sammlung von Markdown-Dokumenten und stellt
eine semantische Suche bereit. Eine Anfrage liefert die k relevantesten
Dokument-Abschnitte. Die Embedding-Erzeugung läuft über ein LLM.

## Warum dieses Beispiel?

- **Mehrere Schichten** (Index, Suche, Embedding-Adapter, API) — genug
  für Layering-ADRs und Architekturtests.
- **Realistische ADRs**: Modellwahl für Embeddings, Vektor-Datenbank,
  hexagonale Architektur.
- **Slices in jedem Lifecycle-Status**: einer in `open/`, einer in
  `in-progress/`, mehrere in `done/`.
- **Ein Carveout** für eine Bootstrap-Coverage.
- **Ein Replay-Beispiel** in `evals/golden/` für [Modul 11](../../kurs/de/04-qualitaet/modul-11-replay-evaluierung.md).
- **Ein fingiertes Review-Fixture** in `exercises/09-review-fixture/`
  für [Modul 9](../../kurs/de/04-qualitaet/modul-09-review-harness.md).

## Struktur

```
example/
├── README.md                    (diese Datei)
├── AGENTS.md                    Hard Rules und Source Precedence
├── harness/README.md            Harness-Einstieg
├── spec/
│   ├── lastenheft.md            LH-*-IDs, Akzeptanzkriterien
│   ├── spezifikation.md         Algorithmen, Defaults, Codes
│   └── architecture.md          Schichten, Sequenzen
├── docs/plan/
│   ├── adr/                     ADR-Index + 3 ADRs
│   ├── planning/                Slices in allen Lifecycle-Stadien
│   ├── carveouts/               1 aktiver Carveout
│   └── roadmap.md               Wellen, Trigger, Status
├── exercises/
│   └── 09-review-fixture/       kaputter Slice für Review-Übung
├── evals/golden/                Replay-Eingang/Erwartung
└── (Sprach-Skelette in Phase C: go/, python/, kotlin/, java/, csharp/)
```

## Was hier *kein* funktionierender Code ist

Die `.md`-Artefakte (Spec, ADR, Plan, Carveout, AGENTS, harness/README)
sind **vollständig**. Die Sprach-Skelette unter `go/`, `python/` etc.
folgen in Phase C — dort werden `make gates` grün laufen.

Aktuell (Phase B) sind nur die Doku-Artefakte fertig — sie sind die
Grundlage, gegen die später jedes Sprach-Skelett dieselbe Spec
implementiert.

## Lernweg

Pro Modul: Template aus `../templates/` kopieren → ausfüllen → mit der
entsprechenden Datei hier vergleichen. Lösung in
[`../../kurs/de/loesungen/`](../../kurs/de/loesungen/) lesen.
