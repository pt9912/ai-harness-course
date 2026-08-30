# Kurs-Validatoren — reproduzierbare, dependency-freie Node-Skripte.
# Vorbild: euler-fourier-hilbert/tools/.
#
# Hermetischer Prueflauf (Modul 14 §Der Prueflauf ist hermetisch): Der
# Pruefgegenstand — das Kurs-Repo — wandert per COPY ins Image, kein
# Bind-Mount. Build-Kontext ist deshalb die Repo-Wurzel, nicht `tools/`:
#
#   docker build -f tools/Dockerfile --target repo -t course-gates .
#   docker run --rm --network none course-gates node /usr/local/bin/docs-check.js
#
# Die beiden `*-gate`-Stages sind dieselbe Pruefung in der Gate-Rolle: Ihr Bau
# schlaegt fehl, wenn der Validator rot ist (Modul 13, Gate und Beleg).

FROM node:22-alpine AS base
WORKDIR /work
COPY tools/docs-check.js tools/alignment-check.js /usr/local/bin/
RUN node --check /usr/local/bin/docs-check.js \
 && node --check /usr/local/bin/alignment-check.js \
 && chmod +x /usr/local/bin/docs-check.js /usr/local/bin/alignment-check.js

# --- repo: der Pruefgegenstand liegt ab hier im Image ---
FROM base AS repo
COPY . /work

# --- Gate-Rollen ---
FROM repo AS docs-check-gate
RUN node /usr/local/bin/docs-check.js

FROM repo AS alignment-check-gate
RUN node /usr/local/bin/alignment-check.js
