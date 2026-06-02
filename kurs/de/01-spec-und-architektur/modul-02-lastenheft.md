# Modul 2 — Lastenheft und Spezifikation

> **Aufwand:** ca. 90 Min Lesen · 90 Min Übung. Spiralcurriculum: ID-Schema und Source Precedence kennst du aus [Modul 1](modul-01-entwicklungszyklus.md) — hier werden sie zum Arbeitswerkzeug.

## Optionale Explorations-Vorab-Übung (Kapur-Stil)

Wenn du eine *echte* Productive-Failure-Variante (Kapur 2008, 2014)
ausprobieren willst: **vor** dem Lesen dieses Moduls 25 Minuten ohne
Anleitung schreiben.

> **Aufgabe (optional, 25 Min):** Wähle ein kleines Feature, das du gut
> kennst (Konfigurations-Reader, CSV-Importer, Slack-Bot-Befehl).
> Schreibe in **freier Form** drei Anforderungen dafür auf — so, wie du
> es heute jemand anderem zur Implementierung geben würdest. Maximal
> eine A4-Seite. Gib das Ergebnis dann einem LLM-Agenten und bitte ihn,
> es zu implementieren. Beobachte: an welchen Stellen rät er, an
> welchen erfindet er, an welchen fragt er nach (falls er das tut)?
>
> Erfolg ist *nicht*, dass der Agent es richtig macht. Erfolg ist, dass
> du fühlst, wo deine Anforderung Lücken hat.

Nach dem Modul-Lesen: vergleiche deine drei Anforderungen mit dem
Worked Example unten und der `LH-FA-CFG-001`-Vorlage in
[`/lab/example/spec/lastenheft.md`](../../../lab/example/spec/lastenheft.md).
Reflektiere mit
[`../grundlagen/reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md) —
insbesondere Frage 4 (welche Vorstellung von "klar genug" wurde
unzufriedenstellend?).

Wenn du keine Zeit hast: überspringen ist okay. Das Worked Example unten
trägt das Modul auch ohne Vorab-Übung.

## Engage

In einem realen Projekt sagte das Lastenheft *"das System speichert die
Konfiguration"*. Der Agent baute eine PostgreSQL-Anbindung — gefordert
war eine YAML-Datei. Ein Verb (*speichern*) entschied über 40 Stunden
Folgearbeit. Was hätte in der Spec gestanden haben müssen, damit der
Agent nicht in die DB-Richtung kippt? Antwort: ein Negativsatz, eine
Boundary, oder beides.

## Lernziele

Nach diesem Modul kannst du:

* ein Lastenheft mit IDs, Akzeptanzkriterien (Happy/Boundary/Negative) und expliziter Out-of-Scope-Liste *verfassen* (Erschaffen),
* funktionale und nichtfunktionale Anforderungen *unterscheiden* und Grenzfälle (z. B. Latenz) *einordnen* (Analysieren),
* eine Spec-Lücke *diagnostizieren*, indem du sie absichtlich provozierst und das Agentenverhalten beobachtest (Bewerten),
* Spec-Stratifizierung (Lastenheft/Spezifikation/Architektur) für ein Repo *entwerfen* (Erschaffen).

## Lab-Bezug

* `spec/`
* [`../../../lab/example/exercises/02-lastenheft.md`](../../../lab/example/exercises/02-lastenheft.md)

## Themen

* Anforderungen
* Nichtfunktionale Anforderungen
* Akzeptanzkriterien
* Scope und Out-of-Scope
* Spec-Qualität für Agentenkonsum (Eindeutigkeit, Negativbedingungen, Beispiele)
* Spec-Stratifizierung (Lastenheft vertraglich, Spezifikation technisch, Architektur diagrammatisch)
* ID-Schema (z. B. `LH-*`, `HSM-*`) als Klammer zwischen Anforderung, Make-Target und Commit

## Harness-Einordnung

Spec = *inferential feedforward* (siehe
[`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)).
Sie ist die billigste Kontrolle: Was die Spec sauber ausschließt, kommt
im Review nicht mehr vor.

## Kernidee

Ein Agent ist ein extrem buchstabengetreuer Praktikant. Was nicht in der
Spec steht, existiert für ihn nicht — Lopopolos Maxime: *"anything it
can't access in-context doesn't exist."* Was zweideutig in der Spec
steht, wird auf die für dich ungünstigste Weise interpretiert.

