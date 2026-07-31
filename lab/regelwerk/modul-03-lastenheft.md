## Modul 3 — Lastenheft und Spezifikation

<!-- Quelle: [01-spec-und-architektur/modul-03-lastenheft.md](../../kurs/de/01-spec-und-architektur/modul-03-lastenheft.md) -->

### Harness-Einordnung (Modul 3)

Spec = *inferential feedforward* (siehe
[`grundlagen/klassifikation.md`](grundlagen-klassifikation.md)).
Sie ist die billigste Kontrolle: Was die Spec sauber ausschließt, kommt
im Review nicht mehr vor.

### Kernidee (Modul 3)

Ein Agent ist ein extrem buchstabengetreuer Praktikant. Was nicht in der
Spec steht, existiert für ihn nicht — Lopopolos Maxime: *"Was der Agent
nicht im Kontext erreicht, existiert für ihn nicht."* Was zweideutig in der Spec
steht, wird auf die für dich ungünstigste Weise interpretiert.

**Grenze der Metapher.** Die Praktikant-Metapher trägt nur die
*Buchstabentreue*. Anders als ein echter Praktikant **vergisst** der
Agent zwischen den Aufgaben — was nicht im Kontext steht, war für ihn
nie da (siehe Glossar in
[`grundlagen/konventionen.md#kernbegriffe`](grundlagen-konventionen.md#kernbegriffe):
LLM ist *stateless*). Wer die Metapher zu weit treibt, erwartet
"Mitlernen" — und plant Reviews, als würden sie *einmal* erklärt
ausreichen. Sie reichen nicht. Jeder Lauf beginnt bei Null.

### Regeln gegen typische Fehlannahmen (Modul 3)

- Happy Path widerlegt nur die These "es funktioniert gar nicht". Boundary und Negative widerlegen die stillen Annahmen, *die ein Agent am liebsten als selbstverständlich behandelt*.
- Im Gegenteil: ein Satz "das System *darf nicht* …" spart später drei Reviews. Negativ ist genauso präzise wie positiv.
- Nein, Performance gehört in den nichtfunktionalen Block der Spec (oder in `spec/spezifikation.md`, wenn stratifiziert). Der ADR begründet, *wie* man die Schwelle einhält.
- Was nicht explizit ausgeschlossen ist, baut der Agent plausibel mit. Das ist die häufigste Quelle für "wir hatten das nie gefordert"-PRs.
- Falsch. Lopopolos Maxime *"Was der Agent nicht im Kontext erreicht, existiert für ihn nicht"* ist ein Plädoyer *für* Kontext-Verfügbarkeit — und sagt damit, dass Spec und Prompt *unterschiedliche* Lebenszyklen haben: Spec wird *gepflegt* (Versions-Geschichte, Bezüge, Audit), Prompt wird *für einen Lauf zusammengestellt*. Was im Prompt steht, aber nicht in der Spec, gilt nur für *diesen* Lauf — der nächste Agent sieht es nicht. Das Muster (Spec sagte *speichert*, Agent baute PostgreSQL) wäre mit einem Mega-Prompt nicht besser geworden — der Prompt würde im nächsten Lauf vergessen.

### Ziel-Form: Akzeptanzkriterium

Anforderungen leben im Lastenheft
([`templates/spec/lastenheft.template.md`](../templates/spec/lastenheft.template.md)).
Ein funktionales Kriterium trägt eine `<PREFIX>-FA-NNN`-ID und dann drei Pfade
im Given/When/Then-Stil — **Happy · Boundary · Negative** — plus einen
**Out-of-Scope**-Block. Vagen Satz zuerst auf Mehrdeutigkeiten prüfen (*was
genau · welche Felder · welcher Speicherort*), bevor die Pfade formuliert
werden; das Negative (`darf nicht …`) spart die spätere Review.

Das Lastenheft ist die **Decke** der Straten-Ordnung: Es referenziert nur
innerhalb der eigenen `LH-*`-Reihe — keine ADRs, Slices, Carveouts, Wellen,
und auch nicht `spezifikation.md` oder `architecture.md`
([`konventionen.md` §Referenz-Richtung (SDP)](grundlagen-konventionen.md#referenz-richtung-sdp-wer-darf-wen-referenzieren);
die Vertrags-Zeile der Matrix trägt in jeder fremden Spalte ein ❌ **ohne**
Kontext-Ausnahme, anders als jede andere Zeile).

**Das gilt in jedem Abschnitt, auch in der Historie.** Für die übrigen Straten
ist die Provenance-Sektion ausgenommen, weil ihr Änderungs-Prozess einen
Urheber im Repo hat; der Vertrag hat keinen. Wer eine Anforderung mit einer
ADR begründet, hat die Entscheidung zur Anforderung gemacht — und wer den
auslösenden Slice in der Historie nennt, tut dasselbe eine Zeile später.

Der Anlass geht damit nicht verloren, er liegt nur am richtigen Ende: Die ADR
deklariert ihre Wirkung aufwärts in `Schärft:`, der Slice hält sie in seiner
Closure-Notiz. Das Lastenheft sagt, **was** zugesagt ist — nicht, wer es
bemerkt hat.

### Ziel-Form: Spezifikation

Technische Festlegungen leben in der Spezifikation
([`templates/spec/spezifikation.template.md`](../templates/spec/spezifikation.template.md)):
Algorithmen und Datenflüsse · Datenstrukturen und Schemas · Defaults und
Konstanten · Fehler-Codes und Logging-Felder · Metriken und Tracing-Felder ·
externe Verträge · Historie. Operative Regeln:

* **Fortschreibbar** — kein Change Request nötig; eine ADR darf die
  Spezifikation schärfen, das Lastenheft nicht
  ([`konventionen.md` §Spec-Stratifizierung](grundlagen-konventionen.md#spec-stratifizierung)).
* **Präzisieren, nie erweitern** — Konfliktregel *Lastenheft › Spezifikation ›
  Architektur*.
* **Optional** — nur Vertrag und Sicht sind obligatorisch. Ohne Technik-Stratum
  fällt es aus der Kette; die Rang-Ordnung bleibt dieselbe.
* **Kein ADR-Rückzeiger als Begründung** — die Spezifikation steht im
  Stabilitäts-Rang über der ADR (*Vertrag › Technik › Sicht › ADR › Slice*),
  normativ zeigen Referenzen nur aufwärts
  ([`konventionen.md` §Referenz-Richtung (SDP)](grundlagen-konventionen.md#referenz-richtung-sdp-wer-darf-wen-referenzieren)).
  Welche ADR einen Wert festlegt, deklariert **die ADR** in ihrem
  `Schärft:`-Feld. Die ADR-Spalte der Historie bleibt erlaubt — nicht weil
  Provenance harmlos wäre, sondern weil die ADR-Schärfung **der**
  Änderungs-Prozess dieses Stratums ist und die ADR damit der legitime
  Urheber. Ein Stratum ohne Urheber im Repo — das Lastenheft, dessen Prozess
  der externe Change Request ist — trägt auch keinen in seiner Historie.

### Spec-Stratifizierung — Drei Schichten (Modul 3)

Reifere Specs zerfallen in drei Schichten mit eigener Precedence:
`lastenheft.md` (vertragliches *Was*) › `spezifikation.md` (präzisiertes
*Wie genau*) › `architektur.md` (strukturelles *Wodurch*). Konfliktregel:
**Lastenheft sticht Spezifikation sticht Architektur** — die untere
Schicht darf *präzisieren*, nie *erweitern*. Vollform (Straten-Klassen,
Referenz-Richtung, `check-references`-Gate) in
[`konventionen.md` §Spec-Stratifizierung](grundlagen-konventionen.md#spec-stratifizierung).
Vorlagen: [`spec/`-Templates](../templates/spec/).

