# Modul 12 — Quality Gates

> **Aufwand:** ca. 90 Min Lesen · 90 Min Übung. Spiralcurriculum: das ID-Schema aus [Modul 2](../01-spec-und-architektur/modul-02-lastenheft.md) bekommt hier seine maschinelle Verankerung — Make-Target-Kommentare zitieren die Anforderungs-ID.

## Mini-Glossar für dieses Modul

Sechs neue Begriffe — Volldefinitionen in
[`../grundlagen/konventionen.md`](../grundlagen/konventionen.md#kernbegriffe).

| Begriff | Ein-Satz-Definition | Bild im Kopf |
|---|---|---|
| **Quality Gate** | Maschinell prüfbarer `make`-Schritt, der rot/grün entscheidet — kein Adjektiv. | Schranke vor dem Bahnübergang, nicht ein Schild. |
| **Fitness Function** | Maschinell prüfbare *Architektur-Aussage* (ArchUnit/dep-cruiser/import-linter). | ADR-Aussage mit Schalter, nicht Absichtserklärung. |
| **Critical Coverage** | Coverage-Schwelle für *kritische Datei-Pfade* — schärfer als Gesamt-Coverage. | Strengere TÜV-Vorgaben für Bremsanlage als für Lackoberfläche. |
| **Bootstrap-aware Gate** | Gate mit *Reifegrad-Stufe* und *Hochschalt-Trigger* — terminierter Carveout, kein Schlupfloch. | Stützrad am Kinderfahrrad, mit Datum für den Abbau. |
| **Halluziniertes Gate** | Im `harness/README.md` versprochener Schritt, der real nicht existiert oder dauerhaft rot ist. | Schild "Vorsicht, Stufe" ohne Stufe. |
| **Domänen-Gate** | Repo-spezifisches Gate jenseits der generischen sechs (`test-determinism`, `noqa-gate`, `solid-suppression-gate`). | Werks-eigenes Prüfgerät neben dem TÜV-Standard. |

## Engage

`make gates` ist grün auf deiner Maschine. Im CI ist es rot. Du investierst
einen Nachmittag und findest: dein lokales Image hat Python 3.12, das
CI-Image Python 3.11. Wer hat hier versagt? Nicht der CI. Nicht Python.
Sondern *die Annahme, dass `make gates` ohne Image-Pinning sinnvoll ist*.
Reproduzierbarkeit ist nicht "läuft auch im CI", sondern "läuft im
*selben Image-Hash*".

## Lernziele

Nach diesem Modul kannst du:

* Gates als `make`-Targets mit ID-Kommentar *aufsetzen* (Anwenden · prozedural),
* Critical Coverage von Gesamt-Coverage *unterscheiden* und ihre Schwellen *begründen* (Bewerten · konzeptuell),
* einen ADR-Satz in eine Fitness Function *übersetzen* (Erschaffen · prozedural — Brücke zu [Modul 3](../01-spec-und-architektur/modul-03-architektur-adrs.md)),
* einen bootstrap-aware Gate mit Hochschalt-Trigger *entwerfen* (Erschaffen · prozedural),
* einen Gate-Typ einem Fehlerbild *zuordnen* (SQL-Injection → Security-Gate, Layer-Bruch → Architekturtest) (Analysieren · konzeptuell).

## Lab-Bezug

```bash
make lint
make typecheck
make arch-check
make coverage-gate
make coverage-gate-critical
make gates
```

## Themen

* Linter
* Typecheck
* Architekturtests
* Coverage Gates
* Critical Coverage Gates
* Security Gates

## Harness-Einordnung

Gates = *computational feedback* (siehe
[`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)).
Schnellste und billigste Sensoren des Harness. Was hier prüfbar wird,
muss nicht mehr im Review-Agent landen — das ist die wichtigste
Einsparung im gesamten System.

## Kernidee

Gates sind Aussagen, die *immer* gelten müssen. Wenn ein Gate "manchmal"
rot sein darf, ist es kein Gate, sondern ein Vorschlag.

## Hard Rule (Doku-Disziplin)

In `harness/README.md` und in jeder Doku, die Gates aufzählt: keine
Befehle behaupten, die es nicht gibt. Wenn `make fullbuild` strukturell
rot ist, wird das als Carveout in `docs/plan/carveouts/CO-<NNN>-…`
dokumentiert ([Modul 6](../02-planung/modul-06-carveouts.md)) und in
der Bindung-Spalte der Sensors-Tabelle per `CO-<NNN>`-ID verlinkt — nicht
ausgelassen, nicht geschönt, nicht in einer Status-Spalte versteckt
(die Sensors-Tabelle trägt keinen Lauf-Status; Lauf-Wahrheit pro Commit
liegt in CI, siehe
[`../grundlagen/konventionen.md`](../grundlagen/konventionen.md#harnessreadmemd-als-einstiegspunkt)).
Halluzinierte Gates sind die häufigste Form von Harness-Lüge — und der
Implementation-Agent vertraut ihnen.

## Bootstrap-aware Gates

In der Frühphase eines Projekts ist eine harte Coverage-Schwelle Unsinn.
Statt sie zu verschweigen: bekenne den Reifegrad. Ein bootstrap-aware
Gate dokumentiert seine Stufe und seinen Hochschalt-Trigger im
Make-Target:

```
coverage-gate: ## Coverage threshold gate (bootstrap-aware, LH-FA-BUILD-008).
```

Das Gate prüft heute z. B. 40 %, schaltet bei Meilenstein M2 auf 70 %
hoch. Das macht "bootstrap-aware" nicht zum Schlupfloch, sondern zum
explizit terminierten Carveout.

## Reichhaltige Gate-Landschaft als Inspiration

Ein reifes Repo (Beispiel `pt9912/grid-gym`, siehe
[`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)) hat
deutlich mehr als sechs Gates:

```
lint · format-check · typecheck
arch-check · arch-check-imports · arch-check-custom
docs-check · spdx-check · noqa-check · noqa-gate
test-unit · test-determinism · test-replay · test-fault
test-integration
coverage-gate · coverage-gate-critical
dep-audit · image-audit · openapi-validate
```

Pointe: Domänenspezifische Gates (`test-determinism`, `test-replay`,
`noqa-gate`) entstehen aus dem Steering Loop — nicht aus einem
Standard-Setup. Wenn dein Repo nur die generischen sechs hat, weißt du
nur, dass du noch keine Schmerzen hattest.

Ein zweites Beispiel in einer anderen Sprach-Welt: `pt9912/bess-ems`
(C#/.NET, Safety/Control) bringt Gate-Familien mit, die `grid-gym`
nicht hat — `solid-suppression-gate` (C#-Pendant zum noqa-gate),
`test-mpc-property` (Property-Based-Sensor für Regelungstechnik),
`native-sanitizer` (für C/C++-Interop-Anteile), `test-hil-*`
(Hardware-in-the-Loop). Voll ausgeschrieben in
[`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md).

Pro Sprache wachsen also unterschiedliche Gate-Familien. Der Harness
ist sprach-unabhängig im Konzept, aber sprach-abhängig in der
Konkretion — genau deshalb wird das Begleit-Lab in Phase C fünf
Sprachen parallel abdecken (heute noch nicht ausgeliefert).

## Typische Fehlvorstellungen

- **"Gate = Lint."** — Lint ist *ein* Gate-Typ. Architekturtests, Coverage-Gates, Security-Gates, Replay-Determinism-Gates sind weitere. Pro Repo entstehen sprachen- und domänenabhängige Gate-Familien.
- **"Wenn ein Gate manchmal rot sein darf, ist das pragmatisch."** — Dann ist es kein Gate, sondern ein Vorschlag. Pragmatik gehört in Carveouts oder bootstrap-aware Gates — mit Trigger und Folge-Slice.
- **"Coverage 80 % ist die richtige Schwelle."** — Es gibt keine universelle Schwelle. Critical Coverage (Security, Geld, Datenintegrität) ≠ Gesamt-Coverage. Schwellen sind ADR-pflichtig.
- **"`make gates` lokal grün heißt fertig."** — Nur wenn lokal und CI dasselbe Image benutzen (Modul 13). Sonst debuggst du den Unterschied.
- **"Mehr Tests sind immer besser."** — Falsch in zwei Richtungen. Erstens: 80 % Gesamt-Coverage über *unkritischem* Code verbirgt 0 % Coverage auf dem Sicherheitspfad — Critical Coverage misst *gezielt*. Zweitens: Tests gegen Beispiele decken nur Realität ab, *wo das Golden Set repräsentativ ist* ([Modul 11](modul-11-replay-evaluierung.md)); Tests gegen die *Spec* erschließt Verifikation ([Modul 10](modul-10-verification.md)). Wer Test-Anzahl als Qualitätsmaß nimmt, baut Coverage-Anstiege, deren Wert auf 0 fällt, sobald die Realität die Coverage-Annahme bricht. Faustregel: *Verteilung vor Anzahl*. Ein zusätzlicher Test gegen einen bereits gut abgedeckten Pfad ist Boilerplate; ein zusätzlicher Test gegen einen *bisher unabgedeckten kritischen* Pfad ist Sensor.

Weitere Präkonzepte, die diesem Kurs zugrunde liegen: [`../grundlagen/lernervorstellungen.md`](../grundlagen/lernervorstellungen.md). Ergänze deine eigenen.

## Worked Example: vom ADR-Satz zur Fitness Function

> **Wenn du ArchUnit / import-linter / dep-cruiser bereits routiniert einsetzt, springe zu [§Übungen](#übungen).** Das Worked Example zeigt die Übersetzungsschablone für den ersten oder zweiten Fall — wer sie kann, gewinnt durch Wiederholung wenig (Expertise-Reversal). Übung 1 setzt das Schema sofort produktiv.

**Ausgangs-ADR:** ADR-0007 (siehe Worked Example in [Modul 3](../01-spec-und-architektur/modul-03-architektur-adrs.md#worked-example-vom-diskussionsfaden-zum-prüfbaren-adr)) sagt:

> "Service-Layer importiert ausschließlich aus `adapter/`-Paket."

**Schritt 1 — Aussage maschinell formulieren.** Aus *"importiert
ausschließlich aus"* wird:
> Keine Datei unter `src/service/**` darf einen Import enthalten, dessen
> Modul nicht mit `adapter.` beginnt oder ein Standardbibliotheks-Modul ist.

**Schritt 2 — Werkzeug wählen.** Python → `import-linter` oder
`grimp`. Java → `ArchUnit`. Go → `depguard`. Allgemein:
`dep-cruiser` für Node, eigene AST-Scanner für Nischensprachen.

**Schritt 3 — Implementierung (Python-Beispiel mit `import-linter`):**

```ini
# .importlinter
[importlinter]
root_packages = service

[importlinter:contract:service-adapter-only]
name = service imports only from adapter or stdlib
type = forbidden
source_modules =
    service
forbidden_modules =
    requests
    urllib3
    httpx
```

**Schritt 4 — Als Gate verdrahten:**

```makefile
arch-check:  ## LH-QA-COUPLING-002 / ADR-0007 — Service-Adapter-Trennung
	lint-imports
```

**Schritt 5 — `make gates` lokal grün — und im CI mit gepinnter
Toolchain (Modul 13).**

**Schritt 6 — Bewusstes Brechen:** Implementer fügt zu Debug-Zwecken
`import requests` in `service/foo.py`. `make arch-check` läuft rot mit
`ADR-0007 violated`. Genau der Effekt, der eine ADR von einer
Absichtserklärung trennt.

## Übungen

* Schreibe einen Architekturtest, der ADR-3 als Regel umsetzt
* Provoziere absichtlich einen Coverage-Gate-Failure auf einer kritischen Datei
* **(Erschaffen — aktiviert LZ "bootstrap-aware Gate entwerfen")** *Entwirf ein bootstrap-aware Gate von Grund auf.* Wähle eine Gate-Klasse, die in einem frühphasigen Repo zwingend rot wäre (Coverage, Mutation-Score, Lighthouse-Score, `noqa`-Count, Doku-Konsistenz). Liefere drei Artefakte: (a) Ein-Zeilen-Make-Target-Kommentar im Stil `gate-x: ## ... (bootstrap-aware, LH-FA-...).`, (b) eine **Hochschalt-Tabelle** mit mindestens drei Stufen (heute / Meilenstein M1 / Meilenstein M2) inkl. konkreter Schwellen und Hochschalt-*Trigger* (Trigger ist ein Ereignis im Repo, kein Datum), (c) eine Hard Rule, was geschieht, wenn der Trigger eintritt, aber die Schwelle nicht eingehalten wird (z. B. *"automatische Carveout-Eröffnung mit Folge-Slice"*). Anti-Antwort: *"40 % heute, 80 % später"* ohne Trigger — das ist nicht bootstrap-aware, sondern aufgeschoben.

## Reflexion

Vier Standardfragen aus [`../grundlagen/reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md)
nach dem Architekturtest-Bau und dem provozierten Coverage-Failure.
Modul-spezifische Trigger:

- **Beobachtung:** Welche ADR-Aussage hattest du schwer in eine Fitness Function übersetzt? Welcher Coverage-Lauf war auf welchem kritischen Pfad rot?
- **2×2-Quadrant:** Gates sind *computational feedback*; bootstrap-aware Gates kombinieren mit Trigger-Disziplin (*inferential feedforward*).
- **Steering-Loop:** bootstrap-aware Gate dokumentieren? ID-Kommentar im Make-Target nachziehen? domänenspezifisches Gate (`test-determinism`, `noqa-gate`) einführen?
- **Conceptual Change:** Kandidaten in [`../grundlagen/lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "Gate = Lint", "Coverage 80 % ist die richtige Schwelle", "Mehr Tests sind immer besser").

## Selbstcheck

* **(Erinnern)** Nenne fünf generische Gate-Familien, die der Kurs als computational feedback einsetzt.
* Warum braucht es Critical Coverage zusätzlich zur Gesamt-Coverage?
* Welcher Gate-Typ erkennt eine SQL-Injection — Linter, Typecheck oder Security Gate?
* **(Anwenden)** Du sollst einen neuen Gate (z. B. `coverage-gate-critical`) in deinem Repo einführen. Welche drei Vorbedingungen klärst du, *bevor* du das Target schreibst?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Fünf Gate-Familien? | drei oder vier genannt | Linter · Typecheck · Architekturtest · Coverage (mit Critical-Variante) · Security-Gate. Optional zusätzlich: Replay-/Determinism-Gates, Suppression-Gates, Dep-/Image-Audit. | + Hinweis: domänenspezifische Gates (z. B. `test-determinism`, `solid-suppression-gate`, `test-mpc-property`) entstehen aus dem Steering Loop, nicht aus einem Standard-Setup. Ein Repo mit nur den fünf generischen Gates hat noch keine Schmerzen verarbeitet. |
| Warum Critical Coverage *zusätzlich*? | "Wichtige Dateien besonders." | Gesamt-Coverage glättet kritische Pfade unter unkritischen Massendateien weg. Critical Coverage misst gezielt Pfade mit Sicherheits-, Geld- oder Datenintegritäts-Risiko. | + Folge: Critical Coverage hat *eigene* (höhere) Schwelle und *eigene* ADR-Kette für Schwellen-Senkung. Carveout auf Critical Coverage ist immer ein HIGH-Finding im Review. |
| SQL-Injection: Linter / Typecheck / Security Gate? | "Security Gate." | Security Gate (Semgrep/Bandit/CodeQL). Linter sieht den String, nicht die Semantik; Typecheck sieht den Typ `str`, nicht die Vertrauensgrenze. | + Hinweis: Manche Linter haben *Semgrep-Regeln* integriert (z. B. `bandit` für Python) — Trennlinie ist nicht "Tool", sondern "Regel-Klasse". Security-Regeln verlangen *Datenfluss*-Analyse, klassische Linter machen nur lokale Mustererkennung. |
| Drei Vorbedingungen für ein neues Gate? | "Tool installieren." | (1) Anforderung mit ID (Spec oder ADR), die das Gate prüft — sonst ist es ein Vorschlag · (2) Schwelle ist begründet (ADR oder Carveout für Übergangsphase) · (3) Lokales und CI-Image laufen identisch (Modul 13); andernfalls debuggt das Team später den Image-Unterschied. | + Empfohlen: Gate-Target trägt ID-Kommentar (`coverage-gate-critical: ## LH-QA-CRIT-003`); ohne diesen Kommentar ist die Traceability-Kette gebrochen, und ein gerötetes Gate erzeugt keinen klaren Bezug zur verletzten Anforderung. |

## Weiterlesen

* Nächstes Modul: [Modul 13 — Docker Harness](../05-betrieb/modul-13-docker-harness.md)
