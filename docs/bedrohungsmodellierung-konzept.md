# Bedrohungsmodellierung — Konzept

**Stand:** Konzept-Entwurf, **nichts umgesetzt**. Kein Kurs-, Regelwerk-,
Template- oder Beispiel-Text berührt; diese Datei und ein Verweis in der
[Roadmap](roadmap.md) sind das gesamte Ergebnis. Die Entscheidungen E1–E6 unten
sind offen. Belegt ist der Befund (§1) gegen den Korpus-Stand von `2f30660`.

Dieses Dokument beantwortet drei Fragen: **Fehlt das Thema?** (Befund) —
**Wo gehört es im Prozess hin?** (Einordnung) — **Was wäre zu tun, und was ist
noch zu entscheiden?** (Plan). Es ist ein Plan-Dokument im Sinn von
[`kennungs-namen-plan.md`](kennungs-namen-plan.md), kein Kurstext.

## 1. Befund — was der Korpus heute trägt

Gesucht wurde breit nach *Threat*, *Bedrohung*, *STRIDE*, *Angriffsfläche*,
*Sicherheit*, *Security* und *Vertrauensgrenze*. Die Tabelle führt die
tragenden Fundstellen; weitere Treffer sind Randbelege (Modul 13 nennt die
„Vertrauensgrenze“ nur als das, was der Typecheck nicht sieht, und führt Critical
Coverage für den Sicherheitspfad; Modul 16 nennt Injection als Fehlannahme; Modul 15 führt die Cache-Hit-Rate auch als Sicherheits-Metrik; Modul 11 verlangt den Rot-Beleg bei sicherheitskritischen Fixes — alles Erkennung und Beleg, keine Methode).

| Stelle | Was dort steht | Reicht das für Threat Modeling? |
|---|---|---|
| [Modul 13](../kurs/de/04-qualitaet/modul-13-quality-gates.md) §Drei Entgleisungen | „Statt der beobachteten Lücke wird ein Bedrohungsmodell abgearbeitet“ — Gegenpol, **nur für die Härtung eines Wächters** | nein: Abgrenzung, keine Methode |
| Modul 13, Security-Gate | Security als Gate-Klasse | nein: statische Analyse (Datenfluss-Befund, Secret-Treffer), keine Methode zum Entwurf |
| [Modul 10](../kurs/de/04-qualitaet/modul-10-review-harness.md) | Sicherheits-Verstoß ist ein HIGH-Finding, das den Merge blockiert | nein: Prüfung gegen ein Muster-Maßstab (Reviewer-Skill: „Sicherheits-Anti-Pattern: Injection, fehlende Auth-Prüfung“), nicht gegen eine Anforderung |
| [Modul 16](../kurs/de/05-betrieb/modul-16-produktiver-betrieb.md) | Lernziel: Prompt-Injection-**Symptome aus Telemetrie erkennen**; „Sicherheitsprüfungen (Prompt Injection, Tool-Abuse, Data Exfiltration)“ steht nur als Stichwort | nein: Erkennung im Betrieb, nicht Entwurf |
| [Modul 14](../kurs/de/05-betrieb/modul-14-docker-harness.md) | „Angriffsfläche minus ~90 %“ als Härtungsargument der Runtime-Stage | nein: Argument, kein Modell |
| `lastenheft.template.md` §4 | `LH-QA-02 — <Sicherheit>` als leerer Platzhalter mit Anforderung und Messmethode | Platz ist da, ein Weg dorthin nicht |

**Ergebnis:** Security-*Erkennung* (Review, Gate, Telemetrie) ist vorhanden. Die
Methode, aus der eine Sicherheitsanforderung und eine Entscheidung *vor dem
Code* entstehen, fehlt. Ein Reviewer kann „Sicherheit“ als HIGH melden, aber der
Maßstab liegt nur auf Muster-Ebene (Anti-Pattern im Reviewer-Skill). Es fehlt der
Maßstab auf **Anforderungs-Ebene**: `LH-QA` bleibt beim Platzhalter.

## 2. Einordnung im Prozess

