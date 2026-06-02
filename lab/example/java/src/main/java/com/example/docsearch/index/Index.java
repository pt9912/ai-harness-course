/**
 * Index — Vektor-Storage, Cosinus, Tie-Break (AGENTS.md §J-3, slice-009).
 */
package com.example.docsearch.index;

import com.example.docsearch.types.Types;
import com.example.docsearch.types.Types.IndexEntry;
import com.example.docsearch.types.Types.SearchResult;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public final class Index {
    private final List<IndexEntry> entries = new ArrayList<>();

    public void add(IndexEntry e) {
        entries.add(e);
    }

    public int size() {
        return entries.size();
    }

    public List<SearchResult> topK(float[] query, int k) {
        if (k <= 0 || entries.isEmpty()) {
            return List.of();
        }
        int effectiveK = Math.min(k, Types.MAX_TOPK);

        record Scored(IndexEntry e, float score) { }
        List<Scored> scored = new ArrayList<>(entries.size());
        for (IndexEntry e : entries) {
            scored.add(new Scored(e, cosine(query, e.embedding())));
        }
        // Tie-Break: Score absteigend, dann docPath, dann sectionIndex.
        // List.sort ist stable — Comparator macht den Tie-Break trotzdem
        // explizit, weil Stabilität allein nicht reicht, wenn die Eingabe-
        // Reihenfolge wechselt.
        scored.sort(
            Comparator.comparingDouble((Scored s) -> -s.score())
                .thenComparing(s -> s.e().docPath())
                .thenComparingInt(s -> s.e().sectionIndex())
        );

        List<SearchResult> out = new ArrayList<>(effectiveK);
        for (int i = 0; i < effectiveK && i < scored.size(); i++) {
            Scored s = scored.get(i);
            out.add(new SearchResult(s.e().docPath(), s.e().sectionTitle(), s.score()));
        }
        return out;
    }

    private static float cosine(float[] a, float[] b) {
        double dot = 0;
        double na = 0;
        double nb = 0;
        for (int i = 0; i < a.length; i++) {
            dot += a[i] * b[i];
            na += a[i] * a[i];
            nb += b[i] * b[i];
        }
        if (na == 0 || nb == 0) {
            return 0;
        }
        return (float) (dot / (Math.sqrt(na) * Math.sqrt(nb)));
    }
}
