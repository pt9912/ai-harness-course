# Fallstudien

Der Kurs benutzt drei reale Open-Source-Repos in unterschiedlichen
Reifegraden als laufendes Beispiel. Wenn ein Modul mit "Beispiel aus
grid-gym" oder "wie in c-hsm-doc" argumentiert, ist genau einer dieser
Stände gemeint.

## Übersicht

| Repo | Klasse | Stack | Was der Kurs daraus zieht |
|---|---|---|---|
| **`pt9912/u-boot`** | Referenz/Tooling | Go-CLI für reproduzierbare Docker-Setups | LH-ID-Schema in Make-Target-Kommentaren, `verify-depguard` als Architekturtest, bootstrap-aware Coverage. **Kein AGENTS.md** — typischer "vor dem Harness"-Zustand. |
| **`pt9912/grid-gym`** | Referenz (Domäne) | Python-EMS-Simulator, hexagonale Architektur | Reichste AGENTS.md (Docker-only, noqa-Verbot, Welle-Self-Close), 18 Gates, Test-Diversität (`determinism`/`replay`/`fault`). |
| **`pt9912/c-hsm-doc`** | Safety + Compliance | Go-Tool mit PKCS#11/HSM-Integration | Spec-Stratifizierung (Lastenheft *vertraglich* / Spezifikation *technisch* / Architektur *diagrammatisch*), `HSM-*`-IDs, `proto-check` als Drift-Sensor gegen generierten Code, Hard Rule "Accepted-ADRs immutable". |
| **`pt9912/bess-ems`** | Safety/Control-Flagship | C#/.NET 10 + native C/C++-Interop, BESS-EMS mit MPC | **Central Package Management** (`Directory.Packages.props` + `packages.lock.json`) als Reproduzierbarkeits-Anker, eigener **`solid-suppression-gate`** als Hard Rule, **`test-mpc-property`** als Property-Based-Sensor neben Unit-Tests, **`native-sanitizer`** für C/C++-Anteile. Zeigt: Safety/Control-Repos tragen oft mehrere Toolchains. |

## Repo-Klassen

In Mehrfach-Repo-Landschaften ist der Harness nicht uniform. Drei
wiederkehrende Charaktere:

| Klasse | Was sie ist | Schwerpunkt | Beispiel |
|---|---|---|---|
| **Referenz-Repo** | Die saubere Vorlage, an der alle anderen sich orientieren. | strenge Determinismus-/Replay-Gates, Doku-Disziplin | Simulator, Beispiel-Stack |
| **Safety/Control-Flagship** | Berührt reale Hardware oder Geld. | Hard Rules, Adapter-Disziplin, fail-closed in Produktion | EMS, Trading-Bot, Steueranlage |
| **Policy/Compliance-Flagship** | Erzeugt Artefakte mit Außenwirkung (Anträge, Bescheinigungen). | Traceability-Matrix, ID-Disziplin, Disclaimer-Pflicht | Antragsgenerator, Compliance-Werkzeug |

### Konsequenzen pro Klasse

* **Referenz-Repo**: Harness ist *Demonstrator*. Hier darf experimentiert werden; was sich bewährt, wandert in die Flagships.
* **Safety-Repo**: Hard Rules sind nicht verhandelbar, Sensors müssen fail-closed sein, native Sanitizer-Gates gehören dazu.
* **Compliance-Repo**: Jede Änderung trägt eine fachliche ID (z. B. `GG-*`). Änderungen an Lastenheft-Versionen erhöhen die Versionsnummer. KI-Funktionen liefern Prompts und Vorschläge, nie verbindliche Entscheidungen.

### Einführungsregel

**Beginne immer beim Referenz-Repo**, portiere erst nach erfolgreicher
Steering-Loop-Iteration (siehe [`klassifikation.md`](klassifikation.md))
auf die Flagships. Alle Repos parallel mit demselben Master-Prompt zu
treiben skaliert nicht — der Agent verteilt dann halbgare Standardtexte
über alle.

## Beobachtung aus dem Ist-Zustand

Keines der vier Repos hat (Stand 2026-06) ein `harness/README.md`.
`bess-ems` hat sogar (Stand jetzt) noch *kein* AGENTS.md, obwohl es das
sicherheitskritischste Repo ist. Alle haben aber *die kanonischen Quellen*
(Spec, ADR, Planning, Makefile-Gates) — der Harness existiert bereits,
nur ohne formellen Einstiegspunkt. Das ist der realistische Ausgangspunkt
für die meisten Teams: nicht "Greenfield-Harness", sondern "Ein Einstieg
in einen schon vorhandenen Harness".

## Branchen-Anwendungsanker

Über die drei konkreten Repos hinaus, einige typische Branchen, in denen
die Konzepte des Kurses besonders tragen:

- **Regulierte Branchen (Finanzen, Medizin, Behörden):** Auditierbarkeit, ADRs und Verification sind nicht nice-to-have, sondern Pflicht. Der Harness ist hier kein Tooling, sondern Compliance-Infrastruktur.
- **Interne Developer-Tools:** Replay und Golden Sets verhindern, dass eine Modellaktualisierung über Nacht das Team ausbremst.
- **Embedded LLM-Anwendungen:** Quality Gates müssen Latenz- und Kostenbudgets als harte Constraints prüfen, nicht nur Korrektheit.
- **Plattform-Teams:** Carveout-Management und Roadmap-Engineering skalieren über mehrere Teams hinweg — der Harness wird zum Verträge-Mechanismus.
- **Migration bestehender Codebasen:** Slice-Planung und Implementation-Agent sind das Werkzeug, mit dem große Refactorings auditierbar werden.
