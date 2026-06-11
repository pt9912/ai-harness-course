# Lösung — Modul 13: Quality Gates

Zugehöriges Modul: [Modul 13 — Quality Gates](../04-qualitaet/modul-13-quality-gates.md).

## Selbstcheck-Antworten

### (Erinnern) Nenne sechs generische Gate-Familien

1. **Linter** — Stil und lokale Mustererkennung.
2. **Typecheck** — Statische Typen, Compiler-Schicht.
3. **Architekturtest** — Schichtungs- und Import-Regeln (`arch-check`).
4. **Coverage** — Test-Abdeckung (Gesamt-Durchschnitt).
5. **Critical Coverage** — gezielte Abdeckung der Risiko-Pfade, mit
   *eigener* (höherer) Schwelle und eigener ADR-Kette. Eigene Familie,
   nicht bloß eine Coverage-Variante — siehe nächste Selbstcheck-Frage.
6. **Security-Gate** — Datenfluss- und Vulnerability-Analyse (Semgrep,
   CodeQL, Bandit).

Über die sechs hinaus wachsen *domänenspezifische* Gates aus dem
Steering Loop heraus (siehe Modul 13 §"Reichhaltige Gate-Landschaft"):
`test-determinism`, `test-replay`, `solid-suppression-gate`,
`test-mpc-property`, `native-sanitizer`. Diese sind nicht Standard,
sondern aus konkreten Vorfällen entstanden.

Faustregel: Ein Repo mit nur den sechs generischen Gates hat noch keine
Schmerzen verarbeitet. Es ist kein schlechtes Repo — aber es hat keine
*spezifische* Steering-Loop-Historie.

### Warum braucht es Critical Coverage zusätzlich zur Gesamt-Coverage?

Gesamt-Coverage ist ein Durchschnitt — sie ist über alle Dateien
gleichgewichtet, auch wenn 90 % der Codebase Beispiel-Daten oder
DTOs sind. Das verbirgt zwei Pathologien:

1. **Sicherheitsrelevanter Code mit niedriger Coverage neben Daten-Klassen mit 100 %.** Der Durchschnitt sieht gut aus, der kritische Pfad ist ungetestet.
2. **Coverage-Manipulation durch Trivialität.** Wer 100 Getter testet, kompensiert für ungeprüfte Geschäftslogik.

Critical Coverage schneidet aus: definierte Pfade (z. B. `auth/`,
`payment/`, `optimizer/`) müssen *einzeln* eine höhere Schwelle
erfüllen. Damit wird:

- Gesamt-Coverage zur *Gesundheits-Metrik* (langsame Drift),
- Critical Coverage zum *Vertragspunkt* (harte Schwelle, fail-closed),
- Carveouts pro kritischen Pfad sichtbar (mit Trigger und Folge-Slice).

### (Bewerten — aktiviert LZ 2) Schwellen-Anhebung abwägen: Critical 90→100, Gesamt 70→85

Beide Anhebungen *einzeln* gegen Risiko und Aufwand stellen — "mehr
ist besser" ist keine Abwägung:

- **Critical 90 → 100: begründbar — unter Bedingungen.** Der kritische
  Pfad ist per Definition klein und trägt Sicherheits-, Geld- oder
  Datenintegritäts-Risiko; die letzten 10 % sind dort *Sensor*, nicht
  Boilerplate — genau die 10 % enthalten oft den Fehlerpfad, den
  niemand testen wollte. Aufwand: überschaubar, weil der Pfad-Umfang
  klein ist. **Aber** mit Grenzfall: 100 % kann Tests erzwingen, die
  nur die Schwelle füttern (Getter-Tests auf dem Auth-Modul). Dann
  ist 90 % mit *begründeter Lücken-Liste* der ehrlichere Sensor.
