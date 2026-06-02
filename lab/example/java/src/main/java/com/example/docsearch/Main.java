package com.example.docsearch;

import com.example.docsearch.embedding.MockEmbedder;
import com.example.docsearch.index.Index;
import com.example.docsearch.service.Searcher;

/**
 * DocSearch Entry-Point. Wiring der Schichten gemäß ADR-0001.
 */
public final class Main {
    public static final String VERSION = "0.3.0";

    private Main() { }

    public static void main(String[] args) {
        for (String a : args) {
            if ("--version".equals(a)) {
                System.out.println(VERSION);
                return;
            }
        }
        if (args.length == 0 || hasHelp(args)) {
            System.err.println("DocSearch " + VERSION + "\n\nNutzung: docsearch [--version]");
            return;
        }

        Index idx = new Index();
        MockEmbedder emb = new MockEmbedder();
        new Searcher(idx, emb);
        System.out.println("DocSearch wired. HTTP-Start ist in Welle-4-Slice geplant.");
    }

    private static boolean hasHelp(String[] args) {
        for (String a : args) {
            if ("--help".equals(a)) {
                return true;
            }
        }
        return false;
    }
}
