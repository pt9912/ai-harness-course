# harness.mk — generischer Doku-Referenz-Gate via d-check (Digest-Pin v0.23.0).
# Ins Repo-Root kopieren, mit `include harness.mk` ins Makefile einbinden.
# Das .d-check.yml-Startgerüst erzeugt `d-check --print-config`; ids/codepaths
# nach Bedarf einkommentieren (siehe .d-check.yml-Kommentare).
D_CHECK_IMAGE ?= ghcr.io/pt9912/d-check@sha256:68951f5a3dd7ad3404e1996d45327f3df2585c0ef2b0b6bde7ccf790da4ddf6a

.PHONY: docs-check
docs-check: ## Doku-Referenzen prüfen (links/anchors; ids/codepaths laut .d-check.yml)
	docker run --rm -v "$(CURDIR)":/repo:ro $(D_CHECK_IMAGE)
