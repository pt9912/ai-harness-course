# DocSearch C# — Multi-Stage

FROM mcr.microsoft.com/dotnet/sdk:10.0@sha256:548d93f8a18a1acbe6cc127bc4f47281430d34a9e35c18afa80a8d6741c2adc3 AS build
WORKDIR /src
COPY global.json Directory.Build.props Directory.Packages.props DocSearch.sln ./
COPY src ./src
COPY tests ./tests
RUN dotnet restore DocSearch.sln && \
    dotnet publish src/DocSearch/DocSearch.csproj \
        -c Release -r linux-x64 --self-contained false \
        /p:UseAppHost=true -o /app

FROM mcr.microsoft.com/dotnet/runtime:10.0-azurelinux3.0-distroless@sha256:30a8c40c480930bdb3e9f01870f5ab742679982134807c780b4671af5a5c4959
COPY --from=build /app /app
USER 65532:65532
ENTRYPOINT ["/app/DocSearch"]
