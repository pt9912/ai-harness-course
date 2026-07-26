## Modul 6 — Roadmap Engineering

<!-- Quelle: [02-planung/modul-06-roadmap.md](../../kurs/de/02-planung/modul-06-roadmap.md) -->

### Kernidee (Modul 6)

Eine Roadmap ist eine Reihenfolge von Wellen, keine Reihenfolge von
Terminen. Termine sind eine Folge der Wellen, nicht ihr Treiber.

Konkret ist eine Roadmap eine geordnete Folge von **Wellen**: jede Welle
bündelt Slices, schließt durch einen *beobachtbaren Trigger* — nicht durch
ein Datum — und hinterlässt eine Closure-Notiz. Ein Termin darf als
Schätzung *erscheinen*, triggert aber nie; er ist Output der
Wellen-Reihenfolge, nicht ihr Treiber. Die fünf Abschnitte unten sind die
Form, die Regeln der Inhalt.

### Roadmap-Regeln (Modul 6)

- Ein Welle-Eintrag braucht minimal drei Bestandteile: Slice-IDs (Inhalt) · Trigger als beobachtbare Bedingung (kein Datum) · Closure-Kriterien (z. B. Replay grün, alle Slices in `done/`). Datum darf *erwähnt* werden (Prognose), darf aber nie Trigger sein — sonst kappt die Welle halbfertige Slices am Kalendertag und das Auditierbarkeits-Versprechen bricht.
- Ein Trigger ist beobachtbar dann, wenn ein *anderer* Mensch ohne Rückfrage sagen kann, ob er eingetreten ist. "Sobald wir Zeit haben" scheitert daran; "SL-024 in `done/`" besteht. Beispiele für beobachtbare Trigger: "SL-024 liegt in `done/`" · "Replay-Lauf gegen Golden Set grün" · "Carveout `CO-007` aufgelöst".
- Welle 30 % über Schätzung — Diagnose vor Aktion: liegt es an Slice-Größe (→ neu schneiden), an Reihenfolge (→ neu planen), oder an unerwarteter Komplexität (→ Carveout)? 30 % früh können ein Steering-Loop-Signal sein (Slice-Sizing-Regel schärfen), 30 % spät (vor Welle-Closure) eher Carveout.

### Welle ≠ Meilenstein ≠ Release (Modul 6)

- **Welle** = Bündel paralleler/serialisierter Slices mit Closure-Kriterien. Eine Welle endet *durch* Closure-Kriterien.
- **Meilenstein** = extern beobachtbarer Zustand (Release, Audit-Punkt). Ein Meilenstein endet durch *Datum oder externe Bestätigung* — und genau deshalb leitet sich der Meilenstein aus Wellen ab, nicht umgekehrt.
- **Release** — Trigger: ein Artefakt verlässt das Repo in eine Umgebung (Tag + Staging). Ein Release kann mehrere Wellen umfassen, der Meilenstein liegt *neben* der Welle (externe Bestätigung), die Welle endet *durch* Closure.

### Roadmap-Struktur: fünf Abschnitte (Modul 6)

Die Form liefert die Vorlage
[`templates/docs/plan/planning/roadmap.template.md`](../templates/docs/plan/planning/roadmap.template.md)
— fünf Abschnitte: *Aktuelle Welle · Nächste Wellen · Meilensteine ·
Abgeschlossene Wellen · Historische Trigger-Verschiebungen*. Operative Lesart:

- **Aktuelle Welle** — die laufende Welle mit den drei Pflicht-Bestandteilen (Slice-IDs · Trigger · Closure-Kriterien). Das *Geplante Ende* ist Schätzung, kein Closure-Kriterium: kippt sie, kippt sie als Schätzung.
- **Nächste Wellen** — die geordnete Vorschau; jede Zeile trägt Welle, Trigger (die Abhängigkeit als beobachtbare Bedingung), wichtigste Slices und geschätzten Aufwand (S/M/L, kein Termin). Eine Welle, die ohne fertige Vorgängerin nicht starten kann, ist eine Phantom-Welle — die Abhängigkeit steht explizit in der `Trigger`-Spalte und als gerichtete Kante im Abhängigkeitsgraphen.
- **Meilensteine** — extern beobachtbare Zustände, orthogonal zur Welle: die Welle endet *durch* Closure-Kriterien (intern), der Meilenstein durch externe Bestätigung (Audit, Release, Kunde). Der Meilenstein liegt *neben* der Welle, nicht in ihr; ein Audit-*Termin* ist Anhang im Meilenstein-Eintrag, nie Trigger der Welle. Ist das externe Datum unverrückbar, aber die Closure-Trigger unerreichbar, ist die richtige Antwort ein *Carveout* (Modul 7), kein halbfertiges `done/`.
- **Abgeschlossene Wellen** — das Closure-Log (ruhender Audit-Bestand): welche Welle wann geschlossen wurde, mit Zeiger auf ihre `done/welle-NN-results.md`.
- **Historische Trigger-Verschiebungen** — das Drift-Log (Bewegungs-Signal): jede Umplanung mit Datum, Änderung, Grund. Wer es leer hat, hat eine starre Roadmap; wer *jeden* Eintrag voll hat, eine treibende. Closure-Log und Drift-Log zusammen machen die Vergangenheit der Roadmap auditierbar.

