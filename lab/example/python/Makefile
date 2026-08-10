# DocSearch — Python-Skelett — Makefile
# Docker-only, uv-Toolchain. AGENTS.md §P-3.

IMAGE := docsearch-python
DOCKER := docker
PY_IMAGE := python:3.12-slim

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

lint: ## ruff inkl. noqa-Gate (LH-QA-* Stil)
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(PY_IMAGE) \
		sh -c "pip install -q ruff==0.6.0 && ruff check ."

typecheck: ## mypy --strict
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(PY_IMAGE) \
		sh -c "pip install -q mypy==1.11.0 && mypy --strict src/"

# Beide Sensoren laufen, auch wenn der erste rot ist: ADR-0018 laesst die
# beiden Befund-Mengen vergleichen, und ein Abbruch nach dem ersten zeigt
# immer nur eine.
arch-check: ## ADR-0001 Layering — zwei Sensoren: a-check (Konfiguration) + import-linter (Contracts)
	@rc=0; $(MAKE) --no-print-directory a-check || rc=1; \
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(PY_IMAGE) \
		sh -c "pip install -q import-linter==2.0 && PYTHONPATH=src lint-imports --config importlinter.cfg" || rc=1; \
	exit $$rc

test: ## pytest
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(PY_IMAGE) \
		sh -c "pip install -q pytest pytest-cov && pytest -v"

test-determinism: ## LH-QA-02: 100 Iter
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(PY_IMAGE) \
		sh -c "pip install -q pytest pytest-repeat && pytest -k determinism --count=100"

coverage-gate: ## Gesamt-Coverage (ADR-0013, bootstrap-aware: 70 %, Hochschalt-Trigger M2 (welle-2 geschlossen) -> 80 % via Nachfolge-ADR)
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(PY_IMAGE) \
		sh -c "pip install -q pytest pytest-cov && \
			pytest --cov=src/docsearch --cov-report=term --cov-fail-under=70"

coverage-gate-critical: ## Critical Coverage (ADR-0013: 90 %; CO-001: Index-Layer ausgenommen)
	@echo "Critical coverage — CO-001 (index-Layer) ausgenommen"
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(PY_IMAGE) \
		sh -c "pip install -q pytest pytest-cov && \
			pytest --cov=src/docsearch/service --cov-fail-under=90 tests/"

gates: lint typecheck arch-check test coverage-gate ## mandatory
	@echo "gates grün."

ci: gates test-determinism coverage-gate-critical
	@echo "ci grün."

fullbuild: ci build
	@echo "fullbuild grün."

clean:
	rm -rf .pytest_cache .ruff_cache .mypy_cache htmlcov .coverage
	-$(DOCKER) image rm $(IMAGE):latest
