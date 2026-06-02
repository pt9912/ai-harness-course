# DocSearch Kotlin-Skelett — Multi-Stage

FROM gradle:8.10-jdk21 AS build
WORKDIR /src
COPY settings.gradle.kts build.gradle.kts ./
COPY src ./src
COPY config ./config
RUN gradle --no-daemon installDist

FROM gcr.io/distroless/java21-debian12:nonroot
COPY --from=build /src/build/install/docsearch /app
USER nonroot
ENTRYPOINT ["/app/bin/docsearch"]
