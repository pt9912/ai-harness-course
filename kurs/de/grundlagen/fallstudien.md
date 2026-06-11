# Fallstudien

Der Kurs benutzt vier reale Open-Source-Repos in unterschiedlichen
Reifegraden: `grid-gym`, `bess-ems` und `c-hsm-doc` tauchen als
laufende Beispiele in mehreren Modulen auf; `u-boot` dient als
ADR-Korpus-Anker in
[Modul 4](../01-spec-und-architektur/modul-04-architektur-adrs.md)
und als Reifegrad-Station in der Beobachtungs-Tabelle unten. Wenn ein
Modul mit "Beispiel aus grid-gym" oder "wie in c-hsm-doc"
argumentiert, ist genau einer dieser Stände gemeint.

## Übersicht

| Repo | Klasse | Anmerkung | Stack | Was der Kurs daraus zieht |
|---|---|---|---|---|
| **`pt9912/u-boot`** | Referenz | Tooling | Go-CLI für reproduzierbare Docker-Setups | LH-ID-Schema in Make-Target-Kommentaren, `verify-depguard` als Architekturtest, bootstrap-aware Coverage. `AGENTS.md` und `harness/README.md` seit 2026-06 — typischer "Tooling-Repo im Harness-Aufbau"-Zustand. |
| **`pt9912/grid-gym`** | Referenz | Domäne | Python-EMS-Simulator, hexagonale Architektur | Reichste AGENTS.md (Docker-only, noqa-Verbot, Wave-Self-Close-Commit-Konvention), 10 A-1-Pflicht-Gates in `make gates`, Test-Diversität (`determinism`/`replay`/`fault`). |
| **`pt9912/c-hsm-doc`** | Policy/Compliance | mit Safety-Anteil (HSM-Integration) | Go-Tool mit PKCS#11/HSM-Integration | Spec-Stratifizierung (Lastenheft *vertraglich* / Spezifikation *technisch* / Architektur *diagrammatisch*), `HSM-*`-IDs, `proto-check` als Drift-Sensor gegen generierten Code, Hard Rule "Accepted-ADRs immutable". |
| **`pt9912/bess-ems`** | Safety/Control | Flagship | C#/.NET 10 + native C/C++-Interop, BESS-EMS mit MPC | **Central Package Management** (`Directory.Packages.props` + `packages.lock.json`) als Reproduzierbarkeits-Anker, eigener **`solid-suppression-gate`** als Hard Rule, **`test-mpc-property`** als Property-Based-Sensor neben Unit-Tests, **`native-sanitizer`** für C/C++-Anteile. Zeigt: Safety/Control-Repos tragen oft mehrere Toolchains. |

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

Die vier Repos zeigen (Stand 2026-06) vier Stationen eines
Reifegrad-Gradienten:

| Repo | `AGENTS.md` | `harness/README.md` | Modus | Stadium |
|---|---|---|---|---|
| `grid-gym` | ✓ | ✓ | BF (graduation-nah) | etablierter formeller Einstieg |
| `u-boot` | ✓ (neu, 2026-06) | ✓ (neu, 2026-06) | BF (in Transition) | formeller Einstieg seit kurzem |
| `c-hsm-doc` | ✓ | ✗ | BF (früh) | AGENTS.md ohne Harness-Index |
| `bess-ems` | ✗ | ✗ | BF (Start) | kanonische Quellen ohne Harness-Hülle, obwohl sicherheitskritischstes Repo |

Alle vier Repos haben *die kanonischen Quellen* (Spec, ADR, Planning,
Makefile-Gates) — der Harness existiert in jedem von ihnen, nur in
unterschiedlich formalisiertem Zustand. **Alle vier sind im
Brownfield-Modus** (Konzept-Anker: [`konventionen.md` §Harness-Bootstrap](konventionen.md#harness-bootstrap); ausgearbeiteter Lehrtext mit GF/BF-Walkthroughs: [Modul 2 — Harness-Bootstrap](../01-spec-und-architektur/modul-02-harness-bootstrap.md)):
Code und kanonische Quellen sind da, die Harness-Hülle entsteht als
*Inventur des Bestands* (Trigger-Richtung Code → Doc). Damit bestätigen
die vier Repos den allgemeinen Befund: *typischer Ausgangspunkt ist
Brownfield, nicht Greenfield*. Die Frage ist nicht *ob*, sondern *wie
weit* die BF-Inventur bereits vorangeschritten ist und wie nah die
Graduation zu Greenfield (Trigger-Richtung kippt auf Doc → Code) ist.

Die Bewegung von `u-boot` zwischen den Wellen (2026-06: AGENTS.md und
`harness/README.md` ergänzt) ist selbst Lehrstoff: BF-Reife ist
beobachtbar und änderbar, nicht statisch — Repos können sich
systematisch der Graduation nähern, ein Artefakt pro Welle.

Keines der vier Repos führt bisher `harness/conventions.md` (neu im
Kurs; Default-Ort für repo-lokale Strukturregeln, Adaptionen ggü.
Baseline und Modus-Deklaration pro Sub-Area — siehe
[`konventionen.md`](konventionen.md#harnessconventionsmd-als-konventionsspeicher)).
Damit auch keinen formalen Modus-Block, in dem GF/BF-Klassifikation
pro Sub-Area dokumentiert wäre — derzeit ist die BF-Einstufung in der
Tabelle oben eine *externe Beobachtung*, kein Repo-eigener Eintrag.
Das ist der nächste sichtbare Reife-Schritt vor formaler Graduation,
sobald repo-lokale Adaptionen ggü. Kurs-Konvention notwendig werden —
und in den meisten realen Repos werden sie das früher als gedacht
(eigene ID-Präfixe für Architektur/Spezifikation, Bootstrap-Modus pro
Sub-Area, Compliance-Bindung-Klassen).

## Branchen-Anwendungsanker

Über die vier konkreten Repos hinaus, einige typische Branchen, in denen
die Konzepte des Kurses besonders tragen:

- **Regulierte Branchen (Finanzen, Medizin, Behörden):** Auditierbarkeit, ADRs und Verification sind nicht nice-to-have, sondern Pflicht. Der Harness ist hier kein Tooling, sondern Compliance-Infrastruktur.
- **Interne Developer-Tools:** Replay und Golden Sets verhindern, dass eine Modellaktualisierung über Nacht das Team ausbremst.
- **Embedded LLM-Anwendungen:** Quality Gates müssen Latenz- und Kostenbudgets als harte Constraints prüfen, nicht nur Korrektheit.
- **Plattform-Teams:** Carveout-Management und Roadmap-Engineering skalieren über mehrere Teams hinweg — der Harness wird zum Verträge-Mechanismus.
- **Migration bestehender Codebasen:** Slice-Planung und Implementation-Agent sind das Werkzeug, mit dem große Refactorings auditierbar werden.
