# ADR-0018: Grenzen stehen in der Konfiguration, nicht im Entscheidungs-Körper

**Status:** Accepted

**Datum:** 2026-08-09

**Autor:** Kurs-Lab

**Supersedes:** [ADR-0017](0017-kotlin-luecke-am-bestandssensor-geschlossen.md)
(dort trug `§Konsequenzen` eine Tabelle der Sensor-Grenzen je Skelett; sie ist
versionsabhängig und zwang bei jeder Werkzeug-Verbesserung eine Ablösung)

**Bezug:** [ADR-0001](0001-hexagonale-architektur.md) (Layering und dessen
Fitness Function)

**Schärft:** — (Prozess-ADR ohne Spec-Stratum: die Werkzeugwahl eines Gates ist
kein Vertragspunkt gegenüber einem Abnehmer, sondern eine Harness-Entscheidung)

---

## Kontext

Diese ADR-Kette ist an zwei Tagen viermal abgelöst worden, und die letzten
beiden Male aus demselben Grund: Eine Tabelle im Entscheidungs-Körper führte
**Fakten über ein Fremdwerkzeug** — welche Schreibweise welcher Sensor sieht.
Solche Fakten ändern sich mit jedem Release des Werkzeugs, und weil eine
`Accepted`-ADR immutabel ist, erzwingt jede Änderung eine Nachfolge-ADR samt
Umhängen aller Verweise.

Zuletzt ausgelöst durch a-check v0.17.0: Die dort notierte Grenze *„das
generierte Fragment ruft `docker` wörtlich auf"* ist behoben — upstream, an der
Stelle, die die ADR selbst benannt hatte. Eine korrekte Ablösung nur deshalb
wäre die vierte in zwei Tagen gewesen.

Das Problem ist nicht die Kette, sondern der **Ort**. Eine Grenze wird gebraucht,
wenn jemand die Konfiguration liest oder ändert — nicht, wenn jemand die
Entscheidung nachvollzieht. Sie gehört dorthin, wo sie gelesen wird.

## Entscheidung

Die Entscheidung der Vorgängerin gilt unverändert weiter und steht hier
vollständig, mit **derselben Nummerierung** — ein Nachfolger, der weniger
trägt, macht jeden Abschnitts-Zeiger auf sich falsch. Neu ist Punkt 7.

1. **a-check ist das zweite Layering-Gate in jedem Sprach-Skelett.** Der
   jeweilige Bestandssensor bleibt — die Mechanismus-Vielfalt ist Lehrinhalt
   des Beispiels, kein Altlast-Zustand.
2. **Eine Config pro Skelett, Scan-Wurzel ist das Sprachverzeichnis.** **Kein**
   gemeinsamer Scan über `lab/example/`: Go-Importe tragen den Modulpfad und
   lösen gegen sprach-präfixierte Schicht-Globs nicht auf; ein eingebauter
   Verstoß blieb im Mono-Scan unentdeckt — das Gate wäre still grün.
3. **Modelliert wird, was gebaut ist.** Rollen nur dort, wo die Schicht sie
   trägt: Das C++-Skelett hat Ports, die übrigen fünf sind geschichtet ohne
   Ports und tragen reine Kanten.
4. **Ein Gate, zwei Sensoren.** `make arch-check` ruft beide, und zwar beide
   vollständig — ein Abbruch nach dem ersten roten zeigt immer nur eine
   Befund-Menge.
5. **Vor einem siebten Skelett: die Regeln des Bestandssensors lesen, nicht
   sein Datenblatt.** Welche Schreibweise setzt die Symbol-Auflösung voraus,
   welche umgeht sie, und erzwingt irgendetwas die vorausgesetzte? Ohne Beleg
   am Skelett ist eine grüne Deklaration kein Beleg.
6. **Eine Sensor-Schwäche wird im Sensor behoben, nicht per Zusatzregel
   kompensiert.** So ist im Kotlin-Skelett die `constructs`-Regel entfallen,
   nachdem die Konsist-Regeln den Quelltext prüfen statt nur `file.imports`.
7. **Neu: Die Grenze steht in der Konfiguration, die sie betrifft.** Jede
   `<sprache>/.a-check.yml` trägt einen `GRENZE`-Block: welche Schreibweise
   dieses Skelett umgehen könnte, ob der Bestandssensor sie sieht, und was
   daraus folgt (Zusatzregel oder ausgewiesene Lücke). Diese ADR führt **kein**
   Inventar mehr — sie entscheidet, *dass* deklariert wird, und überlässt das
   *Was* dem Ort, an dem konfiguriert wird. Ein Werkzeug-Release ändert dann
   Kommentare, keine ADR.

