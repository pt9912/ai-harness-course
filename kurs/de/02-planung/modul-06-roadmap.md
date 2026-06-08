# Modul 6 — Roadmap Engineering

> **Aufwand:** ca. 60 Min Lesen · 60 Min Übung. Die konzeptuelle Tiefe liegt in [Modul 5 (Slice-Schnitt)](modul-05-planning-harness.md) und [Modul 7 (Carveouts)](modul-07-carveouts.md); das siebenschrittige Worked Example zum Wellen-Schnitt unten trägt jedoch die Hauptlast dieses Moduls — plane die volle Stunde ein.

## Mini-Glossar für dieses Modul

Vier neue Begriffe — Volldefinitionen in
[`../grundlagen/konventionen.md`](../grundlagen/konventionen.md#kernbegriffe).

| Begriff | Ein-Satz-Definition | Bild im Kopf |
|---|---|---|
| **Welle** | Sequenz von Slices, geschlossen durch einen *Trigger*, nicht durch ein Datum. | eine Welle, die bricht, *wenn* das Wasser hoch genug ist — nicht *wann* die Uhr klingelt. |
| **Meilenstein** | Beobachtbarer Repo-Zustand am Ende einer Welle — nicht ein Datum, sondern ein Beleg. | das Kerbholz am Bergpfad: du bist *hier*, weil du *das* erreicht hast. |
| **Release** | Ein Artefakt, das in eine Umgebung wandert (Staging, Produktion) — kann mehrere Wellen umfassen oder eine. | das Päckchen, das das Lager verlässt, nicht der Pack-Vorgang. |
| **Trigger** | *Beobachtbare* Bedingung, mit der eine Welle closed (vgl. Carveout-Auflösungs-Trigger, Modul 7). | die Glocke, die *anzeigt*, dass es jetzt soweit ist — nicht "wenn wir Zeit haben". |

## Engage

Frage an drei Tech Leads: *"Wann ist Welle 3 fertig?"* — Antwort A:
*"Am 30. Juni."* Antwort B: *"Wenn SL-024 und SL-027 in done/ liegen
und der Replay-Lauf grün ist."* Antwort C: *"Wenn das Team durch ist."*
Welche Antwort ist eine Roadmap? Genau eine. Die anderen sind Wunsch
oder Status.

## Lernziele

Nach diesem Modul kannst du:

* eine Roadmap als Reihenfolge von Wellen mit Triggern *aufbauen* (Erschaffen · prozedural),
* Welle ↔ Meilenstein ↔ Release sauber *unterscheiden* und für ein Beispiel-Repo den jeweiligen Trigger *zuordnen* (Analysieren · konzeptuell),
* eine Welle, die 30 % über Schätzung liegt, *bewerten* (neu schneiden / neu planen / Carveout) (Bewerten · prozedural+metakognitiv),
* Welle-Abhängigkeiten *modellieren* und Blocker *identifizieren* (Analysieren · konzeptuell).

## Lab-Bezug

* `docs/plan/planning/in-progress/roadmap.md`

## Themen

* Meilensteine
* Releases
* Fortschrittskontrolle
* Abhängigkeiten zwischen Wellen

## Kernidee

Eine Roadmap ist eine Reihenfolge von Wellen, keine Reihenfolge von
Terminen. Termine sind eine Folge der Wellen, nicht ihr Treiber.

## Typische Fehlvorstellungen

- **"Roadmap ist eine Datumsleiste."** — Datum ist Output, nicht Input. Wer Datumsleisten plant, plant Wunschdenken.
- **"Burndown ist Fortschritt."** — Burndown ist *Tempo*. Fortschritt ist, ob die Welle das verspricht, was sie sollte.
- **"Eine Roadmap ist statisch."** — Eine Roadmap, die nach drei Wellen nicht angepasst wurde, hat den Steering Loop nicht durchlaufen.
- **"Welle = Sprint."** — Ein Sprint endet durch *Datum* (zwei Wochen sind um). Eine Welle endet durch *Closure-Kriterien* (alle ihre Slices in `done/`, Replay-Lauf grün, Closure-Einträge geschrieben). Wer Wellen wie Sprints schneidet, kappt halbfertige Slices am Datum — und produziert genau die Auditierbarkeits-Lücke, die der Harness verhindern soll.
- **"Trigger = Datum."** — Ein Trigger ist eine *beobachtbare Bedingung* ("SL-024 liegt in `done/`", "Replay-Lauf gegen Golden Set grün", "Carveout `CO-007` aufgelöst"). Ein Datum ist kein Trigger, sondern eine Prognose. Wenn das einzige Trigger-Kriterium ein Kalendertag ist, plant die Roadmap nicht — sie hofft.

## Worked Example: einen Datumswunsch in eine Trigger-Welle übersetzen

> **Wenn du Wellen routiniert über Closure-Trigger und Abhängigkeiten definierst und Termine als Folge der Wellen sichtbar machst, springe zu [§Übungen](#übungen).** Worked Example zeigt den Pfad vom Datumswunsch zur Trigger-Welle; ist die Disziplin bereits da, kostet das Mitlesen Last (Expertise-Reversal).

**Ausgangssituation:** Ein Stakeholder sagt: *"Welle 3 muss bis Ende
Juli fertig sein, wir haben einen Audit-Termin."* Eine Datumsleiste ist
verlockend. Sie ist auch falsch — denn das Datum ist eine *externe*
Bedingung (Meilenstein M3), nicht die Welle.

**Schritt 1 — Wunsch in Inhalt zerlegen.** Frage zurück: *Was muss
*beim Audit* gezeigt werden?* Die Antwort ist immer eine Liste von
beobachtbaren Zuständen — und genau diese werden zu Closure-Triggern.
Stakeholder antwortet konkret: "ANN-Suche funktioniert auf 100k
Einträgen unter 1 s p95; Multi-Sprach-Adapter ist konsolidiert; OTel-
Pipeline zeigt End-to-End-Traces."

Drei Zustände, drei Trigger-Anker — und keiner davon enthält ein
Datum.

**Schritt 2 — Inhalt in Slices binden.** Jeder Closure-Trigger muss auf
einen oder mehrere Slices mit eigenem DoD verweisen. Sonst ist der
Trigger ein Wunsch, kein Beleg.

| Trigger-Anker (Stakeholder) | Slice(s) (Implementer-Ebene) |
|---|---|
| ANN-Suche < 1 s p95 bei 100k | `slice-014` (ANN-Bibliothek-Integration) + `slice-019` (Latenz-Replay gegen 100k-Korpus) |
| Multi-Sprach-Adapter konsolidiert | `slice-015` (Adapter-Cleanup) |
| OTel-Pipeline E2E | `slice-017` (OTel-Collector) + `slice-018` (Trace-Schema-Pflicht) |

Mehrfachbezüge sind erlaubt — *fehlende* Bezüge nicht. Wer einen
Trigger ohne Slice formuliert, hat einen Wunsch ohne Plan.

**Schritt 3 — Abhängigkeiten gegen vorhandene Wellen messen.** Eine
Welle, die ohne fertige Vorgängerin nicht starten kann, ist eine
Phantom-Welle. Lab-Beispiel: Welle 3 (`welle-3-skalierung`) hängt an
Welle 2 (`welle-2-qualitaet`) — Property-Tests müssen *vor* der
Skalierungs-Welle stehen, weil sonst die Skalierungs-Gates auf einer
nicht-property-getesteten Basis laufen.

Im Abhängigkeitsgraphen wird das eine gerichtete Kante; in der
Roadmap-Tabelle ein expliziter Eintrag in der `Trigger`-Spalte.

**Schritt 4 — Welle-Eintrag mit den drei Pflicht-Bestandteilen
schreiben.** Closure-Kriterien · Slice-IDs · Abhängigkeits-Trigger.
Vorbild aus dem Lab
([`../../../lab/example/docs/plan/planning/in-progress/roadmap.md`](../../../lab/example/docs/plan/planning/in-progress/roadmap.md)):

```markdown
## Aktuelle Welle

**Welle-ID:** welle-3-skalierung
**Geplantes Ende:** 2026-07-24 (Schätzung)

**Closure-Trigger:**
- slice-014 (ANN-Bibliothek) done in allen Sprachen.
- slice-015 (Multi-Sprach-Adapter-Cleanup) done.
- slice-019 (Latenz-Replay) grün: p95 < 1 s bei 100k Korpus.
- ADR-0004 (ANN-Bibliothek-Wahl) `Accepted`.

**Vorgänger-Trigger:** welle-2-qualitaet done.
```

Datum *erscheint* als "Geplantes Ende (Schätzung)" — es triggert
nichts, es prognostiziert. Wenn die Schätzung kippt, kippt sie als
Schätzung, nicht als Closure-Kriterium.

**Schritt 5 — Meilenstein neben die Welle setzen, nicht in sie.** Der
Audit-Termin ist *Meilenstein M3*, nicht *Welle 3*. Welle und
Meilenstein verhalten sich orthogonal:

| Welle | Meilenstein |
|---|---|
| endet durch Closure-Kriterien (intern) | endet durch externe Bestätigung (Audit, Release, Kunde) |
| Inhalt vollständig im Repo | Inhalt zeigt sich an einer Außengrenze |
| `welle-3-skalierung` | M3 — Skalierbar |

Tabelle aus dem Lab:

```markdown
| Meilenstein | Welle(n) | Trigger | Status |
|---|---|---|---|
| M3 — Skalierbar | welle-3-skalierung | p95 < 1 s auch bei 100k Einträgen | offen |
```

Der Audit-Termin (`2026-07-31`) ist Anhang im Meilenstein-Eintrag, nicht
Trigger der Welle. Das hat eine harte Konsequenz: wenn das Audit-Datum
gehalten werden *muss*, aber die Closure-Trigger nicht erreichbar sind,
ist die richtige Antwort ein *Carveout* (Modul 7), nicht ein halb
fertiges `done/`.

**Schritt 6 — Drift-Tabelle als Pflicht-Anhang.** Eine Roadmap, die
sich nie korrigiert, hat den Steering Loop nicht durchlaufen.
Pflicht-Block am Ende:

```markdown
## Historische Trigger-Verschiebungen

| Datum | Was wurde geändert? | Warum? |
|---|---|---|
| 2026-06-12 | slice-019 in welle-3 nachgenommen | Stakeholder ergänzte Audit-Anforderung; Trigger wäre sonst nicht beweisbar gewesen |
```

Diese Tabelle ist nicht Hilfsmittel; sie ist das Audit-Signal. Wer sie
leer hat, hat eine starre Roadmap. Wer sie *jeden* Eintrag voll hat,
hat eine treibende Roadmap.

**Schritt 7 — Bewusstes Brechen: Datum als Trigger schreiben.**
Formuliere einen Closure-Trigger absichtlich als Datum (*"welle-3-
skalierung schließt am 2026-07-24"*) und beobachte: am 24. Juli ist
slice-019 noch nicht grün — was passiert? Drei mögliche Antworten:

| Antwort | Diagnose |
|---|---|
| Welle wird trotzdem geschlossen, slice-019 wandert in welle-4. | Datum hat Closure überschrieben — der Audit fällt durch, weil slice-019 nicht belegt ist. Trigger-Disziplin ist Theorie geblieben. |
| Welle bleibt offen, das Datum wird verschoben. | Trigger-Disziplin wirkt, aber die Roadmap-Drift-Tabelle muss den Eintrag bekommen — sonst ist die Verschiebung still. |
| Carveout `CO-009` für die fehlende Latenz, Welle schließt mit Carveout. | Sauber: das Versprechen wird offen reduziert, Folge-Slice ist verdrahtet, Audit weiß, was er ansieht. |

Genau das Spannungsverhältnis zwischen Stakeholder-Datum und
Closure-Disziplin ist die Conceptual-Change-Stelle dieses Moduls: *Eine
Roadmap ist nicht "wann?", sondern "in welcher Reihenfolge wovon?"*.

Sieben Schritte, eine Welle, drei Trigger ohne Datum. Vergleich:
[`../../../lab/example/docs/plan/planning/in-progress/roadmap.md`](../../../lab/example/docs/plan/planning/in-progress/roadmap.md).

## Übungen

* Aufbau einer produktiven Roadmap für das Begleit-Lab
* Modelliere eine Abhängigkeit, die eine spätere Welle blockiert
* **(Bewerten — aktiviert LZ 3)** *Welle über Schätzung bewerten.* Eine
  Welle deiner Roadmap liegt 30 % über der Schätzung. Bewerte begründet,
  ob du sie **neu schneidest**, **neu planst** oder einen **Carveout**
  setzt — und mach die Diagnose *vor* der Aktion: liegt die Abweichung an
  Slice-Größe (→ neu schneiden), an Reihenfolge/Abhängigkeit (→ neu
  planen) oder an unerwarteter Komplexität (→ Carveout)? Benenne zum
  Schluss *eine* Annahme, die beim Schätzen schon "weich" war — das ist
  dein metakognitives Steering-Signal für die nächste Schätzung.

## Reflexion

Vier Standardfragen aus [`reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md)
nach dem Roadmap-Bau. Modul-spezifische Trigger:

- **Beobachtung:** War dein erster Trigger ein Datum oder ein beobachtbarer Zustand? Welche Welle hattest du *nur* mit Datum gedacht?
- **2×2-Quadrant:** Trigger-Disziplin ist *inferential feedforward* (Roadmap-Skill).
- **Steering-Loop:** Welle-Eintrag-Template mit Trigger-Pflichtfeld? Closure-Kriterien als Selbst-Checkliste vor `done/`-Verschiebung?
- **Conceptual Change:** Kandidaten in [`lernervorstellungen.md`](../grundlagen/lernervorstellungen.md) (z. B. "Welle = Sprint", "Trigger = Datum", "Roadmap ist eine Datumsleiste").

## Selbstcheck

* **(Erinnern)** Welche drei Bestandteile braucht ein Welle-Eintrag minimal, damit "fertig" beobachtbar wird?
* **(Erinnern)** Nenne drei Beispiele für *beobachtbare* Trigger aus diesem Modul — nicht erfundene, sondern aus den Engage-/Fehlvorstellungs-Blöcken.
* Was tust du, wenn eine Welle 30 % über der Schätzung liegt — neu schneiden, neu planen oder Carveout?
* Was unterscheidet eine Welle von einem Meilenstein?
* **(Erschaffen — aktiviert LZ 1)** Gegeben drei Slices `SL-101` (API), `SL-102` (Cache, braucht die API), `SL-103` (Dashboard): entwirf den *ersten* Wellen-Eintrag als kompletten Mini-Block — Slice-IDs, *einen* beobachtbaren Trigger (kein Datum) und *ein* Closure-Kriterium. Begründe in einem Satz, warum genau diese Slices in *einer* Welle liegen und nicht über zwei verteilt sind.
* **(Analysieren — aktiviert LZ 4)** Welle 3 (`welle-3-skalierung`) kann erst starten, wenn Welle 2 (`welle-2-qualitaet`) fertig ist: Wie modellierst du diese Abhängigkeit *im Roadmap-Eintrag* von Welle 3 — und woran genau erkennst du, dass Welle 2 zum *Blocker* wird (nicht bloß Vorgängerin)?

### Selbstcheck-Rubrik

| Frage | rudimentär | solide | exzellent |
|---|---|---|---|
| Drei Bestandteile eines Welle-Eintrags? | "Slices und Datum." | Slice-IDs (Inhalt) · Trigger als beobachtbare Bedingung (kein Datum) · Closure-Kriterien (z. B. Replay grün, alle Slices in `done/`). | + Datum darf *erwähnt* werden (Prognose), darf aber nie Trigger sein — sonst kappt die Welle halbfertige Slices am Kalendertag und das Auditierbarkeits-Versprechen bricht. |
| Drei beobachtbare Trigger-Beispiele? | "Wenn etwas fertig ist." | Drei aus dem Modul: "SL-024 liegt in `done/`" · "Replay-Lauf gegen Golden Set grün" · "Carveout `CO-007` aufgelöst". | + Pointe: ein Trigger ist beobachtbar dann, wenn ein *anderer* Mensch ohne Rückfrage sagen kann, ob er eingetreten ist. "Sobald wir Zeit haben" scheitert daran; "SL-024 in `done/`" besteht. |
| Welle 30 % über Schätzung — was tun? | "Mehr Zeit geben." | Diagnose vor Aktion: liegt es an Slice-Größe (→ neu schneiden), an Reihenfolge (→ neu planen), oder an unerwarteter Komplexität (→ Carveout)? | + Hinweis, dass 30 % früh ein Steering-Loop-Signal sein können (Slice-Sizing-Regel schärfen), 30 % spät (vor Welle-Closure) eher Carveout. Metakognitiv: die *eigene* Schätzunsicherheit als Steering-Signal benennen — woran hätte man die Abweichung früher erkannt (welches Slice war schon beim Schätzen "weich", welche Annahme blieb ungeprüft)? — damit die nächste Schätzung kalibrierter ausfällt. |
| Welle vs. Meilenstein? | "Größe." | Welle = Bündel paralleler/serialisierter Slices mit Closure-Kriterien. Meilenstein = extern beobachtbarer Zustand (Release, Audit-Punkt). | + Eine Welle endet *durch* Closure-Kriterien; ein Meilenstein endet durch *Datum oder externe Bestätigung* — und genau deshalb leitet sich der Meilenstein aus Wellen ab, nicht umgekehrt. |
| Ersten Wellen-Eintrag aus `SL-101/102/103` entworfen? | Slices aufgelistet, aber Trigger ist ein Datum oder fehlt; kein Closure-Kriterium. | Vollständiger Mini-Block: Slice-IDs · *ein* beobachtbarer Trigger (kein Datum) · *ein* Closure-Kriterium; Bündelung begründet (z. B. "`SL-102` braucht `SL-101`, beide liefern erst zusammen prüfbaren Wert"). | + Schnitt-Begründung mit Gegenprobe: warum `SL-103` (Dashboard) *nicht* in dieselbe Welle gehört, wenn es ohne Cache keinen Mehrwert zeigt — und welcher Trigger es in die *nächste* Welle zieht. Der Entwurf nennt den Trigger so, dass ein Dritter ohne Rückfrage über "Welle fertig" entscheiden kann. |
| Abhängigkeit Welle 3 → Welle 2 modelliert, Blocker erkannt? | "Welle 3 kommt nach Welle 2." — Reihenfolge genannt, keine Modellierung. | Abhängigkeit als expliziter Abhängigkeits-Trigger in der `Trigger`-Spalte von Welle 3 (z. B. „startet, wenn `welle-2-qualitaet` in Closure") + gerichtete Kante im Abhängigkeitsgraphen. | + Blocker-Kriterium benannt: Welle 2 ist Blocker, sobald Welle 3 *ohne* deren Closure nicht starten kann (Phantom-Welle) — und der Test dafür: würde Welle 3 jetzt starten, liefe ein Gate auf nicht-property-getesteter Basis. Reine Vorgängerin ohne harte Kante wäre kein Blocker. |

## Weiterlesen

* Nächstes Modul: [Modul 7 — Carveout Management](modul-07-carveouts.md)
