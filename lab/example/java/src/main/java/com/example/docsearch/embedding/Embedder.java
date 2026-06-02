/**
 * Embedder-Port (ADR-0002).
 */
package com.example.docsearch.embedding;

public interface Embedder {
    float[] embed(String text);
}
