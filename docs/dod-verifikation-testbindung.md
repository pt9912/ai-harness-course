# DoD-Verifikation und Test-Bindung — Vorschläge

**Stand:** 2026-09-13 — Vorschläge F und C sind umgesetzt (Welle 135,
`kurs/de/04-qualitaet/modul-11-verification.md` +
`modul-13-quality-gates.md`, Spiegel nachgezogen). A, B, D, E bleiben
unentschieden. Dieses Dokument bleibt als Herleitung stehen — es dient
nicht mehr als offene Diskussionsgrundlage für F/C, sondern als Beleg,
warum genau diese beiden gewählt wurden.

## Ausgangsbeobachtung

Praxis-Rückmeldung aus Repos, die dieses Regelwerk adoptieren: Obwohl DoDs und
ein Verifier-Schritt existieren, wurde nicht immer vollständig implementiert,
was die DoD behauptete. Was in der Praxis den Unterschied gemacht hat, waren
Unit-, Integrations- und besonders End-to-End-Tests.

## Ist-Zustand im Korpus (Belege)

Die Beobachtung trifft eine Lücke, die der Korpus selbst schon benennt, aber
nicht durchsetzt:

- **[Modul 11 §Begriffe](../lab/regelwerk/modul-11-verification.md)** nennt
  *„Behauptung ohne Bestätigung"* als **die häufigste Verifier-Lücke**:
  Verifikation ist primär *inferential feedback* — ein Agent liest Code gegen
  DoD/Spec und urteilt semantisch, ohne Ausführungsbeweis.
- **[Modul 5 §Closure-Regeln](../lab/regelwerk/modul-05-planning-harness.md)**
  kennt den Gegenzug bereits, aber nur als Beispiel: Übergang nach `done/`
  verlangt „zwei beobachtbare Closure-Kriterien (**z. B.** Replay grün,
  DoD-Punkte als Test verlinkt)". Das *z. B.* macht die Test-Bindung optional,
  nicht Pflicht — genau die Stelle, an der die reale Lücke entsteht.
- **[Modul 13 §Gate-Typ ↔ Fehlerbild](../lab/regelwerk/modul-13-quality-gates.md)**
  führt „Integrationstest" als eigenen Gate-Typ, aber keinen eigenen Eintrag
  für Unit- oder E2E-Tests — beide tauchen nur als Beispiel-Targets
  (`test-unit`) in der „Reichhaltigen Gate-Landschaft" auf, nicht als
  definierte Regel-Klasse.

Kurz: Der Korpus weiß, dass Verifikation *inferential* und deshalb fälschbar
ist. Er sagt nur nicht verbindlich, wodurch die Lücke geschlossen wird.

## Audit am Fall — `pg-change-feed`, slice-023

Realer Fall aus dem adoptierenden Repo `pg-change-feed` (ein eigenständiges
Repository neben diesem Kurs-Repo, nicht Teil davon), der genau die
verlangte Form hat: ein Slice, dessen DoD als erfüllt galt, aber erst durch
einen Test als unvollständig auffiel.

**Slice-023** („Rollen-spezifische DSN-Verdrahtung",
`docs/plan/planning/done/slice-023-rollen-spezifische-dsn-verdrahtung.md`)
trägt DoD-Punkt 1: *„… real getestet (z. B. Verbindungsaufbau mit
`cdc_reader`-Rolle scheitert an einem …) … dreimal in Folge grün
(`make test-store`)"* — abgehakt `[x]`, mit Beleg-Link auf drei benannte
Testfälle in `internal/bootstrap/roles_wiring_test.go`. Der Reviewer fand
0 HIGH/0 MEDIUM (`docs/reviews/review-slice-023.md`), kein Merge-Blocker.
Der DoD-Punkt war also nicht nur behauptet, sondern **bereits mit einem
Test verlinkt** — Vorschlag A wäre hier formal erfüllt gewesen.

