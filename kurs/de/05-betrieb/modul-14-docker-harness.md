# Modul 14 — Docker Harness

> **Aufwand:** ca. 60 Min Lesen · 90 Min Übung.

## Mini-Glossar für dieses Modul

Fünf neue Begriffe — Volldefinitionen in
[`../grundlagen/konventionen.md`](../grundlagen/konventionen.md#kernbegriffe).
Der Image-Hash wird hier in *Vollform* eingeführt (Vorgriff-Block in
[Modul 12](../04-qualitaet/modul-12-replay-evaluierung.md#begriff-image-hash-vorgriff-aus-modul-14) löst sich hier auf).

| Begriff | Ein-Satz-Definition | Bild im Kopf |
|---|---|---|
| **Multi-Stage-Dockerfile** | Dockerfile mit getrennten *Build-* und *Runtime-Stages*; der Runtime-Layer enthält nur, was die Anwendung braucht — nicht die Toolchain. | Bauphase und Bezugsphase eines Hauses; das Gerüst bleibt nicht im Wohnzimmer stehen. |
| **Image-Hash** | Byte-genaue Adresse eines Images (SHA-256), *unveränderlich* — anders als ein Tag wie `:latest`. | die Personalausweis-Nummer eines Images. Tag = Spitzname, Hash = Pass. |
| **Lock-File** | Vom Paketmanager generierte Datei mit *exakten* Versionen aller transitiven Abhängigkeiten. | das Inventarverzeichnis, das jeden Schraubentyp und seine Charge kennt. |
| **Devcontainer** | Standardisierte VS-Code-/IDE-Integration einer Container-Umgebung — pinnierte Entwicklungswerkzeuge pro Repo. | das Atelier, das mit dem Auftrag mitkommt, statt dass der Maler seines mitschleppt. |
| **Compose** | Multi-Container-Orchestrierung für lokale Stacks (Service + DB + Cache + …) per `docker-compose.yml`. | Bühnenbild mit mehreren Schauspielern, die zusammen auftreten müssen. |

## Engage

Ein neuer Teamkollege klont das Repo, tippt `make gates`, bekommt einen
Fehler. Vier Stunden später ist er noch nicht durch — falsche Java-Version,
falsches `npm`, fehlende Systembibliothek. *Wie viel kostet ein
unreproduzierbarer Harness in Personentagen pro Quartal?* Schnell drei,
selten weniger. Docker-only Harness ist nicht ein "ops topic" — es ist
die Versicherung gegen unreproduzierbaren Onboarding-Schmerz.

## Lernziele

Nach diesem Modul kannst du:

* einen Multi-Stage-Dockerfile für eine Toolchain *schreiben* (Erschaffen · prozedural),
* Image-Hash und Lock-Files als Reproduzierbarkeits-Anker *einsetzen* (Anwenden · prozedural),
* den Drift zwischen lokal und CI durch eine bewusst unpinnierte Base-Image *messen* (Analysieren · prozedural),
* Devcontainer und Compose-Setup gegeneinander *abwägen* (Bewerten · konzeptuell).

## Lab-Bezug

* Sprachskelett wählen: [`../../../lab/example/go/`](../../../lab/example/go/),
  [`../../../lab/example/python/`](../../../lab/example/python/),
  [`../../../lab/example/kotlin/`](../../../lab/example/kotlin/),
  [`../../../lab/example/java/`](../../../lab/example/java/) oder
  [`../../../lab/example/csharp/`](../../../lab/example/csharp/)
* `make build`, `make run` und `make gates` im gewählten Sprachskelett

## Themen

* Docker-only Entwicklung
* Multi-Stage Builds
* Reproduzierbare Toolchains
* Runtime-Smokes

## Kernidee

Wenn lokal und CI nicht dasselbe Image benutzen, debuggst du den
Unterschied, nicht den Bug.

## Typische Fehlvorstellungen

- **"FROM python:3 ist konkret genug."** — Nein. Ohne Digest (`FROM python:3.12.4-slim@sha256:…`) baust du jeden Monat einen anderen Container.
- **"Lock-Files sind nur für Python."** — Lock-Files gibt es für jede Sprache: `package-lock.json`, `go.sum`, `Cargo.lock`, `packages.lock.json` (mit Central Package Management, siehe `bess-ems`), `pnpm-lock.yaml`, `poetry.lock`. Wer ohne Lock-File baut, baut nicht reproduzierbar.
- **"Docker-only ist Overkill für Tools."** — Tools driften am schnellsten. Genau dort lohnt Docker am meisten.
- **"Devcontainer ersetzt Compose."** — Nein. Devcontainer ist für *Entwickler-IDE-Setup*, Compose für *Lauf- und CI-Vertrag*. Sie ergänzen sich.
- **"DevOps ist YAML schreiben — Container = Deployment."** — Verbreitet, weil Container historisch über die Deployment-Seite eingeführt wurden. In diesem Kurs ist der primäre Zweck eines Containers ein anderer: er ist **Reproduzierbarkeits-Anker** — derselbe Image-Hash garantiert dieselbe Toolchain auf jeder Maschine, im CI und in sechs Monaten. Deployment ist *eine* Anwendung dieses Ankers, nicht sein Hauptzweck. Bei einem Replay-Lauf gegen ein altes Golden Set ([Modul 12](../04-qualitaet/modul-12-replay-evaluierung.md)) brauchst du den *Image-Hash von damals*, nicht das aktuelle Deployment. Wer das Bild "Container = Auslieferung" pflegt, hat keinen Hebel für *time-travel reproducibility* — und damit kein belastbares Replay.

## Worked Example: vom einstufigen Dockerfile zur reproduzierbaren Multi-Stage-Pipeline

> **Wenn du Multi-Stage-Builds mit gepinnten Base-Digests, Lock-File-Stages und Distroless-Runtime routiniert baust, springe zu [§Übungen](#übungen).** Worked Example zeigt den Weg vom typischen "läuft bei mir"-Dockerfile zum CI-tauglichen Drei-Stufen-Aufbau; ist das Muster vertraut, kostet das Mitlesen Last (Expertise-Reversal).

**Ausgangs-Dockerfile (Python, Anti-Beispiel):**

```dockerfile
FROM python:3
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
CMD ["python", "-m", "docsearch"]
```

Vier Zeilen, vier Drift-Quellen: Tag `python:3` zeigt jeden Monat auf
ein anderes Image; `requirements.txt` ist nicht aufgelöst (transitive
Versionen frei); `pip install` ohne Cache-Trennung baut bei jedem Code-
Change die Dependencies neu; das Runtime-Image enthält den Build-Layer
mit Quellcode und Compiler-Toolchain. Sechs Schritte bringen das in
einen Multi-Stage-Build, der lokal und in CI denselben Image-Hash
produziert.

**Schritt 1 — Base-Image mit Digest pinnen.** Tag-Floating ist die
unsichtbarste Drift, weil sie nichts ändert *außer* dass das Image
neu ist. Lösung: SHA-256-Digest dazu.

```dockerfile
FROM python:3.12.4-slim@sha256:9c7f4a9d0c1b2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f AS deps
```

Der Digest wird beim ersten erfolgreichen Lokal-Build von
`docker buildx imagetools inspect python:3.12.4-slim` ausgelesen und
festgeschrieben. Update-Pfad: bei Sprach-/Sicherheits-Update Digest
*bewusst* anheben — ein Commit, der nur die Digest-Zeile ändert.

**Schritt 2 — Lock-File trennen und vor dem Code in den Build-Kontext
holen.** Damit Dependency-Installation cache-freundlich wird (sie läuft
neu *nur* wenn `pyproject.toml` / `poetry.lock` sich ändert, nicht bei
jedem Code-Change):

```dockerfile
FROM python:3.12.4-slim@sha256:9c7f4a... AS deps
WORKDIR /src
COPY pyproject.toml poetry.lock ./
RUN pip install --no-cache-dir uv==0.4.0 && \
    uv pip install --system --no-cache --frozen .
```

Drei Disziplinen in dieser Stage: (a) Installer-Version (`uv==0.4.0`)
selbst pinnen, sonst ist das Installations-Tool die zweite
Drift-Quelle; (b) `--frozen` verbietet, dass uv beim Build neue
Versionen auflöst — Lock-File entscheidet, nicht Build; (c) noch *kein*
Code im Image — Layer-Cache greift, solange Lock unverändert.

**Schritt 3 — Build-Stage separieren.** Code-Kompilierung gehört nicht
ins Runtime-Image; sie braucht aber die Dependencies aus Stage 1.

```dockerfile
FROM deps AS build
COPY . .
RUN python -m compileall src/
```

`FROM deps` referenziert die vorherige Stage — `build` erbt die
installierten Pakete, ohne sie neu zu installieren. `compileall`
ist hier symbolisch für jede Sprach-spezifische Build-Aktion
(Bytecode-Vorgenerierung, Asset-Build, Typ-Stubs). In Go wäre es
`go build`, in Java `mvn package`.

**Schritt 4 — Distroless-Runtime-Stage mit nonroot.** Das Runtime-Image
trägt nur das, was zur Laufzeit *gebraucht* wird — keine Shell, kein
Paketmanager, keine Build-Toolchain. Angriffsfläche minus ~90 %.

```dockerfile
FROM python:3.12.4-slim@sha256:9c7f4a... AS runtime
WORKDIR /app
COPY --from=build /src/src/docsearch /app/docsearch
COPY --from=build /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
RUN useradd --uid 65532 --no-create-home nonroot
USER nonroot
ENTRYPOINT ["python", "-m", "docsearch"]
```

Für Sprachen mit eigenständigem Binär-Output (Go, Rust, statisch
gelinkte JVM-AOT) ist die noch härtere Variante `gcr.io/distroless/static-debian12:nonroot`
ohne interpretierbares Runtime — siehe
[`../../../lab/example/go/Dockerfile`](../../../lab/example/go/Dockerfile)
als Vorbild.

**Schritt 5 — Image-Hash im Build-Output festhalten.** Damit das Image
in einem Replay-Manifest (Modul 12) referenzierbar wird:

```makefile
build:  ## LH-QA-03 — reproduzierbarer Build, Image-Hash erfasst
	docker buildx build \
		--platform linux/amd64 \
		--tag docsearch:welle-2 \
		--metadata-file build-metadata.json \
		--load .
	@jq -r '."containerimage.config.digest"' build-metadata.json > harness/image-hash.txt
	@cat harness/image-hash.txt
```

`build-metadata.json` enthält den exakten Manifest-Digest. Die
`harness/image-hash.txt` ist ein einzeiliges Beleg-Artefakt, das in
`harness/README.md` referenziert wird (siehe Vorlage in
[`/lab/templates/harness/README.template.md`](../../../lab/templates/harness/README.template.md)).
Ohne diesen Schritt ist das Replay-Manifest in Modul 12 zur Hälfte
blind — der `image_hash`-Slot bleibt unbelegt.

**Schritt 6 — Bewusstes Brechen: Drift provozieren.** Ändere in einer
Kopie *eine* Zeile zurück auf den unsicheren Stand und messe die
Wirkung:

| Änderung | Erwartete Beobachtung |
|---|---|
| Digest weglassen (`FROM python:3.12.4-slim`) | Image-Hash ändert sich beim nächsten Lokal-/CI-Build, obwohl kein Code-Diff vorliegt. |
| `--frozen` aus Schritt 2 entfernen | uv löst beim Build neue Patch-Versionen auf; Lock-File und Image divergieren stillschweigend. |
| `COPY . .` *vor* `COPY pyproject.toml ./` ziehen | Dependency-Stage wird bei jedem Code-Change rebuilt; Build-Zeit explodiert, Cache wirkt nicht. |

Erwartete Reflexion: *Welche der drei Drift-Klassen — Toolchain,
Dependency, Layer-Cache — hat dich überrascht?* Genau die Klasse, die
überrascht, ist deine Steering-Loop-Aktion (Image-Hash-Pflicht,
`--frozen`-Linter, Layer-Reihenfolge-Test).

Sechs Schritte, ein Image, drei Drift-Anker (Digest · Lock-File ·
Stage-Trennung). Vergleich:
[`../../../lab/example/python/Dockerfile`](../../../lab/example/python/Dockerfile)
und
[`../../../lab/example/go/Dockerfile`](../../../lab/example/go/Dockerfile)
— beide tragen den ID-Kommentar `LH-QA-03` im Header und folgen
demselben Drei-Stage-Schnitt mit sprach-spezifischen Anpassungen.

## Übungen

* Aufbau eines vollständigen Build-Harness
* Mache ein Image nicht-reproduzierbar (z. B. unpinnierte Base) und beobachte den Drift
* **Devcontainer-oder-Compose-Entscheidung** — aktiviert das Bewertungs-Lernziel
  (LZ 4) zur Setup-Abwägung. Drei Teams, je eine Ausgangslage. Entscheide
  pro Fall begründet, ob das Team (a) *nur* Compose, (b) Compose **plus**
  Devcontainer oder (c) *zuerst* Devcontainer braucht — und nenne pro Fall
  das ausschlaggebende Kriterium (Was ist CI-*Vertrag*, was ist
  Entwickler-*Komfort*?):

  | Fall | Ausgangslage | Entscheidung (a/b/c) + Kriterium |
  |---|---|---|
  | A | Solo-Repo, ein Entwickler, CI baut im Container, kein Onboarding absehbar. | … |
  | B | Fünf Entwickler, drei verschiedene IDEs, wiederkehrende "läuft bei mir"-Tickets beim Setup. | … |
  | C | Neues Team übernimmt ein Repo, das noch *keine* `docker-compose.yml` hat; niemand hat es je gebaut. | … |

  Nenne zum Schluss das *eine* Kriterium, das in allen drei Fällen den
  Ausschlag gibt, und grenze deine Entscheidung gegen das Anti-Muster aus
  den Typischen Fehlvorstellungen ab ("Devcontainer ersetzt Compose").
  Lösungshinweis: Compose ist der CI-Vertrag (Pflicht), Devcontainer ist
  IDE-Komfort (additiv) — Fall C baut zuerst den Vertrag, nie umgekehrt.

### Minimaler Übungspfad

```bash
cd lab/example/go
make build
make run
```

Erwartete Beobachtung: Build und Smoke laufen im Container-Kontext. Der
Fehlerfall entsteht, wenn du in einer Kopie die Base-Image-Version
unpinnst und den Build später erneut ausführst. Dokumentiere nicht nur
"rot/grün", sondern den Unterschied zwischen lokalem und CI-Vertrag.

> *Lab-Grenze:* Das Target ruft ein *fertiges* Multi-Stage-Dockerfile
> auf. Das LZ "Multi-Stage-Dockerfile *schreiben*" (LZ 1, Erschaffen)
> und das LZ "Drift *messen*" (LZ 3, Analysieren) werden erst durch das
> Worked Example oben (vom einstufigen zur Multi-Stage-Pipeline) und die
> Unpin-Übung in einer Kopie abgerufen — der minimale Pfad ist Aufwärm-,
> nicht Ziel-Niveau.

## Reflexion

Vier Standardfragen aus [`../grundlagen/reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md)
nach dem Build-Harness-Aufbau und dem provozierten Image-Drift.
Modul-spezifische Trigger:

- **Beobachtung:** Welche konkrete Toolchain-Version war anders zwischen lokal und CI? Hast du Image-Hash und Lock-File-Stand festgehalten?
- **2×2-Quadrant:** Image-Pinning ist *computational feedforward*; Hash-Vergleich im Replay-Manifest ist *computational feedback*.
- **Steering-Loop:** Image-Hash als Pflichtfeld in `harness/README.md` aufnehmen? Lock-File-Hash als Gate?
- **Conceptual Change:** Kandidaten in [`../grundlagen/lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "FROM python:3 ist konkret genug", "Docker-only ist Overkill für Tools", "Es läuft bei mir, das reicht").

## Selbstcheck

* **(Erinnern)** Nenne für drei verschiedene Sprachen je ein typisches Lock-File.
* **(Erinnern)** Welche zwei Artefakte sind die Mindestkombination für Reproduzierbarkeit eines Builds — und warum reicht keines davon allein?
* Warum ist `make gates` im Host-OS keine valide Gate-Ausführung?
* **(Analysieren — aktiviert LZ 3)** Gegeben ein einstufiges Dockerfile mit `FROM python:3` und `COPY . .` ganz oben: zerlege es in die drei Drift-Klassen (Toolchain, Dependency, Layer-Cache) — woran liegt welcher Drift — *und* benenne die drei Stage-Schnitte eines Multi-Stage-Builds (deps, build, runtime) mit Begründung, was jeder Schnitt gegen welche Drift-Klasse härtet.
* Wann lohnt sich ein Devcontainer zusätzlich zum Compose-Setup?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Drei Sprache↔Lock-File-Paare? | zwei genannt | Python: `poetry.lock` oder `uv.lock` · Node: `package-lock.json` oder `pnpm-lock.yaml` · Go: `go.sum` · .NET: `packages.lock.json` (mit Central Package Management, siehe `bess-ems`) · Rust: `Cargo.lock`. | + Pointe: Ein gepinnter Lock-File ist *nicht* ausreichend für Reproduzierbarkeit — er sichert Transitive-Versionen, aber nicht die Runtime-Version. Lock-File **plus** Image-Hash ist die Mindestkombination (siehe [Modul 12 §Image-Hash](../04-qualitaet/modul-12-replay-evaluierung.md#begriff-image-hash-vorgriff-aus-modul-14)). |
| Mindestkombination für Build-Reproduzierbarkeit? | "Docker." | Lock-File (sichert Abhängigkeits-Versionen) + Image-Hash (sichert Runtime-/Toolchain-Version). Ohne Lock-File driftet das Dependency-Tree, ohne Image-Hash driftet die Sprach-/Tool-Version. | + Folge: ein Replay-Manifest (Modul 12) referenziert *beide* — ohne Image-Hash lässt sich Modell-Drift nicht von Toolchain-Drift trennen; ohne Lock-File-Hash nicht von Dependency-Drift. Drei Drift-Quellen, drei Anker. |
| Warum reicht `make gates` im Host-OS nicht? | "Andere Umgebung." | Host-Toolchain ist nicht versionsgleich mit CI; Gate-Ergebnisse divergieren; Debugging erfolgt am Unterschied, nicht am Bug. | + Konsequenz: ohne Image-Hash-Vertrag zwischen lokal und CI sind grüne lokale Gates *kein* Vertrag — sie sind eine private Information. |
| Einstufiges Dockerfile in Drift-Klassen + Stage-Schnitte zerlegen? | "Stages aufteilen." | Drift benannt: `FROM python:3` ⇒ Toolchain-Drift (Tag floatet, kein Digest); fehlendes `--frozen`/Lock-File ⇒ Dependency-Drift; `COPY . .` vor `pyproject.toml` ⇒ Layer-Cache-Drift (Cache invalidiert bei jedem Code-Change). | + Drei Stage-Schnitte mit Härtung: **deps** (gepinnte Base + Lock-File-Install gegen Toolchain-/Dependency-Drift) · **build** (`FROM deps`, Code-Kompilierung getrennt vom Cache-sensiblen Layer) · **runtime** (Distroless/nonroot, nur Artefakte kopiert — kleinere Angriffsfläche, kein Build-Layer im Image). Image-Hash macht den Schnitt erst messbar. |
| Devcontainer zusätzlich zu Compose? | "Wenn man möchte." | Devcontainer für IDE-Setup (Sprache-Server, Debugger-Anschluss). Compose für Lauf- und CI-Vertrag. Beides parallel, wenn das Team mehrere IDEs nutzt. | + Faustregel: Compose ist *Pflicht* (CI-Vertrag), Devcontainer ist *Komfort*. Wer mit Devcontainer beginnt, baut sich eine zweite Toolchain ohne die erste. |

## Weiterlesen

* Docker-only als Hard Rule mit Falsch/Richtig-Beispiel: [Modul 9](../03-agenten/modul-09-implementierung.md)
* Nächstes Modul: [Modul 15 — Observability](modul-15-observability.md)
