# Umgebungs-Zusage — Plan zur Erweiterung

**Stand:** Plan-Entwurf, **nichts umgesetzt**. Kein Kurs-, Regelwerk-, Template-
oder Beispiel-Text berührt. Befund (§1) gegen den Arbeitsbaum nach `2f30660` (Pin-Stand: `Makefile`)
belegt; A1 ist entschieden (Option a), A2–A7 in §5 sind offen.

**Anlass.** [Modul 14](../kurs/de/05-betrieb/modul-14-docker-harness.md) führt den
Container als *den* „Reproduzierbarkeits-Anker“ (Begriff des Korpus; der Plan prüft
**Umgebungs-Zusage** als Ersatz, A1 entschieden). Die Frage: Welche Zusagen und Träger gibt es
noch, und fehlt ein Gate, das das Vorhandensein der benötigten Werkzeuge und
ihrer Versionen **prüft**?

**Richtung (Vorgabe des Maintainers, 2026-11-19).** Die **Umgebungs-Zusage**
(A1, Option a) ist der **Ausgangspunkt** für Docker und Dockerfile —
und ebenso für deren Alternative, den **Tool-/Versions-Check**. Docker ist damit
nicht mehr die Setzung, aus der alles folgt, sondern **ein Träger** einer
Anforderung. Der Plan folgt dieser Richtung (§2a).

## 1. Befund — was der Korpus heute als „Anker“ führt

Der heutige Begriff „Reproduzierbarkeits-Anker“ steht in Modul 14 als Lernziel
(„Image-Hash und Lock-Files als Reproduzierbarkeits-Anker *einsetzen*“), als
Fehlannahme und als Abschnitt „Zwei Formen des Reproduzierbarkeits-Ankers“
(Archiv · Rezept); als Satz „Image-Hash und Lock-Files sind die
Reproduzierbarkeits-Anker“ steht er in `lernpfade.md`, als Pflicht-Abschnitt der
Freigabe-Checkliste in der Lösung zu Modul 16. Er ist **nirgends** als eigene
Klasse definiert; die einzelnen Pins sind über sechs Module
verstreut. Die Zusammenstellung nach dem, was sie **pinnen** (jede Zeile ist ein Träger der Umgebungs-Zusage oder ein Teil davon):

| Träger | Pinnt | Drift-Klasse | Wo geführt | Wer prüft, dass er hält |
|---|---|---|---|---|
| **Image-Digest** (Archiv/Rezept) | Toolchain und Laufzeit-Image | Toolchain | Modul 14; Beleg `harness/image-hash.txt` | Replay-Diagnose Rang 1 (`runtime.image_hash` verglichen, Modul 12) und Release-Checkliste (identischer Hash in Klon und CI, Lösung zu Modul 16) — **manuell bzw. per Replay, kein Sensor** |
| **Base-Image per Digest** (`FROM …@sha256:`) | Eingangs-Image | Toolchain | Modul 14 | — |
| **Lock-File + `--frozen`** | Abhängigkeits-Versionen | Dependency | Modul 14 | der Build selbst (`--frozen` bricht) |
| **Installer-Pin** (`uv==…`) | das Werkzeug, das installiert | Toolchain | Modul 14 | — |
| **Replay-Manifest** (`image_hash`, `model.version`, `seed`, `determinism:`, `prompt_context`-Hash, `runtime.env`, `timestamp_masking`, `inputs_ref`) | Lauf: Toolchain, Modell, Zufall, Prompt, Umgebung, Daten | Toolchain · Modell · Erwartung | Modul 12 | Replay-Harness (Diagnose-Reihenfolge) |
| **Vendorte Baseline + `SHA256SUMS`** | Regelwerk und Templates des Adopters | Regelwerk | Modul 2 | Integritätsprüfung der Baseline, d-check `sources` (Integritäts-Hälfte, Modul 2) |
| **Pin des Prüfwerkzeugs** (`DCHECK_DIGEST`) | das Gate-Werkzeug selbst | Gate-Werkzeug | Modul 2 (`DCHECK_DIGEST`-Platzhalter, „bei jedem d-check-Bump“), Vorlage `lab/templates/Makefile` | — |
| *Querverweis, kein Träger:* **Reproduzierbarkeits-Bindung** | Klasse der Bindung-Spalte eines Gates (Image-Hash, Toolchain-Pin): das Gate hängt an einem bit-identischen Artefakt | — | `harness-dateien.md`, eine der vier kanonischen Klassen | — |

**Zwei Beobachtungen.**

1. **Zusage und Prüfung fallen auseinander — als Sensor.** Fast jede Zeile hat ein Pin, aber in
   der rechten Spalte steht oft nichts. Der Image-Digest wird **festgehalten**
   (`image-hash.txt`), aber kein Sensor vergleicht ihn mit dem, was gerade läuft.
   Ausnahmen sind `--frozen` (der Build bricht selbst) und der Replay-Vergleich.
2. **Ein Gate, das Werkzeug-Vorhandensein und -Version prüft, gibt es im Korpus
   nicht.** Gesucht wurde nach *tool-version*, *--version*, *toolchain-check*,
   *command -v*, *which*; Treffer sind nur Prosa („Host-Toolchain ist nicht
   versionsgleich mit CI“, Modul 14) und das Tool-Call-Gate `MR-004` aus
   [Modul 13](../kurs/de/04-qualitaet/modul-13-quality-gates.md), das den
   **Aufruf** am falschen Werkzeug verhindert, nicht die Version prüft.

## 2. Ordnungsprinzip: Wirkung statt Träger

Die Regel des Korpus ist nicht „benutze Docker“, sondern **„die Umgebung ist die,
die behauptet wird“**. Der Container ist ein *Träger* dieser Wirkung, nicht die
Wirkung. Für den Plan heißt das: Träger werden nach der **Frage** geordnet, die sie
beantworten, nicht nach dem Werkzeug.