## Verglichene Alternativen

### Option A — Nachfolge-ADR wie bisher, Tabelle aktualisiert

- Pro: Ein Blick, alle sechs Grenzen nebeneinander; konventionstreu.
- Contra: Die vierte Ablösung in zwei Tagen, ausgelöst nicht von einer
  Entscheidung, sondern von einem fremden Release. Die Kette wächst mit der
  Release-Frequenz eines Werkzeugs, das wir nicht kontrollieren.

### Option B — Tabelle stehen lassen, veraltet hinnehmen

- Contra: Eine aktive ADR mit einer nachweislich falschen Aussage. Genau die
  Bauform, gegen die dieses Repo sonst antritt.

### Option C — Grenzen in die Konfiguration, ADR ohne Inventar (gewählt)

- Pro: Die Grenze steht, wo sie gebraucht wird — beim Konfigurieren, nicht beim
  Nachvollziehen der Entscheidung.
- Pro: Die ADR veraltet nicht mehr bei Werkzeug-Releases.
- Contra: Kein Ort mehr, an dem alle sechs nebeneinander stehen. Wer sie
  vergleichen will, liest sechs Dateien — das ist der Preis, und er ist
  vertretbar, weil die Frage praktisch immer *ein* Skelett betrifft.
- Contra: Sechs Blöcke können auseinanderlaufen. Kein Sensor prüft sie; der
  Trigger unten benennt das.

## Konsequenzen

- Positiv: Jedes Skelett hat eine Allow-Liste statt einer Verbotsliste — in
  jedem der sechs belegt (dritter Adapter, `Types`-Schicht ohne Regel, neues
  Paket, neues Modul).
- Positiv: `make a-check-graph` erzeugt das Schichtbild aus derselben
  Deklaration, die das Gate prüft.
- Positiv: Seit a-check v0.17.0 meldet das Werkzeug zwei Klassen von Blindheit
  **selbst** — nicht extrahierbare Import-Zeilen und Schichten, in denen kein
  Symbol auflöst. Der Handgriff aus Punkt 5 wird dadurch nicht überflüssig, aber
  kleiner: Was die Diagnose meldet, muss niemand mehr durch einen eingebauten
  Verstoß suchen.
- Negativ: Sechs Image-Pins, die altern. Sie hängen an keinem Freshness-Sensor;
  das Anheben ist Handarbeit und trifft alle sechs in einem Commit.
- Negativ: Zwei Sensoren für eine Aussage können divergieren. Bei Widerspruch
  gilt ADR-0001, nicht der strengere Lauf — beide sind Sensoren, keine Quelle.
- Folgepflicht: Jedes Skelett trägt die Bindung in seinem
  `<sprache>/harness/README.md` §Sensors **und** seinen `GRENZE`-Block in der
  Konfiguration. Fehlt der Block, ist die Grenze nirgends deklariert.

## Fitness Function

| Tooling | Regel | Make-Target |
|---|---|---|
| Bestandssensor je Skelett | wie in ADR-0001 §Fitness Function | `make arch-check` |
| a-check (Container, digest-gepinnt) | `.a-check.yml` je Skelett: Schichten + erlaubte Kanten aus ADR-0001, Rollen nur wo gebaut, `GRENZE`-Block | `make a-check` (läuft in `make arch-check` mit) |

## Re-Evaluierungs-Trigger

- **Ein Skelett lässt sich nicht ohne Ausnahme-Liste deklarieren**: Wächst
  `markers.ignore_symbols` oder `allow`, ist die Werkzeugwahl für dieses
  Skelett neu zu bewerten — nicht die Liste.
- **Die beiden Sensoren widersprechen sich**: kein stilles Abschalten eines
  Laufs, sondern Befund gegen ADR-0001 prüfen und die Ursache benennen.
- **Ein `GRENZE`-Block widerspricht einem anderen** oder fehlt in einem
  Skelett: Dann trägt die verteilte Form nicht mehr, und die Frage nach einem
  gemeinsamen Ort ist neu zu stellen — dann aber mit einem Sensor, nicht mit
  einer Tabelle im Entscheidungs-Körper.

## Geschichte

| Datum | Ereignis | Verweis |
|---|---|---|
| 2026-08-09 | Proposed | a-check v0.17.0 behebt die in der Vorgängerin notierte `docker`-Grenze; vierte Ablösung derselben Kette drohte |
| 2026-08-09 | Accepted | `GRENZE`-Blöcke in allen sechs `.a-check.yml` ergänzt bzw. bestätigt; Verweise umgehängt |
