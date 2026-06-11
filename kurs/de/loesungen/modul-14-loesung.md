# Lösung — Modul 14: Docker Harness

Zugehöriges Modul: [Modul 14 — Docker Harness](../05-betrieb/modul-14-docker-harness.md).

## Selbstcheck-Antworten

### (Erinnern) Nenne drei Sprache↔Lock-File-Paare

| Sprache | typisches Lock-File |
|---|---|
| Python | `poetry.lock` oder `uv.lock` |
| Node | `package-lock.json` oder `pnpm-lock.yaml` |
| Go | `go.sum` |
| .NET | `packages.lock.json` (mit Central Package Management) |
| Rust | `Cargo.lock` |
| Java/Maven | `pom.xml` mit pinned Versionen + (für reine Reproduzierbarkeit) `dependency-tree`-Snapshot |

Drei Beispiele genügen — kennt der Lerner *kein* Lock-File für die
Sprache seines Repos, fehlt eine zentrale Reproduzierbarkeits-Klammer.

Pointe: Ein gepinntes Lock-File ist *nicht* ausreichend für volle
Reproduzierbarkeit. Es sichert die *Bibliotheks-Versionen*, aber nicht
die *Runtime-Version* (Python 3.11 vs. 3.12, Go 1.21 vs. 1.23). Lock-File
**plus** Image-Hash ist die Mindestkombination. Genau diese Kombination
liefert das Bündel "byteidentische Toolchain", auf das Modul 12 sich für
deterministische Replays stützt.

### (Erinnern) Welche zwei Artefakte sind die Mindestkombination für Build-Reproduzierbarkeit?

1. **Lock-File** — sichert die exakten Versionen aller transitiven
   Abhängigkeiten.
2. **Image-Hash** (Digest, nicht Tag) — sichert Runtime- und
   Toolchain-Version byte-genau.

Warum keines allein reicht: Ohne Lock-File driftet der
Dependency-Tree (gleiche Toolchain, andere Bibliotheks-Patchlevel);
ohne Image-Hash driftet die Sprach-/Tool-Version (gleiches Lock-File,
anderer Compiler/Interpreter). Beide Drift-Quellen sind unabhängig —
deshalb braucht jede ihren eigenen Anker.

Folge für Modul 12: Ein Replay-Manifest referenziert *beide*. Ohne
Image-Hash lässt sich Modell-Drift nicht von Toolchain-Drift trennen,
ohne Lock-File-Stand nicht von Dependency-Drift.

### Warum ist `make gates` im Host-OS keine valide Gate-Ausführung?

Drei Gründe:

1. **Toolchain-Unterschied**: Lokal hast du Go 1.23, im CI läuft Go 1.21. Linter-Regeln und Compile-Verhalten unterscheiden sich subtil. Gate grün lokal, rot im CI — der Unterschied gehört nicht in den Bug.
2. **Abhängigkeits-Reihenfolge**: Host hat globale Pakete (Python, NodeJS), die der CI nicht hat. Importe können Lokal-Fallbacks nutzen, die im CI fehlen.
3. **Filesystem-Annahmen**: Host hat Dateien an Pfaden, die der CI nicht hat (`~/.config`, `/etc/foo`). Gate liest sie ungeprüft.

Wenn lokal und CI nicht *bit-identisch* dasselbe Image benutzen,
debuggst du den Unterschied, nicht den Bug. Docker-only ist nicht
Mode, sondern Kosten-Senkung.

### (Analysieren — aktiviert LZ 3) Einstufiges Dockerfile in Drift-Klassen zerlegen + Stage-Schnitte begründen

Gegeben: `FROM python:3` und `COPY . .` ganz oben. Die drei
Drift-Klassen, jeweils an der verursachenden Zeile festgemacht:

| Drift-Klasse | Verursacher im Dockerfile | Mechanismus |
|---|---|---|
| **Toolchain-Drift** | `FROM python:3` (Tag ohne Digest) | Der Tag floatet — jeden Monat zeigt er auf ein anderes Image; Python-Minor, System-Libs und Linter-Verhalten ändern sich ohne Code-Diff. |
| **Dependency-Drift** | `pip install -r requirements.txt` ohne Lock-File/`--frozen` | Transitive Versionen werden beim *Build* aufgelöst, nicht beim *Commit* — zwei Builds desselben Stands installieren verschiedene Patchlevel. |
| **Layer-Cache-Drift** | `COPY . .` *vor* der Dependency-Installation | Jeder Code-Change invalidiert den Dependency-Layer; der Build wird langsam *und* die Installations-Auflösung läuft bei jedem Build neu (verstärkt Dependency-Drift). |

