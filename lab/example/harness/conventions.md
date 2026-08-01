# Harness-Konventionen

Diese Datei deklariert die *repo-lokalen* Strukturregeln dieses
DocSearch-Beispiel-Repos gegenüber der adoptierten Harnesskonvention.
Sie ist konformitätsbringend für *Form*-Fragen, nicht autoritativ über
Inhalt; bei Konflikt mit einer kanonischen Quelle gilt die kanonische
Quelle ([Source Precedence](README.md#source-precedence)).

## Purpose

Der Default-Ort für:

- **Adaptionen** ggü. der Baseline (mit Begründung).
- **Zusatzklassen-Deklarationen** für Sensors-Bindung-Klassen, die
  über die vier kanonischen (ADR, Carveout, Schwelle,
  Reproduzierbarkeit) hinausgehen.
- **Modus-Deklarationen** pro Sub-Area (Greenfield / Brownfield).

## Baseline

- **Konvention:** AI-Harness-Kurs (`/kurs/de/grundlagen/konventionen.md`)
- **Datum der Adoption:** 2026-05-15 (Repo-Bootstrap, slice-001)
- **Baseline-Pin (Regelwerk + Templates):** die adoptierte Baseline ist das Kurs-Regelwerk als Split *plus* die Templates, self-contained im `lab-regelwerk.zip` (`regelwerk/` + `templates/` parallel; `agents-regelwerk.md` ist retired). Adoptierter Stand: die Stand-Zeile von [`regelwerk/README.md`](../../regelwerk/README.md) (Wellen-Register: `CHANGELOG.md`). Dieses Beispiel liegt *im* Kurs-Repo und ist damit selbst am aktuellen Stand — die Upstream-Freshness-Frage (*„ist mein `<tag>` noch das aktuelle Kurs-Release?"*) stellt sich erst im adoptierenden Fremd-Repo: eine Release-**Listen**-Prüfung (ein neuer Tag löst einen Review), Netz-Operation außerhalb der netzlosen Gates — nicht der Asset-Hash-Vergleich, der einen neuen Tag gar nicht fängt. Siehe [Kurs Modul 2](../../../kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md) §Freshness-Audit.

## Adoptierte Konventions-Quellen

- **Extern (Lehrmaterial):** [`/kurs/de/grundlagen/konventionen.md`](../../../kurs/de/grundlagen/konventionen.md), [`/kurs/de/grundlagen/klassifikation.md`](../../../kurs/de/grundlagen/klassifikation.md)
- **Extern (Kurs-Regelwerk):** [`/lab/regelwerk/`](../../regelwerk/README.md) — was ein Code-Agent statt des vollen Lehrmaterials liest (pro Abschnitt eine Datei); derivativ, bei Konflikt gilt das Lehrmaterial. In einem adoptierenden Fremd-Repo werden Regelwerk *und* Templates aus dem self-contained Release-Asset (`https://github.com/pt9912/ai-harness-course/releases/latest/download/lab-regelwerk.zip`) nach `.harness/baseline/<tag>/{regelwerk,templates}/` vendored; dieses Beispiel liegt im Kurs-Repo und referenziert beide direkt.
- **In-Repo (verkörperte Form):** Template-Set unter [`/lab/templates/`](../../../lab/templates/) als Form-Lookup-Quelle — im Fremd-Repo die vendored `.harness/baseline/<tag>/templates/` (Referenz-Form der „Ziel-Form"-Verweise), daneben die daraus kopiert-und-ausgefüllten eigenen Artefakte.

## Adaptions-Block

Diese Datei trägt den **Index**; die Einträge liegen einzeln unter
`harness/conventions/`, aufgelöste unter `conventions/done/`. Der Zustand ist
die Verzeichnis-Position, kein Status-Feld
([`konventionen.md` §Konventionsspeicher](../../../kurs/de/grundlagen/harness-dateien.md#harnessconventionsmd-als-konventionsspeicher)).

### MR-000 — Baseline-Aussage

- **Datum:** 2026-05-15
- **Geltungsbereich:** gesamtes Repo
- **Ersetzt-Baseline-Regel:** — *(keine; dieser Eintrag ist die
  Adoptions-Erklärung, keine Adaption)*
- **Adaption:** *Keine inhaltlichen Adaptionen ggü. Baseline-Default
  für Verzeichniskonvention, Lifecycle-Regeln, Carveout-Disziplin,
  ID-Schema (`LH-FA-*`, `LH-QA-*`, `ADR-<NNNN>`, `CO-<NNN>`,
  `slice-<NNN>`, `MR-<NNN>`).*
- **Begründung:** Initial-Setzung. Dieses Beispiel-Repo ist
  Lehr-Vehikel und folgt der Kurs-Konvention sturer als ein realer
  Bedarfsfall, damit die Konvention als solche sichtbar bleibt.
- **Auflösungs-Trigger:** permanent.

### Aktive Adaptionen

| MR | Titel | Geltungsbereich | Ersetzt-Baseline-Regel |
|---|---|---|---|
| [002](conventions/MR-002-konventions-bindung-als-sensors-klasse.md) | Konventions-Bindung als Sensors-Klasse | Bindung-Spalte in `harness/README.md` §Sensors | [`konventionen.md` §Sensors-Bindung](../../../kurs/de/grundlagen/harness-dateien.md#harnessreadmemd-als-einstiegspunkt) |
| [003](conventions/MR-003-mr-001-gegenstandslos.md) | MR-001 gegenstandslos durch Baseline-Update | `MR-001` | — |

### Aufgelöste Adaptionen

| MR | aufgelöst durch |
|---|---|
| [001](conventions/done/MR-001-source-precedence-mit-spezifikations-schicht.md) | [MR-003](conventions/MR-003-mr-001-gegenstandslos.md) |

## Zusatzklassen-Deklaration für Sensors-Bindung

DocSearch nutzt neben den vier kanonischen Bindung-Klassen (ADR ·
Carveout · Schwelle · Reproduzierbarkeit) **zwei** Zusatzklassen:

| Klasse | Form | Bedeutung | Beispiel im Repo |
|---|---|---|---|
| LH-Bindung | `LH-FA-<NNN>` · `LH-QA-<NNN>` | Gate prüft direkt eine Anforderung aus `spec/lastenheft.md` | `LH-QA-02` als Bindung von `make test-determinism` (siehe [`README.md` §Sensors](README.md#sensors-feedback-gates)) |
| Konventions-Bindung (`MR-002`) | `Kurs §<Abschnitt>` · `Modul <N> §<Abschnitt>` | Gate setzt eine Regel des Baseline-Regelwerks durch, die weder Anforderung noch ADR ist | `Kurs §Referenz-Richtung` als Bindung von `make check-references` |

## Modus-Deklaration pro Sub-Area

Der Modus gilt **pro Sub-Area**, nicht pro Repo
([Modul 2 FV2](../../../kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md#typische-fehlvorstellungen)).
Dieses Lehr-Repo ist durchgängig **Greenfield** (Harness von Beginn an,
Spec führt) — die Modus-Spalte ist daher homogen. Die Sub-Areas sind
trotzdem einzeln deklariert, damit (a) die Granularitäts-Disziplin
sichtbar ist und (b) eine künftig nach BF kippende Sub-Area einen Platz
hat. Jede Zeile weist die erfüllten Inklusions-Achsen aus
([`konventionen.md` §Was ist eine Sub-Area?](../../../kurs/de/grundlagen/bootstrap.md#was-ist-eine-sub-area),
Schwelle ≥ 2 von 3: 1 Konventions-Härte · 2 Inventur-Linie · 3 Struktureller Cluster).

| Sub-Area | Pfad-Cluster | Erfüllte Inklusions-Achsen | Modus |
|---|---|---|---|
| Spec-Schreibung | `spec/` | 1 (eigene Spec-Stil-`MR` plausibel formulierbar, z. B. AK-Format-Standard) · 2 (Spec↔Code abgleichbar) · 3 (`spec/`) → **3/3** | Greenfield |
| Konventionen & Harness-Doku | `harness/`, `<lang>/harness/`, `AGENTS.md` + `<lang>/AGENTS.md`, `README.md` + `<lang>/README.md`, `docs/glossar.md` | 1 (Heimat der `MR-NNN`, hier `MR-000` bis `MR-002`) · 2 (Doku-Konsistenz-Linie) · 3 (`harness/`-Cluster plus die Agenten-/Einstiegs-Dateien, die dieselbe Konvention tragen) → **3/3** | Greenfield |
| Planning-Lifecycle | `docs/plan/` | 1 (Slice-/ADR-/Carveout-Konvention) · 2 (`open`→`done`-Inventur) · 3 (`docs/plan/`) → **3/3** | Greenfield |
| Implementierung | `<lang>/src/`, `<lang>/cmd/`, `<lang>/internal/`, `<lang>/.editorconfig` | 1 (eigene Implementierungs-Stil-`MR` plausibel formulierbar) · 2 (Code-Inventur) · 3 (`src/`-Cluster) → **3/3** | Greenfield |
| Test-Infrastruktur | `<lang>/tests/` | 1 (Test-/Determinismus-Konvention, z. B. `make test-determinism`) · 2 (Test-ohne-`LH`-ID als Diskrepanz) · 3 (`tests/`) → **3/3** | Greenfield |
| Verifikation | `verification/` | 1 (Plan-vs-Code-Check-Konvention, Modul 11 — *kein* Golden Set) · 2 (Slice-Beleg-Inventur) · 3 (`verification/`) → **3/3** | Greenfield |
| Replay-/Eval-Infrastruktur | `evals/` | 1 (Golden-Set-/Replay-Konvention, Modul 12) · 2 (Golden-Set-Drift-Inventur) · 3 (`evals/`) → **3/3** | Greenfield |
| Observability | `otel/` | 2 (Trace-Inventur) · 3 (`otel/`-Cluster); Achse 1 (Span-Schema-`MR`) noch schwach → **2/3** | Greenfield |
| Container-/Build-Harness | `<lang>/Dockerfile`, `<lang>/.dockerignore` und die Build-Definitionen (`go.mod`, `pom.xml`, `build.gradle.kts` + `settings.gradle.kts`, `pyproject.toml`, `CMakeLists.txt` + `cmake/Dependencies.cmake`, `DocSearch.sln` + `Directory.*.props` + `global.json`) | 1 (Image-/Layer-Konvention, Modul 14) · 2 (Reproduzierbarkeits-Inventur: baut jedes Skelett aus demselben gepinnten Stand?) · 3 (`Dockerfile`- und Build-Definitions-Dateimuster) → **3/3** | Greenfield |
| Betriebs-Runbooks | `runbooks/` | 1 (Runbook-Form-Konvention, Modul 16) · 2 (Szenario↔Runbook-Inventur: hat jeder benannte Ausfall ein Runbook?) · 3 (`runbooks/`) → **3/3** | Greenfield |
| Sensor-Werkzeuge | `tools/`, jedes `Makefile` (Wurzel und `<lang>/`), `<lang>/scripts/`, `<lang>/cmake/*.sh` und die Gate-Konfiguration (`.golangci.yml`, `.clang-tidy`, `checkstyle.xml` + `checkstyle-suppressions.xml`, `importlinter.cfg`, `config/detekt.yml` + `config/detekt-baseline.xml`, `coverlet.runsettings`) | 1 (Skript-Konvention: netzlos, Exit-Code-basiert; jedes Target nennt seine Bindung) · 3 (`tools/` plus das Make-/Gate-Konfigurations-Dateimuster); Achse 2 schwach — die Doku-Aussage über ein Sensor-Werkzeug steht in `README.md` §Sensors, die Inventur zieht damit die Nachbar-Sub-Area mit → **2/3** | Greenfield |

### Warum drei Korrektheits-Sub-Areas und nicht eine

`Test-Infrastruktur`, `Verifikation` und `Replay-/Eval-Infrastruktur`
sind *bewusst getrennt* geführt, obwohl sie alle „Korrektheits-Sensoren"
sind: Achse 1 divergiert (Determinismus ≠ Plan-vs-Code-DoD ≠
Golden-Set-Replay — je eigene Konvention, drei verschiedene Kursmodule
11/12). Sie zu *einer* Sub-Area zusammenzufassen wäre der „zu grob"-Fehler
aus [FV5](../../../kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md#typische-fehlvorstellungen)
— vgl. [`konventionen.md` §Was ist eine Sub-Area?](../../../kurs/de/grundlagen/bootstrap.md#was-ist-eine-sub-area)
(Absatz *Aggregation*).

### Nicht als Sub-Area geführt

Die Tabelle oben deckt jeden **Pfad-Cluster** dieses Repos ab: jedes
Top-Level-Verzeichnis und jede sprach-übergreifende Datei-Familie. Was hier
fehlt, fehlt begründet — ohne diesen Abschnitt wäre nicht unterscheidbar, ob
ein Pfad geprüft und abgewiesen oder schlicht vergessen wurde. Maßstab ist
dieselbe Schwelle wie oben, nur mit dem Ergebnis *nein*: der „zu fein"-Pol aus
[Modul 2 FV5](../../../kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md#typische-fehlvorstellungen).

| Pfad | Achsen | Warum keine Sub-Area |
|---|---|---|
| `docs/user/` | 3 (`docs/user/`) → **1/3** | **Sub-Area-Aspirantin.** Das Verzeichnis trägt nur ein README; eine eigene Konvention (Achse 1) hat es nicht, und eine eigene Inventur-Linie (Achse 2) auch nicht — die Inhalte liegen in `runbooks/` und `AGENTS.md` §4 (siehe [`README.md` §Source precedence](README.md#source-precedence), Rang 6). Der Fall *Struktur ohne Substanz*. Sie kippt, sobald das Verzeichnis einen eigenen Doku-Style-Standard **und** eine eigene Drift-Linie trägt. |
| `exercises/` | — | Kein Produkt-Artefakt. Kurs-Übungsmaterial, das mit diesem Beispiel-Repo mitreist; `exercises/09-review-fixture/` ist absichtlich fehlerhaft. Eine Modus-Aussage darüber wäre eine Aussage über den Kurs, nicht über dieses Repo. |
| `.gitignore` (Wurzel und `<lang>/`) | — | Werkzeug-Defaults ohne Doku-Aussage, gegen die sich etwas abgleichen ließe (Achse 2 leer), und ohne Konvention, die dieses Repo setzt (Achse 1 leer). |

## Glossar (optional)

| Begriff | Bedeutung in diesem Repo |
|---|---|
| DocSearch | das Beispiel-Tool dieses Lab-Verzeichnisses — kleine CLI für Volltext-Suche in lokalen Dokumenten, geführt als Worked Example für den Kurs |
