# Modul 2 — Harness-Bootstrap

> **Aufwand:** ca. 90 Min Lesen · 90 Min Übung. Spiralcurriculum:
> *Harness-Bootstrap*, *GF/BF-Modus* und *Phase-Reife* sind dir aus
> [Modul 1 Mini-Glossar](modul-01-entwicklungszyklus.md#mini-glossar-für-dieses-modul)
> dem Namen nach bekannt — hier werden sie zum Arbeitswerkzeug.

## Optionale Explorations-Vorab-Übung (Kapur-Stil)

Wenn du eine *echte* Productive-Failure-Variante (Kapur 2008, 2014)
ausprobieren willst: **vor** dem Lesen dieses Moduls 20 Minuten ohne
Anleitung klassifizieren.

> **Aufgabe (optional, 20 Min):** Liste drei *Sub-Areas* deines
> aktuellen Repos auf (z. B. *Konventionen*, *Spec-Schreibung*,
> *Test-Infrastruktur*, *Build-Pipeline*, *Architektur-Diagramme*).
> Notiere zu jeder:
>
> 1. *Was führt — Doku oder Code?* (Wenn die Doku führt und der Code
>    folgt: Greenfield-Modus. Wenn der Code führt und die Doku
>    folgt: Brownfield-Modus. Wenn unklar oder gemischt: Hybrid.)
> 2. *Woran erkennst du das?* (Ein konkretes Beobachtungs-Indiz pro
>    Sub-Area.)
> 3. *Wo bist du dir unsicher?* (Was würdest du nachschlagen müssen,
>    um die Klassifikation festzulegen?)
>
> Erfolg ist *nicht*, dass deine Klassifikation richtig ist. Erfolg
> ist, dass du fühlst, wo die Grenze zwischen GF und BF verläuft —
> und an welcher Stelle deine bisherige Intuition unsicher wird.

Nach dem Modul-Lesen: vergleiche deine Klassifikation mit dem
GF-Walkthrough (Worked Example 1) und dem BF-Walkthrough (Worked
Example 2) unten. Reflektiere mit
[`../grundlagen/reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md) —
insbesondere mit Frage 4 (welche Vorstellung von "klarer Modus" wurde
unzufriedenstellend?).

Wenn du keine Zeit hast: überspringen ist okay. Die Worked Examples
tragen das Modul auch ohne Vorab-Übung.

## Engage

Drei Antworten aus drei Projekten auf dieselbe Frage *"Wie war euer
Bootstrap?"*:

- **Greenfield-Erfahrene**: "Lastenheft schreiben, ADR ableiten,
  Konventionen anlegen, dann coden."
- **Brownfield-Erfahrene**: "Den Bestand auseinanderlesen, die
  Diskrepanz zur gewünschten Norm sehen, Reconciliation-Plan
  machen."
- **Skeptiker**: "Bootstrap ist Setup. Das passiert einmal, dann ist
  das System eingeschwungen."

Alle drei sind richtig — aber für unterschiedliche *Sub-Areas
desselben* Repos. Wer das nicht trennt, kommentiert die falschen
Symptome: dem GF-Erfahrenen erscheint jeder BF-Modus als Versagen,
dem Skeptiker erscheint jede Trigger-Klasse als Ritual. Dieser Modul
trennt.

## Lernziele

Nach diesem Modul kannst du:

* GF-, BF- und Hybrid-Modus *unterscheiden* und gegen die vier
  Harness-Linsen *verorten* (Verstehen · konzeptuell),
* dein eigenes Repo nach Modus pro Sub-Area *klassifizieren* und die
  Klassifikation in einer Tabelle *dokumentieren* (Anwenden ·
  prozedural),
* einen beobachteten Auslöser einer der vier Trigger-Klassen
  *zuordnen* und gegen die Phase-Reife des berührten Artefakts
  *spiegeln* (Analysieren · konzeptuell),
* eine Phasen-Karte für ein eigenes Artefakt *erstellen* oder einen
  Reconciliation-Plan für eine konkret beobachtete BF-Diskrepanz
  *entwerfen* (Erschaffen · prozedural),
* den eigenen Bootstrap-Modus pro Sub-Area aktiv *überwachen* und
  Modus-Wechsel als Signal *lesen* (Überwachen · metakognitiv) —
  Bootstrap-Diagnose ist eine Selbstführungs-Praxis, kein
  einmaliges Audit.

## Lab-Bezug

* `harness/conventions.md` und `harness/README.md` (Beispiel im
  Lab unter
  [`../../../lab/example/harness/`](../../../lab/example/harness/) —
  Bootstrap-Quelle für Modus-Deklaration pro Sub-Area).
* Vier Beispiel-Repos in BF-Modus klassifiziert:
  [`../grundlagen/fallstudien.md` §Beobachtung aus dem Ist-Zustand](../grundlagen/fallstudien.md#beobachtung-aus-dem-ist-zustand).

> **TODO-Anker:** Ein dediziertes Bootstrap-Lab folgt in einer
> späteren Welle (geplanter Pfad: unter
> [`../../../lab/example/exercises/`](../../../lab/example/exercises/);
> exakter Dateiname noch offen). Bis dahin sind die Übungen am
> eigenen Repo oder am Beispiel-Repo aus
> [`../../../lab/example/`](../../../lab/example/) durchführbar.

## Themen

* GF/BF/Hybrid-Modus pro Sub-Area: Definition, Abgrenzung gegen
  Repo-Klasse und Phase-Reife.
* Die vier Trigger-Klassen (siehe
  [`../grundlagen/konventionen.md` §Vier Trigger-Klassen](../grundlagen/konventionen.md#vier-trigger-klassen)):
  Pointer, Bestätigung, Diskrepanz, Promotion.
* Phasen-Karte als didaktisches Instrument: sektionsweise
  Reife-Visualisierung eines Artefakts.
* GF-Walkthrough: vom Modus-Beschluss bis zur ersten
  Konventionen-Iteration.
* BF-Walkthrough: Inventur, Diskrepanz-Schock, Reconciliation-Plan,
  Graduation-Trigger.
* Selbstüberwachung des Modus: woran erkenne ich einen Modus-Wechsel
  in der laufenden Arbeit?

## Harness-Einordnung

Bootstrap ist die **initiale Anwendung des Steering-Loops**, laufend
ausgeführt, bis das Repo *steady state* erreicht. Was
[Modul 11 — Verification Harness](../04-qualitaet/modul-11-verification.md)
als laufende Praxis lehrt (Beobachtung → Guide/Sensor → Diff →
Closure), lehrt dieses Modul als *initiale Aufsetzungs-Praxis*:
gleiche Sensoren und Guides, andere Anwendungsphase. Die abstrakte
Verbindung steht in
[`../grundlagen/konventionen.md` §Verbindung zum Steering-Loop](../grundlagen/konventionen.md#verbindung-zum-steering-loop).

Gegen die vier Harness-Linsen aus
[`../grundlagen/konzeptkarte.md`](../grundlagen/konzeptkarte.md):

* **Drift** — Bootstrap ist der erste *Drift-Sensor*: ohne formellen
  Bootstrap bleibt jede spätere Drift unmessbar.
* **Reproduzierbarkeit** — der dokumentierte Modus pro Sub-Area ist
  Voraussetzung dafür, dass ein zweiter Lauf am selben Repo dieselben
  Klassifikationsentscheidungen trifft.
* **Auditierbarkeit** — der Bootstrap-Modus macht die *Begründung*
  jeder Folge-Entscheidung explizit.
* **Steering-Loop** — Bootstrap = initiale Steering-Loop-Anwendung
  (siehe oben).

## Vorab — was hältst du heute für wahr?

*Bevor du die Kernidee liest:* notiere in einem Satz deine spontane
Antwort auf jede dieser drei Fragen.

1. *"Bootstrap — ist das ein einmaliges Setup oder ein laufender
   Modus?"*
2. *"Wenn ein Repo in einer Sub-Area Greenfield ist, gilt das dann
   für das ganze Repo?"*
3. *"Was ist eine Trigger-Klasse — und wozu brauche ich vier davon
   statt einer einzigen 'Bootstrap-Aktion'?"*

Lass die Notiz neben dem Modul liegen. Am Modul-Ende prüft der
Selbstcheck genau diese drei Punkte — und vergleicht mit der scharfen
Konfrontation in §Typische Fehlvorstellungen.

## Kernidee

**Bootstrap ist ein fortlaufender Modus, kein einmaliges Event — und
er gilt pro Sub-Area, nicht pro Repo.** Der Modus ist ein beobachtbares
Verhältnis zwischen Code und Doku, kein Etikett auf dem Repo. Wer den
Modus pro Sub-Area diagnostizieren kann, weiß, *welcher* Trigger die
nächste sinnvolle Aktion auslöst — und spart sich das Ausprobieren auf
der Phasen-Ebene. Genau dieses Diagnose-Vermögen ist das
Lehr-Ergebnis dieses Moduls; die Modus-Wahl als Planungs-Entscheidung
(also: *welcher Modus soll für den nächsten Slice gelten?*) folgt
später in [Modul 5 — Planning Harness](../02-planung/modul-05-planning-harness.md).

## Typische Fehlvorstellungen

* **FV1:** *"Bootstrap ist ein einmaliges Initialisierungs-Event,
  kein laufender Modus."* — Korrektur: Bootstrap ist ein fortlaufender
  Modus, der sich über Sub-Areas und Phasen-Reife entwickelt. Jeder
  Trigger ist ein Bootstrap-Mikro-Event. Wer Bootstrap als Setup
  versteht, übersieht die Modus-Wechsel, die im laufenden Betrieb
  passieren, und produziert daher dauerhaft Findings ohne
  Modus-Bewusstsein.
* **FV2:** *"GF/BF ist eine Eigenschaft des Repos als Ganzes."* —
  Korrektur: Modus gilt **pro Sub-Area**. Ein Repo kann in den
  *Konventionen* BF und in der *Spec-Schreibung* GF sein. Die vier
  Beispiele in
  [`../grundlagen/fallstudien.md` §Beobachtung aus dem Ist-Zustand](../grundlagen/fallstudien.md#beobachtung-aus-dem-ist-zustand)
  zeigen diese Sub-Area-Heterogenität explizit.
* **FV3:** *"Wer im Greenfield arbeitet, kann auf die Trigger-Klassen
  verzichten."* — Korrektur: auch im GF-Modus entstehen Trigger
  (Diskrepanz, Promotion-Auslöser etc.), nur nicht aus
  *Bestandsinventur*, sondern aus *Konsistenzprüfung des neu
  Geschaffenen*. Die vier Klassen gelten in jedem Modus; was sich
  ändert, ist die Frequenz und die typische Auslöse-Quelle.
* **FV4:** *"Brownfield ist eine Notlage, die man möglichst schnell
  überwindet."* — Korrektur: BF ist der *typische* Ausgangspunkt
  realer Repos. Die vier Fallstudien sind alle in BF (siehe oben).
  BF kann systematisch in Richtung GF graduieren — *Graduation* ist
  eine ausgewiesene Bedingung mit Konvergenz-Auftrag, kein
  Wunschdenken. Die Frage ist nicht *ob* graduiert wird, sondern
  *wie weit* das Repo schon ist und *welche Sub-Area* als nächstes
  graduations-reif wird.

(Weitere Fehlvorstellungen ergänzen sich aus der
Konvictions-Check-Ausbeute oben — wer mit "Bootstrap = Setup"
gestartet ist, trägt FV1 implizit.)

## Worked Example 1: Greenfield-Bootstrap (DocSearch-Walkthrough)

(P5 Phase F2 — Schritt 0 bis Schritt 8 als Tabelle mit Progressive
Disclosure; Phasen-Karte als Anschauungs-Visualisierung inline;
Trigger T1–T7 als Inline-Anker mit Rückverweis auf
[`../grundlagen/konventionen.md` §Vier Trigger-Klassen](../grundlagen/konventionen.md#vier-trigger-klassen).)

## Worked Example 2: Brownfield-Bootstrap mit Discovery und Reconciliation

(P5 Phase F2 — Schritt 1 bis Schritt 9 mit Discovery,
Diskrepanz-Schock, Reconciliation-Plan; gleiche
Progressive-Disclosure-Auflage wie Worked Example 1.)

## Übungen

(P5 Phase F3 — drei Übungen, jede gegen genau ein Lernziel
verankert. Trigger-Übung nutzt Alternativ-Vorlage mit
DocSearch-Beispiel-Trigger, weil Modul 2 vor dem ersten Slice liegt.)

## Reflexion

(P5 Phase F3 — Reflexionsfragen nach Vorlage
[`../grundlagen/reflexion-vorlage.md`](../grundlagen/reflexion-vorlage.md);
metakognitive Frage als Träger für das Lernziel
"Überwachen · metakognitiv".)

## Selbstcheck

(P5 Phase F3 — Selbstcheck-Fragen.)

### Selbstcheck-Rubrik

(P5 Phase F3 — kriteriale Rubrik nach Vorlage
[`../grundlagen/selbstcheck-rubrik.md`](../grundlagen/selbstcheck-rubrik.md)
mit Stufen rudimentär · solide · exzellent.)

## Weiterlesen

* Konzept-Anker für alle Bootstrap-Begriffe:
  [`../grundlagen/konventionen.md` §Harness-Bootstrap](../grundlagen/konventionen.md#harness-bootstrap).
* Die vier Beispiel-Repos in GF/BF-Klassifikation:
  [`../grundlagen/fallstudien.md` §Beobachtung aus dem Ist-Zustand](../grundlagen/fallstudien.md#beobachtung-aus-dem-ist-zustand).
* Vorheriges Modul: [Modul 1 — Der Entwicklungszyklus](modul-01-entwicklungszyklus.md).
* Nächstes Modul: [Modul 3 — Lastenheft und Spezifikation](modul-03-lastenheft.md).
