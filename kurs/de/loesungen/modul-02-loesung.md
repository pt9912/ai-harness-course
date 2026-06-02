# Lösung — Modul 2: Lastenheft und Spezifikation

Zugehöriges Modul: [Modul 2 — Lastenheft und Spezifikation](../01-spec-und-architektur/modul-02-lastenheft.md).

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

## Häufige Fehler

- Lastenheft enthält Implementierungs-Details ("die REST-API verwendet POST"). → Implementierung gehört in `spec/spezifikation.md` oder ADR, nicht ins Lastenheft.
- Lastenheft wird ohne IDs geschrieben. → Spätere Traceability-Constraint ist nicht erzwingbar.
- Akzeptanzkriterien enden nach dem Happy Path. → Agent baut nur den Happy Path zuverlässig.

## Verweise

- Spec-Stratifizierung: [`../grundlagen/konventionen.md#spec-stratifizierung`](../grundlagen/konventionen.md#spec-stratifizierung)
- Reales Beispiel mit Lastenheft/Spezifikation-Trennung: `pt9912/c-hsm-doc` in [`../grundlagen/fallstudien.md`](../grundlagen/fallstudien.md)
- Vorherige Lösung: [Modul 1](modul-01-loesung.md)
- Nächste Lösung: [Modul 3](modul-03-loesung.md)
