# Lösung — Modul 5: Planning Harness

Zugehöriges Modul: [Modul 5 — Planning Harness](../02-planung/modul-05-planning-harness.md).

## Selbstcheck-Antworten

### (Erinnern) Nenne die vier Lifecycle-Verzeichnisse in Reihenfolge

`open/` → `next/` → `in-progress/` → `done/`.

Plus zwei Rückführungen, die im Lifecycle-State-Diagramm explizit sind:

- `in-progress/ → next/` — Slice ist zu groß, geht zurück zur Zerlegung.
- `in-progress/ → open/` — Slice ist blockiert (typisch mit Carveout,
  siehe Modul 7).

Faustregel: WIP-Limit auf 1 pro Implementer. Wer mehrere Slices
gleichzeitig in `in-progress/` hat, hat kein Lifecycle, sondern ein
Buffet — und keinen Punkt, an dem reproduzierbar geprüft wird, ob der
8-Schritt-Workflow durchlaufen wurde.

### (Anwenden) Triggerbedingung für jeden Lifecycle-Übergang benennen

Fünf Übergänge, jeder mit einem *beobachtbaren* Trigger:

- `open → next`: Slice wird priorisiert und eingeplant (kommt in die
  Reihenfolge des nächsten Arbeitsfensters).
- `next → in-progress`: der erste Commit, der die Arbeit am Slice
  *startet* — Branch/PR existiert, Abhängigkeiten gelöst, WIP-Slot frei.
  *Nicht* der bloße Wunsch, ihn als nächstes zu machen.
- `in-progress → done`: alle Closure-Kriterien erfüllt (Gates grün oder
  per Carveout gedeckt) *und* Lerneintrag geschrieben.
- `in-progress → next`: der Slice erweist sich als zu groß — zurück zur
  Zerlegung.
- `in-progress → open`: ein Blocker tritt auf, die Priorität ist wieder
  offen (typisch mit Carveout, Modul 7).

Am leichtesten übersehen werden die zwei **Rückführungen**
(`in-progress → next/open`): Sie sehen aus wie Scheitern und werden
deshalb gern als stilles Weiterschieben kaschiert. Genau das bricht die
Auditierbarkeit — ein zu großer Slice gehört *sichtbar* zurück, nicht
heimlich im selben Verzeichnis weiterbearbeitet.

Anti-Pattern: "Ich verschiebe ihn in `in-progress/`, damit ich nicht
vergesse, dass ich ihn morgen anfange." Damit lügt das Lifecycle-System
— jemand könnte annehmen, der Slice sei im Fluss.

### Wann darf ein Slice in `done/` landen, obwohl ein Gate rot ist?

Eigentlich nie. Eine Ausnahme:

- Wenn das rote Gate von einem **Carveout** abgedeckt ist, der explizit dokumentiert ist und einen Auflösungs-Trigger nennt (siehe [Modul 7](../02-planung/modul-07-carveouts.md)).
- Wenn das Gate ein **Bootstrap-aware Gate** ist (siehe [Modul 13](../04-qualitaet/modul-13-quality-gates.md)) und der Slice noch in der Frühphase liegt — auch dann muss der Bootstrap-Stand dokumentiert sein.

In beiden Fällen ist nicht das Gate rot "trotz Closure", sondern das
Gate ist *im aktuellen Reifegrad nicht hart* — und das ist
dokumentiert. Wenn weder Carveout noch Bootstrap, dann ist Closure
falsch.

### (Erschaffen) Zwei beobachtbare Closure-Kriterien und ein Lerneintrag

Ausgearbeitete Beispiel-Konstruktion für `SL-014a` (Login-Endpoint):

**Closure-Kriterien (beobachtbar, kein "fühlt sich fertig an"):**

1. Replay des Login-Flows gegen das Golden Set ist grün
   (`make replay-auth` exit 0) — inklusive Boundary-Fall "leeres
   Passwort" und Negative-Fall "unbekannter User".