Threat Modeling ist Entwurfsarbeit **vor** dem Code. Es ist **kein viertes
Spec-Stratum**: Die Decken-Regel
([`referenz-richtung.md` §Referenz-Richtung (SDP)](../kurs/de/grundlagen/referenz-richtung.md#referenz-richtung-sdp-wer-darf-wen-referenzieren))
lässt das Lastenheft nur `LH-*` untereinander referenzieren, und die beiden
anderen Straten zeigen nie auf ADR oder Slice. Ein Register als Stratum würde
dieses Ordnungsprinzip aufweichen.

Die Kette. Zwei verschiedene Dinge, die nicht dieselbe Pfeilart tragen:

```
Prozessfluss (wer schreibt wann)
  Bedrohung ──▶ LH-QA-Sicherheit        erstmals beim Schreiben des Lastenhefts,
                                          danach nur per Change Request (Version-Bump)

Referenzkanten (wer darf wen nennen — Richtung der Matrix, immer aufwärts)
  Sicht (ARC-*)  ──Use-Case ↔ Vertrags-ID──▶ LH-QA        (offen: E5)
  ADR            ──Normativ: LH-*-Grundlage─▶ LH-QA
  ADR            ──Schärft:─────────────────▶ ARC-* / SPEC-*
```

Die ADR bekommt ihren Bezug zur Bedrohung **nur über die `LH-QA`**, die die
Bedrohung gestellt hat: Sie darf das Bedrohungsregister nicht nennen (die Matrix
führt keine Register-Klasse, E2), nur die Anforderung und die Sicht-/Technik-
Stelle, die sie schärft. Was die ADR zur Bedrohung selbst sagt, steht in ihrem
Kontext-Abschnitt und nicht in einem Verweis.

- **`LH-QA`** formuliert eine *Eigenschaft*, die man prüfen kann („kein Zugriff X
  ohne Y“), nicht die Bedrohung. Bedrohungen sind Hypothesen und gehören nicht in
  den Vertrag.
- **Architektur-Sicht**: Vertrauensgrenzen und Datenflüsse sind Komponenten- und
  Abhängigkeitssicht und gehören in die Sicht. Ob sie dabei eigene `ARC-*`
  bekommen, ist **offen** (E5): Der Kurs vergibt `ARC-*` für „Komponente oder
  Schnittstelle“. Die Sicht ist sprach- und
  meilensteinfrei und führt **keine Historie** — ein Minderungsstatus
  („gemindert“) hat dort keinen Platz.
- **ADR**: Die Entscheidung, *wie* eine Bedrohung gemindert oder das Restrisiko
  akzeptiert wird, ist der klassische ADR-Fall. Die ADR deklariert `Schärft:`;
  die Sicht nennt die ADR nie.
- **Kein Spec-Dokument verweist auf das Bedrohungsregister.** Das folgt
  *analog* aus der Decken-Regel (alle drei Spec-Zeilen der Matrix sind ❌ gegen
  ADR, Slice, Carveout, Welle, Roadmap), ist für das Register aber **nicht
  belegt**: Die Matrix führt keine Register-Klasse, die ❌ decken nur die dort
  geführten Klassen (E2).

**Wer verweist auf das Register?** Offen — siehe E2. Die Referenz-Matrix kennt
keine Register-Klasse; eine ADR darf dort weder auf Welle-Artefakte noch auf
Roadmap zeigen, und bei Slices ist nur Kontext erlaubt. Eine Aussage der Form
„nur von Slice, Welle und ADR aus referenzierbar“ ist deshalb **nicht** durch die
Matrix gedeckt. Die Frage hängt an E6: Ein **Sicht-Peer-Dokument** trüge die
Spec-Straten-Regeln des Stratums und bräuchte keine neue Matrix-Klasse.

## 3. Abgrenzung

**Gegenüber Modul 13 (Wächter-Härtung).** Modul 13 sagt: Ein Wächter wird auf
*Beobachtung* gehärtet, nicht auf ein Modell. Das bleibt richtig und bindend
([Worked Example B](../kurs/de/04-qualitaet/modul-13-quality-gates.md#worked-example-b-guard-härtung-als-steering-loop-am-wächter)).
Die Abgrenzung für das neue Thema: Das Bedrohungsmodell speist die
**Produkt-Anforderung** (`LH-QA`, Sicht, ADR). Für den **Wächter** liefert es
höchstens *Kandidaten*; gehärtet wird weiter erst nach Beobachtung. Modul 13 ist an der
Stelle **ausdrücklich auf die Wächter-Härtung begrenzt** („Welle 1 ‚gleich
richtig‘ bauen wollen“); es entsteht daher kein Widerspruch, höchstens ein
Missverständnisrisiko, wenn ein späteres Modul das Bedrohungsmodell einführt.
Ein klärender Halbsatz in Modul 13 ist sinnvoll, kein Muss.

**Gegenüber Modul 16.** Modul 16 behandelt die *Erkennung* von
Injection-Symptomen in der Telemetrie. Ein Bedrohungsmodell des Harness
(Prompt-Injection über Repo-Inhalte, Agent-Rechte, Container) überschnitte sich
dort und müsste dessen Fundstellen benennen — siehe E3.

## 4. Offene Entscheidungen

| | Frage | Stand der Abwägung |
|---|---|---|
| **E1** | **Register-Form** — Verzeichnis je Bedrohung oder eine Tabelle in einer Datei? | Das Beobachtungs-Register ([Modul 6](../kurs/de/02-planung/modul-06-roadmap.md#das-beobachtungs-register)) trägt drei Lebensdauern (unveränderliche Identität, veränderlicher Zustand, unveränderliche Belege je Auftreten) und einen **abgeleiteten Zähler mit 3×-Auslöser**. Bei Bedrohungen gibt es keinen Zähler und keinen 3×-Auslöser; „Evidence“ wäre ein Minderungs-Beleg, die Ausgänge (gemindert · akzeptiert · offen) sind andere. Das Verzeichnis lohnt sich nur, wenn Identität unveränderlich bleiben soll, während sich der Status ändert. Sonst genügt die Tabelle. Beide Formen wären eine **eigene Artefaktklasse im Planning-Baum** (neben `observations/`), mit eigener Zeile im Planning-README-Template, in Modul 6 und in `harness-dateien.md`. Ob es überhaupt ein Register braucht und wo es liegt, ist E6. |
| **E2** | **Matrix-Klasse** — Wer darf das Register referenzieren, und worauf zeigt es? | Das Register braucht Zeile und Spalte in der Referenz-Matrix (Quelle: `referenz-richtung.md`). Ohne sie bleibt jede Aussage über Verweise ungedeckt. Das Beobachtungs-Register steht ebenfalls nicht in der Matrix und ist **kein** Präzedenzfall. |
| **E3** | **Harness-Bedrohungsmodell** — eigene Folge-Welle? | Ein anderes Modell als das des Produkts (Angreifer, Grenzen, Assets sind andere). Überschneidet sich mit Modul 16; darf Wächter nur als Kandidaten speisen (§3). Erst nach der Produkt-Welle. |
| **E4** | **Reviewer-Zeile** | Nur spiegelbar, wenn Modul 10 sie zuerst trägt (Quelle vor Spiegel). Eine zusätzliche DoD-Zeile im Slice wäre doppelt — **nach dem Ist-Zustand der Vorlage** (`slice.template.md` fordert `LH-QA` mit Messung); im Kurs (Modul 5) fand sich keine entsprechende Zeile, der Satz begründet also nichts für den Kurs. |
| **E5** | **Kennungen im neuen Sicht-Abschnitt** | Quelle ist `source-precedence.md` §ID-Schema: `ARC-<NNN>` ist die Struktur-ID für **Komponente oder Schnittstelle**; die Vorlage führt das aus (auch der Berührungspunkt zu einem externen System trägt eine `ARC-*`). Eine Vertrauensgrenze **an einer Schnittstelle** trägt also schon heute eine Kennung. Offen ist, ob eine Grenze oder ein **Datenfluss ohne eigene Schnittstelle** eine bekommt: Entweder der Abschnitt trägt **keine neuen IDs** und verweist auf bestehende `ARC-*`, oder die Regel des ID-Schemas wird erweitert. Auch zu klären: Worüber die Sicht auf `LH-QA` zeigt — die Matrix kennt Sicht→Vertrag nur als „Use-Case ↔ Vertrags-ID“, ein Grenz-Abschnitt hätte ohne Use-Case keinen formalen Anker. |
| **E6** | **Ablage und Scope** | (a) *Ob und wo:* ein **Sicht-Peer-Dokument** (z. B. ein `threat-model.md` neben `architecture.md`; `referenz-richtung.md` ordnet Zusatzdokumente wie `deployment.md` und Sequenz-Views dem Stratum Sicht zu) trüge die Regeln des Stratums und bräuchte weder Matrix-Klasse noch neue Artefaktklasse — es wäre aber derivativ und führte weder Status noch Historie, also **kein Bedrohungsregister mit Ausgängen**. Ein Register mit Ausgängen (gemindert · akzeptiert · offen) ist Planungsstand und gehört nach `planning/`. Beides zugleich ist möglich: Die *Sicht* der Grenzen im Spec-Stratum, der *Stand* im Register. (b) *Scope:* Lehrt ein Harness-Kurs Produkt-Threat-Modeling, oder nur, wie ein Harness es **aufnimmt**, wenn ein Repo es betreibt? Die Roadmap-Disziplin verlangt hier die Gegenprobe der Folgerung, nicht nur der Behauptung. |

**Methode:** STRIDE nur als Denkhilfe in der Vorlage, nicht als Pflicht. Der Kurs
lehrt das Prinzip (Grenze → Bedrohung → Ausgang) werkzeug-agnostisch.

## 5. Plan — falls der Faden dran ist

**Reihenfolge nach Rangfolge** (`AGENTS.md` §1): Kurs → Regelwerk-Spiegel
(wortgleich, netzlos, keine Beispiel-Auszüge) → Vorlagen → Beispiel.

1. **Kurs.** Modul 3 (Architektur-Sicht: Vertrauensgrenzen; `LH-QA`-Sicherheit
   als Eigenschaft), Modul 4 (Worked Example Bedrohung → ADR), Modul 13
   (optionaler Halbsatz zur Abgrenzung). Je nach E1/E2/E6 zusätzlich Modul 6,
   `harness-dateien.md` und `referenz-richtung.md`. Ein neues Worked Example
   trägt seine Lernziel-Kette: Lernziel, Übung, Selbstcheck, Lösung, und
   `make alignment-check` läuft darüber.
2. **Regelwerk-Spiegel** der berührten Module; `Stand:`-Zeile in
   `lab/regelwerk/README.md` zieht nach.
3. **Vorlagen.** Abschnitt „Vertrauensgrenzen und Datenflüsse“ in der
   Architektur-Vorlage (ohne Historie; Kennungen nach E5); `LH-QA-02` ausfüllen
   statt neu anlegen — nur mit Kurs-Anker aus Schritt 1, sonst trüge das Template
   Struktur ohne Quelle; neue Pfade in `lab/templates` laufen durch die
   Link-Umschreibung beim Bundle-Bau;
   Register-Vorlage und eine Zeile im Planning-README-Template (nach E1/E2).
4. **Beispiel** nur, wo der Kurs ihn trägt.
5. **Satelliten prüfen, nicht vorab festlegen:** Lösungen der berührten Module,
   Begriffe, Konzeptkarte, `make alignment-check`.

**Freigaben.** Committen, Pushen und Taggen sind drei getrennte Freigaben
(`AGENTS.md` §5); dieses Dokument legt keine davon vorweg.

**Welle und Release.** Jede Überarbeitung ist eine Welle mit Eintrag im
`CHANGELOG.md` (`AGENTS.md` §3). Eine neue Regel ist **MINOR** (§6). Ein
Team-Sim-Szenario braucht nur, wo ein Sensor feuern oder schweigen soll;
**Urteile sind keine Szenario-Fälle** („ist das eine Vertrauensgrenze?“). Behauptet
die Welle kein beobachtbares Verhalten, steht das im Wellen-Eintrag. Ein
Prüfmodul wäre vorab auf Baubarkeit in d-check zu klären; **keine neuen
Prüf-Skripte** (§4).

## 6. Trigger

Der Faden hat in der Roadmap *nicht gesetzt* als Trigger — eine Entscheidung,
kein Ereignis: Es liegt kein Konsumenten-Befund vor. Zwei Ereignisse würden ihn
auslösen, beide **unterscheidbar** (nicht in jedem Repo mit leerem Platzhalter
erfüllt):
- ein Konsumenten-CR, der `LH-QA-Sicherheit` ohne Methodenanker meldet;
- ein Review-Report mit Sicherheits-HIGH-Finding in einem Repo, dessen
  `LH-QA-Sicherheit` **ausgefüllt** ist, der Befund sich aber auf keine
  `LH-QA`-Zeile beziehen kann (der Maßstab auf Muster-Ebene war da, der auf
  Anforderungs-Ebene deckte die Lücke nicht).

Setzt eines davon ein, wird der Trigger in der Roadmap eingetragen.
