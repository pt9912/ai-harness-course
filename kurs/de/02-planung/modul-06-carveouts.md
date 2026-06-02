# Modul 6 — Carveout Management

> **Aufwand:** ca. 60 Min Lesen · 60 Min Übung. Spiralcurriculum: Carveouts sind dein erstes konkretes Werkzeug für *Entropy Management* (Säule 3, [Klassifikation](../grundlagen/klassifikation.md#drei-operative-säulen-openai)).

## Mini-Glossar für dieses Modul

Drei neue Begriffe in diesem Modul. Volldefinitionen in
[`../grundlagen/konventionen.md`](../grundlagen/konventionen.md#kernbegriffe).

| Begriff | Ein-Satz-Definition | Bild im Kopf |
|---|---|---|
| **Carveout** | Dokumentierte Ausnahme von einem Gate oder einer Architekturregel — mit Trigger oder explizit als permanent markiert. | ein Loch im Zaun, mit Notiz "wann wird zugemacht?". |
| **Auflösungs-Trigger** | Beobachtbare Bedingung, mit der ein temporärer Carveout endet (nicht "wenn wir Zeit haben"). | die Kerze, die *anzeigt*, dass es jetzt soweit ist. |
| **Bootstrap-aware Gate** | Gate mit dokumentierter Reifestufe: weich in der Frühphase, hart ab Trigger. | Tempolimit, das in der Bauzone gilt, später verschwindet. |

## Engage

Ein Repo trägt 14 dokumentierte Carveouts. Acht davon sind "temporär".
Trigger: *"sobald wir Zeit haben"*. Wann tritt der Trigger ein? Nie. Die
acht Carveouts sind faktisch permanent — aber ihre Permanenz ist eine
Lüge im Repo. Das ist Doku-Drift in einer der gefährlichsten Formen.

## Lernziele

Nach diesem Modul kannst du:

* einen Carveout mit Trigger, Folge-Slice und Auflösungs-Kriterium *dokumentieren* (Erschaffen · prozedural),
* zwischen temporärem und permanentem Carveout *unterscheiden* und einen falsch klassifizierten Carveout *erkennen* (Bewerten · konzeptuell),
* den Unterschied Carveout ↔ bootstrap-aware Gate *einordnen* (Analysieren · konzeptuell),
* ein Carveout-Audit als wiederkehrenden Slice *entwerfen* (Erschaffen · prozedural).

## Lab-Bezug

* `docs/plan/carveouts/`

## Themen

* Temporäre Ausnahmen
* Permanente Ausnahmen
* Trigger für die Auflösung
* Folge-Slices

## Harness-Einordnung

Carveout-Pflege ist ein Pfeiler von *Entropy Management* (siehe
[`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)):
ein Carveout-Audit pro Welle verhindert, dass temporäre Ausnahmen zu
permanenten Lügen werden.

## Kernidee

Jeder temporäre Carveout benötigt einen Plan. Ein Carveout ohne
Auflösungs-Trigger ist ein permanenter Carveout, der lügt.

## Typische Fehlvorstellungen

- **"Carveout = Workaround."** — Carveout = *dokumentierter* Workaround mit Trigger. Ohne Trigger ist es eine versteckte Annahme.
- **"Carveouts gehören ins Issue-Tracker."** — Sie gehören ins Repo, neben Spec und ADRs. Tracker können vergessen werden, Repo-Files kommen mit beim Klonen.
- **"Wenn der Trigger eintritt, lösen wir den Carveout auf."** — Realität: er bleibt liegen. Deshalb braucht jeder temporäre Carveout einen *Folge-Slice mit ID*, der das Auflösen plant. Slice schlägt Memo.

## Übungen

* Dokumentiere einen Carveout für eine fehlende Coverage-Schwelle
* Verknüpfe ihn mit einem konkreten Folge-Slice

## Reflexion

Vier Standardfragen aus [`reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md)
nach der Carveout-Dokumentation und der Folge-Slice-Verknüpfung.
Modul-spezifische Trigger:

- **Beobachtung:** War dein Trigger beobachtbar oder eine Form von "sobald wir Zeit haben"? Lebt dein Carveout in `docs/plan/carveouts/` oder im Tracker?
- **2×2-Quadrant:** Trigger-Disziplin ist *inferential feedforward*; Carveout-Audit-Lauf ist *computational feedback*.
- **Steering-Loop:** Carveout-Audit als wiederkehrender Slice (siehe Lernziel 4)? Trigger-Pflichtfeld als Frontmatter-Check?
- **Conceptual Change:** Kandidaten in [`lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "Carveout = Workaround", "Wenn der Trigger eintritt, lösen wir den Carveout auf").

## Selbstcheck

* **(Erinnern)** Welche zwei Pflichtfelder hat jeder *temporäre* Carveout, damit er nicht heimlich permanent wird?
* **(Erinnern)** Wo im Repo lebt ein Carveout — Verzeichnis und Datei-Konvention?
* Wann darf ein Carveout das `make gates`-Ziel grün halten, und wann nicht?
* Wie unterscheidet sich ein Carveout von einem Bootstrap-aware Gate (siehe [Modul 12](../04-qualitaet/modul-12-quality-gates.md))?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Zwei Pflichtfelder eines temporären Carveouts? | "Beschreibung." | Auflösungs-Trigger (beobachtbar, nicht "sobald wir Zeit haben") + gekoppelter Folge-Slice mit ID. | + Fehlt eines der beiden: der Carveout ist *de facto* permanent — und gehört dann offen als permanenter Carveout markiert oder in eine ADR überführt, statt unter "temporär" zu lügen. |
| Wo lebt ein Carveout? | "Im Tracker." | `docs/plan/carveouts/` als Datei — kommt mit beim Klonen, ist neben Spec/ADR/Plan auditierbar. *Nicht* nur im Issue-Tracker. | + Folge: ein Carveout, der nur im Tracker existiert, taucht im `make gates`-Output nicht auf — und damit weiß ein Implementation-Agent nicht, dass die Schwelle bewusst gesenkt wurde. Das ist eine versteckte Spec-Lücke. |
| Wann hält Carveout `make gates` grün? | "Wenn dokumentiert." | Nur wenn Carveout *im Repo* liegt, einen Auflösungs-Trigger nennt und an einen Folge-Slice gekoppelt ist; sonst muss das Gate rot bleiben. | + Hinweis: ein Carveout, der dauerhaft `make gates` grün hält, *ohne* dass jemals sein Trigger eintritt, ist eine versteckte Architekturentscheidung — sie gehört dann in eine permanente ADR überführt. |
| Carveout vs. bootstrap-aware Gate? | "Beides macht das Gate weicher." | Carveout = Ausnahme für *einen* Fall mit Folge-Slice. Bootstrap-aware Gate = Stufung *des Gates selbst* (z. B. 40 % heute → 70 % bei M2). | + Folge: Bootstrap-aware Gate skaliert mit dem Repo; Carveout ist punktueller Vertrag. Verwechslung führt zu "Bootstrap-Schlupfloch" — Stufung ohne Trigger ist Carveout-Wildwuchs. |

## Weiterlesen

* Nächstes Modul: [Modul 7 — Agentenrollen](../03-agenten/modul-07-agentenrollen.md)