**Wird ein Closure-Trigger doch als Datum geschrieben** und der Kalendertag
erreicht, bevor die Slices grün sind, gibt es drei Ausgänge: (a) Welle
trotzdem schließen → der Audit fällt durch, weil Slices unbelegt sind
(Trigger-Disziplin blieb Theorie); (b) Welle offen lassen, Datum
verschieben → sauber, aber der Eintrag *muss* in die Drift-Tabelle, sonst
ist die Verschiebung still; (c) Carveout für den fehlenden Beleg, Welle
schließt mit Carveout → das Versprechen wird offen reduziert, Folge-Slice
verdrahtet.

*Eine Roadmap ist nicht „wann?", sondern „in welcher Reihenfolge wovon?"*.

### Wellen-Closure-Prozedur (Modul 6)

Modul 5 gibt den *Slice*-Zyklus als Zustandsmaschine vor (`open/` →
`next/` → `in-progress/` → `done/`). Die *Welle* liegt eine Ebene
darüber: Sie schließt nicht durch einen einzelnen Slice-Übergang, sondern
durch einen geordneten Ablauf, der alle ihre Slices bündelt. Fünf
Schritte — jeder hinterlässt einen Beleg, keiner ein Datum:

**Eröffnung — drei Schritte.** (1) Welle-Ziel, **Out-of-Scope** und
Closure-Trigger festlegen: beobachtbare Bedingung, kein Datum; erst danach
Slices zuordnen. Out-of-Scope gehört dazu — dieselbe Disziplin wie im
Lastenheft (Modul 3) und im Slice-Plan (Modul 9); was nicht ausdrücklich
ausgeschlossen ist, dehnt die Welle, bis der Closure-Trigger unerreichbar
wird. (2) **Offene Beobachtungen der letzten Closure sichten** —
Sektion *Beobachtungen unter Schwelle* aus
`done/welle-<NN-1>-results.md` durchgehen: Betrifft eine davon die
Sub-Areas dieser Welle, gehört sie in die Slice-Planung (Risiko im
betroffenen Slice) oder, bei Erreichen von 3×, als eigener Slice, der die
Lücke schließt. Das ist der einzige Schritt, der Closure-Wissen wieder
als Eingabe nutzt; ohne ihn ist die Closure-Notiz write-only und die
Zählregel des Steering Loops hat keinen Zähler. (3) Welle-Datei flach
anlegen (`docs/plan/planning/<welle-id>.md`, Ziel-Form
[`../templates/docs/plan/planning/welle.template.md`](../templates/docs/plan/planning/welle.template.md))
und in der Roadmap als *Aktuelle Welle* eintragen.

**Nicht** in den Lauf-Kontext: `done/` wird dem Implementation-Agenten
nicht geladen. Schritt 2 ist Planungs-Leistung — was die Schwelle
erreicht hat, ist in AGENTS.md, Gates und Skills verkörpert und wirkt
dort automatisch (Modul-0-Prinzip).

**Closure — fünf Schritte.**

1. **Trigger prüfen.** Alle Slices der Welle liegen in `done/`,
   `make gates` und der Replay-Lauf sind grün. Das ist die *beobachtbare*
   Closure-Bedingung aus der Welle-Definition — nicht der Kalendertag.
