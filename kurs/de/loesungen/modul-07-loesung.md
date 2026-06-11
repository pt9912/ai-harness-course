# Lösung — Modul 7: Carveout Management

Zugehöriges Modul: [Modul 7 — Carveout Management](../02-planung/modul-07-carveouts.md).

## Selbstcheck-Antworten

### (Erinnern) Welche zwei Pflichtfelder hat jeder temporäre Carveout?

1. **Auflösungs-Trigger** — eine *beobachtbare* Bedingung. "Sobald wir
   Zeit haben" zählt nicht; "wenn `pkg/x` > 500 LOC", "Meilenstein M2",
   "Bibliothek Y bietet Funktion Z" zählen.
2. **Folge-Slice mit ID** — der Slice, der die Auflösung übernimmt
   (auch wenn er noch in `open/` liegt). Slice schlägt Memo.

Fehlt eines der beiden Felder, ist der Carveout *de facto* permanent —
er bleibt liegen, und das Repo lügt unter "temporär". Konsequenz: Wenn
ein temporärer Carveout mehrfach an seinem Auflösungs-Datum vorbei läuft,
ist er kein temporärer mehr und muss offen als permanent klassifiziert
oder in eine ADR überführt werden.

Permanente Carveouts brauchen *kein* Trigger-Feld und keinen Folge-Slice,
aber eine technische Begründung — sonst sind sie versteckte
Architekturentscheidungen.

### (Erinnern) Wo im Repo lebt ein Carveout — Verzeichnis und Datei-Konvention?

In `docs/plan/carveouts/`, als eigene Datei pro Carveout nach der
Konvention `CO-<NNN>-<kurzname>.md` (z. B.
`CO-001-index-coverage.md`). Damit kommt er beim Klonen mit und ist
neben Spec, ADR und Plan auditierbar — *nicht* (nur) im
Issue-Tracker.

Warum das zählt: Ein Carveout, der nur im Tracker existiert, taucht
im `make gates`-Kontext nicht auf — ein Implementation-Agent sieht
dann nicht, dass die Schwelle *bewusst* gesenkt wurde, und behandelt
die Ausnahme als Normalzustand oder "repariert" sie wild. Das ist
eine versteckte Spec-Lücke: Lopopolos Maxime gilt auch hier — was der
Agent nicht im Kontext erreicht, existiert für ihn nicht.

### Wann darf ein Carveout das `make gates`-Ziel grün halten, und wann nicht?

Grün halten ist erlaubt, wenn:

1. Der Carveout *dokumentiert* ist (in `docs/plan/carveouts/`).
2. Er einen **Trigger** für die Auflösung benennt (z. B. "wenn `pkg/x` > 500 LOC", "Meilenstein M2", "Bibliothek Y bietet Funktion Z"). Der Trigger darf nicht "irgendwann" sein.
3. Er einem **Folge-Slice** zugeordnet ist, der die Auflösung übernimmt (auch wenn der noch in `open/` liegt).
4. Das Gate selbst ihn explizit kennt — z. B. `coverage-gate` weiß: "Pfad X ist temporär bei 0 % Coverage, Begründung in `docs/plan/carveouts/CO-007`".

Grün halten ist *nicht* erlaubt, wenn:

- Es keine Carveout-Datei gibt ("Wir machen mal eine Ausnahme").
- Der Trigger fehlt oder lautet "wenn Zeit ist".
- Der Folge-Slice fehlt.
- Mehrere Slices die gleiche Carveout-Begründung wiederverwenden, ohne dass jemand auflöst ("Cargo-Cult Carveout").

Faustregel: Ein Carveout ohne Auflösungs-Plan ist eine *permanente
Ausnahme*, die als *temporär* getarnt ist — und damit eine Harness-Lüge.

### Drei Werkzeuge für gelockerte Gate-Disziplin — wann welches?

