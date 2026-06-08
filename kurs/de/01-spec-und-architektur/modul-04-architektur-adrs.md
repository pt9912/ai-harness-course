# Modul 4 — Architektur und ADRs

> **Aufwand:** ca. 90 Min Lesen · 90 Min Übung. Spiralcurriculum: ID-Schema und Source Precedence (Module 1, 2) bekommen hier einen neuen Quadranten — ADRs sind *inferential feedforward* mit Brücke zu *computational feedback*.

## Engage

Du fragst deinen Implementation-Agent: *"Warum hast du den Layer
Service direkt mit Runtime verbunden, ohne Adapter?"* — er antwortet:
*"Schien die einfachste Lösung."* In einem Repo *mit* ADR hätte er
antworten müssen: *"ADR-7 verbietet das. Adapter ist Pflicht."* Welcher
Unterschied liegt zwischen den beiden Antworten? Genau die ADR. Ohne sie
gewinnt "ist halt so" gegen "weil".

## Lernziele

Nach diesem Modul kannst du:

* einen ADR im MADR-Format mit Kontext, Optionen, Entscheidung und Konsequenzen *verfassen* (Erschaffen · prozedural),
* die Trennung ADR ↔ Spec ↔ Plan *erklären* und Grenzfälle *einordnen* (Analysieren · konzeptuell),
* eine ADR-Aussage in eine maschinell prüfbare Fitness-Function-*Aussage* übersetzen (Anwenden · prozedural; das volle *Erschaffen* der lauffähigen Fitness Function folgt in [Modul 13](../04-qualitaet/modul-13-quality-gates.md#worked-example-vom-adr-satz-zur-fitness-function)),
* zwischen `superseded` und `deprecated` ADRs *unterscheiden* und einen Folge-ADR *entwerfen* (Bewerten + Erschaffen · konzeptuell+prozedural).

## Lab-Bezug

* `docs/plan/adr/`
* [`../../../lab/example/exercises/03-adr.md`](../../../lab/example/exercises/03-adr.md)

## Themen

* Architekturentscheidungen
* ADR-Formate (MADR, Nygard)
* Architektur-Reviews
* ADRs als maschinell prüfbare Constraints
* Übersetzung ADR → Fitness Function

## Harness-Einordnung

ADR = *inferential feedforward* (für den Implementation-Agent) und
gleichzeitig Quelle für *computational feedback* (ArchUnit/Fitness
Functions, wenn die Entscheidung maschinell prüfbar ist). Eine ADR ohne
Fitness Function ist eine Absichtserklärung.

## Vorab — was hältst du heute für wahr?

*Bevor du die Kernidee liest:* notiere in einem Satz deine spontane
Antwort auf jede dieser drei Fragen.

1. *"Was begründet eine ADR — eine Anforderung oder eine Lösung?"*
2. *"Wenn du eine alte Entscheidung änderst, schreibst du die ADR um oder schreibst du eine neue?"*
3. *"Eine ADR sagt 'lose koppeln'. Ist das eine ADR, oder fehlt noch etwas?"*

Lass die Notiz neben dem Modul liegen. Am Modul-Ende prüft der
Selbstcheck genau diese drei Punkte — und der Block *Typische
Fehlvorstellungen* zeigt, wo die häufigsten Reibungen liegen.

## Kernidee

Ein ADR ist die einzige Stelle, an der "weil" gegen "ist halt so" gewinnt.
Wenn dein Reviewer-Agent den Grund nicht findet, kann er die Entscheidung
nicht verteidigen.

## Hard Rule (Beispiel aus c-hsm-doc, ADR 0001)

Begriff *Hard Rule* siehe Glossar in
[`../grundlagen/konventionen.md`](../grundlagen/konventionen.md).

*"Eine ADR mit Status `Accepted` wird nicht inhaltlich überschrieben.
Spätere Korrekturen oder Schärfungen entstehen als neue ADR mit
explizitem Verweis auf die abgelöste oder geschärfte Vorgängerin."*

Wirkung: ADRs sind Geschichtsdokumente, kein Wiki. Reviewer-Agent kann
auf ältere Entscheidungen vertrauen, ohne Versionsstände zu vergleichen.

## Typische Fehlvorstellungen

- **"Eine ADR begründet eine Anforderung."** — Nein. ADRs begründen die *Lösung*. Anforderungen begründet die Spec. Wer ADRs zur Spec macht, kann später keine Architektur ohne Lastenheft-Änderung wechseln.
- **"Wenn ich die Entscheidung ändere, schreibe ich die ADR um."** — Hard Rule: Accepted-ADRs werden nicht überschrieben. Folge-ADR mit `supersedes ADR-N`. Sonst kann der Reviewer-Agent nicht auf ältere Entscheidungen vertrauen.
- **"Eine ADR ohne Fitness Function ist eine ADR."** — Eine ADR ohne Fitness Function ist eine Absichtserklärung. Wer architecture fitness im Kopf hat, schreibt parallel den ArchUnit-Test.
- **"MADR ist Pflicht."** — MADR ist ein Format unter mehreren (auch Nygard, Tyree/Akerman). Wichtig ist, dass dein Repo *eines* konsequent benutzt.
- **"Architektur ist Bilder zeichnen."** — Diagramme sind *eine* Output-Form, nicht die Sache selbst. Architektur in diesem Kurs heißt: *Entscheidungen mit Begründung (ADR), prüfbar gemacht (Fitness Function), versioniert (Accepted-Hard-Rule)*. Ein Diagramm ohne ADRs hinter sich ist Wandtapete; eine ADR ohne Fitness Function ist Absichtserklärung. `spec/architecture.md` ist explizit *diagrammatisch und enthält keine eigenen Anforderungen* (siehe Spec-Stratifizierung in [`../grundlagen/konventionen.md#spec-stratifizierung`](../grundlagen/konventionen.md#spec-stratifizierung)) — genau weil sonst Bilder anfangen würden, die ADR-Schicht zu ersetzen.
- **"ADRs sind Dokumentation, nicht Constraints."** — Klingt harmlos, ist die folgenreichste Fehlvorstellung in diesem Modul. Eine ADR ohne maschinelle Durchsetzung ist eine *Absichtserklärung*, die der Implementation-Agent freundlich liest und dann ignoriert, wenn ein anderer Pfad "einfacher" wirkt. Eine ADR *mit* Fitness Function ist ein Constraint — die Layering-Regel, die ArchUnit dem Agenten als roten Build entgegenhält. Worked Example in [Modul 13 §Worked Example "ADR → import-linter"](../04-qualitaet/modul-13-quality-gates.md#worked-example-vom-adr-satz-zur-fitness-function) zeigt, was die Übersetzung kostet (kleine Tabelle: ADR-Satz, Werkzeug, Make-Target, Failure-Beispiel). Wer das nicht macht, dokumentiert *Hoffnung*.

Weitere Präkonzepte, die diesem Kurs zugrunde liegen: [`../grundlagen/lernervorstellungen.md`](../grundlagen/lernervorstellungen.md). Ergänze deine eigenen.

## Worked Example: vom Diskussionsfaden zum prüfbaren ADR

> **Wenn du MADR-/Nygard-ADRs routiniert schreibst und Fitness Functions formulieren kannst, springe zu [§Übungen](#übungen).** Wer das Schema bereits hat, profitiert von Worked Examples weniger als Anfänger (Expertise-Reversal); für letztere ist die Sieben-Schritt-Schablone unten der Hauptlernträger.

**Ausgangssituation:** Im Team kommt wiederholt der Vorschlag, den
Service direkt mit der externen API zu sprechen ("warum Adapter? das ist
doch nur ein REST-Call"). Drei Vorfälle innerhalb von zwei Wochen.

**Schritt 1 — Triggerschwelle erreichen.** Drei Vorfälle = Symptom →
Lücke im Harness. Architect-Agent legt ADR-Entwurf an: `0007-service-adapter-layer.md`.

**Schritt 2 — MADR-Kopf:**
```markdown
# ADR-0007 — Service-Schicht spricht externe APIs nur über Adapter

* Status: Accepted
* Datum: 2026-06-15
* Bezug: LH-QA-COUPLING-002
* Supersedes: —
```

**Schritt 3 — Kontext (Spec-Verweis statt -Wiederholung):**
> Wiederholter Wunsch, im `service/`-Layer direkt `http.Client` zu
> instanziieren. LH-QA-COUPLING-002 verlangt, dass externe Abhängigkeiten
> austauschbar bleiben (für Replay und für Provider-Wechsel).

**Schritt 4 — Optionen mit Trade-offs:**
> 1. **Direkt-Calls in Service-Schicht** — minimal Boilerplate; bricht LH-QA-COUPLING-002 (kein Replay ohne API-Mocks).
> 2. **Adapter-Schicht mit Interface** — etwas Boilerplate; erfüllt LH-QA-COUPLING-002; Replay-fähig.
> 3. **Service-Mesh / Sidecar** — verschiebt das Problem in Infrastruktur; überdimensioniert für aktuelle Repo-Größe.

**Schritt 5 — Entscheidung:**
> Option 2. Service-Layer importiert ausschließlich aus `adapter/`-Paket.
> HTTP-Client lebt unter `adapter/http/`.

**Schritt 6 — Konsequenz mit Fitness Function:**
> ArchUnit-Test `arch_no_direct_http_in_service`:
> Keine Klasse in `service.*` darf `java.net.http.*` oder `okhttp.*`
> importieren.
> Gate: `make arch-check` (vergleichbar mit dep-cruiser/dep-rule für
> Python/Go).

**Schritt 7 — Lerneintrag in `done/`** (nach Schließen der Welle, in
der ADR-7 implementiert wird):
> Steering-Loop-Beleg: drei Vorfälle in zwei Wochen → ADR-7 →
> ArchUnit-Test → kein weiterer Vorfall in 6 Wochen.

Sieben Schritte, eine geprüfte Entscheidung. Vergleich:
[`/lab/example/docs/plan/adr/`](../../../lab/example/docs/plan/adr/).

## Übungen

Die folgenden vier ADR-Übungen aktivieren LZ 1 (je ein ADR im MADR-Format
*verfassen*); die fünfte aktiviert LZ 4 (Versionierung bei ADR-Verletzung).

* ADR für Modellwahl
* ADR für Tool Calling
* ADR für Evaluierung
* ADR für Layering (Beispiel nach OpenAI: `Types → Config → Repo → Service → Runtime → UI` — jede Schicht darf nur "abwärts" importieren) und parallele Fitness Function in ArchUnit/dep-cruiser
* Lass einen Agenten gegen eine vorhandene ADR-Verletzung laufen und prüfe, ob er sie erkennt

### Minimaler Übungspfad

1. Starte mit
   [`../../../lab/example/exercises/03-adr.md`](../../../lab/example/exercises/03-adr.md).
2. Kopiere die Vorlage
   [`../../../lab/templates/docs/plan/adr/NNNN-titel.template.md`](../../../lab/templates/docs/plan/adr/NNNN-titel.template.md)
   in dein Übungs-Repo.
3. Prüfe am Ende, ob deine ADR mindestens eine spätere Fitness Function
   vorbereitet. Wenn nicht, ist sie nur Entscheidungsnotiz, noch kein
   Harness-Guide.

> *Lab-Grenze:* Der minimale Pfad führt zur ersten ADR mit
> *Fitness-Function-Anker*, nicht zur fertigen Fitness Function. Das LZ
> "ADR-Aussage in eine maschinell prüfbare Fitness Function *übersetzen*"
> (LZ 3) wird erst in [Modul 13 §Worked Example](../04-qualitaet/modul-13-quality-gates.md#worked-example-vom-adr-satz-zur-fitness-function)
> abgerufen — der minimale Pfad ist Aufwärm-, nicht Ziel-Niveau.

## Reflexion

Vier Standardfragen aus [`reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md)
nach jeder Übung, besonders nach dem ADR-Verletzungs-Lauf.
Modul-spezifische Trigger:

- **Beobachtung:** Hat der Agent die ADR erkannt? Hat er die Verletzung benannt? Oder "schien einfacher" geantwortet (siehe Engage)?
- **2×2-Quadrant:** ADR-Erkennung ist *inferential feedforward*, ArchUnit-Test ist *computational feedback*.
- **Steering-Loop:** fehlende Fitness Function nachziehen? ADR-Bezug in `harness/README.md` schärfen?
- **Conceptual Change:** Kandidaten in [`lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "ADR ohne Fitness Function ist eine ADR", "ADRs sind Dokumentation, nicht Constraints").

## Selbstcheck

* **(Erinnern)** Welche vier Pflichtabschnitte hat ein MADR-ADR (Kopf-Felder + Body-Blöcke)?
* Wann wird aus einer ADR eine Architekturtest-Regel?
* Was ist der Unterschied zwischen *superseded* und *deprecated* ADR?
* **(Anwenden)** Nimm eine ADR aus dem Lab oder einem eigenen Repo — formuliere in einem Satz, *was* eine Fitness Function maschinell prüfen würde, wenn du sie dazu schreiben müsstest.
* **(Erschaffens-Prozess)** Welcher Schritt deines ADR-Schreibens war der *unsicherste* — und warum? (Erfahrungsgemäß: Schritt 4 "Optionen mit Trade-offs" oder Schritt 6 "Fitness Function".)
* **(Erschaffen — aktiviert LZ 4 Erschaffens-Hälfte)** Gegeben: ADR-0007 *"In-Memory-Cache vor Index-Layer"* steht auf `superseded`, der Folge-ADR ist noch nicht geschrieben. Entwirf den Kopf des Folge-ADR (Status, `supersedes: ADR-0007`, `LH-*`-Bezug) plus einen Drei-Zeilen-Body-Entwurf, der mindestens *eine* explizit benannte Option und einen Trade-off enthält, der gegen ADR-0007 spricht.

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Vier MADR-Pflichtabschnitte? | "Titel, Text." | Kopf-Felder (Status, Datum, Bezug, ggf. Supersedes) + Body-Blöcke (Kontext, Optionen mit Trade-offs, Entscheidung, Konsequenzen). | + Eine fehlende *Optionen*-Sektion ist die häufigste Drift: dann ist die ADR ein Postulat, kein Entscheidungsprotokoll — und Reviewer kann sie nicht verteidigen. |
| Wann wird aus einer ADR eine Architekturtest-Regel? | "Wenn man sie prüfen will." | Wenn die ADR-Aussage maschinell formulierbar ist (Modul `X` darf `Y` nicht importieren; Layer `A` ruft `B` nicht direkt auf); Übersetzung in ArchUnit/dep-cruiser/import-linter. | + Hinweis, dass ohne Fitness Function die ADR Absichtserklärung bleibt; und dass *jede* ADR diese Frage beantworten muss — auch wenn die Antwort "lässt sich nicht maschinell prüfen" lautet. |
| *Superseded* vs. *deprecated* ADR? | "Beides bedeutet alt." | Superseded: durch konkrete Nachfolge-ADR ersetzt (mit ID-Bezug). Deprecated: nicht mehr gültig, aber kein Ersatz benannt. | + Folge für Reviewer: superseded → Reviewer prüft gegen Nachfolger; deprecated → Reviewer markiert als Lücke und fordert Folge-ADR. |
| Fitness-Function-Übersetzung in einem Satz? | "Test schreiben." | Eine maschinell prüfbare Aussage in der Form "Komponente/Datei/Layer X darf (nicht) Y" — mit konkretem Werkzeug (ArchUnit/dep-cruiser/import-linter) und konkreter Gate-Verdrahtung (`make arch-check`). | + Wenn dir kein Satz einfällt: ADR-Aussage ist zu vage formuliert (nicht "lose koppeln", sondern "Service-Layer importiert nicht aus `runtime.*`"). Vage ADRs sind unprüfbare ADRs. |
| Unsicherster Schritt des ADR-Schreibens? | "Alles klar." (verdächtig) | Konkret benannter Schritt + Begründung (z. B. "Schritt 4 Optionen, weil ich zwei der drei erst beim Hinschreiben nachträglich überhaupt erwogen habe"). | + Pointe: wer Schritt 4 (Optionen mit Trade-offs) überspringt oder schwammig hält, postet ein *Entscheidungs-Ergebnis* ohne *Entscheidungs-Belege* — und genau das macht ADRs unverteidigbar im Review. Schritt 6 (Fitness Function) ist die zweite häufige unsichere Stelle; wer hier "lässt sich nicht prüfen" schreibt, hat oft nur zu vage formuliert. |
| Folge-ADR zu superseded ADR-0007 entworfen? | Kopf vorhanden, Body sagt nur "neue Entscheidung". | Kopf mit `supersedes: ADR-0007` und `LH-*`-Bezug; mindestens eine explizit benannte Option (z. B. *Read-through-Cache hinter Index-Layer* vs. *Cache entfernen*) plus ein Trade-off, der ADR-0007 widerlegt (z. B. *"Stale-Reads im Worked Example von Modul 10 zeigen, dass die ursprüngliche Annahme 'Cache kann nicht stale werden' nicht hält"*). | + Eine Konsequenzen-Zeile, die explizit auf die Fitness Function des Vorgänger-ADR zurückwirkt: bleibt sie? wird sie verschärft? entfällt sie? Wer das offen lässt, verschiebt das Drift-Risiko nur. |

## Weiterlesen

* Repo mit 10 ADRs als Beispiel-Korpus: `pt9912/u-boot` in [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
* Nächstes Modul: [Modul 5 — Planning Harness](../02-planung/modul-05-planning-harness.md)
