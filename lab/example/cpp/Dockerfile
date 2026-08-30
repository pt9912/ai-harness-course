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

# ---- Stage 2: build — kompiliert die Target-Kette (FetchContent zieht doctest).
#      Zugleich die `repo`-Stage im Sinn von Modul 14 §Der Prueflauf ist
#      hermetisch: Quellen UND Build-Verzeichnis liegen im Image, kein
#      Bind-Mount. Dass diese Stage baut, IST der Typecheck-Gate.
FROM toolchain AS build
COPY . .
RUN cmake -S . -B build -DCMAKE_BUILD_TYPE=Release \
    && cmake --build build -j

# ---- ausfuehrende Stages: je Pruefung ein Gate, dazu ein Beleg ------------
FROM build AS lint-gate
RUN bash cmake/suppression-gate.sh \
    && clang-tidy -p build $(find src -name "*.cpp")

FROM build AS lint-report
RUN mkdir -p /out/lint \
    && { bash cmake/suppression-gate.sh; clang-tidy -p build $(find src -name "*.cpp"); } \
        > /out/lint/findings.txt 2>&1 || true

FROM build AS arch-gate
RUN bash cmake/arch-check.sh

FROM build AS test-gate
RUN ctest --test-dir build -R unit --output-on-failure

# ---- coverage: eigener, instrumentierter Build. Er entsteht BEIM
#      Image-Bau, weil FetchContent dabei doctest zieht — der spaetere
#      `docker run` laeuft mit --network none und koennte das nicht.
#      gcovr laeuft dann im Lauf, damit die Zahl jedes Mal sichtbar ist.
FROM toolchain AS coverage
COPY . .
RUN cmake -S . -B /tmp/build-cov -DDOCSEARCH_COVERAGE=ON \
    && cmake --build /tmp/build-cov -j \
    && ctest --test-dir /tmp/build-cov -R unit --output-on-failure

FROM coverage AS coverage-report
RUN mkdir -p /out/coverage \
    && gcovr --root . --filter "src/" --exclude ".*/main\.cpp" \
        --xml /out/coverage/coverage.xml /tmp/build-cov \
        > /out/coverage/summary.txt 2>&1 || true

# ---- export: Sammelstelle; erbt von `build`, nicht von einem Gate.
#      Der Beleg-Satz ist in allen Skeletten derselbe: lint/findings.txt und
#      coverage/summary.txt, dazu der maschinenlesbare Coverage-Report.
FROM build AS export
COPY --from=lint-report /out /out
COPY --from=coverage-report /out /out

# ---- Stage 3: runtime — Distroless cc (libstdc++/libc), nonroot ----
FROM gcr.io/distroless/cc-debian12:nonroot@sha256:b0ae8e989418b458e0f25489bc3be523718938a2b70864cc0f6a00af1ddbd985
COPY --from=build /src/build/src/docsearch /docsearch
USER nonroot:nonroot
ENTRYPOINT ["/docsearch"]
