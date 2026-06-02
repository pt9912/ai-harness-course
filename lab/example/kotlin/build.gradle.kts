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
    testImplementation("com.lemonappdev:konsist:0.16.1")
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

kover {
    reports {
        verify {
            rule {
                bound {
                    minValue = 70  // LH-QA-Coverage, bootstrap-aware
                }
            }
        }
    }
}
