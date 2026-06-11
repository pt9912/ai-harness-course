# Agents-Digest — der Kurs als Betriebsregelwerk

**Stand:** Kurs-Welle 8 · 2026-06-11

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
  verbessern → Wiederholung reduzieren. Vor dem Einziehen eines neuen
  Sensors die passende Sensor-Klasse wählen
  ([Gate-Typ ↔ Fehlerbild](04-qualitaet/modul-13-quality-gates.md#gate-typ--fehlerbild)).
- **Harness-Lüge** (verboten): der Harness behauptet eine Kontrolle,
  die real nicht greift — halluziniertes Gate, stille Setzung, Pointer
  auf nicht existierende Mechanik.

## 2. Artefaktkette und Verzeichnisse

Lebenszyklus: **Spec → ADR → Plan (Slices) → Code → Review →
Verifikation**, mit Rückkanten (Review-Finding → Plan; Spec-Lücke →
Spec). Verzeichniskonvention:

```
spec/                         # Lastenheft, Spezifikation, Architektur
docs/plan/adr/                # ADRs + Index
docs/plan/planning/open/      # geplante Slices
docs/plan/planning/next/      # priorisiert für die nächste Welle
docs/plan/planning/in-progress/
docs/plan/planning/done/      # geschlossen, mit Lerneintrag
docs/plan/carveouts/          # dokumentierte Ausnahmen (CO-<NNN>)
harness/README.md             # Harness-Einstieg (Pflicht)
harness/conventions.md        # repo-lokale Strukturregeln (Pflicht)
.harness/                     # Skills pro Agenten-Rolle
AGENTS.md                     # Briefing: Hard Rules + Pointer
```

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
  `harness/README.md`. Bei Konflikt gewinnt die höherrangige Quelle —
  nie still entscheiden, Konflikt benennen.
- **Referenz-Richtung (SDP)** ([§](grundlagen/konventionen.md#referenz-richtung-sdp-wer-darf-wen-referenzieren)):
  normative Referenzen zeigen nur volatil→stabil (Slice → ADR → `LH-*`).
  Abwärts-/Seitwärts-Verweise sind Kontext, keine Spezifikation.
- **ID-Schema** ([§](grundlagen/konventionen.md#id-schema-als-klammer)):
  `<PREFIX>-FA-<NN>` (funktional) und `<PREFIX>-QA-<NN>` (Qualität)
  werden **beim Lastenheft-Schreiben vergeben**, Verfeinerungen als
  `<PREFIX>-FA-<NN>.<Buchstabe>` in der Spezifikation, ADR-Nummern
  chronologisch über den Index. Deklaration des Schemas:
  `harness/conventions.md`. **Agenten referenzieren IDs, sie erfinden
  keine.** PRs/Commits nennen die betroffenen IDs.
- **Akzeptanzkriterien** im Given/When/Then-Stil, pro Anforderung
  mindestens Happy Path · Boundary · Negative.

## 4. ADRs

- Eine ADR begründet eine **Lösung** (*warum so*), die Spec trägt die
  **Anforderung** (*was*). „Wir nehmen PostgreSQL" = ADR; „Antwortzeit
  < 200 ms" = Spec; „Slice implementiert den Index" = Plan.
- **`Accepted` = immutable.** Korrektur ist eine neue ADR mit
  `Supersedes ADR-NN`; `superseded`/`deprecated` sind Status, kein
  Löschen.
- ADRs sind **Constraints für spätere Agentenläufe**, nicht
  Dokumentation: wo maschinell prüfbar, in eine **Fitness Function**
  übersetzen (ArchUnit, dep-cruiser, import-linter, Latenzbudget).
- **Gates dürfen nie ohne ADR gelockert werden** — jede
  Schwellen-Senkung ist eine ADR, kein PR-Kommentar.

## 5. Planung

- **Slice:** kleinste lieferbare Einheit; eigener Plan, eigene DoD;
  normativ gebunden an `LH-*`-Scope und aktive ADRs. Zu groß, wenn er
  mehrere unabhängige Lieferwerte bündelt → schneiden, Schnitt
  begründen.
- **Lifecycle:** Slices wandern `open → next → in-progress → done`;
  jeder Übergang hat einen beobachtbaren **Trigger** (Bedingung, kein
  Datumswunsch). **Closure** ist dokumentierter Abschluss mit
  Lerneintrag in `done/` — nicht das Schließen eines Tickets.
- **Roadmap:** Wellen (Slice-Bündel) mit Triggern und
  Closure-Kriterien. Welle ≠ Meilenstein (externer Zustand) ≠ Release
  (Artefakt verlässt das Repo). Eine Roadmap ist nicht statisch — sie
  wird durch Closure-Lerneinträge fortgeschrieben.
- **Carveouts** (`CO-<NNN>`): dokumentierte Ausnahme von Gate oder
  Architekturregel — *temporär* (Auflösungs-Trigger + Folge-Slice)
  oder *permanent* (begründet). Pro Welle ein Carveout-Audit; eine
  permanente Ausnahme, die als temporär getarnt ist, ist eine
  Harness-Lüge.

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

Typische **Hard Rules** (repo-spezifisch in `AGENTS.md`): Docker-only
(kein Host-Toolchain-Install) · Suppression-Verbot (Ausnahmen zentral
mit Begründung) · `git mv` + Inhaltsänderung = zwei Commits ·
Architektur-Doku bleibt wellen-/slice-frei · ADR-Immutabilität ·
Gate-Lockerung nur per ADR. `AGENTS.md` trägt Hard Rules und Pointer,
**dupliziert keine kanonischen Inhalte**.

## 8. Qualität

- **Drei Review-Arten** — wogegen wird geprüft: *Plan-Review* gegen
  Spec/ADR (vor Implementierung) · *Design-Review* gegen Architektur ·
  *Code-Review* gegen Plan + Konventionen.
- **Findings** kategorisiert **HIGH / MEDIUM / LOW / INFO**;
  Reviewer-Verhalten lebt als **Skill** in
  `.harness/skills/reviewer.md`. Review-Läufe reproduzierbar machen
  (fixierte Eingaben, deklarierter Skill); Erwartung ist *ähnlich,
  nicht identisch*.
- **Verifikation:** Plan-gegen-Code-Diff. **DoD-Verletzung** = ein
  prüfbares Artefakt sagt nein (Gate rot, Endpoint weicht vom Plan ab);
  **Review-Finding** = begründetes Urteil ohne verletzten Vertrag.
  Pre-completion-Checks des Agenten selbst ersetzen keine Verifikation
  (Selbstabsolution).
- **Replay & Golden Sets:** kuratierte Eingabe/Erwartungs-Paare
  (Happy · Boundary · Negative, Auswahlkriterium pro Fall) in `evals/`;
  Regressionen messen statt raten. **Der Seed pinnt nur eine von
  mehreren Drift-Quellen** — Modellversion, Sampling-Parameter,
  Tool-Umgebung und Prompt-Kontext driften unabhängig weiter; deshalb
  Rotations-/Sampling-Plan statt Determinismus-Annahme.
- **Quality Gates:** als `make`-Ziele (computational feedback), im CI
  identisch zu lokal. Sensor-Klasse nach Fehlerbild wählen:
  [Gate-Typ ↔ Fehlerbild](04-qualitaet/modul-13-quality-gates.md#gate-typ--fehlerbild).
  **Bootstrap-aware Gates** kennen eine deklarierte Reifestufe und
  greifen ab Trigger hart. Nur Gates behaupten, die als Target
  existieren.

## 9. Betrieb

- **Build-Harness:** Docker-only, Multi-Stage (`deps · build ·
  runtime`), Base-Images **per Digest gepinnt**
  (`image:tag@sha256:…`) — ein Tag allein baut jeden Monat einen
  anderen Container. Lock-File + Image-Hash sind die
  Mindestkombination für Reproduzierbarkeit.
- **Observability:** ein Span pro Tool-Call mit Audit-Attributen;
  Token-Kosten pro Rolle attribuierbar; die Kette **Span → Slice →
  ADR → `LH-*`** muss nachvollziehbar dokumentiert sein. Cache-Hit-Rate
  beobachtbar machen.
- **Produktionsfreigabe:** Checkliste mit Belegen (kein Haken ohne
  Artefakt), Incident-Runbooks mit **Rollback-vs-Fix-Forward**-Abwägung
  (Rollback scheitert u. a. an nicht-rückrollbaren Migrationen und
  bereits verarbeiteten Daten — Szenarien im Runbook benennen).
- **Prompt-Injection-Symptome** in Telemetrie sichtbar machen:
  ungewöhnliche Tool-Sequenz außerhalb des Slice-Scopes · Egress an
  externe Ziele · Drift zwischen Auftrag und Output.
- **Entropy Management:** Doku-Drift, tote Constraints und veraltete
  Konventionen aktiv abbauen — ein Harness, der nicht gepflegt wird,
  lügt mit der Zeit von selbst.

## 10. Wartung dieses Digests

Derivativ — bei jeder Kurs-Welle gegen die Quellen diffen (Abschnitt
0) und die **Stand-Zeile** am Dokumentanfang aktualisieren (Format:
`Kurs-Welle <N> · <Datum>`); adoptierende Repos vergleichen ihren
Baseline-`Stand:`-Eintrag gegen diese Zeile. Wer die harte Garantie
braucht, pinnt die Raw-URL auf Commit oder Tag statt `main` — eine
`main`-Raw-URL ohne Stand-Vergleich ist das Doku-Äquivalent eines
ungepinnten Base-Image (§9). Die Link-Anker prüft
`node tools/docs-check.js kurs/de/`; eine Regel, die hier steht und in
keiner Quelle, ist eine Harness-Lüge dieses Dokuments.
