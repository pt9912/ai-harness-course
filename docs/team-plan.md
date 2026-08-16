# Team-Plan — Umsetzung der sieben Anpassungen

**Stand:** 2026-08-16. **Konsument:** wer die Umsetzung fährt — diese und die
nächsten Sessions. Nach Abschluss aller Pakete ist die SOLL-Stufe **entworfen**
aus [`team.md`](team.md) erreicht; dann trägt diese Datei nur noch Historie und
wird auf einen Verweis eingedampft.

**Abgrenzung.** [`team.md`](team.md) sagt **was und warum** — die Befunde
(`TB-*`) und die Anpassungen (`TA-*`) mit ihren *Wo-es-landet*-Tabellen. Diese
Datei sagt **in welcher Reihenfolge, in welchen Paketen, mit welcher
Fertig-Bedingung**. Bei Konflikt über den Inhalt gilt `team.md`; die
Artefakt-Tabellen dort werden hier **nicht** wiederholt (der Zeiger ist kein
Zitat). Die [Roadmap](roadmap.md) behält den Faden mit dem Trigger der zweiten
SOLL-Stufe (*belegt*); dieser Plan ist die Ausarbeitung der ersten.

## Regeln für jede Umsetzung

1. **Additiv, deklariert, rücknehmbar** — die Design-Auflage aus `team.md`
   §Beleglage. Keine Änderung verschlechtert den Ein-Personen-Fall; die
   Bauform ist §Vergabe: Default für einen Schreiber, deklarierte Variante für
   mehrere.
2. **Die Artefakt-Kette läuft immer vollständig:**
   `kurs/de` (Quelle) → `lab/regelwerk` (Spiegel, nach der
   [Schnittregel](regelwerk-extrakt.md)) → `lab/templates` → `lab/example` →
   `kurs/de/loesungen`, wo berührt. Ein Paket ist nicht fertig, solange ein
   Glied fehlt — das ist die Satelliten-Pflicht des Repos.
3. **Closure je `TA`, nicht je Paket:** Eine Register-Zeile in `team.md`
   wechselt auf *umgesetzt (Welle NN)* erst mit dem **letzten** Paket, das die
   Anpassung berührt — TA-2 etwa erst nach P3; P2 hinterlässt dort
   *teilumgesetzt, Rest in P3*. Je Paket gilt: `make check` grün, und der
   CHANGELOG-Eintrag der Welle nennt die `TA`-Kennungen (zitierbar laut
   Register-Deklaration).
4. **Jede Welle ist MINOR** — es kommen Regeln hinzu, nichts entfällt.
   Ausnahme P3: siehe dort.

## Pakete

Zuschnitt nach Abhängigkeit (aus `team.md` §Reihenfolge), nicht nach
Befund-Nummer. Größen: S = ein Abschnitt und Kette, M = mehrere Module,
L = eigener Entscheidungsbedarf.

