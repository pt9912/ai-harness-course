# Modul 0 — Einführung

> **Aufwand:** ca. 45 Min Lesen · 60 Min Übung. Optional vorgeschaltet: [Hello-Harness](hello-harness.md) (30 Min Hands-on).

## Optionale Explorations-Vorab-Übung (Kapur-Stil)

Wenn du Zeit für eine *echte* Productive-Failure-Variante hast: **vor**
dem Lesen dieses Moduls 20 Minuten ohne Anleitung experimentieren.

> **Aufgabe (optional, 20 Min):** Lass einen LLM-Agenten deiner Wahl
> denselben kleinen Auftrag *zweimal hintereinander* ausführen — z. B.
> *"Schreibe eine Python-Funktion, die die Quersumme einer ganzen Zahl
> berechnet, mit drei Beispielen am Ende."* Speichere beide Ausgaben.
> Versuche dann, in 5 Minuten **schriftlich** zu erklären, warum die
> Antworten verschieden sind (oder gleich) — *bevor* du das Modul liest.
>
> Erfolg ist *nicht*, dass du eine richtige Erklärung findest. Erfolg
> ist, dass du die Reibung spürst und deine Hypothesen aufschreibst.

Nach dem Modul-Lesen: vergleiche deine Hypothesen mit den Begriffen
*stateless*, *Harness*, *Reproduzierbarkeit*. Verwende
[`../grundlagen/reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md)
inklusive Frage 4.

Wenn du keine Zeit hast: überspringen ist okay. Der Kurs trägt mit oder
ohne diesen Einstieg. Echter Kapur-PF braucht aber das Scheitern *vor*
der Lehre — wer das nicht versucht, lernt das Konzept später, nicht
schlechter.

## Engage

Du hast einen Agenten gebaut, der gestern ein Ticket sauber erledigt hat.
Heute gibt er für *dasselbe* Ticket eine andere Antwort. Hast du einen
Bug — oder einen Harness-Mangel? Genau diese Frage trennt Chatbots von
Engineering-Systemen, und sie ist der Grund, warum dieser Kurs existiert.

## Mini-Glossar für diesen Einstieg

Das vollständige Glossar steht in
[`../grundlagen/konventionen.md`](../grundlagen/konventionen.md#kernbegriffe).
Für die ersten Seiten reichen die folgenden acht Begriffe — jeweils ein
Satz, ein Bild im Kopf:

| Begriff | Ein-Satz-Definition | Bild im Kopf |
|---|---|---|
| **LLM** | Modell, das Text-Eingabe in Text-Ausgabe abbildet — *stateless*. | eine Funktion: rein Text, raus Text. |
| **Tool-Call** | Strukturierter Aufruf einer Funktion durch das LLM (`name`, `arguments`, `result`). | das LLM zeigt mit dem Finger und sagt: *"führe das aus"*. |
| **Agent** | LLM + Tools + Schleife. Hält Zustand über mehrere Turns. | LLM, das nicht nur antwortet, sondern *handelt*. |
| **Harness** | Alles am Agenten *außer* dem Modell — Spec, ADRs, Tools, Gates, Telemetrie. | das Geschirr um das Modell, das es lenkt. |
| **Chatbot** | Agent oder LLM mit Fokus auf *Antwort*. | Gespräch. |
| **Engineering-System** | Agent + Harness mit Fokus auf *reproduzierbares, auditierbares Handeln*. | Lieferprozess. |
| **Halluzination** | Plausibles, aber falsches Ausgabe-Stück — meist Folge fehlender Information *im Kontext*. | der Agent *rät*, weil ihm niemand widerspricht. |
| **Reproduzierbarkeit / Auditierbarkeit** | Reproduzierbar: zweimal dasselbe → zweimal dasselbe. Auditierbar: jede Entscheidung lässt sich zurückverfolgen. | "Was ist passiert?" hat eine eindeutige Antwort. |

Lies das einmal langsam durch. Die acht Begriffe sind das gesamte
Vokabular, das du brauchst, um den Rest des Moduls *ohne weitere
Nachschlag-Schleifen* zu lesen.

## Lernziele

Nach diesem Modul kannst du:

* Agent, LLM und Tool-Call in eigenen Worten *erklären* und gegeneinander *abgrenzen* (Verstehen · faktisch+konzeptuell),
* Chatbot von Engineering-System anhand mindestens dreier Kriterien *unterscheiden* (Analysieren · konzeptuell),
* drei typische Scheitermuster von KI-Projekten *identifizieren* und mindestens eines davon einem Quadranten der 2×2-Matrix *zuordnen* (Analysieren · konzeptuell),
* den Begriff *Harness* — im Rahmen von Böckeler eingeführt (siehe [`klassifikation.md`](../grundlagen/klassifikation.md)) — gegen "Prompt Engineering" *abgrenzen* (Analysieren · konzeptuell),
* einen Mega-Prompt anhand der drei Reproduzierbarkeits-Kriterien des Moduls (jeder-Lauf-relevant, auditierbar, deterministisch) zeilenweise *kritisieren* (Bewerten · prozedural).

## Lab-Bezug

* [`../../../lab/example/evals/example-trace.json`](../../../lab/example/evals/example-trace.json) — kommentierter Minimal-Trace
* [`../../../lab/example/docs/glossar.md`](../../../lab/example/docs/glossar.md) — kleines Kurs-Glossar am DocSearch-Beispiel

## Themen

* Was sind KI-Agenten?
* Warum viele KI-Projekte scheitern
* Grenzen von Prompt Engineering
* Der Unterschied zwischen Chatbot und Engineering-System
* LLM vs. Agent vs. Workflow

## Vorab — was hältst du heute für wahr?

*Bevor du die Kernidee liest:* notiere in einem Satz deine spontane
Antwort auf jede dieser drei Fragen — auch wenn du dir unsicher bist.

1. *"Was ist der schnellste Weg, ein KI-Projekt erfolgreich zu machen — besseres Modell, besserer Prompt oder etwas Drittes?"*
2. *"Eine Halluzination ist im Kern ein Modell-Problem — wahr oder falsch?"*
3. *"Wenn ein Agent in jedem Lauf etwas Bestimmtes tun soll, wohin schreibst du diese Regel?"*

Lass deine Notiz neben dem Modul liegen. Am Modul-Ende konfrontiert dich
der Abschnitt *Typische Fehlvorstellungen* mit den drei häufigsten
Antwort-Mustern — wir prüfen, welches deine war.

## Kernidee

Ein Chatbot antwortet. Ein Agent handelt. Engineering-Systeme handeln
**reproduzierbar** und **auditierbar** — das ist nicht dasselbe wie
"antwortet besser". Der Harness ist genau das System, das aus einem
handelnden Agenten einen reproduzierbar handelnden Agenten macht.

> *Rückbezug zur Kapur-Vorab-Übung* (falls du sie gemacht hast): Genau hier löst sich die Reibung deiner zwei verschiedenen Quersummen-Outputs auf. Die Antworten sind verschieden, weil der LLM *stateless* ist; reproduzierbar werden sie erst durch Harness-Elemente (Tool-Allowlist, Spec-Anker, fester Seed im Replay). Welche deiner Vorab-Hypothesen kommt diesem Befund am nächsten, welche nicht? Trag den Vergleich in die Reflexion (Frage 4) ein — *jetzt*, bevor du weiterliest.

## Typische Fehlvorstellungen

- **"Wir brauchen erst ein besseres Modell."** — In den dokumentierten Scheiterfällen war meist nicht das Modell die Ursache, sondern eine Spec-Lücke oder ein fehlender Sensor. Das Modell rät, *weil nichts in der Eingabe widerspricht*. Lopopolo (OpenAI 2026) und die Fallstudien in [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md) belegen das.
- **"Wir bauen einen Mega-Prompt."** — Der Prompt wird zur Anti-Spec, die niemand pflegt. Was in *jedem* Lauf relevant ist, gehört in AGENTS.md oder eine Fitness Function, nicht in den Prompt.
- **"Der Agent muss nur freier entscheiden dürfen."** — Genau das macht Auditierbarkeit unmöglich. Engineering-Systeme sind *reproduzierbar*, nicht kreativ.
- **"Halluzination ist ein Bug des Modells."** — Falsche Attribution. Eine Halluzination ist ein *Output-Symptom*, dessen *Ursache fast immer im Kontext liegt*: fehlende Spec-Aussage, fehlende ADR, fehlende AGENTS.md-Regel, fehlende Tool-Allowlist. Die richtige Frage ist nicht "warum hat das Modell das erfunden", sondern "was *im Kontext* hätte das Erfinden verhindert" — und genau das ist eine Harness-Frage. Wer Halluzinationen als Modell-Bug klassifiziert, kann sie nur durch Modellwechsel adressieren; wer sie als Kontext-Bug klassifiziert, kann sie durch Spec/ADR/Sensor reduzieren. Empirie: dieselbe Klasse von Halluzinationen kommt nach Modellwechsel oft *wieder* — weil das Kontext-Loch nicht zugefüllt wurde.

Weitere Präkonzepte, die diesem Kurs zugrunde liegen: [`../grundlagen/lernervorstellungen.md`](../grundlagen/lernervorstellungen.md). Ergänze deine eigenen.

## Übungen

* Analyse eines fehlgeschlagenen KI-Projekts (Vorlage:
  [`../../../lab/example/exercises/00-postmortem.md`](../../../lab/example/exercises/00-postmortem.md))
* Provoziere absichtlich eine Halluzination, dokumentiere den Trigger
* **Mega-Prompt sortieren** — aktiviert das Bewertungs-Lernziel
  *"Harness gegen Prompt Engineering abgrenzen"*: Nimm einen Mega-Prompt
  aus einem Vorprojekt (oder erfinde einen ≥30-zeiligen) und sortiere
  *jede* Zeile in eine der drei Spalten:
  * **(a) gehört in AGENTS.md** — in *jedem* Lauf relevant, projektweite
    Konvention, kein Einzelfall (Beispiele: Codestil, Tool-Regeln,
    Verbote).
  * **(b) gehört in eine Fitness Function** — deterministisch prüfbar,
    sollte technisch erzwungen werden (Beispiele: Layer-Importregeln,
    Verbot bestimmter Funktionen).
  * **(c) gehört in *diesen* konkreten Prompt** — situativ, nur für
    diese Aufgabe relevant (Beispiele: konkrete Eingabe, konkretes
    Zielartefakt).

  Begründe pro (c)-Zeile in einem Halbsatz, *warum* sie weder (a) noch
  (b) ist. Faustregel: Wenn ein Satz in jedem zweiten Lauf vorkommen
  würde, gehört er nicht in (c). Wer (c) länger als (a) hat, baut sich
  eine Anti-Spec.

## Reflexion

Nach jeder Übung dieses Moduls (besonders nach der Halluzinations-Provokation und der Mega-Prompt-Sortier-Übung) kurz **schriftlich**:

1. **Was ist beobachtbar passiert?** — welche Tool-Calls, welche Ausgabe, welcher Trigger, reproduzierbar beschrieben.
2. **Welcher 2×2-Quadrant war Ursache?** — Computational/Inferential × Feedforward/Feedback (siehe [`konzeptkarte.md §2x2-Schnellanker`](../grundlagen/konzeptkarte.md#2x2-schnellanker)).
3. **Welche konkrete Steering-Loop-Aktion folgt?** — eine konkrete Harness-Änderung, keine vage Absicht.
4. **Welche eigene Vorstellung wurde unzufriedenstellend?** — Conceptual Change; Kandidaten in [`lernervorstellungen.md`](../grundlagen/lernervorstellungen.md).

Eintragsformat, "Wann *nicht* reagieren" und Anti-Antworten: [`reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md).

