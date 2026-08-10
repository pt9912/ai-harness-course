# ADR-0017: Die Kotlin-Lücke gehört in den Bestandssensor, nicht in eine Zusatzregel

**Status:** Superseded by [ADR-0018](0018-grenzen-gehoeren-in-die-konfiguration.md)

**Datum:** 2026-08-09

**Autor:** Kurs-Lab

**Supersedes:** [ADR-0016](0016-a-check-in-allen-skeletten.md) (dort trug die
Grenzen-Tabelle Kotlin als geteilten blinden Fleck und begründete damit eine
`constructs`-Regel; beides gilt nicht mehr)

**Bezug:** [ADR-0001](0001-hexagonale-architektur.md) (Layering und dessen
Fitness Function)

**Schärft:** — (Prozess-ADR ohne Spec-Stratum: die Werkzeugwahl eines Gates ist
kein Vertragspunkt gegenüber einem Abnehmer, sondern eine Harness-Entscheidung)

---

## Kontext

ADR-0016 hielt fest: Im Kotlin-Skelett sind **beide** Sensoren blind für den
voll qualifizierten Zugriff ohne Import — a-check liest Import-Zeilen, und die
Konsist-Regeln waren gegen `file.imports` geschrieben. Eine `constructs`-Regel
schloss davon die Richtung auf die äußerste Schicht; für die übrigen Kanten
blieb die Lücke, ausgewiesen als Grenze.

Der Re-Evaluierungs-Trigger dort nannte den Ausweg schon: *Konsists Regeln
werden auf Typ-Referenzen gehoben.* Das ist geschehen.

## Entscheidung

Die Entscheidung der Vorgängerin gilt unverändert weiter und steht hier
vollständig — ein Nachfolger, der nur seinen eigenen Zusatz trägt, lässt jeden
Verweis auf die übrigen Punkte ins Leere zeigen. **Die Nummerierung ist
absichtlich dieselbe**; neu ist allein Punkt 6.

1. **a-check ist das zweite Layering-Gate in jedem Sprach-Skelett.** Der
   jeweilige Bestandssensor bleibt — die Mechanismus-Vielfalt ist Lehrinhalt
   des Beispiels, kein Altlast-Zustand. Ein Stand wird nicht geführt; welche
   Targets ein Skelett hat, sagt sein `make help`.
2. **Eine Config pro Skelett, Scan-Wurzel ist das Sprachverzeichnis.** **Kein**
   gemeinsamer Scan über `lab/example/`: Go-Importe tragen den Modulpfad und
   lösen gegen sprach-präfixierte Schicht-Globs nicht auf; ein eingebauter
   Verstoß blieb im Mono-Scan unentdeckt — das Gate wäre still grün.
3. **Modelliert wird, was gebaut ist.** Rollen (`role: app`, `role: adapter`)
   nur dort, wo die Schicht sie trägt: Das C++-Skelett hat Ports, die übrigen
   fünf sind geschichtet ohne Ports und tragen reine Kanten.
4. **Ein Gate, zwei Sensoren.** `make arch-check` ruft beide, und zwar beide
   vollständig — ein Abbruch nach dem ersten roten zeigt immer nur eine
   Befund-Menge. Das Ziel-Set von `make gates` bleibt unverändert.
5. **Vor einem siebten Skelett: die Regeln des Bestandssensors lesen, nicht
   sein Datenblatt.** Welche Schreibweise setzt die Symbol-Auflösung voraus,
   welche umgeht sie, und erzwingt irgendetwas die vorausgesetzte? Die Antwort
   ist am Skelett zu belegen. Ohne diesen Schritt ist eine grüne Deklaration
   kein Beleg.
6. **Neu: Eine Sensor-Schwäche wird im Sensor behoben, nicht per Zusatzregel
   kompensiert.** Im Kotlin-Skelett waren beide Sensoren blind für den voll
   qualifizierten Zugriff ohne Import; eine `constructs`-Regel deckte davon
   eine von fünf Richtungen. Die Konsist-Regeln prüfen jetzt den Quelltext
   statt nur `file.imports` und fangen beide Formen — gemessen: `service → ui`
   und `index → service` jeweils voll qualifiziert, vorher grün, jetzt rot,
   unveränderter Baum grün. Die `constructs`-Regel entfällt damit: Eine Regel,
   deren Grund entfallen ist, bleibt nicht stehen, weil sie billig ist — so
   wachsen Ausnahme-Listen. Kotlin verhält sich damit wie Java und C#: a-check
   ist die Allow-Liste über Importe, der Bestandssensor sieht tiefer.

## Verglichene Alternativen

### Option A — `constructs`-Regel behalten (belt and braces)

- Pro: Zwei unabhängige Sensoren für die gefährlichste Richtung; a-check läuft
  in einer Sekunde, Konsist braucht einen JVM-Build.
