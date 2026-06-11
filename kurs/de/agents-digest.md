# Agents-Digest — der Kurs als Betriebsregelwerk

**Stand:** Kurs-Welle 18 · 2026-06-11 · 20:32 CEST

> **Was diese Datei ist.** Das destillierte, operative Wissen des
> Kurses für **Code-Agenten**: Konventionen, Regeln, Workflows — ohne
> die Didaktik-Schicht (Engage, Übungen, Selbstchecks, Lösungen,
> Reflexionen), die für Menschen gebaut ist. Ein Agent, der dieses
> Dokument gelesen hat, kennt das Regelwerk; ein Mensch, der den Kurs
> lernen will, liest die [Module](README.md#lernfortschritt).
>
> **Was diese Datei NICHT ist.** Eine Quelle der Wahrheit. Sie ist ein
> **derivatives Sicht-Artefakt** ohne eigene Normativität — bei
> Konflikt gilt die Quelle (Rang unten). Wer hier eine Regel ändert,
> ohne die Quelle zu ändern, erzeugt die Drift, die §1 verbietet.

## 0. Quellen-Rang dieses Digests

1. [`grundlagen/konventionen.md`](grundlagen/konventionen.md) — normative Strukturregeln (Glossar: [§Kernbegriffe](grundlagen/konventionen.md#kernbegriffe)).
2. [`grundlagen/klassifikation.md`](grundlagen/klassifikation.md) und [`grundlagen/durchsetzungsschicht.md`](grundlagen/durchsetzungsschicht.md) — Kernmodell.
3. Die Modultexte der Phasen 01–05 — Tiefe pro Thema.
4. **Dieses Digest** — derivativ; nie normative Grundlage einer Entscheidung.

Verkörperte Form zum Kopieren: [`/lab/templates/`](../../lab/templates/)
(AGENTS.md, harness/, spec/, ADR, Slice, Welle). Lauffähiges Beispiel:
[`/lab/example/`](../../lab/example/).

## 1. Kernmodell

- **Harness statt Prompt.** Verlässlichkeit kommt nicht aus besseren
  Prompts, sondern aus einem Geschirr aus Artefakten und Kontrollen um
  den Agenten herum. Doppelaufgabe: **constrain** (Grenzen: Architektur,
  Tools, Layer) und **inform** (Kontext: Spec, ADR, AGENTS.md, Skills).
- **2×2-Klassifikation (Böckeler).** Jede Kontrolle liegt in genau
  einem Quadranten: *Feedforward* (vor der Handlung: Guide) oder
  *Feedback* (nach der Handlung: Sensor) × *computational* (maschinell
  prüfbar) oder *inferential* (LLM-/menschliches Urteil). Beispiele:
  Tool-Constraint = computational feedforward; Spec/ADR/AGENTS.md =
  inferential feedforward; Gate = computational feedback;
  Reviewer-Agent = inferential feedback.
- **Faustregel: so weit „links und oben" wie möglich** — präventive,
  deterministische Kontrollen sind die billigsten; inferential
  feedback (Review, Verifikation) greift erst, was die anderen
  Quadranten nicht abdecken können. Eine Regel, die der Typchecker
  erzwingt, braucht keinen Reviewer-Agent.
- **Lifecycle-Verteilung:** Kontrollen so früh wie möglich — Stufen
  *Pre-commit/IDE → Pre-integration → Post-integration → Continuous*,
  Kosten steigen pro Stufe. Eine Prüfung, die folgenlos früher laufen
  könnte, soll früher laufen; eine Coverage-Prüfung erst im
  Continuous-Lauf kommt zu spät, um auf den Slice zurückzuwirken.
- **Drei Harness-Kategorien (Böckeler):** Maintainability (lesbar,
  modular) · Architecture Fitness (Constraints eingehalten) ·
  Behaviour (tut das Richtige).
- **Drei operative Säulen (OpenAI):** Context Engineering ·
  Architectural Constraints · Entropy Management.
- **Steering Loop:** beobachtetes Agenten-Versagen → Guide/Sensor
  verbessern → Wiederholung reduzieren. Eskalationsregel: **1× =
  notieren, keine Aktion · 2× = Symptom, beobachten und kategorisieren
  · 3× = Harness-Lücke, Guide oder Sensor nachziehen** — z. B.
  wiederkehrender Spec-Bug → Spec-Template erweitern; ADR-Verstoß →
  ArchUnit-Regel; Tool-Missbrauch → Tool-Allowlist verschärfen;
  Halluzinations-Muster → Reviewer-Skill. Wer auf jeden Einzelfehler
  ein Gate baut, erstickt den Harness; wer auf keinen wiederkehrenden
  Fehler reagiert, macht ihn irrelevant. Vor dem Einziehen eines neuen
  Sensors die passende Sensor-Klasse wählen
  ([Gate-Typ ↔ Fehlerbild](04-qualitaet/modul-13-quality-gates.md#gate-typ--fehlerbild)).
  Der Steering Loop ist die einzige Stelle im Prozess, an der der
  Mensch unersetzbar bleibt: er entscheidet, wo der Harness wächst.
- **Harness-Lüge** (verboten): der Harness behauptet eine Kontrolle,
  die real nicht greift — halluziniertes Gate, stille Setzung, Pointer
  auf nicht existierende Mechanik. **Häufigste Form: ein behauptetes
  Gate ohne Make-Target — und der Implementation-Agent vertraut ihm.**
  Auch ein Spec-Dokument ohne deklariertes Stratum ist eine stille
  Setzung und **nicht normativ zitierbar**, bis es deklariert ist.
- **Halluzination ist ein Kontext-Bug, kein Modell-Bug.** Die richtige
  Frage ist nicht „warum hat das Modell das erfunden", sondern „was im
  Kontext hätte das Erfinden verhindert" — fehlende Spec-Aussage, ADR,
  AGENTS.md-Regel oder Tool-Allowlist. Wer auf Modellwechsel setzt,
  sieht dieselbe Halluzinations-Klasse wiederkommen, weil das
  Kontext-Loch bleibt.
- **Multi-Repo-Einführung:** immer beim Referenz-Repo beginnen und
  erst nach erfolgreicher Steering-Loop-Iteration auf weitere Repos
  portieren. Alle Repos parallel mit demselben Master-Prompt zu
  treiben skaliert nicht — der Agent verteilt halbgare Standardtexte.

## 2. Artefaktkette und Verzeichnisse

Lebenszyklus (sieben Stationen): **Spec → ADR → Plan (Slices) → Code →
Review (gegen Plan/ADR) → Verifikation (gegen DoD/Spec) → Closure mit
Lerneintrag**, mit Rückkanten (Review-Finding → Plan ·
Closure-Lerneintrag → Spec und ADR). Review und Verifikation fangen
unterschiedliche Fehlerklassen — getrennte Rollen mit getrenntem
Eingabe-Kontext (§6). Jedes Artefakt verweist nach oben (Begründung)
und nach unten (Konsequenz); eine Kette ohne Rückverweise ist nicht
auditierbar. Verzeichniskonvention:

```
spec/                         # Lastenheft, Spezifikation, Architektur
docs/plan/adr/                # ADRs + Index
docs/plan/planning/open/      # geplante Slices
docs/plan/planning/next/      # priorisiert für die nächste Welle
docs/plan/planning/in-progress/
docs/plan/planning/done/      # geschlossen, mit Lerneintrag
docs/plan/carveouts/          # dokumentierte Ausnahmen (CO-<NNN>)
docs/reviews/                 # Review-Reports, ein Report pro Lauf
harness/README.md             # Harness-Einstieg (Pflicht)
harness/conventions.md        # repo-lokale Strukturregeln (Pflicht)
.harness/                     # Skills pro Agenten-Rolle
AGENTS.md                     # Briefing: Hard Rules + Pointer
```

**Bootstrap und Modus** ([§Konventionen](grundlagen/konventionen.md#kernbegriffe)):

- **Sub-Area-Qualifikation:** eine Struktur ist eine Sub-Area, wenn
  sie **mindestens zwei von drei Achsen** erfüllt — eigene
  Konventions-Härte (MR-Adaption formulierbar), eigene Inventur-Linie,
  struktureller Cluster. Eine Achse allein ist Struktur ohne Substanz.
- **Modus pro Sub-Area:** Greenfield (Doc führt, Code folgt) ·
  Brownfield (Code führt, Doc folgt — **Übergangsmodus**) · Hybrid.
  Der Modus ist ein beobachtbarer Zustand **pro Sub-Area, nicht pro
  Repo**. BF ist kein Dauermodus: jede BF-Sub-Area trägt eine
  **Graduation-Bedingung** im Adaptions-Block; BF ohne Graduation-Plan
  ist eine permanente Ausnahme als temporär getarnt.
- **Modus-Begründung im Slice-Plan** gegen vier Pflichtkriterien
  (vier, nicht erweitern): Konventionen-Dichte · Phase-Reife der
  berührten Artefakt-Sektionen · Evidenz-/Diskrepanz-Risiko (bei
  BF/Hybrid das Hauptrisiko) · Reconciliation-Aufwand inklusive
  Graduation-/Folge-Slice-Trigger.
- **Drei Anzeichen für Modus-Wechsel im Betrieb:** (1) die
  Diskrepanz-Häufung ändert sich, (2) der Test-Bestand übertrifft die
  Spec-Anker (GF→BF-Drift), (3) eine Carveout-Auflösung schließt eine
  BF-Sub-Area. Modus-Wechsel ist Signal, kein Versagen — deklarieren,
  nicht verschweigen.
- **Sektionsreife:** Harness-Dokumente reifen sektionsweise (Phasen
  0–5); erst eine Phase-4-Sektion (kohärent) ist für Verweise von
  außen freigegeben. Dokument-Übergänge folgen vier Trigger-Klassen
  (Sync · Promotion · Cross-Reference · Acceptance).

## 3. Spec-Disziplin

- **Strata** ([§Spec-Straten](grundlagen/konventionen.md#spec-straten-mehr-als-ein-spec-dokument)):
  jedes Spec-Dokument fällt über *normativen Gehalt* und
  *Änderungs-Prozess* in genau eine Klasse — **Vertrag** (Decke,
  Change-Request-pflichtig) · **Technik** (fortschreibbar,
  ADR-Schärfung erlaubt) · **Sicht** (derivativ, keine eigenen
  Anforderungen). Rang: Vertrag › Technik › Sicht › ADR › Slice. Nur
  Vertrag und Sicht sind obligatorisch.
- **Source Precedence** ([§](grundlagen/konventionen.md#source-precedence)):
  geordnete Liste der kanonischen Quellen, pro Repo deklariert in
  `harness/README.md` (die konkrete Datei-Reihenfolge ist Repo-Sache;
  ein eigener Spezifikations-Rang ist eine deklarierte Adaption). Bei
  Konflikt gewinnt die höherrangige Quelle, **und das unterlegene
  Dokument wird angepasst** — nie umgekehrt, nie still.
- **Referenz-Richtung (SDP)** ([§](grundlagen/konventionen.md#referenz-richtung-sdp-wer-darf-wen-referenzieren)):
  normative Referenzen zeigen nur volatil→stabil (Slice → ADR → `LH-*`).
  Abwärts-/Seitwärts-Verweise sind Kontext, keine Spezifikation.
- **ID-Schema** ([§](grundlagen/konventionen.md#id-schema-als-klammer)):
  `<PREFIX>-FA-<NN>` (funktional) und `<PREFIX>-QA-<NN>` (Qualität)
  werden **beim Lastenheft-Schreiben vergeben**, Verfeinerungen als
  `<PREFIX>-FA-<NN>.<Buchstabe>` in der Spezifikation, ADR-Nummern
  chronologisch über den Index. Deklaration des Schemas:
  `harness/conventions.md`. **Agenten referenzieren IDs, sie erfinden
  keine.** Das Präfix ist die **Klammer** über Anforderung,
  Make-Target-Kommentar (`coverage-gate: ## LH-FA-BUILD-008`),
  ADR-Body, Commit-Message und PR-Beschreibung — so wird der
  Traceability-Constraint maschinell prüfbar.
- **Akzeptanzkriterien** im Given/When/Then-Stil, pro Anforderung
  mindestens Happy Path · Boundary · Negative.
- **Lopopolos Maxime:** „Was der Agent nicht im Kontext erreicht,
  existiert für ihn nicht." Ein Agent ist ein extrem
  buchstabengetreuer Praktikant — deshalb gehören Negativbedingungen
  und Out-of-Scope **explizit** in die Spec, nicht in stillschweigende
  Annahmen.

## 4. ADRs

- Eine ADR begründet eine **Lösung** (*warum so*), die Spec trägt die
  **Anforderung** (*was*). „Wir nehmen PostgreSQL" = ADR; „Antwortzeit
  < 200 ms" = Spec; „Slice implementiert den Index" = Plan.
- **ADRs dürfen die Spezifikation schärfen, nie das Lastenheft.**
  Diese eine Regel kapselt die Trennung von Vertrag (nur per Change
  Request änderbar) und Technik (fortschreibbar).
- **`Accepted` = immutable.** Korrektur ist eine neue ADR mit
  `Supersedes ADR-NN`; `superseded`/`deprecated` sind Status, kein
  Löschen. Alt-ADRs aus der Zeit vor dieser Konvention werden
  **grandfathered**, nicht nachgezogen.
- ADRs sind **Constraints für spätere Agentenläufe**, nicht
  Dokumentation: wo maschinell prüfbar, in eine **Fitness Function**
  übersetzen (ArchUnit, dep-cruiser, import-linter, Latenzbudget).
- **Gates dürfen nie ohne ADR gelockert werden** — jede
  Schwellen-Senkung ist eine ADR, kein PR-Kommentar.

## 5. Planung

- **Slice:** kleinste lieferbare Einheit; eigener Plan, eigene DoD;
  normativ gebunden an `LH-*`-Scope und aktive ADRs. **Größenregel:
  klein ist ein Slice, wenn ein Agent ihn in *einem* Lauf abschließen
  kann und ein Reviewer den Diff *in einer Sitzung* prüfen kann —
  größer ist falsch; Faustregel: mehr als drei DoD-Punkte = zu
  groß.** Geschnitten wird nach **Lieferwert, nicht nach
  Schichten**: jeder Teil-Slice liefert allein prüfbaren Wert;
  Schichten-Schnitte erzeugen Zombie-Slices, die „fast fertig"
  aufeinander warten.
- **Lifecycle:** Slices wandern `open → next → in-progress → done`;
  jeder Übergang hat einen beobachtbaren **Trigger**. Ein Datum ist
  kein Trigger, sondern eine Prognose — Termine sind Folge, nicht
  Treiber. Dazu zwei **Rückführungen**, die Disziplin sind, kein
  Scheitern: `in-progress → next` (zu groß — zurück zum Schneiden)
  und `in-progress → open` (Blocker, Priorität offen); ein zu großer
  Slice gehört sichtbar zurück, nicht still weitergeschoben.
  **WIP-Limit pro Implementer: 1** — harte Größe, kein Vorschlag.
  **Closure** ist dokumentierter Abschluss mit Lerneintrag in `done/`;
  der Lerneintrag hat eine von drei Formen: **geschärfte Regel ·
  neuer Sensor · benannte Spec-Lücke** — „Tests grün" ist keine.
  Ohne Lerneintrag ist der Slice nur *abgelegt*, nicht geschlossen,
  und das Versagensmuster wiederholt sich unsichtbar.
- **Roadmap:** Wellen (Slice-Bündel) mit Triggern und
  Closure-Kriterien. Welle ≠ Meilenstein (externer Zustand) ≠ Release
  (Artefakt verlässt das Repo). Eine Roadmap ist nicht statisch — sie
  wird durch Closure-Lerneinträge fortgeschrieben.
- **Carveouts** (`CO-<NNN>`): dokumentierte Ausnahme von Gate oder
  Architekturregel — *temporär* (Auflösungs-Trigger + Folge-Slice)
  oder *permanent* (begründet). Pro Welle ein Carveout-Audit; eine
  permanente Ausnahme, die als temporär getarnt ist, ist eine
  Harness-Lüge.
- **Werkzeug-Wahl bei einer Ausnahme** (Carveout vs.
  BF-Sub-Area-Markierung vs. ADR) über zwei sequenzielle Fragen —
  **Granularität vor Temporalität**: (1) einzelne Diskrepanz oder
  Cluster? Ein Cluster ist eine BF-Sub-Area, kein Stapel Carveouts.
  (2) Ist der Auflösungs-Trigger realistisch erreichbar? Wenn nein,
  ist es eine permanente Entscheidung → ADR.

## 6. Rollen und Übergaben

Sechs Rollen: **Planner · Architect · Implementation · Reviewer ·
Verification · Validation**. Rollen-Trennung ist **Kontext-Trennung**
(getrennte Kontextfenster gegen blinde Flecken), keine
Personen-Trennung. Die Sequenz hat **neun Übergaben, jede mit
prüfbarem Artefakt** (Tabelle:
[Modul 8](03-agenten/modul-08-agentenrollen.md)) — ein Übergang ohne
Artefakt ist ein blinder Übergang. Verification prüft Plan-/
DoD-Konformität (*richtig gebaut?*), Validation die fachliche Wirkung
(*das Richtige gebaut?*).

- **Konflikt-Regel:** Bei Reviewer↔Implementation-Konflikt entscheidet
  nicht Seniorität, sondern die Kette: der Architect prüft die
  ADR-Aktualität, der Planner den Plan-Status; das Verdikt ist eine
  neue ADR oder eine Plan-Korrektur — nie ein informeller Zuruf.
- **Kontext-Zuschnitt pro Rolle:** Verifier erhält DoD + Spec + Plan;
  Reviewer erhält Plan + ADR + Diff — Schnittmenge ist nur der Plan,
  und genau diese Trennung erzeugt nicht überlappende Findings. Wer
  dem Verifier zusätzlich den ADR gibt, macht ihn zum zweiten Reviewer
  und verliert die Kontext-Trennung.

## 7. Implementierungs-Workflow (pro Slice)

1. `harness/README.md` lesen.
2. Relevante kanonische Quelle lesen (Source Precedence beachten).
3. Betroffene Requirement-/ADR-IDs **identifizieren** (nie vergeben).
4. Kleinste sinnvolle Änderung planen.
5. Engsten nützlichen Sensor laufen lassen.
6. Repo-weiten Gate-Lauf vor Handoff (`make gates`).
7. Doku/Indizes aktualisieren, falls ein öffentlicher Vertrag berührt.
8. Ausgeführte Sensors und verbleibende Risiken berichten — **keine
   Erfolgsmeldung ohne Gate-Ausführung**.

**Rücksprungkanten:** die zwei Standard-Kanten sind **5→4 und 6→4**
(Plan *verfeinern* — ein roter Sensor/Gate ist meist ein
Plan-Defekt). Ein Rücksprung zu Schritt 1 ist nur richtig, wenn die
kanonische Quelle gar nicht im Kontext war (Kontext-Defekt) — eine
andere Ursachen-Klasse. **Die Wahl der Kante ist die Diagnose der
Ursache**; „nochmal von vorn" ist keine.

Typische **Hard Rules** (repo-spezifisch in `AGENTS.md`): Docker-only
(kein Host-Toolchain-Install) · Suppression-Verbot (Ausnahmen zentral
mit Begründung) · `git mv` + Inhaltsänderung = zwei Commits ·
Architektur-Doku bleibt wellen-/slice-frei · ADR-Immutabilität ·
Gate-Lockerung nur per ADR. `AGENTS.md` trägt Hard Rules und Pointer,
**dupliziert keine kanonischen Inhalte**.

- **Eine Hard Rule braucht beide Feedforward-Formen:** den
  AGENTS.md-Eintrag (inferential — der Agent liest sie) **und** eine
  Fitness Function oder ein Gate (computational — der Verstoß schlägt
  an). Existiert nur eines von beiden, ist die Regel halb
  durchgesetzt.
- **Repo-Klasse bestimmt die Schärfe:** *Referenz* (Standard) ·
  *Safety/Control* — Hard Rules nicht verhandelbar, Sensors
  fail-closed · *Policy/Compliance* — jede Änderung trägt eine
  fachliche ID; KI liefert Vorschläge, nie verbindliche
  Entscheidungen.
- **Kontext-Verdichtung — nicht in den Lauf-Kontext:**
  `superseded`/`deprecated` ADRs ohne Folge-Bezug, Skills fremder
  Rollen, Carveouts mit bereits eingetretenem Auflösungs-Trigger,
  historische Spec-Notizen. Toter Kontext kostet Tokens, verschiebt
  Relevantes in die Mitte des Fensters und füttert Halluzinationen.

## 8. Qualität

- **Drei Review-Arten** — wogegen wird geprüft: *Plan-Review* gegen
  Spec/ADR (vor Implementierung) · *Design-Review* gegen Architektur ·
  *Code-Review* gegen Plan + Konventionen.
- **Finding-Kategorien:** **HIGH** = blockiert Merge —
  Sicherheits-, Korrektheits- oder ADR-Verstoß, auch Suppression
  eines Gates ohne ADR · **MEDIUM** = vor Merge zu klären
  (Soll-Blocker; z. B. fehlende Negativtests bei neuem öffentlichen
  Vertrag) · **LOW** = nice-to-fix, blockiert nicht · **INFO** =
  Hinweis ohne erwartete Aktion (Ergänzungs-, kein Hauptkanal). Die
  Kategorie ist **kontextabhängig** — dieselbe Beobachtung wandert
  nach oben mit dem Geltungsbereich (unbenutzte Variable im
  Hilfsskript = LOW, im Sicherheits-Check-Pfad = HIGH), mit
  Wiederholung (drittes Mal in derselben Sitzung = Symptom →
  MEDIUM/HIGH), mit externer Wirkung und mit Produktionsnähe. Die
  LOW/MEDIUM-Trennlinie ist repo-spezifisch und gehört in den Skill;
  **Streit über eine Kategorisierung ist ein Steering-Loop-Signal**
  (Spec- oder ADR-Schicht zu vage — Regel schärfen).
- Reviewer-Verhalten lebt als **Skill** in
  `.harness/skills/reviewer.md` — Pflichtstruktur: expliziter
  Eingangs-Kontext (gegen welche Verträge wird geprüft),
  repo-spezifische Anker pro Kategorie, Anti-Pattern-Block („was du
  nicht bist"), Output-Schema (Kategorie · Quelle: ADR-ID, LH-ID,
  Hard-Rule-Name oder „Maintainability" · Pfad `Datei:Zeile` ·
  Befund: 1–2 Sätze, beobachtbar, **ohne Lösungsvorschlag** ·
  **verifizierbar** — gibt es einen Gate-Lauf, der den Befund
  bestätigen würde?), **Negativbefund-Zeile pro geprüftem
  Bereich** („geprüft, ohne Befund" — sonst ist „keine Findings"
  nicht von „nicht geprüft" unterscheidbar). Ohne Skill driftet die
  Klassifikation zwischen Sessions. Der ganze Lauf wird als
  **Review-Report** unter `docs/reviews/` abgelegt — ein Report pro
  Lauf (Kopf-Metadaten: Review-Art, Gegenstand, Skill-Version,
  Modell, Eingangs-Kontext · Findings · Negativbefunde ·
  Kategorie-Summary · Verdikt; Vorlage im Template-Set). Review-Läufe
  reproduzierbar machen (fixierte Eingaben, deklarierter Skill);
  Erwartung ist *ähnlich, nicht identisch*.
- **Verifikation:** Plan-gegen-Code-Diff. Abgrenzung zum Review läuft
  über das **Prüf-Artefakt, nicht über die Schwere**:
  **DoD-Verletzung** = Differenz zwischen DoD/Spec/Plan und dem
  tatsächlichen Stand (Gate rot, Endpoint weicht vom Plan ab) — diese
  Klasse fängt nur die Verifikation; **Review-Finding** = begründetes
  Urteil gegen Plan/ADR/Konventionen (ADR-Verstoß,
  Maintainability-Beobachtung). Pre-completion-Checks des Agenten
  selbst ersetzen keine Verifikation (Selbstabsolution).
- **Replay & Golden Sets:** kuratierte Eingabe/Erwartungs-Paare
  (Happy · Boundary · Negative, Auswahlkriterium pro Fall) in `evals/`;
  Regressionen messen statt raten. **Replay-Manifest-Pflichtfelder:**
  Modellversion + Seed + Eingaben + `runtime.image_hash` — identischer
  Image-Hash schließt Toolchain-Drift als Ursache aus. **Der Seed
  pinnt nur eine von mehreren Drift-Quellen** — Modellversion,
  Sampling-Parameter, Tool-Umgebung und Prompt-Kontext driften
  unabhängig weiter; deshalb Rotations-/Sampling-Plan statt
  Determinismus-Annahme. **Drift-Diagnose-Reihenfolge bei rotem
  Replay** (nicht beliebig): (1) Toolchain-Drift (Image-Hash
  vergleichen) → (2) Modell-Routing (Version, Provider-Status) →
  (3) Erwartungs-Drift (Eingaben vs. Spec) → (4) erst dann echte
  Regression.
- **Quality Gates:** als `make`-Ziele (computational feedback), im CI
  identisch zu lokal. Sensor-Klasse nach Fehlerbild wählen:
  [Gate-Typ ↔ Fehlerbild](04-qualitaet/modul-13-quality-gates.md#gate-typ--fehlerbild)
  — Trennlinie ist die *Regel-Klasse*, nicht das Tool. Jede
  Sensor-Zeile in `harness/README.md` trägt eine **Bindung**: ADR ·
  Carveout · Schwellen-Kalibrierung · Reproduzierbarkeit;
  Zusatzklassen vorher in `harness/conventions.md` deklarieren.
  **Bootstrap-aware Gates** kennen eine deklarierte Reifestufe; der
  Hochschalt-Trigger ist ein **Ereignis, kein Datum**, und steht im
  Make-Target-Kommentar — ohne Trigger ist es keine Reifestufe,
  sondern aufgeschobene Pragmatik. **Werkzeug-Triade bei gelockerter
  Gate-Disziplin:** *Carveout* (punktuelle Ausnahme mit Folge-Slice) ·
  *bootstrap-aware Gate* (terminiertes Reifestufen-Gate — eigene
  Klasse, kein Carveout-Subtyp) · *BF-Sub-Area-Markierung* — wobei
  Letztere kein Closure-Werkzeug ist, sondern der Sub-Area-Kontext,
  in dem die beiden anderen als Closure-Antworten strukturell legitim
  werden. Nur Gates behaupten, die als Target existieren.

## 9. Betrieb

- **Build-Harness:** Docker-only, Multi-Stage (`deps · build ·
  runtime`), Base-Images **per Digest gepinnt**
  (`image:tag@sha256:…`) — ein Tag allein baut jeden Monat einen
  anderen Container. Lock-File + Image-Hash sind die
  Mindestkombination für Reproduzierbarkeit. Dazu zwei
  Layer-Disziplin-Regeln: **Lock-File-`COPY` vor Code-`COPY`** (sonst
  rebuildet jede Code-Änderung die Dependency-Stage) und die
  Installation muss das Lock-File **erzwingen** (`--frozen` o. Ä.) —
  ein Lock-File, das der Build nicht erzwingt, pinnt nichts.
- **Observability:** ein Span pro Tool-Call mit Audit-Attributen;
  Token-Kosten pro Rolle attribuierbar; die Kette **Span → Slice →
  ADR → `LH-*`** muss nachvollziehbar dokumentiert sein. Cache als
  **zwei Counter** (Hits *und* Misses), nicht als eine Ratio —
  Miss-Spike ist ein Security-Signal (Injection-Indiz), Hit-Rückgang
  ein Kosten-Signal. Doku-Drift hat zwei Härtegrade: ein
  **behaupteter-aber-fehlender Befehl** in AGENTS.md ist *sofort*
  gate-relevant (Geister-Befehl); ein neues Target ohne Doku-Eintrag
  ist nur Vorwärts-Drift (Doku-Rückstand).
- **Produktionsfreigabe:** Checkliste mit Belegen — **ein Item ohne
  Beleg (Datei, Target-Output, Trace-ID, CI-Link) ist nicht abgehakt,
  auch wenn es inhaltlich erfüllt wäre**; das ist die Grenzlinie
  zwischen Audit und Bürokratie. Die
  **Rollback-vs-Fix-Forward**-Entscheidungstabelle wird *vor* dem
  Incident geschrieben, nicht unter Stress entschieden; die drei
  Anti-Rollback-Szenarien stehen namentlich im Runbook:
  nicht-rückwärtskompatible DB-Migration · bereits ausgelieferte
  fehlerhafte Daten · ungetesteter Rollback-Pfad. **Postmortems sind
  blameless**: sie fragen, welcher Sensor oder Guide gefehlt hat,
  nicht wer schuld war — wer Schuld verteilt, bringt Beteiligte dazu,
  Drift-Symptome zu verschweigen.
- **Prompt-Injection-Symptome** in Telemetrie sichtbar machen:
  ungewöhnliche Tool-Sequenz außerhalb des Slice-Scopes · Egress an
  externe Ziele · Drift zwischen Auftrag und Output.
- **Entropy Management:** Doku-Drift, tote Constraints und veraltete
  Konventionen aktiv abbauen — ein Harness, der nicht gepflegt wird,
  lügt mit der Zeit von selbst.

## 10. Wartung dieses Digests

Derivativ — bei jeder Kurs-Welle gegen die Quellen diffen (Abschnitt
0) und die **Stand-Zeile** am Dokumentanfang aktualisieren (Format:
`Kurs-Welle <N> · <Datum> · <Uhrzeit mit Zeitzone>` — die Uhrzeit
unterscheidet mehrere Überarbeitungen am selben Tag innerhalb
derselben Welle). Die kanonische Wellen-Zählung führt das
[`CHANGELOG.md`](../../CHANGELOG.md) im Repo-Root; adoptierende Repos
vergleichen ihren Baseline-`Stand:`-Eintrag gegen diese Zeile und
lesen die Differenz im Changelog nach. Wer die harte Garantie
braucht, pinnt die Raw-URL auf Commit oder Tag statt `main` — eine
`main`-Raw-URL ohne Stand-Vergleich ist das Doku-Äquivalent eines
ungepinnten Base-Image (§9). Die Link-Anker prüft
`node tools/docs-check.js kurs/de/`; eine Regel, die hier steht und in
keiner Quelle, ist eine Harness-Lüge dieses Dokuments.