## Selbstcheck

* **(Erinnern + Verstehen — aktiviert LZ 1)** Welche drei Bestandteile hat ein Tool-Call laut Mini-Glossar? Grenze dann *Agent*, *LLM* und *Tool-Call* gegeneinander ab: Was kann das LLM allein *nicht*, wofür es den Agenten und den Tool-Call braucht?
* **(Analysieren — aktiviert LZ 3)** Nimm eines der drei Scheitermuster aus deiner Postmortem-Übung und ordne es genau einem Quadranten der 2×2-Matrix zu (Computational/Inferential × Feedforward/Feedback). Begründe, *welche* Kontrolle gefehlt hat — nicht "das Modell war schlecht".
* **(Analysieren — aktiviert LZ 2)** Unterscheide einen Chatbot von einem Engineering-System anhand von *drei* Kriterien (z. B. Reproduzierbarkeit, Auditierbarkeit, Fehler-Rückkopplung). Nimm dann ein Grenzbeispiel — ein Agent mit einem festen System-Prompt, aber ohne Gates — und ordne es begründet einer der beiden Seiten zu.
* Wo verläuft die Grenze zwischen "guter Prompt" und "guter Harness"?
* Welche Fehlermodi eines Agenten kann ein Linter *nicht* fangen?
* **(Bewerten — aktiviert LZ 5)** Nimm den Mega-Prompt aus der Sortier-Übung. Nenne die zwei Reproduzierbarkeits-Kriterien, mit denen du *entscheidest*, ob eine Zeile in AGENTS.md, in eine Fitness Function oder in den Prompt gehört, und zeige eine Zeile, deren Zuordnung *zwischen* zwei Töpfen strittig bleibt — mit Begründung, welches Kriterium hier den Ausschlag gibt.

