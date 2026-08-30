# DocSearch Kotlin-Skelett — Makefile
# Docker-only. Gradle im Container.

IMAGE := docsearch-kotlin
DOCKER := docker
GRADLE_IMAGE := gradle:8.10-jdk21
# Kein Bind-Mount: Die Quellen wandern beim Build ins Image, und weil Gradle
# seine Abhaengigkeiten dabei zieht, ist die Gate-Stage selbst das Gate
# (Modul 14 §Der Prueflauf ist hermetisch). Sichtbare Befunde holt
# `make export` aus den Beleg-Stages. Das `git init`, das Konsist braucht,
# passiert im Image — der `--tmpfs /src/.git`-Kniff und seine root-eigene
# Huelle im Arbeitsbaum entfallen.
GATES := docsearch-kotlin-gates
# `--no-cache-filter <stage>` fuehrt genau diese Stage neu aus, waehrend
# `repo` und die Werkzeug-Layer gecacht bleiben: Ein Gate urteilt so bei jedem
# Aufruf ueber den aktuellen Stand, statt ein gecachtes Gruen zu wiederholen.
# Und kein `-q`: Sonst zeigt ein roter Gate nur den Exit-Code, nicht die
# Befunde (Modul 13, Gate und Beleg).
GATE = $(DOCKER) build --no-cache-filter $(1) --target $(1) . >/dev/null


.PHONY: help build run lint typecheck arch-check test test-determinism \
        coverage-gate coverage-gate-critical gates ci fullbuild clean

# `-h`: MAKEFILE_LIST trägt mehrere Dateien, und grep stellt dann jeder
# Zeile den Dateinamen voran — er verdrängt den Target-Namen.
help: ## Targets anzeigen
	@grep -hE '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-28s %s\n", $$1, $$2}'

# Zweites Layering-Gate (ADR-0018). `a-check.mk` ist tool-generiert
# (`a-check --print-mk`), die Regeln stehen in `.a-check.yml` — beide nicht
# im Recipe. Die Setzung vor dem `include` sticht das `?=` im Fragment;
# gepinnt ist v0.17.0, der geprüfte Stand. Anheben ist ein eigener Commit.
# Der `include` steht hinter `help`, weil das erste gelesene Target das
# Default-Goal ist — davor gelesen, startet ein blankes `make` das Gate.
A_CHECK_IMAGE := ghcr.io/pt9912/a-check@sha256:665540114aea653effcc0e0c96ada6e8da2e7bfa867cade74d418d541af88dda
include a-check.mk

build: ## Image bauen
	$(DOCKER) build -t $(IMAGE):latest .

run: build ## Smoke: --help
	$(DOCKER) run --rm $(IMAGE):latest --help

lint: ## detekt
	$(call GATE,lint-gate)

typecheck: ## Kotlin-Compiler
	$(call GATE,typecheck-gate)

# Beide Sensoren laufen, auch wenn der erste rot ist: ADR-0018 laesst die
# beiden Befund-Mengen vergleichen, und ein Abbruch nach dem ersten zeigt
# immer nur eine.
arch-check: ## ADR-0001 Layering — zwei Sensoren: a-check (Konfiguration) + Konsist (Test-Framework)
	@rc=0; $(MAKE) --no-print-directory a-check || rc=1; \
	$(call GATE,arch-gate) || rc=1; \
	exit $$rc

test: ## JUnit-Tests
	$(call GATE,test-gate)

test-determinism: ## LH-QA-02 100 Iter
	$(call GATE,determinism-gate)

coverage-gate: ## Gesamt-Coverage via kover (ADR-0013, bootstrap-aware: 70 %, Hochschalt-Trigger M2 (welle-2 geschlossen) -> 80 % via Nachfolge-ADR)
	$(call GATE,coverage-gate)

coverage-gate-critical: ## Critical Coverage (ADR-0013: 90 %; CO-001: Index-Layer ausgenommen)
	@echo "Critical coverage — CO-001 (index) ausgenommen"
	$(call GATE,coverage-gate)

export: ## Belege der Beleg-Stages nach ./out holen (Rueckweg ohne Mount)
	$(DOCKER) build -q --target export -t $(GATES) . >/dev/null
	@mkdir -p out && $(DOCKER) run --rm --network none $(GATES) tar -cf - -C /out . | tar -xf - -C out
	@echo "-> ./out"

gates: lint typecheck arch-check test coverage-gate
	@echo "gates grün."

ci: gates test-determinism coverage-gate-critical
	@echo "ci grün."

fullbuild: ci build
	@echo "fullbuild grün."

clean:
	-rm -rf build .gradle
	-$(DOCKER) image rm $(IMAGE):latest