Der Verifier (`docs/reviews/verify-slice-023.md`) hat trotzdem zwei
MEDIUM-Befunde gefunden, beide durch **eigene Mutationstests**, nicht durch
Lektüre:

- **V-1:** Der verlinkte, grüne Test
  `TestCdcAdminHeartbeatWriteRequiresGrant` entzieht/erteilt beim Setup
  *alle drei* Rechte (`REVOKE`/`GRANT SELECT, INSERT, UPDATE`) — er beweist
  „0 Rechte scheitert" und „3 Rechte gelingt", nie die von `ADR-0048`
  wörtlich benannte Zwischenstufe „`INSERT, UPDATE` ohne `SELECT` scheitert".
  Der Verifier hat das **empirisch nachgewiesen**: den realen DB-Grant von
  Hand auf den alten, fehlerhaften Text zurückgesetzt — der Test blieb
  **grün**. Die DoD-Aussage „real getestet … grün" war wahr und deckte den
  Fehler, den `ADR-0048` beheben sollte, trotzdem nicht ab.
- **V-2:** Die DSN-zu-Rolle-Zuordnung in `wiring.go`s `Run`-Funktion war zum
  Zeitpunkt des ersten Durchgangs ausschließlich durch Code-Lektüre
  gesichert, durch keinen Test. Eine Ein-Zeilen-Mutation (Admin-/
  Capture-DSN vertauscht) lief anfänglich durch, ohne dass ein Test
  anschlug.
- Zusätzlich eine **benannte, aber nirgends closure-sichtbare Lücke**: Der
  Replication-Stream-/ACK-Adapter-Pfad bleibt bis heute ungetestet gegen
  Rollen-Vertauschung, weil `run-replication-tests.sh` keine
  rollenbeschränkten Login-Identitäten bereitstellt. Die Lücke stand nur in
  einem Code-Kommentar und einer Commit-Message — nicht im Slice-Plan
  selbst. Der Verifier hat das ausdrücklich benannt: *„ohne ihn
  verschwindet die Lücke mit der Slice-Archivierung."*

Ergebnis: neuer Beobachtungs-Register-Eintrag
`BEO-PGC/rollen-test-abdeckungsluecken`, Zustand zum Zeitpunkt dieses Audits
**weiter offen** — in diesem realen Repo bis heute ungelöst.

