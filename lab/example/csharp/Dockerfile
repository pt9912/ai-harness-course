# DocSearch C# — Multi-Stage

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY global.json Directory.Build.props Directory.Packages.props DocSearch.sln ./
COPY src ./src
COPY tests ./tests
RUN dotnet restore DocSearch.sln && \
    dotnet publish src/DocSearch/DocSearch.csproj \
        -c Release -r linux-x64 --self-contained false \
        /p:UseAppHost=true -o /app

FROM mcr.microsoft.com/dotnet/runtime:10.0-cbl-mariner-distroless
COPY --from=build /app /app
USER 65532:65532
ENTRYPOINT ["/app/DocSearch"]