2. Jeder der drei DoD-Punkte ist auf einen konkreten Test verlinkt
   (`test_login_returns_jwt`, `test_audit_event_on_login`,
   `test_login_rejects_invalid`) — prüfbar per
   `make verify-dod SLICE=SL-014a`.

**Lerneintrag** (Form: *benannte Spec-Lücke*):

> Gelernt: `LH-FA-AUTH-001` sagt nichts über Rate-Limiting bei
> Fehlversuchen — der Implementer hat ein plausibles, ungefordertes
> Limit (5/min) erfunden. Spec-Lücke als `LH-FA-AUTH-001`-Anmerkung
> gemeldet; Folge-Slice für die Entscheidung angelegt. Verhindert:
> dass der nächste Auth-Slice dieselbe stille Annahme anders füllt.

Woran man erkennt, dass der Lerneintrag mehr ist als "Tests grün":
Er lässt sich genau einer der drei Formen zuordnen — **geschärfte
Regel** (eine Konvention/ADR wird präziser), **neuer Sensor** (ein
Gate/Check entsteht), **benannte Spec-Lücke** (eine stille Annahme
wird explizit). "Tests grün" gehört zu keiner der drei: es beschreibt
den Zustand des Slices, nicht das, was der *Harness* gelernt hat.

Pointe (exzellent): Der Eintrag benennt, *welche künftige
Wiederholung* er verhindert — eine Vorhersage, nicht nur ein
Protokoll. Ein `done/`-Slice ohne Lerneintrag macht das
Versagensmuster unsichtbar, und derselbe Fehler wird dreimal gemacht.

### (Analysieren — Transfer aus Modul 2) Welche Sub-Areas berührt der nächste Slice — und welcher Modus passt für jede?

Beispiel-Antwort für `SL-014a` (Authentifizierung implementieren). Vier
berührte Sub-Areas, je gegen die vier Pflichtkriterien begründet —
hier kompakt als Sammel-Antwort, der volle Block-pro-Sub-Area-Stand
steht im Worked Mini-Example in Modul 5:

- *Konventionen (API-Pattern):* **GF.** `MR-014` REST-Endpunkt-Pattern
  steht; Phase 4 (Vertrag, Code wird daran gemessen); Lint-Check als
  Sensor; kein Reconciliation.
- *Test-Infrastruktur:* **BF.** Keine Sektion in
  `harness/conventions.md` (Skelett mit Inventur-Auftrag); Phase 1 BF;
  Reconciliation 1 Slice (`SL-RC-014t` + `MR-002`); Graduation-Trigger:
  Sync-Trigger setzt `MR-002` in `harness/README.md` und `AGENTS.md`.
- *Audit-Logging:* **Hybrid.** Konventionen-Dichte mittel (Pflicht-
  Adaption `MR-008` steht, Format-Standard fehlt im Code); Phase 3
  GF-Lesart. **Evidenz-/Diskrepanz-Risiko und Reconciliation-Aufwand
  sind die zwei vom Lerner in der Übung selbst zu füllenden Felder —
  Mustertext-Antworten im §Übungshinweise-Block weiter unten.** Die
  Sammel-Antwort verrät hier bewusst keinen vollständigen
  Begründungsblock, damit der Faded-Scaffolding-Lerneffekt erhalten
  bleibt.
- *Spec-Schreibung:* **GF.** `LH-FA-AUTH-001` mit drei
  Akzeptanzkriterien + `ADR-0007` (Service-Adapter-Layer); Phase 4;
  Tests werden in Modul 9 §Worked Example gegen `LH-FA-AUTH-001`
  annotiert; kein Reconciliation.

Beobachtung zum eigenen Slice: Heterogenität der Modi je Sub-Area
ist häufig, aber **kein Pflichtsignal** — Slice-Größe und
Sub-Area-Modus sind orthogonale Achsen (siehe Distractor-Klärung im
§Übungshinweise-Block). Ein korrekt kleiner Maintenance-Slice kann
ausschließlich GF-Sub-Areas berühren; ein zu breit geschnittener
Aggregat-Slice kann zufällig dieselbe Modus-Mischung haben wie ein
gut geschnittener. Der Modus-Begründungsblock prüft nicht den
Schnitt, sondern die Bewertungsleistung.

