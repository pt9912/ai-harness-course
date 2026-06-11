# DocSearch Python-Skelett — Multi-Stage
# LH-QA-03 + AGENTS.md §P-3 (Docker-only, kein lokales pip).

FROM python:3.12-slim@sha256:2eb3cdf88d45b1c304d593dfe77f431e00ca13c6e707416a259ed3987d5c6aa8 AS deps
WORKDIR /src
COPY pyproject.toml ./
RUN pip install --no-cache-dir uv==0.4.0 && \
    uv pip install --system --no-cache .

FROM deps AS build
COPY . .
RUN python -m compileall src/

FROM python:3.12-slim@sha256:2eb3cdf88d45b1c304d593dfe77f431e00ca13c6e707416a259ed3987d5c6aa8 AS runtime
WORKDIR /app
COPY --from=build /src/src/docsearch /app/docsearch
COPY --from=build /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
RUN useradd --uid 65532 --no-create-home nonroot
USER nonroot
ENTRYPOINT ["python", "-m", "docsearch"]
