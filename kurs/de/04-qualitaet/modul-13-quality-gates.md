# Modul 13 — Quality Gates

> **Aufwand:** ca. 90 Min Lesen · 90 Min Übung. Spiralcurriculum: das ID-Schema aus [Modul 3](../01-spec-und-architektur/modul-03-spec.md) bekommt hier seine maschinelle Verankerung — Make-Target-Kommentare zitieren die Anforderungs-ID.

## Mini-Glossar für dieses Modul

Sechs neue Begriffe — Volldefinitionen in
[`begriffe.md`](../grundlagen/begriffe.md#kernbegriffe).

| Begriff | Ein-Satz-Definition | Bild im Kopf |
|---|---|---|
| **Quality Gate** | Maschinell prüfbarer `make`-Schritt, der rot/grün entscheidet — kein Adjektiv. | Schranke vor dem Bahnübergang, nicht ein Schild. |
| **Fitness Function** | Maschinell prüfbare *Architektur-Aussage* (ArchUnit/dep-cruiser/import-linter). | ADR-Aussage mit Schalter, nicht Absichtserklärung. |
| **Critical Coverage** | Coverage-Schwelle für *kritische Datei-Pfade* — schärfer als Gesamt-Coverage. | Strengere TÜV-Vorgaben für Bremsanlage als für Lackoberfläche. |
| **Bootstrap-aware Gate** | Gate mit *Reifegrad-Stufe* und *Hochschalt-Trigger* — terminierter Carveout, kein Schlupfloch. | Stützrad am Kinderfahrrad, mit Datum für den Abbau. |
| **Halluziniertes Gate** | Im `harness/README.md` versprochener Schritt, der real nicht existiert oder dauerhaft rot ist. | Schild "Vorsicht, Stufe" ohne Stufe. |
| **Domänen-Gate** | Repo-spezifisches Gate jenseits der generischen sechs (`test-determinism`, `noqa-gate`, `solid-suppression-gate`). | Werks-eigenes Prüfgerät neben dem TÜV-Standard. |

**Begriffsklärung:** *Bootstrap-aware Gate* (oben) ist nicht zu
verwechseln mit *Harness-Bootstrap* aus
[`bootstrap.md` §Harness-Bootstrap](../grundlagen/bootstrap.md#harness-bootstrap).
Letzteres ist der **Repo-Einstiegsprozess** (Lebenszyklus eines Harness
im Repo); ersteres ist die **Reifestufe eines einzelnen Sensors**.
Beide Begriffe teilen das Wort, sind strukturell verschieden.

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
* einen ADR-Satz in eine Fitness Function *übersetzen* (Erschaffen · prozedural — Brücke zu [Modul 4](../01-spec-und-architektur/modul-04-adrs.md)),
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

## Gate-Typ ↔ Fehlerbild

Wer einen neuen Sensor in den Steering Loop einzieht, muss wissen,
*welche Sensor-Klasse welche Fehlerklasse fängt* — sonst reagiert er
auf einen wiederkehrenden Fehler mit dem falschen Sensor, und der
Steering Loop läuft leer. Die Zuordnung in Kurzform:

| Gate-Typ | typisches Fehlerbild | was er NICHT fängt |
|---|---|---|
| Linter | lokale Muster: toter Import, verbotenes Idiom, Suppression-Marker | Datenfluss über Funktionsgrenzen, Struktur-Regeln |
| Typecheck | Typgrenzen-Verstoß: falsche Signatur, `None` am falschen Ort | Vertrauensgrenzen — `str` bleibt `str`, ob nutzerkontrolliert oder nicht |
| Architekturtest | Struktur-/Import-Regel: Layer-Bruch, Domäne importiert Infrastruktur | Verhalten zur Laufzeit, lokale Muster |
| Security-Gate | Datenfluss-Befund: SQL-Injection, Secret-/Entropie-Treffer | Architektur-Schnitt, Coverage-Lücken |
| Coverage / Critical Coverage | Coverage-Loch — gesamt bzw. auf dem kritischen Pfad | Qualität der Tests, Spec-Lücken ([Modul 11](modul-11-verification.md)) |
| Replay-/Determinism-Gate | nicht-deterministischer Test oder Lauf | semantische Drift außerhalb des Golden Sets ([Modul 12](modul-12-replay-evaluierung.md)) |
| Integrationstest | Verhalten im Zusammenspiel: Komponenten-Vertrag bricht erst in Kombination | lokale Muster und Typgrenzen — dafür zu teuer und zu spät |

Trennlinie ist die *Regel-Klasse*, nicht das Tool: Linter machen lokale
Mustererkennung, Security-Regeln verlangen Datenfluss-Analyse,
Architekturtests prüfen Struktur, Integrationstests Verhalten im
Zusammenspiel. Die Zuordnung selbst probst du im
[Selbstcheck](#selbstcheck) (Item zu LZ 5 — vier Fehlerbilder mit
Begründung des Unterscheidungs-Kriteriums); genau diese Sensor-Literacy
ruft auch [Checkpoint D](../grundlagen/checkpoints.md#checkpoint-d--nach-phase-04-qualität)
ab.

## Gate und Beleg — zwei Rollen derselben Prüfung

Dieselbe Prüfung tritt in zwei Rollen auf, und sie dürfen einander nicht
behindern:

| Rolle | Aufgabe | Verhalten bei Befund |
|---|---|---|
| **Gate** | urteilen | Exit ≠ 0, der Lauf bricht ab |
| **Beleg** | berichten | schreibt **immer** — auch, gerade dann, wenn die Prüfung rot ist |

Ein Befund darf den Report nicht verhindern, sonst fehlt die Diagnose genau
dann, wenn man sie braucht. **Das Urteil fällt im Gate, nicht im Beleg** —
deshalb gehört ein `|| true` an den Beleg-Lauf und **nie** an den Gate-Lauf;
dort wäre es ein [behauptetes Gate](#hard-rule-doku-disziplin).

Daraus folgt eine Aufbau-Regel: **Die Stelle, die Belege einsammelt, darf
nicht vom Gate abhängen.** In einem Multi-Stage-Build erbt die sammelnde
Stage von der Quell-Stage, nicht von der Gate-Stage — sonst macht ein roter
Gate genau das Werkzeug unbaubar, mit dem man ihn untersucht. In einem
Makefile ist es dieselbe Regel: Der Beleg-Lauf hängt nicht am Gate-Target.

Zwei Rollen sind keine zwei Wahrheiten: Beide laufen auf demselben Stand und
mit derselben Konfiguration. Wer sie auseinanderlaufen lässt — der Beleg mit
lockereren Regeln als der Gate —, hat keinen Report, sondern eine zweite
Meinung.

## Hard Rule (Doku-Disziplin)

In `harness/README.md` und in jeder Doku, die Gates aufzählt: keine
Befehle behaupten, die es nicht gibt. Wenn `make fullbuild` strukturell
rot ist, wird das als Carveout in `docs/plan/carveouts/CO-<NNN>-…`
dokumentiert ([Modul 7](../02-planung/modul-07-carveouts.md)) und in
der Bindung-Spalte der Sensors-Tabelle per `CO-<NNN>`-ID verlinkt — nicht
ausgelassen, nicht geschönt, nicht in einer Status-Spalte versteckt
(die Sensors-Tabelle trägt keinen Lauf-Status; Lauf-Wahrheit pro Commit
liegt in CI, siehe
[`harness-dateien.md`](../grundlagen/harness-dateien.md#harnessreadmemd-als-einstiegspunkt)).
Halluzinierte Gates sind die häufigste Form von Harness-Lüge — und der
Implementer-Agent vertraut ihnen.

**Eine neue Hard Rule trägt ab ihrer Einführung einen Auflösungs-Trigger oder
die Kennzeichnung *permanent*** — dieselbe Disziplin, die ADR
(Re-Evaluierungs-Trigger, [Modul 4](../01-spec-und-architektur/modul-04-adrs.md))
und Carveout ([Modul 7](../02-planung/modul-07-carveouts.md)) längst tragen:
Ein Korpus, der nur wächst, kostet den nächsten Leser jedes Jahr mehr. Für den
**Altbestand** gilt: kein Nachrüsten — ein nachgetragener Trigger wäre
erfunden, nicht rekonstruiert; der leere Zustand ist die ehrliche Information.
Deklarierter Backfill bleibt möglich, wo sich der Trigger wirklich herleiten
lässt.

**Vorhanden ≠ behauptet.** Die Regel verbietet ein *behauptetes* Gate ohne
Deckung — nicht ein *vorhandenes* Target ohne Anspruch. Ein tool-generiertes
Gate-Fragment (`d-check.mk` aus `d-check --print-mk`, per `-include` eingebunden
statt handgeschrieben — so pflegt das Tool die Recipe-Form und nichts driftet;
`-include` bleibt still, bis das Fragment beim Bootstrap erzeugt ist)
bringt oft mehr Targets mit, als du als Gate führst. Nur das genutzte
(`docs-check`) steht in `harness/README.md`/`AGENTS.md` und `make gates`; die
übrigen (advisory: `doc-trace`, `doc-doctor`, …) sind **verfügbar, aber nicht als
Gate behauptet** — genau wie ein Maintenance-Target (`regelwerk-check`), das
bewusst nicht in `gates` läuft. Die Lüge wäre, ein Gate zu *versprechen*, das
nicht läuft; ein reales Target *nicht* zu versprechen ist keine.

## Bootstrap-aware Gates

In der Frühphase eines Projekts ist eine harte Coverage-Schwelle Unsinn.
Statt sie zu verschweigen: bekenne den Reifegrad. Ein bootstrap-aware
Gate dokumentiert seine Stufe und seinen Hochschalt-Trigger im
Make-Target:

```
coverage-gate: ## Coverage threshold gate (bootstrap-aware, LH-FA-BUILD-008).
```

**Kam das Gate aus dem Steering Loop statt aus einer Anforderung**, trägt
der Kommentar zusätzlich den Herkunfts-Anker `· seit welle-<NN>` — ohne Welle `· seit slice-<NNN>`
([`traceability.md` §Herkunfts-Anker](../grundlagen/traceability.md#herkunfts-anker-für-steering-loop-regeln))
— sonst ist beim nächsten Aufräumen nicht mehr rekonstruierbar, welche
Beobachtung es erzwungen hat.

Das Gate prüft heute z. B. 40 %, schaltet bei Meilenstein M2 auf 70 %
hoch. Das macht "bootstrap-aware" nicht zum Schlupfloch, sondern zum
**explizit terminierten Reifestufen-Gate** — ein Werkzeug eigener
Klasse, kein Subtyp von Carveout (die Werkzeug-Triade-Einordnung
steht direkt unter diesem Absatz).

**Werkzeug-Triade-Einordnung.** Bootstrap-aware Gate ist eine der
drei legitimen Antworten auf gelockerte Gate-Disziplin neben
*Carveout* (punktuelle Ausnahme mit Folge-Slice) und
*BF-Sub-Area-Markierung* (Sub-Area-weiter Übergangs-Modus mit
Graduation-Plan, Konzept in
[Modul 2 §Kernidee](../01-spec-und-architektur/modul-02-harness-bootstrap.md#kernidee)).
**Die BF-Sub-Area-Markierung ist nicht selbst ein Closure-Werkzeug**,
sondern der Sub-Area-Kontext, in dem Carveout und Bootstrap-aware
Gate als Closure-Antworten strukturell legitim werden —
Disambiguierung in
[Modul 7 §Worked Example A Schritt 6](../02-planung/modul-07-carveouts.md#worked-example-a-einen-carveout-dokumentieren).

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

`test-replay` ist dabei das **Gate**, nicht die Praxis: Das Replay-Set
selbst baut [Modul 12](modul-12-replay-evaluierung.md), dieses Target
setzt es durch. Gleiches Wort, zwei Ebenen.

Ein zweites Beispiel in einer anderen Sprach-Welt: `pt9912/bess-ems`
(C#/.NET, Safety/Control) bringt Gate-Familien mit, die `grid-gym`
nicht hat — `solid-suppression-gate` (C#-Pendant zum noqa-gate),
`test-mpc-property` (Property-Based-Sensor für Regelungstechnik),
`native-sanitizer` (für C/C++-Interop-Anteile), `test-hil-*`
(Hardware-in-the-Loop). Voll ausgeschrieben in
[`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md).

Pro Sprache wachsen also unterschiedliche Gate-Familien. Der Harness
ist sprach-unabhängig im Konzept, aber sprach-abhängig in der
Konkretion — genau deshalb deckt das Begleit-Lab **sechs** Sprachen
parallel ab (Go, Python, Kotlin, Java, C#, C++), jede mit eigener
Gate-Familie hinter demselben `make gates`-Vertrag.

## Typische Fehlvorstellungen

- **"Gate = Lint."** — Lint ist *ein* Gate-Typ. Architekturtests, Coverage-Gates, Security-Gates, Replay-Determinism-Gates sind weitere. Pro Repo entstehen sprachen- und domänenabhängige Gate-Familien.
- **"Wenn ein Gate manchmal rot sein darf, ist das pragmatisch."** — Dann ist es kein Gate, sondern ein Vorschlag. Pragmatik gehört in Carveouts oder bootstrap-aware Gates — mit Trigger und Folge-Slice.
- **"Coverage 80 % ist die richtige Schwelle."** — Es gibt keine universelle Schwelle. Critical Coverage (Security, Geld, Datenintegrität) ≠ Gesamt-Coverage. Schwellen sind ADR-pflichtig.
- **"`make gates` lokal grün heißt fertig."** — Nur wenn lokal und CI dasselbe Image benutzen (Modul 14). Sonst debuggst du den Unterschied.
- **"Mehr Tests sind immer besser."** — Falsch in zwei Richtungen. Erstens: 80 % Gesamt-Coverage über *unkritischem* Code verbirgt 0 % Coverage auf dem Sicherheitspfad — Critical Coverage misst *gezielt*. Zweitens: Tests gegen Beispiele decken nur Realität ab, *wo das Golden Set repräsentativ ist* ([Modul 12](modul-12-replay-evaluierung.md)); Tests gegen die *Spec* erschließt Verifikation ([Modul 11](modul-11-verification.md)). Wer Test-Anzahl als Qualitätsmaß nimmt, baut Coverage-Anstiege, deren Wert auf 0 fällt, sobald die Realität die Coverage-Annahme bricht. Faustregel: *Verteilung vor Anzahl*. Ein zusätzlicher Test gegen einen bereits gut abgedeckten Pfad ist Boilerplate; ein zusätzlicher Test gegen einen *bisher unabgedeckten kritischen* Pfad ist Sensor.

Weitere Präkonzepte, die diesem Kurs zugrunde liegen: [`../grundlagen/lernervorstellungen.md`](../grundlagen/lernervorstellungen.md). Ergänze deine eigenen.

## Worked Example A: vom ADR-Satz zur Fitness Function

> **Wenn du ArchUnit / import-linter / dep-cruiser bereits routiniert einsetzt, springe zu [§Übungen](#übungen).** Das Worked Example zeigt die Übersetzungsschablone für den ersten oder zweiten Fall — wer sie kann, gewinnt durch Wiederholung wenig (Expertise-Reversal). Übung 1 setzt das Schema sofort produktiv.

**Ausgangs-ADR:** ADR-0007 (siehe Worked Example in [Modul 4](../01-spec-und-architektur/modul-04-adrs.md#worked-example-vom-diskussionsfaden-zum-prüfbaren-adr)) sagt:

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
Toolchain (Modul 14).**

**Schritt 6 — Bewusstes Brechen:** Implementer fügt zu Debug-Zwecken
`import requests` in `service/foo.py`. `make arch-check` läuft rot mit
`ADR-0007 violated`. Genau der Effekt, der eine ADR von einer
Absichtserklärung trennt.

**Und das Rot muss von *dieser* Regel kommen.** Ein roter Exit ist
erstaunlich leicht aus dem falschen Grund zu bekommen: ein Nachbar-Gate, das
ohnehin schon rot war · ein Tippfehler, an dem das Werkzeug abbricht, bevor
es prüft · eine Probe, die im Abschnitt landet, den die Prüfung ausnimmt —
dann schweigt der Wächter zu Recht und man verbucht es als *„greift nicht"*.
Der Nachweis ist deshalb nicht *„es wurde rot"*, sondern die **gelesene
Ursache**: Die Meldung nennt die gebrochene Regel und die Fundstelle, und
beides gehört angesehen. Wer das überspringt, hat den Lauf gegen eine
Behauptung eingetauscht — und die Behauptung ist das, was Schritt 6
widerlegen soll.

Das ist die eine Richtung. Die andere führt
[Modul 11 §Worked Example, Schritt 8](modul-11-verification.md#worked-example-eine-adr-aussage-ohne-fertiges-tool-als-fitness-function-bauen):
der **unveränderte Bestand**, auf dem der Sensor schweigen muss. Zusammen
sind sie ein Paar — er wird aus dem richtigen Grund rot und bleibt sonst
still. Fällt eine der beiden Proben aus, sagt die verbleibende nichts über
die andere: Ein Wächter, der immer rot wird, besteht die Positivkontrolle;
einer, der nie rot wird, die Negativkontrolle.

## Worked Example B: Guard-Härtung als Steering-Loop am Wächter

> **Voraussetzung:** [`../grundlagen/durchsetzungsschicht.md`](../grundlagen/durchsetzungsschicht.md) (drei Bindepunkte, vier Design-Eigenschaften). Dieses Beispiel zeigt nicht, *wie* man einen Wächter baut, sondern wie er **über Wellen reift** — und wo diese Reifung dokumentarisch landet.

Worked Example A baut einen Sensor: einmal geschrieben, dann grün. Der
zweite Fall ist der unbequemere — der **Sensor selbst** wird zum
Gegenstand des Steering-Loops. Gehärtet wird hier ein **Befehls-Guard**:
ein Tool-Call-Gate (`PreToolUse`-Hook), das die Regel „Toolchain nur
über `make`" durchsetzt (Bindepunkt-Tabelle in
[`../grundlagen/durchsetzungsschicht.md`](../grundlagen/durchsetzungsschicht.md#drei-bindepunkte)).

**Ausgangsregel**, bisher nur in `AGENTS.md` — also *inferential
feedforward*: „Rufe Test-, Lint- und Typecheck-Werkzeuge nie direkt auf;
benutze das `make`-Target. `make` läuft im gepinnten Image (Modul 14)."

### Welle 1 — die Regel bekommt einen Wächter (`MR-004`)

**Beobachtung.** Drei Slices hintereinander, je im Lerneintrag notiert:
der Implementer-Agent ruft `pytest -q` direkt auf. Lokal grün, im CI
rot — Python 3.12 gegen 3.11, exakt das Bild aus [§Engage](#engage).
Einmal ist ein Vorfall, zweimal ein Symptom, dreimal eine **Lücke**
([Steering Loop](../grundlagen/klassifikation.md#steering-loop)).

**Sensor-Wahl.** Wiederkehrender Tool-Missbrauch verlangt *computational
feedforward* — nicht noch einen `make`-Gate. Ein Gate liefe **nach** dem
falschen Aufruf und stellte nur fest, dass die Toolchain-Version nicht
passte; der Bindepunkt, der den Aufruf gar nicht erst zulässt, ist der
Tool-Call-Gate.

**Realisierung.** Der Hook liest die Kommandozeile und prüft die
**Befehlspositionen** — das erste Wort, plus jedes Wort nach `&&`, `||`,
`;`, `|` — gegen eine Denylist (`pytest`, `ruff`, `mypy`, `pip`,
`docker`). Treffer → der Tool-Call wird blockiert, die Meldung nennt das
Ersatz-Target (`pytest` → `make test-unit`).

**Landung in `harness/conventions.md`:**

```
### MR-004 — Toolchain-Aufrufe nur über make (Tool-Call-Gate)

- **Datum:** 2026-03-04
- **Geltungsbereich:** `.claude/settings.json`, `.claude/hooks/guard-bash.sh`;
  Regel-Text in `AGENTS.md` §Safety and scope boundaries
- **Adaption:** Die Baseline-Regel „make/Docker-only" wird von *inferential*
  auf *computational feedforward* gehoben: ein `PreToolUse`-Hook blockiert
  Tool-Calls, deren Befehlsposition auf der Denylist steht.
- **Begründung:** Drei Vorfälle in Folge (Lerneinträge slice-041/044/047):
  direkter `pytest`-Aufruf, lokal grün / CI rot durch ungepinnte
  Interpreter-Version.
- **Grenze:** Stolperdraht, keine Sandbox — geprüft wird die Befehlsposition,
  nicht der Effekt. Interpreter-Umwege (`python -c "…"`) bleiben möglich;
  Netz dafür ist CI.
- **Auflösungs-Trigger:** permanent.
```

Die `Grenze:`-Zeile ist hier ein **repo-lokales Zusatzfeld** — die
Pflichtfelder des Adaptions-Blocks (Datum, Geltungsbereich, Adaption,
Begründung, Auflösungs-Trigger) sind damit nicht angetastet. Wo die
Grenz-Aussage steht, ist Wahl; *dass* sie dasteht, ist Pflicht: ein
Wächter, der so gelesen werden kann, als decke er mehr ab als er tut,
ist selbst eine
[Harness-Lüge](../grundlagen/begriffe.md#kernbegriffe) — dieselbe
Klasse wie das halluzinierte Gate aus
[§Hard Rule](#hard-rule-doku-disziplin).

### Welle 2 — der Wächter wird umgangen (`MR-005`)

**Beobachtung.** Zwei Wochen später, wieder dreimal:
`bash -c "pytest -q --lf"`. Die Befehlsposition ist `bash`, steht nicht
auf der Denylist, der Wächter winkt durch — CI wieder rot. Der Agent ist
dabei nicht böswillig; er hat die Blockade gelesen und einen Weg
gefunden, der formal nicht dagegen verstößt. Genau dafür ist die
Beobachtungs-Häufung da: der Umweg ist erst *nach* der Blockade
entstanden und war vorher nicht vorhersagbar.

**Die naheliegende falsche Reaktion.** `bash` auf die Denylist setzen.
Das blockiert jeden legitimen Shell-Aufruf — inklusive `make` selbst,
sobald es über eine Shell läuft. Der Stolperdraht wird zur Mauer, der
Agent kommt gar nicht mehr durch, und der Wächter wird nach dem dritten
Fehlalarm abgeschaltet. Ein **abgeschalteter Wächter ist schlechter als
ein löchriger**, weil die Doku ihn weiterhin behauptet.

**Die Härtung.** Der Guard packt Sub-Shells **rekursiv aus**: erkennt er
`bash`/`sh`/`zsh` mit einem `-c`-Flag — auch in kombinierter Form
(`-lc`, `-ec`, `-lec`) —, unterwirft er den String-Payload derselben
Befehlspositions-Prüfung. Mit **Tiefenlimit**; oberhalb des Limits wird
**blockiert, nicht durchgewunken** (Design-Eigenschaft *fail-closed*).
Die Denylist bleibt unverändert — geschärft wird die *Zerlegung*, nicht
die Liste.

**Landung: ein neuer Eintrag, keine Korrektur.**

```
### MR-005 — Befehls-Guard: Sub-Shell-Rekursion (schärft MR-004)

- **Datum:** 2026-03-19
- **Geltungsbereich:** `.claude/hooks/guard-bash.sh` (Guard aus MR-004)
- **Adaption:** Befehlspositionen werden zusätzlich *innerhalb* der
  `-c`-Payloads von `bash`/`sh`/`zsh` geprüft, inkl. kombinierter Flags
  (`-lc`, `-ec`, `-lec`); Rekursionstiefe 3, darüber fail-closed blockiert.
- **Begründung:** Drei Umgehungen in Folge (Lerneinträge slice-052/053/056)
  über `bash -c "pytest …"`. Die Denylist um `bash` zu erweitern wurde
  verworfen: sie blockiert legitime Shell-Arbeit inklusive `make`-Aufrufen.
- **Grenze:** unverändert Stolperdraht — `python -c "…"`, `env`-Umwege und
  selbstgeschriebene Wrapper-Skripte bleiben offen. Netz bleibt CI.
- **Auflösungs-Trigger:** permanent.
```

Warum nicht einfach `MR-004` nachbessern? Der Adaptions-Block ist
ADR-artig geführt: chronologisch nummeriert, **keine nachträglichen
inhaltlichen Änderungen an akzeptierten Einträgen**, nur neue Einträge
oder explizite Aufhebungen
([§harness/conventions.md als Konventionsspeicher](../grundlagen/harness-dateien.md#harnessconventionsmd-als-konventionsspeicher)).
Ein überschriebenes `MR-004` löscht die Information, *welche* Umgehung
den Wächter gehärtet hat — und damit die Begründung für die Rekursion.
Beim nächsten Aufräumen wirkt sie wie Overengineering und fliegt raus,
der Umweg kommt zurück, und die Beobachtungs-Zählung beginnt von vorn.

### Die Wellen in einer Tabelle

| Welle | Beobachtung (3×) | Reaktion *am Wächter* | Klasse | Landung |
|---|---|---|---|---|
| 1 | direkter `pytest`-Aufruf, CI rot | Befehlspositions-Denylist im `PreToolUse`-Hook | inferential → computational feedforward | `MR-004` + Grenz-Zeile |
| 2 | `bash -c "pytest …"` umgeht Welle 1 | rekursives Auspacken der `-c`-Payloads, fail-closed über Tiefenlimit | computational feedforward (geschärft) | `MR-005` (schärft `MR-004`) |
| 3 | *(noch nicht beobachtet)* | — | — | — |

Zeile 3 leer zu lassen ist die Pointe, nicht eine Lücke: die nächste
Welle wird **beobachtet, nicht geplant**. Wer heute schon `python -c`
mitprüft, ohne dass es je vorkam, baut gegen ein Phantom — eine Regel
ohne Sensor-Evidenz, die in sechs Monaten niemand mehr begründen kann
und die genau deshalb beim ersten Fehlalarm gestrichen wird.

### Drei Entgleisungen

1. **Welle 1 „gleich richtig" bauen wollen.** Statt der beobachteten
   Lücke wird ein Bedrohungsmodell abgearbeitet. Ergebnis: ein Wächter,
   der legitime Arbeit blockiert, bevor je eine Umgehung vorkam —
   Aufwand ohne Evidenz, und die Fehlalarm-Quote kostet den Wächter am
   Ende die Existenz.
2. **Die Härtung ohne `MR` landen.** Der Hook wird geschärft,
   `harness/conventions.md` bleibt auf dem Stand von Welle 1. Ab da
   beschreibt die Doku einen anderen Wächter als den, der läuft — Drift
   in genau der Richtung, die ein Doku-Konsistenz-Befund
   ([Modul 15](../05-betrieb/modul-15-observability.md)) später
   einsammeln muss.
3. **Die Grenz-Zeile nicht mitziehen.** Nach jeder Härtung verschiebt
   sich, was der Wächter *nicht* kann. Bleibt die alte Grenz-Zeile
   stehen, verspricht die Doku entweder zu wenig (dann wird der Wächter
   unterschätzt und dupliziert) oder zu viel (dann ist sie eine
   Harness-Lüge, siehe
   [`../grundlagen/durchsetzungsschicht.md` §Grenzen](../grundlagen/durchsetzungsschicht.md#grenzen--ehrlich-benannt)).

### Warum das in dieses Modul gehört

Ein Gate prüft ein **Ergebnis**, ein Wächter verhindert eine
**Handlung** — deshalb steht der Befehls-Guard bewusst nicht in
[§Gate-Typ ↔ Fehlerbild](#gate-typ--fehlerbild): er fängt kein
Fehlerbild, er nimmt einen Weg weg. Gemeinsam ist beiden der
Reifungs-Mechanismus: Beobachtung → Häufung → Sensor, und die
Härtung landet nachvollziehbar in einer ID. Wer nur Gates härtet und
den Wächter für fertig hält, hat den Steering-Loop halb verstanden —
**jede Komponente des Harness ist selbst Gegenstand des Harness.**

## Übungen

* Schreibe einen Architekturtest, der ADR-3 als Regel umsetzt
* Provoziere absichtlich einen Coverage-Gate-Failure auf einer kritischen Datei
* **(Erschaffen — aktiviert LZ "bootstrap-aware Gate entwerfen")** *Entwirf ein bootstrap-aware Gate von Grund auf.* Wähle eine Gate-Klasse, die in einem frühphasigen Repo zwingend rot wäre (Coverage, Mutation-Score, Lighthouse-Score, `noqa`-Count, Doku-Konsistenz). Liefere drei Artefakte: (a) Ein-Zeilen-Make-Target-Kommentar im Stil `gate-x: ## ... (bootstrap-aware, LH-FA-...).`, (b) eine **Hochschalt-Tabelle** mit mindestens drei Stufen (heute / Meilenstein M1 / Meilenstein M2) inkl. konkreter Schwellen und Hochschalt-*Trigger* (Trigger ist ein Ereignis im Repo, kein Datum), (c) eine Hard Rule, was geschieht, wenn der Trigger eintritt, aber die Schwelle nicht eingehalten wird (z. B. *"automatische Carveout-Eröffnung mit Folge-Slice"*). Anti-Antwort: *"40 % heute, 80 % später"* ohne Trigger — das ist nicht bootstrap-aware, sondern aufgeschoben.
* **(Analysieren)** *Schreibe Welle 3 des Befehls-Guards.* Nimm die offene Zeile aus [Worked Example B](#worked-example-b-guard-härtung-als-steering-loop-am-wächter) und **erfinde die Beobachtung nicht** — beschreibe stattdessen, welchen *Beleg* du bräuchtest, bevor du härtest (welche Notiz, wo, wie oft), und welche zwei Reaktionen du dann gegeneinander abwägen würdest. Nenne für die von dir gewählte Reaktion die neue Grenz-Zeile. Anti-Antwort: eine Härtung gegen `python -c` ohne Beleg — das ist Bedrohungsmodell, nicht Steering-Loop.

## Reflexion

Vier Standardfragen aus [`../grundlagen/reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md)
nach dem Architekturtest-Bau und dem provozierten Coverage-Failure.
Modul-spezifische Trigger:

- **Beobachtung:** Welche ADR-Aussage hattest du schwer in eine Fitness Function übersetzt? Welcher Coverage-Lauf war auf welchem kritischen Pfad rot?
- **2×2-Quadrant:** Gates sind *computational feedback*; bootstrap-aware Gates kombinieren mit Trigger-Disziplin (*inferential feedforward*).
- **Steering-Loop:** bootstrap-aware Gate dokumentieren? ID-Kommentar im Make-Target nachziehen? domänenspezifisches Gate (`test-determinism`, `noqa-gate`) einführen? Und die Rückfrage aus Worked Example B: hat einer deiner *Wächter* (Hook, Guard, Allowlist) in letzter Zeit eine Umgehung gesehen, die noch in keinem `MR-<NNN>` steht?
- **Conceptual Change:** Kandidaten in [`../grundlagen/lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "Gate = Lint", "Coverage 80 % ist die richtige Schwelle", "Mehr Tests sind immer besser").

## Selbstcheck

* **(Erinnern)** Nenne sechs generische Gate-Familien, die der Kurs als computational feedback einsetzt.
* Warum braucht es Critical Coverage zusätzlich zur Gesamt-Coverage?
* **(Bewerten — aktiviert LZ 2)** Dein Repo hat Critical Coverage 90 % und Gesamt-Coverage 70 %. Ein Teamkollege schlägt vor, beides anzuheben: Critical auf 100 %, Gesamt auf 85 %. Wäge beide Anhebungen einzeln gegen Risiko und Aufwand ab und begründe pro Schwelle, ob du sie übernimmst — und was die *Differenz* zwischen den beiden Schwellen überhaupt rechtfertigt.
* Welcher Gate-Typ erkennt eine SQL-Injection — Linter, Typecheck oder Security Gate?
* **(Analysieren — aktiviert LZ 5)** Ordne vier Fehlerbilder je einer Gate-Familie zu — Layer-Bruch (Domäne importiert Infrastruktur), Secret hartcodiert im Code, nicht-deterministischer Test, Coverage-Loch im Auth-Pfad — und begründe pro Zuordnung das *Unterscheidungs-Kriterium* (z. B. Datenfluss vs. lokale Mustererkennung vs. Struktur-Regel).
* **(Anwenden)** Du sollst einen neuen Gate (z. B. `coverage-gate-critical`) in deinem Repo einführen. Welche drei Vorbedingungen klärst du, *bevor* du das Target schreibst?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Sechs Gate-Familien? | vier oder weniger genannt | Linter · Typecheck · Architekturtest · Coverage · Critical Coverage · Security-Gate. Optional zusätzlich: Replay-/Determinism-Gates, Suppression-Gates, Dep-/Image-Audit. | + Hinweis: domänenspezifische Gates (z. B. `test-determinism`, `solid-suppression-gate`, `test-mpc-property`) entstehen aus dem Steering Loop, nicht aus einem Standard-Setup. Ein Repo mit nur den sechs generischen Gates hat noch keine Schmerzen verarbeitet. |
| Warum Critical Coverage *zusätzlich*? | "Wichtige Dateien besonders." | Gesamt-Coverage glättet kritische Pfade unter unkritischen Massendateien weg. Critical Coverage misst gezielt Pfade mit Sicherheits-, Geld- oder Datenintegritäts-Risiko. | + Folge: Critical Coverage hat *eigene* (höhere) Schwelle und *eigene* ADR-Kette für Schwellen-Senkung. Carveout auf Critical Coverage ist immer ein HIGH-Finding im Review. |
| Zwei Schwellen-Anhebungen abwägen (Critical 90→100, Gesamt 70→85)? | "Mehr Coverage ist immer besser" — beides übernommen, ohne Abwägung. | Pro Schwelle Risiko gegen Aufwand gestellt: Critical 90→100 ist begründbar, wenn der kritische Pfad klein und das Restrisiko (Sicherheit, Geld, Datenintegrität) hoch ist — die letzten 10 % sind dort Sensor, nicht Boilerplate. Gesamt 70→85 ist meist *nicht* begründbar: der Zugewinn liegt auf unkritischem Massencode (Verteilung vor Anzahl, siehe Fehlvorstellung "Mehr Tests sind immer besser"). Die Differenz rechtfertigt sich aus der Risiko-Klasse der Pfade, nicht aus Ehrgeiz. | + Konsequenz benannt: jede Schwellen-Änderung ist ADR-pflichtig ("Schwellen sind ADR-pflichtig"), und eine Anhebung ohne Hochschalt-Trigger ist dieselbe Disziplinlücke wie eine Senkung ohne Carveout. Grenzfall: 100 % Critical kann Tests erzwingen, die nur die Schwelle füttern — dann ist 90 % mit begründeter Lücken-Liste der ehrlichere Sensor. |
| SQL-Injection: Linter / Typecheck / Security Gate? | "Security Gate." | Security Gate (Semgrep/Bandit/CodeQL). Linter sieht den String, nicht die Semantik; Typecheck sieht den Typ `str`, nicht die Vertrauensgrenze. | + Hinweis: Manche Linter haben *Semgrep-Regeln* integriert (z. B. `bandit` für Python) — Trennlinie ist nicht "Tool", sondern "Regel-Klasse". Security-Regeln verlangen *Datenfluss*-Analyse, klassische Linter machen nur lokale Mustererkennung. |
| Vier Fehlerbilder den Gate-Familien zuordnen? | je Bild irgendein Gate genannt, ohne Kriterium | Layer-Bruch → Architekturtest (Struktur-/Import-Regel) · Secret im Code → Security-Gate (Muster-/Entropie-Scan) · nicht-deterministischer Test → Replay-/Determinism-Gate · Coverage-Loch im Auth-Pfad → Critical Coverage. | + Unterscheidungs-Kriterium pro Fall benannt: Security-Injection braucht *Datenfluss*-Analyse, Secret-Scan und Linter machen *lokale Mustererkennung*, Architekturtest prüft *Struktur*, Critical Coverage prüft *Pfad-Abdeckung* — Grenzfall: ein hartcodiertes Secret kann auch ein Linter-Regel-Treffer sein, Trennlinie ist Regel-Klasse, nicht Tool. |
| Drei Vorbedingungen für ein neues Gate? | "Tool installieren." | (1) Anforderung mit ID (Spec oder ADR), die das Gate prüft — sonst ist es ein Vorschlag · (2) Schwelle ist begründet (ADR oder Carveout für Übergangsphase) · (3) Lokales und CI-Image laufen identisch (Modul 14); andernfalls debuggt das Team später den Image-Unterschied. | + Empfohlen: Gate-Target trägt ID-Kommentar (`coverage-gate-critical: ## LH-QA-CRIT-003`); ohne diesen Kommentar ist die Traceability-Kette gebrochen, und ein gerötetes Gate erzeugt keinen klaren Bezug zur verletzten Anforderung. |

## Weiterlesen

* Wie *erzwungen* wird, dass die Gates wirklich liefen — das Handoff-Gate
  und der inhaltsbasierte Nachweis gegen die „ich hab die Gates laufen
  lassen"-Harness-Lüge:
  [`../grundlagen/durchsetzungsschicht.md`](../grundlagen/durchsetzungsschicht.md).
* Nächstes Modul: [Modul 14 — Docker Harness](../05-betrieb/modul-14-docker-harness.md)
