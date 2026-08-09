# DocSearch — Go-Skelett — Makefile
# Alle Gates laufen über Docker (Docker-only, AGENTS.md §2.1).

IMAGE := docsearch-go
DOCKER := docker
GO_IMAGE := golang:1.23-alpine

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

build: ## Runtime-Image bauen (Multi-Stage, Distroless)
	$(DOCKER) build -t $(IMAGE):latest .

run: build ## Smoke: --help
	$(DOCKER) run --rm $(IMAGE):latest --help

lint: ## golangci-lint inkl. depguard (LH-QA-* Stil)
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src \
		golangci/golangci-lint:v1.62-alpine golangci-lint run ./...

typecheck: ## go vet als Statik-Check
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(GO_IMAGE) \
		sh -c "go mod download && go vet ./..."

# Beide Sensoren laufen, auch wenn der erste rot ist: ADR-0015 laesst die
# beiden Befund-Mengen vergleichen, und ein Abbruch nach dem ersten zeigt
# immer nur eine.
arch-check: ## ADR-0001 Layering — zwei Sensoren: a-check (Konfiguration) + depguard (Linter-Regeln)
	@rc=0; $(MAKE) --no-print-directory a-check || rc=1; \
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src \
		golangci/golangci-lint:v1.62-alpine \
		golangci-lint run --disable-all --enable=depguard ./... || rc=1; \
	exit $$rc

test: ## Unit-Tests (Race-Detector braucht cgo: gcc/musl-dev im alpine-Image)
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(GO_IMAGE) \
		sh -c "apk add --no-cache gcc musl-dev && go mod download && CGO_ENABLED=1 go test -race ./..."

test-determinism: ## LH-QA-02: 100 Wiederholungen identischer Eingabe
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(GO_IMAGE) \
		sh -c "go mod download && go test -run 'TestDeterminism' -count=100 ./..."

coverage-gate: ## Gesamt-Coverage (ADR-0013, bootstrap-aware: 70 %, Hochschalt-Trigger M2 (welle-2 geschlossen) -> 80 % via Nachfolge-ADR; hermetisch via coverage-Stage)
	$(DOCKER) build --target coverage -t $(IMAGE)-coverage .
	$(DOCKER) run --rm $(IMAGE)-coverage ./... 70

coverage-gate-critical: ## Critical-Path-Coverage (ADR-0013: 90 %; CO-001: Index-Layer ausgenommen)
	@echo "Critical coverage check — CO-001 (internal/index) ausgenommen bis Welle 2 done"
	$(DOCKER) build --target coverage -t $(IMAGE)-coverage .
	$(DOCKER) run --rm $(IMAGE)-coverage ./internal/service/... 90

gates: lint typecheck arch-check test coverage-gate ## alle inneren Gates (mandatory)
	@echo "gates grün."

ci: gates test-determinism coverage-gate-critical ## CI-Lauf
	@echo "ci grün."

fullbuild: ci build ## volle Closure
	@echo "fullbuild grün, Image: $(IMAGE):latest"

clean: ## generierte Artefakte entfernen
	rm -f coverage.out
	-$(DOCKER) image rm $(IMAGE):latest $(IMAGE)-coverage
