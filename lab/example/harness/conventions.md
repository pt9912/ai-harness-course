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
- **In-Repo (verkörperte Form):** Template-Set unter [`/lab/templates/`](../../../lab/templates/) als Form-Lookup-Quelle

## Adaptions-Block

### MR-000 — Baseline-Aussage

- **Datum:** 2026-06-01
- **Geltungsbereich:** gesamtes Repo
- **Adaption:** *Keine inhaltlichen Adaptionen ggü. Baseline-Default
  für Verzeichniskonvention, Source Precedence, Lifecycle-Regeln,
  Carveout-Disziplin, ID-Schema (LH-FA-*, LH-QA-*, ADR-NNN, CO-NNN,
  slice-NNN, MR-NNN).*
- **Begründung:** Initial-Setzung. Dieses Beispiel-Repo ist
  Lehr-Vehikel und folgt der Kurs-Konvention sturer als ein realer
  Bedarfsfall, damit die Konvention als solche sichtbar bleibt.
- **Auflösungs-Trigger:** permanent.

## Zusatzklassen-Deklaration für Sensors-Bindung

DocSearch nutzt neben den vier kanonischen Bindung-Klassen (ADR ·
Carveout · Schwelle · Reproduzierbarkeit) **eine** Zusatzklasse:

| Klasse | Form | Bedeutung | Beispiel im Repo |
|---|---|---|---|
| LH-Bindung | `LH-FA-<NNN>` · `LH-QA-<NNN>` | Gate prüft direkt eine Anforderung aus `spec/lastenheft.md` | `LH-QA-02` als Bindung von `make test-determinism` (siehe [`README.md` §Sensors](README.md#sensors-feedback-gates)) |

## Modus-Deklaration pro Sub-Area

| Sub-Area | Modus | Begründung | Graduation-Bedingung / Folge-Slice |
|---|---|---|---|
| `*` (gesamtes Repo) | Greenfield | DocSearch ist als Lehr-Beispiel von Beginn an mit Harness konzipiert; Spec führt, Code folgt. | n/a (GF Steady-State) |

## Glossar (optional)

| Begriff | Bedeutung in diesem Repo |
|---|---|
| DocSearch | das Beispiel-Tool dieses Lab-Verzeichnisses — kleine CLI für Volltext-Suche in lokalen Dokumenten, geführt als Worked Example für den Kurs |
