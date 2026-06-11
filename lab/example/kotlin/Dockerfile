# DocSearch Kotlin-Skelett — Multi-Stage

FROM gradle:8.10-jdk21@sha256:963d59f7f22767da4efbcf46b661361b61af5fb88b0309da1071c4234c647eba AS build
WORKDIR /src
COPY settings.gradle.kts build.gradle.kts ./
COPY src ./src
COPY config ./config
RUN gradle --no-daemon installDist

FROM gcr.io/distroless/java21-debian12:nonroot@sha256:7e37784d94dccbf5ccb195c73b295f5ad00cd266512dfbac12eb9c3c28f8077d
COPY --from=build /src/build/install/docsearch /app
USER nonroot
ENTRYPOINT ["/app/bin/docsearch"]
