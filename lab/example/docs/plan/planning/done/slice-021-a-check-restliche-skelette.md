# Slice 021: a-check in den vier verbleibenden Sprach-Skeletten

**Lifecycle:** Der Zustand dieses Slice ist das Verzeichnis, in dem diese
Datei liegt — eines von `open/`, `next/`, `in-progress/`, `done/`. Er wechselt
nur durch `git mv` (Kurs
[Modul 5 §Lifecycle als State Machine](../../../../../../kurs/de/02-planung/modul-05-planning-harness.md#lifecycle-als-state-machine)).

**Welle:** ohne Welle — die Closure-Bedingung ist die DoD dieses Slice.

**Bezug:** [ADR-0016](../../adr/0016-a-check-in-allen-skeletten.md)
(Entscheidung und Stand-Tabelle), [ADR-0001](../../adr/0001-hexagonale-architektur.md)
(die Aussage, die beide Sensoren prüfen)

**Berührte Spec-Stellen:** —

**Autor:** Kurs-Lab. **Datum:** 2026-08-09.

## 1. Ziel

Go, Python, Java und Kotlin bekommen a-check als zweiten Layering-Sensor, wie
ADR-0016 es entschieden hat. C++ und C# sind verdrahtet und dienen als Vorlage.

## 2. Definition of Done

Je Skelett, in dieser Reihenfolge — **abgehakt heißt: für alle vier erledigt**
(Go, Python, Kotlin, Java; C++ und C# waren beim Anlegen dieses Slice schon
verdrahtet):

- [x] **Schritt 0 — Schreibweisen-Frage beantwortet, bevor die Config
      entsteht.** Welche Schreibweise setzt die Symbol-Auflösung voraus, welche
      Schreibweise umgeht sie, und erzwingt irgendetwas die vorausgesetzte? Die
      Antwort steht in §3 als Ausgangslage; sie ist am Skelett zu **belegen**,
      nicht zu übernehmen: Verstoß in der umgehenden Schreibweise einbauen,
      beide Sensoren laufen lassen, Ausgabe notieren.
- [x] `<sprache>/.a-check.yml` — Schichten und Kanten aus ADR-0001, Rollen nur
      wo der Code sie einlöst.
- [x] `<sprache>/a-check.mk` per `a-check --print-mk`; Pin im `Makefile`
      (`A_CHECK_IMAGE :=`), nicht im Fragment.
- [x] `include` **hinter** `help` — sonst wird `a-check` das Default-Goal.
- [x] `arch-check` führt **beide** Sensoren vollständig aus, nicht als
      Prerequisite.
- [x] Bindung in `<sprache>/harness/README.md` §Sensors.
- [x] `<sprache>/AGENTS.md` §C-2 nennt beide Sensoren.
- [x] Break-Test je Regel rot mit Exit 1, sauberer Baum grün.
- [x] `make gates` grün.
- [x] Stand der Umsetzung je Skelett in der Rollout-ADR nachgezogen (die
      Tabelle ist mit ADR-0016 entfallen, weil der Rollout abgeschlossen ist).

Am Ende aller vier:

- [x] Nachfolge-ADR, die die Stand-Tabelle durch die schlichte Aussage ersetzt
      (Re-Evaluierungs-Trigger der abgelösten ADR) — [ADR-0016](../../adr/0016-a-check-in-allen-skeletten.md).
- [x] Closure-Notiz mit den Break-Test-Ausgaben je Skelett (§9).

## 3. Plan (vor Code)

**Ausgangslage zu Schritt 0.** Die Frage ist für alle sechs Skelette einmal
gestellt worden; das Ergebnis hat ein Muster. a-check liest die
Import-Anweisung — blind ist es immer für die Schreibweise, die **an der
Import-Anweisung vorbei** koppelt. Ob daraus ein Gate-Loch wird, entscheidet
der Bestandssensor: Ein AST- oder IL-basierter sieht die Umgehung, ein
textbasierter nicht.

| Skelett | Auflösung setzt voraus | Umgehende Schreibweise | Sieht sie der Bestandssensor? |
|---|---|---|---|
| C++ | Include gegen `src/` gewurzelt | `#include "../../adapters/…"` | **Nein** — `arch-check.sh` grept Text. Einziges echtes Loch, geschlossen per `constructs`-Regel |
| C# | `using`-Direktive | voll qualifizierter Typ ohne `using` | Ja — NetArchTest liest die Assembly |
| Python | absoluter Import | `from ..ui import x` (a-check extrahiert relative Importe nicht) | Ja — `import-linter`/grimp löst relative Importe auf. Belegt: a-check 0 Befunde, `make arch-check` rot |
| Go | — | keine; Go kennt keinen relativen Import | entfällt (Compiler erzwingt die Schreibweise) |
| Java | Import, Paket == Verzeichnis | gleiches Paket braucht keinen Import | unkritisch: gleiches Paket ist dieselbe Schicht |
| Kotlin | Import, Paket == Verzeichnis | dito, plus Wildcard-Import | Wildcard löst a-check auf das Paket-Verzeichnis auf; Konsist sieht den Typ |

Daraus folgt für die vier offenen Skelette: **kein zusätzliches Loch erwartet**
— aber Schritt 0 verlangt den Beleg am Skelett, nicht die Übernahme dieser
Tabelle. Sie ist die Ausgangslage, nicht der Nachweis.

| Datei / Komponente | Änderungs-Art | Begründung |
|---|---|---|
| `go/`, `python/`, `java/`, `kotlin/` je `.a-check.yml` | neu | Deklaration je Skelett; eine Scan-Wurzel pro Sprachverzeichnis (ADR-0016 §Entscheidung 2) |
| dieselben vier je `a-check.mk` | neu | tool-generiert, keine Skript-Kopie |
| dieselben vier `Makefile` | update | Pin, `include`, `arch-check` mit beiden Sensoren |
| dieselben vier `harness/README.md`, `AGENTS.md` | update | Bindung und Sensor-Nennung |
| `docs/plan/adr/0015-…` | update | Stand-Tabelle |
| `README.md` (Beispiel-Wurzel) | update | Spalte *Architekturtest* je Zeile |

## 4. Trigger

- Auslöser ist ADR-0016; C++ und C# sind verdrahtet, die Entscheidung gilt für
  alle sechs.
- Reihenfolge-Vorschlag: Go zuerst — dort hängt die Mono-Scan-Grenze aus
  ADR-0016 §Entscheidung 2, und die Auflösung läuft ohne `resolution`-Block.

## 5. Risiken

| Risiko | Wahrscheinlichkeit | Gegenmaßnahme |
|---|---|---|
| Die Deklaration wird gröber als ADR-0001 und ist damit schwächer als der Bestandssensor | mittel | Die Regeln des Bestandssensors vor der Config auflisten und jede gegen eine Kante halten (der Befund aus dem C++-Pilot) |
| Vier Pins altern unabhängig voneinander | mittel | Anheben trifft alle verdrahteten Skelette in einem Commit; kein Freshness-Sensor deckt das ab (ADR-0016 §Konsequenzen) |
| Rollen werden gesetzt, wo der Code sie nicht einlöst | mittel | ADR-0016 §Entscheidung 3 — nur modellieren, was gebaut ist; im Zweifel reine Kanten |

## 6. Offene Risiken zur Welle-Closure

- Entfällt — Slice ohne Welle.

## 7. Steering-Loop-Beobachtungen

- **Kotlin: zweites geteiltes Loch.** Konsists Regeln sind gegen `file.imports`
  geschrieben und liegen damit auf derselben Ebene wie a-check; eine voll
  qualifizierte Nutzung ohne Import passiert beide. Das ist dieselbe
  Konstellation wie in C++ (zwei textnahe Sensoren) — die Vermutung aus §3, nur
  AST-basierte Bestandssensoren deckten die Umgehung ab, trägt für Konsist
  **nicht**: Das Werkzeug könnte den AST lesen, seine Regeln tun es hier nicht.
  Folge-Arbeit: Konsist-Regeln auf Typ-Referenzen statt Import-Liste heben —
  eigener Slice, nicht Teil dieses.
- **Das Kriterium der Ausgangs-Tabelle war falsch.** §3 sortierte nach Werkzeug
  („AST-/IL-basiert sieht die Umgehung“). Java hat das bestätigt (ArchUnit
  importiert Bytecode, fängt den FQN-Fall), Kotlin es widerlegt: Konsist
  *könnte* den AST lesen, seine Regeln hier tun es nicht. Das tragende Merkmal
  ist die **Bauform der Regel**, nicht die Klasse des Werkzeugs — und die steht
  in keiner Werkzeug-Dokumentation, sondern nur im Regel-Quelltext des
  jeweiligen Skeletts. Ein Rollout auf ein siebtes Skelett liest deshalb zuerst
  die Regeln des Bestandssensors, nicht sein Datenblatt.

- Aus dem C++-Pilot: Die Frage aus Schritt 0 kam dort **nach** dem Review, nicht
  vor der Config. Der blinde Fleck war deshalb schon verdrahtet und als „Gate"
  beschrieben, bevor er auffiel. Schritt 0 steht in dieser DoD, weil eine Regel
  in einer ADR den nicht erreicht, der das nächste Skelett verdrahtet.

## 8. Sub-Area-Modus-Begründung

Berührte Sub-Area: *Sprach-Skelette* (`go/`, `python/`, `java/`, `kotlin/`).
Modus **RK** — jedes Skelett trägt einen gewachsenen Bestandssensor mit
eigenen Regeln, gegen den die neue Deklaration zu rekonziliieren ist; die
Konvention entsteht nicht neu, sie muss den vorhandenen Stand einholen.

## 9. Closure-Notiz

**Ergebnis.** Alle sechs Skelette tragen a-check als zweiten Layering-Sensor
hinter `make arch-check`. Die Entscheidung steht in
[ADR-0016](../../adr/0016-a-check-in-allen-skeletten.md); dieser Slice hat sie
umgesetzt und dabei zwei Dinge korrigiert, die vorher als sicher galten.

**Schritt 0 hat je Skelett etwas geändert, nicht nur dokumentiert.**

| Skelett | Ergebnis von Schritt 0 | Folge für die Config |
|---|---|---|
| Go | Der Compiler weist relative Importe ab (`relative import paths are not supported in module mode`); Dot- und Blank-Import bleiben volle Modulpfade | keine `resolution`, keine `constructs` — die Voraussetzung erzwingt die Sprache |
| Python | Drei umgehende Schreibweisen gemessen, je 0 a-check-Befunde: `from ..ui import x`, `from docsearch import ui`, `import a, b` | keine Zusatzregel; `import-linter` fängt alle drei, a-check ist hier der schwächere Sensor — als Grenze deklariert |
| Kotlin | `com.example.docsearch.ui.Handler` ohne Import: compiliert, a-check 0 Befunde, Konsist `BUILD SUCCESSFUL` — **geteilter blinder Fleck** | `constructs`-Regel für die Richtung auf `ui`; die übrigen Kanten bleiben ausgewiesen offen |
| Java | Dieselbe Sonde: a-check 0 Befunde, ArchUnit `serviceDoesNotDependOnUi` rot (2 Verstöße) — Bytecode deckt es ab | keine Zusatzregel nötig |

**Break-Tests, je Regel des Bestandssensors, alle rot mit Exit 1:**

- Go — vier depguard-Blöcke (`ui→index`, `ui→embedding`, `service→ui`,
  `index→service`, `embedding→index`) plus `types→service`, für das depguard
  keine Deny-Liste führt.
- Python — die Contracts von `importlinter.cfg`; zusätzlich das neue Modul
  `docsearch.audit` mit Import auf `docsearch.ui`: a-check exit 1,
  `import-linter` „4 kept, 0 broken".
- Kotlin — alle fünf Konsist-Tests, plus `types→service` (kein Test dafür),
  plus der FQN-Fall über `construct-leak`.
- Java — alle vier ArchUnit-Regeln plus `types→service` (keine Regel dafür).
- Sauberer Baum: in allen sechs Skeletten `0 Befund(e)`.

**Das Muster, das die Reihe ergeben hat.** a-check ist blind für die
Schreibweise, die an der Import-Anweisung vorbei koppelt; ob daraus eine
Gate-Lücke wird, entscheidet der Bestandssensor. Das Kriterium dafür ist
**nicht** die Werkzeugklasse — Konsist könnte den AST lesen und tut es in seinen
Regeln nicht — sondern die Bauform der Regel. Sie steht in keinem Datenblatt,
nur im Regel-Quelltext des jeweiligen Skeletts.

**Gates zum Zeitpunkt der Closure:** `make gates` in allen sechs Skeletten grün,
`make arch-check` je beide Sensoren grün, Root `make check` 0 ERROR / 0 WARN,
`make verify` ohne Befund.

**Offen geblieben, bewusst:** Konsists Regeln auf Typ-Referenzen statt
`file.imports` zu heben (eigener Slice, siehe §7) und die vier Befunde an
a-check selbst — Laufzeit-Diagnose der Heuristik-Grenze, Mehrfach-Direktiven pro
Zeile, `--print-mk`-Digest-Versatz, `docker` statt `$(DOCKER)`. Beides liegt
außerhalb dieses Repos bzw. dieses Slice.
