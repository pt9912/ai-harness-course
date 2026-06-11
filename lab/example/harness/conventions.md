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
- **Stand:** Template-Set 2026-06
- **Datum der Adoption:** 2026-06-01

## Adoptierte Konventions-Quellen

- **Extern (Lehrmaterial):** [`/kurs/de/grundlagen/konventionen.md`](../../../kurs/de/grundlagen/konventionen.md), [`/kurs/de/grundlagen/klassifikation.md`](../../../kurs/de/grundlagen/klassifikation.md)
- **Extern (Agenten-Destillat):** [`/kurs/de/agents-digest.md`](../../../kurs/de/agents-digest.md) — was ein Code-Agent statt des vollen Lehrmaterials liest; derivativ, bei Konflikt gilt das Lehrmaterial. (Außerhalb dieses Repos als Raw-URL: `https://raw.githubusercontent.com/pt9912/ai-harness-course/main/kurs/de/agents-digest.md`.)
- **In-Repo (verkörperte Form):** Template-Set unter [`/lab/templates/`](../../../lab/templates/) als Form-Lookup-Quelle

## Adaptions-Block

### MR-000 — Baseline-Aussage

- **Datum:** 2026-06-01
- **Geltungsbereich:** gesamtes Repo
- **Adaption:** *Keine inhaltlichen Adaptionen ggü. Baseline-Default
  für Verzeichniskonvention, Lifecycle-Regeln, Carveout-Disziplin,
  ID-Schema (`LH-FA-*`, `LH-QA-*`, `ADR-<NNN>`, `CO-<NNN>`,
  `slice-<NNN>`, `MR-<NNN>`).*
- **Begründung:** Initial-Setzung. Dieses Beispiel-Repo ist
  Lehr-Vehikel und folgt der Kurs-Konvention sturer als ein realer
  Bedarfsfall, damit die Konvention als solche sichtbar bleibt.
- **Auflösungs-Trigger:** permanent.

### MR-001 — Source Precedence mit eigener Spezifikations-Schicht