| Paket | Inhalt | hängt an | Größe |
|---|---|---|---|
| **P0** | Geltungsbereich deklarieren — der IST-Absatz | nichts | S |
| **P1** | [TA-1](team.md#ta-1) Rolleninhaber + [TA-6](team.md#ta-6) Konflikt-Terminal | nichts | M |
| **P2** | [TA-2](team.md#ta-2) Verantwortlich-Feld + [TA-7](team.md#ta-7) Übergang auf dem Hauptzweig | P1 (das Feld benennt einen Rolleninhaber) | M |
| **P3** | [TA-2](team.md#ta-2)-Folge: *Aktuelle Welle* entfällt zugunsten der Ableitung ([TB-014](team.md#tb-014)) | P2 | **L** |
| **P4** | [TA-4](team.md#ta-4) Stand-Deklaration | nichts | S |
| **P5** | [TA-3](team.md#ta-3) Vergabe-Korrekturen (drei Textstellen in §Vergabe) | nichts | S |
| **P6** | [TA-5](team.md#ta-5) Leseordnung + Rückbau-Trigger | nichts | **L** |

P0, P4, P5 sind unabhängig und klein — sie können jede Welle auffüllen.

### P0 — Geltungsbereich deklarieren

Ein Absatz: *Getestet und gelebt ist dieser Korpus mit einem schreibenden
Menschen plus Agenten; die Mehr-Schreiber-Fassung ist entworfen, nicht belegt.*

**Entschieden — der Ort folgt aus dem Leser, und es sind zwei.** Die
Deklaration muss den erreichen, der außerhalb des Getesteten arbeiten würde:
den **Adopter**. Der liest nicht `kurs/de`, sondern das Bundle. Also beide
Enden: der Absatz in `kurs/de/README.md` §Zielgruppe (wo der Kurs sich
beschreibt), **und eine Zeile in `lab/regelwerk/README.md`** — die reist im
Bundle und ist handgeführt, kein Spiegel; sie trägt schon die Stand-Zeile,
also die Selbstauskunft des Artefakts. `grundlagen/begriffe.md` scheidet aus:
Der Geltungsbereich ist kein Begriff, sondern eine Zusage.
**DoD:** beide Absätze; `team.md` §IST verweist darauf, statt das Fehlen zu
beklagen.

### P1 — Rolleninhaber und Konflikt-Terminal

Umsetzung exakt nach den *Wo-es-landet*-Tabellen von TA-1 und TA-6. Beide in
einem Paket, weil TA-6 ohne das Wort nicht formulierbar ist und beide fast nur
Modul 8 berühren.

**Kette:** Modul 8 (drei Stellen) · Modul 5 §Selbstcheck-Rubrik · Modul 10
§Pflege · Modul 4 (ein Satz) → Spiegel (4 Dateien) → `loesungen/modul-05`
und `modul-08` (WIP-Formulierung, Konflikt-Ausgänge) → Templates: keine.
**Wachsamkeit:** Die Lernervorstellung *„Eine Person spielt alle Rollen"*
bleibt unverändert — TA-1 steht daneben, nicht dagegen; der Satz dazu aus
`team.md` §Rolle/Person/Zuweisung gehört in die Quelle mit.

### P2 — Verantwortlich-Feld und Hauptzweig-Übergang

Nach den Tabellen von TA-2 und TA-7. Zusammen, weil TA-7 das Feld überhaupt
erst team-weit sichtbar macht.

**Kette:** `slice.template.md` (Feld neben `Autor:` — **Abgrenzung im
Template-Kommentar**: Autor schreibt den Plan, Verantwortlich hält die Arbeit;
gesetzt bei `open→next`) · Modul 5 §Ziel-Form (der gelehrte Slice-Kopf nennt
das Feld — Quell-Anker, gleiche Logik wie in P6) · Modul 5 (Übergangs-Trigger,
Zeitpunkt des `git mv`)
· Modul 9 §Hard Rules (Zeitpunkt-Zusatz) · §Vergabe (Abgrenzung Ableiten vs.
Beanspruchen, sonst Scheinwiderspruch) → Spiegel → `lab/example`
(nur **neue** Slice-Köpfe — Altbestand bleibt, wie bei Kennungen).
**DoD zusätzlich:** ein Break-Test der Doku-Gates gegen das neue Pflichtfeld,
falls eines es prüfen soll — sonst ausdrücklich *kein Sensor* deklarieren.

### P3 — *Aktuelle Welle* entfällt

Das einzige Paket, das etwas **entfernt**, deshalb eigener Zuschnitt und
eigene Entscheidung vor Beginn:

- Modul 6: §Aktuelle Welle und Closure-Schritt 5 zweite Hälfte (die
  Beförderung) umbauen auf *Offene Wellen* (derivativ) + Ableitung über
  `Welle:`-Feld.
- `roadmap.template.md`: Abschnitt raus, Ersatz rein.
- `lab/example`: Roadmap, `harness/README.md` **und**
  `docs/plan/planning/welle-2-qualitaet.md` — die verlinkt
  `roadmap.md §Aktuelle Welle` per Anker; bleibt sie stehen, meldet
  `example-verify` einen toten Verweis.
- Modul 8 §Rollen-Sequenz für eine Welle: Schritt-5-Zeile anpassen.

**Erste Aufgabe von P3** ist der Zielform-Entwurf des Ersatz-Abschnitts —
bewusst nicht hier vorweggenommen, weil er auf dem `Verantwortlich:`-Feld aus
P2 ruht.

**Entschieden: MINOR.** Die MAJOR-Politik des Repos bindet an
**Asset-Entfernung und Layout-Bruch** — die Datei-Ebene des Bundles
(Präzedenzfälle v2.0.0, v3.0.0: retirte Dateien, umgebautes ZIP-Layout).
Ein Abschnitt *innerhalb* einer Vorlage ist Inhalt, kein Layout; kein Pfad
bricht, kein Asset fehlt. Und für den Adopter, dessen instanziierte Roadmap
den Abschnitt trägt, existiert der geordnete Übergang bereits: Der
Freshness-Audit zeigt das Delta beim Re-Baseline, und Ausgang 5 behandelt
genau den Fall, dass die neue Baseline einem Bestand widerspricht — der
Adopter entscheidet per `MR`, nicht wir per Versionssprung.

### P4 — Stand-Deklaration

Nach der TA-4-Tabelle: drei Sätze in Modul 5/6, eine Quell-Verankerung für die
Lifecycle-Tabelle der Planning-README (behebt damit [TB-012](team.md#tb-012)
mit). Reine Ergänzung, keine Mechanik.

### P5 — Vergabe-Korrekturen

Nach der TA-3-Tabelle: `MR` als Hybrid in die Klassen-Aufzählung, die Welle im
Zählraum beantworten, die Ableitbarkeits-Zusage einschränken. Die
Schema-Frage (Zähler ersetzen) bleibt **ausdrücklich draußen** — sie ist in
der Skizze unter TA-3 abgewogen und wartet auf ein Repo, das sie braucht.

### P6 — Leseordnung und Rückbau

Das teuerste Paket, zuletzt. Nach der TA-5-Tabelle — **deren erste Zeile die
Quelle ist**: Die Pflichtgliederung in `grundlagen/harness-dateien.md` bekommt
die *Leseordnung*-Zeile, bevor das Template die Sektion bekommt; umgekehrt wäre
es Template-Drift, die Klasse aus TB-012. Die deklarierte Grenze gilt: Bestand
verkleinern ist nicht Gegenstand.
**Entschieden: ab Einführung, kein Nachrüsten.** Der Korpus hat für exakt
diese Frage einen Präzedenzfall — den Herkunfts-Anker:
*„Bestehende Regeln haben keinen rekonstruierbaren Ursprung mehr; `seit
unbekannt` wäre eine Harness-Lüge. Der leere Zustand ist die ehrliche
Information."* Dasselbe gilt vorwärts: Ein nachgetragener Auflösungs-Trigger
für eine alte Hard Rule wäre erfunden, nicht rekonstruiert. Also: Pflicht für
**neue** Hard Rules und Skill-HIGH-Einträge, Altbestand bleibt ohne — und darf
per deklariertem Backfill nachgezogen werden, wo jemand den Trigger wirklich
herleiten kann (Präzedenz: der `Schärft:`-Backfill im ADR-Index des
Beispiels).

## Wellen-Vorschlag

**Vier Wellen, Nummern erst bei der Registrierung** — die Zählung ist im
CHANGELOG kanonisch, und zwischenrein kann anderes landen:

| | Pakete | Bemerkung |
|---|---|---|
| 1. | P1 + P0 | Vokabular zuerst; P0 füllt auf — **umgesetzt als Welle 76** |
| 2. | P2 + P4 | Feld und Sichtbarkeit; P4 füllt auf |
| 3. | P3 | allein, wegen der Entfernungs-Entscheidung |
| 4. | P5 + P6 | Abschluss; danach Register-Abgleich in `team.md` und SOLL-Stufe *entworfen* im CHANGELOG festhalten |

Der Vorschlag ist Reihenfolge, kein Terminplan — jede Welle schließt durch
ihre Kette und `make check`, nicht durch ein Datum.
