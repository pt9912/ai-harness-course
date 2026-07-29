# ADR-0013: Coverage-Schwellen — bootstrap-aware 70 %, kritisch 90 %

**Status:** Accepted

**Datum:** 2026-06-02

**Autor:** Kurs-Lab

**Bezug:** [CO-001](../carveouts/CO-001-index-coverage.md) (Bootstrap-Coverage Index-Layer),
[LH-QA-02](../../../spec/lastenheft.md#lh-qa-02--reproduzierbarkeit) (Reproduzierbarkeit — die Tests, die die
Schwelle füllen, sind dieselben, die den Determinismus belegen)

**Schärft:** — (Prozess-ADR ohne Spec-Stratum: Coverage ist eine
Handwerks-Schwelle, kein Vertragspunkt gegenüber einem Abnehmer)

---

## Kontext

`make coverage-gate` und `make coverage-gate-critical` prüfen seit dem
Repo-Bootstrap feste Zahlen: 70 % gesamt, Hochschaltung auf 80 % bei
Meilenstein M2, und auf dem kritischen Layer die Schwelle, die CO-001 als
Vorgabe nennt. Begründet war keine davon.

Dabei war die kritische Schwelle **gedriftet**: CO-001 verlangte 90 %, die
sechs Implementierungen prüften 80 %. Ohne einen Ort, an dem die Zahl steht,
fällt so etwas nicht auf — jede Sprache trug ihre eigene Kopie.

Damit war das Gate nach dem Maßstab, den der Kurs selbst anlegt, **kein Gate,
sondern ein Vorschlag**: Ein Gate braucht eine Anforderung mit ID — aus der
Spezifikation *oder* aus einer ADR — und eine begründete Schwelle
([Kurs Modul 13](../../../../../kurs/de/04-qualitaet/modul-13-quality-gates.md#selbstcheck-rubrik),
Drei Vorbedingungen). Coverage ist im Lastenheft **nicht** geführt — und gehört dort auch nicht hin:
Sie ist kein abnahmebindender Vertragspunkt, sondern eine interne
Prozessmetrik.
Eine erfundene `LH-`ID wäre die schlechtere Lösung gewesen — sie hätte das
ID-Schema aus `MR-000` verletzt und eine Vertragsbindung behauptet, die es
nicht gibt. Also gehört die Begründung in eine ADR.

## Entscheidung

Drei Zahlen, drei Begründungen:

1. **Gesamt-Coverage 70 %, bootstrap-aware.** In der Frühphase ist eine harte
   Schwelle Unsinn; 70 % ist die Stufe, die der vorhandene Testbestand ohne
   Schwellen-Füttern trägt. Die Stufe wird im Make-Target-Kommentar bekannt,
   nicht verschwiegen.
2. **Hochschalt-Trigger M2.** Sobald `slice-013` in `done/` liegt, die
   Property-Suite 100 Generationen läuft **und Welle 2 geschlossen ist**,
   trägt der Testbestand 80 %. Der Trigger ist ein beobachtbares Ereignis im
   Repo, keine Selbstreferenz auf das Gate. Die Anhebung selbst ist dann eine
   **Nachfolge-ADR** mit `Supersedes ADR-0013` — diese ADR legt den Trigger
   fest, nicht schon den neuen Wert.
3. **Kritischer Layer 90 %, dauerhaft schärfer.** Der kritische Pfad ist per
   Definition der, an dem ein Loch teurer ist; seine Schwelle muss über der
   Gesamt-Schwelle liegen, sonst wird das kritische Gate mit dem Hochschalten
   wirkungslos. Der Abstand bleibt deshalb auch nach M2 erhalten (80 / 90).
   Der Index-Layer ist bis zur Auflösung von CO-001 ausgenommen.

## Verglichene Alternativen

### Option A — Coverage als `LH-QA-05` ins Lastenheft

- Pro: Gate bindet an die Spec, keine zusätzliche ADR.
- Contra: Das Lastenheft ist Rang 1 und *vertraglich abnahmebindend*. Eine
  interne Prozessmetrik dort einzutragen weitet den Vertragsbegriff auf etwas
  aus, das kein Abnehmer je prüft.

### Option B — Gar keine Bindung, nur die Zahl im Kommentar

- Pro: Kein neues Artefakt.
- Contra: Genau der Zustand, der diese ADR ausgelöst hat. Beim nächsten
  Aufräumen ist nicht rekonstruierbar, warum 70 und nicht 40 oder 90 — die
  Schwelle wird dann nach Gefühl bewegt.

### Option C — ADR mit den drei Zahlen (gewählt)

- Pro: Die Zahlen haben genau einen Ort, an dem sie begründet sind; die neun
  Build- und Konfigurationsdateien zitieren ihn.
- Pro: Eine Schwellen-Änderung wird damit ADR-pflichtig — sie kann nicht mehr
  still in einer Sprache abweichen.
- Contra: Neun Build- und Konfigurationsdateien müssen den Verweis tragen; eine
  vergessene Sprache fällt nur im Review auf.

## Konsequenzen

- Positiv: `coverage-gate` und `coverage-gate-critical` erfüllen die drei
  Vorbedingungen aus Modul 13 — Anforderung mit ID (diese ADR), begründete
  Schwelle, in lokalem und CI-Lauf identisch.
- Positiv: CO-001 muss die 90 % nicht mehr selbst behaupten, sondern verweist.
- Negativ: Eine Schwellen-Anhebung ist jetzt eine ADR-Änderung — nach
  `Accepted` also eine **neue** ADR mit `Supersedes`. Das ist gewollt.
- Folgepflicht: Der Hochschalt-Trigger M2 muss bei Eintritt tatsächlich
  ausgeführt werden; er steht als Re-Evaluierungs-Trigger unten.

## Fitness Function

| Tooling | Regel | Make-Target |
|---|---|---|
| Coverage-Werkzeug je Sprache | Gesamt-Coverage ≥ 70 % (ab M2: 80 %) | `make coverage-gate` |
| dito, auf den kritischen Layer verengt | Kritischer Layer ≥ 90 %, Index-Layer via CO-001 ausgenommen | `make coverage-gate-critical` |

## Re-Evaluierungs-Trigger

- **M2 erreicht** (Welle 2 geschlossen — `slice-013` in `done/`, Property-Suite
  läuft 100 Generationen): Gesamt-Schwelle auf 80 % heben, diese ADR durch eine
  Nachfolge-ADR mit `Supersedes ADR-0013` ersetzen.
- **CO-001 aufgelöst**: Die Mess-Verengung auf `service` wird auf `service`
  und Index erweitert; ob 90 % dann noch trägt, ist neu zu bewerten.
- **Eine Sprache erreicht eine Schwelle dauerhaft nicht**: Kein stilles Senken,
  sondern Carveout mit Trigger und Folge-Slice.

## Geschichte

| Datum | Ereignis | Verweis |
|---|---|---|
| 2026-06-02 | Proposed | Lab-Ausbau (Kurs-Welle 9); Schwellen unbegründet, kritische Schwelle gegen CO-001 gedriftet |
| 2026-06-02 | Accepted | neun Build-/Konfigurationsdateien zitieren ADR-0013; kritische Schwelle von 80 auf die von CO-001 geforderten 90 korrigiert |
