# Kickoff-Vorlauf — Präkonzept-Sammlung in der Kursnutzung

## Was diese Datei ist

Eine *konkrete Vorlage* für eine fünf- bis siebenminütige Vorlaufrunde
am Anfang eines Kurs-Workshops. Ziel: dokumentieren, mit *welchen
Vorstellungen* die Teilnehmenden in den Kurs einsteigen — als Grundlage
für die spätere Rückkopplung in [`lernervorstellungen.md`](lernervorstellungen.md)
(zweite Säule der Didaktischen Rekonstruktion, Kattmann et al. 1997).

## Was diese Datei *nicht* ist

Kein Test, kein Vortest-Bench­mark, kein "Einstellungsfragebogen".
Lernende geben hier *Vermutungen* zu Protokoll — die Funktion ist
diagnostisch, nicht summativ. Wer die Antworten benotet, verschließt
genau die Stimmen, die hier am wertvollsten sind.

## Drei kalibrierte Vorlauffragen

Drei Fragen, dieselbe Form wie der Modul-0-Vorab-Block (siehe
[`../00-einfuehrung/modul-00-einfuehrung.md`](../00-einfuehrung/modul-00-einfuehrung.md#vorab--was-hältst-du-heute-für-wahr) §"Vorab — was hältst du heute für wahr?").
Jede Frage zielt auf einen *anderen* Quadranten der 2×2-Matrix
([`klassifikation.md`](klassifikation.md)), damit die Sammlung am Ende
breit streut.

### Frage 1 — *Inferential Feedforward*

> *"Wenn ein KI-Agent in deinem Projekt regelmäßig denselben Fehler
> wiederholt — wo schreibst du die Regel hin, die das verhindert? Ein
> Satz."*

Was die Antwort verrät:
- **"In den Prompt"** → Mega-Prompt-Vorstellung (siehe Modul 0
  Fehlvorstellung "Wir bauen einen Mega-Prompt").
- **"In AGENTS.md"** → Harness-Vorstellung schon präsent (selten als
  spontane Antwort vor Modul 9).
- **"Im Code/Linter"** → Fitness-Function-Vorstellung präsent (selten
  vor Modul 13).
- **"Wir trainieren das Modell um"** → Modell-zentrierte Vorstellung
  (siehe Modul 0 Fehlvorstellung "Wir brauchen erst ein besseres Modell").

### Frage 2 — *Inferential Feedback*

> *"Wenn dein Reviewer-Agent denselben Diff zweimal mit
> unterschiedlicher Strenge bewertet — was ist die wahrscheinlichste
> Ursache? Ein Satz."*

Was die Antwort verrät:
- **"Das Modell ist nicht-deterministisch"** → Modell-zentrierte
  Vorstellung; Sensoren-/Kontext-Frage wird übersprungen.
- **"Der Kontext war anders"** → Harness-Vorstellung schon präsent.
- **"Reviewer ist halt subjektiv"** → Vorstellung, dass Reviewer-
  Schwankung *akzeptabel* ist (vgl. Modul 10 Fehlvorstellung "Wenn der
  Reviewer-Agent dasselbe zweimal anders kategorisiert, nehmen wir die
  mildere").

### Frage 3 — *Computational Feedback / Feedforward*

> *"Du wechselst dein LLM-Modell. Acht von zehn Replay-Fällen sind
> grün. Gehst du live? Begründung in einem Satz."*

Was die Antwort verrät:
- **"Ja, 80 % reichen"** → Replay-Set wird als Bench­mark, nicht als
  Symptom-Sensor verstanden (vgl. Modul 12 Fehlvorstellung "Wenn der
  Replay grün ist, ist das Modell gut").
- **"Nein, die zwei roten müssen ich verstehen"** → Drift-Diagnose-
  Reihenfolge bereits angedacht (selten vor Modul 12).
- **"Ich rotiere zuerst das Golden Set"** → Entropy-Management-
  Vorstellung präsent (sehr selten als spontane Antwort).

## Sammelplatz: ein YAML-Block pro Workshop

Trage die Antworten — gerne wortwörtlich, aber anonymisiert — in
folgendem Format ein. *Wortlaut zählt*: paraphrasieren glättet die
diagnostische Schärfe (vgl. [`lernervorstellungen.md`](lernervorstellungen.md#rückfluss-wie-eine-beobachtete-lernervorstellung-in-den-kurs-zurückkommt) §"Rückfluss").

```yaml
# kickoff/<JJJJ-MM-TT>-<organisation>.yaml
workshop:
  datum: 2026-06-30
  organisation: <Team / Org>
  teilnehmende_anzahl: 7
  rollen_verteilung: { dev: 4, devops: 2, architect: 1 }

vorlauf:
  frage_1_regel_wohin:
    - wortlaut: "In den Prompt, am Anfang vom Lauf"
      vermutete_klasse: mega-prompt
      ziel_modul: 0
    - wortlaut: "AGENTS.md, aber wir haben keine"
      vermutete_klasse: harness-bewusst-ohne-praxis
      ziel_modul: 9

  frage_2_reviewer_drift:
    - wortlaut: "Halluziniert halt manchmal"
      vermutete_klasse: modell-zentriert
      ziel_modul: 10
    - wortlaut: "Anderer Kontext, ich gebe dem mal mehr Beispiele"
      vermutete_klasse: harness-bewusst-ohne-rolle
      ziel_modul: 10

  frage_3_replay_8_von_10:
    - wortlaut: "80 % ist gut, in der Praxis reicht das"
      vermutete_klasse: benchmark-vorstellung
      ziel_modul: 12

ruckfluss:
  rohnotizen: kickoff/2026-06-30-rohnotizen.md
  pr_zu_lernervorstellungen: "<Link, falls eingereicht>"
```

Das Schema ist bewusst flach. Es lebt davon, dass die *Wortlaute* erhalten
bleiben — die Klassifikation ist Hilfsrad, kein Selbstzweck.

## Wie diese Sammlung in den Kurs zurückkommt

Genau auf demselben Pfad, den
[`lernervorstellungen.md`](lernervorstellungen.md#rückfluss-wie-eine-beobachtete-lernervorstellung-in-den-kurs-zurückkommt)
§"Rückfluss" beschreibt — vier Schritte: beobachten, verorten,
Konfrontation entwerfen, PR oder Issue öffnen. Das hier ergänzt nur den
*Eingabe-Mechanismus*: die Vorlauffragen geben drei kalibrierte
Anlässe, an denen Lernervorstellungen *systematisch* sichtbar werden,
statt zufällig in einem Review aufzutauchen.

## Wann diese Vorlage *nicht* nutzen?

- **Solo-Selbststudium.** Wer den Kurs alleine durcharbeitet, braucht
  keinen YAML-Block — die Vorab-Frage in Modul 0 (drei Sätze) reicht
  als Selbstkonfrontation. Diese Datei richtet sich an *kollektive*
  Kursnutzung.
- **Performance-Reviews.** Die Antworten dürfen weder anonymisiert noch
  nicht-anonymisiert in eine Personalbewertung fließen. Sonst wirst du
  weder Mega-Prompt-Vorstellungen noch "Reviewer ist subjektiv"-
  Antworten hören — und genau die brauchst du.

## Quellen-Bezug

* Modell der Didaktischen Rekonstruktion: Kattmann, Duit, Gropengießer,
  Komorek 1997 — vollständiger Eintrag in
  [`../abschluss/quellen.md`](../abschluss/quellen.md#didaktische-quellen).
* Conceptual Change und Vorlauf-Befragung: Posner et al. 1982 — die
  drei Fragen oben zielen auf Bedingung 1 (Unzufriedenheit), nicht auf
  Wissensabfrage.
