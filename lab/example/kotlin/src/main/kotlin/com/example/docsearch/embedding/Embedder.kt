// Embedder-Adapter (ADR-0002). Importiert nur types.
package com.example.docsearch.embedding

import com.example.docsearch.types.EMBEDDING_DIM
import java.security.MessageDigest

interface Embedder {
    fun embed(text: String): FloatArray
}

class MockEmbedder : Embedder {
    override fun embed(text: String): FloatArray {
        val digest = MessageDigest.getInstance("SHA-256").digest(text.toByteArray())
        var seed = 0L
        for (i in 0 until SEED_BYTES) {
            seed = (seed shl BYTE_BITS) or (digest[i].toLong() and BYTE_MASK)
        }
        val out = FloatArray(EMBEDDING_DIM)
        for (i in 0 until EMBEDDING_DIM) {
            seed = seed * LCG_MULTIPLIER + LCG_INCREMENT
            out[i] = (((seed shr LCG_SHIFT) and LCG_MASK).toInt() / LCG_DIVISOR)
        }
        return out
    }

    private companion object {
        const val SEED_BYTES = 8
        const val BYTE_BITS = 8
        const val BYTE_MASK = 0xFFL
        const val LCG_MULTIPLIER = 1103515245L
        const val LCG_INCREMENT = 12345L
        const val LCG_SHIFT = 16
        const val LCG_MASK = 0x7FFFL
        const val LCG_DIVISOR = 32768.0f
    }
}
