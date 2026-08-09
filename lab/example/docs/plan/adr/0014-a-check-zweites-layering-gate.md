# ADR-0014: a-check als zweites Layering-Gate im C++-Skelett

**Status:** Superseded by [ADR-0015](0015-a-check-rollout-sprachskelette.md)

**Datum:** 2026-08-09

**Autor:** Kurs-Lab

**Bezug:** [ADR-0001](0001-hexagonale-architektur.md) (Layering und dessen
Fitness Function — diese ADR ergänzt deren Werkzeugzeile für C++, sie ändert
die Entscheidung nicht)

**Schärft:** — (Prozess-ADR ohne Spec-Stratum: die Werkzeugwahl eines Gates ist
kein Vertragspunkt gegenüber einem Abnehmer, sondern eine Harness-Entscheidung)

---

## Kontext

ADR-0001 verlangt „pro Sprach-Skelett ein Architekturtest". Im C++-Skelett ist
das [`cmake/arch-check.sh`](../../../cpp/cmake/arch-check.sh): vier von Hand
geschriebene `grep`-Regeln, die vier konkrete Verzeichnispaare gegeneinander
absichern.

Das Skript ist ehrlich — es sagt im Kopf, dass es textbasiert ist und keinen
C++-Parser hat. Aber es trägt die Layering-Aussage als **Code**, und die vier
Regeln sind eine **Auswahl**, keine Ableitung aus ADR-0001:

- Regel C nennt `src/adapters/ui` beim Namen, Regel D `src/adapters/embedding`.
  Ein **dritter** Adapter unter `src/adapters/` wäre von keiner Regel erfasst —
  das Gate bliebe grün, obwohl ADR-0001 auch für ihn gilt.
- Jede Layer-Änderung ist eine Skript-Änderung. Was das Skript prüft, steht
  nirgends als Deklaration, sondern muss aus vier `grep`-Ausdrücken gelesen
  werden.

