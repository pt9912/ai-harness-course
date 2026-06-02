# ADR-0003: Index-Storage-Format Custom Binary v1

**Status:** Accepted

**Datum:** 2026-05-29

**Autor:** Kurs-Lab

**Bezug:** LH-QA-01, LH-QA-02

---

## Kontext

DocSearch persistiert den Vektor-Index zwischen Reindex und Start.
Wahl-Punkte: Format, Atomic-Replace-Strategie, Mmap-Fähigkeit.

## Entscheidung

Wir wählen **Custom Binary Format v1** mit Atomic-Replace und
optionalem Mmap.

Datei: `data/index/index.bin`.

Struktur:

```
[8 bytes  magic: "DSIDX001"]
[4 bytes  format_version: uint32]
[4 bytes  embedding_dim: uint32]
[8 bytes  entry_count: uint64]
[entry × entry_count]
  [4 bytes  doc_path_len: uint32]
  [N bytes  doc_path]
  [4 bytes  section_title_len]
  [N bytes  section_title]
  [4 bytes  section_index: uint32]
  [4 bytes  section_text_len]
  [N bytes  section_text]
  [embedding_dim × 4 bytes  embedding: float32[]]
```

Atomic-Replace: schreiben in `index.bin.new`, dann `rename` über
`index.bin`. Bei Crash: `index.bin.new` bleibt liegen und wird beim
nächsten Start verworfen.

## Verglichene Alternativen

### Option A — JSON Lines

- Pro: Trivial, debugbar.
- Contra: 3-5× Speicher-Overhead, parsing-Latenz spürbar bei 80k Einträgen.

### Option B — SQLite

- Pro: Volltext-Suche zusätzlich kostenlos, ACID.
- Contra: Vektor-Suche braucht Extension; Mmap-Behaviour komplex.

### Option C — Lance / Parquet

- Pro: Industrie-Standard, Tooling.
- Contra: Schwere Dependency für ein Beispiel-Lab.

### Option D — Custom Binary v1 (gewählt)

- Pro: Kompakt, schnell, Mmap-fähig, kein externer Code. Lehrwert: Studierende sehen das Format.
- Contra: Eigenes Code-Pfad, Migrations-Pflicht bei Format-Erweiterung.

## Konsequenzen

- Positiv: Cold-Start unter 100 ms für 80k Einträge. p95-Budget (LH-QA-01) hat Reserve.
- Negativ: Format-Migration v1 → v2 ist eigener Slice mit Schreib/Lese-Adapter.
- Folgepflicht: `magic` und `format_version` müssen bei jedem Read geprüft werden. Mismatch → `E099` mit klarem Fehler.

## Fitness Function

| Tooling | Regel | Make-Target |
|---|---|---|
| Test | Roundtrip-Test: Index schreiben → lesen → Inhalt identisch. | `make test` |
| Determinismus-Test | Zwei Reindex-Läufe gleicher Quelle erzeugen byte-identische Index-Dateien (siehe LH-QA-02). | `make test-determinism` |

## Re-Evaluierungs-Trigger

- Wenn Index-Größe > 1 GB erwartet wird (Mmap-Charakteristik überprüfen).
- Wenn Approximate-NN-Suche eingeführt wird (Welle 3) und einen anderen Index-Layout erfordert.

## Geschichte

| Datum | Ereignis | Verweis |
|---|---|---|
| 2026-05-29 | Proposed | slice-010 |
| 2026-05-29 | Accepted | PR slice-010 |
