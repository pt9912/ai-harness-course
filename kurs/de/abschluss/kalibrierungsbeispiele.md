# Kalibrierungsbeispiele zum Abschlussprojekt

Diese Beispiele sind keine Musterloesungen. Sie zeigen, wie die Rubric
aus [`abschlussprojekt.md`](abschlussprojekt.md) praktisch gelesen wird.

## Beispiel A — funktional, aber noch nicht solide

Ein Team gibt ein Repo mit Spec, Code, ADR und `make gates` ab. Die
Artefakte existieren, aber der Slice in `done/` verweist nur auf
`LH-FA-02`, nicht auf die ADR, die seine Architekturentscheidung traegt.
Der Replay-Lauf ist dokumentiert, aber das Golden Set enthaelt nur zwei
Faelle.

Bewertung:

| Achse | Stufe | Grund |
|---|---|---|
| Vollstaendigkeit | funktional | Artefakttypen vorhanden, aber Replay und Verknuepfung sind lueckenhaft. |
| Konsistenz | solide | `harness/README.md` und AGENTS.md widersprechen sich nicht. |
| Reproduzierbarkeit | funktional | Dockerfile vorhanden, aber Image-Hash nicht festgehalten. |
| Auditierbarkeit | funktional | IDs existieren, aber nicht durchgaengig in Slice, Commit und PR. |
| Steering-Loop-Reife | funktional | Failure dokumentiert, Guide/Sensor noch nicht umgesetzt. |

Das Projekt besteht so nicht, weil mehrere Achsen unter solide liegen.

## Beispiel B — solide

Ein Team gibt ein kleines, aber geschlossenes Repo ab: eine Spec, drei
ADRs, drei Slices, davon einer in `done/`, ein dokumentierter Carveout,
ein Replay mit mindestens drei Golden-Set-Faellen und ein Root-Target
`make gates`, das im Container und in CI denselben Stand prueft.

Bewertung:

| Achse | Stufe | Grund |
|---|---|---|
| Vollstaendigkeit | solide | Alle Artefakte vorhanden und verknuepft. |
| Konsistenz | solide | Source Precedence ist sichtbar; AGENTS.md behauptet keine erfundenen Tools. |
| Reproduzierbarkeit | solide | Gates laufen auf frischem Klon und in CI mit gepinntem Image. |
| Auditierbarkeit | solide | `LH-*`, `ADR-*` und `SL-*` erscheinen in Artefakten und PR-Beschreibung. |
| Steering-Loop-Reife | solide | Ein Failure fuehrte zu einem implementierten Sensor; Wiederholung wurde geprueft. |

Das Projekt besteht. Es ist nicht breit, aber belegt die komplette
Artefaktkette.

## Beispiel B' — knappes Bestehen (vier solide, eine funktional)

Ein Team gibt ein Repo ab, das in vier Achsen *solide* trifft, aber bei
*Steering-Loop-Reife* nur *funktional* erreicht: ein Failure ist
dokumentiert, ein Sensor-Vorschlag steht im Begleitprotokoll, aber der
Sensor ist noch nicht implementiert und die Wiederholungs-Messung
fehlt.

Bewertung:

| Achse | Stufe | Grund |
|---|---|---|
| Vollstaendigkeit | solide | Alle Artefakte vorhanden und verknuepft. |
| Konsistenz | solide | Source Precedence sichtbar; AGENTS.md ohne Drift. |
| Reproduzierbarkeit | solide | Gates auf frischem Klon und in CI mit gepinntem Image. |
| Auditierbarkeit | solide | `LH-*`, `ADR-*` und `SL-*` durchgaengig in Artefakten und PR-Beschreibung. |
| Steering-Loop-Reife | funktional | Failure beobachtet und Sensor-Vorschlag notiert; Sensor selbst nicht implementiert, Wiederholungs-Messung fehlt. |

Das Projekt **besteht** — gerade noch. Die Bestehens-Regel
([`abschlussprojekt.md`](abschlussprojekt.md#bestanden)) erlaubt *eine*
funktional-Achse, wenn die Luecke dokumentiert und mit einem Folge-Slice
verknuepft ist. Das Begleitprotokoll referenziert `SL-018`
("Sensor *suppression-counter* implementieren") in `next/` — damit ist
die Auflage erfuellt.

*Lehrwert*: dies ist die haeufigste Bewertungs-Entscheidung im Kurs.
Ohne den Folge-Slice mit ID waere dieselbe Konstellation *nicht
bestanden*. Die Beleg-Verknuepfung ist nicht Formalitaet, sie ist die
Schwelle.

## Beispiel C — exzellent

Ein Team zeigt ueber mehrere Wochen drei Steering-Loop-Iterationen. Eine
Iteration erzeugt einen neuen Sensor, eine zweite schaerft einen
bestehenden Sensor, eine dritte verschiebt eine inferentielle Regel aus
AGENTS.md zusaetzlich in ein computational Gate. Die Telemetrie belegt
Token-Kosten pro Slice, Cache-Hit-Rate und Tool-Call-Audit.

Bewertung:

| Achse | Stufe | Grund |
|---|---|---|
| Vollstaendigkeit | exzellent | Reviewer-Skill, superseding ADR und Failure-Eintrag vorhanden. |
| Konsistenz | exzellent | Doku-Konsistenz-Sensor erkennt Drift zwischen AGENTS.md und realen Gates. |
| Reproduzierbarkeit | exzellent | Image-Hash, Lock-Files, Cache-Metrik und bootstrap-aware Hochschalt-Schwelle belegt. |
| Auditierbarkeit | exzellent | Trace fuehrt von Tool-Call bis Anforderungs-ID. |
| Steering-Loop-Reife | exzellent | Drei Iterationen, davon mindestens eine Verschärfung eines bestehenden Sensors. |

Der Unterschied zu solide ist nicht mehr Artefaktmenge, sondern
belegte Reife des Harness unter wiederholtem Versagen.