**Warum das die Vorschläge oben schärft, statt sie nur zu bestätigen:**
Vorschlag A („DoD-Punkt braucht einen verlinkten Test") hätte diesen Fall
**nicht** gefangen — der Test war bereits verlinkt, benannt und grün. Die
Lücke lag nicht in *Test ja/nein*, sondern darin, dass ein grüner,
verlinkter Test selbst eine unbestätigte Behauptung sein kann, wenn niemand
gezeigt hat, dass er ohne den Fix rot liefe. Genau diese Prüfung — **zeigen,
dass die Regel aus dem richtigen Grund rot wird** — kennt der Korpus bereits,
aber nur für ADR-Fitness-Functions
([Modul 13 §Fitness Function aus einem ADR-Satz](../lab/regelwerk/modul-13-quality-gates.md#adr-zur-fitness-function),
Schritt „Bewusstes Brechen"). Der Verifier hat sie hier aus eigener
Sorgfalt auf eine DoD-Testbehauptung angewandt — keine Regel hat das
verlangt.

## Vorschläge

Die Vorschläge sind unabhängig voneinander entscheidbar — keiner setzt einen
anderen voraus, mit Ausnahme der Anmerkung bei D.

### Vorschlag A — DoD-Punkt-Test-Pflicht (Modul 5 schärfen)

Aus dem Beispiel „DoD-Punkte als Test verlinkt" wird eine Pflicht für jeden
DoD-Punkt, der ein **beobachtbares Verhalten** behauptet: Closure nach `done/`
verlangt einen verlinkten Test (Unit, Integration oder E2E — Wahl nach
Fehlerbild, siehe Modul 13). DoD-Punkte ohne beobachtbares Verhalten (reine
Doku-Punkte, Namensänderungen) bleiben ausgenommen — dafür bietet Modul 11
bereits den Weg über eine selbstgebaute Fitness Function.

- **Kette:** `kurs/de/02-planung/modul-05-planning-harness.md` §Closure- und
  Lerneintrag-Regeln → Spiegel `lab/regelwerk/modul-05-planning-harness.md` →
  ggf. `lab/templates/docs/plan/planning/slice.template.md` (DoD-Feld) →
  `lab/example` (falls ein Slice dort dem neuen Kriterium widerspricht).
- **Trade-off:** Größter Eingriff der fünf Vorschläge — macht eine bisher
  weiche Empfehlung zur Pflicht. Risiko: Slices mit schwer testbaren
  DoD-Punkten (Prosa-Qualität, Architektur-Entscheidung ohne Fitness Function)
  brauchen einen sauberen Ausnahmepfad, sonst wird die Pflicht zur Fiktion,
  die keiner einhält (dieselbe Falle wie ein „behauptetes Gate", Modul 13
  §Hard Rule Doku-Disziplin).

### Vorschlag B — Verifier-Regel: Test vor Inferenz (Modul 11 ergänzen)

Ergänzung in Modul 11: Ist ein DoD-Punkt testbar, schließt ein Test (Unit,
Integration, E2E) die Verifier-Lücke **bevorzugt vor** einer zusätzlichen
inferentiellen Prüfung. Die inferentielle Verifikation bleibt Fallback für
Aussagen, die kein Standard-Tool prüfen kann — genau die Kosten-Tabelle, die
Modul 11 §Fitness Function ohne Standard-Tool schon führt (Pre-commit-Hook →
Make-Target → Doku-Konsistenz-Agent, aufsteigend nach Kosten). Ein Test wäre
darin explizit die günstigste, bevorzugte Stufe *vor* dieser Tabelle, nicht
eine vierte Stufe daneben.

- **Kette:** `kurs/de/04-qualitaet/modul-11-verification.md` §Regeln gegen
  typische Fehlannahmen (Zeile zu „Tests prüfen … Verifikation prüft …") →
  Spiegel `lab/regelwerk/modul-11-verification.md`.
- **Trade-off:** Kleinster Eingriff — schärft nur eine bestehende Regel, ohne
  neue Struktur oder Pflicht. Wirkung hängt daran, dass Verifier-Agenten die
  Regel tatsächlich anwenden (inferential feedforward, keine maschinelle
  Durchsetzung) — schwächer als A, aber ohne dessen Rigiditätsrisiko.

### Vorschlag C — E2E als eigener Gate-Typ (Modul 13 Tabelle erweitern)

Neue Zeile in der Gate-Typ-↔-Fehlerbild-Tabelle:

| Gate-Typ | typisches Fehlerbild | was er NICHT fängt |
| --- | --- | --- |
| E2E-Test | Vertragsbruch über den vollen Pfad (Wiring, Deployment-Annahmen, Cross-Komponenten-Reihenfolge) — bricht erst, wenn alle Teile *zusammen und in echter Konfiguration* laufen | lokale Muster, einzelne Komponentengrenzen (das leistet der günstigere Integrationstest) |

Schließt eine Definitionslücke unabhängig von der DoD-Frage: Aktuell steht
„Integrationstest" für „Verhalten im Zusammenspiel" — ohne Abgrenzung zu E2E
wäre eine neue Zeile eine Dopplung. Die Abgrenzung selbst (Integrationstest
= zwei/drei Komponenten in Isolation, E2E = kompletter Pfad in echter oder
repräsentativer Umgebung) muss explizit mitgeliefert werden, sonst entsteht
genau die Zwei-Zeilen-für-dieselbe-Sache-Falle.

- **Kette:** `kurs/de/04-qualitaet/modul-13-quality-gates.md` §Gate-Typ ↔
  Fehlerbild → Spiegel `lab/regelwerk/modul-13-quality-gates.md`.
- **Trade-off:** Rein additiv, kein Konflikt mit bestehender Prosa. Wirkung
  ist Begriffsschärfe, nicht automatisch mehr Testbindung — löst für sich
  allein nicht die DoD-Verletzung, ergänzt aber A/B um ein klares Vokabular,
  *welcher* Test wann greift.

### Vorschlag D — Closure-Trace-Kriterium (Modul 5 + Modul 15 verzahnen)

Modul 15 kennt bereits das Konzept „End-to-End-Trace bis LH-ID" — bisher nur
für Observability/Nachvollziehbarkeit im Betrieb. Vorschlag: dasselbe Konzept
als Closure-Bedingung wiederverwenden — ein Slice mit beobachtbarem Verhalten
braucht vor `done/` einen Trace oder Test, der den vollen Pfad von
Anforderung (LH-ID) bis Ergebnis abdeckt.

- **Kette:** `kurs/de/02-planung/modul-05-planning-harness.md` (Closure) +
  Querverweis auf `kurs/de/05-betrieb/modul-15-observability.md` §End-to-End-
  Trace → beide Spiegel.
- **Abhängigkeit:** Baut auf demselben Mechanismus wie A (Closure-Kriterium
  schärfen) auf — würde faktisch A mit der E2E-Ebene aus C verzahnen. Kein
  eigenständiger Vorschlag, wenn A verworfen wird.
- **Trade-off:** Stärkste inhaltliche Kohärenz (ein Konzept, zwei Konsumenten
  — Betrieb und Closure), aber auch das größte Risiko einer Modul-Kopplung,
  die bei einer Änderung an Modul 15 unbeabsichtigt Modul 5 mitzieht.

### Vorschlag E — nur die Formulierung schärfen (leichtgewichtig)

Kleinste Änderung: in Modul 5 den Closure-Satz „DoD-Punkte als Test verlinkt"
aus der Klammer („z. B. …") lösen und als eigenständigen, empfohlenen
Bulletpoint mit Begründung ausformulieren — **ohne** ihn zur Pflicht zu
machen (Unterschied zu A).

- **Kette:** wie A, aber ohne Pflicht-Formulierung.
- **Trade-off:** Geringstes Risiko, geringste Wirkung. Löst die reale Lücke
  aus der Beobachtung wahrscheinlich nicht — eine Empfehlung ohne Sensor ist
  nach Modul 13s eigener Regel „dann ist es kein Gate, sondern ein Vorschlag".

### Vorschlag F — Bewusstes-Brechen-Pflicht für DoD-Testbehauptungen (Modul 11 + Modul 13 verzahnen)

Aus dem Audit: Ergänzung in Modul 11, dass ein DoD-Punkt der Form „real
getestet" erst als bestätigt gilt, wenn zusätzlich zum grünen, verlinkten
Test ein **Rot-Beleg** vorliegt — derselbe Schritt, den Modul 13 §Fitness
Function aus einem ADR-Satz für ADR-Aussagen bereits verlangt: den Fix
gedanklich oder real zurücknehmen und zeigen, dass der Test dann aus dem
richtigen Grund fehlschlägt. Ist das für einen DoD-Punkt zu teuer (z. B.
bei einem bereits bestehenden, nicht slice-eigenen Test), trägt der
Verifier-Report die Prüfung nach — genau die Rolle, die `verify-slice-023.md`
in diesem Fall schon gespielt hat, nur ohne dass eine Regel es verlangte.

- **Kette:** `kurs/de/04-qualitaet/modul-11-verification.md` (neuer Punkt
  unter §Regeln gegen typische Fehlannahmen oder als eigener Absatz,
  Querverweis auf Modul 13 §Fitness Function aus einem ADR-Satz) → Spiegel
  `lab/regelwerk/modul-11-verification.md`.
- **Trade-off:** Wiederverwendet einen bereits etablierten, bewährten
  Mechanismus (kein neues Vokabular) statt eine neue Pflicht-Kategorie zu
  erfinden — direkteste Antwort auf den Audit-Befund V-1. Kosten liegen im
  Verifier-Aufwand (ein Mutationstest pro sicherheits-/korrektheitskritischem
  DoD-Punkt), nicht in neuer Prozess-Bürokratie.

## Einordnung

Der Fall aus `pg-change-feed` widerlegt die naive Form von Vorschlag A: Der
DoD-Punkt trug bereits einen verlinkten, grünen, namentlich benannten Test —
die reale Lücke (V-1) bestand trotzdem, weil niemand geprüft hatte, ob dieser
Test aus dem *richtigen* Grund grün ist. „Ein Test ist verlinkt" ist selbst
eine Behauptung, die Bestätigung braucht — dieselbe Verifier-Lücke aus Modul
11, nur eine Ebene tiefer als ursprünglich gedacht. **A allein wäre am
gemessenen Fall wirkungslos gewesen.**

Was am Fall tatsächlich gegriffen hat, ist der Mechanismus hinter
**Vorschlag F**: das „Bewusstes Brechen" aus Modul 13, angewandt auf eine
DoD-Testbehauptung statt nur auf eine ADR-Fitness-Function. Der zweite reale
Befund (die bis heute offene Replication-/ACK-Adapter-Lücke) stützt zusätzlich
**Vorschlag C**: Ohne benannten E2E-Gate-Typ fehlt das Vokabular, um zu sagen,
*welche* Testebene diese Lücke schließen müsste — aktuell steht sie nur als
Kommentar im Code, nicht als benannte Anforderung. Und dieselbe Lücke belegt
den Kern von **Vorschlag D**: Der Verifier musste explizit fordern, dass die
Lücke in den Slice-Plan selbst wandert, *„sonst verschwindet sie mit der
Slice-Archivierung"* — eine Closure-Sichtbarkeitsregel hätte das erzwungen,
statt es der Sorgfalt des Verifiers zu überlassen.

**Revidierte Empfehlung:** F + C als Paar — F schließt die im Audit
tatsächlich gefundene Lücke (grüner Test ohne Rot-Beleg), C liefert das
Vokabular für die noch offene zweite Lücke (fehlender E2E-Test für den
Replication-Pfad). B bleibt sinnvoll, aber schwächer, da der Fall zeigt, dass
selbst eine vorhandene Test-Ebene die Lücke nicht automatisch schließt — die
Prüftiefe zählt, nicht nur *Test statt Inferenz*. A wird durch den Fall
entkräftet, es sei denn es wird um die Rot-Beleg-Pflicht aus F ergänzt (dann
deckt es sich mit F). D bleibt tragfähig, hängt aber jetzt eher an C
(*welche* Testebene) als an A. E bleibt die risikoärmste, wirkungsschwächste
Option.

## Umsetzung

F + C sind umgesetzt als Welle 135
(`kurs/de/04-qualitaet/modul-11-verification.md` §Bewusstes Brechen für
DoD-Testbehauptungen + neue Fehlvorstellung; `modul-13-quality-gates.md`
neue Zeile „E2E-Test" in der Gate-Typ-↔-Fehlerbild-Tabelle), Spiegel
wortgleich nachgezogen. Rangfolge nach `AGENTS.md` §1 eingehalten:
`kurs/de` zuerst, `lab/regelwerk` danach; `lab/templates`/`lab/example`
nicht berührt, da keiner der beiden Vorschläge dort etwas ändert.

## Offene Fragen

- B optional ergänzen — A/D nur, falls F allein als zu schwach empfunden
  wird (z. B. weil Verifier-Agenten das Bewusste-Brechen ohne
  Pflicht-Formulierung überspringen)?
- Modul 5s Closure-Beispiel „DoD-Punkte als Test verlinkt" braucht einen
  Verweis auf Modul 11s neue Regel, sonst widerspricht ein isoliertes
  Lesen von Modul 5 der neuen Fehlvorstellung in Modul 11 — im selben
  Zug wie F ergänzt (siehe CHANGELOG Welle 135).
