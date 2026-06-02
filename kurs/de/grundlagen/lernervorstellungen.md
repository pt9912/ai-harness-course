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
deckt oft Präkonzepte auf, die diese Liste nicht enthält.

## Sammlung

Sortiert nach Modulen, in denen sie primär adressiert werden. Sterne
markieren Präkonzepte, die der Kurs heute *nicht* explizit als
Fehlvorstellungs-Block aufgreift — Kandidaten für die nächste
Iteration.

### Über KI-Agenten und LLMs (Modul 0–1)

- "Wir brauchen erst ein besseres Modell." — Modul 0
- "Wir bauen einen Mega-Prompt." — Modul 0
- "Der Agent muss nur freier entscheiden dürfen." — Modul 0
- "Ein Agent ist ein besserer/schnellerer Programmierer." \* — *nicht
  explizit benannt*; klingt im Engage von Modul 8 an (800 Zeilen in 4
  Minuten), wird aber nicht als Präkonzept aufgeschlagen.
- "Halluzinationen sind ein Bug des Modells." — Modul 0
  (Fehlvorstellungs-Block; seit Welle 7 explizit benannt mit Verweis auf
  Kontext-Ursachen und Wiederholungs-Empirie nach Modellwechsel).
- "Agenten lernen mit der Zeit, wenn man sie länger benutzt." — Modul 2
  (Kernidee-Block "Grenze der Metapher"; seit Welle 7 explizit gegen
  Praktikant-Metapher abgegrenzt).

### Über Spec und Anforderungen (Modul 2)

- "Akzeptanzkriterien sind der Happy Path." — Modul 2
- "Negativbedingungen sind unhöflich." — Modul 2
- "Out-of-Scope kann implizit bleiben." — Modul 2
- "Performance gehört in den ADR." — Modul 2
- "Prompts ersetzen Specs." \* — die agile/Lean-Tradition mancher Teams
  ("Code statt Doku") wird nicht als Antagonist adressiert; die
  Engage-Geschichte in Modul 2 (Spec sagt "speichert", Agent baut
  PostgreSQL) ist eine implizite Antwort darauf.

### Über Architektur und ADRs (Modul 3)

- "Eine ADR begründet eine Anforderung." — Modul 3
- "Wenn ich die Entscheidung ändere, schreibe ich die ADR um." — Modul 3
- "Eine ADR ohne Fitness Function ist eine ADR." — Modul 3
- "MADR ist Pflicht." — Modul 3
- "ADRs sind Dokumentation, nicht Constraints." \* — die Vorstellung
  einer *passiven* Dokumentation wird in Modul 3 widerlegt, aber nicht
  explizit als Präkonzept beschriftet.
- "Architektur ist Bilder zeichnen." — Modul 3
  (Fehlvorstellungs-Block; seit Welle 7 explizit benannt mit Bezug auf
  Spec-Stratifizierung).

### Über Planung (Modul 4–6)

- "Plan ist nur eine Liste von Tickets." — Modul 1
- "Slice = Ticket = Feature." — Modul 4
- "Erst plan ich alle Slices, dann fange ich an." — Modul 4
- "Wenn ein Slice in `done/` ist, ist er fertig." — Modul 4
- "Roadmap ist eine Datumsleiste." — Modul 5
- "Burndown ist Fortschritt." — Modul 5
- "Welle = Sprint." — Modul 5
- "Trigger = Datum." — Modul 5
- "Carveout = Workaround." — Modul 6
- "Carveouts gehören ins Issue-Tracker." — Modul 6
- "Wenn der Trigger eintritt, lösen wir den Carveout auf." — Modul 6

### Über Agentenrollen und Implementation (Modul 7–8)

- "Eine Person spielt alle Rollen." — Modul 7
- "Reviewer macht das Verification gleich mit." — Modul 7
- "Validation machen wir vor Release." — Modul 7
- "Architect entscheidet, Implementation widerspricht nicht." — Modul 7
- "Agent liefert schnell, also ist der Workflow Overhead." — Modul 8
- "Hard Rules schreibe ich in AGENTS.md, und das reicht." — Modul 8
- "Wenn die Tests grün sind, ist der Slice fertig." — Modul 8
- "Die Pre-completion Checklist ist Bürokratie." — Modul 8

### Über Qualität und Gates (Modul 9–12)

- "Reviewer ist ein zweiter Implementer." — Modul 9
- "Findings ohne Prioritätssortierung." — Modul 9
- "Reviewer-Agent läuft ohne Skill-Datei." — Modul 9
- "Wenn der Reviewer-Agent dasselbe zweimal anders kategorisiert, nehmen
  wir die mildere." — Modul 9
