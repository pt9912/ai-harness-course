# Modul 10 — Verification Harness

> **Aufwand:** ca. 60 Min Lesen · 75 Min Übung.

## Engage

Tests grün, Review grün, Slice geht in `done/`. Drei Wochen später meldet
die Behaviour-Suite einen Regress. Forensik zeigt: der Slice hatte einen
DoD-Punkt nicht erfüllt — Reviewer hatte ihn nicht im Blick. Wer hätte
es fangen müssen? *Verifikation* — die Rolle, die fragt: "Wurde das
umgesetzt, was geplant war?" Nicht: "Ist es gut?"

## Lernziele

Nach diesem Modul kannst du:

* einen Plan-gegen-Code-Diff automatisch *prüfen* und das Ergebnis gegen Plan/DoD *interpretieren* (Bewerten),
* eine DoD-Verletzung *erkennen* und gegen ein Review-Finding *abgrenzen* (Analysieren),
* ADR-Konformität als Fitness Function *entwerfen* (auch dort, wo kein vorhandenes Werkzeug die ADR-Aussage 1:1 abbildet) (Erschaffen),
* die Pre-completion Checklist eines Implementation-Agenten *bewerten* und Lücken *identifizieren* (Bewerten).

## Lab-Bezug

* [`../../../lab/example/Makefile`](../../../lab/example/Makefile), Target `make verify SLICE=slice-009`
* [`../../../lab/example/verification/checks/`](../../../lab/example/verification/checks/)

## Themen

* Plan-gegen-Code-Prüfung
* DoD-Verifikation
* ADR-Konformität
* Architekturkonformität
* Pre-completion Checklist Middleware (vom Agenten selbst durchlaufen, bevor er "fertig" meldet — siehe [Modul 8 Schritt 8](../03-agenten/modul-08-implementierung.md#minimal-agent-workflow-8-schritte))

## Harness-Einordnung

Verifikation = primär *inferential feedback* in der Behaviour-Kategorie,
unterstützt durch *computational feedback* (Fitness Functions für die
Architecture-Fitness-Kategorie). Dies ist die anspruchsvollste Schicht
— und laut Böckeler die am wenigsten ausgereifte. Siehe
[`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md).

## Kernidee

Verifikation ist die Stelle, an der der Harness *gegen sich selbst*
misst: "Hat das, was gebaut wurde, das umgesetzt, was geplant war?" —
nicht: "Ist es gut?"

## Typische Fehlvorstellungen

- **"Grüne Tests sind Verifikation."** — Tests prüfen ob *Code tut, was Tests testen*. Verifikation prüft, ob *Code tut, was Plan/DoD/Spec verlangt*. Lücken zwischen Tests und Spec sind genau das, was Verifikation findet.
- **"Verifier braucht denselben Kontext wie Reviewer."** — Nein. Reviewer hat *Plan + ADR*. Verifier hat *DoD + Spec + Plan*. Andere Eingabe, andere Findings.
- **"Wenn Verifier rot und Reviewer grün, hat Reviewer recht."** — Falsch. Die wahrscheinlichere Erklärung: Reviewer hat gegen einen veralteten Plan geprüft, oder der Plan hat eine DoD-Lücke. Architect klärt — *nicht* "wir nehmen das mildere Ergebnis".

## Übungen

* Automatische Verifikation eines Slices
* Provoziere eine DoD-Verletzung und prüfe, ob sie erkannt wird

### Minimaler Übungspfad

```bash
cd lab/example
make verify SLICE=slice-009
```

Erwartete Beobachtung: Der Check ist bewusst klein. Er prüft, ob der
Slice DoD, Traceability-ID und Gate-Beleg enthält. Danach provozierst du
den Fehlerfall: entferne in einer Kopie des Slice den `make gates`-Beleg
und beobachte, dass die Verifikation rot wird.

## Reflexion

Nach dem Verifikations-Lauf und dem provozierten DoD-Verstoß kurz **schriftlich**:

1. **Was ist beobachtbar passiert?** — Welches Verifier-Findings hat den Verstoß erkannt? Hat dein Reviewer denselben Verstoß übersehen — und warum (welche Eingabe fehlte ihm)?
2. **Welcher 2×2-Quadrant war Ursache?** — siehe [`konzeptkarte.md §2x2-Schnellanker`](../grundlagen/konzeptkarte.md#2x2-schnellanker). Verifikation kombiniert *inferential feedback* und *computational feedback* (Fitness Functions).
3. **Welche konkrete Steering-Loop-Aktion folgt?** — Verifier-Eingabe-Pflicht (DoD+Spec+Plan) schärfen? Plan-Verteilung an Reviewer im 8-Schritt-Workflow nachziehen?
4. **Welche eigene Vorstellung wurde unzufriedenstellend?** — Conceptual Change; Kandidaten in [`lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "Grüne Tests sind Verifikation", "Verifier braucht denselben Kontext wie Reviewer").

Eintragsformat, "Wann *nicht* reagieren" und Anti-Antworten: [`reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md).

## Selbstcheck

* **(Erinnern)** Welche drei Eingabe-Artefakte braucht ein Verifier minimal — und wodurch unterscheiden sie sich von den Eingaben des Reviewers?
* Warum reicht ein grünes Testsuite-Ergebnis nicht als Verifikation?
* Wer löst den Konflikt, wenn Verification rot, Review grün ist?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Drei Verifier-Eingaben + Abgrenzung zu Reviewer? | "Code und Plan." | Verifier: DoD + Spec + Plan. Reviewer: Plan + ADR + Diff. Schnittmenge ist nur der Plan — die Trennung erzeugt die unterschiedlichen Findings. | + Hinweis: Wer dem Verifier *zusätzlich* den ADR gibt, macht ihn zum zweiten Reviewer und verliert die Kontext-Trennung. Verifier prüft "Plan↔Code↔DoD↔Spec", Reviewer prüft "Plan↔Diff↔ADR". |
| Warum reichen grüne Tests nicht? | "Tests sind unvollständig." | Tests prüfen, ob Code tut, was *Tests testen*. Verifikation prüft, ob Code tut, was *Plan/DoD/Spec verlangt*. Tests können Spec-Lücken nicht selbst erkennen. | + Hinweis auf Behaviour-Kategorie (Modul 11): Tests gegen Beispiele decken Realität *nur* da ab, wo das Golden Set repräsentativ ist; Verifikation gegen Spec wird daher *nicht* von Tests ersetzt. |
| Verification rot, Review grün — wer entscheidet? | "Der Architekt." | Architect-Rolle prüft: hat Reviewer gegen veralteten Plan geprüft, oder ist der Plan unvollständig? Konflikt löst sich entweder als Folge-ADR oder als Plan-Update — *nicht* als "wir nehmen das mildere Ergebnis". | + Folge: Wenn dieses Pattern dreimal auftritt, liegt eine Lücke in der Plan→Review-Kette (Reviewer bekommt nicht den aktuellen Plan als Eingabe). Steering-Loop-Aktion: Plan-Verteilung an Reviewer als Schritt im 8-Schritt-Workflow. |

## Weiterlesen

* Nächstes Modul: [Modul 11 — Replay und Evaluierung](modul-11-replay-evaluierung.md)
