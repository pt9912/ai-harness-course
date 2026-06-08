# Modul 3 — Lastenheft und Spezifikation

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

* ein Lastenheft mit IDs, Akzeptanzkriterien (Happy/Boundary/Negative) und expliziter Out-of-Scope-Liste *verfassen* (Erschaffen · prozedural),
* funktionale und nichtfunktionale Anforderungen *unterscheiden* und Grenzfälle (z. B. Latenz) *einordnen* (Analysieren · konzeptuell),
* eine Spec-Lücke *diagnostizieren*, indem du sie absichtlich provozierst und das Agentenverhalten beobachtest (Bewerten · prozedural+metakognitiv),
* Spec-Stratifizierung (Lastenheft/Spezifikation/Architektur) für ein Repo *entwerfen* (Erschaffen · konzeptuell).

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

## Vorab — was hältst du heute für wahr?

*Bevor du die Kernidee liest:* notiere in einem Satz deine spontane
Antwort auf jede dieser drei Fragen.

1. *"Sind Akzeptanzkriterien immer Happy-Path-Beschreibungen, oder gehört da noch etwas dazu?"*
2. *"Performance < 200 ms — funktionale oder nichtfunktionale Anforderung?"*
3. *"Was gewinnst du, wenn Out-of-Scope explizit in der Spec steht — was verlierst du, wenn es implizit bleibt?"*

Lass die Notiz neben dem Modul liegen. Am Modul-Ende prüft der
Selbstcheck genau diese drei Punkte — und vergleicht mit der scharfen
Konfrontation im Block *Typische Fehlvorstellungen*.

## Kernidee

Ein Agent ist ein extrem buchstabengetreuer Praktikant. Was nicht in der
Spec steht, existiert für ihn nicht — Lopopolos Maxime: *"Was der Agent
nicht im Kontext erreicht, existiert für ihn nicht."* Was zweideutig in der Spec
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
- **"Prompts ersetzen Specs."** — Verbreitet aus der agil/Lean-Ecke ("Code statt Doku"). Falsch. Lopopolos Maxime *"Was der Agent nicht im Kontext erreicht, existiert für ihn nicht"* ist ein Plädoyer *für* Kontext-Verfügbarkeit — und sagt damit, dass Spec und Prompt *unterschiedliche* Lebenszyklen haben: Spec wird *gepflegt* (Versions-Geschichte, Bezüge, Audit), Prompt wird *für einen Lauf zusammengestellt*. Was im Prompt steht, aber nicht in der Spec, gilt nur für *diesen* Lauf — der nächste Agent sieht es nicht. Engage-Geschichte oben (Spec sagte *speichert*, Agent baute PostgreSQL) wäre mit einem Mega-Prompt nicht besser geworden — der Prompt würde im nächsten Lauf vergessen.

## Worked Example: vom vagen Satz zum prüfbaren Akzeptanzkriterium

