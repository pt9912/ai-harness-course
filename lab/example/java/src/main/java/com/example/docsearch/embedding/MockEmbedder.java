/**
 * Deterministisches Pseudo-Embedding (LH-QA-02).
 */
package com.example.docsearch.embedding;

import com.example.docsearch.types.Types;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public final class MockEmbedder implements Embedder {
    @Override
    public float[] embed(String text) {
        final byte[] digest;
        try {
            digest = MessageDigest.getInstance("SHA-256").digest(text.getBytes(StandardCharsets.UTF_8));
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 unavailable", e);
        }
        long seed = 0L;
        for (int i = 0; i < 8; i++) {
            seed = (seed << 8) | (digest[i] & 0xFFL);
        }
        float[] out = new float[Types.EMBEDDING_DIM];
        for (int i = 0; i < Types.EMBEDDING_DIM; i++) {
            seed = seed * 1103515245L + 12345L;
            out[i] = (float) (((seed >>> 16) & 0x7FFFL) / 32768.0);
        }
        return out;
    }
}
