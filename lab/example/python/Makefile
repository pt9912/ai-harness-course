# DocSearch — Python-Skelett — Makefile
# Docker-only, uv-Toolchain. AGENTS.md §P-3.

IMAGE := docsearch-python
DOCKER := docker
PY_IMAGE := python:3.12-slim

.PHONY: help build run lint typecheck arch-check test test-determinism \
        coverage-gate coverage-gate-critical gates ci fullbuild clean

help: ## Targets anzeigen
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-28s %s\n", $$1, $$2}'

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

arch-check: ## import-linter Contracts (ADR-0001)
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(PY_IMAGE) \
		sh -c "pip install -q import-linter==2.0 && lint-imports --config importlinter.cfg"

test: ## pytest
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(PY_IMAGE) \
		sh -c "pip install -q pytest pytest-cov && pytest -v"

test-determinism: ## LH-QA-02: 100 Iter
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(PY_IMAGE) \
		sh -c "pip install -q pytest pytest-repeat && pytest -k determinism --count=100"

coverage-gate: ## LH-QA-Coverage 70 %
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(PY_IMAGE) \
		sh -c "pip install -q pytest pytest-cov && \
			pytest --cov=src/docsearch --cov-report=term --cov-fail-under=70"

coverage-gate-critical: ## Critical Coverage 80 % (CO-001 ausgenommen)
	@echo "Critical coverage — CO-001 (index-Layer) ausgenommen"
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(PY_IMAGE) \
		sh -c "pip install -q pytest pytest-cov && \
			pytest --cov=src/docsearch/service --cov-fail-under=80 tests/test_service.py"

gates: lint typecheck arch-check test coverage-gate ## mandatory
	@echo "gates grün."

ci: gates test-determinism coverage-gate-critical
	@echo "ci grün."

fullbuild: ci build
	@echo "fullbuild grün."

clean:
	rm -rf .pytest_cache .ruff_cache .mypy_cache htmlcov .coverage
	-$(DOCKER) image rm $(IMAGE):latest