2. **Trigger-Audit der Welle.** Drei Artefaktklassen tragen einen Trigger,
   alle drei werden geprüft: **Carveout** (Auflösungs-Trigger → aufgelöst ·
   verlängert mit Folge-Slice · permanent, Modul 7) · **bootstrap-aware Gate**
   (Hochschalt-Trigger → Stufe hochschalten, oder Carveout eröffnen wenn die
   neue Schwelle rot ist, Modul 13) · **ADR** (Re-Evaluierungs-Trigger →
   bestätigen oder Folge-ADR mit `supersedes`, Modul 4). Eine Welle darf *mit*
   dokumentiertem Carveout schließen — aber nie mit einem stillen roten Gate,
   einer stehengebliebenen Reifestufe oder einer Entscheidung, deren
   Re-Evaluierungs-Bedingung vor drei Wellen eintrat. **Ein Trigger ohne
   Wächter ist eine Absichtserklärung mit Verfallsdatum.** **Zwei Paarungen mitprüfen**,
   beide nach dem Muster *Nennung ohne Deckung ist eine Harness-Lüge*:
   (a) **Anker-Paarung** — jeder Steering-Loop-Eintrag nennt einen
   Zielort, der Zielort existiert und trägt `seit welle-<NN>`
   ([`konventionen.md` §Herkunfts-Anker](grundlagen-konventionen.md#herkunfts-anker));
   (b) **Folge-Slice-Paarung** — jeder genannte Folge-Slice existiert als
   Datei in `open/`. Rot heißt: etwas wurde versprochen und nicht
   geschrieben.
3. **Welle nach `done/` schließen.** Grundlage sind die **Closure-Notizen der
   Slices dieser Welle** (§7 jeder Datei in `done/`): durchgehen und
   **verdichten**, nicht aus dem Gedächtnis zusammentragen — gleiche
   Beobachtungen zusammenfassen und zählen, 3× → *Steering-Loop-Einträge*,
   darunter → *Beobachtungen unter Schwelle*, Risiken mit Ausgang „weiter
   offen" (Modul 5) ebenfalls dorthin. Ohne diesen Lese-Schritt ist der
   Slice-Lerneintrag write-only und die Zählung nicht durchführbar.
   Closure-Notiz `done/welle-NN-results.md`
   schreiben (*was gelernt wurde*: geliefert · was funktionierte · was anders
   lief · **Steering-Loop-Einträge** · **Beobachtungen unter Schwelle** ·
   Folge-Slices (*derivativ* — der Slice selbst liegt in `open/`) ·
   Verifikation aus
   Schritt 1). Ziel-Form:
   [`../templates/docs/plan/planning/welle-results.template.md`](../templates/docs/plan/planning/welle-results.template.md).
   Ohne Lerneintrag ist die Welle nicht „fertig", nur „weg"
   (Modul 1). **Zugleich per `git mv` die Welle-Plan-Datei von flach nach
   `done/`** — neben ihre Ergebnis-Notiz; der Zustand ist die
   Verzeichnis-Position, kein `Status`-Feld (wie beim Slice). Aktive Welle
   flach, geschlossene in `done/`, die Roadmap bleibt Sequenzierungs-Autorität.
4. **Wave-Self-Close-Commit.** Ein einzelner, beobachtbarer Commit
   markiert den Abschluss — der Audit sieht *einen* Punkt, an dem die
   Welle schloss, statt eines verstreuten Verschwindens.
5. **Roadmap fortschreiben.** Die Welle wandert aus *Aktuelle Welle* in
   die Tabelle *Abgeschlossene Wellen* (mit Zeiger auf ihre
   Closure-Notiz); die erste Zeile aus *Nächste Wellen* wird zur neuen
   *Aktuellen Welle*. Löste dabei ein Trigger eine Umplanung aus, bekommt
   die *Historische Trigger-Verschiebungen*-Tabelle ihren Eintrag.

Erst wenn alle fünf Belege vorliegen, ist die Welle *auditierbar*
geschlossen.

### Regeln gegen typische Fehlannahmen (Modul 6)

- **Gegen "Roadmap ist eine Datumsleiste":** Datum ist Output, nicht Input. Wer Datumsleisten plant, plant Wunschdenken.
- **Gegen "Burndown ist Fortschritt":** Burndown ist *Tempo*. Fortschritt ist, ob die Welle das verspricht, was sie sollte.
- **Gegen "Eine Roadmap ist statisch":** Eine Roadmap, die nach drei Wellen nicht angepasst wurde, hat den Steering Loop nicht durchlaufen.
- **Gegen "Welle = Sprint":** Ein Sprint endet durch *Datum* (zwei Wochen sind um). Eine Welle endet durch *Closure-Kriterien* (alle ihre Slices in `done/`, Replay-Lauf grün, Closure-Einträge geschrieben). Wer Wellen wie Sprints schneidet, kappt halbfertige Slices am Datum — und produziert genau die Auditierbarkeits-Lücke, die der Harness verhindern soll.
- **Gegen "Trigger = Datum":** Ein Trigger ist eine *beobachtbare Bedingung* ("SL-024 liegt in `done/`", "Replay-Lauf gegen Golden Set grün", "Carveout `CO-007` aufgelöst"). Ein Datum ist kein Trigger, sondern eine Prognose. Wenn das einzige Trigger-Kriterium ein Kalendertag ist, plant die Roadmap nicht — sie hofft.
