# DocSearch Go-Skelett — Multi-Stage Build
# LH-QA-03: reproduzierbare Toolchain via pinned Base.

# ---- Stage 1: deps (Lockfile zuerst, Cache-freundlich) ----
FROM golang:1.23-alpine@sha256:383395b794dffa5b53012a212365d40c8e37109a626ca30d6151c8348d380b5f AS deps
WORKDIR /src
COPY go.mod go.sum* ./
RUN go mod download

# ---- tools: Pruefwerkzeuge per COPY --from, nichts installiert ausser dem,
#      was der Race-Detector braucht. Getrennt von den Quellen, damit der
#      Layer-Cache ueber Code-Aenderungen haelt.
FROM deps AS tools
COPY --from=golangci/golangci-lint:v1.62-alpine /usr/bin/golangci-lint /usr/local/bin/golangci-lint
RUN apk add --no-cache gcc musl-dev

# ---- repo: der Pruefgegenstand ist ab hier Teil des Images (Modul 14 §Der
#      Prueflauf ist hermetisch). Kein Bind-Mount.
FROM tools AS repo
COPY . .

# ---- ausfuehrende Stages: je Pruefung ein Gate, dazu ein Beleg ------------
FROM repo AS lint-gate
RUN golangci-lint run ./...

FROM repo AS lint-report
RUN mkdir -p /out/lint && golangci-lint run ./... > /out/lint/findings.txt 2>&1 || true

FROM repo AS typecheck-gate
RUN go vet ./...

FROM repo AS arch-gate
RUN golangci-lint run --disable-all --enable=depguard ./...

FROM repo AS test-gate
RUN CGO_ENABLED=1 go test -race ./...

FROM repo AS coverage-report
RUN mkdir -p /out/coverage \
    && sh scripts/coverage-gate.sh ./... 70 > /out/coverage/summary.txt 2>&1 || true \
    && cp coverage.out /out/coverage/coverage.out 2>/dev/null || true

# ---- export: Sammelstelle; erbt von `repo`, nicht von einem Gate.
#      Der Beleg-Satz ist in allen Skeletten derselbe: lint/findings.txt und
#      coverage/summary.txt, dazu der maschinenlesbare Coverage-Report.
FROM repo AS export
COPY --from=lint-report /out /out
COPY --from=coverage-report /out /out

# ---- Stage 2: build ----
FROM deps AS build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build \
    -trimpath -ldflags="-s -w" \
    -o /out/docsearch ./cmd/docsearch

# ---- Stage: coverage (Gate, hermetisch — coverage.out bleibt im Container) ----
FROM deps AS coverage
COPY . .
ENTRYPOINT ["sh", "scripts/coverage-gate.sh"]

# ---- Stage 3: runtime (Distroless, nonroot) ----
FROM gcr.io/distroless/static-debian12:nonroot@sha256:d093aa3e30dbadd3efe1310db061a14da60299baff8450a17fe0ccc514a16639
COPY --from=build /out/docsearch /docsearch
USER nonroot:nonroot
ENTRYPOINT ["/docsearch"]
