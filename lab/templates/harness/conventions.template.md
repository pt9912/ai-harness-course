# Harness-Konventionen

> **Template-Hinweis.** Diese Datei ist eine Vorlage für
> `harness/conventions.md` deines Repos. Kopiere sie nach
> `harness/conventions.md`, ersetze `<Platzhalter>` und lösche
> diesen Block. Pflichtgliederung folgt
> [Kurs Konventionen / `harness/README.md` als Einstiegspunkt](../../../kurs/de/grundlagen/konventionen.md#harnessreadmemd-als-einstiegspunkt).
>
> **Was diese Datei trägt:** repo-lokale Strukturregeln und Adaptionen
> ggü. der adoptierten Harnesskonvention (Baseline). Sie ist
> **Pflicht** (Existenz), die Form (Einzeldatei vs. Verzeichnis,
> ADR-artig vs. Prosa) ist **Wahl**.
>
> **Was diese Datei NICHT trägt:** Kurs- oder Baseline-Konventionstext
> wird nicht dupliziert — Pointer reichen. Sonst drift gegen die Quelle.

---

## Purpose

Diese Datei deklariert die *repo-lokalen* Strukturregeln dieses Repos
gegenüber der adoptierten Harnesskonvention (Baseline). Sie ist der
Default-Ort für:

- **Adaptionen** ggü. der Baseline (mit Begründung und Auflösungs-Trigger).
- **Zusatzklassen-Deklarationen** für repo-spezifische
  Bindung-Klassen in der Sensors-Tabelle, die über die vier kanonischen
  hinausgehen (ADR, Carveout, Schwelle, Reproduzierbarkeit).
- **Modus-Deklarationen** pro Sub-Area (Greenfield / Brownfield /
  Hybrid) inklusive Konvergenz-Auftrag bei BF.

Bei Konflikt zwischen dieser Datei und einer kanonischen Quelle gilt die
kanonische Quelle (Source Precedence). Diese Datei ist konformitäts-
bringend für *Form*-Fragen, nicht autoritativ über Inhalt.

## Baseline

<!--
Welche Harnesskonvention wird adoptiert? Stand und Datum festhalten,
damit spätere Adaptionen einen Bezugspunkt haben.
-->

- **Konvention:** <Name, z. B. "AI-Harness-Kurs", interner Standard, Industrie-Norm>
- **Stand:** <Datum oder Version, z. B. "Template-Set 2026-06">
- **Datum der Adoption:** <Datum>

## Adoptierte Konventions-Quellen

<!--
Pointer auf die Quellen der Baseline. KEINE Wiederholung des Inhalts —
nur Verweise.
-->

- **Extern (Lehrmaterial):** <Pfad oder URL>
- **In-Repo (verkörperte Form):** <Pfade zu adoptierten Templates>

## Adaptions-Block

<!--
ADR-artige Liste der Abweichungen ggü. Baseline.
Jeder Eintrag mit Pflichtfeldern: ID (MR-<NNN>), Datum, Geltungsbereich,
Adaption, Begründung, Auflösungs-Trigger (oder "permanent").

Disziplin: chronologisch nummeriert, keine nachträglichen
inhaltlichen Änderungen an akzeptierten Einträgen — nur neue Einträge
oder explizite Aufhebungen via neuen MR.
-->

### MR-000 — Baseline-Aussage

- **Datum:** <Datum>
- **Geltungsbereich:** gesamtes Repo
- **Adaption:** *keine inhaltlichen Adaptionen ggü. Baseline-Default
  für Verzeichniskonvention, Source Precedence, Lifecycle,
  Carveout-Disziplin.*
- **Begründung:** Initial-Setzung. Spätere Adaptionen werden als
  `MR-<NNN>` nachgetragen.
- **Auflösungs-Trigger:** permanent.

<!-- Beispiel-Eintrag für eine konkrete Adaption: -->

### MR-001 — <Titel der Adaption>

- **Datum:** <Datum>
- **Geltungsbereich:** <Dateien / Module / Sub-Areas>
- **Adaption:** <was weicht inhaltlich ab>
- **Begründung:** <warum, idealerweise mit Praxis-Bezug>
- **Auflösungs-Trigger:** <Trigger oder "permanent">

## Zusatzklassen-Deklaration für Sensors-Bindung

<!--
Die vier kanonischen Bindung-Klassen der Sensors-Tabelle in
`harness/README.md` (ADR, Carveout, Schwelle, Reproduzierbarkeit) sind
ohne Deklaration legitim.

Repos können weitere Klassen einführen — z. B. Anforderungs-Bindung
(`LH-...`), Compliance-Bindung (Regulatorik-Artikel), Modell-Version-
Bindung (für KI-Evals). Diese müssen hier deklariert werden, sonst sind
sie für Reviewer nicht von Tippfehlern unterscheidbar.

Eine nicht-deklarierte Zusatzklasse in der Sensors-Tabelle ist eine
stille Setzung und damit Harness-Lüge in derselben Klasse wie ein
halluziniertes Gate (Modul 12).
-->

| Klasse | Form | Bedeutung | Beispiel |
|---|---|---|---|
| <z. B. LH-Bindung> | `LH-<...>` | <z. B. Gate prüft eine bestimmte LH-Anforderung> | <z. B. `LH-QA-01` für Determinismus-Gate> |

<!-- Wenn keine Zusatzklassen verwendet werden: Tabelle entfernen oder
"— keine —" eintragen. -->

## Modus-Deklaration pro Sub-Area

<!--
Pro Modul / Verzeichnis / Sub-Area: Modus festlegen.
- Greenfield (GF): Doc führt, Code folgt. Steady-State.
- Brownfield (BF): Code führt, Doc folgt. Übergangsmodus mit
  Konvergenz-Auftrag zu GF. Graduation-Bedingung benennen.
- Hybrid: gemischt pro Sub-Sub-Area.
- Permanent-BF (selten): nur für Code, der absehbar entfernt wird;
  mit Begründung und Folge-Slice analog zu permanentem Carveout.

Eine Sub-Area in BF *ohne* Graduation-Plan ist eine Harness-Lüge:
"permanente Ausnahme als temporär getarnt" (Modul 6 Analogie).
-->

| Sub-Area (Pfad / Modul) | Modus | Begründung | Graduation-Bedingung / Folge-Slice |
|---|---|---|---|
| `*` (Default für gesamtes Repo) | <Greenfield / Brownfield / Hybrid> | <warum> | <Bedingung oder "n/a (GF)" oder "permanent + slice-Ref"> |

## Glossar (optional)

<!--
Repo-spezifische Begriffe, die im Kurs-Glossar nicht stehen.
Nur ergänzen, nicht Kurs-Glossar wiederholen.
-->

| Begriff | Bedeutung |
|---|---|
| <repo-spezifischer Begriff> | <Bedeutung in diesem Repo> |
