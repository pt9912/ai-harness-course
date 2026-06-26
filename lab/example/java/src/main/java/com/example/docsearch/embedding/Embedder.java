package com.example.docsearch.embedding;

/**
 * Embedder-Port (ADR-0002).
 */
public interface Embedder {
    float[] embed(String text);
}