- **Gesamt 70 → 85: meist *nicht* begründbar.** Der Zugewinn liegt
  fast vollständig auf unkritischem Massencode (DTOs, Glue) —
  *Verteilung vor Anzahl* (Fehlvorstellung "Mehr Tests sind immer
  besser"). Aufwand: hoch, Risiko-Reduktion: minimal. Die
  Gesundheits-Metrik wird dadurch nicht gesünder, nur teurer — und
  sie lädt zu Coverage-Manipulation durch Trivial-Tests ein.

Was die *Differenz* zwischen den Schwellen rechtfertigt: die
**Risiko-Klasse der Pfade**, nicht Ehrgeiz. Critical Coverage ist
Vertragspunkt (fail-closed), Gesamt-Coverage ist Drift-Metrik — zwei
verschiedene Instrumente, daher legitim zwei verschiedene Zahlen.

Konsequenz in beide Richtungen: jede Schwellen-Änderung ist
**ADR-pflichtig** — auch die Anhebung. Eine Anhebung ohne
Hochschalt-Trigger ist dieselbe Disziplinlücke wie eine Senkung ohne
Carveout: eine Zahl, die jemand nach Gefühl gesetzt hat und die unter
Druck wieder wandert.

### Welcher Gate-Typ erkennt eine SQL-Injection — Linter, Typecheck oder Security Gate?

Primär Security Gate (Semgrep, CodeQL, language-spezifische
SAST-Tools). Linter und Typecheck sehen meist nur Typen und Stil,
nicht Datenfluss.

Aber: Eine ADR mit "Alle DB-Zugriffe gehen über Repository-Klasse mit
parametrisierten Queries" plus depguard/import-linter, das direkte
SQL-String-Builds verbietet, ist die *präventive* Variante
(Computational + Feedforward). Das erste Gate, das anschlägt, ist dann
das Architektur-Gate — *vor* dem Security-Gate.

Faustregel: Wenn dein Security-Gate eine SQL-Injection im
Production-Code findet, war die Schichtung lückenhaft. Security-Gates
sollen Reste fangen, nicht das Hauptpensum tragen.

### (Analysieren — aktiviert LZ 5) Vier Fehlerbilder den Gate-Familien zuordnen

Zuordnung mit Unterscheidungs-Kriterium (die volle Tabelle steht in
Modul 13 §"Gate-Typ ↔ Fehlerbild"):

| Fehlerbild | Gate-Familie | Unterscheidungs-Kriterium |
|---|---|---|
| Layer-Bruch (Domäne importiert Infrastruktur) | **Architekturtest** | *Struktur-/Import-Regel* — prüfbar am statischen Abhängigkeits-Graph, kein Laufzeit-Verhalten nötig |
| Secret hartcodiert im Code | **Security-Gate** (Secret-/Entropie-Scan) | *lokale Muster-/Entropie-Erkennung* — der Treffer steht an einer Stelle im Code, kein Datenfluss nötig |
| nicht-deterministischer Test | **Replay-/Determinism-Gate** (`test-determinism`) | *Wiederholbarkeits-Prüfung* — erst der Vergleich zweier Läufe macht das Fehlerbild sichtbar, kein Einzel-Lauf-Sensor fängt es |
| Coverage-Loch im Auth-Pfad | **Critical Coverage** | *Pfad-Abdeckung* — Gesamt-Coverage glättet das Loch weg; nur das pfad-gezielte Gate sieht es |

Die Trennlinie ist die **Regel-Klasse, nicht das Tool**: eine
SQL-Injection braucht *Datenfluss*-Analyse (Security-Gate), ein
Secret-Scan und ein Linter machen *lokale Mustererkennung*, ein
Architekturtest prüft *Struktur*, Critical Coverage prüft
*Pfad-Abdeckung*.

Grenzfall, der das Kriterium testet: das hartcodierte Secret kann auch
ein Linter-Regel-Treffer sein (manche Linter bündeln Security-Regeln,
z. B. `bandit`). Das ist kein Widerspruch — die *Regel* bleibt eine
Security-Regel (Muster/Entropie), auch wenn sie im Linter-Binary
mitläuft. Wer nach Tool statt Regel-Klasse zuordnet, reagiert im
Steering Loop auf den nächsten wiederkehrenden Fehler mit dem falschen
Sensor.

### (Anwenden) Drei Vorbedingungen vor einem neuen Gate

Bevor du das Make-Target schreibst:

1. **Anforderungs- oder ADR-Bezug.** Welcher `LH-*`/`ADR-*` rechtfertigt
   das Gate? Ohne diesen Bezug ist es ein Vorschlag, kein Vertrag. Das
   Make-Target trägt die ID im Kommentar: `coverage-gate-critical: ## LH-QA-CRIT-003 / ADR-0014`.
2. **Begründete Schwelle.** Die Zahl (40 %, 70 %, 90 %) braucht eine
   Begründung — entweder in einer ADR ("Sicherheits-Pfad: 90 % wegen
   LH-QA-SEC-001") oder als bootstrap-aware Stufung mit Trigger.
   Schwellen ohne Begründung wandern unter Druck nach unten.
3. **Lokal-CI-Parität.** Das Gate läuft in einem Image, dessen Hash
   lokal und im CI identisch ist (Modul 14). Andernfalls debuggst du
   *nicht* den Gate-Verstoß, sondern den Image-Unterschied — ein
   Tagesgeschäft, das niemand will.

Falle: "Tool installieren, ausführen, fertig". Ohne die drei
Vorbedingungen ist das Gate ein lokaler Verbesserungswunsch, der im
nächsten Repo-Refactor verschwindet. Mit den drei Vorbedingungen ist es
eine traceable Anforderung mit Sensor — und das ist genau die Bauart,
die der Kurs lehrt.

## Übungshinweise

### Schreibe einen Architekturtest, der ADR-3 als Regel umsetzt

Wenn ADR-3 z. B. besagt "Layer Service darf nur Repo importieren,
nicht Runtime", dann:

- **Go (depguard)**: `denyList: { "**/runtime/**": { "**/service/**" } }`.
- **Python (import-linter)**: `forbidden_modules = service` mit `from = runtime`.
- **Java/Kotlin (ArchUnit)**:
  ```
  noClasses().that().resideInAPackage("..service..")
    .should().dependOnClassesThat().resideInAPackage("..runtime..")
  ```

Erfolgskriterien:

- Test schlägt fehl, *bevor* du den Verstoß im Code einbaust (Vorab-Validierung).
- Test bricht `make arch-check` und damit `make gates` — nicht nur ein Warning.
- Test referenziert die ADR-ID im Kommentar.

### Provoziere absichtlich einen Coverage-Gate-Failure auf einer kritischen Datei

Vorgehen:

1. Lege eine neue Funktion in `optimizer/critical.go` (oder Äquivalent) ohne Test an.
2. Stelle sicher, dass `coverage-gate-critical` die Datei sieht.
3. Führe `make coverage-gate-critical` aus → muss rot werden.
4. Schreibe minimalen Test → grün.

Warum diese Übung wichtig ist: Sie validiert, dass dein
Critical-Coverage-Gate *funktioniert*. Häufiger Fehler: Gate ist
konfiguriert, aber Critical-Pfad ist im Glob falsch und matched
nichts — Gate ist also stumm.

### (Erschaffen — aktiviert LZ "bootstrap-aware Gate entwerfen") Bootstrap-aware Gate von Grund auf

Beispiel-Konstruktion für die Gate-Klasse **Doku-Konsistenz** (in
einem frühphasigen Repo zwingend rot: die Hälfte der Doku existiert
noch nicht). Die drei verlangten Artefakte:

**(a) Make-Target-Kommentar:**

```makefile
docs-consistency-gate: ## Doku-Konsistenz AGENTS.md/harness-README vs. Code (bootstrap-aware, LH-QA-DOC-004).
```

**(b) Hochschalt-Tabelle** — drei Stufen, Trigger als Repo-Ereignis,
nicht als Datum:

| Stufe | Schwelle | Hochschalt-Trigger |
|---|---|---|
| heute (Bootstrap) | nur *Existenz*-Checks: `harness/README.md` und `AGENTS.md` vorhanden, Sensors-Tabelle nicht leer | — |
| Meilenstein M1 | kein halluziniertes Gate: jedes in der Sensors-Tabelle gelistete Target existiert im Makefile | Trigger: erstes `make gates` läuft repo-weit grün (alle sechs generischen Gates aktiv) |
| Meilenstein M2 | Voll-Konsistenz: Doku-Konsistenz-Agent (Modul 15) meldet keine HIGH-Drift zwischen AGENTS.md, `harness/README.md` und realem Gate-Stand | Trigger: zehnter Slice in `done/` (genug Steering-Loop-Historie, dass Drift überhaupt entstehen kann) |

**(c) Hard Rule für den Konfliktfall** (Trigger eingetreten, Schwelle
nicht gehalten):

> Tritt der Hochschalt-Trigger ein und die nächste Stufe ist rot,
> wird **automatisch ein Carveout eröffnet** (`CO-NNN`, betroffenes
> Gate: `docs-consistency-gate`) mit Folge-Slice in `next/`, der die
> Lücke schließt. Das Gate bleibt auf der alten Stufe, *aber* der
> Carveout trägt den Trigger "Folge-Slice in `done/`" — die Stufe darf
> nicht still übersprungen oder der Trigger neu verhandelt werden.

Begründung der Konstruktion: Die Trigger sind *Ereignisse im Repo*
(erstes grünes `make gates`, zehnter Done-Slice), keine Daten — ein
Datum tritt auch ein, wenn das Repo sich nicht bewegt hat, und macht
die Stufe dann zur Lüge. Die Hard Rule in (c) verhindert die beiden
Entgleisungs-Pfade: stilles Hochschalten (Gate dauerhaft rot = kein
Gate mehr) und stilles Liegenbleiben (Stufung ohne Konsequenz =
permanenter Carveout in Tarnung).

Anti-Antwort: *"Existenz-Checks heute, Voll-Konsistenz später"* ohne
Trigger — das ist nicht bootstrap-aware, sondern aufgeschoben; es
fehlt genau das Element, das die Reifestufe terminiert.

- **Gate-Existenz wird mit Gate-Wirkung verwechselt.** `make coverage-gate` *gibt* es, aber prüft 0 %. → Halluzinations-Gate, siehe Disziplinregel aus Modul 13.
- **Schwelle in der Pipeline-YAML statt im Makefile.** → Lokales `make` und CI driften. Schwelle gehört dorthin, wo sie reproduzierbar gilt.
- **Bootstrap-aware-Marker fehlt.** → Wenn das Gate "aktuell 40 %" prüft, ohne den Trigger für "morgen 70 %" zu nennen, wird der Bootstrap zur permanenten Lüge.

## Verweise

- Reichhaltige Gate-Landschaft aus grid-gym: [Modul 13](../04-qualitaet/modul-13-quality-gates.md) und [Fallstudie](../grundlagen/fallstudien.md)
- Computational-Feedback-Quadrant: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)
- Vorherige Lösung: [Modul 12](modul-12-loesung.md)
- Nächste Lösung: [Modul 14](modul-14-loesung.md)