- **Datum:** 2026-06-01
- **Geltungsbereich:** [`harness/README.md` §Source precedence](README.md#source-precedence)
- **Adaption:** Die Source-Precedence-Tabelle führt
  [`spec/spezifikation.md`](../spec/spezifikation.md) als eigenen
  **Rang 2** zwischen Lastenheft (Rang 1) und Architektur (Rang 3).
  Der Kurs-Default
  ([`konventionen.md` §Source Precedence](../../../kurs/de/grundlagen/konventionen.md#source-precedence))
  setzt nur zwei Spec-Ränge (`lastenheft` → `architecture`); dieses
  Repo nutzt drei.
- **Begründung:** Das Repo verwendet die Spec-Stratifizierung
  ([`konventionen.md` §Spec-Stratifizierung](../../../kurs/de/grundlagen/konventionen.md#spec-stratifizierung))
  explizit mit drei Spec-Dateien — Lastenheft (vertraglich),
  Spezifikation (technisch fortschreibbar), Architektur (diagrammatisch).
  Damit die Source-Precedence-Tabelle die ADR-Schärfungs-Regel
  ("ADR darf Spezifikation schärfen, nicht Lastenheft") strukturell
  abbildet, muss die Spezifikation als eigener Rang sichtbar sein —
  sonst kollabiert die Trennschärfe zwischen "wir versprechen" und
  "wir liefern wie".
- **Auflösungs-Trigger:** permanent.

## Zusatzklassen-Deklaration für Sensors-Bindung

DocSearch nutzt neben den vier kanonischen Bindung-Klassen (ADR ·
Carveout · Schwelle · Reproduzierbarkeit) **eine** Zusatzklasse:

| Klasse | Form | Bedeutung | Beispiel im Repo |
|---|---|---|---|
| LH-Bindung | `LH-FA-<NNN>` · `LH-QA-<NNN>` | Gate prüft direkt eine Anforderung aus `spec/lastenheft.md` | `LH-QA-02` als Bindung von `make test-determinism` (siehe [`README.md` §Sensors](README.md#sensors-feedback-gates)) |

## Modus-Deklaration pro Sub-Area

Der Modus gilt **pro Sub-Area**, nicht pro Repo
([Modul 2 FV2](../../../kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md#typische-fehlvorstellungen)).
Dieses Lehr-Repo ist durchgängig **Greenfield** (Harness von Beginn an,
Spec führt) — die Modus-Spalte ist daher homogen. Die Sub-Areas sind
trotzdem einzeln deklariert, damit (a) die Granularitäts-Disziplin
sichtbar ist und (b) eine künftig nach BF kippende Sub-Area einen Platz
hat. Jede Zeile weist die erfüllten Inklusions-Achsen aus
([`konventionen.md` §Was ist eine Sub-Area?](../../../kurs/de/grundlagen/konventionen.md#was-ist-eine-sub-area),
Schwelle ≥ 2 von 3: 1 Konventions-Härte · 2 Inventur-Linie · 3 Struktureller Cluster).

| Sub-Area | Pfad-Cluster | Erfüllte Inklusions-Achsen | Modus |
|---|---|---|---|
| Spec-Schreibung | `spec/` | 1 (eigene Spec-Stil-`MR` plausibel formulierbar, z. B. AK-Format-Standard) · 2 (Spec↔Code abgleichbar) · 3 (`spec/`) → **3/3** | Greenfield |
| Konventionen & Harness-Doku | `harness/` | 1 (Heimat der `MR-NNN`, hier `MR-000`/`MR-001`) · 2 (Doku-Konsistenz-Linie) · 3 (`harness/`) → **3/3** | Greenfield |
| Planning-Lifecycle | `docs/plan/` | 1 (Slice-/ADR-/Carveout-Konvention) · 2 (`open`→`done`-Inventur) · 3 (`docs/plan/`) → **3/3** | Greenfield |
| Implementierung | `<lang>/src/`, `<lang>/cmd/`, `internal/` | 1 (eigene Implementierungs-Stil-`MR` plausibel formulierbar) · 2 (Code-Inventur) · 3 (`src/`-Cluster) → **3/3** | Greenfield |
| Test-Infrastruktur | `<lang>/tests/` | 1 (Test-/Determinismus-Konvention, z. B. `make test-determinism`) · 2 (Test-ohne-`LH`-ID als Diskrepanz) · 3 (`tests/`) → **3/3** | Greenfield |
| Verifikation | `verification/` | 1 (Plan-vs-Code-Check-Konvention, Modul 11 — *kein* Golden Set) · 2 (Slice-Beleg-Inventur) · 3 (`verification/`) → **3/3** | Greenfield |
| Replay-/Eval-Infrastruktur | `evals/` | 1 (Golden-Set-/Replay-Konvention, Modul 12) · 2 (Golden-Set-Drift-Inventur) · 3 (`evals/`) → **3/3** | Greenfield |
| Observability | `otel/` | 2 (Trace-Inventur) · 3 (`otel/`-Cluster); Achse 1 (Span-Schema-`MR`) noch schwach → **2/3** | Greenfield |

`Test-Infrastruktur`, `Verifikation` und `Replay-/Eval-Infrastruktur`
sind *bewusst getrennt* geführt, obwohl sie alle „Korrektheits-Sensoren"
sind: Achse 1 divergiert (Determinismus ≠ Plan-vs-Code-DoD ≠
Golden-Set-Replay — je eigene Konvention, drei verschiedene Kursmodule
11/12). Sie zu *einer* Sub-Area zusammenzufassen wäre der „zu grob"-Fehler
aus [FV5](../../../kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md#typische-fehlvorstellungen)
— vgl. [`konventionen.md` §Was ist eine Sub-Area?](../../../kurs/de/grundlagen/konventionen.md#was-ist-eine-sub-area)
(Absatz *Aggregation*).

**Keine Sub-Area — Aspirantinnen (< 2 Achsen, der „zu fein"-Pol aus
[Modul 2 FV5](../../../kurs/de/01-spec-und-architektur/modul-02-harness-bootstrap.md#typische-fehlvorstellungen)):**

- `docs/user/` — nur Achse 3 (`docs/user/`-Pfad); keine eigene Konvention
  (Achse 1), keine eigenständige Inventur-Linie (Achse 2 — hängt an der
  Spec). → **Sub-Area-Aspirantin**, bewusst *nicht* als Sub-Area geführt.
  Erst mit eigenem Doku-Style-Standard *und* eigener Drift-Linie kippt sie.
- `tools/` — ein Hilfsskript (`check_closure_notes.py`); Achse 3 erfüllt,
  sonst unter Schwelle. Ebenfalls Aspirantin.

## Glossar (optional)

| Begriff | Bedeutung in diesem Repo |
|---|---|
| DocSearch | das Beispiel-Tool dieses Lab-Verzeichnisses — kleine CLI für Volltext-Suche in lokalen Dokumenten, geführt als Worked Example für den Kurs |
