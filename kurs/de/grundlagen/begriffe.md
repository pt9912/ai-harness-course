# Kernbegriffe und Trennschärfen

## Kernbegriffe

| Begriff | Bedeutung im Kurs |
|---|---|
| LLM | Modell, das Text → Text abbildet. Stateless. |
| Agent | LLM + Tool-Schnittstelle + Schleife. Hält Zustand über mehrere Turns. |
| Tool-Call | Strukturierter Aufruf einer Funktion durch das LLM (`name`, `arguments`, `result`). |
| SDLC / Lebenszyklus | Software Development Lifecycle; im Kurs *Entwicklungszyklus* genannt (Modul 1). Artefaktkette Spec → ADR → Plan → Code → Review → Verifikation → Closure mit verpflichtenden Rückwärtskanten (Lerneintrag, Folge-ADR). *Validierung* fehlt hier bewusst: sie prüft gegen den realen Bedarf außerhalb des Repos und hinterlässt kein Repo-Artefakt — ihr Ort ist die Rollen-Sequenz (Modul 8). |
| Spec | Die Artefakte unter `spec/` — die drei Straten *Vertrag* · *Technik* · *Sicht*. Quelle der Wahrheit für *was gilt*; das *warum* trägt die ADR. |
| ADR | Architecture Decision Record unter `docs/plan/adr/`. Quelle der Wahrheit für *warum so*. |
| Slice | Kleinste lieferbare Einheit eines Features. Hat eigenen Plan, eigene DoD. |
| Plan (vor Code) | Auch *Umsetzungsplan* genannt. Datei-Tabelle in §3 des Slice-Plans: Der Implementer-Agent gibt sie vor dem ersten Diff aus und verfeinert sie über die Rückkanten (Schritt 5/6 → 4) — bindet an Akzeptanzkriterien, wiederholt die Out-of-Scope-Zeile aus §1. Siehe [Modul 9 §Minimal Agent Workflow](../03-agenten/modul-09-implementierung.md#minimal-agent-workflow-8-schritte). |
| Welle | Bündel von Slices, das gemeinsam geplant und abgeschlossen wird. |
| Trigger | Beobachtbare Bedingung, bei der ein Slice/Welle/Carveout in den nächsten Status wandert. |
| Closure | Abschluss eines Slice oder einer Welle, dokumentiert mit Lerneintrag in `done/`. |
| Gate | Automatisch prüfbares Qualitätskriterium (Linter, Typecheck, Architekturtest, Coverage). |
| Carveout | Dokumentierte Ausnahme von einem Gate oder einer Architekturregel. |
| Skill | Repo-spezifisches Markdown/JSON-Artefakt, das einer Agenten-Rolle Checkliste oder Verhalten beibringt. Lebt typischerweise in `.harness/`. |
| Replay | Deterministisch wiederholbarer Lauf gegen fixierte Inputs. |
| Golden Set | Kuratiertes Eingabe/Erwartungs-Paar für Regressionstests. |
| Drift | Abweichung des Verhaltens zwischen zwei Läufen, deren Manifeste eigentlich übereinstimmen sollten. |
| Determinismus | Gleiche Eingabe → gleiche Ausgabe. Setzt voraus, dass *jede* Zufalls- und Umgebungsquelle des Laufs gepinnt ist: Seed samt Ableitungsregel, Modellversion, Toolchain, Umgebungszustand des Containers. |
| Finding | Einzelne Beobachtung eines Reviewers, kategorisiert HIGH/MEDIUM/LOW/INFO. |
| DoD | Definition of Done. Liste der Bedingungen, die ein Slice erfüllen muss. |
| Guide | Feedforward-Kontrolle: lenkt den Agenten *vor* der Handlung (Spec, ADR, AGENTS.md, Skill, Tool-Constraint). |
| Sensor | Feedback-Kontrolle: prüft *nach* der Handlung (Linter, Test, ArchUnit, Reviewer-Agent). |
| Fitness Function | Maschinell prüfbare Architektur-Aussage (z. B. Modulgrenze, Latenzbudget). |
| RTM | *Requirements Traceability Matrix*, deutsch Anforderungs-Rückverfolgbarkeits-Matrix: je Anforderung ihre Belege, und sichtbar die **Waisen** ohne einen. **Auslesestand, kein Artefakt** — erzeugt aus den Verweis-Quellen, die das Repo als entlastend deklariert (im Kurs-Vorschlag: der Slice), nicht daneben gepflegt; als Dokument geführt wäre sie eine Kopie und driftete. Bericht und Vollständigkeits-Gate sind derselbe Lauf ([§Die zweite Richtung](traceability.md#die-zweite-richtung-anforderung--beleg)). Nicht die Richtungs-Prüfung über die Spec-Straten — die prüft, ob ein Verweis *erlaubt* ist, die RTM, ob es ihn *gibt*. |
| Steering Loop | Wiederkehrendes Muster: beobachtetes Agenten-Versagen → Guide/Sensor verbessern → Wiederholung reduzieren. |
| AGENTS.md | Maschinell lesbare Projekt-Konventionen für Agenten (Codestil, Tool-Regeln, Layering, Verbote). Quasi-Standard nach OpenAI/Codex. |
| Constrain / Inform | OpenAI-Doppelaufgabe des Harness: *constrain* = Grenzen ziehen (Architektur, Tools, Layer), *inform* = Kontext liefern (Spec, ADR, AGENTS.md, Skills). |
| Entropy Management | Aktive Pflege des Harness gegen Doku-Drift, tote Constraints und veraltete Konventionen. |
| Harness-Lüge | Der Harness behauptet eine Kontrolle, die real nicht (mehr) greift — halluziniertes oder undeklariertes Gate, stille Setzung, Pointer auf nicht existierende Mechanik. Häufigste Form: behauptete Gates ohne Make-Target. |
| Source Precedence | Geordnete Liste der kanonischen Quellen. Bei Konflikt gewinnt die höher rangierende. |
| `harness/README.md` | Pro-Repo-Einstiegspunkt: bündelt Source Precedence, Guides, Sensors, Traceability- und Safety-Regeln. Dupliziert keine Spec-Inhalte. |
| `harness/conventions.md` | Repo-lokaler Konventionsspeicher: trägt Strukturregeln und Adaptionen ggü. der adoptierten Baseline (`MR-<NNN>`-Liste, Zusatzklassen für Sensors-Bindung, Modus-Deklaration pro Sub-Area). Pflicht; Form (Einzeldatei/Verzeichnis) ist Wahl. |
| `harness/sensors/<target>.md` | Vertiefung zu **einem** Gate oder Werkzeug, sobald sein Vertrag mehr braucht als einen Satz: Deckungsgrenze, Ausgabe-Bedeutung, Exit-Codes, Sperren. Nicht darin: was das Werkzeug prüft und wie es an seinen Randformen entscheidet — das steht in der Spezifikation —, und womit es selbst gedeckt ist — das lebt bei ihm. Index ist die Sensors-Zeile in `harness/README.md`, die per Link darauf zeigt; kein Lifecycle-Verzeichnis, ein retiriertes Gate verschwindet. |
| `harness/mk/<werkzeug>.md` | Teil des Gate-Index, der einem **Werkzeug** gehört, einer je Werkzeug: nur die Targets seiner Make-Fragmente, in der Tabellenform von `harness/README.md` §Sensors; bei jedem Lauf des Werkzeugs neu geschrieben, das Repo schreibt nicht hinein. Disjunkt zu den anderen Teilen und von `harness/README.md` verlinkt; der Deklarations-Sensor misst gegen die Vereinigung. Gibt es nur, wenn ein Werkzeug Fragmente erzeugt. |
| Hard Rule | Negativregel, die der Agent nie brechen darf (z. B. "Optimierer darf nie direkt aufs Gerät schreiben"). Repo-spezifisch. |
| Repo-Klasse | Charakter eines Repos im Harness: *Referenz* · *Safety/Control* · *Policy/Compliance*. Bestimmt, wie scharf Hard Rules und Sensors gesetzt werden. |
| ID-Schema | Stabile Präfix-Klammer (`LH-*`, `HSM-*`, `GG-*`), die Spec-Anforderungen, Make-Target-Kommentare, ADRs und Commits verbindet. Die Kennungs-Form kodiert zugleich das Stratum (beim Vertrags-Präfix über den Suffix: `LH-FA-03` Vertrag, `LH-FA-03.a` Technik). Siehe [§ID-Schema](source-precedence.md#id-schema-als-klammer). |
| Reconciliation-Backlog | Sicht auf `docs/plan/planning/reconciliation.md`: die noch offenen Funde des Brownfield-Rückbaus, eine Zeile je Fund mit Klasse und auflösendem Artefakt. Er *steht*, wenn jeder Fund eine Zeile mit Auflösung trägt — nicht, wenn das Register leer ist; leer wird es je Sub-Area erst bei der Graduation. Siehe [§Harness-Bootstrap-Ende](bootstrap.md#harness-bootstrap-ende-vs-workflow-beginn). |
| Struktur-ID | Kennung *innerhalb* eines Spec-Stratums — `SPEC-<NNN>` für eine technische Festlegung, `ARC-<NNN>` für Komponente oder Schnittstelle. Sie macht adressierbar, was dort ohnehin steht, und **verspricht nichts**: Nur Anforderungs-IDs werden abgenommen. Deshalb gehört sie nicht in die Klammer nach außen (Commit, PR), sondern in die Verweise zwischen ADR, Slice und Spec. Der Carveout bleibt beim Abschnitt. |
| `BEO-<KUERZEL>/<slug>` | Kennung einer Beobachtung im Beobachtungs-Register — zugleich ihr **Pfad** ([Modul 6](../02-planung/modul-06-roadmap.md#das-beobachtungs-register)). Beide Segmente werden nachgeschlagen, nicht erfunden: das Kürzel aus der Modus-Deklaration, der Slug aus der Bezeichnung. Es gibt keine Vergabestelle und keine fortlaufende Nummer. Die Kennung macht die Zählung unabhängig vom Wortlaut der Bezeichnung. |
| `MR-<NNN>` | Kennung eines Adaptions-Eintrags im Konventionsspeicher: **eine** benannte Abweichung von einer Baseline-Regel, mit Pflichtfeldern und Auflösungs-Trigger ([§harness/conventions.md als Konventionsspeicher](harness-dateien.md#harnessconventionsmd-als-konventionsspeicher)). Vergabestelle ist der Adaptions-Block — die Nummer steht in seiner Index-Zeile, der Text in `harness/conventions/MR-<NNN>-<titel>.md`; `MR-000` trägt die Adoptions-Erklärung. Der Zustand ist die Verzeichnis-Position (`done/` = aufgelöst), kein Status-Feld. |
| Referenz-Richtung (SDP) | Normative Referenzen zeigen nur volatil→stabil — **Vertrag › Technik › Sicht › ADR › Slice** (Stratum-Klassen, nicht Dateinamen). Wo die Matrix eine Zelle als *Kontext* ausweist, ist der Verweis erlaubt, trägt aber keine Normkraft; ein ❌ erlaubt auch keinen Kontext. Siehe [§Referenz-Richtung](referenz-richtung.md#referenz-richtung-sdp-wer-darf-wen-referenzieren). |
| Spec-Stratifizierung | Aufteilung der Spec in drei obligatorische Straten — *vertraglich* (Lastenheft) · *technisch* (Spezifikation) · *Sicht* (Architektur) — mit eigener Precedence-Regel. |
| Stratum | Rollen-Klasse eines Spec-Dokuments — *Vertrag* (Decke) · *Technik* · *Sicht* —, bestimmt über normativen Gehalt und Änderungs-Prozess, nicht über den Dateinamen. Widersprechen die Achsen einander, entscheidet der Änderungs-Prozess. Rang: Vertrag › Technik › Sicht; alle drei sind obligatorisch, eine Abweichung wird als `MR-<NNN>` deklariert. Siehe [§Spec-Straten](referenz-richtung.md#spec-straten-mehr-als-ein-spec-dokument). |
| Change Request | Externer Vorgang, in dem eine Vertragsänderung mit dem Auftraggeber vereinbart wird — **bewusst kein Harness-Konstrukt**: kein ID-Schema, keine eigene Datei, kein Gate. Im Repo hinterlässt ein *angenommener* CR nur einen Fußabdruck — Version-Bump des Lastenhefts, Historie-Zeile mit Verweis, die geänderten `LH-*`. Siehe [§Spec-Stratifizierung](source-precedence.md#spec-stratifizierung). |
| Bootstrap-aware Gate | Gate mit weicher Frühphase: kennt eine Reifestufe und greift erst ab Trigger hart. Dokumentiert, was die Stufe ist. |
| Spec-Driven Development (SDD) | Sammelbegriff für Varianten, in denen eine Spec Coding-Agenten als Leitlinie dient. Böckeler definiert die Spec als „a structured, behavior-oriented artifact - or a set of related artifacts - written in natural language that expresses software functionality and serves as guidance to AI coding agents". Das Regelwerk ist *spec-anchored* („spec-verankert"); Einordnung und Zuordnung der Bausteine: [§Einordnung: Spec-Driven Development](#einordnung-spec-driven-development). |

## Trennschärfen

- *Spec* beschreibt **was**, *ADR* begründet **warum so**, *Plan* legt **wann
und wie** fest.
- *Review* prüft, ob Code gegen Plan und ADR konform ist; *Verifikation*
prüft, ob das Ergebnis die DoD und die Spec erfüllt; *Validation* prüft, ob
das Ergebnis den realen Bedarf trifft.
- *Linter*-Findings sind keine *Review*-Findings. Gates sind maschinell;
Reviews sind agentisch.
- *Refinement* verfeinert eine Arbeitseinheit teamintern und laufend, ohne
Vertragspartner; ein *Change Request* vereinbart die Vertragsänderung extern mit
dem Auftraggeber. Beide ändern Text — nur einer ändert ein Versprechen. Welcher
von beiden ein Dokument ändern darf, entscheidet über sein Stratum.

## Einordnung: Spec-Driven Development

Birgitta Böckeler unterscheidet in *Understanding Spec-Driven-Development: Kiro, spec-kit, and Tessl* (martinfowler.com, 15. Oktober 2025) drei Stufen:

- **spec-first:** „A well thought-out spec is written first, and then used in the AI-assisted development workflow for the task at hand".
- **spec-anchored:** „The spec is kept even after the task is complete, to continue using it for evolution and maintenance of the respective feature".
- **spec-as-source:** „The spec is the main source file over time, and only the spec is edited by the human, the human never touches the code".

**Das Regelwerk ist spec-anchored** („spec-verankert"). Die Spec bleibt nach dem Slice bestehen und wird mitgeführt: Eine benannte Spec-Lücke aus Closure oder Verifikation fließt über den Rückwärtspfad in die Spec zurück (Modul 1), Gates und Fitness Functions setzen die Festlegungen aus Spec und ADR am Code durch (Modul 13). *Spec-as-source* schließt das Regelwerk nicht aus: Es setzt nicht voraus, dass ein Mensch Code schreibt (den schreibt der Implementer-Agent), und die Verifikation prüft den Code gegen die Spec (Modul 1). Dass die Spec die Quelle des Codes ist, der Code also aus ihr neu erzeugt werden kann, sagt das Regelwerk nicht; eigene Regeln dafür — etwa zur Regenerierbarkeit des Codes oder zur Kennzeichnung erzeugten Codes — enthält es nicht. Offen ist außerdem, wie die Gates und Hard Rules, die ein Mensch schreibt, zu „der Mensch fasst den Code nie an" passen. Belegt ist die Verträglichkeit damit nicht. Das Regelwerk schreibt kein SDD-Werkzeug und keinen Ablauf eines solchen Werkzeugs vor; sein eigener Ablauf ist der Entwicklungszyklus (Modul 1).

Die Bausteine, die Böckeler bei Kiro und Spec Kit nennt, haben im Regelwerk diesen Ort:

| Baustein | Ort im Regelwerk |
|---|---|
| Constitution (Spec Kit): Grundprinzipien des Projekts | `AGENTS.md` mit Hard Rules (Modul 9), ADRs (Modul 4) |
| Requirements (Kiro), Specify (Spec Kit) | Lastenheft mit Akzeptanzkriterien im Given/When/Then-Stil (Modul 3); die User-Story-Form gehört nicht hierher, siehe Abweichung unten |
| Design (Kiro), Plan (Spec Kit) | Spezifikation und Architektur-Sicht (Modul 3), ADRs (Modul 4) |
| Tasks (Kiro, Spec Kit) | Slice mit DoD und Datei-Tabelle im Plan (Modul 5); Roadmap und Wellen (Modul 6) ordnen Slices, sie sind keine Tasks |

Darüber hinaus führt das Regelwerk den Umsetzungs-Workflow (Modul 9), Review und Verifikation als getrennte Rollen (Modul 10 und 11), Gates (Modul 13) und den Rückwärtspfad von Closure und Verifikation zur Spec (Modul 1).

**Abweichung bei User Stories.** Kiro führt die Requirements als User Stories mit Akzeptanzkriterien. Im Regelwerk ist eine User Story kein Spec-Dokument, sondern Slice-Klasse und gehört unter `docs/plan/planning/`: Given/When/Then deklariert kein Stratum ([Referenz-Richtung §Spec-Straten](referenz-richtung.md#spec-straten-mehr-als-ein-spec-dokument)).