Die drei Stage-Schnitte des Multi-Stage-Builds (Benennung wie im
Worked Example: **deps · build · runtime**) und was jeder gegen
welche Klasse härtet:

1. **deps** — gepinnte Base (Digest) + Lock-File-Kopie *vor* dem
   Install + `--frozen`: härtet gegen Toolchain-Drift (Digest) und
   Dependency-Drift (Lock entscheidet, nicht Build); weil noch kein
   Code im Layer liegt, greift der Cache, solange das Lock unverändert
   ist — das nimmt auch der Layer-Cache-Drift die Wirkung.
2. **build** — `FROM deps`, erst hier `COPY . .` und Kompilierung:
   trennt den volatil-Code-Layer vom cache-sensiblen Dependency-Layer
   (Layer-Cache-Drift) und hält die Build-Toolchain aus dem
   Runtime-Image heraus.
3. **runtime** — Distroless/nonroot, nur Artefakte per `COPY --from=build`:
   kein Compiler, keine Shell im Image — kleinere Angriffsfläche, und
   das Laufzeit-Image ist über seinen Hash als Replay-Anker
   referenzierbar (Modul 12).

Erst der Image-Hash macht den Schnitt *messbar*: ohne festgehaltenen
Digest lässt sich nicht belegen, dass zwei Builds dasselbe Image
ergaben.

### Wann lohnt sich ein Devcontainer zusätzlich zum Compose-Setup?

Wenn der primäre Entwicklungs-Pfad eines Repos *interaktives Arbeiten
im selben Image* ist, das auch der CI benutzt — und nicht "Code lokal
schreiben, dann Container für Tests".

Konkrete Trigger:

