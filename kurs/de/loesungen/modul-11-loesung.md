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

### (Erinnern) Drei Fragen-Klassen: Review, Verifikation, Validation

- **Review:** "Ist der Diff *riskant*?" — geprüft gegen Plan/ADR
  (Maintainability, Konventionen).
- **Verifikation:** "*Erfüllt* der Diff Plan und DoD?" — geprüft gegen
  DoD/Spec ("Bauen wir es richtig?").
- **Validation:** "*Trifft* das Ergebnis den realen Bedarf?" — geprüft
  gegen Nutzer/Markt ("Bauen wir das Richtige?").

Pointe: jede Klasse hat *eigene* Eingaben (siehe vorige Frage) und
*eigene* Findings. Keine darf eine andere "mit erledigen" — sonst
wiederholen sich blinde Flecken, und genau dagegen ist die
Rollen-Trennung aus Modul 8 gebaut.

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

### (Analysieren — aktiviert LZ 2) Drei Fundstücke: DoD-Verletzung oder Review-Finding?

| Fundstück | Klasse | Begründung über das Prüf-Artefakt |
|---|---|---|
| **A** — Coverage-Gate auf dem kritischen Pfad rot, obwohl die DoD "Gates grün" verlangt | **DoD-Verletzung** | Der DoD-Punkt "Gates grün" ist nicht erfüllt. Die Rolle, die das fängt, prüft gegen *DoD/Spec* — das ist der Verifier. |
| **B** — eine Funktion liest *und* schreibt den Index in einem Schritt; unschön, aber kein DoD-Punkt nennt es | **Review-Finding** | Maintainability-Beobachtung am Diff ohne DoD-/Plan-Bezug. Die Rolle, die das fängt, prüft gegen *Plan/ADR/Konventionen* — das ist der Reviewer (Kategorie je nach Skill, typisch MEDIUM). |
| **C** — Plan nennt `/export`, Code liefert `/download` | **DoD-/Plan-Verletzung** | Plan-gegen-Code-Differenz: genau die Frage "wurde umgesetzt, was geplant war?", die *nur* die Verifikation stellt. |

Das Abgrenzungs-Kriterium ist nicht die *Schwere* des Fundstücks,
sondern das *Prüf-Artefakt*: DoD/Spec/Plan → Verifier; Plan/ADR/Diff →
Reviewer. B könnte schwerer wiegen als A und bleibt trotzdem ein
Review-Finding.

Pointe zu C: Ein Reviewer mit veraltetem Plan übersieht die Differenz
*strukturell* — er prüft den Diff gegen das, was er als Plan kennt.
Deshalb ist die Plan-gegen-Code-Differenz eine eigene Klasse, die nur
die Verifikation fängt (siehe Modul 11 §Vorgriff, "DoD-Verletzung").

### (Bewerten — aktiviert LZ 4) Pre-completion-Bericht "Tests grün, Feature läuft. Restrisiken: minimal." bewerten

Der Bericht wird gegen *Plan/DoD* geprüft, nicht gegen sich selbst —
und fällt durch:

- **"Tests grün"** deckt den von der DoD verlangten **Negativtest für
  den neuen öffentlichen Vertrag** nicht: die Aussage nennt weder
  Targets noch Files, also ist nicht belegbar, *welche* Tests grün
  sind. Konkrete DoD-Lücke 1.
- **"Feature läuft"** deckt den verlangten **Closure-Note-Eintrag**
  nicht — der ist kein Laufzeit-Verhalten, sondern ein Artefakt, und
  er fehlt. Konkrete DoD-Lücke 2.
- **"Restrisiken: minimal"** ist eine Selbstabsolution-Floskel: sie
  prüft den Bericht gegen das eigene Gefühl statt gegen die DoD. Ein
  Schritt-8-Bericht verlangt *benannte* Sensors und *konkrete*
  Restrisiken (vgl. Worked Example Modul 9: Folge-Slice-Vorschlag,
  Reflexionsanker).

Anschluss: Diese Lücken kategorisiert der *Verifier* als HIGH/MEDIUM-
Findings — nicht der Bericht selbst. Eine Behauptung der Checkliste,
die die Verifikation nicht maschinell oder semantisch bestätigen kann,
ist die häufigste Verifier-Lücke (Modul 11 §Vorgriff). Anti-Antwort:
"Klingt ok, läuft ja" — das übernimmt die Selbstabsolution des Agenten
ungeprüft.

### Wer löst den Konflikt, wenn Verification rot, Review grün ist?

