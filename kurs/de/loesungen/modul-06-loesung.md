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

### (Analysieren) Braucht ein Slice, der einen Tool-Pin nachzieht, eine Welle?

**Nein.** Die Begründung läuft über die Closure-Bedingung, nicht über
den Umfang: Der Trigger einer Welle um diesen Slice könnte nur „Pin
aktualisiert, Gates grün" lauten — und genau das steht bereits in der
DoD des Slice. Ein Trigger, der nichts beobachtet, was der Slice nicht
ohnehin belegt, ist Zeremonie. Es fehlt das *Mehr*, also liegt keine
Welle vor.

Der Slice läuft **ohne Welle**. In der Roadmap erscheint er nicht —
weder beim Start noch beim Abschluss; sein Zustand ist die
Verzeichnis-Position (Modul 5), und `ls in-progress/` beantwortet
autoritativ, was gerade läuft.

**Wo der Steering-Loop-Eintrag landet:** im **Beobachtungs-Register**
(`docs/plan/planning/observations.md`) — eingetragen bei der
Slice-Closure, unabhängig von jeder Welle. **Gelesen** wird er bei der
nächsten Welle-Closure (was hat 3× erreicht → verkörpern) — auch für diesen
Slice, obwohl er zu keiner Welle gehört. Erst in einem Repo, das **gar keine**
Wellen schneidet, löst die Slice-Closure den Lese-Schritt selbst aus, und der
Anker lautet `seit slice-<NNN>`. Beide Hälften gehören zur
Antwort — eintragen ohne benannten Leser wäre genau die Ablage, gegen die
das Register gebaut ist. Der Zähler
unterscheidet nicht nach Welle-Zugehörigkeit, sonst zählte er an
wellenloser Arbeit vorbei, und eine Beobachtung, die überwiegend dort
auftritt, erreichte die Schwelle nie. Wer die Antwort „gar nicht" gibt, hat den zweiten Teil der
Regel übersehen: wellenlos heißt nicht wächterlos.

**Typischer Fehlschluss:** „Ein Slice ist zu klein für eine Welle."
Das ist ein Größen-Argument und trifft zufällig richtig. Es versagt
beim Gegenfall — ein einzelner Slice, dessen Abschluss zusätzlich einen
grünen Replay-Lauf gegen das Golden Set verlangt, *ist* eine Welle,
weil diese Bedingung repo-weit ist und in keiner DoD steht.

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

### (Analysieren) Warum steht der Zähler in einer eigenen Datei?

**Weil die Übernahme-Kette bricht.** Die Sektion lag früher *in*
`welle-NN-results.md` und wurde von Closure zu Closure kopiert und
hochgezählt. Drei Bruchstellen: Wer die Übernahme vergisst, setzt den
Zähler auf null; die erste Welle braucht eine Sonderregel; und wer keine
Welle eröffnet, hat gar keinen Träger. Eine stehende Datei streicht alle
drei — sie existiert ab Repo-Beginn.

**Wer einträgt, wer liest:**

| Wer | Wann | Was |
|---|---|---|
| **Slice-Closure** | bei jeder Closure, *vor* dem `git mv` nach `done/` | schreibt: neuer Eintrag mit `BEO-<NNN>` oder Zähler +1 und Beleg |
| **Welle-Closure** | bei jeder Closure | liest: was hat 3× erreicht → verkörpern |
| **Wellen-Eröffnung, Schritt 2** | bei jeder Eröffnung | liest: was steht *unter* der Schwelle und betrifft die Sub-Areas dieser Welle? |

Zwei Leser, nicht einer — der zweite hält die Einträge unterhalb von 3× am
Leben. In einem Repo ohne Wellen-Betrieb übernimmt beide die Slice-Arbeit:
den Lese-Schritt die Closure, den Sichtungs-Schritt die Planung (§8).

Das ist der Punkt, an dem der Zähler **von der Welle unabhängig** wird: Er
läuft mit jedem geschlossenen Slice, auch mit wellenlosen.

