# Roadmap — DocSearch

**Status:** Aktiv. **Letzte Änderung:** 2026-06-02.

**Format-Regel:** Reihenfolge von **Wellen**, keine Reihenfolge von
Terminen. Daten sind Schätzungen, korrigierbar.

---

## Aktuelle Welle

**Welle-ID:** welle-2-qualitaet
**Start:** 2026-05-29
**Geplantes Ende:** 2026-06-12 (Schätzung)

**Closure-Trigger:**
- slice-013 (Property-Tests) done in allen fünf Sprachen.
- `make fullbuild` grün.
- Replay-Lauf gegen Golden Set grün.

## Nächste Wellen

| Welle | Trigger | Wichtigste Slices | Geschätzter Aufwand |
|---|---|---|---|
| welle-3-skalierung | welle-2 done + ADR-0004 (ANN-Bibliothek) accepted | slice-014 (ANN-Suche), slice-015 (Multi-Sprach-Adapter-Cleanup) | L |
| welle-4-betrieb | welle-3 done | slice-016 (k8s-Helm-Chart), slice-017 (OTel-Collector) | M |

## Meilensteine

| Meilenstein | Welle(n) | Trigger | Status |
|---|---|---|---|
| M1 — Lauffähiger Stack | welle-1-mvp | DoD `make gates` grün, ein Lab-Beispiel pro Sprache | erreicht 2026-05-28 |
| M2 — Qualitätsschwelle | welle-2-qualitaet | Property-Tests + Coverage-Gate hochgeschaltet | offen |
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
| welle-1-mvp | 2026-05-28 | [`../done/welle-1-results.md`](../done/welle-1-results.md) |

## Historische Trigger-Verschiebungen

| Datum | Was wurde geändert? | Warum? |
|---|---|---|
| 2026-05-25 | Welle-1-Schließung um 3 Tage verschoben | slice-007 (Top-K-Boundary) erforderte LH-Update — Spec-Lücke aus Steering Loop |
