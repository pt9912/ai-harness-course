# Roadmap — DocSearch

**Format-Regel:** Reihenfolge von **Wellen**, keine Reihenfolge von
Terminen. Daten sind Schätzungen, korrigierbar.

---

## Offene Wellen

*Derivativ* — der Zustand sind die flachen Welle-Dateien unter
`docs/plan/planning/`; woran gerade gearbeitet wird, sagt das `Welle:`-Feld
der Slices in `in-progress/`. Ziel, Trigger und Closure-Kriterien stehen in
der Welle-Datei, nicht hier:

- [wave-qualitaet](../wave-qualitaet.md)

## Nächste Wellen

| Welle | Trigger | Wichtigste Slices | Geschätzter Aufwand |
|---|---|---|---|
| wave-skalierung | wave-qualitaet done | slice-ann-suche (ANN-Suche, bringt ADR-0004), slice-replay-runner (Multi-Sprach-Adapter-Cleanup) | L | <!-- d-check:ignore (ADR entsteht erst in slice-ann-suche) -->
| wave-betrieb | wave-skalierung done | slice-k8s-helm-chart (k8s-Helm-Chart), slice-otel-collector (OTel-Collector) | M |

## Meilensteine

| Meilenstein | Welle(n) | Trigger | Status |
|---|---|---|---|
| M1 — Lauffähiger Stack | wave-mvp | DoD `make gates` grün, ein Lab-Beispiel pro Sprache | erreicht 2026-06-02 — [`../done/wave-mvp-results.md`](../done/wave-mvp-results.md) |
| M2 — Qualitätsschwelle | wave-qualitaet | wave-qualitaet geschlossen (slice-property-tests in `done/`, Property-Suite läuft 100 Generationen) | offen |
| M3 — Skalierbar | wave-skalierung | p95 < 1 s auch bei 100k Einträgen | offen |
| M4 — Produktionsreif | wave-betrieb | Releases, Runbook, OTel-Pipeline | offen |

## Abhängigkeitsgraph

```mermaid
flowchart LR
    W1[wave-mvp<br/>done]
    W2[wave-qualitaet<br/>in progress]
    W3[wave-skalierung<br/>geplant]
    W4[wave-betrieb<br/>geplant]

    W1 --> W2
    W2 --> W3
    W3 --> W4
```

## Abgeschlossene Wellen

| Welle | Abschluss | Closure-Notiz |
|---|---|---|
| wave-mvp | 2026-06-02 | [`../done/wave-mvp-results.md`](../done/wave-mvp-results.md) |

## Historische Trigger-Verschiebungen

| Datum | Was wurde geändert? | Warum? |
|---|---|---|
| 2026-05-22 | Welle-1-Schließung verschoben | slice-007 (Top-K-Boundary) erforderte LH-Update (v0.2.0) — Spec-Lücke aus Steering Loop |
