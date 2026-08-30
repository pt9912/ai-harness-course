# DocSearch — Python-Skelett — Makefile
# Docker-only, uv-Toolchain. AGENTS.md §P-3.

IMAGE := docsearch-python
DOCKER := docker

# Kein Bind-Mount: Die Quellen wandern beim Build ins Image (Dockerfile,
# Stage `repo`), die Werkzeuge laufen darin, die Belege kommen ueber stdout
# heraus (Modul 14 §Der Prueflauf ist hermetisch). Damit kann kein Gate den
# Arbeitsbaum veraendern, und nichts bleibt als root:root liegen.
GATES := docsearch-python-gates
RUN := --rm --network none $(GATES)

.PHONY: help build run gate-image lint typecheck arch-check test test-determinism \
        coverage-gate coverage-gate-critical export gates ci fullbuild clean

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

gate-image: ## Pruef-Image bauen (Stage `export`: Quellen + Werkzeuge im Image)
	$(DOCKER) build -q --target repo -t $(GATES) . >/dev/null

lint: gate-image ## ruff inkl. noqa-Gate (LH-QA-* Stil)
	$(DOCKER) run $(RUN) ruff check .

typecheck: gate-image ## mypy --strict
	$(DOCKER) run $(RUN) mypy --cache-dir=/tmp/mypy --strict src/

# Beide Sensoren laufen, auch wenn der erste rot ist: ADR-0018 laesst die
# beiden Befund-Mengen vergleichen, und ein Abbruch nach dem ersten zeigt
# immer nur eine.
arch-check: ## ADR-0001 Layering — zwei Sensoren: a-check (Konfiguration) + import-linter (Contracts)
	@rc=0; $(MAKE) --no-print-directory a-check || rc=1; \
	$(MAKE) --no-print-directory gate-image; \
	$(DOCKER) run $(RUN) sh -c "PYTHONPATH=src lint-imports --config importlinter.cfg --no-cache" || rc=1; \
	exit $$rc

test: gate-image ## pytest
	$(DOCKER) run $(RUN) pytest -v -p no:cacheprovider

test-determinism: gate-image ## LH-QA-02: 100 Iter
	$(DOCKER) run $(RUN) pytest -k determinism --count=100 -p no:cacheprovider

coverage-gate: gate-image ## Gesamt-Coverage (ADR-0013, bootstrap-aware: 70 %, Hochschalt-Trigger M2 (welle-2 geschlossen) -> 80 % via Nachfolge-ADR)
	$(DOCKER) run $(RUN) sh -c "COVERAGE_FILE=/tmp/.coverage pytest -p no:cacheprovider --cov=src/docsearch --cov-report=term --cov-fail-under=70"

coverage-gate-critical: gate-image ## Critical Coverage (ADR-0013: 90 %; CO-001: Index-Layer ausgenommen)
	@echo "Critical coverage — CO-001 (index-Layer) ausgenommen"
	$(DOCKER) run $(RUN) sh -c "COVERAGE_FILE=/tmp/.coverage pytest -p no:cacheprovider --cov=src/docsearch/service --cov-fail-under=90 tests/"

export: ## Belege der Beleg-Stages nach ./out holen (Rueckweg ohne Mount)
	$(DOCKER) build -q --target export -t $(GATES)-export . >/dev/null
	@mkdir -p out && $(DOCKER) run --rm --network none $(GATES)-export tar -cf - -C /out . | tar -xf - -C out
	@echo "-> ./out"

gates: lint typecheck arch-check test coverage-gate ## mandatory
	@echo "gates grün."

ci: gates test-determinism coverage-gate-critical
	@echo "ci grün."

fullbuild: ci build
	@echo "fullbuild grün."

clean:
	rm -rf .pytest_cache .ruff_cache .mypy_cache htmlcov .coverage
	-$(DOCKER) image rm $(IMAGE):latest
