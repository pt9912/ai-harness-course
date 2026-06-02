# Modul 13 — Docker Harness

> **Aufwand:** ca. 60 Min Lesen · 90 Min Übung.

## Engage

Ein neuer Teamkollege klont das Repo, tippt `make gates`, bekommt einen
Fehler. Vier Stunden später ist er noch nicht durch — falsche Java-Version,
falsches `npm`, fehlende Systembibliothek. *Wie viel kostet ein
unreproduzierbarer Harness in Personentagen pro Quartal?* Schnell drei,
selten weniger. Docker-only Harness ist nicht ein "ops topic" — es ist
die Versicherung gegen unreproduzierbaren Onboarding-Schmerz.

## Lernziele

Nach diesem Modul kannst du:

* einen Multi-Stage-Dockerfile für eine Toolchain *schreiben* (Erschaffen),
* Image-Hash und Lock-Files als Reproduzierbarkeits-Anker *einsetzen* (Anwenden),
* den Drift zwischen lokal und CI durch eine bewusst unpinnierte Base-Image *messen* (Analysieren),
* Devcontainer und Compose-Setup gegeneinander *abwägen* (Bewerten).

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

## Übungen

* Aufbau eines vollständigen Build-Harness
* Mache ein Image nicht-reproduzierbar (z. B. unpinnierte Base) und beobachte den Drift

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

## Reflexion

Nach dem Build-Harness-Aufbau und dem provozierten Image-Drift kurz **schriftlich**:

1. **Was ist beobachtbar passiert?** — Welche konkrete Toolchain-Version war anders zwischen lokal und CI? Hast du Image-Hash und Lock-File-Stand festgehalten?
2. **Welcher 2×2-Quadrant war Ursache?** — siehe [`konzeptkarte.md §2x2-Schnellanker`](../grundlagen/konzeptkarte.md#2x2-schnellanker). Image-Pinning ist *computational feedforward*; Hash-Vergleich im Replay-Manifest ist *computational feedback*.
3. **Welche konkrete Steering-Loop-Aktion folgt?** — Image-Hash als Pflichtfeld in `harness/README.md` aufnehmen? Lock-File-Hash als Gate?
4. **Welche eigene Vorstellung wurde unzufriedenstellend?** — Conceptual Change; Kandidaten in [`lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "FROM python:3 ist konkret genug", "Docker-only ist Overkill für Tools", "Es läuft bei mir, das reicht").

Eintragsformat, "Wann *nicht* reagieren" und Anti-Antworten: [`reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md).

## Selbstcheck

* **(Erinnern)** Nenne für drei verschiedene Sprachen je ein typisches Lock-File.
* Warum ist `make gates` im Host-OS keine valide Gate-Ausführung?
* Wann lohnt sich ein Devcontainer zusätzlich zum Compose-Setup?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Drei Sprache↔Lock-File-Paare? | zwei genannt | Python: `poetry.lock` oder `uv.lock` · Node: `package-lock.json` oder `pnpm-lock.yaml` · Go: `go.sum` · .NET: `packages.lock.json` (mit Central Package Management, siehe `bess-ems`) · Rust: `Cargo.lock`. | + Pointe: Ein gepinnter Lock-File ist *nicht* ausreichend für Reproduzierbarkeit — er sichert Transitive-Versionen, aber nicht die Runtime-Version. Lock-File **plus** Image-Hash ist die Mindestkombination (siehe [Modul 11 §Image-Hash](../04-qualitaet/modul-11-replay-evaluierung.md#begriff-image-hash-vorgriff-aus-modul-13)). |
| Warum reicht `make gates` im Host-OS nicht? | "Andere Umgebung." | Host-Toolchain ist nicht versionsgleich mit CI; Gate-Ergebnisse divergieren; Debugging erfolgt am Unterschied, nicht am Bug. | + Konsequenz: ohne Image-Hash-Vertrag zwischen lokal und CI sind grüne lokale Gates *kein* Vertrag — sie sind eine private Information. |
| Devcontainer zusätzlich zu Compose? | "Wenn man möchte." | Devcontainer für IDE-Setup (Sprache-Server, Debugger-Anschluss). Compose für Lauf- und CI-Vertrag. Beides parallel, wenn das Team mehrere IDEs nutzt. | + Faustregel: Compose ist *Pflicht* (CI-Vertrag), Devcontainer ist *Komfort*. Wer mit Devcontainer beginnt, baut sich eine zweite Toolchain ohne die erste. |

## Weiterlesen

* Docker-only als Hard Rule mit Falsch/Richtig-Beispiel: [Modul 8](../03-agenten/modul-08-implementierung.md)
* Nächstes Modul: [Modul 14 — Observability](modul-14-observability.md)
