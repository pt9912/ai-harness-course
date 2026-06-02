# DocSearch Go-Skelett — Multi-Stage Build
# LH-QA-03: reproduzierbare Toolchain via pinned Base.

# ---- Stage 1: deps (Lockfile zuerst, Cache-freundlich) ----
FROM golang:1.23-alpine AS deps
WORKDIR /src
COPY go.mod go.sum* ./
RUN go mod download

# ---- Stage 2: build ----
FROM deps AS build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build \
    -trimpath -ldflags="-s -w" \
    -o /out/docsearch ./cmd/docsearch

# ---- Stage 3: runtime (Distroless, nonroot) ----
FROM gcr.io/distroless/static-debian12:nonroot
COPY --from=build /out/docsearch /docsearch
USER nonroot:nonroot
ENTRYPOINT ["/docsearch"]
