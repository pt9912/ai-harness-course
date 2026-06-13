# Gates. Doc-Gate generisch (harness.mk); Code-Gates (lint/test/build) sind
# repo-spezifisch — Vorbild: lab/example/<lang> im Kurs. Nur existierende,
# laufende Targets in AGENTS.md / harness/README.md eintragen (keine
# halluzinierten Gates, Modul 13). Code-Gates wachsen mit dem Code.
include harness.mk

.PHONY: help gates
help: ## Targets anzeigen
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-14s %s\n", $$1, $$2}'

gates: docs-check ## alle aktuell lauffähigen Gates (Code-Gates ergänzen)