Klassisches Szenario: Reviewer findet keinen Code-Smell, Verifier
meldet "Akzeptanzkriterium LH-FA-3.b nicht erfüllt". Der Konflikt ist
*scheinbar*: Reviewer und Verifier prüfen unterschiedliche Fragen.

Vorgehen:

1. **Der Architect entscheidet prozessual** — *nicht* "wir nehmen das
   mildere Ergebnis" (vgl. [Modul 11 §Fehlvorstellungen](../04-qualitaet/modul-11-verification.md)).
   Inhaltlich kommt er dabei typischerweise zum Schluss: der
   **Verifier-Befund hat Vorrang**, weil er gegen die *vereinbarte
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

### (Bewerten — aktiviert LZ 1) Plan-gegen-Code prüfen und das Ergebnis interpretieren

Erster Teil — Verletzung provozieren. Bewährte Trigger:

- Lass den Implementer ein Akzeptanzkriterium der DoD weglassen, aber alle Tests grün halten.
- Lass ihn Code für eine *nicht referenzierte* Anforderung hinzufügen.
- Lass ihn die Doku eines öffentlichen Vertrags *nicht* aktualisieren.

Verifier muss alle drei melden. Wenn er nur den ersten findet, fehlen
ihm Code-zu-Spec-Tracerouten — typisch bei ID-Schemas, die nur in der
Spec, aber nicht in Tests verankert sind.

Zweiter Teil — und das ist die eigentliche Bewertungsleistung: die
Rötung ist nur das *Signal*; interpretiert wird sie gegen Plan/DoD.
Drei mögliche Ursachen, mit Erkennungszeichen:

| Ursache | Woran erkennbar | Konsequenz |
|---|---|---|
| **Echte DoD-Lücke** | Ein DoD-Punkt hat keinen Beleg (kein Test referenziert das Kriterium), und der Punkt ist fachlich weiterhin gewollt | Implementierung nachziehen; Slice bleibt offen bzw. Re-Open |
| **Zu eng formulierter Plan** | Der Code ist fachlich richtig, aber der Plan beschreibt einen Spezialfall wörtlicher, als die Spec es verlangt (Plan ≠ Spec) | Plan-Korrektur mit Begründung — *nicht* den Code an einen falschen Plan anpassen |
| **Scope-Creep im Diff** | Der Diff enthält Code ohne Anforderungs-Quelle ("Code ohne Anforderung" in der Verifier-Liste) | Code entfernen oder als neue Anforderung/Folge-Slice legitimieren |

Häufiger Übungsfehler: jede Rötung reflexhaft als "DoD-Lücke" lesen
und nachimplementieren. Wer Scope-Creep nachimplementiert "legalisiert",
belohnt ungeplanten Code; wer einen zu engen Plan per Code erfüllt,
zementiert den Plan-Fehler. Die Zuordnung kommt vor der Aktion.

### Eigene ADR übersetzen (aktiviert LZ 3 — Erschaffen)

Wähle eine ADR, deren Aussage *kein* Standard-Tool 1:1 abbildet, und
durchlaufe die sieben Schritte des Worked Example. Ergebnis: ein neues
`verify-*`-Make-Target mit ID-Kommentar.

Beispiel-Konstruktion (andere ADR als im Worked Example, damit der
Transfer sichtbar wird) — ADR-0015: *"Jede öffentliche API-Route muss
in `spec/lastenheft.md` eine LH-ID referenzieren; Routen ohne
Spec-Anker sind verboten."* Kein Linter kennt diese Regel.

1. **Operationalisierung:** Für jede Route-Registrierung im Code
   (`@app.route(...)` bzw. Router-Tabelle) gilt: im selben Modul steht
   ein Kommentar `# LH-FA-...`, und die ID existiert wörtlich in
   `spec/lastenheft.md`. Routen in `internal/`-Modulen sind ausgenommen.
