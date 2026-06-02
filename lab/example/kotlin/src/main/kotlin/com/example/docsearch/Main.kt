// DocSearch Entry-Point. Wiring gemäß ADR-0001.
package com.example.docsearch

import com.example.docsearch.embedding.MockEmbedder
import com.example.docsearch.index.Index
import com.example.docsearch.service.Searcher

const val VERSION: String = "0.3.0"

fun main(args: Array<String>) {
    if ("--version" in args) {
        println(VERSION)
        return
    }
    if ("--help" in args || args.isEmpty()) {
        System.err.println("DocSearch $VERSION\n\nNutzung: docsearch [--version]")
        return
    }

    val idx = Index()
    val emb = MockEmbedder()
    val service = Searcher(idx, emb)
    println(
        "DocSearch wired. service=$service, index-size=${idx.size()}. " +
            "HTTP-Start ist in Welle-4-Slice geplant.",
    )
}