### (Erschaffen + Bewerten) `SL-031 — Bestell-Checkout` bewerten und schneiden

**(a) Bewertung gegen die zwei Größen-Kriterien:** zu groß.

- *In einem Agenten-Lauf abschließbar?* Nein — fünf DoD-Punkte
  (Warenkorb-API · Zahlungs-Integration · Bestätigungs-Mail ·
  Lager-Abbuchung · Audit-Log) überschreiten die
  Drei-Punkte-Faustregel deutlich, und die Zahlungs-Integration
  allein bringt eine externe Abhängigkeit mit eigenem Fehlerraum mit.
- *In einer Review-Sitzung prüfbar?* Nein — der Diff berührt
  mindestens vier Schichten (API, Payment-Adapter, Mail-Versand,
  Lager-/DB-Schema) plus Audit-Logging quer dazu. Kein Reviewer prüft
  das in einer Sitzung gegen Plan und ADR.

**(b) Schnitt-Vorschlag — nach Lieferwert, in drei Slices:**

| ID | DoD | Liefert |
|---|---|---|
| `SL-031a` | Warenkorb-API: Artikel hinzufügen/entfernen, Summe berechnen; Audit-Event pro Mutation. | Funktion (eigenständig nutzbarer Warenkorb) |
| `SL-031b` | Zahlungs-Integration gegen den Warenkorb: Checkout erzeugt Zahlung, Fehlerpfade getestet; Audit-Event. | Umsatz (erster durchgehender Kaufpfad) |
| `SL-031c` | Bestätigungs-Mail + Lager-Abbuchung nach erfolgreicher Zahlung, mit Idempotenz-Test. | Erfüllung (Fulfilment-Abschluss) |

Das Audit-Log wird nicht als eigener Slice geschnitten, sondern
wandert als DoD-Zeile in jeden Slice — es ist eine Quer-Anforderung,
kein lieferbares Inkrement.

**Begründung des Schnitt-Typs — Lieferwert statt Schichten:** Jeder
der drei Slices liefert allein prüfbaren Wert und wartet nicht auf
den nächsten (`SL-031a` ist ohne Zahlung demonstrierbar, `SL-031b`
schließt den Kaufpfad). Ein Schichtschnitt (`SL-031-db`,
`SL-031-service`, `SL-031-ui`) erzeugte Zombie-Slices: eine
Lager-Abbuchung ohne Checkout liefert nichts Prüfbares — sie ist
"fast fertig", bis der letzte Schicht-Slice kommt, und genau solche
Slices bleiben in `in-progress/` hängen.

Anti-Antwort: "Zu groß, irgendwie aufteilen." — ohne Bezug auf die
zwei Größen-Kriterien ist die Bewertung ein Bauchgefühl, und ohne
benannten Schnitt-Typ ist der Vorschlag nicht verteidigbar.

## Übungshinweise

### Planung eines Features über mehrere Wellen

Maßstab:

- Die *erste* Welle liefert etwas, was sichtbar grün läuft (`make gates` grün, mindestens ein Smoke-Test). Lieber kleiner als zu groß.
- Jede Welle hat einen Closure-Trigger ("wenn X grün und Y dokumentiert → Welle done").
- Wellen sind in *Reihenfolge* abhängig, nicht in *Termin*. Termine ergeben sich, sobald die Wellen geschnitten sind.
- Mindestens ein Slice pro Welle hat einen Verweis auf eine Anforderungs-ID (`LH-*`) — sonst ist die Welle "Wartungsarbeit", die nicht in die Roadmap gehört.

### Bewege einen Slice durch alle vier Verzeichnisse

Vier Commits ist die saubere Variante:

