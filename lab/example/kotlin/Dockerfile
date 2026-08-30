# DocSearch Kotlin-Skelett — Multi-Stage

FROM gradle:8.10-jdk21@sha256:963d59f7f22767da4efbcf46b661361b61af5fb88b0309da1071c4234c647eba AS build
WORKDIR /src
COPY settings.gradle.kts build.gradle.kts ./
COPY src ./src
COPY config ./config
RUN gradle --no-daemon installDist

# ---- repo: Pruefgegenstand im Image (Modul 14 §Der Prueflauf ist hermetisch).
#      Konsist verlangt ein git-Repo; im Image ist das ein `git init` ohne
#      Folgen — beim Bind-Mount brauchte es dafuer ein `--tmpfs /src/.git`, das
#      eine root-eigene Huelle im Arbeitsbaum hinterliess.
FROM gradle:8.10-jdk21@sha256:963d59f7f22767da4efbcf46b661361b61af5fb88b0309da1071c4234c647eba AS repo
WORKDIR /src
# `COPY .` statt einer Auswahl — siehe java/Dockerfile. Was draussen bleibt,
# sagt `.dockerignore`.
COPY . .
RUN git init -q /src

FROM repo AS lint-gate
RUN gradle --no-daemon -q detekt

FROM repo AS lint-report
RUN mkdir -p /out/lint && gradle --no-daemon detekt > /out/lint/findings.txt 2>&1 || true

FROM repo AS typecheck-gate
RUN gradle --no-daemon -q compileKotlin compileTestKotlin

FROM repo AS arch-gate
RUN gradle --no-daemon -q test --tests "com.example.docsearch.ArchitectureTest"

FROM repo AS test-gate
RUN gradle --no-daemon -q test

FROM repo AS determinism-gate
RUN gradle --no-daemon -q test --tests "com.example.docsearch.DeterminismTest" -Pdeterminism.iterations=100

FROM repo AS coverage-gate
RUN gradle --no-daemon -q koverVerify

FROM repo AS coverage-report
RUN mkdir -p /out/coverage \
    && gradle --no-daemon koverXmlReport > /out/coverage/summary.txt 2>&1 || true \
    && find build/reports/kover -name "*.xml" -exec cp {} /out/coverage/ \; 2>/dev/null || true

# ---- export: Sammelstelle. Der Beleg-Satz ist in allen Skeletten derselbe:
#      lint/findings.txt und coverage/summary.txt, dazu der maschinenlesbare
#      Coverage-Report.
FROM repo AS export
COPY --from=lint-report /out /out
COPY --from=coverage-report /out /out

FROM gcr.io/distroless/java21-debian12:nonroot@sha256:7e37784d94dccbf5ccb195c73b295f5ad00cd266512dfbac12eb9c3c28f8077d
COPY --from=build /src/build/install/docsearch /app
USER nonroot
ENTRYPOINT ["/app/bin/docsearch"]
