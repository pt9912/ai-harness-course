# Lösung — Modul 6: Roadmap Engineering

Zugehöriges Modul: [Modul 6 — Roadmap Engineering](../02-planung/modul-06-roadmap.md).

## Selbstcheck-Antworten

### (Erinnern) Welche drei Bestandteile braucht ein Welle-Eintrag minimal?

1. **Slice-IDs** — die Inhalte der Welle, jeweils mit `LH-*`/`HSM-*`-Bezug.
2. **Trigger** — beobachtbare Bedingung für Start/Closure (z. B. "ADR-7
   akzeptiert", "Replay grün gegen Golden Set v2"). *Kein Datum.*
3. **Closure-Kriterien** — was muss erreicht sein, damit die Welle als
   *done* gilt (alle Slices in `done/`, Replay grün, Closure-Einträge
   geschrieben).

Ein Datum darf in der Roadmap *erwähnt* werden — als Prognose,
nachdem die Wellen geschnitten sind. Sobald das Datum zum Trigger wird,
kappt die Welle halbfertige Slices am Kalendertag und das
Auditierbarkeits-Versprechen bricht: in `done/` landen dann Slices,
deren DoD nur "wegen Datum" akzeptiert wurde.

Falle: Wer eine Welle nur über "Slice-Liste" und "Datum" definiert, hat
keinen Welle-Eintrag, sondern einen Sprint. Sprint ist legitim — aber
dann gehört das in eine separate operationale Ebene, nicht in die
Roadmap.

### (Erinnern) Drei Beispiele für beobachtbare Trigger aus diesem Modul

Aus den Engage-/Fehlvorstellungs-Blöcken des Moduls:

1. *"SL-024 liegt in `done/`."*
2. *"Replay-Lauf gegen Golden Set grün."*
3. *"Carveout `CO-007` aufgelöst."*

Was die drei gemeinsam haben — und was sie von "bis Ende Juli" oder
"sobald wir Zeit haben" unterscheidet: Ein Trigger ist beobachtbar,
wenn ein *anderer* Mensch ohne Rückfrage sagen kann, ob er
eingetreten ist. Alle drei sind Repo-Zustände (Verzeichnis, Gate,
Carveout-Status), keine Prognosen. Ein Datum ist keine Beobachtung,
sondern eine Hoffnung mit Ziffern.

### Was tust du, wenn eine Welle 30 % über der Schätzung liegt — neu schneiden, neu planen oder Carveout?

Diagnose *vor* Aktion — es kommt darauf an, *warum* die Schätzung
daneben lag. Drei Diagnosen, drei Antworten:

1. **Slice-Größe** (einzelne Slices waren zu groß geschnitten, "ein
   Lauf, eine Review-Sitzung" nicht haltbar): → **Neu schneiden.**
   Die übergroßen Slices gehen zurück zur Zerlegung
   (`in-progress → next`), die Welle behält ihren Scope, aber in
   kleineren Einheiten.
2. **Reihenfolge/Abhängigkeit** (Slices blockieren sich, eine
   Voraussetzung kam zu spät): → **Neu planen.** Die Welle bekommt
   eine korrigierte Reihenfolge bzw. einen expliziten
   Abhängigkeits-Trigger; ggf. wandert ein Slice in eine spätere
   Welle.
3. **Unerwartete Komplexität in einem Punkt** (Rest läuft): →
   **Carveout** für die problematische Stelle mit Auflösungs-Trigger;
   die Welle kann mit offen reduziertem Versprechen schließen.

Verfeinerung (exzellent): 30 % *früh* in der Welle sind eher ein
Steering-Loop-Signal an die Slice-Sizing-Regel (neu schneiden lohnt
noch); 30 % *spät*, kurz vor Welle-Closure, sprechen eher für einen
Carveout — neu schneiden würde nur noch Buchhaltung erzeugen.

Metakognitiv gehört dazu, *eine* Annahme zu benennen, die beim
Schätzen schon "weich" war (z. B. "Bibliothek X liefert das schon" —
ungeprüft übernommen). Das ist das Steering-Signal für die nächste
Schätzung: woran hätte man die Abweichung früher erkannt?

Anti-Antwort: "Wir biegen die Schätzung gerade." Das macht den Steering
Loop unbrauchbar — wenn Schätzungen sich an Realität anpassen statt
umgekehrt, lernst du nichts über deine Schätzungsqualität.

### Was unterscheidet eine Welle von einem Meilenstein?

- **Welle** — ein Bündel paralleler/serialisierter Slices mit
  Closure-Kriterien. Sie endet *durch* Closure (alle Slices in
  `done/`, Replay grün, Closure-Einträge geschrieben) — eine interne,
  im Repo vollständig beobachtbare Bedingung.
- **Meilenstein** — ein *extern* beobachtbarer Zustand an einer
  Außengrenze (Audit-Punkt, Release, Kundenabnahme). Er endet durch
  Datum oder externe Bestätigung, nicht durch Repo-interne Closure.

Die beiden verhalten sich orthogonal: Der Meilenstein liegt *neben*
der Welle, nicht in ihr — der Audit-Termin ist Meilenstein M3, nicht
Welle 3. Und genau deshalb leitet sich der Meilenstein aus Wellen ab,
nie umgekehrt: Wenn das Meilenstein-Datum gehalten werden muss, die
Closure-Trigger aber nicht erreichbar sind, ist die Antwort ein
Carveout (Modul 7) — nicht ein halb fertiges `done/`.

### (Analysieren) Drei grid-gym-Ereignisse Welle/Meilenstein/Release zuordnen

Zuordnung mit Trigger und Begründung pro Ereignis:

- **(a) Wave-Self-Close-Commit** → **Welle.** Trigger: die
  Closure-Kriterien sind erfüllt — alle Slices der laufenden Welle in
  `done/` *und* die 10 A-1-Pflicht-Gates in `make gates` grün.
  Begründung: das Ereignis ist eine rein *interne* Closure, die
  vollständig im Repo beobachtbar ist (der Self-Close-Commit ist ihr
  Beleg); keine Außengrenze beteiligt.
- **(b) "Simulator läuft deterministisch reproduzierbar" erstmals
  extern vorzeigbar** → **Meilenstein.** Trigger: ein extern
  beobachtbarer Repo-Zustand — die `determinism`/`replay`-Suiten
  laufen vollständig grün und der Zustand kann an einer Außengrenze
  gezeigt werden. Begründung: hier endet nichts durch interne
  Closure; der Wert des Ereignisses liegt in der *externen
  Bestätigbarkeit*, nicht im Schließen eines Slice-Bündels.
- **(c) Versions-Tag + Paket nach Staging** → **Release.** Trigger:
  ein Artefakt *verlässt das Repo* in eine Umgebung (Tag gesetzt,
  Deployment nach Staging). Begründung: weder Closure-Kriterium noch
  Außenbestätigung, sondern eine Auslieferung — die dritte,
  eigenständige Kategorie.

Pointe über die Orthogonalität (exzellent): Ein Release kann mehrere
Wellen umfassen, der Meilenstein liegt *neben* der Welle, die Welle
endet *durch* Closure — deshalb kann (b) eintreten, ohne dass (a)
oder (c) am selben Tag liegen. Wer die drei in eine einzige
"Fertig"-Leiter sortiert, hat die Kategorien auf eine Zeitachse
plattgedrückt.

Anti-Antwort: Trigger "ist halt fertig" — das benennt keinen
beobachtbaren Auslöser und macht die Zuordnung beliebig.

### (Erschaffen) Ersten Wellen-Eintrag aus `SL-101`/`SL-102`/`SL-103` entwerfen

```text
## welle-1-api-mit-cache
Slices:   SL-101 (Such-API), SL-102 (Query-Cache mit TTL, konsumiert SL-101)
Trigger:  startet, sobald ADR-Cache-Strategie (Read-through vs. Look-aside)
          akzeptiert ist  ← beobachtbarer Zustand, kein Datum
Closure:  Replay gegen Golden Set grün UND SL-101+SL-102 in done/
Nicht in dieser Welle: SL-103 (Dashboard)
```

Begründung der Bündelung: `SL-102` braucht die von `SL-101` gelieferte
API — getrennt liefert keiner der beiden prüfbaren Wert, erst zusammen
ist ein Replay-Closure-Kriterium überhaupt formulierbar. Sie teilen sich
also *ein* Closure.

Gegenprobe, warum `SL-103` *nicht* hineingehört: ein Dashboard über
einer Suche ohne Cache zeigt keinen Mehrwert, den diese Welle belegen
soll (Latenz-Gewinn durch Cache). `SL-103` zieht in die *nächste* Welle,
sobald deren Trigger eintritt: "`welle-1-api-mit-cache` in Closure, Cache
liefert messbare Trefferquote". Der Trigger ist so formuliert, dass ein
Dritter ohne Rückfrage über "Welle fertig" entscheiden kann.

### (Analysieren) Abhängigkeit Welle 3 → Welle 2 modellieren und Blocker erkennen

Die Abhängigkeit gehört als *expliziter Abhängigkeits-Trigger* in die
`Trigger`-Spalte von Welle 3 — nicht als bloße Reihenfolge-Notiz:

```text
## welle-3-skalierung
Trigger:  startet, wenn welle-2-qualitaet in Closure
          (Property-Tests grün, Coverage-Critical-Gate steht)
```

Plus eine gerichtete Kante `welle-2-qualitaet → welle-3-skalierung` im
Abhängigkeitsgraphen.

Wann wird Welle 2 zum *Blocker* (nicht bloß Vorgängerin)? Test: Würde
Welle 3 *jetzt* starten, liefe ihr Skalierungs-Gate auf nicht-property-
getesteter Basis — die Skalierung würde Last auf Code legen, dessen
Korrektheit Welle 2 erst absichert. Genau dann ist Welle 2 eine *harte
Kante*: ohne ihre Closure ist Welle 3 eine Phantom-Welle. Eine reine
Vorgängerin *ohne* solche harte Kante (Welle 3 könnte technisch auch
ohne sie laufen) wäre kein Blocker, nur eine Sortier-Präferenz.

## Übungshinweise

### Nachgeholter Schritt 7: Bewusstes Brechen (Fehlerfall-Übung)

Wer das Worked Example übersprungen hat, holt vor den Übungen dessen
Schritt 7 nach — die einzige Fehler-Provokation des Moduls: einen
Closure-Trigger absichtlich als Datum schreiben und am Stichtag (bei
nicht-grünem `slice-019`) beobachten, was passiert. Erwartung: Eine
der drei Diagnosen aus der Schritt-7-Tabelle tritt ein — Welle wird
trotzdem geschlossen (Datum hat Closure überschrieben, Audit fällt
durch), Welle bleibt offen und das Datum verschiebt sich (Disziplin
wirkt, aber die Drift-Tabelle braucht den Eintrag) oder Carveout
`CO-009` mit Folge-Slice (sauber: Versprechen offen reduziert). Nur
die dritte Antwort hält Trigger-Disziplin *und* Termin-Realität
zusammen. Für die Reflexion festhalten, welche Antwort dein erster
Impuls war.

### Aufbau einer produktiven Roadmap für das Begleit-Lab

Maßstab:

- Mindestens drei Wellen, davon mindestens eine mit klar nachgelagerter Abhängigkeit ("Welle 2 startet erst, wenn Welle 1 done").
- Jede Welle hat einen *Trigger* (was muss vorher passiert sein) und einen *Closure*-Trigger (was muss erreicht sein, damit sie als done gilt).
- Jeder Slice in jeder Welle hat eine LH-/HSM-/GG-ID-Referenz (siehe [ID-Schema](../grundlagen/konventionen.md#id-schema-als-klammer)).
- Mindestens ein expliziter "Wir-tun-X-nicht-in-dieser-Welle"-Eintrag pro Welle. Negativ-Scope ist Roadmap-Disziplin.

Vergleich-Möglichkeit: [`/lab/example/docs/plan/planning/in-progress/roadmap.md`](../../../lab/example/docs/plan/planning/in-progress/roadmap.md)
(im Lab nach Phase B).

### Modelliere eine Abhängigkeit, die eine spätere Welle blockiert

Beispielszenario: Welle 2 ("LLM-gestützter Replay-Diff-Reporter")
braucht ein in Welle 1 definiertes Trace-Format. Wenn Welle 1 das
Trace-Format ändert, blockiert sie Welle 2.

Modellierung:

- Welle 2 deklariert in ihrem Plan: `Voraussetzung: Welle 1, Trace-Format-Vertrag (ADR-7)`.
- ADR-7 dokumentiert den Vertrag und nennt Welle 2 als Konsument.
- Wenn Welle 1 das Format ändern muss, ist das ein ADR-Update (ADR-7 superseded), und Welle 2 *muss* angepasst werden — als eigener Slice in Welle 2 oder als Carveout.

### Welle über Schätzung bewerten (Bewerten — LZ 3)

Maßstab für eine gute Bewertung:

- Die **Diagnose steht vor der Aktion**: Slice-Größe (→ neu
  schneiden), Reihenfolge/Abhängigkeit (→ neu planen) oder
  unerwartete Komplexität (→ Carveout). Wer mit der Aktion beginnt
  ("wir carven das aus"), hat bewertet, ohne zu diagnostizieren —
  die volle Entscheidungs-Matrix steht oben in der
  Selbstcheck-Antwort zur 30-%-Frage.
- Die Entscheidung ist *begründet* gegen die Diagnose, nicht gegen
  den Termindruck.
- Der metakognitive Schluss ist Pflichtteil: *eine* Annahme benennen,
  die beim Schätzen schon "weich" war. Das ist kein Schuldbekenntnis,
  sondern das Steering-Signal, das die nächste Schätzung kalibriert.

Anti-Antwort: "Mehr Zeit geben." — verschiebt die Abweichung, ohne
ihre Ursache zu klassifizieren; beim nächsten Mal sind es wieder
30 %.

## Häufige Fehler

- **Roadmap als Datums-Versprechen verstehen.** Datum ist Folge der Wellen, nicht ihr Treiber. Wenn du Termine fest schreibst und Scope variabel hältst, lieferst du Scope-Kompromisse statt Lieferversprechen.
- **Wellen ohne Closure-Trigger.** "Welle ist done, wenn alle Slices done sind." Tautologie, kein Trigger. Was ist die *Beobachtung*, die das System grün meldet?
- **Implizite Abhängigkeiten zwischen Wellen.** Wenn die Reihenfolge "ist halt logisch", wird die Reihenfolge bei Druck umgekehrt — mit Folgen. Abhängigkeit gehört explizit in den Plan.

## Verweise

- Slice-Lifecycle: [Modul 5](../02-planung/modul-05-planning-harness.md)
- Vorherige Lösung: [Modul 5](modul-05-loesung.md)
- Nächste Lösung: [Modul 7](modul-07-loesung.md)
