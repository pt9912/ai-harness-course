/**
 * Domain-Modell, Pure. ADR-0001 Layer 1.
 */
package com.example.docsearch.types;

public final class Types {
    private Types() { }

    public static final int EMBEDDING_DIM = 1024;
    public static final int MAX_TOPK = 100;

    /** IndexEntry — Vektor + Metadaten. */
    public record IndexEntry(
        String docPath,
        String sectionTitle,
        int sectionIndex,
        String sectionText,
        float[] embedding
    ) {
        public IndexEntry {
            if (embedding.length != EMBEDDING_DIM) {
                throw new IllegalArgumentException("embedding must have " + EMBEDDING_DIM + " dimensions");
            }
        }
    }

    /** SearchResult — Treffer. */
    public record SearchResult(String doc, String section, float score) { }

    /** SearchRequest — Anfrage. */
    public record SearchRequest(String q, int k) { }
}
