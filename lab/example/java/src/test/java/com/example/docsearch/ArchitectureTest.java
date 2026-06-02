/**
 * ADR-0001 Layering — ArchUnit. AGENTS.md §J-2.
 */
package com.example.docsearch;

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noClasses;

import com.tngtech.archunit.core.domain.JavaClasses;
import com.tngtech.archunit.core.importer.ClassFileImporter;
import org.junit.jupiter.api.Test;

public class ArchitectureTest {

    private static final JavaClasses CLASSES =
        new ClassFileImporter().importPackages("com.example.docsearch");

    @Test
    void uiDoesNotDependOnIndexOrEmbedding() {
        noClasses().that().resideInAPackage("..ui..")
            .should().dependOnClassesThat().resideInAnyPackage(
                "com.example.docsearch.index..",
                "com.example.docsearch.embedding..")
            .check(CLASSES);
    }

    @Test
    void serviceDoesNotDependOnUi() {
        noClasses().that().resideInAPackage("..service..")
            .should().dependOnClassesThat().resideInAPackage("..ui..")
            .check(CLASSES);
    }

    @Test
    void indexDoesNotDependOnServiceOrUi() {
        noClasses().that().resideInAPackage("..index..")
            .should().dependOnClassesThat().resideInAnyPackage(
                "com.example.docsearch.service..",
                "com.example.docsearch.ui..")
            .check(CLASSES);
    }

    @Test
    void embeddingDoesNotDependOnServiceOrUiOrIndex() {
        noClasses().that().resideInAPackage("..embedding..")
            .should().dependOnClassesThat().resideInAnyPackage(
                "com.example.docsearch.service..",
                "com.example.docsearch.ui..",
                "com.example.docsearch.index..")
            .check(CLASSES);
    }
}
