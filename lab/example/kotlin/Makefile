# DocSearch Kotlin-Skelett — Makefile
# Docker-only. Gradle im Container, Wrapper im Repo.

IMAGE := docsearch-kotlin
DOCKER := docker
GRADLE_IMAGE := gradle:8.10-jdk21

.PHONY: help build run lint typecheck arch-check test test-determinism \
        coverage-gate coverage-gate-critical gates ci fullbuild clean

help: ## Targets anzeigen
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-28s %s\n", $$1, $$2}'

build: ## Image bauen
	$(DOCKER) build -t $(IMAGE):latest .

run: build
	$(DOCKER) run --rm $(IMAGE):latest --help

lint: ## detekt
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(GRADLE_IMAGE) gradle detekt

typecheck: ## Kotlin-Compiler
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(GRADLE_IMAGE) gradle compileKotlin compileTestKotlin

arch-check: ## Konsist-Tests (ADR-0001 Layering)
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(GRADLE_IMAGE) \
		gradle test --tests "com.example.docsearch.ArchitectureTest"

test: ## JUnit-Tests
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(GRADLE_IMAGE) gradle test

test-determinism: ## LH-QA-02 100 Iter
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(GRADLE_IMAGE) \
		gradle test --tests "com.example.docsearch.DeterminismTest" \
		-Pdeterminism.iterations=100

coverage-gate: ## kover, 70 %
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(GRADLE_IMAGE) gradle koverVerify

coverage-gate-critical:
	@echo "Critical coverage — CO-001 (index) ausgenommen"
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(GRADLE_IMAGE) \
		gradle koverVerify -Pcritical=true

gates: lint typecheck arch-check test coverage-gate
	@echo "gates grün."

ci: gates test-determinism coverage-gate-critical
	@echo "ci grün."

fullbuild: ci build
	@echo "fullbuild grün."

clean:
	-rm -rf build .gradle
	-$(DOCKER) image rm $(IMAGE):latest
