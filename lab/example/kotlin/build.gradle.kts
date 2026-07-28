// DocSearch Kotlin-Skelett — Gradle KTS

plugins {
    kotlin("jvm") version "2.0.20"
    id("io.gitlab.arturbosch.detekt") version "1.23.7"
    id("org.jetbrains.kotlinx.kover") version "0.8.3"
    application
}

group = "com.example"
version = "0.3.0"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation("org.jetbrains.kotlin:kotlin-test")
    testImplementation("org.junit.jupiter:junit-jupiter:5.10.3")
    // Konsist: Kotlin-Architekturtests, ADR-0001 Layering
    testImplementation("com.lemonappdev:konsist:0.17.3")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

application {
    mainClass.set("com.example.docsearch.MainKt")
}

kotlin {
    jvmToolchain(21)
}

tasks.test {
    useJUnitPlatform()
}

detekt {
    config.setFrom("config/detekt.yml")
    buildUponDefaultConfig = true
    allRules = false
    // AGENTS.md §K-1: Suppression-Verbot. Baseline-Datei statt @Suppress.
    baseline = file("config/detekt-baseline.xml")
}

// CO-001: `make coverage-gate-critical` reicht `-Pcritical=true` durch und
// misst dann NUR den kritischen Layer (service) gegen 80 %; index ist bis
// Welle 2 ausgenommen. Analog go (./internal/service/... 80), python
// (src/docsearch/service 80) und cpp (gcovr auf src/hexagon/service/).
// Ohne diese Auswertung verpuffte das Flag, und das Gate fuhr denselben
// 70-%-Check wie `coverage-gate` — ein Gate, das seine Zusage nicht prüft.
val criticalOnly = project.hasProperty("critical")

kover {
    reports {
        filters {
            if (criticalOnly) {
                includes {
                    classes("com.example.docsearch.service.*")
                }
            } else {
                // Composition Root von der Coverage ausnehmen (analog cpp/java:
                // main.cpp bzw. Main.class). Reines Wiring, kein Unit-Test-Gegenstand.
                excludes {
                    classes("com.example.docsearch.MainKt")
                }
            }
        }
        verify {
            rule {
                bound {
                    // LH-QA-Coverage 70 % bootstrap-aware; 80 % auf dem kritischen Layer
                    minValue = if (criticalOnly) 80 else 70
                }
            }
        }
    }
}
