# Lösung — Modul 3: Lastenheft und Spezifikation

Zugehöriges Modul: [Modul 3 — Lastenheft und Spezifikation](../01-spec-und-architektur/modul-03-lastenheft.md).

## Selbstcheck-Antworten

### (Erinnern) Welche drei Akzeptanzkriterien-Arten muss ein vollständiger `LH-FA-*`-Eintrag tragen?

Happy Path, Boundary, Negative — alle drei im Given/When/Then-Stil.
Plus eine *explizite* Out-of-Scope-Liste pro Anforderung.

Die Out-of-Scope-Liste ist kein optionaler Anhang, sondern Teil des
Akzeptanzkriteriums. Sie verhindert plausibel-Anbau: was nicht explizit
ausgeschlossen ist, baut der Agent mit. Out-of-Scope ist *die* Klammer
gegen "wir hatten das nie gefordert"-PRs.

Falle: drei *Test-Fälle* zu liefern (drei Happy-Path-Varianten) ist
nicht das gleiche wie drei *Test-Arten*. Die Arten sind orthogonal — sie
prüfen drei *verschiedene Klassen von Annahmen*, nicht drei verschiedene
Eingabewerte derselben Klasse.

### Welche drei Tests würden ein Akzeptanzkriterium falsifizieren?

Ein Akzeptanzkriterium ist gut, wenn man es mit drei *unterschiedlichen
Testarten* angreifen kann. "Falsifizieren" heißt hier: das Kriterium
würde rot werden, wenn die Implementierung naiv wäre.

1. **Happy Path** — falsifiziert die These "es funktioniert nicht überhaupt": Eingabe entspricht der Spec, Ergebnis entspricht der Erwartung.
2. **Boundary** — falsifiziert die These "es funktioniert nur weit weg vom Rand": Eingabe liegt am Rand des spezifizierten Bereichs (leer, maximal, exakt am Schwellwert). Spec sollte sagen, ob das Verhalten am Rand "noch akzeptabel" oder "schon Fehler" ist.
3. **Negative** — falsifiziert die These "Annahmen aus dem Happy Path sind universell": Eingabe ist *außerhalb* der Spec. Spec sollte den Fehlerpfad explizit benennen (Exception, definierter Rückgabewert, Logging-Eintrag).

Boundary und Negative widerlegen die stillen Annahmen des Happy Path —
genau die Annahmen, die ein Agent am liebsten als "selbstverständlich"
behandelt. Wenn die Spec auf "Negative" mit "ist undefiniert" antwortet,
ist das eine Spec-Lücke, und genau dort halluziniert ein Agent.

### Wo gehört "Performance < 200 ms" hin — funktional oder nichtfunktional?

Nichtfunktional. Funktionale Anforderungen beschreiben *was* das System
tut; nichtfunktionale *wie gut* es das tut (Performance, Verfügbarkeit,
Sicherheit, Wartbarkeit).