- "Grüne Tests sind Verifikation." — Modul 10
- "Verifier braucht denselben Kontext wie Reviewer." — Modul 10
- "Wenn Verifier rot und Reviewer grün, hat Reviewer recht." — Modul 10
- "Wenn der Replay grün ist, ist das Modell gut." — Modul 11
- "Golden Set ist statisch." — Modul 11
- "Determinismus = Reproduzierbarkeit." — Modul 11
- "Gate = Lint." — Modul 12
- "Wenn ein Gate manchmal rot sein darf, ist das pragmatisch." — Modul 12
- "Coverage 80 % ist die richtige Schwelle." — Modul 12
- "`make gates` lokal grün heißt fertig." — Modul 12
- "Mehr Tests sind immer besser." — Modul 12 (Fehlvorstellungs-Block;
  seit Welle 7 explizit benannt mit Faustregel *Verteilung vor Anzahl*).

### Über Betrieb (Modul 13–15)

- "FROM python:3 ist konkret genug." — Modul 13
- "Lock-Files sind nur für Python." — Modul 13
- "Docker-only ist Overkill für Tools." — Modul 13
- "Devcontainer ersetzt Compose." — Modul 13
- "Logs reichen." — Modul 14
- "Metriken sind nur für Performance." — Modul 14
- "Prompt-Caching ist Modell-Sache." — Modul 14
- "Trace teurer Tool-Call = unnötiger Tool-Call." — Modul 14
- "Rollback ist die Standardantwort." — Modul 15
- "Runbook beschreibt den Happy Path." — Modul 15
- "Produktionsfreigabe ist eine formale Checkbox." — Modul 15
- "Prompt-Injection ist eine Modell-Frage." — Modul 15
- "DevOps ist YAML schreiben." \* — Vorstellung "Container = Deployment"
  (statt "Container = Reproduzierbarkeitsanker") wird in Modul 13 nicht
  explizit aufgegriffen.
- "Postmortems sind Schuldzuweisung." — Modul 15 (Fehlvorstellungs-Block;
  seit Welle 7 explizit benannt mit Sensor-Schutz-Argument für blameless).

## Wie diese Liste verwendet wird

In den Modulen erscheint **eine Auswahl** dieser Vorstellungen als
"Typische Fehlvorstellungen"-Block — mit Konfrontation und Begründung.
Die mit `*` markierten Einträge sind dokumentierte Lücken; Mitwirkende
sind eingeladen, sie in den jeweiligen Modulen zu adressieren oder hier
als adressiert zu markieren, wenn sie ergänzt wurden.

## Offene `*`-Lücken (nächste Schicht)

Diese vier Präkonzepte sind heute nicht als Fehlvorstellungs-Block in
ihrem Zielmodul aufgeschlagen. Sie sind die priorisierten Kandidaten
für die nächste Welle.

| Präkonzept | Zielmodul | Warum heute offen | Vorschlag für die Konfrontation |
|---|---|---|---|
| "Ein Agent ist ein besserer/schnellerer Programmierer." | [Modul 8](../03-agenten/modul-08-implementierung.md) | klingt im Engage an (800 Zeilen in 4 Minuten), aber wird nicht als Präkonzept aufgeschlagen | Geschwindigkeits-Argument: 20 % länger Plan + 50 % weniger Review = Netto-Gewinn. Hinweis: Geschwindigkeit ohne Plan produziert *Review-Last*, nicht *Lieferung*. |
| "Prompts ersetzen Specs." | [Modul 2](../01-spec-und-architektur/modul-02-lastenheft.md) | wird implizit durch Engage-Geschichte beantwortet, aber nicht als Präkonzept benannt | Lebenszyklus-Argument: Spec wird *gepflegt*, Prompt nicht. Was im Prompt steht und nicht in der Spec, gilt nur für den nächsten Lauf. Verweis auf Lopopolo: was nicht im Kontext ist, existiert nicht — aber das ist Plädoyer für Spec, nicht für Mega-Prompt. |
| "ADRs sind Dokumentation, nicht Constraints." | [Modul 3](../01-spec-und-architektur/modul-03-architektur-adrs.md) | wird implizit widerlegt, aber nicht explizit als Präkonzept beschriftet | Fitness-Function-Argument: Eine ADR ohne maschinelle Durchsetzung ist eine Absichtserklärung. Verweis auf Worked Example Modul 12 (ADR-0007 → import-linter). |
| "DevOps ist YAML schreiben." (Container = Deployment) | [Modul 13](../05-betrieb/modul-13-docker-harness.md) | Vorstellung "Container = Deployment" wird in Modul 13 nicht explizit aufgegriffen | Reproduzierbarkeits-Argument: Container ist *primär* ein Reproduzierbarkeits-Anker (Image-Hash, identische Toolchain) und *sekundär* eine Deployment-Form. Wer Container nur als Deployment denkt, verzichtet auf den Hauptzweck im Kurs. |

Wer einen `*`-Eintrag adressiert: in dieser Tabelle die Zeile streichen
und im Zielmodul den `*` am entsprechenden Listen-Eintrag oben
entfernen.

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
   *Halluzination* (Modul 0), *Postmortems* (Modul 15) und *Mehr
   Tests sind immer besser* (Modul 12).
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