**Der Unterschied *gezählt* vs. *verkörpert*** (exzellent): In einem Repo
**ohne Wellen-Betrieb** zählt das Register weiter; den Lese-Schritt löst dann
die Slice-Closure selbst aus, und der Herkunfts-Anker lautet
`seit slice-<NNN>`. Ein Eintrag kann
also bei 3× stehen und trotzdem noch keine Regel sein. Was dann fehlt, ist
nicht der Zähler, sondern der Lese-Schritt. Und die `BEO-<NNN>` macht die
Zählung **unabhängig vom Wortlaut der Bezeichnung**: Ohne Kennung zählt eine
Umformulierung als zweite Beobachtung, und keine der beiden erreicht je 3×.

**Anti-Antwort:** „Ist übersichtlicher." Das ist ein Ordnungsargument. Die
Frage ist mechanisch: Was passiert, wenn niemand die Sektion überträgt?

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

### Welle oder keine Welle — vier Vorhaben (Analysieren — LZ 2)

| Vorhaben | Entscheidung | Die Bedingung über den DoDs |
|---|---|---|
| (a) veralteter Tool-Pin nachziehen | **ohne Welle** | keine — der Trigger schriebe die DoD des Slice ab |
| (b) zweite Zielsprache, drei Slices, die zusammen erst Sinn ergeben | **Welle** | der **Cross-Language-Konformitätslauf** — er vergleicht die neue Sprache gegen die bestehenden und steht in keiner der drei Sprach-DoDs. „Alle drei in `done/`" allein wäre *nicht* das Mehr: das ist bloß die Konjunktion der DoDs |
| (c) Review-Finding, genau eine Korrektur | **ohne Welle** | keine — reaktiv, ein Slice, Trigger wäre Abschrift |
| (d) ein Slice + grüner Replay-Lauf gegen das Golden Set | **Welle** | der Replay-Lauf ist repo-weit und steht in keiner DoD |

Maßstab: Die Begründung nennt in jedem Fall *die Bedingung* — oder
ihr Fehlen. Der häufigste Fehler bei (b) ist, „drei Slices" als Bedingung
auszugeben: Die Konjunktion der DoDs liegt bei *jedem* Mehr-Slice-Bündel
automatisch vor und ist deshalb nie das *Mehr*. Wer bei (b) „drei Slices, also Welle" schreibt und bei (d)
„nur ein Slice, also keine Welle", hat die Slice-Zahl angewandt, nicht
das Kriterium — und liegt bei (d) falsch. Fall (d) ist die Probe: Größe
entscheidet nicht, der Trigger entscheidet.

### Wo landet die Beobachtung? (Analysieren — LZ 2)

**(a)** In `observations.md` bei `BEO-001` den Zähler auf **3×** setzen und
`slice-NNN` in die Belege aufnehmen. In §7 des Slice wird die `BEO-001`
**zitiert**, nicht neu formuliert — sonst zählt das Register zwei Namen
getrennt.

**(b) Nein.** Die Slice-Closure trägt ein, unabhängig von jeder Welle. Genau
dafür steht das Register außerhalb der Welle-Closure.

**(c)** Bis zur nächsten **Welle-Closure** steht der Eintrag bei 3× und ist
**gezählt, aber nicht verkörpert**. Erst ihr Lese-Schritt macht daraus eine
Regel in `AGENTS.md`, einem Gate, einem Skill oder einer `MR-*`, mit
Herkunfts-Anker `seit welle-<NN>`. Wer beides gleichsetzt, hält eine Notiz für
einen Wächter.

**Nicht zu verwechseln — die Achse aus (b) ist eine andere:** Dass *dieser
Slice* zu keiner Welle gehört, heißt nicht, dass das Repo keine Wellen
schneidet. Das `grid-gym`-Repo tut es; seine nächste Welle-Closure liest das
Register und findet den Eintrag, egal aus welchem Slice er stammt. Der Anker
`seit slice-<NNN>` und die Slice-Closure als Lese-Schritt gehören zum
**wellenlosen Repo** — dem Fall, in dem es gar keine Welle-Closure gibt
([Modul 6 §Wann Arbeit eine Welle braucht](../02-planung/modul-06-roadmap.md#wann-arbeit-eine-welle-braucht--und-wann-nicht)).
Wer beides gleichsetzt, verlegt den Lese-Schritt an einen Ort, an dem ihn
niemand ausführt.

Maßstab: Die Antwort trennt *eintragen* (Slice-Closure) von *lesen*
(Welle-Closure) und benennt, dass die Verkörperung am **Lese-Schritt** hängt, nicht am Zähler.

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
