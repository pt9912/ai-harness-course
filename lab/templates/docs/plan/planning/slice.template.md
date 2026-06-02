# Slice <slice-id>: <Titel>

> **Template-Hinweis.** Vorlage für einen Slice-Plan. Kopiere nach
> `docs/plan/planning/open/slice-<NNN>-<kurzer-titel>.md` und ersetze
> Platzhalter. Lösche diesen Block.

**Status:** open → next → in-progress → done (Datei wird durch die
Verzeichnisse bewegt, siehe
[Kurs Modul 4](../../../../../kurs/de/02-planung/modul-04-planning-harness.md)).

**Welle:** <welle-id> oder "ohne Welle" (Wartung/Spike).

**Bezug:** `<LH-FA-NN>`, `<LH-QA-NN>`, ADR-<NN>.

**Autor:** <Name>. **Datum:** YYYY-MM-DD.

---

## 1. Ziel

<!--
Was liefert dieser Slice in einem Satz? Liefer-Fokus, kein "wir
machen aufräumen".
-->

<…>

## 2. Definition of Done

<!--
Was muss erfüllt sein, damit der Slice in done/ wandert?
Liste mit jeweils prüfbarem Kriterium.
-->

- [ ] LH-FA-<NN> erfüllt, Test referenziert.
- [ ] LH-QA-<NN> erfüllt, Messung dokumentiert.
- [ ] `make gates` grün.
- [ ] Doku-Update für <Schnittstelle X> falls öffentlicher Vertrag berührt.
- [ ] Closure-Notiz mit Steering-Loop-Lerneintrag.

## 3. Plan (vor Code)

<!--
Welche Änderungen sind geplant? Datei- oder Komponenten-Ebene reicht.
Der Implementation-Agent erweitert diese Liste in seinem ersten Lauf.
-->

| Datei / Komponente | Änderungs-Art | Begründung |
|---|---|---|
| <…> | neu / update / refactor | <…> |

## 4. Trigger

<!--
Wann beginnt dieser Slice? (next → in-progress)
Beispiele: "Wenn Welle X done." / "Wenn Carveout CO-NN aufgelöst."
-->

<…>

## 5. Closure-Trigger

<!--
Wann ist der Slice done?
"DoD vollständig + PR gemerged + Closure-Notiz geschrieben."
-->

<…>

## 6. Risiken und offene Punkte

<!--
Was könnte schief gehen? Welche Carveouts entstehen ggf.?
-->

- <…>

## 7. Closure-Notiz (nach `done/`)

<!--
Wird *nach* Abschluss ergänzt. Inhalt:
- Was hat funktioniert?
- Was ging anders als geplant?
- Steering-Loop-Eintrag: welcher Guide/Sensor sollte verbessert werden?
- Folge-Slices: welche neuen open/-Einträge?
-->

<!-- Erst nach Abschluss füllen. -->