1. Erstelle Slice in `open/`.
2. `git mv open/X.md next/X.md` (Prioritäts-Trigger erfüllt).
3. `git mv next/X.md in-progress/X.md` (Start-Commit, oder Branch-Commit).
4. `git mv in-progress/X.md done/X.md` + Closure-Notiz.

Wichtig: Reine Move-Commits (Git-Rename-Detection braucht 50 %
Similarity, siehe Hard Rule aus grid-gym in [Modul 9](../03-agenten/modul-09-implementierung.md)).
Inhaltliche Edits dazwischen sind eigene Commits.

### Closure-Kriterien mit Lerneintrag formulieren (Erschaffen — LZ 4)

Vorlage: §Closure im
[`slice.template.md`](../../../lab/templates/docs/plan/planning/slice.template.md).
Maßstab für einen guten Closure-Block:

- **(a)** Zwei bis drei Closure-Kriterien, jedes *beobachtbar* — d. h.
  ein Dritter kann es ohne Rückfrage prüfen (ein grünes Make-Target,
  ein verlinkter Test pro DoD-Punkt, ein Replay-Ergebnis). "Fühlt
  sich fertig an", "Code ist sauber" disqualifizieren.
- **(b)** Ein Lerneintrag, der benennt, was der *Harness* gelernt hat
  — zuordenbar zu einer der drei Formen: geschärfte Regel, neuer
  Sensor oder benannte Spec-Lücke. "Tests grün" ist keine der drei
  Formen: das ist der Slice-Zustand, kein Lernen.

Selbsttest für den Lerneintrag: Würde der Eintrag eine *künftige*
Wiederholung verhindern, wenn ihn der nächste Planner liest? Wenn er
nur protokolliert, was passiert ist, fehlt die Steering-Loop-Hälfte.
Eine ausgearbeitete Beispiel-Konstruktion (Kriterien + Lerneintrag
für `SL-014a`) steht oben in der Selbstcheck-Antwort zum
Erschaffen-Item.

### Schneide einen zu großen Slice in zwei umsetzbare Slices

Kriterien für "zu groß":

- Mehr als eine Schicht der Architektur betroffen ohne klare Abstraktion dazwischen.
- DoD enthält "und" mehrfach (statt einer klaren Bedingung).
- Geschätzte Bearbeitungsdauer überschreitet, was ein Reviewer *in einer Sitzung* prüfen kann.

Schnitt-Strategien:

- **Vertikal**: Slice 1 liefert minimalen End-to-End-Pfad; Slice 2 erweitert.
- **Horizontal**: Slice 1 baut die Schicht, Slice 2 verkabelt sie.
- **Read-Write-Split**: Slice 1 nur Lesen, Slice 2 fügt Schreiben hinzu.

### Bestimme und begründe Bootstrap-Modus pro Sub-Area