Drei legitime Alternativen — nicht eine Mehrfach-Variante derselben
Sache. Der Disambiguierungs-Reflex hängt am **Symptom**, nicht am
Werkzeug:

| Wahl                       | Symptom-Indikator (woran erkennst du es?)                                                                                          | Träger                            | Folge-Artefakt                                                                            |
|----------------------------|------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------|-------------------------------------------------------------------------------------------|
| **Carveout**               | *Eine* konkrete Gate-/Regelausnahme, klar abgrenzbar, mit Folge-Slice und Auflösungs-Trigger.                                      | einzelne Diskrepanz               | `docs/plan/carveouts/CO-<NNN>-*.md`                                                       |
| **BF-Sub-Area-Markierung** | Diskrepanz-**Häufung** im selben Geltungsbereich; oder generelles *"Code existiert vor Doku"*-Muster (z. B. 4 Carveouts auf `internal/index/`). | ganze Sub-Area                    | Modus-Deklaration im Adaptions-Block von `harness/conventions.md`, mit Graduation-Trigger |
| **Bootstrap-aware Gate**   | Gate, dessen Schwelle systemisch mit dem Repo-Reifegrad **mitwachsen** soll (Coverage 0 → 70 % bei M2), nicht einmalig gelockert.    | Gate-Stufung                      | Gate-Konfiguration mit Reifestufe + Trigger (Modul 13)                                    |

> *Warum diese Tabelle anders aussieht als die in Worked Example A
> Schritt 6:* Dort lautet die Frage *"wie löse ich eine konkrete
> Diskrepanz auf?"* — die dritte Option ist dann der **permanente ADR**,
> und das Bootstrap-aware Gate erscheint *absichtlich nicht* (es regelt
> Gate-Reifestufung, nicht Diskrepanz-Auflösung). Hier lautet die Frage
> *"wie gehe ich mit gelockerter Gate-Disziplin um?"* — dann gehört das
> Bootstrap-aware Gate dazu, und der permanente ADR ist der Sonderfall
> "Trigger nie erreichbar". Carveout und BF-Markierung sind in beiden
> Triaden dieselben; nur die dritte Option wechselt mit der Frage.

**Häufigste Verwechslung — und die Korrektur dazu:** wer ein Dutzend
Carveouts auf denselben Geltungsbereich (z. B. `internal/index/`)
anlegt, hat das trainierte Carveout-Verfahren auf einen Fall
übertragen, wo die einfachere **BF-Sub-Area-Markierung** genügt —
eine Deklaration im Adaptions-Block, die die ganze Sub-Area als BF
markiert und einen Graduation-Plan trägt. Anti-Pattern:
*Carveout-Kaskade* (viele Einzel-Carveouts für ein systemisches Muster)
und *Stufung-ohne-Trigger* (Bootstrap-aware Gate-Mimikry, dessen
Reifestufe nie eintreten kann — entweder Carveout-Wildwuchs oder
permanente ADR). Keine harte Carveout-Zahl als Schwelle — wer die
Diskussion am Zähler aufhängt, hat das Symptom-Muster mit einer Quote
verwechselt; die Faustregel ist der **gemeinsame Geltungsbereich**, nicht
*n ≥ 3*.