| Frage | Zusage-Klasse | Träger (Beispiele) |
|---|---|---|
| *Welche Bytes laufen?* | Artefakt-Adresse | Image-Digest, Release-`SHA256SUMS`, vendorte Baseline |
| *Welche Version von was?* | Versions-Pin | Lock-File, Installer-Pin, Base-Image-Digest, **Tool-Versions-Manifest** |
| *Welche Eingaben und welcher Zufall?* | Lauf-Pin | Replay-Manifest: `inputs_ref`, `seed`, `determinism:` |
| *Welches Modell, welcher Prompt?* | Modell-Pin | `model.version` (ohne Alias), `prompt_context`-Hash |
| *Welcher Zustand beim Start?* | Umgebungs-Pin | `runtime.env`, Zeitzone, Locale |
| *Hält der Pin noch?* | **Zusage-Prüfung** | Vergleich Soll ↔ Ist — hier fehlt das Gate |

Die letzte Zeile ist die Lücke: Sie ist kein weiterer Träger, sondern die
**Prüfung**, dass die anderen noch tragen.

## 2a. Ausgangspunkt: die Anforderung, zwei Träger

**Befund, der die Umstellung trägt.** Der Korpus begründet die *Anforderung*
(lokal und CI sollen dasselbe laufen; Toolchain driftet) gut — aber nicht, dass
sie **mit Docker** zu erfüllen ist. Die Regel „kein `pip install` außerhalb
von Dockerfile-Stages“ (Modul 9) setzt Docker voraus und
kann **die Wahl von Docker** nicht begründen (innerhalb eines Docker-Repos trägt
die Regel: „Toolchain-Reproduzierbarkeit“ begründet das Nicht-Umgehen);
„Supply-Chain-Defense“ steht dort ohne Mechanismus (Modul 9; die Vorlage
`AGENTS.template.md` §3.1 übernimmt es, bedingt formuliert: „Wenn das Repo
Docker-only ist“). Modul 14 wägt Devcontainer
gegen Compose ab und begründet „Docker-only“ mit „Tools driften am schnellsten“;
**gegen konstruktive Alternativen** (Nix, devbox, asdf, mise, Podman, VM) wird
die Wahl nirgends abgewogen (Suche in Modul 14, Regelwerk und Modul 9: kein
Treffer).

**Die Zusage** (A1, Option a — die belegbare Selbstaussage der Umgebung): *Die Umgebung, in der ein
Lauf stattfindet, ist die, die behauptet wird — und das lässt sich belegen.*
Sie hat zwei Teile: Die Umgebung ist **festgelegt**
(gepinnt) und sie ist **adressierbar** (es gibt einen Beleg, der sagt, welche es
war).

**Beide Träger sind zulässig** (Maintainer, 2026-11-19): **Docker/Dockerfile**
und **Tool-Pin mit Tool-/Versions-Check**. Der Check allein erfüllt nur den Teil
*adressierbar/belegbar*, nicht *festgelegt*; der zweite Träger ist deshalb das
Paar aus **Tool-Pin** (die Versionen der Werkzeuge sind deklariert oder gelockt:
Manifest, Lock, Versionsmanager) und **Check** (stellt fest, ob die Umgebung sie
trägt). Der Pin legt fest, der Check belegt. Beide Träger erfüllen damit beide
Teile der Zusage, auf verschiedenem Weg. Weitere konstruktive Träger (Nix,
devbox, asdf, mise, VM) behandelt der Korpus nicht; sie sind ein offener Faden
(A6), keine Behauptung.

**Zwei Träger, mit verschiedener Wirkungsweise:**

| | **Docker / Dockerfile** | **Tool-Pin + Tool-/Versions-Check** |
|---|---|---|
| Wirkungsweise | **konstruktiv** — baut die Umgebung aus gepinnten Eingaben; sie soll dann die behauptete sein | **deklarativ und feststellend** — der Pin legt die Versionen fest, der Check stellt fest, ob die vorhandene Umgebung sie trägt |
| Festlegung durch | Digest, Lock-File, Stages | Tool-Pin: deklariertes Soll (Manifest, Lock oder aus der Pin-Stelle abgeleitet, A2) |
| Beleg / Adresse | Image-Digest, `image-hash.txt` | Prüfprotokoll: Werkzeug, Soll, Ist |
| Isolation | ja (eigenes Dateisystem; kein Netz nur mit `--network none`) | nein — die Umgebung bleibt die des Hosts |
| Voraussetzung | Docker am Host (selbst ungepinnt) | Werkzeuge am Host; kein Container nötig |
| Schwäche | Host-Abhängigkeit; Rootless/Mount-Besitz; ein Pin, der etwas anderes installiert, als er behauptet | prüft nur, was das Soll nennt; Drift **zwischen** zwei Prüfungen bleibt unbemerkt; keine Isolation |
| Trägt, wenn … | das Repo Docker nutzen darf und die Toolchain im Image liegt | kein Container möglich ist (Embedded, Host-gebundene Toolchain, Agent-Umgebung) oder der Container **geprüft** werden soll |

**Sie schließen sich nicht aus.** Wo Docker trägt, ist der Check die
**Zusage-Prüfung** (§1 Beobachtung 1: Der Digest wird festgehalten, aber nicht
gegen das Laufende verglichen). Wo Docker nicht trägt, ist der Check **selbst der
Träger**. Das ist derselbe Mechanismus in zwei Rollen — und der Grund, ihn *nicht*
als bloßes Anhängsel des Containers zu führen.

**Was der Kurs daraus lehrt:** Anforderung zuerst; dann zwei zulässige Träger mit
ihren Folgen; die Wahl trifft der Adopter (wie bei A2) und kann sie als ADR
festhalten, mit den betrachteten Optionen. Modul 14 behält seine Disziplinen
(Digest, Stages, Besitz der Belege) und bekommt den zweiten Träger daneben
(Welle B).

## 3. Das Tool-/Versions-Gate