**Grenze der Metapher.** Die Praktikant-Metapher trägt nur die
*Buchstabentreue*. Anders als ein echter Praktikant **vergisst** der
Agent zwischen den Aufgaben — was nicht im Kontext steht, war für ihn
nie da (siehe Glossar in
[`../grundlagen/konventionen.md#kernbegriffe`](../grundlagen/konventionen.md#kernbegriffe):
LLM ist *stateless*). Wer die Metapher zu weit treibt, erwartet
"Mitlernen" — und plant Reviews, als würden sie *einmal* erklärt
ausreichen. Sie reichen nicht. Jeder Lauf beginnt bei Null.

## Typische Fehlvorstellungen

- **"Akzeptanzkriterien sind 'der Happy Path'."** — Happy Path widerlegt nur die These "es funktioniert gar nicht". Boundary und Negative widerlegen die stillen Annahmen, *die ein Agent am liebsten als selbstverständlich behandelt*.
- **"Negativbedingungen sind unhöflich."** — Im Gegenteil: ein Satz "das System *darf nicht* …" spart später drei Reviews. Negativ ist genauso präzise wie positiv.
- **"Performance gehört in den ADR."** — Nein, Performance gehört in den nichtfunktionalen Block der Spec (oder in `spec/spezifikation.md`, wenn stratifiziert). Der ADR begründet, *wie* man die Schwelle einhält.
- **"Out-of-Scope kann implizit bleiben."** — Was nicht explizit ausgeschlossen ist, baut der Agent plausibel mit. Das ist die häufigste Quelle für "wir hatten das nie gefordert"-PRs.

## Worked Example: vom vagen Satz zum prüfbaren Akzeptanzkriterium

> **Wenn du Akzeptanzkriterien im Given/When/Then bereits routiniert schreibst, springe direkt zu [§Übungen](#übungen).** Worked Examples helfen beim Aufbau eines Schemas; ist das Schema da, kostet das Wiederholen nur Last (Expertise-Reversal). Bei Unsicherheit: dieses Worked Example als Schablone lesen.

**Ausgangstext (vage):**
> "Das System speichert die Konfiguration."

**Schritt 1 — Mehrdeutigkeiten markieren:** *speichert* (DB? Datei? Cache?), *die* (welche?), *Konfiguration* (welche Felder?).

**Schritt 2 — ID vergeben:** `LH-FA-CFG-001`.

**Schritt 3 — Happy Path konkret:**
> Given eine gültige Konfigurationsdatei `config.yaml` mit den Pflichtfeldern `name`, `version`,
> When das System startet,
> Then liest es die Datei *aus dem Arbeitsverzeichnis* und gibt `name@version` auf stdout aus.

**Schritt 4 — Boundary:**
> Given `config.yaml` ist leer,
> When das System startet,
> Then bricht es mit Exit-Code 2 ab und meldet `LH-FA-CFG-001: empty config`.

**Schritt 5 — Negative (zwei Sätze):**
> Given keine `config.yaml` existiert,
> When das System startet,
> Then bricht es mit Exit-Code 1 ab und schreibt keine Datei.
>
> Das System *darf nicht* Konfiguration in Datenbanken, externen APIs oder versteckten Verzeichnissen ablegen.

**Schritt 6 — Out-of-Scope:**
> Out-of-Scope (LH-FA-CFG-001): Schreiboperationen, Migration zwischen Versionen, Verschlüsselung.

Sechs Schritte, ein vollständig prüfbares Akzeptanzkriterium. Vergleich
mit dem Lab-Beispiel: [`/lab/example/spec/lastenheft.md`](../../../lab/example/spec/lastenheft.md).

## Übungen

* Erstellung eines vollständigen Lastenhefts für ein kleines Feature
* Provoziere absichtlich einen Spec-Bug: lass den Agenten gegen eine unterspezifizierte Anforderung laufen und benenne, was schiefging

### Minimaler Übungspfad

1. Öffne die Übung
   [`../../../lab/example/exercises/02-lastenheft.md`](../../../lab/example/exercises/02-lastenheft.md).
2. Schreibe erst nur eine `LH-FA-*`-Anforderung mit Happy Path,
   Boundary und Negative.
3. Vergleiche anschließend mit
   [`../../../lab/example/spec/lastenheft.md`](../../../lab/example/spec/lastenheft.md):
   Fehlt bei dir ein Negativsatz, ist die Spec für einen Agenten noch
   nicht scharf genug.

## Reflexion

Nach jeder Übung — besonders nach dem absichtlich provozierten Spec-Bug — kurz **schriftlich**:

1. **Was ist beobachtbar passiert?** — Welcher Negativsatz fehlte? Welche stille Annahme hat der Agent gefüllt?
2. **Welcher 2×2-Quadrant war Ursache?** — Computational/Inferential × Feedforward/Feedback (siehe [`konzeptkarte.md §2x2-Schnellanker`](../grundlagen/konzeptkarte.md#2x2-schnellanker)). Spec-Lücken sind klassisch *inferential feedforward*.
3. **Welche konkrete Steering-Loop-Aktion folgt?** — Spec-Template um Negativ-Pflichtfeld erweitern? Worked Example als Repo-Skill hinterlegen?
4. **Welche eigene Vorstellung wurde unzufriedenstellend?** — Conceptual Change; Kandidaten in [`lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "Akzeptanzkriterien sind der Happy Path", "Out-of-Scope kann implizit bleiben").

Eintragsformat, "Wann *nicht* reagieren" und Anti-Antworten: [`reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md).

## Selbstcheck

* **(Erinnern)** Welche drei Akzeptanzkriterien-Arten muss ein vollständiger `LH-FA-*`-Eintrag laut Worked Example tragen?
* Welche drei Tests würden ein Akzeptanzkriterium falsifizieren?
* Wo gehört "Performance < 200 ms" hin — funktional oder nichtfunktional?
* **(Erschaffens-Prozess)** Welcher Schritt deines Lastenheft-Schreibens war der *unsicherste* — und warum? (Erfahrungsgemäß: Schritt 5 "Negative" oder Schritt 6 "Out-of-Scope".)

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Drei Akzeptanzkriterien-Arten eines vollständigen `LH-FA-*`? | "Tests." | Happy Path, Boundary, Negative — alle drei im Given/When/Then-Stil, ergänzt um eine explizite Out-of-Scope-Liste. | + Begründung: ohne Boundary und Negative trifft der Agent die *für dich ungünstigste* Interpretation; Out-of-Scope ist die einzige Klammer, die plausibel-Anbau verhindert. |
| Drei Tests, die ein Akzeptanzkriterium falsifizieren? | "Tests dagegen." | Happy Path · Boundary · Negative — drei verschiedene Test*arten*, nicht drei Test*fälle*. | + Hinweis, dass Boundary/Negative die stillen Annahmen des Happy Path widerlegen — *genau die*, die ein Agent als "selbstverständlich" behandelt. |
| "Performance < 200 ms" — funktional oder nichtfunktional? | "Nichtfunktional." | Nichtfunktional, weil ohne Lasttest nicht prüfbar; gehört in QA-Block oder `spec/spezifikation.md`. | + Abgrenzung "*Antwort innerhalb von* 200 ms" ist Latenz-*Garantie* (nichtfunktional); "System antwortet mit gültigem JSON" wäre funktional. |
| Unsicherster Schritt des Lastenheft-Schreibens? | "Alles klar." (verdächtig) | Konkret benannter Schritt + Begründung (z. B. "Schritt 5 Negative, weil ich erst beim Hinschreiben gemerkt habe, *was* ausgeschlossen werden muss"). | + Pointe: wer keinen unsicheren Schritt findet, hat den Worked Example *gelesen* statt *nachgebaut*. Schritte 5 (Negative) und 6 (Out-of-Scope) sind die häufigsten unsicheren Stellen — und damit auch die häufigsten Spec-Lücken. |

## Weiterlesen

* Spec-Stratifizierung im Detail: [`../grundlagen/konventionen.md#spec-stratifizierung`](../grundlagen/konventionen.md#spec-stratifizierung)
* Reales Beispiel mit Lastenheft/Spezifikation-Trennung: `pt9912/c-hsm-doc` in [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
* Nächstes Modul: [Modul 3 — Architektur und ADRs](modul-03-architektur-adrs.md)