- Mehrere Sprachen im selben Repo (z. B. `c-hsm-doc` mit Go + Java/Kotlin-Demos).
- Tool-spezifische Sub-Setups, die einrichtungsschwer sind (PKCS#11-Slots, SoftHSM-Init).
- Team-Größe > 2: das "läuft auf meiner Maschine" sich häuft.

Wenn `make build && make shell` reicht (siehe grid-gym), brauchst du
keinen Devcontainer — das ist Kosten ohne Nutzen. Devcontainer wird
wertvoll, wenn IDE-Integration (LSP, Debugger) im Container nötig
ist.

## Übungshinweise

### (Erschaffen — aktiviert LZ 1) Multi-Stage-Dockerfile von Grund auf schreiben

Pflicht sind die **drei Stages aus dem Worked Example** — gleiche
Benennung, damit keine dritte Taxonomie entsteht:

1. **deps** — gepinnte Base (Digest, nicht `:latest`), Lock-File-Kopie
   *vor* dem Dependency-Install, Installer-Version selbst gepinnt,
   `--frozen`-Disziplin. Noch kein Quellcode im Layer.
2. **build** — `FROM deps`, Quellcode + Compile (sprach-spezifisch:
   `go build`, `mvn package`, `compileall`).
3. **runtime** — Distroless oder Minimal-Base mit nonroot; nur
   Artefakte per `COPY --from=build`, keine Build-Tools.

Optional als vierte Stage: **test** — lässt die Gates im Build-Kontext
laufen (`make test`/`make lint` gegen die build-Stage).

Erweiterte Variante (kein Pflicht-Schema): In großen Repos wird die
Drei-Stage-Struktur weiter aufgefächert — deps zerfällt in
Toolchain- und Lock-Resolution-Stage, test in Test- und Lint-Stage.
Das sind *Verfeinerungen innerhalb* von deps · build · runtime (+ test),
keine eigene Taxonomie: jede Zusatz-Stage lässt sich einem der vier
Schnitte zuordnen.

Cache-Strategie: Lock-File ändert sich selten → deps-Stage ist meist
cached. Quellcode ändert sich oft → build/test wiederholen. Das spart
in einem typischen Repo 60-80 % Build-Zeit.

Abnahme-Test aus der Übung: `docker build` läuft durch, *und* das
Runtime-Image enthält keine Build-Tools mehr — `which gcc`/`go`/`mvn`
schlägt fehl (bei Distroless schlägt schon das Shell-Spawnen fehl,
was dasselbe belegt). Wichtig: aus dem leeren File schreiben, nicht
das Worked-Example-Dockerfile kopieren — das Nachbauen ist Verstehen,
das Selbst-Schreiben ist das Erschaffen-Ziel.

### Mache ein Image nicht-reproduzierbar und beobachte den Drift

Trigger:

- `FROM golang:latest` statt `golang:1.23.4`.
- `apt-get install` ohne pinned Versionen.
- `go install github.com/...@latest`.

Erwartetes Symptom: Zwei Builds an verschiedenen Tagen erzeugen
Binaries unterschiedlicher Größe / unterschiedlicher SHA. CI grün,
Production-Bug — und niemand kann den ursprünglichen Stand rekonstruieren.

Lehrwert: Drift ist nicht etwas, das *manchmal* passiert. Es passiert
*immer*, du siehst es nur nicht, bis es wehtut.

### (Bewerten — aktiviert LZ 4) Devcontainer-oder-Compose-Entscheidung — drei Fälle

| Fall | Ausgangslage | Entscheidung + Kriterium |
|---|---|---|
| **A** | Solo-Repo, ein Entwickler, CI baut im Container, kein Onboarding absehbar | **(a) nur Compose.** Der CI-Vertrag existiert und genügt; ein Devcontainer wäre IDE-Komfort für ein Onboarding, das nicht stattfindet — Kosten ohne Nutzen (zweite Konfiguration, die mitgepflegt werden muss). |
| **B** | Fünf Entwickler, drei IDEs, wiederkehrende "läuft bei mir"-Tickets beim Setup | **(b) Compose plus Devcontainer.** Der Vertrag (Compose) bleibt die Basis; die Tickets sind das Symptom divergierender *Entwickler-Umgebungen* — genau das Problem, das der Devcontainer löst: pinnierte Werkzeuge, LSP/Debugger im selben Image, IDE-übergreifend. |
| **C** | Neues Team übernimmt ein Repo ohne `docker-compose.yml`; niemand hat es je gebaut | **(a) zuerst nur Compose** — *nie* (c). Es gibt noch keinen Lauf-/CI-Vertrag; einen Devcontainer zuerst zu bauen hieße, eine zweite Toolchain zu errichten, bevor die erste existiert. Erst wenn `make build`/`make gates` im Compose-Kontext reproduzierbar laufen, ist Devcontainer-Komfort eine legitime zweite Schicht. |

Das *eine* Kriterium, das in allen drei Fällen den Ausschlag gibt:
**Was ist CI-Vertrag, was ist Entwickler-Komfort?** Compose ist der
Vertrag (Pflicht — lokal und CI laufen im selben Stack), Devcontainer
ist Komfort (additiv — lohnt, wenn IDE-Integration im Container
gebraucht wird).

Abgrenzung gegen das Anti-Muster aus den Typischen Fehlvorstellungen
("Devcontainer ersetzt Compose"): Die beiden beantworten verschiedene
Fragen — Devcontainer: *womit entwickle ich?*, Compose: *worin läuft
und prüft es?*. Wer den Devcontainer als Ersatz nimmt, hat eine
Umgebung, in der Entwickler arbeiten, aber keine, gegen die CI und
Replay verlässlich laufen — der Vertrag fehlt, der Komfort bleibt.

- **Multi-Stage ohne Cache-Trennung.** Dockerfile lädt Lockfile und Code im selben Layer. → Jede Code-Änderung triggert vollen Re-Download.
- **Runtime-Stage enthält Dev-Tools.** Distroless wird ignoriert, "weil debugging einfacher ist". → Angriffsfläche balloniert.
- **`make gates` startet kein eigenes Image, nutzt Host-Docker.** → Halber Schritt: Build im Container, Test am Host. Bringt die meisten Drift-Probleme zurück.

## Verweise

- Hard Rule "Docker-only" aus grid-gym: [Modul 9](../03-agenten/modul-09-implementierung.md) und [Fallstudien](../grundlagen/fallstudien.md)
- Vorherige Lösung: [Modul 13](modul-13-loesung.md)
- Nächste Lösung: [Modul 15](modul-15-loesung.md)
