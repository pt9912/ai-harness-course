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
CRITICAL_THRESHOLD ?= 90

# Toolchain-Container: Repo unter /src, build/ persistiert via Bind-Mount.
WORK := $(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(TOOLCHAIN)

.PHONY: help toolchain configure lint typecheck arch-check test test-determinism \
        coverage-gate coverage-gate-critical gates ci fullbuild build run clean

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

toolchain: ## Builder-Image mit gepinnter Toolchain bauen (deps-Stage)
	$(DOCKER) build --target toolchain -t $(TOOLCHAIN) .

configure: toolchain ## CMake konfigurieren (Release, compile_commands.json)
	$(WORK) cmake -S . -B $(BUILD_DIR) -DCMAKE_BUILD_TYPE=Release

typecheck: configure ## Compiler als Statik-Check (-Wall -Wextra -Werror)
	$(WORK) cmake --build $(BUILD_DIR) -j

lint: configure ## clang-tidy + Suppression-Gate (AGENTS.md §2.2)
	$(WORK) bash cmake/suppression-gate.sh
	$(WORK) sh -c 'clang-tidy -p $(BUILD_DIR) $$(find src -name "*.cpp")'

# Beide Sensoren laufen, auch wenn der erste rot ist: ADR-0018 laesst die
# beiden Befund-Mengen vergleichen, und ein Abbruch nach dem ersten zeigt
# immer nur eine.
arch-check: ## ADR-0001 Layering — zwei Sensoren: a-check (Konfiguration) + Skript (Include-Heuristik)
	@rc=0; $(MAKE) --no-print-directory a-check || rc=1; \
	$(WORK) bash cmake/arch-check.sh || rc=1; \
	exit $$rc

test: configure ## doctest via ctest (Unit + Tie-Break)
	$(WORK) sh -c 'cmake --build $(BUILD_DIR) -j && \
		ctest --test-dir $(BUILD_DIR) -R unit --output-on-failure'

test-determinism: configure ## LH-QA-02: Determinismus-Case (100 Iterationen)
	$(WORK) sh -c 'cmake --build $(BUILD_DIR) -j && \
		ctest --test-dir $(BUILD_DIR) -R determinism --output-on-failure'

coverage-gate: toolchain ## Gesamt-Coverage (ADR-0013, bootstrap-aware: 70 %, Hochschalt-Trigger M2 (welle-2 geschlossen) -> 80 % via Nachfolge-ADR; Composition Root ausgenommen)
	$(WORK) sh -c 'cmake -S . -B $(COV_DIR) -DDOCSEARCH_COVERAGE=ON && \
		cmake --build $(COV_DIR) -j && \
		ctest --test-dir $(COV_DIR) -R unit --output-on-failure && \
		gcovr --root . --filter "src/" --exclude ".*/main\.cpp" --fail-under-line $(COVERAGE_THRESHOLD) $(COV_DIR)'

coverage-gate-critical: toolchain ## Critical-Path-Coverage (ADR-0013: 90 %; CO-001: Index-Layer ausgenommen)
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
