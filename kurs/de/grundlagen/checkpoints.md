# Phasen-Checkpoints

Zwischen den großen Phasen des Kurses lohnt sich ein Mini-Integrations-Test:
*Hast du die Phase wirklich gelernt — oder nur durchgelesen?*

Jeder Checkpoint ist eine konkrete, kleine Aufgabe, die mehrere Konzepte
der vorhergehenden Phase verbindet. Keine Theoriefrage — eine Handlung
mit überprüfbarem Ergebnis.

## Checkpoint A — nach Phase 01 (Spec und Architektur)

**Aufgabe:** Schreibe für ein eigenes Mini-Feature (frei wählbar; z. B.
"Markdown-Dateien indexieren und durchsuchen") in 90 Minuten:

1. Drei funktionale Anforderungen mit IDs (`LH-FA-001` … `LH-FA-003`) und
   je drei Akzeptanzkriterien (Happy Path · Boundary · Negative) im
   Given/When/Then-Stil.
2. Eine nichtfunktionale Anforderung mit messbarer Schwelle.
3. Ein ADR im MADR-Format, das eine Architekturentscheidung dokumentiert,
   die mindestens eine deiner Anforderungen direkt betrifft.
4. Eine `harness/README.md`-Skizze mit Source-Precedence-Block (Vorlage in
   [`/lab/templates/harness/README.template.md`](../../../lab/templates/harness/README.template.md)).

**Selbsttest:**
- Verweist dein ADR auf eine `LH-*`-ID? Wenn nein: Traceability-Constraint nicht erfüllt.
- Hat mindestens eines deiner Akzeptanzkriterien einen Negativ-Pfad ("System darf nicht …")? Wenn nein: Spec-Lücke wahrscheinlich.
- Steht in deinem `harness/README.md` nur, was es im Repo *tatsächlich* gibt? Wenn nein: Halluzinierter Sensor.

Wer hier hängenbleibt, sollte Modul 2 und 3 erneut durchgehen, bevor er
in Phase 02 startet. Lösungs-Vergleichspunkt:
[`/lab/example/spec/`](../../../lab/example/spec/) und
[`/lab/example/docs/plan/adr/`](../../../lab/example/docs/plan/adr/).

## Checkpoint B — nach Phase 02 (Planung)

**Aufgabe:** Schneide das Mini-Feature aus Checkpoint A in mindestens drei
Slices und bewege sie durch die Lifecycle-Verzeichnisse.

1. Lege `open/`, `next/`, `in-progress/`, `done/` an.
2. Schreibe drei Slice-Dateien (`SL-001` … `SL-003`), jede mit DoD und
   Trigger für den Übergang in `done/`.
3. Mindestens *ein* Slice muss zu groß sein — schneide ihn ohne Verlust
   in zwei und dokumentiere die Schnittentscheidung.
4. Dokumentiere mindestens einen Carveout (temporär *oder* permanent),
   mit Auflösungs-Trigger oder begründeter Permanenz.

**Selbsttest:**
- Kann ein Implementation-Agent jeden Slice in *einem* Lauf abschließen, ein Reviewer den Diff *in einer Sitzung* prüfen? Wenn nein: zu groß.
- Hat dein temporärer Carveout einen *Folge-Slice* mit ID? Wenn nein: er ist faktisch permanent.
- Ist deine Roadmap eine Reihenfolge von Wellen, *nicht* von Terminen?

Wer hier hängenbleibt, sollte Modul 4–6 erneut durchgehen. Lösungs-Vergleichspunkt:
[`/lab/example/docs/plan/planning/`](../../../lab/example/docs/plan/planning/).

## Checkpoint C — nach Phase 03 (Agenten)