Praktischer Test: Wenn ein Akzeptanzkriterium ohne Messung im
Lasttest nicht prüfbar ist, ist es nichtfunktional. "Performance
< 200 ms p95 bei 100 RPS" gehört in den nichtfunktionalen Block der
Spec — oder in `spec/spezifikation.md`, wenn dein Repo
[stratifiziert](../grundlagen/konventionen.md#spec-stratifizierung).

Falle: "Antwort innerhalb von 200 ms" klingt funktional, ist aber eine
Latenz-Garantie. Funktional wäre "System antwortet mit gültigem JSON";
die 200 ms sind eine Qualität *dieser* Antwort.

### (Erschaffens-Prozess) Welcher Schritt deines Lastenheft-Schreibens war der unsicherste — und warum?

Diese Frage hat keine universelle Lösung — sie fragt nach *deinem*
Schreibprozess. Was eine gute Antwort auszeichnet:

- Ein *konkreter* Schritt ist benannt (nach der Nummerierung des
  Worked Example), plus eine Begründung, *warum* gerade er unsicher
  war. Beispiel einer modellierten Antwort: "Schritt 5 (Negative) —
  ich habe erst beim Hinschreiben gemerkt, dass ich gar nicht weiß,
  *was alles* das System nicht tun darf; der Happy Path war dagegen
  in zwei Minuten geschrieben."
- Erfahrungsgemäß sind Schritt 5 (Negative) und Schritt 6
  (Out-of-Scope) die unsichersten — und genau das ist die Pointe:
  die unsicheren Schritte des Schreibens sind die häufigsten
  Spec-Lücken im Ergebnis. Wo du zögerst, rät später der Agent.

Anti-Antwort: "Kein Schritt war unsicher." — wer keinen unsicheren
Schritt findet, hat das Worked Example *gelesen* statt *nachgebaut*.
Die Frage prüft den Erschaffens-Prozess, nicht das Erinnern der sechs
Schritte.

### (Erschaffen — aktiviert LZ 4) Drei-Schichten-Spec-Stratifizierung für dein Mini-Feature

Ausgearbeitete Beispiel-Konstruktion für das Konfigurations-Feature
aus dem Worked Example (`LH-FA-CFG-001`):

| Schicht | Pflicht-Inhalt (gehört zwingend hierhin) | Anti-Inhalt (fehl am Platz) |
|---|---|---|
| `lastenheft.md` — vertragliches *Was* | "Das System liest beim Start `config.yaml` und gibt `name@version` aus; bei fehlender Datei Abbruch mit Exit-Code 1." (abnahmebindend, mit Akzeptanzkriterien) | "Das Parsen nutzt die Bibliothek `yaml.v3`." (Implementierungs-Detail — bindet den Vertrag an eine Lösung) |
| `spezifikation.md` — präzisiertes *Wie genau* | "Pflichtfelder `name`, `version`; `name` matcht `^[a-z][a-z0-9-]{2,31}$`; Parse-Fehler werden mit Zeilennummer gemeldet." (präzisiert den Vertrag prüfbar) | "Der Kunde braucht das Feature für Audit-Zwecke." (Anforderungs-Begründung — gehört ins Lastenheft bzw. dessen Kontext) |
| `architektur.md` — strukturelles *Wodurch* | "Config-Zugriff nur über den `ConfigLoader`-Port; der Service-Layer ruft nie direkt das Dateisystem." (Struktur-Invariante, von ArchUnit prüfbar) | "Bei leerer Datei Exit-Code 2." (Verhaltens-Vertrag — gehört ins Lastenheft, sonst entsteht eine zweite Wahrheitsquelle) |

**Konfliktregel:** Lastenheft sticht Spezifikation sticht Architektur.
Die untere Schicht darf die obere *präzisieren*, nie *erweitern* —
taucht dieselbe Aussage in zwei Schichten auf, gilt die obere
Formulierung, und die untere wird auf eine Präzisierung zurückgebaut
(oder gelöscht, wenn sie nur dupliziert).

Exzellent wird der Entwurf mit der *zweiten* Konfliktregel: Macht die
Architektur eine Spezifikations-Aussage technisch *unmöglich*, wird
nicht still angepasst — der Pfad läuft rückwärts über eine
ADR-Supersedure plus Spec-Update, damit die Änderung auditierbar
bleibt. Vorbild: Spec-Stratifizierung in `c-hsm-doc`
([`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)).

Anti-Antwort: drei Schichten, deren Inhalte austauschbar formuliert
sind ("Schicht 1: Konfiguration, Schicht 2: Details, Schicht 3:
Technik") — ohne Anti-Inhalt pro Schicht ist die Trennung nicht
operationalisiert.

### (Bewerten — aktiviert LZ 3) Eine Lücke aus dem provozierten Agentenlauf diagnostizieren

Modellierte Antwort (dein konkreter Lauf liefert andere Details,
aber dieselbe Struktur):

- **Beobachtetes Verhalten:** Der Agent hat beim Feature "Liste der
  letzten Konfigurations-Versionen" ein Default-Limit von 10
  Einträgen erfunden und paginiert — gefordert war beides nicht.
- **Diagnose — welcher Spec-Bestandteil fehlte:** ein
  Boundary-Kriterium für die Listenlänge ("Given 10 000 Versionen,
  When … Then …"). Ohne Boundary war der Rand des Wertebereichs
  unspezifiziert, und der Agent hat ihn mit der *plausibelsten*
  Konvention gefüllt. Die Lücke ist klassisch *inferential
  feedforward*: ein Guide vor der Handlung fehlte, kein Sensor
  danach.
- **Metakognitive Hälfte:** Die eigene Annahme, die die Lücke
  verdeckte: "Ein Limit ist doch offensichtlich — niemand will
  10 000 Zeilen." Genau weil die Annahme *mir* selbstverständlich
  schien, habe ich sie nicht hingeschrieben — und genau die
  selbstverständlichen Annahmen sind die teuersten Lücken, weil sie
  systematisch ungeprüft bleiben.

Anti-Antwort: "Die Spec war unklar." — das benennt weder den
fehlenden Bestandteil (welche der drei Kriterien-Arten? welche
Out-of-Scope-Zeile?) noch die eigene Annahme. Ohne beide Hälften ist
es keine Bewertung, sondern ein Schulterzucken.

## Übungshinweise

### Erstellung eines vollständigen Lastenhefts für ein kleines Feature

Maßstab für ein gutes Lastenheft:

- Jede Anforderung hat eine ID (`LH-FA-*` für funktional, `LH-QA-*` für nichtfunktional, oder eigene Schema). Die IDs erscheinen später in Make-Target-Kommentaren, ADRs und Commits — sie sind die Klammer ([siehe ID-Schema](../grundlagen/konventionen.md#id-schema-als-klammer)).
- Akzeptanzkriterien sind im Given/When/Then-Stil und enthalten Boundary + Negative.
- Out-of-Scope ist *explizit* benannt — nicht weggelassen.
- Mindestens *eine* Negativbedingung pro Feature ("dieses System *darf nicht*…"). Negativ ist genauso präzise wie positiv.

Vergleich-Möglichkeit: Das Lab-Beispiel unter
[`/lab/example/spec/lastenheft.md`](../../../lab/example/spec/lastenheft.md)
zeigt das vollständige Schema mit IDs.

### Provoziere absichtlich einen Spec-Bug

Gute Trigger:

- Lasse "Out-of-Scope" weg — der Agent wird etwas Plausibles bauen, was nicht gefordert war.
- Verwende ein vages Wort ("schnell", "robust", "intuitiv") ohne messbares Kriterium — der Agent rät den Default.
- Lass mehrere Anforderungen sich widersprechen (z. B. "stateless" + "merkt sich Sessions") — der Agent wählt eine, ohne den Konflikt zu melden.

Dokumentiere: was hat der Agent gewählt? Welches Wort der Spec hat ihn
in diese Richtung gedrängt? Die Antwort wird oft ein einzelnes Verb sein
("speichern" → vermuten DB; "merken" → vermuten Cache).

### Drei-Schichten-Übung (Erschaffen — LZ 4)

Maßstab für eine gute Verteilung:

- Pro Schicht steht *ein* Pflicht-Inhalt **und** *ein* Anti-Inhalt —
  der Anti-Inhalt ist der eigentliche Test: wer nur Pflicht-Inhalte
  nennt, hat die Schichten beschrieben, aber nicht *abgegrenzt*.
- Die Konfliktregel ist als Satz formuliert (Lastenheft sticht
  Spezifikation sticht Architektur; die untere Schicht darf
  *präzisieren*, nie *erweitern*) — nicht nur "es gibt eine
  Rangordnung".
- Die drei Dateien folgen den Vorlagen unter
  [`/lab/templates/spec/`](../../../lab/templates/spec/); Vorbild
  für die gelebte Trennung ist `c-hsm-doc`
  ([`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)).

Häufiger Fehler: dieselbe Aussage wandert wortgleich in zwei
Schichten ("Sicherheitsnetz"). Das ist keine Stratifizierung, sondern
eine Duplikation — beim ersten Update driften die Kopien auseinander,
und die Konfliktregel muss entscheiden, welche gilt. Eine
ausgearbeitete Beispiel-Verteilung samt beiden Konfliktregeln steht
oben in der Selbstcheck-Antwort zum Erschaffen-Item (LZ 4).

## Häufige Fehler

- Lastenheft enthält Implementierungs-Details ("die REST-API verwendet POST"). → Implementierung gehört in `spec/spezifikation.md` oder ADR, nicht ins Lastenheft.
- Lastenheft wird ohne IDs geschrieben. → Spätere Traceability-Constraint ist nicht erzwingbar.
- Akzeptanzkriterien enden nach dem Happy Path. → Agent baut nur den Happy Path zuverlässig.

## Verweise

- Spec-Stratifizierung: [`../grundlagen/konventionen.md#spec-stratifizierung`](../grundlagen/konventionen.md#spec-stratifizierung)
- Reales Beispiel mit Lastenheft/Spezifikation-Trennung: `pt9912/c-hsm-doc` in [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
- Vorherige Lösung: [Modul 2](modul-02-loesung.md)
- Nächste Lösung: [Modul 4](modul-04-loesung.md)
