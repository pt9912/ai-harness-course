# Modul 2 — Harness-Bootstrap

> **Aufwand:** ca. 90 Min Lesen · 90 Min Übung. Spiralcurriculum:
> *Harness-Bootstrap*, *GF/BF-Modus* und *Phase-Reife* sind dir aus
> [Modul 1 Mini-Glossar](modul-01-entwicklungszyklus.md#mini-glossar-für-dieses-modul)
> dem Namen nach bekannt — hier werden sie zum Arbeitswerkzeug.

## Optionale Explorations-Vorab-Übung (Kapur-Stil)

Wenn du eine *echte* Productive-Failure-Variante (Kapur 2008, 2014)
ausprobieren willst: **vor** dem Lesen dieses Moduls 20 Minuten ohne
Anleitung klassifizieren.

> **Aufgabe (optional, 20 Min):** Liste drei *Sub-Areas* deines
> aktuellen Repos auf (z. B. *Konventionen*, *Spec-Schreibung*,
> *Test-Infrastruktur*, *Build-Pipeline*, *Architektur-Diagramme*).
> Notiere zu jeder:
>
> 1. *Was führt — Doku oder Code?* (Wenn die Doku führt und der Code
>    folgt: Greenfield-Modus. Wenn der Code führt und die Doku
>    folgt: Brownfield-Modus. Wenn unklar oder gemischt: Hybrid.)
> 2. *Woran erkennst du das?* (Ein konkretes Beobachtungs-Indiz pro
>    Sub-Area.)
> 3. *Wo bist du dir unsicher?* (Was würdest du nachschlagen müssen,
>    um die Klassifikation festzulegen?)
>
> Erfolg ist *nicht*, dass deine Klassifikation richtig ist. Erfolg
> ist, dass du fühlst, wo die Grenze zwischen GF und BF verläuft —
> und an welcher Stelle deine bisherige Intuition unsicher wird.

Nach dem Modul-Lesen: vergleiche deine Klassifikation mit dem
GF-Walkthrough (Worked Example 1) und dem BF-Walkthrough (Worked
Example 2) unten. Reflektiere mit
[`../grundlagen/reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md) —
insbesondere mit Frage 4 (welche Vorstellung von "klarer Modus" wurde
unzufriedenstellend?).

Wenn du keine Zeit hast: überspringen ist okay. Die Worked Examples
tragen das Modul auch ohne Vorab-Übung.

## Engage

Drei Antworten aus drei Projekten auf dieselbe Frage *"Wie war euer
Bootstrap?"*:

- **Greenfield-Erfahrene**: "Lastenheft schreiben, ADR ableiten,
  Konventionen anlegen, dann coden."
- **Brownfield-Erfahrene**: "Den Bestand auseinanderlesen, die
  Diskrepanz zur gewünschten Norm sehen, Reconciliation-Plan
  machen."
- **Skeptiker**: "Brauchen wir das wirklich, wenn das Repo eh schon
  läuft?"

Alle drei Stimmen treffen einen realen Punkt — aber jeweils für
unterschiedliche *Sub-Areas desselben* Repos. Wer das nicht trennt,
kommentiert die falschen Symptome: dem GF-Erfahrenen erscheint jeder
BF-Modus als Versagen; die Skeptiker-Frage ist legitim, hat aber eine
*sub-area-spezifische* Antwort (nicht "ja/nein für das Repo", sondern
"ja für diese, nein für jene Sub-Area"). Dieses Modul trennt.

## Lernziele

Nach diesem Modul kannst du:

* GF-, BF- und Hybrid-Modus *unterscheiden* und gegen die vier
  Harness-Linsen *verorten* (Verstehen · konzeptuell),
* dein eigenes Repo nach Modus pro Sub-Area *klassifizieren* und die
  Klassifikation in einer Tabelle *dokumentieren* (Anwenden ·
  prozedural),
* einen beobachteten Auslöser einer der vier Trigger-Klassen
  *zuordnen* und gegen die Phase-Reife des berührten Artefakts
  *spiegeln* (Analysieren · konzeptuell),
* eine Phasen-Karte für ein eigenes Artefakt *erstellen* oder einen
  Reconciliation-Plan für eine konkret beobachtete BF-Diskrepanz
  *entwerfen* (Erschaffen · prozedural),
* den eigenen Bootstrap-Modus pro Sub-Area aktiv *überwachen* und
  Modus-Wechsel als Signal *lesen* (Überwachen · metakognitiv) —
  Bootstrap-Diagnose ist eine Selbstführungs-Praxis, kein
  einmaliges Audit.

## Lab-Bezug

* `harness/conventions.md` und `harness/README.md` (Beispiel im
  Lab unter
  [`../../../lab/example/harness/`](../../../lab/example/harness/) —
  Bootstrap-Quelle für Modus-Deklaration pro Sub-Area).
* Vier Beispiel-Repos in BF-Modus klassifiziert:
  [`../grundlagen/fallstudien.md` §Beobachtung aus dem Ist-Zustand](../grundlagen/fallstudien.md#beobachtung-aus-dem-ist-zustand).

> **TODO-Anker:** Ein dediziertes Bootstrap-Lab folgt in einer
> späteren Welle (geplanter Pfad: unter
> [`../../../lab/example/exercises/`](../../../lab/example/exercises/);
> exakter Dateiname noch offen). Bis dahin sind die Übungen am
> eigenen Repo oder am Beispiel-Repo aus
> [`../../../lab/example/`](../../../lab/example/) durchführbar.

## Themen

* GF/BF/Hybrid-Modus pro Sub-Area: Definition, Abgrenzung gegen
  Repo-Klasse und Phase-Reife.
* Die vier Trigger-Klassen (siehe
  [`../grundlagen/konventionen.md` §Vier Trigger-Klassen](../grundlagen/konventionen.md#vier-trigger-klassen)):
  Sync, Promotion, Cross-Reference, Acceptance — plus die
  BF-typische Sync-Trigger-Variante über *Diskrepanz-Auslöser*
  (T3), die im BF-Walkthrough sichtbar wird.
* Phasen-Karte als didaktisches Instrument: sektionsweise
  Reife-Visualisierung eines Artefakts.
* GF-Walkthrough: vom Modus-Beschluss bis zur ersten
  Konventionen-Iteration.
* BF-Walkthrough: Inventur, Diskrepanz-Schock, Reconciliation-Plan,
  Graduation-Trigger.
* Selbstüberwachung des Modus: woran erkenne ich einen Modus-Wechsel
  in der laufenden Arbeit?

## Harness-Einordnung

Bootstrap ist die **initiale Anwendung des Steering-Loops**, laufend
ausgeführt, bis das Repo *steady state* erreicht. Was
[Modul 11 — Verification Harness](../04-qualitaet/modul-11-verification.md)
als laufende Praxis lehrt (Beobachtung → Guide/Sensor → Diff →
Closure), lehrt dieses Modul als *initiale Aufsetzungs-Praxis*:
gleiche Sensoren und Guides, andere Anwendungsphase. Die abstrakte
Verbindung steht in
[`../grundlagen/konventionen.md` §Verbindung zum Steering-Loop](../grundlagen/konventionen.md#verbindung-zum-steering-loop).

Gegen die vier Harness-Linsen aus
[`../grundlagen/konzeptkarte.md`](../grundlagen/konzeptkarte.md):

* **Drift** — Bootstrap ist der erste *Drift-Sensor*: ohne formellen
  Bootstrap bleibt jede spätere Drift unmessbar.
* **Reproduzierbarkeit** — der dokumentierte Modus pro Sub-Area ist
  Voraussetzung dafür, dass ein zweiter Lauf am selben Repo dieselben
  Klassifikationsentscheidungen trifft.
* **Auditierbarkeit** — der Bootstrap-Modus macht die *Begründung*
  jeder Folge-Entscheidung explizit.
* **Steering-Loop** — Bootstrap = initiale Steering-Loop-Anwendung
  (siehe oben).

## Vorab — was hältst du heute für wahr?

*Bevor du die Kernidee liest:* notiere in einem Satz deine spontane
Antwort auf jede dieser drei Fragen.

1. *"Bootstrap — ist das ein einmaliges Setup oder ein laufender
   Modus?"*
2. *"Wenn ein Repo in einer Sub-Area Greenfield ist, gilt das dann
   für das ganze Repo?"*
3. *"Was ist eine Trigger-Klasse — und wozu brauche ich vier davon
   statt einer einzigen 'Bootstrap-Aktion'?"*

Lass die Notiz neben dem Modul liegen. Am Modul-Ende prüft der
Selbstcheck genau diese drei Punkte — und vergleicht mit der scharfen
Konfrontation in §Typische Fehlvorstellungen.

## Kernidee

**Bootstrap ist ein fortlaufender Modus, kein einmaliges Event — und
er gilt pro Sub-Area, nicht pro Repo.** Der Modus ist ein beobachtbares
Verhältnis zwischen Code und Doku, kein Etikett auf dem Repo. Wer den
Modus pro Sub-Area diagnostizieren kann, weiß, *welcher* Trigger die
nächste sinnvolle Aktion auslöst — und spart sich das Ausprobieren auf
der Phasen-Ebene. Genau dieses Diagnose-Vermögen ist das
Lehr-Ergebnis dieses Moduls; die Modus-Wahl als Planungs-Entscheidung
(also: *welcher Modus soll für den nächsten Slice gelten?*) folgt
später in [Modul 5 — Planning Harness](../02-planung/modul-05-planning-harness.md).

## Typische Fehlvorstellungen

* **FV1:** *"Bootstrap ist ein einmaliges Initialisierungs-Event,
  kein laufender Modus."* — Korrektur: Bootstrap ist ein fortlaufender
  Modus, der sich über Sub-Areas und Phase-Reife entwickelt. Jeder
  Trigger ist ein Bootstrap-Mikro-Event. Wer Bootstrap als Setup
  versteht, übersieht die Modus-Wechsel, die im laufenden Betrieb
  passieren, und produziert daher dauerhaft Findings ohne
  Modus-Bewusstsein.
* **FV2:** *"GF/BF ist eine Eigenschaft des Repos als Ganzes."* —
  Korrektur: Modus gilt **pro Sub-Area**. Ein Repo kann in den
  *Konventionen* BF und in der *Spec-Schreibung* GF sein. Die vier
  Beispiele in
  [`../grundlagen/fallstudien.md` §Beobachtung aus dem Ist-Zustand](../grundlagen/fallstudien.md#beobachtung-aus-dem-ist-zustand)
  zeigen diese Sub-Area-Heterogenität explizit.
* **FV3:** *"Wer im Greenfield arbeitet, kann auf die Trigger-Klassen
  verzichten."* — Korrektur: auch im GF-Modus entstehen Trigger
  (Diskrepanz, Promotion-Auslöser etc.), nur nicht aus
  *Bestandsinventur*, sondern aus *Konsistenzprüfung des neu
  Geschaffenen*. Die vier Klassen gelten in jedem Modus; was sich
  ändert, ist die Frequenz und die typische Auslöse-Quelle.
* **FV4:** *"Brownfield ist eine Notlage, die man möglichst schnell
  überwindet."* — Korrektur: BF ist der *typische* Ausgangspunkt
  realer Repos. Die vier Fallstudien sind alle in BF (siehe oben).
  BF kann systematisch in Richtung GF graduieren — *Graduation* ist
  eine ausgewiesene Bedingung mit Konvergenz-Auftrag, kein
  Wunschdenken. Die Frage ist nicht *ob* graduiert wird, sondern
  *wie weit* das Repo schon ist und *welche Sub-Area* als nächstes
  graduations-reif wird.

(Weitere Fehlvorstellungen ergänzen sich aus der
Konvictions-Check-Ausbeute oben — wer mit "Bootstrap = Setup"
gestartet ist, trägt FV1 implizit.)

## Worked Example 1: Greenfield-Bootstrap (DocSearch-Walkthrough)

**Story.** Ein neues Repo `docsearch` soll mit dem Kurs-Harness von
Grund auf aufgesetzt werden — eine Such-Engine über interne
Dokumente. Es gibt noch keinen Code, kein Lastenheft, keine ADRs.
Die Sub-Areas (Konventionen, Spec, Architektur, ADR) starten alle
im GF-Modus: Doku führt, Code wird daran gemessen. Neun Schritte
führen vom leeren Repo zum ersten Code-Slice.

### Übersicht: GF-Walkthrough als Mermaid-Diagramm

```mermaid
flowchart TD
    Start([leeres Repo]):::start
    S0["0. Modus = GF pro Sub-Area"]:::orient
    S1["1. Baseline + Repo-Klasse + ID-Schemata"]:::orient
    S2["2. Templates adoptieren"]:::action
    S3["3. conventions.md (MR-000 + MR-001)"]:::action
    S4["4. lastenheft.md Outline"]:::content
    S5["5. Roadmap + Release-Plan Outline"]:::content
    S6["6. Sensors-Roster im Nicht-behauptet-Block"]:::content
    S7["7. Architektur + Spezifikation Outline"]:::content
    S8["8. ADR-0001 (Proposed)"]:::content
    End([bereit fuer erste Code-Slices]):::endNode

    Start --> S0 --> S1 --> S2 --> S3 --> S4 --> S5 --> S6 --> S7 --> S8 --> End

    classDef start fill:#f5f5f5,stroke:#888
    classDef orient fill:#fff4d6,stroke:#d4a017
    classDef action fill:#dceaff,stroke:#3366cc
    classDef content fill:#e0f0e0,stroke:#3a8a3a
    classDef endNode fill:#f5f5f5,stroke:#888
```

Drei Phasen sind farbig sichtbar: *Orient* (gelb, Schritte 0–1),
*Action* (blau, Schritte 2–3), *Content* (grün, Schritte 4–8).

### Detail-Tabelle (Schritte 0–4: Setup-Phase)

Trigger-Anker (T1, T2, T4, T5, T6, T7) sind Instanz-Beispiele der
vier Trigger-Klassen aus
[`../grundlagen/konventionen.md` §Vier Trigger-Klassen](../grundlagen/konventionen.md#vier-trigger-klassen) —
die abstrakten Definitionen stehen dort, hier nur die Instanzen.

*Hinweis zur T-Nummerierung:* Die Trigger sind durch das
DocSearch-Beispiel nummeriert (T1 = Pointer in README,
T2 = Pointer in AGENTS, T4 = Promotion, T5 = erste ADR-Vorschläge,
T6 = Cross-Reference Spec ↔ ADR, T7 = ADR-Review-Auslöser).
**T3 ist BF-spezifisch** und tritt im Greenfield-Walkthrough nicht
auf — er erscheint in Worked Example 2 als Sync-Trigger in
BF-Diskrepanz-Auslöse-Variante.

| # | Aktion | Berührte Dateien (Phasen-Übergang) | Trigger |
|---|---|---|---|
| 0 | Modus pro Sub-Area entscheiden: GF für *Konventionen*, *Spec*, *Architektur*, *ADR* (alle vier Doku-führt). | keine | keine — Vorbedingung |
| 1 | Baseline-Auswahl (Kurs-Harness) + Repo-Klasse (Tooling) + ID-Schemata festlegen (`LH-*`, `ARC-*`, `SPEC-*`, `MR-*`) | keine | reift 2/3 |
| 2 | Templates aus [`../../../lab/templates/`](../../../lab/templates/) kopieren | alle Skelette **0 → 1** | keine |
| 3 | `harness/conventions.md` mit MR-000 (Baseline) + MR-001 (`ARC-*`/`SPEC-*` als Adaption) | `conventions.md` 0 → 1 | **T1** (Pointer auf `conventions.md` in `harness/README.md`), **T2** (Pointer in `AGENTS.md`) |
| 4 | `spec/lastenheft.md` Outline mit `LH-FA-*`/`LH-QA-*` | `lastenheft.md` 1 → 2 | keine direkt |

### Detail-Tabelle (Schritte 5–8: Inhalts-Phase)

| # | Aktion | Berührte Dateien (Phasen-Übergang) | Trigger |
|---|---|---|---|
| 5 | `docs/plan/planning/roadmap.md` mit Welle + Release-Mapping; `releasing.md` mit Release-Strategie | `roadmap.md` 1 → 2; `releasing.md` 1 → 2 | keine |
| 6 | Sensors-Roster im "Nicht behauptet"-Block (Prosa-Pointer-Liste, kein Status) | `harness/README.md` §Sensors Sub-1 → Sub-2; `AGENTS.md` §4 Sub-1 → Sub-2 | **T4** (Promotion-Auslöser bei erstem Code-Slice) |
| 7 | `spec/architecture.md` + `spec/spezifikation.md` Outline mit `ARC-*`/`SPEC-*` | beide 1 → 2 | **T5** (erste ADR-Vorschläge aus Architektur-Outline) |
| 8 | `docs/plan/adr/0001-doc-source-of-truth.md` mit Status *Proposed* | `0001-…md` 0 → 2; ADR-Index 1 → 2 | **T6** (Cross-Reference Spec ↔ ADR), **T7** (ADR-Review-Auslöser) |
| Bootstrap-Ende | Bereit für ersten Code-Slice — Workflow-Übergang | — | — |

**Anmerkung zur Tabellen-Splittung.** Die Setup-Phase (0–4) etabliert
*was wo lebt*; die Inhalts-Phase (5–8) füllt mit *normativem Inhalt*.
Trigger entstehen erst in der Inhalts-Phase, weil dann Bezüge zwischen
Dokumenten und ADRs notwendig werden. Die Tabellen-Trennung macht
das kognitiv lesbar — die Phasen verschwimmen sonst.

## Worked Example 2: Brownfield-Bootstrap mit Discovery und Reconciliation

**Story.** Ein bestehendes Repo `legacy-search` (Code, Makefile, CI,
Tests) soll formellen Harness-Einstieg bekommen. Es gibt keine
Spec, keine ADRs, kein `harness/conventions.md` — wohl aber
Build-Pipeline, Tests, dokumentierte Konventionen (verstreut in
README, Commit-Messages, Code-Kommentaren). Die Sub-Areas starten
alle im BF-Modus: Code führt, Doku folgt mit Inventur-Auftrag. Neun
Schritte führen vom inventur-bedürftigen Repo zum Reconciliation-
Backlog mit sichtbarem Konvergenzpfad zu GF.

### Übersicht: BF-Walkthrough als Mermaid-Diagramm

```mermaid
flowchart TD
    Start([Repo mit Code/Makefile/CI<br/>ohne Harness]):::startBF
    S1["1. Modus = BF + Repo-Klasse + ID-Schemata"]:::orient
    S2["2. Code-Inventur (Discovery)"]:::discover
    S3["3. Templates adoptieren"]:::action
    S4["4. conventions.md (Modus = BF, MR-000)"]:::action
    S5["5. Sensors-Haupt-Tabelle aus Makefile"]:::contentBF
    S6["6. Lastenheft Reverse-Engineering aus Tests/CI"]:::contentBF
    S7["7. Architektur + Spec Reverse-Engineering"]:::contentBF
    S8["8. Diskrepanz-Schock + CO-DS + Reconc.-Slices"]:::discrepancy
    S9["9. Roadmap als Reconciliation-Plan"]:::contentBF
    Graduation[/"Konvergenz-Ziel: Graduation BF -> GF"/]:::goal

    Start --> S1 --> S2 --> S3 --> S4 --> S5 --> S6 --> S7 --> S8 --> S9 -.-> Graduation

    classDef startBF fill:#fef0f0,stroke:#a14040
    classDef orient fill:#fff4d6,stroke:#d4a017
    classDef action fill:#dceaff,stroke:#3366cc
    classDef discover fill:#f0e5ff,stroke:#7a3acc
    classDef contentBF fill:#ffe9d6,stroke:#cc7733
    classDef discrepancy fill:#ffd9d9,stroke:#cc3333
    classDef goal fill:#dff5e8,stroke:#3a8a3a,stroke-dasharray: 6 4
```

Vier Phasen sind farbig sichtbar: *Orient* (gelb), *Discover* (lila,
neu in BF), *Action* (blau), *Content-BF* (orange), *Diskrepanz-
Schock* (rot, neu in BF), *Goal/Graduation* (grün gestrichelt).

### Detail-Tabelle (Schritte 1–4: Inventur-Phase, was bei BF anders ist)

*Hinweis zur Schritt-Nummerierung:* BF nimmt die Modus-Setzung in
Schritt 1 mit (wo GF Schritt 0 trägt), weil in BF die
Repo-Klassen-Wahl und die Modus-Antizipation zusammenfallen — beide
hängen von der ersten Inventur-Beobachtung ab und können nicht *vor*
dem ersten Hinschauen entschieden werden. Daher die asymmetrische
Nummerierung GF 0–8 vs. BF 1–9.

| # | Aktion | BF-Besonderheit gegenüber GF |
|---|---|---|
| 1 | Wie GF-Schritt 1, plus Modus-Antizipation "BF pro Sub-Area" | + explizite Modus-Setzung mit Sub-Area-Aufzählung |
| 2 | **Code-Inventur (Discovery):** Makefile, CI, Tests, README, Commit-Messages inventarisieren als Lerner-Schritt | **neu in BF** — kein Repo-Artefakt entsteht, nur Lerner-Wissen |
| 3 | Templates adoptieren | wie GF |
| 4 | `harness/conventions.md` mit Modus = BF pro Sub-Area, MR-000-Aussage | Modus-Block anders strukturiert (BF-Deklarationen + Konvergenz-Auftrag pro Sub-Area) |

### Detail-Tabelle (Schritte 5–9: Reconciliation-Phase)

| # | Aktion | BF-Besonderheit gegenüber GF |
|---|---|---|
| 5 | Sensors-Haupt-Tabelle direkt aus Makefile-Kommentaren entstehen lassen | **gegenteilig zu GF** — Targets existieren, keine "Nicht behauptet"-Promotion nötig; **T3** (Sync-Trigger in BF-Diskrepanz-Auslöse-Variante: Sensor-Lücke = impliziter Pointer-Mismatch zwischen Makefile-Realität und Sensor-Tabelle) wird sichtbar |
| 6 | Lastenheft aus Code/Tests/CI rückbauen | Inventur-Umkehr; Diskrepanz-Material entsteht (Code ohne Anforderung, Test ohne LH-Bezug) |
| 7 | Architektur + Spezifikation aus `src/` rückbauen; **retroaktive ADRs** für implizite Entscheidungen | ADRs teils retroaktiv mit Status *Accepted* (oder *Superseded*, falls Entscheidung schon revidiert) |
| 8 | **Diskrepanz-Schock:** Diskrepanzen klassifizieren als (a) `CO-DS-*` (orphan code ohne Anforderung), (b) Reconc.-Slice (orphan requirement ohne Code), (c) retro-ADR (implicit decision) | **BF-spezifischer Schritt** — die Reconciliation-Pflicht macht hier den Modus-Übergang sichtbar; **T3** (Sync-Trigger zwischen Code-Realität und Anforderungs-Anker, in BF-typischer Diskrepanz-Auslöse-Variante) als typische Trigger-Quelle |
| 9 | Roadmap als Reconciliation-Plan; letzte Welle = Graduation pro Sub-Area | Inhalt anders als GF-Roadmap — Plan ist Diskrepanz-Auflösungs-Sequenz, nicht Feature-Sequenz |
| Bootstrap-Ende | Reconciliation-Backlog steht, Konvergenzpfad zu GF pro Sub-Area sichtbar | — |

**Diskrepanz-Schock als didaktischer Anker.** Schritt 8 ist die Stelle,
an der BF-Erfahrene merken, dass die Inventur-Arbeit der vorigen
Schritte überhaupt einen Sinn hat: sie macht die Diskrepanzen
*explizit*, statt sie als implizite Last weiter zu tragen. Genau
diesen Moment werden Lernende im eigenen Repo wiedererkennen — der
Schock ist eine pädagogisch wertvolle Erfahrung, keine
Pannenerscheinung.

## Phasen × Modus — die zweidimensionale Reife-Matrix

Beide Walkthroughs bewegen Artefakte durch **Phase-Reife** (0–5)
pro Sektion (sechs Stufen, siehe
[`../grundlagen/konventionen.md` §Sektionsweise Reife](../grundlagen/konventionen.md#harness-bootstrap)).
Die folgende Matrix macht sichtbar, *was Phase-N in GF bedeutet
versus was sie in BF bedeutet* — dieselbe Phase-Stufe,
unterschiedliche Bewegungsrichtung:

| | Greenfield (Doc → Code) | Brownfield (Code → Doc) |
|---|---|---|
| **Phase 0 leer** | Datei existiert nicht — Pflicht zur Anlage aus Konvention | Datei existiert nicht — Inventur stellt fest, dass Doku-Anker fehlt |
| **Phase 1 Skelett** | Template kopiert, *Versprechen* zu füllen | Template kopiert, *Inventur-Auftrag* an Code |
| **Phase 2 Outline** | Top-Level-Wunschbild | Top-Level-Bestandsaufnahme |
| **Phase 3 partiell** | Sektionen versprochen, Code folgt | Sektionen dokumentiert, andere unentdeckt |
| **Phase 4 kohärent** | Vertrag steht, Code wird daran gemessen | Inventur abgeglichen, **Diskrepanz-Schock sichtbar** |
| **Phase 5 stabil** | Change-Process aktiv | Reconciliation-Slice oder Carveout aktiv |

Die Matrix ist *die* Lesart für jede Bootstrap-Aktion: erst
identifizieren, *welche Sub-Area* sich bewegt; dann *welche Phase*
sie erreicht; dann *in welchem Modus* — daraus folgt der nächste
Schritt fast deterministisch. In Übung 3 (siehe §Übungen) füllst du
selbst eine Phasen-Karte für ein eigenes Artefakt aus.

## Übungen

Drei Übungen, jede gegen genau ein Lernziel aus dem §Lernziele-Block
verankert. Das Lernziel *Verstehen · konzeptuell* wird durch die
Klassifikations-Vorstufe von Übung 1 implizit geprüft — wer korrekt
klassifiziert, hat die GF/BF/Hybrid-Unterscheidung verstanden.

### Übung 1 — Modus pro Sub-Area klassifizieren (LZ Anwenden · prozedural)

Klassifiziere dein eigenes Repo nach Modus pro Sub-Area. Tabellen-
Vorlage:

| Sub-Area | Modus (GF/BF/Hybrid) | Beobachtungs-Indiz | Unsicherheit? |
|---|---|---|---|
| Konventionen | … | … | … |
| Spec-Schreibung | … | … | … |
| Architektur | … | … | … |
| Test-Infrastruktur | … | … | … |
| Build/CI | … | … | … |

*Mindestens drei Sub-Areas befüllen.* Pro Zeile:

1. **Modus** — GF, BF oder Hybrid.
2. **Beobachtungs-Indiz** — konkretes Indiz (z. B. *"AGENTS.md
   existiert seit drei Monaten, aber Tests-Verzeichnis verweist
   immer noch auf alten Pfad"* → BF in *Test-Infrastruktur*).
3. **Unsicherheit** — was du nachschlagen musst, um die Wahl
   abschließend zu treffen.

*Erfolgskriterium:* mindestens *eine* Sub-Area, die du anders
klassifizierst, als du vor dem Modul-Lesen vermutet hättest. Wenn
deine Kapur-Vorab-Übung komplett mit dieser Übung übereinstimmt,
hast du wahrscheinlich oberflächlich klassifiziert.

### Übung 2 — Trigger-Klassen zuordnen (LZ Analysieren · konzeptuell)

**Alternativ-Vorlage (Standard für dieses Modul, weil Modul 2 vor
dem ersten Slice liegt):** Identifiziere fünf Trigger aus der
DocSearch-Beispiel-Trigger-Liste in §Worked Example 1 und ordne sie
den vier Trigger-Klassen aus
[`../grundlagen/konventionen.md` §Vier Trigger-Klassen](../grundlagen/konventionen.md#vier-trigger-klassen)
zu:

| Trigger | Klasse | Begründung |
|---|---|---|
| T1 (Pointer in `harness/README.md` auf `conventions.md`) | Sync-Trigger | … |
| T2 (Pointer in `AGENTS.md`) | … | … |
| T4 (Promotion bei Code-Slice) | … | … |
| T5 (erste ADR-Vorschläge aus Architektur-Outline) | … | … |
| T6 oder T7 (Cross-Reference Spec↔ADR / ADR-Review) | … | … |

*Optional, falls du schon einen Slice durchlaufen hast:* Nimm fünf
Trigger aus deinem letzten Slice statt aus dem DocSearch-Beispiel.
Diese Variante setzt eigene Slice-Erfahrung voraus — sie ist die
Transfer-Form der Übung.

### Übung 3 — Phasen-Karte ausfüllen (LZ Erschaffen · prozedural)

Erstelle eine Phasen-Karte für ein Artefakt deiner Wahl (z. B.
`harness/conventions.md`, `spec/lastenheft.md`,
`docs/plan/planning/roadmap.md`). **Faded scaffolding** — die Hälfte
der Vorlage ist gefüllt, den Rest füllst du selbst:

| Sektion | Aktuelle Phase (0–5) | Begründung | Nächster Modus-/Trigger-Anker |
|---|---|---|---|
| §Kernidee | 4 | "Vertrag steht, Code wird daran gemessen" | bei Spec-Änderung → T6 Cross-Reference-Trigger zur ADR |
| §Sensors | … | … | … |
| §Source Precedence | 2 | "Top-Level-Wunschbild, noch nicht durchverbunden" | … |
| §Closure-Regel | … | … | … |
| §Adaption | 1 | "Template kopiert, Versprechen zu füllen" | … |

*Mindestens drei Zeilen vollständig ausfüllen* (auch die noch nicht
gestarteten — Phase 0 oder Phase 1 sind legitime Reifegrade,
*"existiert nicht"* ist ein gültiger Befund). Die Phase-Stufen 0–5
stehen in der Phase × Modus-Matrix weiter oben.

*Erfolgskriterium:* mindestens eine Sektion in einer anderen Phase
als die übrigen — sektionsweise Reife ist das Lehr-Ergebnis, und
genau diese Heterogenität ist der Punkt der Übung.

## Reflexion

Verwende die vier Standardfragen aus
[`../grundlagen/reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md)
(Beobachtung · 2×2-Quadrant · Steering-Loop · Conceptual Change)
nach den Übungen. Modul-spezifische Trigger:

- **Beobachtung:** Welche Sub-Area-Klassifikation in Übung 1 hat
  dich überrascht — und was hat dich vorher in eine andere Lesart
  kippen lassen?
- **2×2-Quadrant:** Bootstrap-Diagnose ist klassisch *inferential
  feedforward* (siehe
  [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)) —
  die Diagnose wirkt *vor* der Aktion, nicht *nach*.
- **Steering-Loop:** Welche Sub-Area in deinem Repo trägt heute
  eine Modus-Aussage, die du beim nächsten Slice prüfen lässt?
  Welcher Sensor (Make-Target, Doc-Konsistenz-Agent, Closure-Note)
  würde das prüfen?
- **Conceptual Change:** Vergleiche deinen Konvictions-Check
  (§Vorab — was hältst du heute für wahr?) mit deiner heutigen
  Antwort. Welche Vorstellung hat sich verschoben? Kandidaten in
  [`../grundlagen/lernervorstellungen.md`](../grundlagen/lernervorstellungen.md)
  (insbesondere FV1, FV2 aus §Typische Fehlvorstellungen).

**Metakognitive Reflexionsfrage** (Träger für Lernziel
*Überwachen · metakognitiv*):

> In welcher Sub-Area deines Repos bist du dir *gerade jetzt*
> unsicher, welcher Modus gilt — und was wäre dein nächster Schritt,
> diese Unsicherheit aufzulösen?

Die Frage prüft nicht *was du weißt*, sondern *ob du beobachten
kannst, was du nicht weißt*. Diese Selbstüberwachung ist die
metakognitive Kompetenz, ohne die Bootstrap-Diagnose im laufenden
Betrieb still verfällt.

## Selbstcheck

Die metakognitive Selbstüberwachung (Lernziel *Überwachen ·
metakognitiv*) wird in §Reflexion geprüft, nicht im Selbstcheck.
Der Selbstcheck deckt die übrigen vier Lernziele plus die
Conceptual-Change-Selbstvalidierung ab.

* **(Verstehen · konzeptuell — geprüft durch Übung 1)** Was
  unterscheidet GF-Modus von BF-Modus? Warum gilt der Modus *pro
  Sub-Area* und nicht pro Repo?
* **(Verstehen · konzeptuell — Voraussetzung für Anwenden in Übung 2)**
  Welche vier Trigger-Klassen gibt es laut
  [`../grundlagen/konventionen.md` §Vier Trigger-Klassen](../grundlagen/konventionen.md#vier-trigger-klassen)?
  Nenne pro Klasse ein Beispiel aus den beiden Worked Examples.
* **(Analysieren · konzeptuell — aktiviert durch Übung 2)** Welcher
  Trigger in Worked Example 2 macht den BF-Modus-Übergang sichtbar
  — und warum gerade dieser?
* **(Erschaffen · prozedural — aktiviert durch Übung 3)** Was
  bedeutet *Phase 4 kohärent* in GF gegenüber BF? Nenne pro Modus
  ein konkretes Indiz aus der Phase × Modus-Matrix.
* **(Conceptual Change — Selbstvalidierung)** Vergleiche jetzt
  deine Spontanantworten zu den drei §Vorab-Fragen mit deiner
  heutigen Antwort. Welche hat sich verschoben? Welche ist gleich
  geblieben — und warum hält sie?

### Selbstcheck-Rubrik

Die generische Erklärung der drei Stufen steht in
[`../grundlagen/selbstcheck-rubrik.md`](../grundlagen/selbstcheck-rubrik.md);
die modulspezifischen Indikatoren sind:

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| GF vs. BF, pro Sub-Area? | "GF = Doku führt, BF = Code führt." | Plus Sub-Area-Argument mit Beispiel ("ein Repo kann in *Konventionen* BF und in *Spec-Schreibung* GF sein"), Verweis auf `fallstudien.md` §Beobachtung. | + Hybrid-Fall benannt; Erklärung, warum die Repo-Ebene zu grob für die Modus-Entscheidung ist (Verweis auf die vier Trigger-Klassen als kontextuelle Differenzierung). |
| Vier Trigger-Klassen, je ein Beispiel? | Drei Klassen genannt, ohne Worked-Example-Bezug. | Alle vier Klassen genannt + je ein Trigger aus WE1 oder WE2 als Beispiel. | + Begründung, warum die vier Klassen *erschöpfend* sind (was würde nicht in eine der vier passen?); Verweis auf `konventionen.md` §Vier Trigger-Klassen für die Definition. |
| Trigger in WE2, der BF-Übergang sichtbar macht? | "T3" oder "Diskrepanz". | T3 als **Sync-Trigger in BF-Diskrepanz-Auslöse-Variante** bei Schritt 5 oder 8 — Begründung: weil dort die Inventur-Umkehr (Code → Doc) auf Bestand trifft, der keinem Anforderungs-Anker entspricht (impliziter Pointer-Mismatch). | + Pointe: T3 ist *keine fünfte Klasse*, sondern eine BF-typische Auslöse-Variante von Sync (die vier Klassen aus konventionen.md bleiben erschöpfend). Plus: Diskrepanz-Schock ist der pädagogisch wertvolle Moment, an dem die Inventur-Arbeit der vorigen Schritte einen sichtbaren Sinn bekommt. |
| Phase 4 kohärent in GF vs. BF? | "In GF steht der Vertrag, in BF die Inventur." | GF Phase 4: *Vertrag steht, Code wird daran gemessen* (z. B. CI-Gates greifen). BF Phase 4: *Inventur abgeglichen, Diskrepanz-Schock sichtbar* (z. B. CO-DS-* oder Reconc.-Slice-Backlog). | + Begründung, warum *Phase 4* die kritische Stufe in BF ist (vorher: Inventur arbeitet, nachher: Reconciliation läuft); Verweis auf Modul 7 §Carveouts für die `CO-DS-*`-Konvention. |
| Konvictions-Check: welche Verschiebung? | Keine Verschiebung benannt oder pauschal "alles klarer". | Eine konkrete Antwort: welche §Vorab-Frage hat sich um welchen Halbsatz verschoben? Verweis auf eine Fehlvorstellung (FV1–FV4), die deine Spontanantwort getragen hat. | + Pointe: welche Vorstellung gleich geblieben ist und *warum sie hält* — Conceptual-Change-Reflexion verlangt, beides zu zeigen, nicht nur Verschiebung. |

## Weiterlesen

* Konzept-Anker für alle Bootstrap-Begriffe und die vier
  Trigger-Klassen:
  [`../grundlagen/konventionen.md` §Harness-Bootstrap](../grundlagen/konventionen.md#harness-bootstrap).
* Verbindung zum Steering-Loop (Bootstrap = initiale
  Steering-Loop-Anwendung):
  [`../grundlagen/konventionen.md` §Verbindung zum Steering-Loop](../grundlagen/konventionen.md#verbindung-zum-steering-loop).
* Die vier Beispiel-Repos in GF/BF-Klassifikation:
  [`../grundlagen/fallstudien.md` §Beobachtung aus dem Ist-Zustand](../grundlagen/fallstudien.md#beobachtung-aus-dem-ist-zustand).
* Modus-*Wahl* als Planungs-Entscheidung (Diagnose aus diesem Modul
  → Wahl im nächsten Slice):
  [Modul 5 — Planning Harness](../02-planung/modul-05-planning-harness.md).
* Steering-Loop im Steady-State (was Bootstrap *nach* Graduation
  wird):
  [Modul 11 — Verification Harness](../04-qualitaet/modul-11-verification.md).
* Lernervorstellungen-Sammlung für Conceptual-Change-Reflexion:
  [`../grundlagen/lernervorstellungen.md`](../grundlagen/lernervorstellungen.md).
* Vorheriges Modul: [Modul 1 — Der Entwicklungszyklus](modul-01-entwicklungszyklus.md).
* Nächstes Modul: [Modul 3 — Lastenheft und Spezifikation](modul-03-lastenheft.md).