- Contra: Sie deckt genau eine von fünf Richtungen und dupliziert damit einen
  Ausschnitt dessen, was der Bestandssensor vollständig prüft. Eine Regel ohne
  eigenen Grund ist keine Absicherung, sondern Rauschen im Konfigurations-Bild.

### Option B — Regel auf alle Richtungen ausweiten

- Contra: Das hieße, den Kanten-Graphen ein zweites Mal als Zonen-Listen zu
  führen. ADR-0016 hat genau das schon einmal verworfen.

### Option C — Lücke im Bestandssensor schließen, Regel entfernen (gewählt)

- Pro: Eine Wahrheit, an der Stelle, an der sie hingehört.
- Contra: Die Konsist-Prüfung ist Text-Vergleich, keine Typ-Auflösung — Konsist
  ist quell-basiert (PSI), nicht Bytecode-basiert wie ArchUnit. Die
  Heuristik-Grenze bleibt, sie wandert nur.

## Konsequenzen

- Positiv: Kein Skelett trägt mehr eine Zusatzregel, die eine Sensor-Schwäche
  kompensiert. Wo eine Schwäche bleibt, ist sie ausgewiesen.
- **Grenzen je Skelett**, fortgeschrieben. a-check liest die Import-Anweisung;
  ob seine Blindheit zur Gate-Lücke wird, entscheidet der Bestandssensor:

  | Skelett | Umgehende Schreibweise | Bestandssensor sieht sie? |
  |---|---|---|
  | C++ | elternrelativer `#include` | **nein** — Skript grept Text; per `constructs`-Regel verboten |
  | Kotlin | voll qualifizierter Typ ohne `import` | **ja** — Konsist prüft den Quelltext (seit dieser ADR) |
  | C# | voll qualifizierter Typ ohne `using` | ja — NetArchTest liest die Assembly |
  | Java | voll qualifizierter Typ ohne `import` | ja — ArchUnit importiert Bytecode |
  | Python | relativ, Subpaket-Form, Komma-Liste | ja — `import-linter` löst den AST auf |
  | Go | keine — der Compiler weist relative Importe ab | entfällt |

  C++ bleibt der einzige Fall mit zwei textnahen Sensoren; dort trägt die
  `constructs`-Regel weiter.
- Negativ: Die Konsist-Regeln sind länger und tragen einen Text-Filter
  (Kommentare, eigene `package`-Zeile). Wer sie liest, muss die Grenze
  mitlesen — sie steht als Kommentar darüber.
- Grenze: Ein Bezug über einen Typ-Alias oder eine Extension in einem anderen
  Paket bleibt unsichtbar. Das ist die Klasse, die nur eine echte
  Typ-Auflösung fängt, und die hat Konsist nicht.

## Fitness Function

| Tooling | Regel | Make-Target |
|---|---|---|
| Bestandssensor je Skelett | wie in ADR-0001 §Fitness Function; in Kotlin über den Quelltext, nicht nur `file.imports` | `make arch-check` |
| a-check (Container, digest-gepinnt) | `.a-check.yml` je Skelett: Schichten + erlaubte Kanten aus ADR-0001, Rollen nur wo gebaut | `make a-check` (läuft in `make arch-check` mit) |

## Re-Evaluierungs-Trigger

- **Ein Skelett lässt sich nicht ohne Ausnahme-Liste deklarieren**: Wächst
  `markers.ignore_symbols` oder `allow`, ist die Werkzeugwahl für dieses
  Skelett neu zu bewerten — nicht die Liste.
- **Die beiden Sensoren widersprechen sich**: kein stilles Abschalten eines
  Laufs, sondern Befund gegen ADR-0001 prüfen und die Ursache benennen.
- **Der C++-Skript-Sensor wird durch einen tieferen ersetzt** (Parser statt
  Include-Heuristik): Dann entfällt auch dort der geteilte blinde Fleck und die
  verbliebene `constructs`-Regel ist neu zu bewerten.

## Geschichte

| Datum | Ereignis | Verweis |
|---|---|---|
| 2026-08-09 | Proposed | Re-Evaluierungs-Trigger von ADR-0016 eingetreten: Konsists Regeln auf Quelltext gehoben |
| 2026-08-09 | Accepted | `constructs`-Regel im Kotlin-Skelett entfernt; Grenzen-Tabelle fortgeschrieben; Verweise auf diese ADR umgehängt |
| 2026-08-09 | Superseded | [ADR-0018](0018-grenzen-gehoeren-in-die-konfiguration.md) — die Grenzen-Tabelle war versionsabhaengig und zwang bei jedem Werkzeug-Release eine Abloesung; sie steht jetzt je Skelett in der Konfiguration |
