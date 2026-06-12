# Repo-Root-Targets für die Kurs-Validatoren (tools/).
# Docker-basiert für Reproduzierbarkeit (gleiche Node-Version überall);
# ARGS reicht Flags und Pfade durch:
#   make docs-check ARGS="--verbose kurs/de/"
#   make alignment-check ARGS="--strict"

ARGS ?=

.PHONY: help check docs-check alignment-check

help: ## Targets anzeigen
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-24s %s\n", $$1, $$2}'

check: docs-check alignment-check ## beide Validatoren nacheinander

# Referenz-Checks (Links, Anker, Bilder, Inline-Code-Pfade) via d-check
# (Digest-Pin auf v0.2.0 — braucht das Modul codepaths; Konfiguration
# in .d-check.yml). Der Node-Validator bleibt als Rest-Sensor für die
# kurs-spezifischen Modul-Nummern-Checks.
D_CHECK_IMAGE ?= ghcr.io/pt9912/d-check@sha256:f2e0ac7bd9650fe560058e530c8890a629e2df43b8b2e696e78488794d311846

docs-check: ## Referenzen (d-check) + Modul-Nummern (Rest-Sensor) prüfen
	docker run --rm -v "$(CURDIR)":/repo:ro $(D_CHECK_IMAGE)
	docker build -q -t docs-check --target docs-check tools/
	docker run --rm -v "$(CURDIR)":/work docs-check $(ARGS)

alignment-check: ## Lernziel-Alignment-Prüfschritt (Docker)
	docker build -q -t alignment-check --target alignment-check tools/
	docker run --rm -v "$(CURDIR)":/work alignment-check $(ARGS)
