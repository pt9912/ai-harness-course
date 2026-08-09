# DocSearch Java-Skelett — Makefile

IMAGE := docsearch-java
DOCKER := docker
MVN_IMAGE := maven:3.9-eclipse-temurin-21-alpine

.PHONY: help build run lint typecheck arch-check test test-determinism \
        coverage-gate coverage-gate-critical gates ci fullbuild clean

# `-h`: MAKEFILE_LIST trägt mehrere Dateien, und grep stellt dann jeder
# Zeile den Dateinamen voran — er verdrängt den Target-Namen.
help: ## Targets anzeigen
	@grep -hE '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-28s %s\n", $$1, $$2}'

# Zweites Layering-Gate (ADR-0015). `a-check.mk` ist tool-generiert
# (`a-check --print-mk`), die Regeln stehen in `.a-check.yml` — beide nicht
# im Recipe. Die Setzung vor dem `include` sticht das `?=` im Fragment;
# gepinnt ist v0.16.0, der geprüfte Stand. Anheben ist ein eigener Commit.
# Der `include` steht hinter `help`, weil das erste gelesene Target das
# Default-Goal ist — davor gelesen, startet ein blankes `make` das Gate.
A_CHECK_IMAGE := ghcr.io/pt9912/a-check@sha256:aef28cfe25bb054b1b0eb28420222a45b9f6ce9425b7ffd0f55e6ae56f295b56
include a-check.mk

build: ## Image bauen
	$(DOCKER) build -t $(IMAGE):latest .

run: build
	$(DOCKER) run --rm $(IMAGE):latest --help

lint: ## Checkstyle
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(MVN_IMAGE) \
		mvn -q checkstyle:check

typecheck: ## javac
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(MVN_IMAGE) \
		mvn -q compile

# Beide Sensoren laufen, auch wenn der erste rot ist: ADR-0015 laesst die
# beiden Befund-Mengen vergleichen, und ein Abbruch nach dem ersten zeigt
# immer nur eine.
arch-check: ## ADR-0001 Layering — zwei Sensoren: a-check (Konfiguration) + ArchUnit (Test-Framework)
	@rc=0; $(MAKE) --no-print-directory a-check || rc=1; \
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(MVN_IMAGE) \
		mvn -q test -Dtest=ArchitectureTest || rc=1; \
	exit $$rc

test:
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(MVN_IMAGE) \
		mvn -q test

test-determinism: ## LH-QA-02: @RepeatedTest(100) in DeterminismTest
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(MVN_IMAGE) \
		mvn -q test -Dtest=DeterminismTest

coverage-gate: ## Gesamt-Coverage via JaCoCo (ADR-0013, bootstrap-aware: 70 %, Hochschalt-Trigger M2 (welle-2 geschlossen) -> 80 % via Nachfolge-ADR)
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(MVN_IMAGE) \
		mvn -q verify

coverage-gate-critical: ## Critical Coverage (ADR-0013: 90 %; CO-001: Index-Layer ausgenommen)
	@echo "Critical coverage — CO-001 (index) ausgenommen"
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(MVN_IMAGE) \
		mvn -q verify -Pcritical-coverage

gates: lint typecheck arch-check test coverage-gate
	@echo "gates grün."

ci: gates test-determinism coverage-gate-critical
	@echo "ci grün."

fullbuild: ci build
	@echo "fullbuild grün."

clean:
	-rm -rf target
	-$(DOCKER) image rm $(IMAGE):latest
