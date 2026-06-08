# Kurs-Validatoren — reproduzierbare, dependency-freie Node-Skripte.
# Vorbild: euler-fourier-hilbert/tools/.
#
# Multi-Stage: eine gemeinsame `base`-Stage kopiert beide Skripte und
# validiert sie zur Build-Zeit (`node --check`); zwei benannte Ziel-Stages
# liefern je ein zweckgebundenes Image mit eigenem ENTRYPOINT.
#
#   docker build -t docs-check       --target docs-check       tools/
#   docker build -t alignment-check  --target alignment-check  tools/
#
# Ohne --target baut Docker die letzte Stage (alignment-check).

FROM node:22-alpine AS base
WORKDIR /work
COPY docs-check.js alignment-check.js /usr/local/bin/
RUN node --check /usr/local/bin/docs-check.js \
 && node --check /usr/local/bin/alignment-check.js \
 && chmod +x /usr/local/bin/docs-check.js /usr/local/bin/alignment-check.js

# --- Ziel-Stage: Markdown-Link-Validator ---
FROM base AS docs-check
ENTRYPOINT ["node", "/usr/local/bin/docs-check.js"]

# --- Ziel-Stage: Alignment-Prüfschritt-Wächter ---
FROM base AS alignment-check
ENTRYPOINT ["node", "/usr/local/bin/alignment-check.js"]
