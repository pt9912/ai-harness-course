# Modul 12 — Quality Gates

> **Aufwand:** ca. 90 Min Lesen · 90 Min Übung. Spiralcurriculum: das ID-Schema aus [Modul 2](../01-spec-und-architektur/modul-02-lastenheft.md) bekommt hier seine maschinelle Verankerung — Make-Target-Kommentare zitieren die Anforderungs-ID.

## Engage

`make gates` ist grün auf deiner Maschine. Im CI ist es rot. Du investierst
einen Nachmittag und findest: dein lokales Image hat Python 3.12, das
CI-Image Python 3.11. Wer hat hier versagt? Nicht der CI. Nicht Python.
Sondern *die Annahme, dass `make gates` ohne Image-Pinning sinnvoll ist*.
Reproduzierbarkeit ist nicht "läuft auch im CI", sondern "läuft im
*selben Image-Hash*".

## Lernziele

Nach diesem Modul kannst du:

* Gates als `make`-Targets mit ID-Kommentar *aufsetzen* (Anwenden),
* Critical Coverage von Gesamt-Coverage *unterscheiden* und ihre Schwellen *begründen* (Bewerten),
* einen ADR-Satz in eine Fitness Function *übersetzen* (Erschaffen — Brücke zu [Modul 3](../01-spec-und-architektur/modul-03-architektur-adrs.md)),
* einen bootstrap-aware Gate mit Hochschalt-Trigger *entwerfen* (Erschaffen),
* einen Gate-Typ einem Fehlerbild *zuordnen* (SQL-Injection → Security-Gate, Layer-Bruch → Architekturtest) (Analysieren).

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
Befehle behaupten, die es nicht gibt. Wenn `make fullbuild` aktuell rot
ist, wird das dokumentiert (mit Datum und Trigger), nicht ausgelassen
oder geschönt. Halluzinierte Gates sind die häufigste Form von
Harness-Lüge — und der Implementation-Agent vertraut ihnen.

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
Konkretion — genau deshalb deckt das Begleit-Lab fünf Sprachen
parallel ab.

## Typische Fehlvorstellungen

- **"Gate = Lint."** — Lint ist *ein* Gate-Typ. Architekturtests, Coverage-Gates, Security-Gates, Replay-Determinism-Gates sind weitere. Pro Repo entstehen sprachen- und domänenabhängige Gate-Familien.
- **"Wenn ein Gate manchmal rot sein darf, ist das pragmatisch."** — Dann ist es kein Gate, sondern ein Vorschlag. Pragmatik gehört in Carveouts oder bootstrap-aware Gates — mit Trigger und Folge-Slice.
- **"Coverage 80 % ist die richtige Schwelle."** — Es gibt keine universelle Schwelle. Critical Coverage (Security, Geld, Datenintegrität) ≠ Gesamt-Coverage. Schwellen sind ADR-pflichtig.
- **"`make gates` lokal grün heißt fertig."** — Nur wenn lokal und CI dasselbe Image benutzen (Modul 13). Sonst debuggst du den Unterschied.

## Worked Example: vom ADR-Satz zur Fitness Function

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

Nach den Übungen: [Reflexionsvorlage](../grundlagen/reflexion-vorlage.md).

## Selbstcheck

* Warum braucht es Critical Coverage zusätzlich zur Gesamt-Coverage?
* Welcher Gate-Typ erkennt eine SQL-Injection — Linter, Typecheck oder Security Gate?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Warum Critical Coverage *zusätzlich*? | "Wichtige Dateien besonders." | Gesamt-Coverage glättet kritische Pfade unter unkritischen Massendateien weg. Critical Coverage misst gezielt Pfade mit Sicherheits-, Geld- oder Datenintegritäts-Risiko. | + Folge: Critical Coverage hat *eigene* (höhere) Schwelle und *eigene* ADR-Kette für Schwellen-Senkung. Carveout auf Critical Coverage ist immer ein HIGH-Finding im Review. |
| SQL-Injection: Linter / Typecheck / Security Gate? | "Security Gate." | Security Gate (Semgrep/Bandit/CodeQL). Linter sieht den String, nicht die Semantik; Typecheck sieht den Typ `str`, nicht die Vertrauensgrenze. | + Hinweis: Manche Linter haben *Semgrep-Regeln* integriert (z. B. `bandit` für Python) — Trennlinie ist nicht "Tool", sondern "Regel-Klasse". Security-Regeln verlangen *Datenfluss*-Analyse, klassische Linter machen nur lokale Mustererkennung. |

## Weiterlesen

* Nächstes Modul: [Modul 13 — Docker Harness](../05-betrieb/modul-13-docker-harness.md)