Vertiefung: [Modul 7 §Worked Example A Schritt 6](../02-planung/modul-07-carveouts.md#worked-example-a-einen-carveout-dokumentieren)
führt das Frage-Schema (Carveout? BF-Markierung? ADR?) als
Entscheidungsbaum durch.

### (Anwenden — LZ 4) Carveout-Audit-Slice für die nächste Welle skizzieren

Skizze entlang der Schablone aus Worked Example B:

- **DoD (vier Punkte — drei Status-Aktionen plus ein Belegartefakt):**
  1. Jeder aktive Carveout in `docs/plan/carveouts/` trägt ein
     aktuelles `Letzte Prüfung:`-Datum.
  2. Jeder Carveout mit eingetretenem Trigger ist nach `done/`
     verschoben (inkl. Entfernen der Gate-Ausnahme).
  3. Jeder Carveout, der seit > 2 Wellen "aktiv" steht, ist explizit
     als weiter-gültig bestätigt oder in eine ADR überführt.
  4. Audit-Bericht (vorher/nachher/Aktion) als Closure-Notiz der
     Welle.
- **Beteiligte Rollen:** Planner identifiziert die fälligen Carveouts
  vor Welle-Closure; Architect entscheidet bei Permanenz über die
  ADR-Überführung; Implementer führt `git mv` und Config-Updates aus.
- **Belegartefakt:** die Audit-Bericht-Tabelle in
  `done/<welle>-results.md`.

**Die drei Status-Übergänge**, die der Slice möglich machen muss:
*aufgelöst* (Trigger eingetreten → `done/`), *permanent* (Trigger
wird nie eintreten → ADR-Überführung), *weiterhin aktiv* (Trigger
sinnvoll → Prüfdatum nachtragen).

**Der unbequemste ist *permanent → ADR*:** Er gibt zu, dass ein
angeblich temporäres Konstrukt in Wahrheit eine stille
Architekturentscheidung war. Die anderen beiden Übergänge sind
Buchhaltung; dieser ist ein Eingeständnis — und genau deshalb wird er
am häufigsten vermieden. Wer ihn nie vollzieht, hat keinen
Carveout-Mechanismus, sondern eine Sammlung gut formatierter Lügen.

Steering-Loop-Aktion (exzellent): den Audit-Slice als Schablone unter
`docs/plan/planning/templates/carveout-audit.md` festschreiben —
ohne Vorlage wird er beim dritten Mal vergessen, und die Drift kehrt
zurück.

## Übungshinweise

### Dokumentiere einen Carveout für eine fehlende Coverage-Schwelle

Pflicht-Inhalt einer Carveout-Datei:

- **ID** (`CO-NNN`)
- **Betroffenes Gate** (`coverage-gate`, `coverage-gate-critical`)
- **Geltungsbereich** (Pfad, Modul, Datei)
- **Begründung** (technisch, nicht "noch nicht geschafft")
- **Auflösungs-Trigger** (Meilenstein, Code-Eigenschaft, externes Ereignis)
- **Folge-Slice-Referenz** (`slice-X-coverage-Y.md` in `open/` oder `next/`)
- **Datum** der Anlage und letzten Prüfung

Vergleich-Möglichkeit:
[`/lab/example/docs/plan/carveouts/`](../../../lab/example/docs/plan/carveouts/)
(im Lab nach Phase B).

Zum geforderten **Schluss-Satz** (Mini-Anwendung von Lernziel 3):
Ein guter Satz benennt das *Symptom*, nicht das Werkzeug — z. B.
"Carveout, weil es *eine* abgrenzbare Gate-Ausnahme mit beobachtbarem
Trigger ist; keine BF-Markierung, weil keine Diskrepanz-Häufung im
selben Geltungsbereich vorliegt; kein permanenter ADR, weil der
Trigger erreichbar ist." Wer nur "ist halt temporär" schreibt, hat
die Werkzeug-Disambiguierung (siehe Drei-Werkzeuge-Tabelle oben)
nicht abgerufen.

### Verknüpfe ihn mit einem konkreten Folge-Slice

Der Folge-Slice sollte:

- Den Auflösungs-Trigger des Carveouts in seinen DoD übernehmen.
- Eine Closure-Notiz vorsehen, die den Carveout *schließt* (Datei nach `docs/plan/carveouts/done/` oder Markierung "RESOLVED").
- In der Roadmap im Block der Welle stehen, in der der Trigger erwartet wird.

### Carveout-Audit-Slice instanziieren (Anwenden — LZ 4)

Die Übung ist eine *Instanziierung* der Schablone aus Worked
Example B — kein Neuentwurf: Schablone kopieren, eigenes Datum,
eigene Carveouts, eigene Welle einsetzen. Beispiel-Instanz für eine
Welle 3:

```markdown
# SL-CO-AUDIT-welle-3: Carveout-Audit vor Welle-3-Closure

**DoD:**
- Jeder aktive Carveout in `docs/plan/carveouts/` hat ein aktuelles
  `Letzte Prüfung:`-Datum (≤ 2026-07-02).
- Jeder Carveout, dessen Trigger eingetreten ist, ist nach `done/`
  verschoben.
- Jeder Carveout, der seit > 2 Wellen "aktiv" ist, wurde explizit
  als weiter-gültig bestätigt oder in eine ADR überführt.
- Audit-Bericht als Closure-Notiz in `done/welle-3-results.md`.

**Rollen:** Planner identifiziert · Architect entscheidet bei
Permanenz · Implementer führt `git mv`/Config-Updates aus.
```

Beiliegende Audit-Bericht-Tabelle (Closure-Notiz-Block, eigene
Einträge statt der WE-B-Beispiele):

```markdown
## Carveout-Audit — Welle 3 (2026-07-02)

| Carveout | Status vorher | Status nachher | Aktion |
|---|---|---|---|
| CO-005 (Lock-File-Pin) | aktiv, Trigger "Folge-Slice slice-018 done" | aufgelöst | git mv nach `done/`; Pin entfernt |
| CO-009 (Latenz-Schwelle) | aktiv, Trigger "100k-Korpus verfügbar" | aktiv, geprüft | Datum 2026-07-02 nachgetragen |
| CO-011 (Mock-Auth im Devmode) | aktiv seit Welle 1 | permanent | überführt in ADR-0016 |
```

**Zum absichtlichen Fehlerfall** (*eine* Welle ohne Audit schließen):
Erwartete Beobachtung nach zwei Wellen — aktive Carveouts, deren
Trigger längst eingetreten ist, liegen weiterhin in `carveouts/`;
das Repo lügt unter `aktiv`, Gates bleiben grün auf Basis von
Ausnahmen, die niemand mehr braucht. Das Re-Audit räumt auf
(`git mv` nach `done/`, eine Permanenz-Drift wandert in eine ADR) —
und liefert die zentrale Erkenntnis des Moduls: *Drift entsteht
nicht durch falsches Tun, sondern durch nicht-getanes Auditieren.*
Der Carveout-Mechanismus hält nur, wenn ihn ein zweiter Mechanismus
auditiert.

Hinweis zum Anspruchsniveau: Die Übung trägt das Label *Anwenden*
(nicht Erschaffen) — die Konstruktionsleistung steckt schon in der
Schablone aus Worked Example B; geprüft wird, ob du sie korrekt auf
dein Repo instanziierst und den Fehlerfall beobachtest.

## Häufige Fehler

- **Carveout = "noqa".** Carveouts sind nicht inline. Sie leben in der Plan-Doku und sind im Gate selbst verankert.
- **Carveouts ohne Audit-Termin.** Wenn niemand regelmäßig durch `docs/plan/carveouts/` geht, sammeln sich Karteileichen. Carveout-Audit sollte als eigene Welle oder als wiederkehrender Slice geplant sein.
- **Vergleichbare Carveouts vermehren sich.** Wenn mehrere Stellen denselben Carveout brauchen, ist die *Ursache* der gemeinsame Punkt — meist ein fehlendes ADR oder eine fehlende Bibliotheks-Wahl. Dort ansetzen, nicht überall Carveout setzen.

## Verweise

- Entropy Management als Konzept: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)
- Bootstrap-aware Gates als verwandtes Muster: [Modul 13](../04-qualitaet/modul-13-quality-gates.md)
- Vorherige Lösung: [Modul 6](modul-06-loesung.md)
- Nächste Lösung: [Modul 8](modul-08-loesung.md)