> **Wenn du Akzeptanzkriterien im Given/When/Then bereits routiniert schreibst, springe direkt zu [§Übungen](#übungen).** Worked Examples helfen beim Aufbau eines Schemas; ist das Schema da, kostet das Wiederholen nur Last (Expertise-Reversal). Bei Unsicherheit: dieses Worked Example als Schablone lesen.

> *Rückbezug zur Kapur-Vorab-Übung* (falls du sie gemacht hast): Im nächsten Schritt 4 (Boundary) und Schritt 5 (Negative) löst sich genau die Reibung auf, die dein Vorab-Agent dir gezeigt hat. Markiere deine drei Vorab-Anforderungen jetzt mit *Happy/Boundary/Negative*-Tags — wie viele Tags bleiben leer? Die leeren Tags sind die Stellen, an denen dein Agent "geraten hat", obwohl du dachtest, du hättest die Anforderung "klar genug" formuliert.

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
* **Drei-Schichten-Übung** — aktiviert das Erschaffens-Lernziel (LZ 4) zur
  Spec-Stratifizierung. Nimm dein Mini-Feature aus der ersten Übung und
  verteile seinen Inhalt auf drei Dateien — `lastenheft.md` (vertragliches
  *Was*), `spezifikation.md` (präzisiertes *Wie genau*), `architektur.md`
  (strukturelles *Wodurch*). Pflicht pro Schicht: *ein* Inhalt, der dort
  zwingend gehört, und *ein* Inhalt, der dort fehl am Platz wäre (z. B.
  gehört "Antwort als gültiges JSON" ins Lastenheft, "Service-Layer ruft
  nie direkt die DB" in die Architektur). Formuliere zum Schluss die
  *Konfliktregel*: Was gilt, wenn dieselbe Aussage in zwei Schichten
  auftaucht (Lastenheft sticht Spezifikation sticht Architektur — die
  untere Schicht darf *präzisieren*, nie *erweitern*)? Vorbild:
  Spec-Stratifizierung in `c-hsm-doc`
  ([`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)).
  Vorlagen: [`spec/`-Templates](../../../lab/templates/spec/).

### Minimaler Übungspfad

1. Öffne die Übung
   [`../../../lab/example/exercises/02-lastenheft.md`](../../../lab/example/exercises/02-lastenheft.md).
2. Schreibe erst nur eine `LH-FA-*`-Anforderung mit Happy Path,
   Boundary und Negative.
3. Vergleiche anschließend mit
   [`../../../lab/example/spec/lastenheft.md`](../../../lab/example/spec/lastenheft.md):
   Fehlt bei dir ein Negativsatz, ist die Spec für einen Agenten noch
   nicht scharf genug.

> *Lab-Grenze:* Der minimale Pfad übt **eine** Anforderung mit drei
> Akzeptanzkriterien. Das volle LZ "Lastenheft *verfassen*" und das LZ
> "Spec-Stratifizierung *entwerfen*" werden erst durch die freie
> Lastenheft-Übung oben und die Drei-Schichten-Übung (LZ 4) abgerufen —
> der minimale Pfad ist Aufwärm-, nicht Ziel-Niveau.

## Reflexion

Verwende die vier Standardfragen aus [`reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md)
(Beobachtung · 2×2-Quadrant · Steering-Loop · Conceptual Change) nach
jeder Übung — besonders nach dem absichtlich provozierten Spec-Bug.
Modul-spezifische Trigger:

- **Beobachtung:** Welcher Negativsatz fehlte? Welche stille Annahme hat der Agent gefüllt?
- **2×2-Quadrant:** Spec-Lücken sind klassisch *inferential feedforward*.
- **Steering-Loop:** Spec-Template um Negativ-Pflichtfeld erweitern? Worked Example als Repo-Skill hinterlegen?
- **Conceptual Change:** Kandidaten in [`lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "Akzeptanzkriterien sind der Happy Path", "Out-of-Scope kann implizit bleiben").

## Selbstcheck

* **(Erinnern)** Welche drei Akzeptanzkriterien-Arten muss ein vollständiger `LH-FA-*`-Eintrag laut Worked Example tragen?
* Welche drei Tests würden ein Akzeptanzkriterium falsifizieren?
* Wo gehört "Performance < 200 ms" hin — funktional oder nichtfunktional?
* **(Erschaffens-Prozess)** Welcher Schritt deines Lastenheft-Schreibens war der *unsicherste* — und warum? (Erfahrungsgemäß: Schritt 5 "Negative" oder Schritt 6 "Out-of-Scope".)
* **(Erschaffen — aktiviert LZ 4)** Entwirf für dein Mini-Feature eine Drei-Schichten-Spec-Stratifizierung (`lastenheft.md` · `spezifikation.md` · `architektur.md`): nenne *je* einen Inhalt, der in dieser Schicht zwingend gehört, und einen Inhalt, der dort *fehl am Platz* wäre. Welche Regel löst den Konflikt, wenn dieselbe Aussage in zwei Schichten auftaucht?
* **(Bewerten — aktiviert LZ 3)** Provoziere mit deinem Lastenheft einen Agentenlauf und benenne *eine* konkrete Lücke, die das beobachtete Verhalten offenlegt (z. B. Agent erfindet ein Default-Limit, weil kein Boundary-Kriterium existiert): Diagnostiziere, *welcher* fehlende Spec-Bestandteil die Fehlinterpretation zuließ. Und metakognitiv: welche *eigene* Annahme — die dir beim Schreiben selbstverständlich schien — hat genau diese Lücke verdeckt?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Drei Akzeptanzkriterien-Arten eines vollständigen `LH-FA-*`? | "Tests." | Happy Path, Boundary, Negative — alle drei im Given/When/Then-Stil, ergänzt um eine explizite Out-of-Scope-Liste. | + Begründung: ohne Boundary und Negative trifft der Agent die *für dich ungünstigste* Interpretation; Out-of-Scope ist die einzige Klammer, die plausibel-Anbau verhindert. |
| Drei Tests, die ein Akzeptanzkriterium falsifizieren? | "Tests dagegen." | Happy Path · Boundary · Negative — drei verschiedene Test*arten*, nicht drei Test*fälle*. | + Hinweis, dass Boundary/Negative die stillen Annahmen des Happy Path widerlegen — *genau die*, die ein Agent als "selbstverständlich" behandelt. |
| "Performance < 200 ms" — funktional oder nichtfunktional? | "Nichtfunktional." | Nichtfunktional, weil ohne Lasttest nicht prüfbar; gehört in QA-Block oder `spec/spezifikation.md`. | + Abgrenzung "*Antwort innerhalb von* 200 ms" ist Latenz-*Garantie* (nichtfunktional); "System antwortet mit gültigem JSON" wäre funktional. |
| Unsicherster Schritt des Lastenheft-Schreibens? | Schritt vage benannt ohne Begründung ("Schritt 5 war schwer."). | Konkret benannter Schritt + Begründung (z. B. "Schritt 5 Negative, weil ich erst beim Hinschreiben gemerkt habe, *was* ausgeschlossen werden muss"). | + Pointe: wer keinen unsicheren Schritt findet, hat den Worked Example *gelesen* statt *nachgebaut*. Schritte 5 (Negative) und 6 (Out-of-Scope) sind die häufigsten unsicheren Stellen — und damit auch die häufigsten Spec-Lücken. |
| Spec-Lücke aus provoziertem Lauf diagnostiziert? | Lücke pauschal benannt ("Spec war unklar.") ohne Bezug zum beobachteten Agentenverhalten. | Konkrete Lücke aus dem Lauf benannt + welcher Bestandteil fehlte (z. B. Boundary-Kriterium), der die Fehlinterpretation zuließ. | + metakognitive Hälfte: die *eigene* stille Annahme benannt, die die Lücke verdeckte ("ich hielt das Default-Limit für offensichtlich") — und der Schluss, dass genau die selbstverständlichen Annahmen die teuersten Lücken sind. |
| Drei-Schichten-Spec-Stratifizierung entworfen? | Drei Schichten genannt, aber Inhalt aus zwei Schichten austauschbar formuliert. | Pro Schicht ein Pflicht-Inhalt und ein Anti-Inhalt; Konfliktregel formuliert (z. B. "Lastenheft sticht Spezifikation sticht Architektur — Spezifikation darf Lastenheft *präzisieren*, nie *erweitern*"). | + Zweite Konfliktregel für den Fall, dass die Architektur eine Spezifikations-Aussage *technisch unmöglich* macht: Pfad zurück über ADR-Supersedure und Spec-Update, nicht durch stille Anpassung. Verweis auf Spec-Stratifizierung in `c-hsm-doc` ([`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)). |

## Weiterlesen

* Spec-Stratifizierung im Detail: [`../grundlagen/konventionen.md#spec-stratifizierung`](../grundlagen/konventionen.md#spec-stratifizierung)
* Reales Beispiel mit Lastenheft/Spezifikation-Trennung: `pt9912/c-hsm-doc` in [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
* Vorheriges Modul: [Modul 2 — Harness-Bootstrap](modul-02-harness-bootstrap.md)
* Nächstes Modul: [Modul 4 — Architektur und ADRs](modul-04-architektur-adrs.md)
