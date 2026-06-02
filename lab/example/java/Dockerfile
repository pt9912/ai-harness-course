# DocSearch Java-Skelett — Multi-Stage

FROM maven:3.9-eclipse-temurin-21-alpine AS build
WORKDIR /src
COPY pom.xml checkstyle.xml ./
COPY src ./src
RUN mvn -q package -DskipTests

FROM gcr.io/distroless/java21-debian12:nonroot
COPY --from=build /src/target/docsearch.jar /app/docsearch.jar
USER nonroot
ENTRYPOINT ["java", "-jar", "/app/docsearch.jar"]
