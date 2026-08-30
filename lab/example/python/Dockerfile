# DocSearch Python-Skelett — Multi-Stage
# LH-QA-03 + AGENTS.md §P-3 (Docker-only, kein lokales pip).
#
# Bauform nach Modul 14 §Der Prueflauf ist hermetisch: Die Quellen wandern per
# COPY ins Image, kein Bind-Mount. Jede Pruefung gibt es zweimal — als *Gate*
# (Exit != 0 bricht den Build) und als *Beleg* (`|| true`, schreibt nach /out).
# `export` sammelt die Belege ein und erbt von `repo`, nicht von einem Gate:
# ein roter Gate darf das Werkzeug nicht unbaubar machen (Modul 13).

FROM python:3.12-slim@sha256:2eb3cdf88d45b1c304d593dfe77f431e00ca13c6e707416a259ed3987d5c6aa8 AS deps
WORKDIR /src
COPY pyproject.toml ./
RUN pip install --no-cache-dir uv==0.4.0 && \
    uv pip install --system --no-cache .

# ---- tools: Pruefwerkzeuge, gepinnt; getrennt von den Quellen, damit der
#      Layer-Cache ueber Code-Aenderungen haelt.
FROM deps AS tools
RUN pip install --no-cache-dir \
        ruff==0.6.0 mypy==1.11.0 import-linter==2.0 pytest pytest-cov pytest-repeat

# ---- repo: der Pruefgegenstand ist ab hier Teil des Images.
FROM tools AS repo
COPY . /src

FROM repo AS build
RUN python -m compileall src/

# ---- ausfuehrende Stages: je Pruefung ein Gate und ein Beleg -----------------
FROM repo AS lint-gate
RUN ruff check .

FROM repo AS lint-report
RUN mkdir -p /out/lint && ruff check . > /out/lint/findings.txt 2>&1 || true

FROM repo AS typecheck-gate
RUN mypy --strict src/

FROM repo AS arch-gate
RUN PYTHONPATH=src lint-imports --config importlinter.cfg --no-cache

FROM repo AS test-gate
RUN pytest -q

FROM repo AS coverage-gate
RUN pytest -q --cov=src/docsearch --cov-report=term --cov-fail-under=70

FROM repo AS coverage-report
RUN mkdir -p /out/coverage && \
    pytest -q --cov=src/docsearch --cov-report=term --cov-report=xml:/out/coverage/coverage.xml \
        > /out/coverage/summary.txt 2>&1 || true

# ---- export: Sammelstelle und Rueckweg ueber stdout.
# Kein ENTRYPOINT: Er wuerde jedem `docker run <image> <werkzeug>` seine
# Argumente unterschieben und aus einem Gate-Aufruf still einen tar-Lauf
# machen — ein behauptetes Gate (Modul 13). Der Rueckweg steht stattdessen
# ausgeschrieben im Makefile-Target `export`.
FROM repo AS export
COPY --from=lint-report /out /out
COPY --from=coverage-report /out /out

# ---- runtime: das ausgelieferte Image.
FROM python:3.12-slim@sha256:2eb3cdf88d45b1c304d593dfe77f431e00ca13c6e707416a259ed3987d5c6aa8 AS runtime
WORKDIR /app
COPY --from=build /src/src/docsearch /app/docsearch
COPY --from=build /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
RUN useradd --uid 65532 --no-create-home nonroot
USER nonroot
ENTRYPOINT ["python", "-m", "docsearch"]
