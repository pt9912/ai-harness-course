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

* `Dockerfile`, `docker-compose.yml` im Begleit-Repo
* `make build`, `make run` (Smoke-Test)

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

Nach den Übungen: [Reflexionsvorlage](../grundlagen/reflexion-vorlage.md).

## Selbstcheck

* Warum ist `make gates` im Host-OS keine valide Gate-Ausführung?
* Wann lohnt sich ein Devcontainer zusätzlich zum Compose-Setup?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Warum reicht `make gates` im Host-OS nicht? | "Andere Umgebung." | Host-Toolchain ist nicht versionsgleich mit CI; Gate-Ergebnisse divergieren; Debugging erfolgt am Unterschied, nicht am Bug. | + Konsequenz: ohne Image-Hash-Vertrag zwischen lokal und CI sind grüne lokale Gates *kein* Vertrag — sie sind eine private Information. |
| Devcontainer zusätzlich zu Compose? | "Wenn man möchte." | Devcontainer für IDE-Setup (Sprache-Server, Debugger-Anschluss). Compose für Lauf- und CI-Vertrag. Beides parallel, wenn das Team mehrere IDEs nutzt. | + Faustregel: Compose ist *Pflicht* (CI-Vertrag), Devcontainer ist *Komfort*. Wer mit Devcontainer beginnt, baut sich eine zweite Toolchain ohne die erste. |

## Weiterlesen

* Docker-only als Hard Rule mit Falsch/Richtig-Beispiel: [Modul 8](../03-agenten/modul-08-implementierung.md)
* Nächstes Modul: [Modul 14 — Observability](modul-14-observability.md)
