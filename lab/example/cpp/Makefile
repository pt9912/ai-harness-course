# DocSearch — C++/CMake-Skelett — Makefile
# Alle Gates laufen über Docker (Docker-only, AGENTS.md §2.1). Das
# Toolchain-Image (deps-Stage) liefert cmake/g++/clang-tidy/gcovr; der
# Quellbaum wird per Bind-Mount hineingereicht, build/ bleibt auf dem Host
# (so übersteht der FetchContent-Cache einzelne Targets).

IMAGE := docsearch-cpp
TOOLCHAIN := docsearch-cpp-toolchain
DOCKER := docker
BUILD_DIR := build
COV_DIR := build-cov
COVERAGE_THRESHOLD ?= 70
CRITICAL_THRESHOLD ?= 80

# Toolchain-Container: Repo unter /src, build/ persistiert via Bind-Mount.
WORK := $(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(TOOLCHAIN)

.PHONY: help toolchain configure lint typecheck arch-check test test-determinism \
        coverage-gate coverage-gate-critical gates ci fullbuild build run clean

help: ## Targets anzeigen
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-28s %s\n", $$1, $$2}'

toolchain: ## Builder-Image mit gepinnter Toolchain bauen (deps-Stage)
	$(DOCKER) build --target toolchain -t $(TOOLCHAIN) .

configure: toolchain ## CMake konfigurieren (Release, compile_commands.json)
	$(WORK) cmake -S . -B $(BUILD_DIR) -DCMAKE_BUILD_TYPE=Release

typecheck: configure ## Compiler als Statik-Check (-Wall -Wextra -Werror)
	$(WORK) cmake --build $(BUILD_DIR) -j

lint: configure ## clang-tidy + Suppression-Gate (AGENTS.md §2.2)
	$(WORK) bash cmake/suppression-gate.sh
	$(WORK) sh -c 'clang-tidy -p $(BUILD_DIR) $$(find src -name "*.cpp")'

arch-check: ## ADR-0001 Layering (textbasiert, ohne Toolchain)
	$(WORK) bash cmake/arch-check.sh

test: configure ## doctest via ctest (Unit + Tie-Break)
	$(WORK) sh -c 'cmake --build $(BUILD_DIR) -j && \
		ctest --test-dir $(BUILD_DIR) -R unit --output-on-failure'

test-determinism: configure ## LH-QA-02: Determinismus-Case (100 Iterationen)
	$(WORK) sh -c 'cmake --build $(BUILD_DIR) -j && \
		ctest --test-dir $(BUILD_DIR) -R determinism --output-on-failure'

coverage-gate: toolchain ## LH-QA-Coverage (bootstrap-aware, $(COVERAGE_THRESHOLD)%; Composition Root ausgenommen)
	$(WORK) sh -c 'cmake -S . -B $(COV_DIR) -DDOCSEARCH_COVERAGE=ON && \
		cmake --build $(COV_DIR) -j && \
		ctest --test-dir $(COV_DIR) -R unit --output-on-failure && \
		gcovr --root . --filter "src/" --exclude ".*/main\.cpp" --fail-under-line $(COVERAGE_THRESHOLD) $(COV_DIR)'

coverage-gate-critical: toolchain ## Critical-Path-Coverage (CO-001: index ausgenommen)
	@echo "Critical coverage — CO-001 (src/hexagon/index) ausgenommen bis Welle 2 done"
	$(WORK) sh -c 'cmake -S . -B $(COV_DIR) -DDOCSEARCH_COVERAGE=ON && \
		cmake --build $(COV_DIR) -j && \
		ctest --test-dir $(COV_DIR) -R unit --output-on-failure && \
		gcovr --root . --filter "src/hexagon/service/" --fail-under-line $(CRITICAL_THRESHOLD) $(COV_DIR)'

build: ## Runtime-Image bauen (Multi-Stage, Distroless)
	$(DOCKER) build -t $(IMAGE):latest .

run: build ## Smoke: --help
	$(DOCKER) run --rm $(IMAGE):latest --help

gates: lint typecheck arch-check test coverage-gate ## alle inneren Gates (mandatory)
	@echo "gates grün."

ci: gates test-determinism coverage-gate-critical ## CI-Lauf
	@echo "ci grün."

fullbuild: ci build ## volle Closure inkl. Runtime-Image
	@echo "fullbuild grün, Image: $(IMAGE):latest"

clean: ## generierte Artefakte entfernen
	rm -rf $(BUILD_DIR) $(COV_DIR)
	-$(DOCKER) image rm $(IMAGE):latest $(TOOLCHAIN)
