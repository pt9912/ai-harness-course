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

# Referenz-Checks (Links, Anker, Bilder, Inline-Code-Pfade) via d-check:
# das Gate-Fragment `d-check.mk` ist tool-generiert (`d-check --print-mk`,
# v0.51.1) und wird included — kein handgepflegtes Recipe. Re-Pin über
# DCHECK_DIGEST (sticht den Tag von DCHECK_IMAGE); Konfiguration in .d-check.yml.
# Bei d-check-Release neu erzeugen: `d-check --print-mk > d-check.mk`, DCHECK_DIGEST
# neu setzen. Der Node-Validator bleibt Rest-Sensor für die Modul-Nummern-Checks.
DCHECK_DIGEST ?= sha256:fede3d027b2ebc1dd8534460853e57b67cc7a9a182cad2e2138c8eebf7a2d03c
include d-check.mk

# docs-check brückt das tool-generierte `doc-check` (reiner d-check) und hängt
# den Node-Rest-Sensor an; beide Runs hermetisch (--network none).
docs-check: doc-check ## Referenzen (d-check) + Modul-Nummern (Rest-Sensor) prüfen
	docker build -q -t docs-check --target docs-check tools/
	docker run --rm --network none -v "$(CURDIR)":/work docs-check $(ARGS)

alignment-check: ## Lernziel-Alignment-Prüfschritt (Docker)
	docker build -q -t alignment-check --target alignment-check tools/
	docker run --rm -v "$(CURDIR)":/work alignment-check $(ARGS)

# Prüft das AUSGELIEFERTE Artefakt, nicht den Repo-Stand: `make check` sieht die
# Links VOR dem Release-Rewrite, der Workflow zippte danach ungeprüft. Ein
# Rewrite-Fehler oder ein Link, der erst durch das Umschreiben bricht, ginge
# unbemerkt an jeden Adopter. REF=main baut die Vorschau; der Release-Workflow
# ruft dieselben zwei Schritte mit dem Tag auf.
REF ?= main
bundle-build: ## Bundle nach DEST bauen (DEST=<dir> REF=<tag|main>)
	@test -n "$(DEST)" || { echo "DEST fehlt"; exit 2; }
	@mkdir -p "$(DEST)" && chmod 755 "$(DEST)"
	@bash tools/build-bundle.sh "$(DEST)" "$(REF)" >/dev/null

# Prüft ein GEBAUTES Bundle. Die Konfiguration wandert nur für den Lauf hinein
# und wieder heraus — sie gehört nicht ins ausgelieferte ZIP.
bundle-verify: ## Referenzen eines gebauten Bundles prüfen (DEST=<dir>)
	@test -d "$(DEST)" || { echo "DEST=$(DEST) existiert nicht"; exit 2; }
	@cp tools/bundle-d-check.yml "$(DEST)/.d-check.yml"
	@docker run --rm --network none -v "$(abspath $(DEST)):/repo:ro" $(DCHECK_REF); \
	rc=$$?; rm -f "$(DEST)/.d-check.yml"; exit $$rc

bundle-check: ## Bundle bauen und prüfen, in einem Wegwerf-Verzeichnis (REF=<tag|main>)
	@set -e; tmp=$$(mktemp -d); trap 'rm -rf "$$tmp"' EXIT; \
	$(MAKE) -s bundle-build DEST="$$tmp" REF="$(REF)"; \
	$(MAKE) -s bundle-verify DEST="$$tmp"
