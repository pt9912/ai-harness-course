# Spezifikation — DocSearch

**Status:** Aktiv. **Letzte Änderung:** 2026-08-08.

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
3. Pro Abschnitt: Embedding berechnen via Embedding-Adapter (Defaults §3).
4. Vektor + Metadaten (`doc_path`, `section_title`, `section_index`) als Tupel speichern.
5. Index speichern (Format §6).
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

### LH-FA-IDX-003.a — Index-Schreiben

**Eingabe:** Vollständige Liste der `IndexEntry` eines Reindex-Laufs.
**Ausgabe:** Ersetzter Index unter `INDEX_STORAGE`.

**Schritte:**

1. Serialisieren nach `<INDEX_STORAGE>.new.<PID>.<UUID>` — dasselbe
   Verzeichnis wie das Ziel, sonst ist der Rename kein
   dateisystem-interner Vorgang mehr.
2. `fsync` auf die Temp-Datei.
3. `rename` von Temp-Pfad auf `INDEX_STORAGE`.
4. `fsync` auf das Verzeichnis — ohne diesen Schritt kann der
   Verzeichnis-Eintrag nach einem Crash verloren gehen.

**Beobachtbarkeit:** Ein Leser sieht entweder den alten oder den neuen Index,
nie einen gemischten Zustand. **Idempotenz:** Zwei Läufe mit gleicher Eingabe
erzeugen bit-identische Dateien; das folgt aus dem deterministischen
Serialisierungs-Format und dem Tie-Break aus `LH-FA-02.a` Schritt 5.

**Aufräumen:** Beim Service-Start werden Reste `<INDEX_STORAGE>.new*` gelöscht
— mit und ohne PID/UUID-Suffix.

## 2. Datenstrukturen und Schemas

### SPEC-001 — IndexEntry

```json
{
  "doc_path": "string (relative path)",
  "section_index": "uint",
  "section_title": "string",
  "embedding": "float32[EMBEDDING_DIM]",
  "section_text": "string (max SECTION_MAX_CHARS)"
}
```

### SPEC-002 — Search-Request

```json
{
  "q": "string (1..QUERY_MAX_CHARS)",
  "k": "uint (1..MAX_TOPK*100, wird geklemmt)"
}
```

### SPEC-003 — Search-Response

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

| ID | Name | Wert | Begründung |
|---|---|---|---|
| `SPEC-004` | `EMBEDDING_DIM` | 1024 | Vorgegeben durch das Embedding-Modell. |
| `SPEC-005` | `MAX_TOPK` | 100 | Lasttest-Grenze, höher → p95 reißt LH-QA-01. |
| `SPEC-006` | `SECTION_MAX_CHARS` | 4000 | Embedding-Modell-Kontext-Fenster. |
| `SPEC-007` | `QUERY_MAX_CHARS` | 1000 | UX + Embedding-Grenzen. |
| `SPEC-008` | `USER_HASH_SALT` | aus `config/secrets.env`, niemals im Repo. | DSGVO + LH-QA-04. |
| `SPEC-009` | `INDEX_STORAGE` | `data/index/index.bin` | Gewähltes Index-Storage-Format. |

## 4. Fehler-Codes und Logging-Felder

| ID | Code | Bedingung | Aktion |
|---|---|---|---|
| `SPEC-010` | E001 | Verzeichnis existiert nicht (Indexierung) | HTTP 400, Log `event=reindex_error` |
| `SPEC-011` | E002 | Leere Suchanfrage | HTTP 400, Log `event=search_invalid` |
| `SPEC-012` | E003 | Embedding-Adapter nicht erreichbar | HTTP 503, Log `event=embedding_unavailable`, Index bleibt unverändert |
| `SPEC-013` | E099 | Unklassifizierter interner Fehler | HTTP 500, Log `event=internal_error`, Stack-Trace nur in `LOG_LEVEL=debug` |

## 5. Metriken und Tracing-Felder

| ID | Span | Pflicht-Attribute | Quelle |
|---|---|---|---|
| `SPEC-014` | `docsearch.reindex` | `indexed_docs`, `indexed_sections`, `duration_ms`, `embedding_calls` | LH-FA-01 |
| `SPEC-015` | `docsearch.search` | `q_hash`, `k`, `k_clamped`, `result_count`, `duration_ms`, `top_score` | LH-FA-02 |
| `SPEC-016` | `docsearch.embedding` | `model`, `cache_hit`, `tokens`, `duration_ms`, `cost_usd_estimate` | LH-FA-01, LH-FA-02 |
| `SPEC-017` | `docsearch.audit` | `event`, `user_id_hash`, `q_hash`, `result_count`, `latency_ms` | LH-FA-03 |

## 6. Externe Verträge

| ID | System | Version | Vertrag |
|---|---|---|---|
| `SPEC-018` | Embedding-Modell | `local-embed-v3@2026-05-22`, gepinnt im Adapter | Adapter-Signatur im `embedding`-Paket je Sprache |
| `SPEC-019` | Vektor-Storage | Custom Binary v1 | Serialisierungs-Format im `index`-Paket je Sprache |

## 7. Historie

| Datum | Änderung |
|---|---|
| 2026-05-15 | Initial |
| 2026-05-22 | `MAX_TOPK = 100` ergänzt |
| 2026-05-22 | §3 `EMBEDDING_DIM`, `SECTION_MAX_CHARS` festgeschrieben |
| 2026-05-25 | §3 `INDEX_STORAGE`, §6 Vektor-Storage-Format festgeschrieben |
| 2026-05-26 | §1 LH-FA-02.a Schritt 5: Tie-Break präzisiert |
| 2026-06-02 | `docsearch.audit`-Span ergänzt |
| 2026-06-02 | §1 Schreib-Semantik: Atomic-Replace präzisiert |
| 2026-06-03 | Abwärtszeiger auf einen Slice-Plan entfernt (Referenz-Richtung) |
| 2026-08-08 | `SPEC-*`-Kennungen in §2 bis §6 vergeben (Baseline-ID-Schema) |
| 2026-08-08 | §1 `LH-FA-IDX-003.a` ergänzt — die Anforderung hatte keinen Verfeinerungs-Abschnitt |
