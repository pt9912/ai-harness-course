# DocSearch Go-Skelett — Multi-Stage Build
# LH-QA-03: reproduzierbare Toolchain via pinned Base.

# ---- Stage 1: deps (Lockfile zuerst, Cache-freundlich) ----
FROM golang:1.23-alpine@sha256:383395b794dffa5b53012a212365d40c8e37109a626ca30d6151c8348d380b5f AS deps
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
FROM gcr.io/distroless/static-debian12:nonroot@sha256:d093aa3e30dbadd3efe1310db061a14da60299baff8450a17fe0ccc514a16639
COPY --from=build /out/docsearch /docsearch
USER nonroot:nonroot
ENTRYPOINT ["/docsearch"]