**Aufgabe:** Wähle einen deiner Slices aus Checkpoint B und durchlaufe
ihn mit dem 8-Schritt-Workflow aus
[Modul 8](../03-agenten/modul-08-implementierung.md#minimal-agent-workflow-8-schritte).

1. Implementation-Agent läuft mit AGENTS.md *und* ohne — vergleiche die Diffs.
2. Dokumentiere zwei Hard Rules für dein Repo (jeweils mit Falsch/Richtig-Beispiel und Begründung).
3. Mindestens *eine* Hard Rule muss durch eine Fitness Function (Linter, ArchUnit, dep-cruiser) maschinell durchgesetzt sein.

**Selbsttest:**
- Hat dein Implementation-Agent vor der Codegenerierung einen Plan ausgegeben?
- Kannst du den Lauf reproduzieren? (Replay-Voraussetzung, Phase 04)
- Liegt jede Hard Rule in *einem oder zwei* Quadranten der 2×2-Matrix (siehe [`klassifikation.md`](klassifikation.md))?

Wer hier hängenbleibt, sollte Modul 7 und 8 erneut durchgehen.

## Checkpoint D — nach Phase 04 (Qualität)

**Aufgabe:** Baue für dein Mini-Feature das volle Gate-Set auf und mache
einen Replay-Lauf.

1. `make lint`, `make typecheck`, `make arch-check`, `make coverage-gate` (oder Sprach-Äquivalente) als Make-Targets — alle grün auf einem frischen Klon.
2. Reviewer-Agent läuft gegen den fingierten kaputten Slice aus
   [`/lab/example/exercises/09-review-fixture/`](../../../lab/example/exercises/09-review-fixture/)
   und findet alle drei eingebauten Fehler in den *richtigen* Kategorien.
3. Replay-Lauf gegen ein Golden Set (mindestens 3 Eingabe/Erwartungs-Paare).
4. Provoziere einen DoD-Verstoß und prüfe, ob deine Verifikation ihn fängt.

**Selbsttest:**
- Erzwingt dein `make gates` die Kategorisierung-Disziplin (Reviewer kategorisiert HIGH/MEDIUM/LOW/INFO)?
- Hast du mindestens einen *bootstrap-aware* Gate (mit dokumentierter Hochschalt-Schwelle)?
- Kannst du am Replay-Lauf erkennen, ob ein neues Modell schlechter geworden ist als das alte?

Wer hier hängenbleibt, sollte Modul 9–12 erneut durchgehen.

## Checkpoint E — nach Phase 05 (Betrieb)

Identisch mit dem [Abschlussprojekt](../abschluss/abschlussprojekt.md).
Phase 05 ist die letzte fachliche Phase; ein eigener Mini-Checkpoint
wäre redundant zum Abschluss.

## Wann ist ein Checkpoint "bestanden"?

Nicht: "alle Häkchen gesetzt".
Sondern: *Du kannst die vier Reflexionsfragen aus
[`reflexion-vorlage.md`](reflexion-vorlage.md) für jeden absichtlich
provozierten Fehler in der Phase beantworten — schriftlich.*

Wer einen Checkpoint nur halb schafft, schafft das Abschlussprojekt
nicht ganz. Lieber im Checkpoint stolpern als am Abschluss.

## Pass-Through-Logik zum Abschlussprojekt

Die Checkpoints und das [Abschlussprojekt](../abschluss/abschlussprojekt.md)
sind keine getrennten Welten. Jede Bewertungsachse des Abschlussprojekts
hat einen direkten Vorboten in einem Checkpoint:

| Abschluss-Achse | Vorbereitender Checkpoint | Wenn dort nicht erreicht … |
|---|---|---|
| Vollständigkeit | A (Spec/ADR/Harness-Skizze vorhanden) | → später keine "solide" auf Vollständigkeit; Modul 1–3 vertiefen. |
| Konsistenz | A (Source Precedence) + B (Carveout-Folge-Slice) | → Konsistenz bleibt auf "funktional"; Modul 1 §Source Precedence und Modul 6 vertiefen. |
| Reproduzierbarkeit | C (8-Schritt-Workflow reproduzierbar) + D (Gates auf frischem Klon) | → Reproduzierbarkeit auf "rudimentär"; Modul 8, 12, 13 vertiefen. |
| Auditierbarkeit | B (Slice-IDs) + C (Hard Rules mit ID) | → Auditierbarkeit bleibt auf "funktional"; ID-Schema und Traceability-Hook nachholen (Modul 2, 12). |
| Steering-Loop-Reife | D (DoD-Verstoß provoziert + Reflexion) | → Steering-Loop bleibt auf "rudimentär"; Reflexionsvorlage und Modul 11 vertiefen. |

**Diagnose-Regel:** Wer im Abschlussprojekt mehr als eine Achse auf
*rudimentär* hat, schließt typischerweise eine Phase-Lücke nicht — nicht
eine Modul-Lücke. Die Tabelle oben sagt dir, *welche Phase*. Geh dort
zurück, mache den entsprechenden Checkpoint vollständig, **bevor** du
das Abschlussprojekt erneut versuchst.

**Empfohlene Sequenz:**

1. Modul lesen und Übungen machen.
2. Phasen-Checkpoint vollständig — *inkl. schriftlicher Reflexionsfragen*.
3. Erst dann nächste Phase beginnen.
4. Nach Phase 05: Abschlussprojekt mit den Kalibrierungsbeispielen aus
   [`kalibrierungsbeispiele.md`](../abschluss/kalibrierungsbeispiele.md)
   gegenlesen, *bevor* du abgibst.

Wer Checkpoints überspringt und das Abschlussprojekt direkt angeht, lernt
nur, wo die Lücken sind, ohne sie geschlossen zu haben — und gibt ein
Abschlussprojekt ab, das in der Bewertung typischerweise auf zwei
*rudimentär*-Achsen landet. Das ist behebbar, aber nicht effizient.
