# DocSearch Java-Skelett — Multi-Stage

FROM maven:3.9-eclipse-temurin-21-alpine@sha256:c3b70520630a94abc4bb9d87bb3c6a0bb44f936e0ef1035233727411c7b5b854 AS build
WORKDIR /src
COPY pom.xml checkstyle.xml ./
COPY src ./src
RUN mvn -q package -DskipTests

# ---- repo: der Pruefgegenstand liegt im Image (Modul 14 §Der Prueflauf ist
#      hermetisch). Kein Bind-Mount — und weil Maven seine Abhaengigkeiten beim
#      Build zieht, IST hier jede Gate-Stage das Gate: Ihr Bau schlaegt fehl,
#      wenn die Pruefung rot ist. Die Beleg-Stages schreiben zusaetzlich nach
#      /out und werden von `export` eingesammelt (Modul 13, Gate und Beleg).
FROM maven:3.9-eclipse-temurin-21-alpine@sha256:c3b70520630a94abc4bb9d87bb3c6a0bb44f936e0ef1035233727411c7b5b854 AS repo
WORKDIR /src
# `COPY .` statt einer Auswahl: Was nicht kopiert wird, gilt im hermetischen
# Lauf nicht — eine Allow-List laesst frueher oder spaeter ein Regel-Beiwerk
# weg und aendert damit das Urteil. Was draussen bleibt, sagt `.dockerignore`.
COPY . .

FROM repo AS lint-gate
RUN mvn -q checkstyle:check

FROM repo AS lint-report
RUN mkdir -p /out/lint && mvn checkstyle:check > /out/lint/findings.txt 2>&1 || true

FROM repo AS typecheck-gate
RUN mvn -q compile

FROM repo AS arch-gate
RUN mvn -q test -Dtest=ArchitectureTest

FROM repo AS test-gate
RUN mvn -q test

FROM repo AS determinism-gate
RUN mvn -q test -Dtest=DeterminismTest

FROM repo AS coverage-gate
RUN mvn -q verify

FROM repo AS critical-coverage-gate
RUN mvn -q verify -Pcritical-coverage

FROM repo AS coverage-report
RUN mkdir -p /out/coverage \
    && mvn verify jacoco:report > /out/coverage/summary.txt 2>&1 || true \
    && cp target/site/jacoco/jacoco.xml /out/coverage/ 2>/dev/null || true

FROM repo AS export
COPY --from=lint-report /out /out
COPY --from=coverage-report /out /out

FROM gcr.io/distroless/java21-debian12:nonroot@sha256:7e37784d94dccbf5ccb195c73b295f5ad00cd266512dfbac12eb9c3c28f8077d
COPY --from=build /src/target/docsearch.jar /app/docsearch.jar
USER nonroot
ENTRYPOINT ["java", "-jar", "/app/docsearch.jar"]