**Idee.** Ein Gate, das vor den fachlichen Gates feststellt: Sind die benötigten
Werkzeuge **da**, und haben sie die **deklarierte Version**? Schlägt es an, ist
„rot“ dann ein Umgebungs-Befund und kein Befund über den Code. Das ist die
Diagnose-Reihenfolge aus Modul 12 (Rang 1: Toolchain-Drift) als Vorabprüfung.

**Warum es auch bei Docker-only etwas prüft.** Man könnte meinen, der Image-Digest
mache es überflüssig. Das stimmt nur, wenn das Image tut, was sein Name behauptet:

| Fall | Was der Digest sagt | Was nur das Versions-Gate fängt |
|---|---|---|
| **Host** (Docker, `make`, `buildx`, `git`) | nichts — der Host liegt außerhalb des Images | Host-Werkzeug fehlt oder ist zu alt (der Start des Gates scheitert sonst kryptisch) |
| **Im Image** | *dass* es dieses Image ist | dass **darin** die Version steckt, die die Deklaration behauptet (ein Pin, der etwas anderes installiert, als das Manifest sagt) |
| **Host-Werkzeuge außerhalb des Images** (`bash`, `make`, `sed`, `awk`, `grep`, `git`, `docker`) | nichts — sie liegen vor dem Image und rufen es auf | **alle**, die ein Skript aufruft: Am Host sind sie nicht versionsgleich mit dem Image (`bash` 3.2, `make` 3.81, BSD-Varianten). Auch sie gehören ins Inventar. |
| **Repo ohne Docker** (Rezept-Form ohne Container) | nichts — es gibt keinen Digest | das Gate **ist** der Träger der Zusage; ohne es gibt es keinen |
| **Agent-Umgebung** | nichts | Tool-Allowlist und tatsächliche Werkzeuge stimmen überein (vgl. Release-Checkliste in der Lösung zu Modul 16: „Tool-Allowlist = Stand der AGENTS.md“) |

**Das Gate im Rahmen dieses Korpus — Randbedingungen.**

1. **Eine Quelle für „Soll“.** Das Gate vergleicht Ist gegen Soll. Steht das Soll
   in einer *zweiten* Datei neben dem Pin (`Dockerfile`, Lock-File), driften beide
   auseinander: Das Gate prüft dann seine eigene Abschrift. Entweder wird das Soll
   **aus dem Pin abgeleitet** (Soll = was das `Dockerfile` installiert), oder das
   Manifest ist die einzige Quelle und das Dockerfile liest daraus. Welcher der
   beiden Wege gilt, entscheidet **der Adopter** (A2); der Kurs lehrt beide.