Bezug: Worked Mini-Example *Bootstrap-Modus pro Sub-Area für einen
Slice begründen* im
[Modul 5](../02-planung/modul-05-planning-harness.md#worked-mini-example-bootstrap-modus-pro-sub-area-für-einen-slice-begründen)
mit Beispiel-Slice `SL-014a`.

**Hybrid-Sub-Area `Audit-Logging` — Mustertext für die zwei vom
Lerner zu ergänzenden Kriterien:**

- *Evidenz-/Diskrepanz-Risiko:* mittel. Die Pflicht-Adaption `MR-008`
  in `harness/conventions.md` sagt *"jeder Login-Versuch muss ein
  Audit-Event erzeugen"*; im Code (`services/audit/`) liegen aber
  zwei unterschiedliche Event-Formate aus früheren Slices (z. B.
  flaches JSON vs. structured-key-value). Inventur kann sichtbar
  machen, dass die Tests nicht gegen ein Schema, sondern gegen das je
  vorgefundene Format prüfen — Drift passiert lautlos, sobald ein
  dritter Slice ein drittes Format einführt.
- *Reconciliation-Aufwand:* ≈ 0.5 Slice. `MR-008` in
  `harness/conventions.md` um konkretes Event-Schema ergänzen
  (Pflicht-Felder, Format-Lock); bestehende
  `services/audit/`-Producer auf das Schema heben (oder als Carveout
  mit Auflösungs-Trigger dokumentieren). Graduation-Trigger:
  **Sync-Trigger** — eine Audit-Sensor-Zeile in `harness/README.md`
  §Sensors, die auf `MR-008` zeigt (Pattern wie Sub-Area 2:
  Konventions-Adaption in `conventions.md` → Pointer in `README.md`).
  Sobald der Sync steht und mindestens ein Test das Schema validiert,
  schaltet `Audit-Logging` von Hybrid Richtung GF.

**Drei Anker für die Bewertung in §8 des Slice-Plans:**

1. *Pro berührte Sub-Area ein Begründungsblock* aus dem Template
   (Konventionen-Dichte · Phase-Reife · Evidenz-/Diskrepanz-Risiko ·
   Reconciliation-Aufwand inkl. Graduation-/Folge-Slice-Trigger). Wer
   nur "Modus: BF, weil Doku fehlt" schreibt, hat das Kriterien-Set
   nicht genutzt — das ist Klassifikation (Modul 2), nicht Begründung.
2. *Bei BF und Hybrid* muss der Reconciliation-Aufwand mit einem
   konkreten Trigger geschlossen werden — entweder eine der vier
   Trigger-Klassen aus
   [`../grundlagen/konventionen.md` §Vier Trigger-Klassen](../grundlagen/konventionen.md#vier-trigger-klassen)
   (Sync, Promotion, Cross-Reference, Acceptance) oder eine
   explizite Folge-Slice-ID. "Werden wir später dokumentieren" ist
   kein Trigger. Die T1–T7-Notation in Modul 2 §Worked Example 1 ist
   eine *Instanziierung* dieser Klassen für den DocSearch-Walkthrough;
   in eigenen Slice-Plänen reicht die Klassen-Bezeichnung plus konkrete
   Bezugs-Doku.
3. *Evidenz benennen* aus Code, Doku oder `harness/conventions.md`.
   Aussagen ohne Evidenz-Anker sind nicht prüfbar und damit nicht
   teil der Übungs­leistung.

**Distractor-Klärung "Wenn der Slice klein ist, ist die berührte
Sub-Area GF.":** Der Beispiel-Slice `SL-014a` ist klein (≤ 3
DoD-Punkte), trotzdem ist die Test-Infrastruktur klar BF und das
Audit-Logging Hybrid. Slice-Größe und Sub-Area-Modus sind orthogonale
Achsen — Slice-Größe ist eine Eigenschaft des Schnitts (kann ein
Reviewer ihn in einer Sitzung prüfen?), Sub-Area-Modus ist eine
Eigenschaft des Reifegrads der berührten Doku-/Code-Sektion. Wer
beim Modus-Begründungsblock auf die DoD-Punkte-Zahl zeigt, hat die
Diagnose vom falschen Träger abgeleitet. Persistente Lernhilfe in
Modul 5 §Typische Fehlvorstellungen; hier ist sie *aktiver Distractor*
im Übungs-Kontext.

## Häufige Fehler

- **`done/` wird zur Mülltonne.** Slices wandern dort hin, weil "halt nicht mehr aktuell". Das ist kein Closure, sondern Verstecken.
- **`open/` enthält Wünsche, die nie umgesetzt werden.** Aufräumen ist Teil von Entropy Management — toter Backlog ist Rauschen.
- **Closure-Notiz fehlt oder ist generisch ("done").** Damit verlierst du den Steering-Loop-Lerneffekt.

## Verweise

- Carveouts: [Modul 7](../02-planung/modul-07-carveouts.md) und [Lösung Modul 7](modul-07-loesung.md)
- Welle-Self-Close-Konvention aus grid-gym: [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
- Vorherige Lösung: [Modul 4](modul-04-loesung.md)
- Nächste Lösung: [Modul 6](modul-06-loesung.md)
