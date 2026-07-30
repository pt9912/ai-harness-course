package com.example.docsearch.service;

import com.example.docsearch.embedding.Embedder;
import com.example.docsearch.index.Index;
import com.example.docsearch.types.Types.IndexEntry;
import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Stream;

/**
 * Reindex-Service (LH-FA-01). ADR-0001 Layer: nutzt index + embedding, kein ui.
 */
public final class Indexer {

    /** E001 — Verzeichnis existiert nicht (spec/spezifikation.md §4). */
    public static final class DirectoryNotFoundException extends RuntimeException {
        private static final long serialVersionUID = 1L;

        public DirectoryNotFoundException() {
            super("E001: directory not found");
        }
    }

    private final Index index;
    private final Embedder embedder;

    public Indexer(Index index, Embedder embedder) {
        this.index = index;
        this.embedder = embedder;
    }

    /**
     * Indexiert alle {@code .md}-Dateien und liefert {@code indexed_docs}.
     * Fehlt das Verzeichnis, wird {@link DirectoryNotFoundException} (E001)
     * geworfen. Ein leeres Verzeichnis ist kein Fehler (LH-FA-01 Boundary).
     */
    public int reindex(String directory) {
        final Path base = Path.of(directory);
        if (!Files.isDirectory(base)) {
            throw new DirectoryNotFoundException();
        }
        final List<String> names = new ArrayList<>();
        try (Stream<Path> stream = Files.list(base)) {
            stream.filter(Files::isRegularFile)
                .map(p -> p.getFileName().toString())
                .filter(n -> n.endsWith(".md"))
                .forEach(names::add);
        } catch (IOException e) {
            throw new DirectoryNotFoundException();
        }
        // Deterministische Reihenfolge: LH-QA-02 verlangt bit-identische
        // Ergebnisse bei identischer Eingabe.
        Collections.sort(names);

        for (int i = 0; i < names.size(); i++) {
            final String name = names.get(i);
            final String text;
            try {
                text = Files.readString(base.resolve(name), StandardCharsets.UTF_8);
            } catch (IOException e) {
                throw new UncheckedIOException(e);
            }
            final float[] vec;
            try {
                vec = embedder.embed(text);
            } catch (RuntimeException e) {
                throw new Searcher.EmbeddingUnavailableException(e);
            }
            index.add(new IndexEntry(name, firstHeading(text, name), i, text, vec));
        }
        return names.size();
    }

    private static String firstHeading(String text, String fallback) {
        for (String line : text.split("\n", -1)) {
            if (line.startsWith("#")) {
                return line.replaceAll("^#+\\s*", "").trim();
            }
        }
        return fallback;
    }
}