2. **Bindepunkt.** Es ist ein Gate (Preflight vor `make gates`), kein
   Tool-Call-Gate: Es soll nicht einen Aufruf verhindern, sondern die Umgebung
   feststellen. Einordnung in die drei Bindepunkte der
   [Durchsetzungsschicht](../kurs/de/grundlagen/durchsetzungsschicht.md#drei-bindepunkte)
   ist Teil des Plans.
3. **Rot muss lesbar sein.** Es meldet **welches** Werkzeug, **soll** und **ist**.
   Das ist die Fehlalarm-Frage aus Modul 13: Ein Gate, das bei jeder
   Patch-Abweichung rot wird, kostet sich die Existenz. Die Vergleichsstärke
   (exakt, Minor, Mindestversion) ist **A3**.
4. **Eine Prüfung muss prüfen.** Break-Test vor der Behauptung: absichtlich ein
   Werkzeug entfernen und eine Version verschieben, beides muss rot werden;
   unverändert muss grün bleiben. Ohne den Test wäre es „ein halluziniertes Gate“
   im Sinn von `AGENTS.md` §3/§4.
5. **Keine neuen Prüf-Skripte in *diesem* Repo** (`AGENTS.md` §4). Das betrifft
   die Umsetzung hier, nicht die Lehre: Der Kurs lehrt das Muster
   werkzeug-agnostisch; ob d-check ein Modul dafür trägt, ist vorab auf
   **Baubarkeit** zu klären (Ziel-Verzeichnis, Ignores, Scan-Roots), sonst
   behauptet der Plan ein Gate, das es nicht gibt (**A4**).

## 3a. Anschauung aus zwei Konsumenten-Repos

**Rang.** Gelesen wurden zwei Repos, die den Kurs als Baseline nutzen:
**u-boot** und **hetzner-viper** (nur gelesen, nichts ausgeführt; beide Stände
vom 2026-11-19). Sie sind **Anschauung, keine Begründung**: Fremd-Repos
begründen den Kurs nie, auch Konsumenten nicht — ein Stand ist ein Stand, und
eine Regel, die auf einem Fremd-Repo ruht, wird still falsch, sobald dort jemand
etwas ändert. Jede Aussage dieses Abschnitts ist **Entwurfsrichtung** für die
Fragen A2, A3 und A7; die Begründung muss der Kurs selbst tragen.

**Beide haben den Tool-/Versions-Check bereits.** Je ein Skript
`tool-pruefung.sh` (u-boot nennt es „das Laufzeit-Gate der Pin-Inventur“), und
dazu das d-check-Modul `pinsync` (§3b), das **beide** Repos fahren. Was daran für den Plan zählt:

| Frage | Beobachtung | Richtung für den Plan |
|---|---|---|
| **A2** Quelle des Solls | Beide lesen das Soll **aus der Pin-Stelle selbst**, nicht aus einer Kopie (u-boot: `repo.mk`; hetzner-viper: `Dockerfile` und `go.mod`). Kein eigenes Manifest. | Soll **ableiten**, kein zweites Manifest — das beantwortet die Zweite-Quelle-Sorge aus §3 Punkt 1. |
| **A2** zwei Prüfungen, nicht eine | **Stellen-Abgleich:** die Pins stimmen untereinander überein (u-boot: vier Stellen in einem Test; hetzner-viper: `go.mod` gegen `Dockerfile`). **Laufzeit-Gate:** die installierten Werkzeuge tragen den Pin. Das eine braucht keine Werkzeuge, das andere läuft im Kontext. | §3 führt beides als „das Gate“ zusammen. Der Plan trennt es: **Stellen-Abgleich** (statisch, prüft die Pins) und **Laufzeit-Gate** (dynamisch, prüft die Umgebung). Beide sind Prüfungen derselben Zusage. |
| **A3** Vergleichsstärke | Je Werkzeug eine von **drei Prüfformen:** exakt bzw. per Teilstring (`go`, `golangci-lint`, siehe unten), Mindestversion (`make`), Anwesenheit (`bash`, `curl`, `gh`, `git`, `docker`) — **`bash` nur auf Anwesenheit zu prüfen ist am Host zu schwach** (siehe unten). `sed`, `awk` und die Coreutils bleiben ungeprüft („Basis-Image-Grenze“). | „Exakt im Image, Mindestversion am Host“ war zu grob. **Die Ausnahme „ungeprüft“ trägt nur im bekannten Image:** Am Host gibt es von `sed`, `awk`, `make` und `grep` **GNU- und BSD-Varianten** mit verschiedenem Verhalten. Der Plan führt deshalb **vier Formen je Werkzeug:** exakt · Mindestversion · Anwesenheit · **Variante** (GNU oder BSD, wo sich das Verhalten unterscheidet). **Kein Werkzeug bleibt ungeprüft** (Maintainer, 2026-11-19): Jedes Werkzeug, das ein Skript des Repos aufruft, steht im Inventar und trägt eine Prüfform. Auch „Anwesenheit“ ist eine Prüfform, aber eine **entschiedene** — keine Ausnahme von der Prüfung. Eine Pauschale „Coreutils“ gibt es nicht. Die Entscheidung je Werkzeug gehört in die Deklaration, nicht ins Skript. Offen bleibt, **woher das Inventar kommt** (A8). Zudem sind `sed` und `awk` **keine Coreutils**; die Pauschale hat zwei Pakete verdeckt. **Dieselbe Klasse trifft `bash`:** macOS liefert als `/bin/bash` die Version 3.2 (ohne assoziative Arrays, `mapfile`, `${var,,}`); die Anwesenheitsprüfung beider Konsumenten-Repos geht dort grün und lässt ein Skript scheitern, das Bash 4 voraussetzt. `bash` gehört auf **Mindestversion**, und zwar auf die, die die Skripte des Repos tatsächlich brauchen. Die Klasse ist allgemein: **Systemwerkzeuge des Hosts sind nicht versionsgleich mit dem Image** (`bash` 3.2, `make` 3.81, BSD-`sed`/`awk`/`grep`), und genau dort trägt „Anwesenheit“ nichts. |
| **A7** Bindepunkt und Ort | Das Gate hängt in `make gates` und läuft im **laufenden Kontext**; u-boot: „der Lauf-Ort ist egal, die Werkzeuge sind die Trägerschaft“. | Der Check ist **vom Träger unabhängig** (Devcontainer, CI, Host): Er prüft, was läuft, nicht wie es gebaut wurde. **Beobachtung:** Ob das die Trennung Zusage / Träger trägt, ist im Kurs herzuleiten (§2a), nicht aus diesen Repos. |
| **A7** Rot-Stufen | `sshd` fehlt → nur Warnung; sonst Rot mit Werkzeug- und Pin-Namen. | Zwei Stufen (Rot, Warnung) sind belegt; wann welche gilt, ist zu entscheiden. |
| **A6** Docker-Wahl | u-boot-ADR-0043 wägt fünf Optionen ab (zwei Modi, Toolchain-Image ohne Devcontainer u. a.) — **innerhalb** von Docker. Gegen Nix, devbox, asdf, mise oder VM wägt keines der beiden Repos ab. | Beobachtung. Die Lücke belegt die Suche im Kurs (§2a), nicht dieses Repo. |
| **Supply-Chain** | u-boot-ADR-0041 verifiziert eine nutzergewählte Werkzeug-Version gegen die **offizielle Prüfsummen-Quelle** (SHA-256 je Architektur). | Ein **Mechanismus** für das, was Modul 9 nur als „Supply-Chain-Defense“ etikettiert. Der Kurs müsste ihn selbst herleiten (Pin und Prüfsumme statt „Container“), nicht von dort übernehmen. |

**Prüfqualität der Vorbilder (nachgeprüft, beides Anschauung für §3 Punkt 4).**
- **u-boot prüft „exakt“ per Teilstring:** `case *"$want"*` lässt `go1.27.30` auf
  den Pin `1.27.3` passen. hetzner-viper prüft exakt (Präfix mit Leerzeichen).
- **u-boots `make`-Mindestversion vergleicht per `awk` als Dezimalzahl:**
  `4.10 < 4.4` ergibt dort wahr, also ein falsches Rot. hetzner-viper prüft
  `make` nur auf Anwesenheit.
Beide Fehlerbilder zeigen, wofür die Break-Probe da ist: Eine Prüfung, die „richtig
aussieht“, ist keine geprüfte Prüfung.

**Eine Beobachtung zu stillen Ausgängen.** hetzner-viper setzt
`VIPER_REQUIRE_TOOLS=1` im `make test`: Ein fehlendes Werkzeug ist dort ein
Fehler, ohne die Variable würden die Tests **still überspringen**. Im Gate ist
der stille Ausgang also zu. Das ist die Klasse „erwartete Stille ist eine
Aussage“ (`AGENTS.md` §3) und ein Szenario für Welle B (*Werkzeug fehlt → rot,
nicht übersprungen*). Beide Vorbilder geben bei Erfolg eine **OK-Zeile** aus; das
Verdikt „still“ gilt dort nicht, es heißt Exit 0 ohne Befund.

**Nicht geprüft.** Ob die beiden Skripte **wirklich prüfen**, ist offen: Ein Break-Test
(Werkzeug entfernen, Version verschieben) ist in keinem der beiden Repos
belegt, und zwei Fehlerbilder stehen oben. Vor einer Übernahme der Form ist der
Break-Test Pflicht (§3 Punkt 4).

## 3b. d-check als Träger — was es kann, was nicht

**Rang.** Gelesen wurde das Benutzerhandbuch von d-check v0.91.0 (nichts
ausgeführt). d-check ist das Prüfwerkzeug dieses Repos (`AGENTS.md` §4); der Kurs
lehrt das Muster aber werkzeug-agnostisch und nennt d-check nur dort, wo er es
heute schon tut (Modul 2). Dieser Abschnitt beantwortet A4 für die Teile des
Gates, nicht die Frage, was der Kurs vorschreibt.

| Teil des Gates | d-check | Befund |
|---|---|---|
| **Stellen-Abgleich** (derselbe Wert an mehreren Stellen) | Modul **`pinsync`** (neu in v0.91.0, opt-in über `--enable pinsync`) | **trägt gut.** Ein Pin hat einen Namen und mindestens zwei Quellen (Datei plus Ausdruck mit genau einer Fanggruppe); gleich oder Befund auf der Zeile des Treffers. Hermetisch: kein git, kein Netz, **kein Programmstart**, kein Schreiben. Liest auch Dateien ohne Markdown-Endung (`Dockerfile`, `Makefile`). |
| **Laufzeit-Gate** (installierte Werkzeuge tragen den Pin) | — | **trägt nicht, konstruktiv.** d-check startet kein Programm und prüft Repo-Text, nicht die Umgebung; es läuft selbst in einem Container ohne Netz und sähe nur sein eigenes Image. `go version`, die Bash-Version, GNU oder BSD sind außerhalb seiner Reichweite. Braucht ein Skript im laufenden Kontext. |
| **Inventar-Vollständigkeit** (A8) | kein passendes Modul | Nichts parst Werkzeug-Aufrufe in Shell-Skripten gegen ein Inventar. `mentions` prüft Dateien einer Soll-Menge gegen Dokumente, nicht Werkzeugnamen; `targets` prüft Doku-Tabellen gegen Makefile-Regeln. **A8 (a) ist mit d-check heute nicht baubar.** |

**Grenzen von `pinsync` selbst** (Handbuch §4.27, „Was das Modul nicht sagt“):
- Verglichen wird **byte-genau**: `1.27` und `1.27.0` sind verschieden; ein
  führendes `v` steuert der Ausdruck, nicht ein Schalter.
- Es prüft nicht, ob der Ausdruck die **richtige** Stelle trifft: Ein Treffer in
  einer Kommentarzeile mit passendem Wortlaut ist ein Treffer.
- Die Bezugsmenge sagt, was gelesen wurde, nicht, dass **jeder** Pin des Repos
  erfasst ist — das ist dieselbe Vollständigkeitsfrage wie A8, eine Ebene tiefer.

**Folgen für die Entscheidungen:**
- **A2 öffnet sich.** Mit `pinsync` ist auch ein **eigenes Manifest** tragbar: Die
  Zweite-Quelle-Sorge aus §3 Punkt 1 löst sich, weil das Werkzeug Manifest und
  Pin-Stelle gegeneinander hält. „Ableiten, kein Manifest“ (§3a) ist nicht mehr
  die einzige Richtung; sie bleibt die einfachere (eine Quelle weniger).
- **A4 ist für zwei von drei Teilen beantwortet:** Stellen-Abgleich ja, Laufzeit-
  Gate nein, Inventar-Vollständigkeit nein.
- **A8 verliert Weg (a);** es bleiben (b) und (c).
- **Das Laufzeit-Gate ist ein Skript des Adopters.** `AGENTS.md` §4 (keine neuen
  Prüf-Skripte) gilt für dieses Repo, das nur Doku führt; der Kurs lehrt das Gate
  für Repos, die Werkzeuge nutzen. Für dieses Repo selbst entsteht kein Skript.

**Im Einsatz (Anschauung, nicht Begründung).** Beide Konsumenten-Repos nutzen
`pinsync` bereits. **hetzner-viper** fährt es als eigenes Gate-Target (`pinsync`
in `GATE_CHECKS`, d-check v0.91.0 per Digest gepinnt) mit nur diesem Modul;
Pin-Gruppen: `go` (Dockerfile, Devcontainer-Dockerfile, `go.mod`) und
`golangci-lint`. **u-boot** hat das Modul in der Modulliste und fünf Quellen für
`go`. Drei Dinge daran sind für den Plan lehrreich:
- **Granularität je Quelle über die Fanggruppe.** u-boot fängt bei `go` nur
  `Major.Minor` (die `go`-Direktive in `go.mod` steht auf `1.27.0`, die Toolchain
  auf `1.27.3`) und lässt den Patch-Teil in den `GO_VERSION`-Stellen: Ein Pin
  kann an verschiedenen Stellen verschieden fein stehen, und der Ausdruck legt
  fest, was verglichen wird (vgl. A3).
- **Dieselbe Prüfung zweimal.** hetzner-vipers `tool-pruefung.sh` vergleicht
  `go.mod` und `Dockerfile` selbst, obwohl `pinsync` das übernimmt; die Aufteilung
  aus §3a (Stellen-Abgleich statisch, Laufzeit-Gate dynamisch) ist dort nur
  halb durchgeführt.
- **Beobachtung zur Ausnahme-Begründung.** u-boot begründet in der Konfiguration,
  `bash`, `sed` und weitere Shell-Werkzeuge trügen keine Einzel-Pins, weil ihre
  Versionen „mit dem Basis-Image des jeweiligen Pins“ kämen. Das gilt im Image und
  nicht am Host (Zeile „Host-Werkzeuge“ in §3). Warum A3 die Ausnahme verwirft,
  ist im Kurs herzuleiten (Host-Werkzeuge sind nicht versionsgleich mit dem
  Image, Modul 14), nicht aus diesem Repo.

**Versions-Stand.** Der Pin dieses Repos steht auf **d-check v0.91.0**
(`DCHECK_DIGEST` in `Makefile`, `sha256:5d2f650d…`; Beispiel und Fragmente
ebenso). `pinsync` ist damit verfügbar, **opt-in** und in diesem Repo **nicht
aktiviert**; ein Kapitel, das es nennt, braucht keinen weiteren Bump. Ob die
Beispiel-Stufe es aktiviert, entscheidet sich nach dem Kurs (`AGENTS.md` §1).

## 4. Wohin im Kurs

- **Primär: Modul 14.** Die „Umgebungs-Zusage“ wird als **Anforderung**
  definiert (heute nur gebraucht, und dort für den Träger), Docker und der
  Versions-Check stehen als zwei Träger nebeneinander (§2a), dazu die
  Frage-Tabelle aus §2. Das Tool-/
  Versions-Gate steht neben `--frozen` und `image-hash.txt` als dritte Disziplin
  (*prüfen, dass der Pin hält*) — **in Welle B**, nicht in Welle A.
- **Sekundär: Modul 13.** Das Gate als Preflight-Klasse neben Gate/Beleg; der
  Worked Example MR-004 argumentiert, ein Gate stelle den Fehlaufruf nur
  *nachträglich* fest, der Tool-Call-Gate sei deshalb besser. Ein Preflight in
  `make gates` erreicht den direkten `pytest`-Aufruf **nicht**; das Versions-Gate
  ergänzt MR-004 (Umgebung feststellen), ersetzt es nicht. Die Abgrenzung muss in
  Modul 13 stehen.
- **Modul 12.** Die Diagnose-Reihenfolge (Rang 1 Toolchain-Drift) verweist auf das
  Gate als maschinelle Vorstufe.
- **`grundlagen/harness-dateien.md`.** „Reproduzierbarkeits-Bindung“ wird mit
  der neuen Klasse verbunden.
- **Vorlagen.** Sensor-Vorlage für das Gate (neben `sensors/gate.template.md`),
  Zeile in der `Makefile`-Vorlage, ggf. Abschnitt „Tool-Soll“ in
  `harness/README.template.md` neben `image-hash.txt`. Die Form richtet sich nach
  A2.

## 5. Offene Entscheidungen

| | Frage | Stand der Abwägung |
|---|---|---|
| **A1** | **Begriff.** | **entschieden: Option (a)** (Maintainer, 2026-11-19). **Umgebungs-Zusage** = die **belegbare Aussage der Umgebung über sich selbst**: „Die Umgebung, in der ein Lauf stattfindet, ist die behauptete — und das lässt sich belegen.“ Die Zusage ist die **Aussage**; der Sensor ist ihre **Prüfung**, nicht ihr Bestandteil (der Korpus kennt auch die „Zusage ohne Sensor“, Modul 2, und die „Zusage ohne Deckung“, Lösung zu Modul 12) Das ist der Gebrauch von „Zusage“ im Korpus (Selbstaussage einer Stelle, die ein Sensor sehen muss; `harness-dateien.md`, Modul 2, Modul 10; Modul 14 `nonroot`-Zusage). Die **Anforderung**, dass es sie geben muss, bleibt eine `LH-QA-*` des Projekts (Messmethode = der Sensor); der Kurs lehrt die Klasse, das Projekt trägt die Instanz. **Träger** legt die Umgebung fest (Docker/Dockerfile, ein Manifest, weitere), die **Prüfung** stellt fest, ob die Zusage hält. Der Tool-/Versions-Check hat **zwei Rollen**: Wo die Festlegung anderswo liegt (Lock, Manifest, Betriebssystem), ist er Träger; wo Docker festlegt, ist er die Prüfung. Das wird im Kurs ausdrücklich so benannt. **Abgrenzung** im Text: „Zusage“ des Lastenhefts (Modul 3, `source-precedence.md`: verpflichtende Aussage an den Auftraggeber) ist etwas anderes; das Präfix „Umgebungs-“ steht immer mit. `lab/example` begründet nichts (`AGENTS.md` §1). Folgen: Eintrag in `begriffe.md`; Lösungen, Lernervorstellungen und Konzeptkarte ziehen mit; die Fundstellen des alten Begriffs „Reproduzierbarkeits-Anker“ (§6 Welle A) werden umgestellt. |
| **A2** | **Quelle des Solls.** | **entschieden (Maintainer, 2026-11-19): Der Adopter entscheidet; der Kurs lehrt beide Wege mit ihren Folgen.** **Weg 1, ableiten:** das Soll steht in der Pin-Stelle (`Dockerfile`, Lock, `go.mod`), das Gate liest sie. Eine Quelle, aber nur, wo eine maschinell lesbare Pin-Stelle existiert — je Sprache verschieden, und für Host-Werkzeuge (`bash` ≥, `make` ≥) gibt es keine. **Weg 2, Manifest:** eine eigene Deklaration (Werkzeug, Prüfform, Soll). Sprach-neutral und vollständig deklarierbar, aber eine **zweite Quelle**; sie driftet gegen die Pin-Stelle, wenn niemand sie gegeneinander hält (`pinsync` leistet das, wo d-check zur Verfügung steht). **Mischform:** ableiten, wo eine Pin-Stelle existiert, Manifest für den Rest. Der Kurs gibt **Entscheidungskriterien**, keine Vorgabe: Gibt es eine Pin-Stelle? Läuft ein Host-Teil? Ist `pinsync` oder ein Gleichwertiges verfügbar? **A2a, entschieden (Maintainer, 2026-11-19): Der Adopter deklariert seine Wahl in `harness/conventions.md` als `MR-<NNN>`** — die Wahl ist eine Adaption der Baseline, und dort steht, was ein Repo von ihr abweichen lässt. **Offen bleibt,** ob die Vorlage einen Default mitliefert. **Entwurfsrichtung (§3a, §3b):** Stellen-Abgleich und Laufzeit-Gate getrennt führen; das Inventar muss vollständig sein (A8). |
| **A3** | **Prüfform je Werkzeug.** Welche der vier Formen (exakt · Mindestversion · Anwesenheit · Variante)? | **Entschieden in der Richtung (Maintainer, 2026-11-19): kein Werkzeug bleibt ungeprüft**; die Ausnahmeliste entfällt. Offen: welche Form je Werkzeug und warum — die Herleitung gehört in den Kurs (Host-Werkzeuge sind nicht versionsgleich mit dem Image), nicht in die Konsumenten-Repos. Exakt ist reproduzierbar, aber fehlalarm-anfällig bei Host-Werkzeugen; Mindestversion deckt den Host ab, fängt aber Drift im Image nicht. **Entwurfsrichtung (§3a):** je Werkzeug eine Form, in der Deklaration, nicht im Skript. |
| **A4** | **Baubarkeit in d-check.** Trägt ein bestehendes Modul das Gate, oder bleibt es ein `make`-Target der Vorlage? | Vorab gegen Ignores und Scan-Roots prüfen (`lab/templates` ist gate-ignoriert). Kein neues Prüf-Skript hier. **Teilweise beantwortet (§3b):** Stellen-Abgleich → `pinsync` (ab v0.91.0, Pin steht dort); Laufzeit-Gate und Inventar-Vollständigkeit → kein d-check-Modul. |
| **A5** | **Schnitt der Wellen.** | **Zwei Wellen (§6).** Welle A: Begriff und Bereinigung (A1; A6 entschieden) — der Satz zu den zwei Trägern **fehlt** dort bewusst und kommt in Welle B. Welle B: das Gate und der zweite Träger (A3, A4, A7–A9). Ob Welle A allein eine Welle trägt, ist beim Start zu entscheiden. |
| **A6** | **Docker: Stand des Kurses.** | **Richtung entschieden (Maintainer, 2026-11-19): beide Träger zulässig — Docker/Dockerfile und Tool-Pin mit Tool-/Versions-Check.** Docker ist der heutige Stand des Kurses, keine Abwägung gegen andere Träger; ein „weil …“ behauptete eine Wahl, die es nicht gab. Betrifft Modul 14 (ein Docker-Modul), die Zeile in Modul 9 (ein „Beispiel aus realen Repos“, kein Kurs-Gebot; „Supply-Chain-Defense“ hat keinen Mechanismus) und `AGENTS.template.md` §3.1 (bedingt formuliert). **Wortlaut-Entwurf für Modul 14:** „Die Umgebungs-Zusage lässt sich auf zwei Wegen erfüllen: mit Docker und Dockerfile, die die Umgebung aus gepinnten Eingaben bauen, oder mit Tool-Pins und einem Tool-/Versions-Check, der feststellt, ob die vorhandene Umgebung sie trägt. Dieses Modul behandelt den ersten Weg; der zweite folgt. Das ist der heutige Stand des Kurses, keine Abwägung zwischen beiden oder gegen weitere Träger.“ Die Abwägung gegen weitere Träger bleibt ein offener Faden, den der Kurs nicht behauptet. **Offen:** ob Welle A den Satz schon setzt, bevor der zweite Träger gelehrt wird (Welle B) — er verspräche dann etwas, das noch fehlt. |
| **A7** | **Bindepunkt, Ausführungsort, Prüfer des Prüfers.** | **Bindepunkt entschieden (Maintainer, 2026-11-19): der erste Check in `make gates`.** Das Gate steht vor den fachlichen Gates, ein Rot hier ist ein Umgebungs-Befund und kein Befund über den Code. **Folge, im Kurs zu nennen:** Der Check läuft *in* `make`; ein zu altes `make` oder eine zu alte Shell scheitert beim Einlesen des Makefiles, bevor der Check dran ist (u-boot führt deshalb zusätzlich eine Mindestversion im Makefile selbst, als Parse-Guard). Der Host-Teil, der `make` und `bash` prüft, prüft also nur noch, was *trotz* dieser Grenze startete. **Offen:** Wo läuft der Check (am Host, im Image)? Der Host-Soll wird am Host geprüft, das Image-Soll im Image — zwei Läufe oder einer? Wer prüft den Prüfer selbst (Pin des Prüfwerkzeugs, `DCHECK_DIGEST`)? Einordnung in die drei Bindepunkte der Durchsetzungsschicht. Ohne diese Antworten ist das Gate eine Idee, kein Entwurf. **Entwurfsrichtung (§3a):** das Gate hängt in `make gates`, läuft im laufenden Kontext und ist vom Träger unabhängig; zwei Stufen (Rot, Warnung) sind zu klären; **die Werkzeuge, mit denen das Gate seine Pins parst (`sed`, `awk`, `grep`), sind selbst Abhängigkeiten des Gates** und gehören in dieselbe Prüfung — sonst prüft der Prüfer mit ungeprüften Werkzeugen. Das Gate-Skript selbst muss unter der **ältesten zugelassenen** Bash laufen (Bash 3.2 am Mac, wenn der Host dort zugelassen ist), sonst scheitert es, bevor es prüft. |
| **A8** | **Woher kommt das Werkzeug-Inventar?** | Wenn kein Werkzeug ungeprüft bleibt, muss das Inventar **vollständig** sein. Handgepflegt driftet es: Ein Skript ruft nach einem Jahr `jq` auf, das nirgends steht, und das Gate bleibt grün. Optionen: (a) handgepflegt, mit einem Sensor, der Aufrufe in den Skripten gegen das Inventar prüft (**mit d-check heute nicht baubar**, §3b); (b) aus den Skripten abgeleitet (vollständig, aber schwer: Aufrufe in Shell sind nicht sauber parsbar); (c) handgepflegt ohne Vollständigkeitsprüfung, mit dem **Prüfer des Prüfers** als Stichprobe; (d) handgepflegt, mit einer **Probe im leeren Kontext** als Beleg: `make gates` läuft in einem Kontext, der genau das Inventar enthält, und ein undeklariertes Werkzeug lässt es scheitern. **Träger-neutral als `PATH`-Käfig** (ein Wegwerf-Verzeichnis mit Verweisen nur auf die deklarierten Werkzeuge, `PATH` darauf gesetzt; läuft auch ohne Docker und deckt auch die Host-Werkzeuge); **im Docker-Repo als Image** mit genau dem Inventar, dort aber ohne Host-Werkzeuge. Grenzen, für beide Formen: Shell-Builtins liegen nicht im `PATH`; ein absoluter Pfad umgeht den Käfig; `make` und `sh` müssen im Käfig liegen und gehören ins Inventar; die Probe fängt nur Aufrufe, die in diesem Lauf passieren — ein **Beleg mit Lücke**, kein Beweis der Vollständigkeit, und der Kurs müsste das so sagen. **Ungeprüft:** Der Käfig ist nicht gebaut und nicht erprobt. Zu klären gegen die Baubarkeit in d-check (A4); keine neuen Prüf-Skripte hier (`AGENTS.md` §4). |
| **A9** | **Was feuert im Team-Sim?** | Welle B braucht ein Szenario *Werkzeug fehlt → rot* (`AGENTS.md` §3). Das Laufzeit-Gate ist ein Skript des Adopters (§3b), dieses Repo legt kein neues Prüf-Skript an (§4), und der Team-Sim fährt d-check. Offen: ob der Team-Sim ein Vorlagen-Skript fahren kann, ohne ein Gate zu behaupten, das es hier nicht gibt; sonst bleibt Welle B ohne geprüftes Verhalten und das steht im Wellen-Eintrag. |

## 6. Plan — falls der Faden dran ist

**Reihenfolge nach Rangfolge** (`AGENTS.md` §1): Kurs → Regelwerk-Spiegel
(wortgleich, netzlos) → Vorlagen → Beispiel.

1. **Welle A — Begriff und Bereinigung** (hängt an A1; A6 ist entschieden).
   Modul 14 definiert die Umgebungs-Zusage als Anforderung und führt die
   Frage-Tabelle (§2); Docker steht darin als **der heutige Träger**, **ohne** den
   Satz zu den zwei Wegen — der kommt erst in Welle B, wenn beide Wege da sind
   (A6). Modul 9: die Zeile „Supply-Chain-Defense“ entfällt, „Toolchain-
   Reproduzierbarkeit“ bleibt; die Vorlage `AGENTS.template.md` §3.1 zieht nach
   (Quelle zuerst). Modul 12 und `harness-dateien.md` verlinken. Regelwerk-
   Spiegel; `Stand:`-Zeile des Regelwerk-READMEs zieht nach. Kein beobachtbares
   Verhalten, **kein Team-Sim-Szenario** — das steht im Wellen-Eintrag. **Zu
   prüfen vor dem Start:** Trägt Welle A allein (Umbenennung und Bereinigung)
   eine eigene Welle, oder gehört sie in Welle B? Die Entscheidung fällt, wenn
   der Umfang feststeht.
   **Satelliten des heutigen Begriffs** (jede Fundstelle des Begriffs
   „Reproduzierbarkeits-Anker“ zieht mit): Modul 14 (Lernziel, Fehlannahme,
   Abschnitt „Zwei Formen…“, Reflexion; „drei Drift-Anker“ und „drei Anker“ in Übung und Selbstcheck), die Fehlannahme im Regelwerk-Spiegel, die Überschrift „Zwei Formen des
   Reproduzierbarkeits-Ankers“ im Regelwerk-Spiegel (Anker-Slug!), `lernpfade.md`,
   `fallstudien.md`, `lernervorstellungen.md`, die Überschrift „Reproduzierbarkeits-Anker“
   in der Lösung zu Modul 16 und der Pflicht-Abschnitt der Freigabe-Checkliste in Modul 16, Modul 9 im Spiegel (Supply-Chain-Zeile); **erst danach, in der Beispiel-Stufe,**
   zieht `lab/example/AGENTS.md` nach — es ist Folge, nicht Anlass. Release-Art: **MINOR** (neue Anforderungs-/Träger-Regel, Umbau von Modul 9).
2. **Welle B — das Gate.** Nach A3, A4 und A7–A9 (A2 ist Adopter-Entscheidung). Kurs (Modul 14, Modul 13), Spiegel,
   Sensor-Vorlage und `Makefile`-Zeile, **Team-Sim-Szenario** je Verhalten:
   *Werkzeug fehlt → rot*, *Version weicht ab → rot*, *alles stimmt → Exit 0 ohne Befund*
   (erwartete Stille ist eine Aussage und braucht ihr Szenario; beide Vorbilder
   geben dabei eine OK-Zeile aus, das Verdikt ist der Exit-Code). Nachzug in der
   Vorlage: `AGENTS.template.md` sagt „Host braucht nur Docker und GNU `make`“ —
   das Host-Inventar des Gates widerspricht dem. Beispiel nur,
   wo der Kurs ihn trägt.
3. **Satelliten prüfen, nicht vorab festlegen:** Lösungen 12/13/14, Begriffe,
   Lernervorstellungen, Konzeptkarte, `make alignment-check`.

Eine neue Regel ist **MINOR** (`AGENTS.md` §6). Committen, Pushen und Taggen sind
drei getrennte Freigaben (§5).

## 7. Trigger

In der Roadmap *nicht gesetzt*; eine Entscheidung, kein Ereignis. Kandidaten für
ein beobachtbares Ereignis: ein Konsumenten-Repo meldet einen Gate-Lauf, der an
einer abweichenden Werkzeug-Version rot wurde, ohne dass das Gate dies als
Umgebungs-Befund benannte; oder ein Replay-Befund, der erst auf Rang 4 landet,
weil Rang 1 nie maschinell geprüft wurde.
