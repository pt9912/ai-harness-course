# DocSearch Kotlin-Skelett — Makefile
# Docker-only. Gradle im Container.

IMAGE := docsearch-kotlin
DOCKER := docker
GRADLE_IMAGE := gradle:8.10-jdk21

.PHONY: help build run lint typecheck arch-check test test-determinism \
        coverage-gate coverage-gate-critical gates ci fullbuild clean

# `-h`: MAKEFILE_LIST trägt mehrere Dateien, und grep stellt dann jeder
# Zeile den Dateinamen voran — er verdrängt den Target-Namen.
help: ## Targets anzeigen
	@grep -hE '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-28s %s\n", $$1, $$2}'

# Zweites Layering-Gate (ADR-0016). `a-check.mk` ist tool-generiert
# (`a-check --print-mk`), die Regeln stehen in `.a-check.yml` — beide nicht
# im Recipe. Die Setzung vor dem `include` sticht das `?=` im Fragment;
# gepinnt ist v0.16.0, der geprüfte Stand. Anheben ist ein eigener Commit.
# Der `include` steht hinter `help`, weil das erste gelesene Target das
# Default-Goal ist — davor gelesen, startet ein blankes `make` das Gate.
A_CHECK_IMAGE := ghcr.io/pt9912/a-check@sha256:aef28cfe25bb054b1b0eb28420222a45b9f6ce9425b7ffd0f55e6ae56f295b56
include a-check.mk

build: ## Image bauen
	$(DOCKER) build -t $(IMAGE):latest .

run: build ## Smoke: --help
	$(DOCKER) run --rm $(IMAGE):latest --help

lint: ## detekt
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(GRADLE_IMAGE) gradle detekt

typecheck: ## Kotlin-Compiler
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(GRADLE_IMAGE) gradle compileKotlin compileTestKotlin

# Beide Sensoren laufen, auch wenn der erste rot ist: ADR-0016 laesst die
# beiden Befund-Mengen vergleichen, und ein Abbruch nach dem ersten zeigt
# immer nur eine.
arch-check: ## ADR-0001 Layering — zwei Sensoren: a-check (Konfiguration) + Konsist (Test-Framework)
	@rc=0; $(MAKE) --no-print-directory a-check || rc=1; \
	$(DOCKER) run --rm --tmpfs /src/.git -v "$$(pwd)":/src -w /src $(GRADLE_IMAGE) \
		sh -c 'git init -q /src >/dev/null 2>&1; gradle test --tests "com.example.docsearch.ArchitectureTest"' || rc=1; \
	exit $$rc

test: ## JUnit-Tests
	$(DOCKER) run --rm --tmpfs /src/.git -v "$$(pwd)":/src -w /src $(GRADLE_IMAGE) \
		sh -c 'git init -q /src >/dev/null 2>&1; gradle test'

test-determinism: ## LH-QA-02 100 Iter
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(GRADLE_IMAGE) \
		gradle test --tests "com.example.docsearch.DeterminismTest" \
		-Pdeterminism.iterations=100

coverage-gate: ## Gesamt-Coverage via kover (ADR-0013, bootstrap-aware: 70 %, Hochschalt-Trigger M2 (welle-2 geschlossen) -> 80 % via Nachfolge-ADR)
	$(DOCKER) run --rm --tmpfs /src/.git -v "$$(pwd)":/src -w /src $(GRADLE_IMAGE) \
		sh -c 'git init -q /src >/dev/null 2>&1; gradle koverVerify'

coverage-gate-critical: ## Critical Coverage (ADR-0013: 90 %; CO-001: Index-Layer ausgenommen)
	@echo "Critical coverage — CO-001 (index) ausgenommen"
	$(DOCKER) run --rm --tmpfs /src/.git -v "$$(pwd)":/src -w /src $(GRADLE_IMAGE) \
		sh -c 'git init -q /src >/dev/null 2>&1; gradle koverVerify -Pcritical=true'

gates: lint typecheck arch-check test coverage-gate
	@echo "gates grün."

ci: gates test-determinism coverage-gate-critical
	@echo "ci grün."

fullbuild: ci build
	@echo "fullbuild grün."

clean:
	-rm -rf build .gradle
	-$(DOCKER) image rm $(IMAGE):latest
