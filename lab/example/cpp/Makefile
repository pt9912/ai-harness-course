# DocSearch — C++/CMake-Skelett — Makefile
# Alle Gates laufen über Docker (Docker-only, AGENTS.md §2.1). Das
# Toolchain-Image (deps-Stage) liefert cmake/g++/clang-tidy/gcovr; der
# Quellbaum wird per Bind-Mount hineingereicht, build/ bleibt auf dem Host
# (so übersteht der FetchContent-Cache einzelne Targets).

IMAGE := docsearch-cpp
TOOLCHAIN := docsearch-cpp-toolchain
DOCKER := docker
BUILD_DIR := build
COV_DIR := /tmp/build-cov
COVERAGE_THRESHOLD ?= 70
CRITICAL_THRESHOLD ?= 90

# Kein Bind-Mount: Quellen UND Build-Verzeichnis liegen im Image (Dockerfile,
# Stage `build`), die Werkzeuge daneben in `toolchain`. Der Rueckweg der Belege
# laeuft ueber stdout (Modul 14 §Der Prueflauf ist hermetisch). Dass die
# `build`-Stage baut, ist zugleich der Typecheck-Gate.
GATES := docsearch-cpp-gates
COV_IMAGE := docsearch-cpp-coverage
RUN := --rm --network none $(GATES)

.PHONY: help toolchain gate-image cov-image export lint typecheck arch-check test test-determinism \
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

# Kein `-q`: In diesen beiden Stages faellt ein Urteil (der Bau IST der
# Typecheck-Gate, der Coverage-Bau fuehrt die Tests aus). Mit `-q` zeigte ein
# Fehler nur den Exit-Code, nicht die Diagnose (Modul 14, zwei Griffe).
cov-image: ## Coverage-Image bauen (instrumentierter Build entsteht im Image)
	$(DOCKER) build --target coverage -t $(COV_IMAGE) . >/dev/null

gate-image: ## Pruef-Image bauen (Stage `export`: Quellen, Build-Baum, Werkzeuge)
	$(DOCKER) build --target build -t $(GATES) . >/dev/null

typecheck: gate-image ## Compiler als Statik-Check (-Wall -Wextra -Werror) — der Bau der `build`-Stage
	$(DOCKER) run $(RUN) cmake --build $(BUILD_DIR) -j

lint: gate-image ## clang-tidy + Suppression-Gate (AGENTS.md §2.2)
	$(DOCKER) run $(RUN) bash cmake/suppression-gate.sh
	$(DOCKER) run $(RUN) sh -c 'clang-tidy -p $(BUILD_DIR) $$(find src -name "*.cpp")'

# Beide Sensoren laufen, auch wenn der erste rot ist: ADR-0018 laesst die
# beiden Befund-Mengen vergleichen, und ein Abbruch nach dem ersten zeigt
# immer nur eine.
arch-check: ## ADR-0001 Layering — zwei Sensoren: a-check (Konfiguration) + Skript (Include-Heuristik)
	@rc=0; $(MAKE) --no-print-directory a-check || rc=1; \
	$(MAKE) --no-print-directory gate-image; \
	$(DOCKER) run $(RUN) bash cmake/arch-check.sh || rc=1; \
	exit $$rc

test: gate-image ## doctest via ctest (Unit + Tie-Break)
	$(DOCKER) run $(RUN) ctest --test-dir $(BUILD_DIR) -R unit --output-on-failure

test-determinism: gate-image ## LH-QA-02: Determinismus-Case (100 Iterationen)
	$(DOCKER) run $(RUN) ctest --test-dir $(BUILD_DIR) -R determinism --output-on-failure

coverage-gate: cov-image ## Gesamt-Coverage (ADR-0013, bootstrap-aware: 70 %, Hochschalt-Trigger M2 (welle-2 geschlossen) -> 80 % via Nachfolge-ADR; Composition Root ausgenommen)
	$(DOCKER) run --rm --network none $(COV_IMAGE) \
		gcovr --root . --filter "src/" --exclude ".*/main\.cpp" \
			--fail-under-line $(COVERAGE_THRESHOLD) $(COV_DIR)

coverage-gate-critical: cov-image ## Critical-Path-Coverage (ADR-0013: 90 %; CO-001: Index-Layer ausgenommen)
	@echo "Critical coverage — CO-001 (src/hexagon/index) ausgenommen bis Welle 2 done"
	$(DOCKER) run --rm --network none $(COV_IMAGE) \
		gcovr --root . --filter "src/hexagon/service" \
			--fail-under-line $(CRITICAL_THRESHOLD) $(COV_DIR)

build: ## Runtime-Image bauen (Multi-Stage, Distroless)
	$(DOCKER) build -t $(IMAGE):latest .

run: build ## Smoke: --help
	$(DOCKER) run --rm $(IMAGE):latest --help

export: ## Belege der Beleg-Stages nach ./out holen (Rueckweg ohne Mount)
	$(DOCKER) build -q --target export -t $(GATES)-export . >/dev/null
	@mkdir -p out && $(DOCKER) run --rm --network none $(GATES)-export tar -cf - -C /out . | tar -xf - -C out
	@echo "-> ./out"

gates: lint typecheck arch-check test coverage-gate ## alle inneren Gates (mandatory)
	@echo "gates grün."

ci: gates test-determinism coverage-gate-critical ## CI-Lauf
	@echo "ci grün."

fullbuild: ci build ## volle Closure inkl. Runtime-Image
	@echo "fullbuild grün, Image: $(IMAGE):latest"

clean: ## generierte Artefakte entfernen
	rm -rf $(BUILD_DIR) $(COV_DIR)
	-$(DOCKER) image rm $(IMAGE):latest $(TOOLCHAIN)
