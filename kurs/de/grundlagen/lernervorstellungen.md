# Lernervorstellungen

## Was diese Datei ist

Eine **offene Sammlung** typischer Vorstellungen, mit denen Lernende in
diesen Kurs einsteigen — als Anker für die "Typische
Fehlvorstellungen"-Blöcke in den Modulen.

## Was diese Datei *nicht* ist

Keine empirische Studie. Die hier gesammelten Präkonzepte sind aus der
**Praxiserfahrung der Autoren** (Reviews, Postmortems, Tech-Lead-Gespräche,
Open-Source-Mitarbeit in den vier Fallstudien-Repos) destilliert — nicht
aus Interviews, Fragebögen oder einem Postmortem-Korpus. Damit fehlt die
erste Säule der Didaktischen Rekonstruktion (Kattmann et al. 1997) im
methodischen Vollausbau. Die Liste ist plausibel, nicht repräsentativ.

Wenn du den Kurs in einer Organisation einsetzt: ergänze diese Liste um
*deine* Beobachtungen. Eine fünfminütige Eingangsfrage im Kickoff
("Welche Aussage über KI-Agenten würdest du sofort unterschreiben?")
deckt oft Präkonzepte auf, die diese Liste nicht enthält. Eine
strukturierte Vorlage mit drei kalibrierten Vorlauffragen und einem
YAML-Sammelplatz steht in
[`kickoff-vorlauf.md`](kickoff-vorlauf.md) — sie operationalisiert
diese Aufforderung in zehn Minuten Workshop-Zeit.

## Sammlung

Sortiert nach Modulen, in denen sie primär adressiert werden. Sterne
markieren Präkonzepte, die der Kurs heute *nicht* explizit als
Fehlvorstellungs-Block aufgreift — Kandidaten für die nächste
Iteration.

### Über KI-Agenten und LLMs (Modul 0–3; Folge-Adressierung in Modul 9)

- "Wir brauchen erst ein besseres Modell." — Modul 0
- "Wir bauen einen Mega-Prompt." — Modul 0
- "Der Agent muss nur freier entscheiden dürfen." — Modul 0
- "Ein Agent ist ein besserer/schnellerer Programmierer." — Modul 9
  (Fehlvorstellungs-Block; seit Welle 13 explizit benannt mit
  Geschwindigkeits-Argument und Lopopolo-Skalierungs-Beleg).
- "Halluzinationen sind ein Bug des Modells." — Modul 0
  (Fehlvorstellungs-Block; seit Welle 7 explizit benannt mit Verweis auf
  Kontext-Ursachen und Wiederholungs-Empirie nach Modellwechsel).
- "Agenten lernen mit der Zeit, wenn man sie länger benutzt." — Modul 3
  (Kernidee-Block "Grenze der Metapher"; seit Welle 7 explizit gegen
  Praktikant-Metapher abgegrenzt).

### Über Harness-Bootstrap (Modul 2)

- "Bootstrap ist ein einmaliges Initialisierungs-Event." — Modul 2 (FV1)
- "GF/BF ist eine Eigenschaft des Repos als Ganzes." — Modul 2 (FV2)
- "Wer im Greenfield arbeitet, kann auf Trigger-Klassen verzichten." — Modul 2 (FV3)
- "Brownfield ist eine Notlage, die man möglichst schnell überwindet." — Modul 2 (FV4)
- "Jede Struktur ist automatisch eine Sub-Area." — Modul 2 (FV5;
  Granularitäts-Wurzel — verwandt mit der Modul-5-Vorstellung "wenn der
  Slice klein ist, ist die Sub-Area GF" im Cluster *Über Planung*:
  Substanz/Reife aus einem Oberflächenmerkmal abgelesen statt geprüft).
