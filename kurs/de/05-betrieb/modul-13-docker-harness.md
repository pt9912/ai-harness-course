# Modul 13 — Docker Harness

## Lernziele

* Einen Docker-only Build-Harness aufbauen
* Multi-Stage Builds für reproduzierbare Toolchains schreiben
* Runtime-Smokes als ersten Gate-Schritt einsetzen

## Lab-Bezug

* `Dockerfile`, `docker-compose.yml` im Begleit-Repo
* `make build`, `make shell`, `make smoke`

## Themen

* Docker-only Entwicklung
* Multi-Stage Builds
* Reproduzierbare Toolchains
* Runtime-Smokes

## Kernidee

Wenn lokal und CI nicht dasselbe Image benutzen, debuggst du den
Unterschied, nicht den Bug.

## Übungen

* Aufbau eines vollständigen Build-Harness
* Mache ein Image nicht-reproduzierbar (z. B. unpinnierte Base) und beobachte den Drift

## Selbstcheck

* Warum ist `make gates` im Host-OS keine valide Gate-Ausführung?
* Wann lohnt sich ein Devcontainer zusätzlich zum Compose-Setup?

## Weiterlesen

* Docker-only als Hard Rule mit Falsch/Richtig-Beispiel: [Modul 8](../03-agenten/modul-08-implementierung.md)
* Nächstes Modul: [Modul 14 — Observability](modul-14-observability.md)
