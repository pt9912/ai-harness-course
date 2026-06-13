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
| [`docs/reviews/review-report.template.md`](docs/reviews/review-report.template.md) | Review-Report: Kopf-Metadaten, Findings nach Output-Schema, Negativbefunde, Verdikt | [Modul 10](../../kurs/de/04-qualitaet/modul-10-review-harness.md) |
| [`project-readme.template.md`](project-readme.template.md) | Projekt-Root-`README.md`: Überblick, Ist-Stand, Vertrauens-Signale (Rang 7) | [Modul 2](../../kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md) |
| [`AGENTS.template.md`](AGENTS.template.md) | Repo-weite Hard Rules und Source Precedence | [Modul 9](../../kurs/de/03-agenten/modul-09-implementierung.md) |
| [`harness/README.template.md`](harness/README.template.md) | Repo-Einstiegspunkt mit Guides, Sensors, Safety | [Konventionen](../../kurs/de/grundlagen/konventionen.md#harnessreadmemd-als-einstiegspunkt) |
| [`harness/conventions.template.md`](harness/conventions.template.md) | Repo-lokale Strukturregeln, Adaptions-Block (`MR-*`), Zusatzklassen-Deklaration, Modus-Deklaration pro Sub-Area | [Konventionen](../../kurs/de/grundlagen/konventionen.md#harnessconventionsmd-als-konventionsspeicher) |

## Download als ZIP

**Stabiler Link (kein Login nötig):** der Workflow `templates-release`
hängt bei jedem Tag `templates-v*` das ZIP als Release-Asset an —

> <https://github.com/pt9912/ai-harness-course/releases/latest/download/lab-templates.zip>

Zusätzlich lädt der Workflow `templates-zip` diesen Ordner bei jeder
Änderung als Actions-Artifact `lab-templates` hoch (Vorschau-Stand von
`main`): auf GitHub unter **Actions → templates-zip → neuester Lauf →
Artifacts**. Artifacts erfordern einen GitHub-Login und verfallen nach
90 Tagen; über **Run workflow** (workflow_dispatch) lässt sich das ZIP
jederzeit neu erzeugen.

## Verwendung

1. **Modul lesen** im Kurs.
2. **Template kopieren** in dein eigenes Repo:
   ```bash
   cp lab/templates/spec/lastenheft.template.md mein-repo/spec/lastenheft.md
   ```
3. **`<Platzhalter>`-Stellen ersetzen.**
4. **Template-Hinweis-Block oben entfernen** (er beginnt mit `> **Template-Hinweis.**`).
5. **HTML-Kommentar-Hilfen entfernen** (`<!-- ... -->`) — **außer**
   `<!-- d-check:ignore … -->`-Marker: die unterdrücken Falsch-Positive
   des Referenz-Gates für bewusst illustrative Pfade und müssen bleiben.
6. **Mit dem entsprechenden Pfad in `lab/example/` vergleichen** —
   so siehst du, wie ein voll ausgefülltes Artefakt aussieht.

## Ein- vs. wiederkehrende Templates

Die Templates haben zwei Lebenszyklen:

- **Singletons** — einmal beim Bootstrap zu `.md` füllen, dann das
  `.template.md` verwerfen: `project-readme`, `spec/lastenheft`,
  `spec/spezifikation`, `spec/architecture`, `AGENTS`, `harness/README`,
  `harness/conventions`, `roadmap`.
- **Wiederkehrend** — als `.template.md` **co-located** im Repo behalten;
  jede neue Instanz wird daneben kopiert: `adr/NNNN-titel`, `slice`,
  `welle`, `carveout`, `review-report`.

Wiederkehrende Templates bleiben also dauerhaft im Repo (z. B.
`docs/plan/adr/NNNN-titel.template.md` neben den echten ADRs). Damit ihre
Platzhalter den Gate nicht rot färben, ignoriert die mitgelieferte
`.d-check.yml` sie per Suffix (`**/*.template.md`). `/tmp` ist nur die
kurzlebige Entpack-Station — der `harness/`-Ordner ist **kein**
Template-Lager.

## Gate-Baseline

Drei mitgelieferte Dateien geben dir den Doku-Referenz-Gate
out-of-the-box (ins Repo-Root kopieren):

| Datei | Rolle |
|---|---|
| [`.d-check.yml`](.d-check.yml) | Modul-Auswahl + Suffix-Ignore; `ids`/`codepaths` wachsen mit den Artefakten |
| [`harness.mk`](harness.mk) | `make docs-check` via d-check (Image per Digest gepinnt) |
| [`Makefile`](Makefile) | bindet `harness.mk` ein; `gates: docs-check`, Code-Gates ergänzt der Adopter |

Danach läuft `make docs-check` sofort (`links`/`anchors`). `ids` und
`codepaths` im `.d-check.yml` einkommentieren, sobald die Ziele bzw.
Verzeichnisse existieren — sonst behauptet der Gate eine Dimension, die er
nicht durchsetzt (Modul 13). Startgerüst neu erzeugen: `d-check --print-config`.

## Pflichtgliederung vs. freie Form

Die Templates geben **Pflichtgliederung** vor (Abschnitte, IDs,
Verlinkung). Innerhalb der Abschnitte hast du Freiraum — was am
besten zu deinem Projekt passt. Pflicht-Strukturen sind:

- ID-Schema (z.B. `LH-*`) konsistent durchziehen.
- ADRs nach Accepted nicht überschreiben (Hard Rule aus c-hsm-doc).
- Carveouts brauchen immer Trigger + Folge-Slice.
- Slices brauchen DoD mit prüfbaren Kriterien.
- Slices mit mindestens einer in BF oder Hybrid berührten Sub-Area
  brauchen einen Sub-Area-Modus-Begründungsblock (§8 in
  `slice.template.md`), pro berührter Sub-Area einen Block; bei
  reinem GF genügt der Hinweis "alle berührten Sub-Areas GF".
  Voraussetzung-Wissen: Kurs Modul 5 §Worked Mini-Example.

## Ergänzungen

Wenn du eigene Template-Varianten brauchst (z.B. für ein
Compliance-Repo mit zusätzlichem Disclaimer-Block oder ein
Safety-Repo mit HIL-Test-Plan), lege sie in einem eigenen
`templates/`-Unterordner deines Repos an, *nicht* hier — diese Datei
ist die Referenz-Quelle.
