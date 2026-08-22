# Roadmap — DocSearch

**Status:** Aktiv. **Letzte Änderung:** 2026-08-22.

**Format-Regel:** Reihenfolge von **Wellen**, keine Reihenfolge von
Terminen. Daten sind Schätzungen, korrigierbar.

---

## Offene Wellen

*Derivativ* — der Zustand sind die flachen Welle-Dateien unter
`docs/plan/planning/`; woran gerade gearbeitet wird, sagt das `Welle:`-Feld
der Slices in `in-progress/`. Ziel, Trigger und Closure-Kriterien stehen in
der Welle-Datei, nicht hier:

- [welle-2-qualitaet](../welle-2-qualitaet.md)

## Nächste Wellen

| Welle | Trigger | Wichtigste Slices | Geschätzter Aufwand |
|---|---|---|---|
| welle-3-skalierung | welle-2 done | slice-014 (ANN-Suche, bringt ADR-0004), slice-015 (Multi-Sprach-Adapter-Cleanup) | L | <!-- d-check:ignore (ADR entsteht erst in slice-014) -->
| welle-4-betrieb | welle-3 done | slice-016 (k8s-Helm-Chart), slice-017 (OTel-Collector) | M |

## Meilensteine

| Meilenstein | Welle(n) | Trigger | Status |
|---|---|---|---|
| M1 — Lauffähiger Stack | welle-1-mvp | DoD `make gates` grün, ein Lab-Beispiel pro Sprache | erreicht 2026-06-02 — [`../done/welle-1-results.md`](../done/welle-1-results.md) |
| M2 — Qualitätsschwelle | welle-2-qualitaet | welle-2-qualitaet geschlossen (slice-013 in `done/`, Property-Suite läuft 100 Generationen) | offen |
| M3 — Skalierbar | welle-3-skalierung | p95 < 1 s auch bei 100k Einträgen | offen |
| M4 — Produktionsreif | welle-4-betrieb | Releases, Runbook, OTel-Pipeline | offen |

## Abhängigkeitsgraph

```mermaid
flowchart LR
    W1[welle-1-mvp<br/>done]
    W2[welle-2-qualitaet<br/>in progress]
    W3[welle-3-skalierung<br/>geplant]
    W4[welle-4-betrieb<br/>geplant]

    W1 --> W2
    W2 --> W3
    W3 --> W4
```

## Abgeschlossene Wellen

| Welle | Abschluss | Closure-Notiz |
|---|---|---|
| welle-1-mvp | 2026-06-02 | [`../done/welle-1-results.md`](../done/welle-1-results.md) |

## Historische Trigger-Verschiebungen

| Datum | Was wurde geändert? | Warum? |
|---|---|---|
| 2026-05-22 | Welle-1-Schließung verschoben | slice-007 (Top-K-Boundary) erforderte LH-Update (v0.2.0) — Spec-Lücke aus Steering Loop |
