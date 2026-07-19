# DocSearch example harness entrypoints.
# Lightweight root targets for the course modules; language-specific gates
# stay in go/, python/, kotlin/, java/, csharp/, cpp/.

COURSE_LANG ?= go
RUN ?= welle-1-baseline

.PHONY: help gates ci fullbuild plan-status agent-implement agent-review verify verify-slice verify-closure-notes check-references replay trace release

help: ## Targets anzeigen
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-24s %s\n", $$1, $$2}'

gates: ## Sprachskelett-Gates ausführen: make gates COURSE_LANG=go|python|kotlin|java|csharp|cpp
	@test -d "$(COURSE_LANG)" || (echo "Unknown COURSE_LANG=$(COURSE_LANG)"; exit 2)
	$(MAKE) -C "$(COURSE_LANG)" gates

ci: ## Sprachskelett-CI ausführen
	@test -d "$(COURSE_LANG)" || (echo "Unknown COURSE_LANG=$(COURSE_LANG)"; exit 2)
	$(MAKE) -C "$(COURSE_LANG)" ci

fullbuild: ## Sprachskelett-Fullbuild ausführen
	@test -d "$(COURSE_LANG)" || (echo "Unknown COURSE_LANG=$(COURSE_LANG)"; exit 2)
	$(MAKE) -C "$(COURSE_LANG)" fullbuild

plan-status: ## Slice-Verteilung ueber docs/plan/planning/{open,next,in-progress,done}/ anzeigen
	@for dir in open next in-progress done; do \
		base="docs/plan/planning/$$dir"; \
		test -d "$$base" || { echo "Missing lifecycle directory: $$base"; exit 1; }; \
		files=$$(find "$$base" -maxdepth 1 -name '*.md' | sort); \
		if [ -n "$$files" ]; then count=$$(echo "$$files" | wc -l); else count=0; fi; \
		echo "$$dir/ ($$count)"; \
		for f in $$files; do echo "  - $$(basename "$$f")"; done; \
	done

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

agent-review: ## Review-Fixture fuer Modul 10 anzeigen
	@fixture="exercises/09-review-fixture/slice-X-broken-feature.md"; \
	test -f "$$fixture" || (echo "Missing review fixture"; exit 1); \
	echo "Review fixture: $$fixture"; \
	echo "Required context:"; \
	echo "1. AGENTS.md"; \
	echo "2. docs/plan/adr/0001-hexagonale-architektur.md"; \
	echo "3. spec/lastenheft.md"; \
	echo "Expected: HIGH, MEDIUM and LOW finding categories"

verify-closure-notes: ## ADR-0011 — Closure-Note-Pflicht fuer done/-Slices pruefen
	@python3 tools/check_closure_notes.py

check-references: ## Kurs §Referenz-Richtung — Spec-Straten ohne ADR/Slice-Abwaertszeiger, keine superseded-ADR-Referenzen
	@python3 tools/check_references.py

verify-slice: ## Slice-DoD plausibilisieren: make verify-slice SLICE=slice-009
	@test -n "$(SLICE)" || (echo "Usage: make verify-slice SLICE=slice-009"; exit 2)
	@slice_path=$$(find docs/plan/planning -name "$(SLICE)*.md" -print -quit); \
	test -n "$$slice_path" || (echo "Slice not found: $(SLICE)"; exit 1); \
	grep -q "Definition of Done" "$$slice_path" || (echo "Missing Definition of Done: $$slice_path"; exit 1); \
	grep -Eq "LH-|ADR-" "$$slice_path" || (echo "Missing traceability ID: $$slice_path"; exit 1); \
	grep -q "make gates" "$$slice_path" || (echo "Missing gates evidence in DoD: $$slice_path"; exit 1); \
	echo "verify-slice ok: $$slice_path"

verify: verify-closure-notes check-references ## Verifikation: Closure-Pflicht + Referenz-Richtung immer, Slice-DoD wenn SLICE gesetzt
	@if [ -n "$(SLICE)" ]; then $(MAKE) verify-slice SLICE=$(SLICE); fi

replay: ## Golden-Set-Replay-Verzeichnis validieren: make replay RUN=welle-1-baseline
	@set -e; \
	base="evals/golden/$(RUN)"; \
	if [ ! -f "$$base/manifest.yaml" ]; then echo "Manifest fehlt: $$base/manifest.yaml"; exit 1; fi; \
	if [ ! -d "$$base/inputs" ]; then echo "inputs/ fehlt: $$base/inputs"; exit 1; fi; \
	if [ ! -d "$$base/expectations" ]; then echo "expectations/ fehlt: $$base/expectations"; exit 1; fi; \
	grep -q "^model:" "$$base/manifest.yaml" || { echo "manifest.yaml: model-Block fehlt"; exit 1; }; \
	grep -q "^runtime:" "$$base/manifest.yaml" || { echo "manifest.yaml: runtime-Block fehlt"; exit 1; }; \
	in_count=$$(find "$$base/inputs" -maxdepth 1 -name 'case-*.json' | wc -l); \
	exp_count=$$(find "$$base/expectations" -maxdepth 1 -name 'case-*.json' | wc -l); \
	if [ "$$in_count" -lt 3 ]; then echo "Replay braucht mindestens 3 inputs (Happy/Boundary/Negative), gefunden: $$in_count"; exit 1; fi; \
	if [ "$$in_count" != "$$exp_count" ]; then echo "inputs/expectations-Mismatch: $$in_count vs $$exp_count"; exit 1; fi; \
	echo "replay set ok: $$base ($$in_count cases)"

trace: ## Agentenlauf-Trace-Fixture ausgeben: make trace RUN=sl-009-agent-run
	@test -f "otel/$(RUN).trace.json" || (echo "Trace fixture not found: otel/$(RUN).trace.json"; exit 1)
	@node -e 'const fs=require("fs"); const p="otel/$(RUN).trace.json"; const j=JSON.parse(fs.readFileSync(p,"utf8")); const spans=j.spans||[]; if(spans.length===0) { throw new Error("Trace has no spans"); } console.log("trace fixture ok: " + p + " (" + spans.length + " spans)");'

release: ## Release-Checkliste und Runbook-Fixtures pruefen
	@test -f runbooks/release-checklist.md || (echo "Missing runbooks/release-checklist.md"; exit 1)
	@test -f runbooks/incident-agent-data-loss.md || (echo "Missing incident runbook"; exit 1)
	@grep -q "Trace" runbooks/release-checklist.md || (echo "Release checklist lacks trace evidence"; exit 1)
	@echo "release fixture ok: runbooks present"
