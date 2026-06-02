# Spezifikation — DocSearch

**Status:** Aktiv. **Letzte Änderung:** 2026-06-02.

**Bezug zum Lastenheft:** Diese Spezifikation präzisiert die in
[`lastenheft.md`](lastenheft.md) formulierten Anforderungen (`LH-*`-IDs).
Bei Konflikt gewinnt das Lastenheft.

---

## 1. Algorithmen und Datenflüsse

### LH-FA-01.a — Indexierung

**Eingabe:** Pfad zu Markdown-Verzeichnis.
**Ausgabe:** Persistierter Vektor-Index in `data/index/`.

**Schritte:**

1. Verzeichnis rekursiv scannen, alle `*.md`-Dateien lesen.
2. Pro Datei: Text in Abschnitte zerlegen (Trennung an `##`-Heading-Zeilen, erste Section vor erstem `##` zählt als Intro).
3. Pro Abschnitt: Embedding berechnen via Embedding-Adapter (siehe ADR-0002).
4. Vektor + Metadaten (`doc_path`, `section_title`, `section_index`) als Tupel speichern.
5. Index speichern (Format gemäß ADR-0003).
6. Antwort `{"indexed_docs": <count>, "indexed_sections": <count>}` zurückgeben.

**Komplexität:** O(n) in Anzahl Abschnitte, dominiert durch
Embedding-Latenz (≈ 50 ms / Abschnitt).

**Fehlermodi:**

- Verzeichnis existiert nicht → `E001`.
- Embedding-Adapter nicht erreichbar → `E003`, Reindex bricht ab, partieller Index wird *nicht* gespeichert (Atomic-Replace).

### LH-FA-02.a — Suche

**Eingabe:** Suchanfrage `q`, Top-K `k`.
**Ausgabe:** Sortierte Liste von Treffern.

**Schritte:**

1. Eingabe validieren: `q != ""` → sonst `E002`.
2. `k = min(k, MAX_TOPK)`. Wenn geklemmt: Response-Header `X-Topk-Clamped: <MAX_TOPK>`.
3. Embedding für `q` berechnen.
4. Cosinus-Ähnlichkeit zwischen `q`-Embedding und allen Index-Einträgen berechnen.
5. Top `k` nach Score sortieren. **Tie-Break:** bei gleichem Score nach `(doc_path, section_index)` lexikographisch (deterministisch, siehe LH-QA-02).
6. Antwort `{"results": [{"doc": ..., "section": ..., "score": ...}, ...]}` zurückgeben.

**Komplexität:** O(n) in Anzahl Index-Einträge. Optimierung über
Approximate-NN (ANN) ist in Welle 3 geplant — aktuell linear.

## 2. Datenstrukturen und Schemas

### IndexEntry

```json
{
  "doc_path": "string (relative path)",
  "section_index": "uint",
  "section_title": "string",
  "embedding": "float32[EMBEDDING_DIM]",
  "section_text": "string (max SECTION_MAX_CHARS)"
}
```

### Search-Request

```json
{
  "q": "string (1..QUERY_MAX_CHARS)",
  "k": "uint (1..MAX_TOPK*100, wird geklemmt)"
}
```

### Search-Response

```json
{
  "results": [
    {
      "doc": "string",
      "section": "string",
      "score": "float (cosine, -1..1)"
    }
  ]
}
```

## 3. Defaults und Konstanten

| Name | Wert | Begründung | ADR |
|---|---|---|---|
| `EMBEDDING_DIM` | 1024 | Vorgegeben durch Modell aus ADR-0002. | ADR-0002 |
| `MAX_TOPK` | 100 | Lasttest-Grenze, höher → p95 reißt LH-QA-01. | ADR-0001 |
| `SECTION_MAX_CHARS` | 4000 | Embedding-Modell-Kontext-Fenster. | ADR-0002 |
| `QUERY_MAX_CHARS` | 1000 | UX + Embedding-Grenzen. | — |
| `USER_HASH_SALT` | aus `config/secrets.env`, niemals im Repo. | DSGVO + LH-QA-04. | ADR-0001 |
| `INDEX_STORAGE` | `data/index/index.bin` | Format-Wahl in ADR-0003. | ADR-0003 |

## 4. Fehler-Codes und Logging-Felder

| Code | Bedingung | Aktion |
|---|---|---|
| E001 | Verzeichnis existiert nicht (Indexierung) | HTTP 400, Log `event=reindex_error` |
| E002 | Leere Suchanfrage | HTTP 400, Log `event=search_invalid` |
| E003 | Embedding-Adapter nicht erreichbar | HTTP 503, Log `event=embedding_unavailable`, Index bleibt unverändert |
| E099 | Unklassifizierter interner Fehler | HTTP 500, Log `event=internal_error`, Stack-Trace nur in `LOG_LEVEL=debug` |

## 5. Metriken und Tracing-Felder

| Span | Pflicht-Attribute | Quelle |
|---|---|---|
| `docsearch.reindex` | `indexed_docs`, `indexed_sections`, `duration_ms`, `embedding_calls` | LH-FA-01 |
| `docsearch.search` | `q_hash`, `k`, `k_clamped`, `result_count`, `duration_ms`, `top_score` | LH-FA-02 |
| `docsearch.embedding` | `model`, `cache_hit`, `tokens`, `duration_ms`, `cost_usd_estimate` | ADR-0002 |
| `docsearch.audit` | `event`, `user_id_hash`, `q_hash`, `result_count`, `latency_ms` | LH-FA-03 |

## 6. Externe Verträge

| System | Version | Vertrag-Datei |
|---|---|---|
| Embedding-Modell | siehe ADR-0002, gepinnt im Adapter | `internal/embedding/contract.md` (sprach-spezifisch) |
| Vektor-Storage | Custom Binary v1 | `internal/index/format.md` |

## 7. Historie

| Datum | Änderung | ADR |
|---|---|---|
| 2026-05-15 | Initial | — |
| 2026-05-22 | `MAX_TOPK = 100` ergänzt | ADR-0001 |
| 2026-06-01 | `docsearch.audit`-Span ergänzt | LH-FA-03 |
