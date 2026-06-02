// ADR-0001 Layering durchgesetzt mit Konsist.
// AGENTS.md §K-2.
package com.example.docsearch

import com.lemonappdev.konsist.api.Konsist
import com.lemonappdev.konsist.api.verify.assertFalse
import org.junit.jupiter.api.Test

class ArchitectureTest {
    private val scope = Konsist.scopeFromProject()

    @Test
    fun `ui darf nicht direkt auf index zugreifen (ADR-0001)`() {
        scope.files
            .withPackage("..ui..")
            .assertFalse { file ->
                file.imports.any { it.name.contains("docsearch.index") }
            }
    }

    @Test
    fun `ui darf nicht direkt auf embedding zugreifen (ADR-0001)`() {
        scope.files
            .withPackage("..ui..")
            .assertFalse { file ->
                file.imports.any { it.name.contains("docsearch.embedding") }
            }
    }

    @Test
    fun `service darf nicht ui importieren (ADR-0001)`() {
        scope.files
            .withPackage("..service..")
            .assertFalse { file ->
                file.imports.any { it.name.contains("docsearch.ui") }
            }
    }

    @Test
    fun `index darf nicht service, ui oder embedding importieren (ADR-0001)`() {
        scope.files
            .withPackage("..index..")
            .assertFalse { file ->
                file.imports.any {
                    it.name.contains("docsearch.service") ||
                        it.name.contains("docsearch.ui") ||
                        it.name.contains("docsearch.embedding")
                }
            }
    }

    @Test
    fun `embedding darf nicht service, ui oder index importieren (ADR-0001)`() {
        scope.files
            .withPackage("..embedding..")
            .assertFalse { file ->
                file.imports.any {
                    it.name.contains("docsearch.service") ||
                        it.name.contains("docsearch.ui") ||
                        it.name.contains("docsearch.index")
                }
            }
    }
}
