# Architektur — DocSearch

**Status:** Aktiv. **Letzte Änderung:** 2026-06-02.

**Hard Rule:** Diese Datei enthält *keine* Wellen, Slices, Commit-Hashes
oder Closure-Daten. Die zeitliche Schicht lebt in
[`../docs/plan/planning/in-progress/roadmap.md`](../docs/plan/planning/in-progress/roadmap.md).

---

## 1. Komponenten-Übersicht

```mermaid
flowchart TB
    UI[UI / HTTP-API]
    Service[Service-Layer<br/>Reindex · Search]
    Index[Index-Layer<br/>Vektor-Storage]
    Embedding[Embedding-Adapter<br/>LLM-Client]
    Audit[Audit-Layer<br/>OTel-Spans]
    Types[Types · Domain-Modell]

    UI --> Service
    Service --> Index
    Service --> Embedding
    Service --> Audit
    Index --> Types
    Embedding --> Types
    Service --> Types
```

## 2. Schichten und Constraints

| Schicht | Verantwortlichkeit | Darf importieren | Darf NICHT importieren | ADR |
|---|---|---|---|---|
| Types | Domain-Modell (Pure), keine I/O | — | alle anderen | ADR-0001 |
| Index | Vektor-Storage, Cosinus-Berechnung | Types | Service, UI, Embedding | ADR-0001, ADR-0003 |
| Embedding | LLM-Adapter, Caching | Types | Service, UI, Index | ADR-0001, ADR-0002 |
| Audit | OTel-Spans, Log-Formatter | Types | Service, UI | ADR-0001 |
| Service | Geschäftslogik (Reindex, Search) | Types, Index, Embedding, Audit | UI | ADR-0001 |
| UI | HTTP-Handler, Input-Validierung | Service, Types | Index, Embedding, Audit direkt | ADR-0001 |

**Konsequenz:** Service ist der einzige "Sammler". UI darf weder Index
noch Embedding direkt aufrufen — alle Quereinstiege gehen über
Service.

## 3. Externe Abhängigkeiten

| System | Rolle | ADR | Substituierbarkeit |
|---|---|---|---|
| Embedding-Modell | Embedding-Erzeugung | ADR-0002 | Adapter-Pattern: Modell-Wechsel ohne Service-Änderung |
| Object Storage (optional) | Index-Persistenz | ADR-0003 | Lokales Filesystem vs. S3-API |

## 4. Sequenz-Diagramme

### Use-Case: LH-FA-02 — Suche

```mermaid
sequenceDiagram
    participant Client
    participant UI
    participant Service
    participant Embedding
    participant Index
    participant Audit

    Client->>UI: POST /search {q, k}
    UI->>Service: search(q, k)
    Service->>Embedding: embed(q)
    Embedding-->>Service: vector
    Service->>Index: topK(vector, k)
    Index-->>Service: results
    Service->>Audit: span(search, attrs)
    Service-->>UI: results
    UI-->>Client: 200 {results}
```

### Use-Case: LH-FA-01 — Indexierung

```mermaid
sequenceDiagram
    participant Client
    participant UI
    participant Service
    participant Embedding
    participant Index

    Client->>UI: POST /reindex
    UI->>Service: reindex()
    Service->>Service: read docs/*.md
    loop pro Abschnitt
        Service->>Embedding: embed(section)
        Embedding-->>Service: vector
    end
    Service->>Index: atomicReplace(entries)
    Index-->>Service: {indexed_docs, indexed_sections}
    Service-->>UI: counts
    UI-->>Client: 200 {indexed_docs, indexed_sections}
```

## 5. Fehlermodelle und Resilienz

| Fehlerquelle | Behandlung-Schicht | Logging |
|---|---|---|
| Verzeichnis fehlt (Reindex) | UI → 400 E001 | `event=reindex_error` |
| Embedding-Adapter Timeout | Service → 503 E003 (Index unverändert) | `event=embedding_unavailable` |
| Index-Read-Fehler | Service → 500 E099 | `event=internal_error` |

**Atomic-Replace:** Reindex schreibt in `data/index/index.bin.new` und
ersetzt erst nach erfolgreichem Schreiben. Damit bleibt der alte Index
bei jedem Fehler intakt.

## 6. ADR-Index

- [ADR-0001](../docs/plan/adr/0001-hexagonale-architektur.md) — Hexagonale Architektur mit Layering
- [ADR-0002](../docs/plan/adr/0002-modellwahl-embedding.md) — Modellwahl für Embedding (mit Adapter-Pattern)
- [ADR-0003](../docs/plan/adr/0003-index-storage-format.md) — Index-Storage-Format (Custom Binary v1)
