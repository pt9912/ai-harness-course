// ADR-0001 Layering durchgesetzt mit Konsist.
// AGENTS.md §K-2.
//
// Die Regeln prüfen nicht nur `file.imports`, sondern jede Nennung des
// verbotenen Pakets im Code. Grund, gemessen: `com.example.docsearch.ui.Handler`
// voll qualifiziert im Service, ohne Import — compiliert, und die frühere
// Fassung dieser Tests war grün. Ein Verstoß, der die Import-Zeile umgeht,
// umging damit das Gate.
//
// Konsist ist quell-basiert (PSI), nicht Bytecode-basiert wie ArchUnit im
// Java-Skelett: Eine echte Typ-Auflösung gibt es hier nicht. Geprüft wird
// deshalb der Quelltext ohne Kommentare und ohne die eigene `package`-Zeile —
// die Grenze ist dieselbe Klasse wie bei einer Include-Heuristik, aber sie
// deckt den Fall ab, der vorher durchfiel.
package com.example.docsearch

import com.lemonappdev.konsist.api.Konsist
import com.lemonappdev.konsist.api.ext.list.withPackage
import com.lemonappdev.konsist.api.provider.KoTextProvider
import com.lemonappdev.konsist.api.verify.assertFalse
import org.junit.jupiter.api.Test

private const val ROOT = "com.example.docsearch"

/** Quelltext ohne Zeilenkommentare, Blockkommentare und eigene `package`-Zeile. */
private fun KoTextProvider.codeText(): String =
    text
        .replace(Regex("""/\*.*?\*/""", RegexOption.DOT_MATCHES_ALL), "")
        .lineSequence()
        .filterNot { it.trimStart().startsWith("//") }
        .filterNot { it.trimStart().startsWith("package ") }
        .joinToString("\n")

/**
 * Nennt die Datei das Paket — als Import **oder** voll qualifiziert im Code?
 * Beides ist eine Abhängigkeit; nur die erste Form stand vorher im Gate.
 */
private fun KoTextProvider.references(vararg packages: String): Boolean =
    packages.any { codeText().contains("$ROOT.$it.") }

class ArchitectureTest {
    private val scope = Konsist.scopeFromProject()

    @Test
    fun `ui darf nicht direkt auf index oder embedding zugreifen (ADR-0001)`() {
        scope.files
            .withPackage("..ui..")
            .assertFalse { it.references("index", "embedding") }
    }

    @Test
    fun `service darf nicht ui nennen (ADR-0001)`() {
        scope.files
            .withPackage("..service..")
            .assertFalse { it.references("ui") }
    }

    @Test
    fun `index darf nicht service, ui oder embedding nennen (ADR-0001)`() {
        scope.files
            .withPackage("..index..")
            .assertFalse { it.references("service", "ui", "embedding") }
    }

    @Test
    fun `embedding darf nicht service, ui oder index nennen (ADR-0001)`() {
        scope.files
            .withPackage("..embedding..")
            .assertFalse { it.references("service", "ui", "index") }
    }

    @Test
    fun `types darf keine andere Schicht nennen (ADR-0001)`() {
        scope.files
            .withPackage("..types..")
            .assertFalse { it.references("index", "embedding", "service", "ui") }
    }
}
