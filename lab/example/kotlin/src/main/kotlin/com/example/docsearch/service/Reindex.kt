// Service-Layer (LH-FA-01). ADR-0001: importiert types, index, embedding; KEIN ui.
package com.example.docsearch.service

import com.example.docsearch.embedding.Embedder
import com.example.docsearch.index.Index
import com.example.docsearch.types.IndexEntry
import java.io.File

/** E001 — Verzeichnis existiert nicht (spec/spezifikation.md §4). */
class DirectoryNotFoundException(msg: String = "E001: directory not found") :
    IllegalArgumentException(msg)

class Indexer(
    private val index: Index,
    private val embedder: Embedder,
) {
    /**
     * Indexiert alle `.md`-Dateien und liefert `indexed_docs`.
     * Fehlt das Verzeichnis, wird [DirectoryNotFoundException] (E001) geworfen.
     * Ein leeres Verzeichnis ist kein Fehler (LH-FA-01 Boundary).
     */
    fun reindex(directory: String): Int {
        val base = File(directory)
        if (!base.isDirectory) throw DirectoryNotFoundException()
        // Deterministische Reihenfolge: LH-QA-02 verlangt bit-identische
        // Ergebnisse bei identischer Eingabe.
        val files = (base.listFiles() ?: emptyArray())
            .filter { it.isFile && it.name.endsWith(".md") }
            .sortedBy { it.name }
        files.forEachIndexed { i, file ->
            val text = file.readText()
            val vec = runCatching { embedder.embed(text) }
                .getOrElse { throw EmbeddingUnavailableException(cause = it) }
            index.add(
                IndexEntry(
                    docPath = file.name,
                    sectionTitle = firstHeading(text, file.name),
                    sectionIndex = i,
                    sectionText = text,
                    embedding = vec,
                ),
            )
        }
        return files.size
    }
}

private fun firstHeading(text: String, fallback: String): String =
    text.lineSequence().firstOrNull { it.startsWith("#") }
        ?.trimStart('#', ' ')?.trim() ?: fallback
