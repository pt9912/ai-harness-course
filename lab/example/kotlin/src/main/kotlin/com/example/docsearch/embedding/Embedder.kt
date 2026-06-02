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
        for (i in 0 until 8) {
            seed = (seed shl 8) or (digest[i].toLong() and 0xFFL)
        }
        val out = FloatArray(EMBEDDING_DIM)
        for (i in 0 until EMBEDDING_DIM) {
            seed = seed * 1103515245L + 12345L
            out[i] = (((seed shr 16) and 0x7FFFL).toInt() / 32768.0f)
        }
        return out
    }
}
