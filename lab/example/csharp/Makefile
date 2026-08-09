# DocSearch C#-Skelett — Makefile

IMAGE := docsearch-csharp
DOCKER := docker
DOTNET_SDK := mcr.microsoft.com/dotnet/sdk:10.0

.PHONY: help build run lint typecheck arch-check test test-determinism \
        coverage-gate coverage-gate-critical gates ci fullbuild clean

# `-h`: MAKEFILE_LIST trägt mehrere Dateien, und grep stellt dann jeder
# Zeile den Dateinamen voran — er verdrängt den Target-Namen.
help: ## Targets anzeigen
	@grep -hE '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-28s %s\n", $$1, $$2}'

# Zweites Layering-Gate (ADR-0017). `a-check.mk` ist tool-generiert
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

lint: ## dotnet format inkl. Suppression-Verbot (AGENTS.md §C-1)
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(DOTNET_SDK) \
		dotnet format DocSearch.sln --verify-no-changes

typecheck: ## dotnet build -warnaserror, Lock-Mode aktiv
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(DOTNET_SDK) \
		dotnet build DocSearch.sln -warnaserror /p:RestoreLockedMode=true

# Beide Sensoren laufen, auch wenn der erste rot ist: ADR-0017 laesst die
# beiden Befund-Mengen vergleichen, und ein Abbruch nach dem ersten zeigt
# immer nur eine.
arch-check: ## ADR-0001 Layering — zwei Sensoren: a-check (Konfiguration) + NetArchTest (Test-Framework)
	@rc=0; $(MAKE) --no-print-directory a-check || rc=1; \
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(DOTNET_SDK) \
		dotnet test DocSearch.sln --filter "FullyQualifiedName~ArchitectureTests" || rc=1; \
	exit $$rc

test: ## xUnit-Tests
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(DOTNET_SDK) \
		dotnet test DocSearch.sln

test-determinism: ## LH-QA-02: Determinismus-Case
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(DOTNET_SDK) \
		dotnet test DocSearch.sln --filter "FullyQualifiedName~DeterminismTests"

coverage-gate: ## Gesamt-Coverage via coverlet (ADR-0013, bootstrap-aware: 70 %, Hochschalt-Trigger M2 (welle-2 geschlossen) -> 80 % via Nachfolge-ADR)
# Zwei Integrationen, die sich ausschliessen: `--settings coverlet.runsettings`
# ist die COLLECTOR-, `/p:Threshold` die MSBUILD-Integration — die Schwelle
# wertet nur die MSBUILD-Seite aus. Beide zugleich gesetzt: es wird gemessen,
# die Schwelle bleibt unbeachtet, exit 0. Deshalb eine Integration, nicht zwei.
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(DOTNET_SDK) \
		dotnet test DocSearch.sln \
		/p:CollectCoverage=true /p:CoverletOutputFormat=cobertura \
		'/p:Exclude="[xunit.*]*,[*.Tests]*"' \
		/p:Threshold=70 /p:ThresholdType=line /p:ThresholdStat=total

coverage-gate-critical: ## Critical Coverage (ADR-0013: 90 %; CO-001: Index-Layer ausgenommen)
	@echo "Critical coverage — Messung auf DocSearch.Service verengt (CO-001: Index ausgenommen)"
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(DOTNET_SDK) \
		dotnet test DocSearch.sln \
		/p:CollectCoverage=true /p:CoverletOutputFormat=cobertura \
		'/p:Include="[DocSearch]DocSearch.Service.*"' \
		/p:Threshold=90 /p:ThresholdType=line /p:ThresholdStat=total

gates: lint typecheck arch-check test coverage-gate ## alle inneren Gates (mandatory)
	@echo "gates grün."

ci: gates test-determinism coverage-gate-critical ## gates + test-determinism + coverage-gate-critical
	@echo "ci grün."

fullbuild: ci build ## volle Closure inkl. Runtime-Image
	@echo "fullbuild grün."

clean: ## generierte Artefakte entfernen
	-rm -rf bin obj **/bin **/obj TestResults
	-$(DOCKER) image rm $(IMAGE):latest
