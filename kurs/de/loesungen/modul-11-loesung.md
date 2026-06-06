# Lösung — Modul 11: Verification Harness

Zugehöriges Modul: [Modul 11 — Verification Harness](../04-qualitaet/modul-11-verification.md).

## Selbstcheck-Antworten

### (Erinnern) Welche drei Eingabe-Artefakte braucht ein Verifier minimal — und wodurch unterscheiden sie sich von den Eingaben des Reviewers?

**Verifier-Eingaben:** DoD · Spec · Plan.

**Reviewer-Eingaben:** Plan · ADR · Diff.

Schnittmenge: nur der Plan. Genau das *erzeugt* die unterschiedlichen
Findings — Verifier prüft "Plan↔Code↔DoD↔Spec", Reviewer prüft
"Plan↔Diff↔ADR".

Wer dem Verifier *zusätzlich* den ADR übergibt, macht ihn zum zweiten
Reviewer und verliert die Kontext-Trennung. Wer dem Reviewer *zusätzlich*
die Spec mit DoD übergibt, macht ihn zum vorgezogenen Verifier — auch das
bricht die Rollen-Trennung (siehe [Lösung Modul 8](modul-08-loesung.md)).

Praktische Folge: Verifier braucht eine Datei mit *allen referenzierten
Anforderungs-IDs* und ihren Akzeptanzkriterien wörtlich (nicht nur IDs).
Ohne das vergleicht er gegen leere Container.

### Warum reicht ein grünes Testsuite-Ergebnis nicht als Verifikation?

Tests prüfen *implementierte* Eigenschaften — Verification prüft, ob
*geplante* Eigenschaften implementiert *und* getestet sind. Konkrete
Lücken, die nur Verification fängt:

- **Akzeptanzkriterien ohne Test.** Test-Suite grün, aber LH-FA-3.b ist nie geprüft worden. Verification merkt: kein Test referenziert LH-FA-3.b.
- **Implementierter, aber unspezifizierter Code.** Tests grün, aber der getestete Code setzt eine Anforderung um, die nicht in der Spec steht (Scope-Creep). Verification meldet: Code ohne Anforderungs-Quelle.
- **ADR-Verstoß ohne ArchUnit-Fang.** Tests grün, aber Schichtung verletzt. Verification merkt durch Strukturanalyse, dass ADR-7-Regel keinen `arch-check` hat oder dass der `arch-check` lückenhaft ist.
- **Done ohne Closure-Notiz.** Tests grün, aber Slice landet ohne Lerneintrag in `done/`. Verification meldet: Steering-Loop-Lücke.

Tests sind ein *Sensor*. Verification ist ein *Vergleichsmesser
zwischen Plan und Realisierung* — sie nutzt Tests als Eingabe, ist
aber nicht durch sie ersetzbar.

### Wer löst den Konflikt, wenn Verification rot, Review grün ist?

Klassisches Szenario: Reviewer findet keinen Code-Smell, Verifier
meldet "Akzeptanzkriterium LH-FA-3.b nicht erfüllt". Der Konflikt ist
*scheinbar*: Reviewer und Verifier prüfen unterschiedliche Fragen.

Vorgehen:

1. **Verifier-Befund hat Vorrang**, weil er gegen die *vereinbarte
   Lieferung* misst. Reviewer-Grün bedeutet höchstens "der Code, der
   da ist, ist sauber" — nicht "der Code, der nötig ist, ist da".
2. **Schließe die Lücke** entweder durch Implementierung (häufigster
   Fall) oder durch Spec-Korrektur (wenn die Anforderung im Lichte des
   Builds keinen Sinn mehr macht — dann als Spec-Folge-Slice).
3. **Steering-Loop-Eintrag**: warum hat der Reviewer den Mangel nicht
   gesehen? Skill-Schärfung nötig?

Umgekehrter Fall (Reviewer rot, Verifier grün) ist genauso informativ:
*was* hat der Reviewer gefunden, das nicht in der Spec steht? Wenn es
ein berechtigter Befund ist, fehlt es in der Spec — Spec-Update.

## Übungshinweise

### Automatische Verifikation eines Slices

Mindest-Output eines Verifiers:

- Liste der referenzierten Anforderungs-IDs aus dem Slice-Plan.
- Pro ID: gibt es einen Test, der sie referenziert? Welcher?
- Pro ID: ist mindestens ein Akzeptanzkriterium-Test grün?
- Liste der referenzierten ADRs: gibt es einen `arch-check`, der die ADR-Regel umsetzt?
- Liste der gefundenen "Code ohne Anforderung" — verdächtiger Scope-Creep.

### Provoziere eine DoD-Verletzung

Trigger:

- Lass den Implementer ein Akzeptanzkriterium der DoD weglassen, aber alle Tests grün halten.
- Lass ihn Code für eine *nicht referenzierte* Anforderung hinzufügen.
- Lass ihn die Doku eines öffentlichen Vertrags *nicht* aktualisieren.

Verifier muss alle drei melden. Wenn er nur den ersten findet, fehlen
ihm Code-zu-Spec-Tracerouten — typisch bei ID-Schemas, die nur in der
Spec, aber nicht in Tests verankert sind.

## Häufige Fehler

- **Verification mit Test-Suite verwechseln.** "Wir haben `make test` — wir verifizieren." → Nein, du testest. Verification fragt: stimmen Plan, Code und Test miteinander überein?
- **Verifier hat keinen Zugriff auf die Spec-IDs.** → Er kann nur ein Subset prüfen. ID-Schema mit Cross-Referenzen Spec → Test → Code ist Voraussetzung für sinnvolle Verification.
- **Pre-completion Checklist wird zur reinen Format-Pflicht.** → Checklist muss *spezifische* Items pro Slice enthalten (siehe [Lösung Modul 9](modul-09-loesung.md)).

## Verweise

- Behaviour Harness als Kategorie: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)
- Vorherige Lösung: [Modul 10](modul-10-loesung.md)
- Nächste Lösung: [Modul 12](modul-12-loesung.md)