Genau diese Skript-Spezies — pro Repo eine driftende `arch-check.sh`-Variante —
ist der Anlass für [a-check](https://github.com/pt9912/a-check), das der Kurs in
[Modul 4](../../../../../kurs/de/01-spec-und-architektur/modul-04-adrs.md) schon
als Fitness-Function-Werkzeug führt.

## Entscheidung

a-check läuft im C++-Skelett **zusätzlich** zum Skript, nicht an seiner Stelle.

1. **Layering als Deklaration.** [`cpp/.a-check.yml`](../../../cpp/.a-check.yml)
   trägt die Schichten und erlaubten Kanten aus ADR-0001. `service` bekommt
   explizit `role: app`, damit neben der Kanten-Regel auch der direkte
   Adapter-Zugriff (`app-impurity`) greift. Jeder Adapter ist eine **eigene**
   Schicht: ADR-0001 gibt UI und Embedding verschiedene Reichweiten, eine
   gemeinsame `adapters`-Schicht trüge die Vereinigung beider Kanten und wäre
   damit schwächer als Regel D des Skripts.
2. **Ein Gate, zwei Sensoren.** `make arch-check` ruft beide auf; das
   Make-Fragment `a-check.mk` ist tool-generiert (`a-check --print-mk`) und wird
   included — keine Skript-Kopie.
3. **Digest-Pin.** `A_CHECK_IMAGE` steht im `Makefile`, nicht im generierten
   Fragment: Der von `--print-mk` ausgegebene Default nennt den Digest des
   *Vorgänger*-Release (er wird vor dem Push eingebacken) — v0.15.0 gibt
   v0.14.0 aus. Gepinnt wird deshalb hier, auf den Stand, gegen den das Skelett
   geprüft ist. Anheben ist ein eigener Commit.
4. **Pilot.** Die Entscheidung gilt vorerst nur für C++. Die übrigen fünf
   Skelette behalten ihr jeweiliges Werkzeug, bis der Pilot ausgewertet ist.

## Verglichene Alternativen

### Option A — Das Skript durch a-check ersetzen

- Pro: Eine Quelle statt zwei, kein Divergenz-Risiko.
- Contra: Das Skript ist Kurs-Anschauungsmaterial — es ist das Beispiel für
  „computational feedback ohne Toolchain" und die Skript-Zeile in der
  Werkzeug-Vergleichstabelle des Beispiels. Ohne es verliert der Sprach-Vergleich
  eine seiner drei Mechanismus-Klassen (Konfiguration / Test-Framework / Skript).
- Contra: Man tauscht ein toolchainfreies Skript gegen einen Image-Pull.

### Option B — Nichts ändern

- Pro: Keine zusätzliche Fläche, kein zweiter Pin.
- Contra: Die Lücke bleibt — ein neuer Adapter ist ungeprüft, und die
  Layering-Aussage bleibt in `grep`-Ausdrücken verborgen statt deklariert.

### Option C — Beide, das Skript bleibt (gewählt)

- Pro: Die Layering-Aussage steht als Deklaration; generische Regeln
  (`app-impurity`, `lateral-adapter`) decken auch Schichten und Adapter ab, die
  beim Schreiben der Regel noch nicht existierten.
- Pro: Das Skelett zeigt beide Mechanismus-Klassen an **derselben** Aussage —
  das ist genau die Gegenüberstellung, die der Sprach-Vergleich lehren will.
- Contra: Zwei Sensoren für eine Aussage können divergieren; sie müssen bei einer
  Layering-Änderung beide nachgezogen werden.

## Konsequenzen

- Positiv: Ein neuer Adapter unter `src/adapters/` ist ab sofort erfasst, ohne
  dass jemand eine fünfte `grep`-Regel nachträgt: Er liegt in keiner Schicht,
  und a-check meldet jeden seiner Schicht-Importe als Befund, bis er deklariert
  ist. Das Skript bleibt bei ihm stumm.
- Positiv: `make a-check-graph` erzeugt das Schichtbild aus derselben
  Deklaration, die das Gate prüft — Diagramm und Gate können nicht auseinanderlaufen.
- Negativ: Ein zweiter Image-Pin, der altert. Er hängt an keinem
  Freshness-Sensor; das Anheben ist Handarbeit.
- Negativ: Bei Widerspruch der beiden Sensoren gilt ADR-0001, nicht der
  „strengere" Lauf. Beide sind Sensoren, keine Quelle.
- Grenze: a-check ist wie das Skript **text-heuristisch** (kein C++-Parser). Die
  Grenze verschwindet nicht, sie wird nur deklariert statt implizit.
- Grenze: Das generierte Fragment ruft `docker` wörtlich auf, nicht `$(DOCKER)`
  wie die übrigen Recipes des Skeletts. `make arch-check DOCKER=podman` fährt
  den Skript-Sensor unter podman und diesen Sensor weiter unter docker; auf
  einem Host ohne `docker`-Binary läuft das Gate nicht. Behoben gehört das in
  `a-check --print-mk`, nicht in eine Handkorrektur des Fragments.
- Folgepflicht: `cpp/harness/README.md` §Sensors nennt die Bindung des neuen
  Targets; ohne diese Zeile wäre das Gate nirgends definiert (AGENTS.md §4).

## Fitness Function

| Tooling | Regel | Make-Target |
|---|---|---|
| `cmake/arch-check.sh` | vier benannte Verzeichnispaare, Include-Heuristik | `make arch-check` |
| a-check (Container, digest-gepinnt) | `.a-check.yml`: Schichten + erlaubte Kanten aus ADR-0001; je Adapter eine Schicht (Regel C/D), `service` als `role: app` | `make a-check` (läuft in `make arch-check` mit) |

## Re-Evaluierungs-Trigger

- **Pilot ausgewertet**: Rollout auf die übrigen fünf Skelette als eigener Slice
  mit Nachfolge-ADR. **Nicht** als eine gemeinsame Config über `lab/example/`:
  Diese Variante wurde geprüft und verworfen — Go-Importe tragen den Modulpfad
  (`github.com/example/docsearch/internal/ui`) und lösen gegen sprach-präfixierte
  Schicht-Globs (`go/internal/ui/**`) nicht auf; ein eingebauter Verstoß blieb
  unentdeckt. Rollout heißt: eine Scan-Wurzel und eine Config **pro Skelett**.
- **Die beiden Sensoren widersprechen sich**: kein stilles Abschalten eines
  Laufs, sondern Befund gegen ADR-0001 prüfen und die Ursache benennen.
- **a-check kann ein Layering-Konstrukt nicht ausdrücken**: dokumentieren statt
  die Ausnahme-Listen wachsen lassen — wächst `markers.ignore_symbols`, ist die
  Werkzeugwahl neu zu bewerten.

## Geschichte

| Datum | Ereignis | Verweis |
|---|---|---|
| 2026-08-09 | Proposed | Lücke in `arch-check.sh` Regel C/D (dritter Adapter ungeprüft); a-check gegen alle sechs Skelette erprobt, Break-Test je Skelett rot |
| 2026-08-09 | Accepted | C++-Pilot verdrahtet: `.a-check.yml`, `a-check.mk` (tool-generiert), `arch-check` ruft beide Sensoren |
| 2026-08-09 | Nachtrag | Review-Befunde vor dem Merge: Adapter je Schicht getrennt (gemeinsame `adapters`-Schicht war schwächer als Regel D), `include` hinter `help` (Default-Goal), `$(DOCKER)`-Grenze aufgenommen |
| 2026-08-09 | Superseded | [ADR-0015](0015-a-check-rollout-sprachskelette.md) weitet den Geltungsbereich vom C++-Pilot auf alle Sprach-Skelette |
