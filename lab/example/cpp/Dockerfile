# DocSearch C++/CMake-Skelett — Multi-Stage Build.
# LH-QA-03: reproduzierbare Toolchain via pinned Base + gepinnte Deps.
#
# GLIBC-Match: Build-Base ist debian:12 (glibc 2.36) — dieselbe glibc wie
# das Runtime distroless/cc-debian12. Eine neuere Build-glibc (z. B.
# ubuntu:24.04 = 2.39) erzeugt sonst ein Binary, das im älteren Runtime mit
# `GLIBC_2.xx not found` stirbt. Build-glibc <= Runtime-glibc ist Pflicht.
#
# DIGEST-PIN (LH-QA-03): Base-Images per @sha256 gepinnt (reproduzierbarer
# Build; Vorbild ../java/Dockerfile, ../csharp/Dockerfile). Hebung = Digest
# bewusst hochsetzen, mit Begründung im Commit-Body.

# ---- Stage 1: toolchain (deps) — cmake/g++/clang-tidy/gcovr, Cache-Layer ----
FROM debian:12-slim@sha256:96e378d7e6531ac9a15ad505478fcc2e69f371b10f5cdf87857c4b8188404716 AS toolchain
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential cmake git ca-certificates clang-tidy gcovr \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /src

# ---- Stage 2: build — kompiliert die Target-Kette (FetchContent zieht doctest) ----
FROM toolchain AS build
COPY . .
RUN cmake -S . -B build -DCMAKE_BUILD_TYPE=Release \
    && cmake --build build -j

# ---- Stage 3: runtime — Distroless cc (libstdc++/libc), nonroot ----
FROM gcr.io/distroless/cc-debian12:nonroot@sha256:b0ae8e989418b458e0f25489bc3be523718938a2b70864cc0f6a00af1ddbd985
COPY --from=build /src/build/src/docsearch /docsearch
USER nonroot:nonroot
ENTRYPOINT ["/docsearch"]
