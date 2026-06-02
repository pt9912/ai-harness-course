# DocSearch Java-Skelett — Makefile

IMAGE := docsearch-java
DOCKER := docker
MVN_IMAGE := maven:3.9-eclipse-temurin-21-alpine

.PHONY: help build run lint typecheck arch-check test test-determinism \
        coverage-gate coverage-gate-critical gates ci fullbuild clean

help:
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-28s %s\n", $$1, $$2}'

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

arch-check: ## ArchUnit-Tests (ADR-0001)
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(MVN_IMAGE) \
		mvn -q test -Dtest=ArchitectureTest

test:
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(MVN_IMAGE) \
		mvn -q test

test-determinism:
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(MVN_IMAGE) \
		mvn -q test -Dtest=DeterminismTest -Dsurefire.rerunFailingTestsCount=100

coverage-gate: ## JaCoCo 70 %
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(MVN_IMAGE) \
		mvn -q verify

coverage-gate-critical:
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
