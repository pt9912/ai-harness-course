# DocSearch Java-Skelett — Multi-Stage

FROM maven:3.9-eclipse-temurin-21-alpine@sha256:c3b70520630a94abc4bb9d87bb3c6a0bb44f936e0ef1035233727411c7b5b854 AS build
WORKDIR /src
COPY pom.xml checkstyle.xml ./
COPY src ./src
RUN mvn -q package -DskipTests

FROM gcr.io/distroless/java21-debian12:nonroot@sha256:7e37784d94dccbf5ccb195c73b295f5ad00cd266512dfbac12eb9c3c28f8077d
COPY --from=build /src/target/docsearch.jar /app/docsearch.jar
USER nonroot
ENTRYPOINT ["java", "-jar", "/app/docsearch.jar"]
