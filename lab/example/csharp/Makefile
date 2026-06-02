# DocSearch C#-Skelett — Makefile

IMAGE := docsearch-csharp
DOCKER := docker
DOTNET_SDK := mcr.microsoft.com/dotnet/sdk:10.0

.PHONY: help build run lint typecheck arch-check test test-determinism \
        coverage-gate coverage-gate-critical gates ci fullbuild clean

help:
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-28s %s\n", $$1, $$2}'

build:
	$(DOCKER) build -t $(IMAGE):latest .

run: build
	$(DOCKER) run --rm $(IMAGE):latest --help

lint: ## dotnet format inkl. Suppression-Verbot (AGENTS.md §C-1)
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(DOTNET_SDK) \
		dotnet format DocSearch.sln --verify-no-changes

typecheck: ## dotnet build -warnaserror, Lock-Mode aktiv
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(DOTNET_SDK) \
		dotnet build DocSearch.sln -warnaserror /p:RestoreLockedMode=true

arch-check: ## NetArchTest in xUnit (ADR-0001)
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(DOTNET_SDK) \
		dotnet test DocSearch.sln --filter "FullyQualifiedName~ArchitectureTests"

test:
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(DOTNET_SDK) \
		dotnet test DocSearch.sln

test-determinism:
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(DOTNET_SDK) \
		dotnet test DocSearch.sln --filter "FullyQualifiedName~DeterminismTests"

coverage-gate: ## coverlet, 70 % (Schwelle via msbuild-Properties)
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(DOTNET_SDK) \
		dotnet test DocSearch.sln --settings coverlet.runsettings \
		/p:CollectCoverage=true /p:CoverletOutputFormat=cobertura \
		/p:Threshold=70 /p:ThresholdType=line /p:ThresholdStat=total

coverage-gate-critical:
	@echo "Critical coverage — CO-001 (Index) ausgenommen"
	$(DOCKER) run --rm -v "$$(pwd)":/src -w /src $(DOTNET_SDK) \
		dotnet test DocSearch.sln --filter "FullyQualifiedName~Service"

gates: lint typecheck arch-check test coverage-gate
	@echo "gates grün."

ci: gates test-determinism coverage-gate-critical
	@echo "ci grün."

fullbuild: ci build
	@echo "fullbuild grün."

clean:
	-rm -rf bin obj **/bin **/obj TestResults
	-$(DOCKER) image rm $(IMAGE):latest
