# DocSearch example harness entrypoints.
# Lightweight root targets for the course modules; language-specific gates
# stay in go/, python/, kotlin/, java/, csharp/.

COURSE_LANG ?= go
RUN ?= welle-1-baseline

.PHONY: help gates ci fullbuild agent-implement agent-review verify replay trace release

help: ## Targets anzeigen
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-24s %s\n", $$1, $$2}'

gates: ## Sprachskelett-Gates ausführen: make gates COURSE_LANG=go|python|kotlin|java|csharp
	@test -d "$(COURSE_LANG)" || (echo "Unknown COURSE_LANG=$(COURSE_LANG)"; exit 2)
	$(MAKE) -C "$(COURSE_LANG)" gates

ci: ## Sprachskelett-CI ausführen
	@test -d "$(COURSE_LANG)" || (echo "Unknown COURSE_LANG=$(COURSE_LANG)"; exit 2)
	$(MAKE) -C "$(COURSE_LANG)" ci

fullbuild: ## Sprachskelett-Fullbuild ausführen
	@test -d "$(COURSE_LANG)" || (echo "Unknown COURSE_LANG=$(COURSE_LANG)"; exit 2)
	$(MAKE) -C "$(COURSE_LANG)" fullbuild

agent-implement: ## Kontextpaket fuer einen Implementation-Agent zeigen: make agent-implement SLICE=slice-009
	@test -n "$(SLICE)" || (echo "Usage: make agent-implement SLICE=slice-009"; exit 2)
	@slice_path=$$(find docs/plan/planning -name "$(SLICE)*.md" -print -quit); \
	test -n "$$slice_path" || (echo "Slice not found: $(SLICE)"; exit 1); \
	echo "Implementation context for $$slice_path"; \
	echo "1. harness/README.md"; \
	echo "2. AGENTS.md"; \
	echo "3. $$slice_path"; \
	echo "4. referenced spec/ and docs/plan/adr/ files"; \
	echo "5. run the narrowest useful sensor, then make gates COURSE_LANG=$(COURSE_LANG)"

agent-review: ## Review-Fixture fuer Modul 9 anzeigen
	@fixture="exercises/09-review-fixture/slice-X-broken-feature.md"; \
	test -f "$$fixture" || (echo "Missing review fixture"; exit 1); \
	echo "Review fixture: $$fixture"; \
	echo "Required context:"; \
	echo "1. AGENTS.md"; \
	echo "2. docs/plan/adr/0001-hexagonale-architektur.md"; \
	echo "3. spec/lastenheft.md"; \
	echo "Expected: HIGH, MEDIUM and LOW finding categories"

verify: ## Slice-DoD gegen sichtbare Artefakte plausibilisieren: make verify SLICE=slice-009
	@test -n "$(SLICE)" || (echo "Usage: make verify SLICE=slice-009"; exit 2)
	@slice_path=$$(find docs/plan/planning -name "$(SLICE)*.md" -print -quit); \
	test -n "$$slice_path" || (echo "Slice not found: $(SLICE)"; exit 1); \
	grep -q "Definition of Done" "$$slice_path" || (echo "Missing Definition of Done: $$slice_path"; exit 1); \
	grep -Eq "LH-|ADR-" "$$slice_path" || (echo "Missing traceability ID: $$slice_path"; exit 1); \
	grep -q "make gates" "$$slice_path" || (echo "Missing gates evidence in DoD: $$slice_path"; exit 1); \
	echo "verify ok: $$slice_path"

replay: ## Golden-Set-Replay-Fixture validieren: make replay RUN=welle-1-baseline
	@test -f "evals/golden/$(RUN).json" || (echo "Replay fixture not found: evals/golden/$(RUN).json"; exit 1)
	@node -e 'const fs=require("fs"); const p="evals/golden/$(RUN).json"; const j=JSON.parse(fs.readFileSync(p,"utf8")); if(!j.model_version||!Array.isArray(j.cases)||j.cases.length<3) { throw new Error("Replay needs model_version and >=3 cases"); } console.log("replay fixture ok: " + p + " (" + j.cases.length + " cases)");'

trace: ## Agentenlauf-Trace-Fixture ausgeben: make trace RUN=sl-009-agent-run
	@test -f "otel/$(RUN).trace.json" || (echo "Trace fixture not found: otel/$(RUN).trace.json"; exit 1)
	@node -e 'const fs=require("fs"); const p="otel/$(RUN).trace.json"; const j=JSON.parse(fs.readFileSync(p,"utf8")); const spans=j.spans||[]; if(spans.length===0) { throw new Error("Trace has no spans"); } console.log("trace fixture ok: " + p + " (" + spans.length + " spans)");'

release: ## Release-Checkliste und Runbook-Fixtures pruefen
	@test -f runbooks/release-checklist.md || (echo "Missing runbooks/release-checklist.md"; exit 1)
	@test -f runbooks/incident-agent-data-loss.md || (echo "Missing incident runbook"; exit 1)
	@grep -q "Trace" runbooks/release-checklist.md || (echo "Release checklist lacks trace evidence"; exit 1)
	@echo "release fixture ok: runbooks present"