- "Trigger-Klassen sind Bürokratie-Overhead." — Modul 2 (FV3-Variante;
  zielt nicht auf "GF braucht keine Trigger", sondern auf "auch in GF
  nur Aufwand"). Modul 2 §Vorab-Frage 3 zielt explizit auf diese
  Variante, weil sie die häufigste implizite Annahme bei
  GF-erfahrenen Lernenden ist.

### Über Spec und Anforderungen (Modul 3)

- "Akzeptanzkriterien sind der Happy Path." — Modul 3
- "Negativbedingungen sind unhöflich." — Modul 3
- "Out-of-Scope kann implizit bleiben." — Modul 3
- "Performance gehört in den ADR." — Modul 3
- "Prompts ersetzen Specs." — Modul 3 (Fehlvorstellungs-Block; seit
  Welle 13 explizit benannt mit Lebenszyklus-Argument Spec vs. Prompt).

### Über Architektur und ADRs (Modul 4)

- "Eine ADR begründet eine Anforderung." — Modul 4
- "Wenn ich die Entscheidung ändere, schreibe ich die ADR um." — Modul 4
- "Eine ADR ohne Fitness Function ist eine ADR." — Modul 4
- "MADR ist Pflicht." — Modul 4
- "ADRs sind Dokumentation, nicht Constraints." — Modul 4
  (Fehlvorstellungs-Block; seit Welle 13 explizit benannt mit
  Fitness-Function-Argument und Verweis auf Worked Example Modul 13).
- "Architektur ist Bilder zeichnen." — Modul 4
  (Fehlvorstellungs-Block; seit Welle 7 explizit benannt mit Bezug auf
  Spec-Stratifizierung).

### Über Planung (Modul 5–7)

- "Plan ist nur eine Liste von Tickets." — Modul 1
- "Slice = Ticket = Feature." — Modul 5
- "Erst plan ich alle Slices, dann fange ich an." — Modul 5
- "Wenn ein Slice in `done/` ist, ist er fertig." — Modul 5
- "Ein Slice hat einen Bootstrap-Modus." — Modul 5
  (Fehlvorstellungs-Block; entsteht typisch als Übertragung aus der
  Klassifikations-Übung in Modul 2 — Anlass *Slice* wird mit Träger
  der Modus-Entscheidung *Sub-Area* verwechselt).
- "Wenn der Slice klein ist, ist die berührte Sub-Area GF." — Modul 5
  (Fehlvorstellungs-Block; transitive Vereinfachung von Slice-Größe
  auf Sub-Area-Reife — zwei orthogonale Achsen).
- "Roadmap ist eine Datumsleiste." — Modul 6
- "Burndown ist Fortschritt." — Modul 6
- "Welle = Sprint." — Modul 6
- "Trigger = Datum." — Modul 6
- "Carveout = Workaround." — Modul 7
- "Carveouts gehören ins Issue-Tracker." — Modul 7
- "Wenn der Trigger eintritt, lösen wir den Carveout auf." — Modul 7
- "Jede entdeckte Diskrepanz ist ein eigener Carveout." — Modul 7
  (Fehlvorstellungs-Block; trainiertes Verfahren auf falschen Fall
  übertragen — Diskrepanz-Häufung in einer Sub-Area gehört nicht in
  eine Carveout-Kaskade, sondern in eine BF-Sub-Area-Markierung mit
  Graduation-Plan).
- "Wenn Diskrepanz-Häufung BF-Markierung verlangt, ist auch jede
  einzelne Diskrepanz eine BF-Markierung wert." — Modul 7
  (Fehlvorstellungs-Block; Pendel-Überschwingen nach Conceptual
  Change — die Schwester-FV zur vorigen, die typisch nach P7-Lese-
  Erlebnis auftritt, wenn der Lerner die Carveout-FV gerade
  überwunden hat).

### Über Agentenrollen und Implementation (Modul 8–9)

- "Eine Person spielt alle Rollen." — Modul 8
- "Reviewer macht das Verification gleich mit." — Modul 8
- "Validation machen wir vor Release." — Modul 8
- "Architect entscheidet, Implementation widerspricht nicht." — Modul 8
- "Agent liefert schnell, also ist der Workflow Overhead." — Modul 9
- "Hard Rules schreibe ich in AGENTS.md, und das reicht." — Modul 9
- "Wenn die Tests grün sind, ist der Slice fertig." — Modul 9
- "Die Pre-completion Checklist ist Bürokratie." — Modul 9

### Über Qualität und Gates (Modul 10–13)

- "Reviewer ist ein zweiter Implementer." — Modul 10
- "Findings ohne Prioritätssortierung." — Modul 10
- "Reviewer-Agent läuft ohne Skill-Datei." — Modul 10
- "Wenn der Reviewer-Agent dasselbe zweimal anders kategorisiert, nehmen
  wir die mildere." — Modul 10
- "Grüne Tests sind Verifikation." — Modul 11
- "Verifier braucht denselben Kontext wie Reviewer." — Modul 11
- "Wenn Verifier rot und Reviewer grün, hat Reviewer recht." — Modul 11
- "Wenn der Replay grün ist, ist das Modell gut." — Modul 12
- "Golden Set ist statisch." — Modul 12
- "Determinismus = Reproduzierbarkeit." — Modul 12
- "Gate = Lint." — Modul 13
- "Wenn ein Gate manchmal rot sein darf, ist das pragmatisch." — Modul 13
- "Coverage 80 % ist die richtige Schwelle." — Modul 13
- "`make gates` lokal grün heißt fertig." — Modul 13
- "Mehr Tests sind immer besser." — Modul 13 (Fehlvorstellungs-Block;
  seit Welle 7 explizit benannt mit Faustregel *Verteilung vor Anzahl*).

### Über Betrieb (Modul 14–16)

- "FROM python:3 ist konkret genug." — Modul 14
- "Lock-Files sind nur für Python." — Modul 14
- "Docker-only ist Overkill für Tools." — Modul 14
- "Devcontainer ersetzt Compose." — Modul 14
- "Logs reichen." — Modul 15
- "Metriken sind nur für Performance." — Modul 15
- "Prompt-Caching ist Modell-Sache." — Modul 15
- "Trace teurer Tool-Call = unnötiger Tool-Call." — Modul 15
- "Rollback ist die Standardantwort." — Modul 16
- "Runbook beschreibt den Happy Path." — Modul 16
- "Produktionsfreigabe ist eine formale Checkbox." — Modul 16
- "Prompt-Injection ist eine Modell-Frage." — Modul 16
- "DevOps ist YAML schreiben." — Modul 14 (Fehlvorstellungs-Block; seit
  Welle 13 explizit benannt mit Reproduzierbarkeits-Anker-Argument und
  Replay-Brücke zu Modul 12).
- "Postmortems sind Schuldzuweisung." — Modul 16 (Fehlvorstellungs-Block;
  seit Welle 7 explizit benannt mit Sensor-Schutz-Argument für blameless).

## Wie diese Liste verwendet wird

In den Modulen erscheint **eine Auswahl** dieser Vorstellungen als
"Typische Fehlvorstellungen"-Block — mit Konfrontation und Begründung.
Die mit `*` markierten Einträge sind dokumentierte Lücken; Mitwirkende
sind eingeladen, sie in den jeweiligen Modulen zu adressieren oder hier
als adressiert zu markieren, wenn sie ergänzt wurden.

## Offene `*`-Lücken (nächste Schicht)

Aktuell keine. Die vier in Welle 8 dokumentierten Lücken (*"Agent ist
schnellerer Programmierer"*, *"Prompts ersetzen Specs"*, *"ADRs sind
Dokumentation, nicht Constraints"*, *"DevOps ist YAML schreiben"*) wurden
in Welle 13 in Modul 9, 2, 3 und 13 als Fehlvorstellungs-Blöcke
aufgeschlagen.

Wenn dir neue Präkonzepte begegnen: trag sie in der passenden Sammlung
oben mit `*` ein und beschreibe sie in einer neuen Tabellen-Zeile hier
(Spalten: Präkonzept, Zielmodul, Warum heute offen, Vorschlag für die
Konfrontation). Wer eine `*`-Lücke adressiert: in dieser Tabelle die
Zeile streichen und im Zielmodul den `*` am entsprechenden Listen-Eintrag
oben entfernen.

## Verweis aus Modulen

Jedes Modul mit einem "Typische Fehlvorstellungen"-Block sollte am Ende
des Blocks auf diese Datei verweisen — als Einladung, eigene
Beobachtungen zurückzuspielen. Das ist eine schwache Form von
Lernervorstellungs-Erfassung in der Kursnutzung, kein Ersatz für
empirische Studien.

## Rückfluss: wie eine beobachtete Lernervorstellung in den Kurs zurückkommt

Kattmanns Rekonstruktions-Loop lebt davon, dass Beobachtungen aus dem
Unterricht in die didaktische Strukturierung zurückfließen. Damit das
hier nicht nur Geste bleibt, ein konkreter Pfad:

1. **Beobachten und notieren.** Sobald du in einem Workshop, einem
   Review oder einem Postmortem einen Satz hörst, der eine
   Vorstellung über KI-Agenten/Harness offenbart, schreibe ihn
   wortwörtlich auf. Wortlaut zählt — paraphrasieren glättet die
   diagnostische Schärfe.
2. **Verorten.** Welches Modul des Kurses adressiert die *Sachfrage*,
   die hinter dem Satz steht? Trage die Beobachtung in der passenden
   Modul-Sektion oben ein (oder eröffne eine neue, wenn keine passt).
3. **Konfrontation entwerfen.** Eine gute Konfrontation hat drei
   Bestandteile: Anti-Argument (warum die Vorstellung nicht trägt),
   Beleg (empirisch oder aus den Fallstudien), konkrete Korrektur
   (was stattdessen gelten sollte). Vorbild: die Konfrontationen zu
   *Halluzination* (Modul 0), *Postmortems* (Modul 16) und *Mehr
   Tests sind immer besser* (Modul 13).
4. **PR oder Issue öffnen.** Ein PR ergänzt die Vorstellung in dieser
   Datei *und* den Fehlvorstellungs-Block des Zielmoduls. Ein Issue
   beschreibt die Beobachtung, wenn die Konfrontation noch unklar
   ist.

### PR-Beispiel-Skelett

```markdown
## Lernervorstellung: "<Wortlaut>"

**Wo beobachtet:** <Workshop / Review / Postmortem — Datum, Rolle des Sprechenden>
**Zielmodul:** <Modul X>
**Heute im Kurs adressiert?:** <ja, halb, nein>

### Vorschlag — Eintrag in `lernervorstellungen.md`

> "<Wortlaut>" — Modul X (Fehlvorstellungs-Block, *neu*)

### Vorschlag — Konfrontation im Modul-Text

- **Anti-Argument:** <warum die Vorstellung nicht trägt>
- **Beleg:** <Fallstudie / Quelle / eigene Beobachtung>
- **Konkrete Korrektur:** <was stattdessen gilt>
```

Ein PR mit diesem Skelett ist klein genug, um in einem Slice
umsetzbar zu sein, und groß genug, um nicht in der Kommentar-Spalte
zu versanden.

## Quellen-Bezug

Modell der Didaktischen Rekonstruktion: Kattmann, Duit, Gropengießer,
Komorek 1997 — vollständiger Eintrag in
[`../abschluss/quellen.md`](../abschluss/quellen.md#didaktische-quellen).
