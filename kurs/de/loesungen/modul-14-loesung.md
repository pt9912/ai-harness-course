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

### Warum ist `make gates` im Host-OS keine valide Gate-Ausführung?

Drei Gründe:

1. **Toolchain-Unterschied**: Lokal hast du Go 1.23, im CI läuft Go 1.21. Linter-Regeln und Compile-Verhalten unterscheiden sich subtil. Gate grün lokal, rot im CI — der Unterschied gehört nicht in den Bug.
2. **Abhängigkeits-Reihenfolge**: Host hat globale Pakete (Python, NodeJS), die der CI nicht hat. Importe können Lokal-Fallbacks nutzen, die im CI fehlen.
3. **Filesystem-Annahmen**: Host hat Dateien an Pfaden, die der CI nicht hat (`~/.config`, `/etc/foo`). Gate liest sie ungeprüft.

Wenn lokal und CI nicht *bit-identisch* dasselbe Image benutzen,
debuggst du den Unterschied, nicht den Bug. Docker-only ist nicht
Mode, sondern Kosten-Senkung.

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

### Aufbau eines vollständigen Build-Harness

Pflicht-Stages im Dockerfile:

1. **Toolchain-Stage**: Base-Image mit pinned Version, Compiler/Linter/Tools.
2. **Deps-Stage**: nur Lockfile + Lock-Resolution, vor dem Quellcode. Cache-freundlich.
3. **Build-Stage**: Quellcode + Compile.
4. **Test-Stage**: läuft `make test` (oder Äquivalent).
5. **Lint-Stage**: läuft Linter.
6. **Runtime-Stage** (Distroless oder JRE-minimal): nur das Binary plus minimale Laufzeit-Abhängigkeiten.

Cache-Strategie: Lockfile ändert sich selten → Stage 2 ist meist
cached. Quellcode ändert sich oft → Stage 3+4 wiederholen. Das spart
in einem typischen Repo 60-80 % Build-Zeit.

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

## Häufige Fehler

- **Multi-Stage ohne Cache-Trennung.** Dockerfile lädt Lockfile und Code im selben Layer. → Jede Code-Änderung triggert vollen Re-Download.
- **Runtime-Stage enthält Dev-Tools.** Distroless wird ignoriert, "weil debugging einfacher ist". → Angriffsfläche balloniert.
- **`make gates` startet kein eigenes Image, nutzt Host-Docker.** → Halber Schritt: Build im Container, Test am Host. Bringt die meisten Drift-Probleme zurück.

## Verweise

- Hard Rule "Docker-only" aus grid-gym: [Modul 9](../03-agenten/modul-09-implementierung.md) und [Fallstudien](../grundlagen/fallstudien.md)
- Vorherige Lösung: [Modul 13](modul-13-loesung.md)
- Nächste Lösung: [Modul 15](modul-15-loesung.md)
