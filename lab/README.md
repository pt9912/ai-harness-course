# Lab — Begleit-Repository zum Kurs

Dieses Verzeichnis ist das **Begleit-Lab** zum Kurs unter
[`/kurs/de/`](../kurs/de/README.md). Es liefert:

1. **Templates** (`templates/`): leere Skelett-Vorlagen mit Pflicht-Gliederung für alle Dokumenttypen des Kurses (Spec, ADR, Slice, Welle, Roadmap, Carveout, AGENTS.md, `harness/README.md`).
2. **Beispiel** (`example/`): ein voll ausgefülltes Beispiel-Repo mit konsistenten IDs, mindestens einem geschlossenen Slice, einem fingierten kaputten Slice für [Modul 9](../kurs/de/04-qualitaet/modul-09-review-harness.md) und einem Replay-Beispiel für [Modul 11](../kurs/de/04-qualitaet/modul-11-replay-evaluierung.md).
3. **Sprach-Skelette** (`example/{go,python,kotlin,java,csharp}/`, kommen in Phase C): fünf lauffähige Implementierungs-Skelette mit eigener Toolchain (Linter, Typecheck, Architekturtest, Coverage, Container) und einheitlichem `make gates`-Vertrag.

## Lernweg

Pro Modul (siehe [Kurs-Übersicht](../kurs/de/README.md)):

1. **Modul lesen.**
2. Aus `templates/` die passende Vorlage **kopieren** in dein eigenes Übungs-Repo.
3. Vorlage **ausfüllen** entlang des Modul-Texts.
4. Mit dem entsprechenden Pfad in `example/` **vergleichen** — wo unterscheidet sich deine Lösung? Warum?
5. Lösung in [`/kurs/de/loesungen/`](../kurs/de/loesungen/) aufschlagen.

## Aufbau

```
lab/
├── README.md                  (diese Datei)
├── templates/                 sprachneutrale Skelett-Vorlagen
│   ├── spec/
│   │   ├── lastenheft.template.md
│   │   ├── spezifikation.template.md
│   │   └── architecture.template.md
│   ├── docs/plan/
│   │   ├── adr/NNNN-titel.template.md
│   │   ├── planning/{slice,welle,roadmap}.template.md
│   │   └── carveouts/carveout.template.md
│   ├── harness/README.template.md
│   └── AGENTS.template.md
│
└── example/                   voll ausgefülltes Beispiel-Repo
    ├── README.md
    ├── AGENTS.md
    ├── harness/README.md
    ├── spec/{lastenheft,spezifikation,architecture}.md
    ├── docs/plan/
    │   ├── adr/{README.md, 0001-*.md, …}
    │   ├── planning/{open,next,in-progress,done}/
    │   ├── roadmap.md
    │   └── carveouts/{README.md, CO-001-*.md}
    ├── exercises/09-review-fixture/    (kaputter Slice für Modul 9)
    ├── evals/golden/                   (Replay-Beispiel für Modul 11)
    │
    └── {go,python,kotlin,java,csharp}/  (Phase C — fünf Sprach-Skelette)
        Makefile · Dockerfile · AGENTS.md · harness/README.md · …
```

## Lab-Beispiel: Was wird gebaut?

Das Beispiel-Repo `example/` ist ein fiktiver, aber realistischer
KI-Mini-Service: **"DocSearch"** — ein Service, der eine Sammlung von
Markdown-Dokumenten indexiert und über eine semantische Suche
abfragbar macht. Genug Komplexität für:

- mehrere Schichten (Index, Suche, Adapter),
- ein paar realistische ADRs (Modellwahl, Layering, Vektor-Datenbank),
- mehrere Slices in unterschiedlichen Lifecycle-Stadien,
- einen Carveout (z. B. Bootstrap-Coverage),
- ein fingiertes Review-Fixture für Modul 9.

Der Sinn ist nicht, ein produktives DocSearch zu bauen, sondern den
Kursinhalt am konkreten Artefakt erlebbar zu machen.

## Verwendung der Sprach-Skelette (ab Phase C)

Jedes Sprach-Skelett ist **eigenständig lauffähig**:

```bash
cd lab/example/go         # oder python, kotlin, java, csharp
make build                # Docker-Image bauen
make gates                # alle Quality Gates
```

Jedes Skelett implementiert dasselbe Lab-Beispiel (DocSearch) in der
jeweiligen Sprache — der Lerner sieht den Kontrast zwischen
sprach-unabhängigem Harness (Spec, ADR, Plan) und sprach-spezifischer
Konkretion (Linter-Konfig, Architekturtest-Framework, Container-Strategie).

## Lizenz

Templates und Texte in `lab/` stehen unter CC BY 4.0;
Code-Artefakte (Makefiles, Dockerfiles, Quelldateien) unter MIT.
Details in [`../LICENSE.md`](../LICENSE.md).
