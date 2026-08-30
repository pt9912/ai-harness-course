# DocSearch C# — Multi-Stage

FROM mcr.microsoft.com/dotnet/sdk:10.0@sha256:548d93f8a18a1acbe6cc127bc4f47281430d34a9e35c18afa80a8d6741c2adc3 AS build
WORKDIR /src
COPY global.json Directory.Build.props Directory.Packages.props DocSearch.sln ./
COPY src ./src
COPY tests ./tests
RUN dotnet restore DocSearch.sln && \
    dotnet publish src/DocSearch/DocSearch.csproj \
        -c Release --no-restore \
        /p:UseAppHost=true -o /app

# ---- repo: Pruefgegenstand im Image (Modul 14 §Der Prueflauf ist hermetisch).
#      Kein Bind-Mount; jede Gate-Stage ist das Gate, ihr Bau schlaegt fehl,
#      wenn die Pruefung rot ist. Die Beleg-Stages schreiben nach /out.
FROM mcr.microsoft.com/dotnet/sdk:10.0@sha256:548d93f8a18a1acbe6cc127bc4f47281430d34a9e35c18afa80a8d6741c2adc3 AS repo
WORKDIR /src
# Manifeste zuerst (Cache-Schnitt aus Schritt 2), dann der Rest per `COPY .`:
# Eine Allow-List laesst frueher oder spaeter Konfiguration weg — die fehlende
# .editorconfig liess die Analyzer anders urteilen als im Arbeitsbaum. Was
# draussen bleibt, sagt `.dockerignore`.
COPY global.json Directory.Build.props Directory.Packages.props DocSearch.sln ./
COPY src/DocSearch/DocSearch.csproj src/DocSearch/
COPY tests/DocSearch.Tests/DocSearch.Tests.csproj tests/DocSearch.Tests/
RUN dotnet restore DocSearch.sln
COPY . .

FROM repo AS lint-gate
RUN dotnet format DocSearch.sln --verify-no-changes

FROM repo AS lint-report
RUN mkdir -p /out/lint && dotnet format DocSearch.sln --verify-no-changes > /out/lint/findings.txt 2>&1 || true

FROM repo AS typecheck-gate
RUN dotnet build DocSearch.sln -warnaserror /p:RestoreLockedMode=true

FROM repo AS arch-gate
RUN dotnet test DocSearch.sln --filter "FullyQualifiedName~ArchitectureTests"

FROM repo AS test-gate
RUN dotnet test DocSearch.sln

FROM repo AS determinism-gate
RUN dotnet test DocSearch.sln --filter "FullyQualifiedName~DeterminismTests"

FROM repo AS coverage-gate
RUN dotnet test DocSearch.sln \
        /p:CollectCoverage=true /p:CoverletOutputFormat=cobertura \
        '/p:Exclude="[xunit.*]*,[*.Tests]*"' \
        /p:Threshold=70 /p:ThresholdType=line /p:ThresholdStat=total

FROM repo AS critical-coverage-gate
RUN dotnet test DocSearch.sln \
        /p:CollectCoverage=true /p:CoverletOutputFormat=cobertura \
        '/p:Include="[DocSearch]DocSearch.Service.*"' \
        /p:Threshold=90 /p:ThresholdType=line /p:ThresholdStat=total

FROM repo AS coverage-report
RUN mkdir -p /out/coverage \
    && dotnet test DocSearch.sln \
        /p:CollectCoverage=true /p:CoverletOutputFormat=cobertura \
        '/p:Exclude="[xunit.*]*,[*.Tests]*"' \
        /p:CoverletOutput=/out/coverage/coverage.cobertura.xml \
        > /out/coverage/summary.txt 2>&1 || true

# ---- export: Sammelstelle. Der Beleg-Satz ist in allen Skeletten derselbe:
#      lint/findings.txt und coverage/summary.txt, dazu der maschinenlesbare
#      Coverage-Report.
FROM repo AS export
COPY --from=lint-report /out /out
COPY --from=coverage-report /out /out

FROM mcr.microsoft.com/dotnet/runtime:10.0-azurelinux3.0-distroless@sha256:30a8c40c480930bdb3e9f01870f5ab742679982134807c780b4671af5a5c4959
COPY --from=build /app /app
USER 65532:65532
ENTRYPOINT ["/app/DocSearch"]