### Selbstcheck-Rubrik

Schema in [`../grundlagen/selbstcheck-rubrik.md`](../grundlagen/selbstcheck-rubrik.md). Drei Stufen pro Frage:

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Drei Bestandteile eines Tool-Calls + Abgrenzung Agent/LLM/Tool-Call? | "Name und Argumente." | `name`, `arguments`, `result`. Abgrenzung: das LLM erzeugt nur Text; der *Tool-Call* ist die strukturierte Handlung, die der *Agent* (die Schleife um das LLM) ausführt und deren `result` er zurück in den Kontext gibt. | + Anwendung: ohne `result`-Feld kann der Verifier den Lauf nicht reproduzieren; ohne `arguments` ist Token-Attribution unmöglich. Das LLM allein kann nicht handeln (keine Datei lesen, kein Gate aufrufen) — erst die Agent-Schleife macht aus Text eine auditierbare Handlung. |
| Scheitermuster einem 2×2-Quadranten zugeordnet? | Muster genannt, aber kein Quadrant — oder "Modell war schlecht". | Genau ein Quadrant benannt (z. B. Spec-Lücke → *inferential feedforward*) mit Begründung, *welche* Kontrolle gefehlt hat. | + Gegenprobe: das Muster gegen einen *zweiten* Quadranten gehalten und begründet, warum es dort *nicht* primär liegt — und welche Kontrolle (Guide vs. Sensor) am billigsten gegriffen hätte. |
| Chatbot ↔ Engineering-System an drei Kriterien? | ein Unterschied genannt ("eines ist ein Programm"). | Drei trennscharfe Kriterien — z. B. Reproduzierbarkeit (gleicher Input → prüfbar gleicher Prozess), Auditierbarkeit (jede Änderung über eine ID rückverfolgbar), Fehler-Rückkopplung (Versagen wird zu Guide/Sensor). | + Grenzbeispiel zugeordnet: ein Agent mit festem System-Prompt, aber ohne Gates, ist *noch* ein Chatbot — die Trennlinie ist nicht der Prompt, sondern der reproduzierbare, auditierbare Prozess drumherum. |
| Grenze "guter Prompt" ↔ "guter Harness"? | "Harness ist umfangreicher." | Prompt verbessert *eine* Interaktion; Harness verbessert *jede zukünftige Interaktion derselben Klasse*. | + Test "wäre die Anweisung in *jedem* Lauf relevant?" und Verweis auf AGENTS.md/Fitness Function als Ablage. |
| Fehlermodi, die ein Linter *nicht* fängt? | "Semantik." | Drei Klassen: semantische Halluzination, ADR-Verstoß, Spec-Lücken-Symptom. | + zwei weitere (implizite Annahmen, Sicherheits-Anti-Pattern im Fremdkontext) und Zuordnung zu Sensor-Typen (Compiler/ArchUnit/Verifier/Replay/Security-Gate). |
| Mega-Prompt-Zuordnung mit Begründung des Grenzfalls? | "Ich sortiere in drei Töpfe." (= Analyse, kein Bewerten.) | Zwei Kriterien benannt (z. B. *jeder-Lauf-relevant?* und *deterministisch prüfbar?*); ein konkreter Grenzfall mit Begründung, welches Kriterium ausschlaggebend ist. | + ein zweiter Grenzfall, in dem die Kriterien *gegeneinander* entscheiden, plus die Faustregel, welches Kriterium dann Vorrang hat und warum (Verweis auf Sweller-Redundanz oder Lopopolo-Constrain). |

## Weiterlesen

* Konzeptueller Rahmen: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)
* Nächstes Modul: [Modul 1 — Der Entwicklungszyklus](../01-spec-und-architektur/modul-01-entwicklungszyklus.md)
