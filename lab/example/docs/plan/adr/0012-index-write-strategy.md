# ADR-0012: Index-Write-Strategie (Temp-File + Atomic Rename)

**Status:** Accepted

**Datum:** 2026-06-02

**Autor:** Kurs-Lab

**Bezug:** [LH-FA-IDX-003](../../../spec/lastenheft.md#lh-fa-idx-003--index-schreib-idempotenz-und-atomarität) (Index-Schreib-Idempotenz und Atomarität),
[ADR-0003](0003-index-storage-format.md) (Index-Storage-Format)

**Schärft:** [`spezifikation.md` §1](../../../spec/spezifikation.md#1-algorithmen-und-datenflüsse) (Atomic-Replace / Schreib-Semantik)
und [`architecture.md` §5](../../../spec/architecture.md#5-fehlermodelle-und-resilienz) (Atomic-Replace).

---

## Kontext

LH-FA-IDX-003 verlangt **Idempotenz** (gleiche Eingabe → gleicher
Index-Hash) und **Atomarität** (kein halb geschriebener Index ist
beobachtbar). Das Index-Storage-Format aus ADR-0003 (Custom Binary v1)
ist eine einzige Datei `internal/index/store.bin`. Naive Schreib-
Strategie (Datei öffnen, im Loop schreiben, schließen) verletzt beides:
ein Crash mitten im Schreiben hinterlässt eine Datei mit Header der
neuen Generation, aber Body der alten — der Service startet mit
inkonsistentem Index.

## Entscheidung

Index-Schreiben läuft über **Temp-File + Atomic Rename**:

1. Schreibe vollständigen Index nach `internal/index/.store.tmp.<PID>.<UUID>`.
2. `fsync(2)` auf das Temp-File.
3. `rename(2)` von Temp-Pfad nach `internal/index/store.bin`.
4. `fsync(2)` auf das Verzeichnis (POSIX: persistiert den Verzeichnis-
   Eintrag, sonst kann der Rename nach Crash verloren gehen).

Diese vier Schritte sind unteilbar gegenüber externen Beobachtern: ein
Reader sieht entweder den alten oder den neuen Index, nie einen
gemischten Zustand. Idempotenz folgt aus dem deterministischen
Serialisierungs-Format (ADR-0003) plus deterministischem Tie-Break
(slice-009).

## Verglichene Alternativen

### Option A — Direkt-Schreiben in `store.bin`

- Pro: Eine Datei-Operation weniger.
- Contra: Verletzt Atomarität bei Crash. Verletzt Idempotenz, wenn der
  zweite Lauf einen alten Header noch nicht überschrieben hat.

### Option B — Write-Ahead-Log

- Pro: Robuster für sehr große Indizes.
- Contra: Overkill für die Lab-Größenordnung (< 10.000 Dokumente);
  zweite Datei verdoppelt die Verifikations-Komplexität.

### Option C — Temp-File + Atomic Rename (gewählt)

- Pro: POSIX-garantiert atomar auf demselben Dateisystem; eine zusätzliche
  `fsync(2)`-Zeile pro Schreibvorgang.
- Pro: Idempotenz testbar via Hash-Vergleich zweier aufeinander folgender Läufe.
- Contra: Temp-Files können nach Crash zurückbleiben — Aufräum-Routine
  beim Service-Start nötig (löscht alle `.store.tmp.*`).

## Konsequenzen

- Positiv: `make test-determinism` (slice-009) wird zur Verifikation
  *auch* von LH-FA-IDX-003 — bit-identischer Index nach zwei Läufen.
- Positiv: Crash-Recovery braucht keinen separaten Repair-Pfad.
- Negativ: Schreib-Latenz steigt um ~5–10 ms pro `make reindex` durch
  die `fsync(2)`-Calls. Akzeptabel; Reindex ist kein Hot Path.
- Folgepflicht: Fitness Function für die Existenz der Rename-Sequenz im
  Writer-Code (siehe unten).

## Fitness Function

| Tooling | Regel | Make-Target |
|---|---|---|
| Architekturtest pro Sprache | `writer.write_index` ruft `rename`/`Files.move(REPLACE_EXISTING)`/`File.Move` *nach* `fsync` auf; *kein* direkter Write auf `store.bin`. | `make arch-check` |
| Property-Test (slice-013) | Zwei aufeinander folgende `writer.write_index`-Aufrufe mit gleicher Eingabe produzieren identischen SHA-256-Hash. | `make test` |

## Re-Evaluierungs-Trigger

- Wenn DocSearch zu Multi-Writer übergeht (Cluster), bricht die
  Single-Writer-Annahme — neue ADR (vermutlich Write-Ahead-Log oder
  Append-Only-Segments).
- Wenn das Dateisystem `rename(2)`-Atomarität nicht garantiert (z. B.
  einige Cloud-Block-Stores) — dann Fallback auf "Schreibe in S3-Object
  mit If-None-Match" oder vergleichbar.

## Geschichte

| Datum | Ereignis | Verweis |
|---|---|---|
| 2026-06-02 | Proposed | Modul 15 Worked Example, Welle-9-Lab-Ausbau |
| 2026-06-02 | Accepted | LH-FA-IDX-003 ergänzt, Trace-Fixture um writer.write_index Span erweitert |