2. **Sensor-Schicht:** Make-Target im `verify`-Block (Standardweg —
   CI soll prüfen); semantische Restfrage ("deckt die LH-ID die Route
   *inhaltlich*?") optional an den Doku-Konsistenz-Agenten.
3. **Skript:** ~20 Zeilen Python — Routen per Regex/AST sammeln,
   LH-IDs im Modul greppen, gegen die Spec-Datei abgleichen; drei
   Fehlertypen (Route ohne ID · ID ohne Spec-Eintrag · Floskel-ID).
4. **Gate verdrahten:** `verify-route-spec-anker: ## ADR-0015 — Spec-Anker-Pflicht`
   plus `verify: verify-route-spec-anker`. ID-Kommentar nennt die ADR.
5. **Inferentielle Schicht:** Skill-Anker für den Doku-Konsistenz-Agenten:
   "Markiere Routen, deren LH-ID zwar existiert, aber inhaltlich
   eine andere Funktion beschreibt — HIGH-Finding."
6. **Bewusstes Brechen:** eine Route ohne LH-Kommentar einchecken →
   Target muss rot werden, mit Datei und Routen-Pfad in der Meldung.
7. **Pre-completion-Bezug:** AGENTS.md-Eintrag "Vor PR-Open:
   `make verify-route-spec-anker` grün" — damit liegt die Regel in
   zwei Quadranten (inferential feedforward + computational feedback).

Begründung der Konstruktion: Die Erschaffens-Leistung steckt in
Schritt 1 — die ADR sagt *was*, die Operationalisierung sagt *prüfbar
was* (inklusive der Ausnahme-Grenze `internal/`). Wer Schritt 1
überspringt und direkt skriptet, baut ein Gate, dessen Grenzfälle
niemand entschieden hat — und das beim ersten False Positive gelockert
wird. Maßstab: Das Target trägt die ADR-ID im Kommentar, läuft im
`verify`-Block (DoD-/Spec-Frage, nicht `make gates`-Architektur-Frage)
und wurde einmal bewusst gebrochen.

### (Bewerten — aktiviert LZ 4) Pre-completion Checklist eines fremden Agentenlaufs bewerten

Verglichen werden der Schritt-8-Bericht aus dem Worked Example in
Modul 9 (Bericht A) und ein weichgespülter Vergleichs-Bericht wie
*"Tests grün, läuft. Restrisiken: minimal."* (Bericht B), entlang der
vier Kriterien der Übung:

| Kriterium | Bericht A (Modul 9) | Bericht B (weichgespült) |
|---|---|---|
| Sensors konkret benannt | ja — `make test` (3 neue Tests), `make gates` inkl. `arch-check` | nein — "Tests grün" ohne Target, ohne Files |
| Restrisiken handlungsorientiert | ja — Refresh-Token-Flow offen, Folge-Slice SL-014b vorgeschlagen, Audit-Rotation als DoD-Hinweis | nein — "minimal" ist ein Urteil ohne Gegenstand |
| Selbstabsolution-Indikatoren | keine | drei: "grün" (unbelegt), "läuft", "minimal" |
| Verifier-Anschlussfähigkeit | ja — jede Behauptung ist maschinell (`make gates` re-run) oder semantisch (Folge-Slice existiert?) prüfbar | nein — keine Behauptung ist nachprüfbar formuliert |

Drei konkrete Lücken des schwächeren Berichts, wie ein Verifier-Skill
sie kategorisieren würde:

1. **Kein benannter Sensor** (welches Target, welche Files?) —
   **HIGH**: "Erfolgsmeldung ohne Gate-Ausführungs-Beleg" verstößt
   gegen Schritt 8 des Workflows; die Verifikation kann nichts
   bestätigen, also gilt nichts als belegt.
2. **Restrisiken nicht handlungsorientiert** — **MEDIUM**: "minimal"
   erzeugt weder Folge-Slice noch Reflexionsanker; das Risiko wird
   unbenannt in die nächste Rolle verlagert.
3. **Selbstabsolution statt DoD-Bezug** — **MEDIUM**: kein einziges
   DoD-Item ist referenziert; der Bericht ist eine Pflichtformel
   (Kabuki, vgl. Lösung Modul 9) und in jedem Lauf identisch
   wiederverwendbar — genau das Gegenteil einer Selbstprüfung.

## Häufige Fehler

- **Verification mit Test-Suite verwechseln.** "Wir haben `make test` — wir verifizieren." → Nein, du testest. Verification fragt: stimmen Plan, Code und Test miteinander überein?
- **Verifier hat keinen Zugriff auf die Spec-IDs.** → Er kann nur ein Subset prüfen. ID-Schema mit Cross-Referenzen Spec → Test → Code ist Voraussetzung für sinnvolle Verification.
- **Pre-completion Checklist wird zur reinen Format-Pflicht.** → Checklist muss *spezifische* Items pro Slice enthalten (siehe [Lösung Modul 9](modul-09-loesung.md)).

## Verweise

- Behaviour Harness als Kategorie: [`../grundlagen/klassifikation.md`](../grundlagen/klassifikation.md)
- Vorherige Lösung: [Modul 10](modul-10-loesung.md)
- Nächste Lösung: [Modul 12](modul-12-loesung.md)
