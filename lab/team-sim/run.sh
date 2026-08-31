#!/usr/bin/env bash
# Team-Sim — Replay fuer Nebenlaeufigkeits-Szenarien (Modul-12-Bauform).
# KEIN Gate: laeuft auf Anlass, nicht in make check. Topologie je Lauf frisch:
# bare origin.git + zwei Clones (alice, bob) — die Team-Topologie, nicht
# Worktrees (die teilen ein .git und modellieren EINEN Entwickler).
# Erwartungen sind VORAB notiert (manifest.yaml, README-Tabelle); auch stille
# Ausgaenge sind Erwartungen.
#
# Aufruf:  bash run.sh              alle Gruppen
#          bash run.sh s04 s06      nur diese Gruppen (Kennung = Praefix der Verdikte)
# Umgebung: SIM_WORK=<dir>  Arbeitsverzeichnis (sonst mktemp; bleibt liegen)
#           SIM_CLEAN=1     Arbeitsverzeichnis nach dem Lauf entfernen
# Ergebnis: $WORK/ergebnis.tsv — je Verdikt eine Zeile (Szenario, erwartet,
#           beobachtet, PASS|FAIL|KAPUTT) unter einem Kopf mit Datum, Image,
#           Repo-Stand und Seed-Hash; der Lauf ist damit belegbar, nicht nur
#           notiert.
set -u
HIER="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$HIER/../.." && pwd)"
DIGEST="$(grep -m1 '^DCHECK_DIGEST' "$REPO_ROOT/Makefile" 2>/dev/null | sed 's/.*= *//')"
# Fail-closed: ohne Digest liefen die Git-Szenarien "gruen" und die
# Docker-Szenarien scheiterten kryptisch — ein halb-bestehender kaputter
# Lauf. Der Harness lebt im Kurs-Repo; die Kopie-Grenze steht im README.
[ -n "$DIGEST" ] || { echo "FEHLER: DCHECK_DIGEST nicht gefunden — run.sh braucht das Kurs-Repo (../../Makefile)."; exit 2; }
IMG="ghcr.io/pt9912/d-check@${DIGEST}"
WORK="${SIM_WORK:-$(mktemp -d)}"
TSV="$WORK/ergebnis.tsv"
PASS=0; FAIL=0; KAPUTT=0
SELECT="$*"

# ---- Ergebnisdatei: Kopf traegt, was den Lauf bestimmt --------------------
mkdir -p "$WORK"
{
  echo "# team-sim ergebnis"
  echo "# datum: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "# image: $IMG"
  echo "# repo: $(git -C "$REPO_ROOT" rev-parse --short HEAD 2>/dev/null || echo unbekannt)"
  echo "# seed: $(cd "$HIER/seed" && find . -type f | sort | xargs sha256sum | sha256sum | cut -c1-12)"
  printf 'szenario\terwartet\tbeobachtet\tverdikt\n'
} > "$TSV"

topo() {  # frische Topologie
  rm -rf "$WORK/sim"; mkdir -p "$WORK/sim"; cd "$WORK/sim"
  git init -q --bare -b main origin.git
  git clone -q origin.git seedclone 2>/dev/null && cd seedclone
  cp -r "$HIER/seed/." . && git add -A && git -c user.name=seed -c user.email=s@s commit -qm "seed" && git push -q origin main
  cd "$WORK/sim"
  git clone -q origin.git alice 2>/dev/null && git clone -q origin.git bob 2>/dev/null
  # Wachsamkeit gegen den Leer-Checkout-Fehler des ersten Laufs:
  [ -f alice/.d-check.yml ] || { echo "TOPO-DEFEKT: alice leer"; exit 9; }
  for w in alice bob seedclone; do git -C $w config user.name $w; git -C $w config user.email $w@sim; done
}
# Volle Ausgabe, kein tail: ein zweiter Befund schoebe den erwarteten Code
# sonst aus dem Fenster; die Verdikte zeigen selbst nur die letzte Zeile.
dcheck() { docker run --rm --network none -v "$1:/repo:ro" "$IMG" 2>&1; }
# Befund-Zeile gezielt: <datei>:<zeile> TAB <target> TAB <code>. Ein Code
# irgendwo in der Ausgabe reichte nicht — wave-drift auf dem falschen Ziel
# waere sonst auch "bestanden".
befund() { printf '%s' "$1" | grep -q "$(printf '\t%s\t%s' "$2" "$3")"; }
verdikt() { # $1 name  $2 erwartet  $3 beobachtet  $4 ok(0/1)
  if [ "$4" = 0 ]; then echo "  PASS  $1"; PASS=$((PASS+1)); v=PASS;
  else echo "  FAIL  $1"; echo "        erwartet:  $2"; echo "        beobachtet: $3"; FAIL=$((FAIL+1)); v=FAIL; fi
  printf '%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "$v" >> "$TSV"
}
# Vorbedingungs-Schritt: scheitert er, ist das Szenario KAPUTT, nicht FAIL —
# ein Verdikt ueber einen Zustand, der nie hergestellt wurde, waere keines.
schritt() { "$@" || { echo "  KAPUTT ($CUR): Schritt fehlgeschlagen: $*"; printf '%s\t%s\t%s\t%s\n' "$CUR" "Vorbedingung" "Schritt fehlgeschlagen: $*" "KAPUTT" >> "$TSV"; KAPUTT=$((KAPUTT+1)); return 1; }; }
lauf() { # $1 gruppen-kennung  $2 funktion
  if [ -n "$SELECT" ]; then case " $SELECT " in *" $1 "*) ;; *) return 0;; esac; fi
  CUR="$1"; "$2" || true
}

s01_doppel_anspruch() {
  topo
  # alice beansprucht slice-003 auf main (Datei anlegen + mv-Aequivalent: neu in in-progress)
  cd "$WORK/sim/alice"; printf '# Slice slice-003\n\n**Welle:** welle-2-ausbau\n\n**Verantwortlich:** alice.\n' > docs/plan/planning/in-progress/slice-003-ausbau.md
  schritt git add -A && schritt git commit -qm "claim slice-003 (alice)" && schritt git push -q origin main || return 1
  # bob, OHNE zu pullen, beansprucht denselben Slice auf seinem main
  cd "$WORK/sim/bob"; printf '# Slice slice-003\n\n**Welle:** welle-2-ausbau\n\n**Verantwortlich:** bob.\n' > docs/plan/planning/in-progress/slice-003-ausbau.md
  schritt git add -A && schritt git commit -qm "claim slice-003 (bob)" || return 1
  out=$(git push origin main 2>&1); rc=$?
  [ $rc -ne 0 ] && echo "$out" | grep -q "rejected\|fetch first\|fast-forward" && ok=0 || ok=1
  verdikt "s01 Doppel-Anspruch: zweiter Push laut abgelehnt" "push rejected (non-fast-forward)" "rc=$rc" $ok
  # und nach dem Pull SIEHT bob den Anspruch samt Inhaber
  git pull -q --no-rebase origin main 2>/dev/null
  # Merge-Konflikt in der Datei selbst ist auch "laut" — beides akzeptabel:
  if git ls-files -u | grep -q slice-003; then ok=0; beob="Merge-Konflikt in der Slice-Datei (laut)"; else grep -q "alice" docs/plan/planning/in-progress/slice-003-ausbau.md && ok=0 && beob="alice als Inhaber sichtbar" || { ok=1; beob="weder Konflikt noch Inhaber sichtbar"; }; fi
  verdikt "s01b Anspruch nach Pull sichtbar oder Konflikt laut" "sichtbar/Konflikt" "$beob" $ok
}

s02_stille_nummer() {
  topo
  cd "$WORK/sim/alice"; schritt git switch -qc a/cache || return 1; printf '# Slice slice-003: Cache\n' > docs/plan/planning/open/slice-003-cache.md
  schritt git add -A && schritt git commit -qm "slice-003-cache" && schritt git push -q origin a/cache || return 1
  cd "$WORK/sim/bob"; schritt git switch -qc b/index || return 1; printf '# Slice slice-003: Index\n' > docs/plan/planning/open/slice-003-index.md
  schritt git add -A && schritt git commit -qm "slice-003-index" && schritt git push -q origin b/index || return 1
  # beide "PRs" mergen
  cd "$WORK/sim/seedclone" && git fetch -q origin && git merge -q --no-edit origin/a/cache >/dev/null 2>&1 && git merge -q --no-edit origin/b/index >/dev/null 2>&1; rc=$?
  n=$(ls docs/plan/planning/open/slice-003-*.md 2>/dev/null | wc -l)
  [ $rc -eq 0 ] && [ "$n" = 2 ] && ok=0 || ok=1
  verdikt "s02 stille Nummern-Kollision: Merge glatt, zwei slice-003" "rc=0, 2 Dateien" "rc=$rc, $n Dateien" $ok
}

s03_register_doppelzeile() {
  topo
  cd "$WORK/sim/alice"; schritt git switch -qc a/beo || return 1
  sed -i 's/| 1× | slice-001 |/| 2× | slice-001, slice-003 |/' docs/plan/planning/observations.md
  schritt git add -A && schritt git commit -qm "BEO-001 erhoeht" && schritt git push -q origin a/beo || return 1
  cd "$WORK/sim/bob"; schritt git switch -qc b/beo || return 1
  printf '| BEO-005 | Fixture-Pfade driften (neu benannt) | Kern | 1× | slice-004 | offen |\n' >> docs/plan/planning/observations.md
  schritt git add -A && schritt git commit -qm "neue Zeile fuers selbe Phaenomen" && schritt git push -q origin b/beo || return 1
  cd "$WORK/sim/seedclone" && git fetch -q && git merge -q --no-edit origin/a/beo >/dev/null 2>&1 && git merge -q --no-edit origin/b/beo >/dev/null 2>&1; rc=$?
  zeilen=$(grep -c "Fixture-Pfade driften" docs/plan/planning/observations.md)
  [ $rc -eq 0 ] && [ "$zeilen" = 2 ] && ok=0 || ok=1
  verdikt "s03 Register (mit Abstand): Doppel-Zeile mergt STILL" "rc=0, 2 Zeilen fuers selbe Phaenomen" "rc=$rc, $zeilen Zeilen" $ok
}

# s04 — Offene Wellen: Singleton (mode one) gegen Bijektion (mode many),
# beide Richtungen der Bijektion. Reihenfolge der Verdikte: a b e f i.
s04_zwei_wellen_und_waves() {
  topo
  cd "$WORK/sim/alice"
  printf '# Welle welle-2-ausbau: Ausbau\n\n**Verantwortlich:** bob. **Datum:** 2026-08-16.\n' > docs/plan/planning/welle-2-ausbau.md
  sed -i 's|- \[welle-1-basis\](../welle-1-basis.md)|- [welle-1-basis](../welle-1-basis.md)\n- [welle-2-ausbau](../welle-2-ausbau.md)|' docs/plan/planning/in-progress/roadmap.md
  sed -i '/welle-2-ausbau | welle-1 done/d' docs/plan/planning/in-progress/roadmap.md
  schritt git add -A && schritt git commit -qm "zweite offene Welle" && schritt git push -q origin main || return 1
  out=$(dcheck "$WORK/sim/alice"); echo "$out" | grep -q "0 Befund" && ok=0 || ok=1
  verdikt "s04a zwei offene Wellen: planning ohne waves GRUEN" "0 Befunde" "$(echo "$out"|tail -1)" $ok
  # waves einschalten -> Singleton-Semantik (Default mode: one) muss beissen
  printf '  waves:\n    dir: docs/plan/planning\n' >> .d-check.yml
  out=$(dcheck "$WORK/sim/alice"); befund "$out" "docs/plan/planning" "wave-drift" && ok=0 || ok=1
  verdikt "s04b waves.dir an: Singleton meldet wave-drift" "wave-drift (target: Verzeichnis)" "$(echo "$out"|tail -1)" $ok
  # Bijektion statt Singleton (d-check v0.62.0, der CR dieses Repos): derselbe
  # Zustand unter mode: many — Kennungs-Mengen in beide Richtungen, Marker aussen vor.
  printf '    mode: many\n' >> .d-check.yml
  out=$(dcheck "$WORK/sim/alice"); echo "$out" | grep -q "0 Befund" && ok=0 || ok=1
  verdikt "s04e waves.dir + mode: many: zwei offene Wellen GRUEN" "0 Befunde" "$(echo "$out"|tail -1)" $ok
  # Gegenprobe: die Bijektion muss beissen — dritte Welle flach OHNE Zeiger.
  # Ohne diesen Lauf waere "many prueft die Liste" nur behauptet (gruen ist
  # auch ein Sensor, der nichts liest).
  printf '# Welle welle-3-x: X\n\n**Verantwortlich:** alice. **Datum:** 2026-08-22.\n' > docs/plan/planning/welle-3-x.md
  out=$(dcheck "$WORK/sim/alice"); befund "$out" "welle-3" "wave-drift" && ok=0 || ok=1
  verdikt "s04f many: Datei ohne Zeiger meldet wave-drift (Bijektion beisst)" "wave-drift (target: welle-3)" "$(echo "$out"|tail -1)" $ok
  # Die andere Richtung: Zeiger ohne Datei. Bare Kennung statt Link, damit
  # allein die Bijektion spricht und nicht zusaetzlich `links` (target-missing).
  rm docs/plan/planning/welle-3-x.md
  sed -i 's|^- \[welle-2-ausbau\](../welle-2-ausbau.md)$|- [welle-2-ausbau](../welle-2-ausbau.md)\n- welle-5-x (Zeiger ohne Datei)|' docs/plan/planning/in-progress/roadmap.md
  out=$(dcheck "$WORK/sim/alice"); befund "$out" "welle-5" "wave-drift" && ok=0 || ok=1
  verdikt "s04i many: Zeiger ohne Datei meldet wave-drift (beide Richtungen)" "wave-drift (target: welle-5)" "$(echo "$out"|tail -1)" $ok
}

s04g_eroeffnet_unter_waves() {
  # Der Handbuch-Fall: EINE Welle eroeffnet (Zeiger steht), nichts beansprucht
  # (Marker steht, in-progress/ leer). Unter mode: one absichtlich rot — der
  # Block wird gegen genau eine Datei gehalten —, unter many gruen. Bewusst
  # NICHT der s04c-Zustand mit zwei flachen Wellen: dort ist one zufaellig
  # gruen, weil der Bool-Vergleich bei stehendem Marker nur "ungleich 1" prueft.
  topo
  cd "$WORK/sim/alice"
  schritt git mv docs/plan/planning/in-progress/slice-001-kern.md docs/plan/planning/open/ || return 1
  sed -i 's|^- \[welle-1-basis\](../welle-1-basis.md)$|- [welle-1-basis](../welle-1-basis.md)\n\nNichts in Arbeit.|' docs/plan/planning/in-progress/roadmap.md
  printf '  waves:\n    dir: docs/plan/planning\n' >> .d-check.yml
  schritt git add -A && schritt git commit -qm "Welle eroeffnet, nichts beansprucht, waves im Default" && schritt git push -q origin main || return 1
  out=$(dcheck "$WORK/sim/alice"); befund "$out" "docs/plan/planning" "wave-drift" && ok=0 || ok=1
  verdikt "s04g eine Welle eroeffnet + Marker, mode one: wave-drift (Singleton)" "wave-drift (target: Verzeichnis)" "$(echo "$out"|tail -1)" $ok
  printf '    mode: many\n' >> .d-check.yml
  out=$(dcheck "$WORK/sim/alice"); echo "$out" | grep -q "0 Befund" && ok=0 || ok=1
  verdikt "s04h dito unter mode many: GRUEN (Marker geht nicht ein)" "0 Befunde" "$(echo "$out"|tail -1)" $ok
}

s04c_leerer_anspruch() {
  # Spiegelrichtung zur bekannten Negativ-Probe (Marker BEI beanspruchtem Slice
  # meldet rot): offene Wellen in der Liste UND nichts beansprucht — der
  # baseline-legitime Zustand nach der Wellen-Eroeffnung. Misst, dass der
  # Waechter die MARKER-Haelfte prueft und die Liste ihn nicht stoert.
  topo
  cd "$WORK/sim/alice"
  printf '# Welle welle-2-ausbau: Ausbau\n\n**Verantwortlich:** bob. **Datum:** 2026-08-16.\n' > docs/plan/planning/welle-2-ausbau.md
  sed -i 's|- \[welle-1-basis\](../welle-1-basis.md)|- [welle-1-basis](../welle-1-basis.md)\n- [welle-2-ausbau](../welle-2-ausbau.md)|' docs/plan/planning/in-progress/roadmap.md
  sed -i '/welle-2-ausbau | welle-1 done/d' docs/plan/planning/in-progress/roadmap.md
  # Anspruch zuruecknehmen: in-progress/ traegt keinen Slice mehr ...
  schritt git mv docs/plan/planning/in-progress/slice-001-kern.md docs/plan/planning/open/ || return 1
  # ... und der Ruhe-Marker tritt NEBEN die Liste, nicht an ihre Stelle.
  sed -i 's|- \[welle-2-ausbau\](../welle-2-ausbau.md)|- [welle-2-ausbau](../welle-2-ausbau.md)\n\nNichts in Arbeit.|' docs/plan/planning/in-progress/roadmap.md
  schritt git add -A && schritt git commit -qm "Anspruch zurueck, Ruhe-Marker neben der Liste" && schritt git push -q origin main || return 1
  out=$(dcheck "$WORK/sim/alice"); echo "$out" | grep -q "0 Befund" && ok=0 || ok=1
  verdikt "s04c Marker NEBEN Liste (Wellen offen, nichts beansprucht): planning GRUEN" "0 Befunde" "$(echo "$out"|tail -1)" $ok
  # Gegenprobe, zweite Richtung derselben Aequivalenz: Marker weg, in-progress/
  # weiter leer. Ohne diesen Lauf waere "haelt in BEIDE Richtungen" behauptet.
  sed -i '/^Nichts in Arbeit\.$/d' docs/plan/planning/in-progress/roadmap.md
  schritt git add -A && schritt git commit -qm "Marker entfernt (Gegenprobe)" && schritt git push -q origin main || return 1
  out=$(dcheck "$WORK/sim/alice"); echo "$out" | grep -q "planning-drift" && ok=0 || ok=1
  verdikt "s04d Marker FEHLT bei leerem in-progress/: planning ROT" "planning-drift (Ruhe-Marker fehlt)" "$(echo "$out"|tail -1)" $ok
}

s05_mr_hybrid() {
  topo
  cd "$WORK/sim/alice"; schritt git switch -qc a/mr || return 1
  mkdir -p harness/conventions && printf '# MR-001: Alpha\n' > harness/conventions/MR-001-alpha.md
  sed -i 's/| MR-000 | 2026-08-16 | Baseline-Aussage |/| MR-000 | 2026-08-16 | Baseline-Aussage |\n| MR-001 | 2026-08-16 | Alpha |/' harness/conventions.md
  schritt git add -A && schritt git commit -qm "MR-001 alpha" && schritt git push -q origin a/mr || return 1
  cd "$WORK/sim/bob"; schritt git switch -qc b/mr || return 1
  mkdir -p harness/conventions && printf '# MR-001: Beta\n' > harness/conventions/MR-001-beta.md
  sed -i 's/| MR-000 | 2026-08-16 | Baseline-Aussage |/| MR-000 | 2026-08-16 | Baseline-Aussage |\n| MR-001 | 2026-08-16 | Beta |/' harness/conventions.md
  schritt git add -A && schritt git commit -qm "MR-001 beta" && schritt git push -q origin b/mr || return 1
  cd "$WORK/sim/seedclone" && git fetch -q && git merge -q --no-edit origin/a/mr >/dev/null 2>&1
  git merge --no-edit origin/b/mr >/dev/null 2>&1; rc=$?
  dateien=$(ls harness/conventions/MR-001-*.md 2>/dev/null | wc -l)
  konflikt=$([ $rc -ne 0 ] && git ls-files -u | grep -q conventions.md && echo ja || echo nein)
  [ "$dateien" = 2 ] && [ "$konflikt" = ja ] && ok=0 || ok=1
  verdikt "s05 MR-Hybrid: Dateien still (2x MR-001), Index-Zeile LAUT" "2 Dateien + Index-Konflikt" "$dateien Dateien, Konflikt=$konflikt" $ok
}

s06_branch_protection() {
  topo
  cat > "$WORK/sim/origin.git/hooks/pre-receive" <<'HOOK'
#!/bin/sh
while read old new ref; do
  [ "$ref" = "refs/heads/main" ] && echo "main ist geschuetzt (Branch-Protection-Simulation)" && exit 1
done
exit 0
HOOK
  chmod +x "$WORK/sim/origin.git/hooks/pre-receive"
  cd "$WORK/sim/alice"; printf '# Slice slice-003\n\n**Verantwortlich:** alice.\n' > docs/plan/planning/in-progress/slice-003-ausbau.md
  schritt git add -A && schritt git commit -qm "claim auf main" || return 1
  out=$(git push origin main 2>&1); rc=$?
  [ $rc -ne 0 ] && echo "$out" | grep -q "geschuetzt" && ok=0 || ok=1
  verdikt "s06 Branch-Protection: TA-7-Anspruch scheitert am Hook" "push abgelehnt (Hook-Meldung)" "rc=$rc" $ok
}

s07_sichtung_liest_alt() {
  topo
  cd "$WORK/sim/alice"; schritt git switch -qc a/closure || return 1
  sed -i 's/| 1× | slice-001 |/| 3× | slice-001, slice-005, slice-006 |/' docs/plan/planning/observations.md
  schritt git add -A && schritt git commit -qm "BEO-001 auf 3x (im PR)" && schritt git push -q origin a/closure || return 1
  cd "$WORK/sim/bob" && git pull -q origin main
  stand=$(grep -o "| [0-9]×" docs/plan/planning/observations.md | head -1)
  [ "$stand" = "| 1×" ] && ok=0 || ok=1
  verdikt "s07 Sichtung liest gemergten Stand: 1x trotz 3x im offenen PR" "1×" "$stand" $ok
}

# s08 — Closure-Seite unter Nebenlaeufigkeit (Modul 6 §Wellen-Closure-Prozedur,
# Schritt 1 "Alle Slices der Welle liegen in done/" ist Prozedur, kein Sensor).
s08_closure_unter_anspruch() {
  topo
  cd "$WORK/sim/bob"; schritt git switch -qc b/arbeit || return 1
  sed -i 's/^Offen\.$/In Arbeit: Kern-Modul, erster Schnitt./' docs/plan/planning/in-progress/slice-001-kern.md
  schritt git add -A && schritt git commit -qm "slice-001: Arbeit im PR" && schritt git push -q origin b/arbeit || return 1
  # alice schliesst welle-1-basis auf main — schlampig: Zeile im Register, keine Ergebnisnotiz
  cd "$WORK/sim/alice"
  printf '  waves:\n    dir: docs/plan/planning\n    mode: many\n' >> .d-check.yml
  schritt git mv docs/plan/planning/welle-1-basis.md docs/plan/planning/done/ || return 1
  sed -i '/^- \[welle-1-basis\](..\/welle-1-basis.md)$/d' docs/plan/planning/in-progress/roadmap.md
  printf '| welle-1-basis | 2026-08-22 | done/welle-1-results.md |\n' >> docs/plan/planning/in-progress/roadmap.md
  schritt git add -A && schritt git commit -qm "welle-1-basis geschlossen (ohne Notiz)" && schritt git push -q origin main || return 1
  out=$(dcheck "$WORK/sim/alice"); befund "$out" "welle-1" "wave-results-missing" && ok=0 || ok=1
  verdikt "s08a Welle geschlossen ohne Ergebnisnotiz: wave-results-missing" "wave-results-missing (target: welle-1)" "$(echo "$out"|tail -1)" $ok
  # sauber nachgezogen: Ergebnisnotiz liegt — der Slice der Welle ist weiter
  # beansprucht (in-progress/, und in bobs offenem PR): sieht das ein Sensor?
  printf '# Welle 1 — Basis — Closure-Notiz\n\n**Welle:** welle-1-basis\n\nGeliefert: Kern-Schnittstelle. Offen geblieben: slice-001.\n' > docs/plan/planning/done/welle-1-results.md
  schritt git add -A && schritt git commit -qm "welle-1-results" && schritt git push -q origin main || return 1
  out=$(dcheck "$WORK/sim/alice"); echo "$out" | grep -q "0 Befund" && ok=0 || ok=1
  verdikt "s08b Welle sauber geschlossen, Slice der Welle weiter beansprucht: STILL" "0 Befunde (kein Sensor sieht den Widerspruch)" "$(echo "$out"|tail -1)" $ok
}

# s09 — Vorvergabe (source-precedence §Vergabe: "lokal ableitbar hat eine
# Grenze — den PR-Rest faengt das Schema nicht"; TB-010).
s09_vorvergabe() {
  topo
  # welle-1-basis §4 vergibt slice-002 (Rand) — ohne Datei. bob zieht dieselbe
  # Nummer fuer etwas anderes, im PR.
  cd "$WORK/sim/bob"; schritt git switch -qc b/cache || return 1
  printf '# Slice slice-002: Cache\n\n**Welle:** ohne Welle\n\n**Verantwortlich:** bob.\n' > docs/plan/planning/open/slice-002-cache.md
  schritt git add -A && schritt git commit -qm "slice-002-cache" && schritt git push -q origin b/cache || return 1
  cd "$WORK/sim/seedclone" && git fetch -q && git merge -q --no-edit origin/b/cache >/dev/null 2>&1; rc=$?
  plan=$(grep -c "slice-002 (Rand)" docs/plan/planning/welle-1-basis.md)
  out=$(dcheck "$WORK/sim/seedclone"); echo "$out" | grep -q "0 Befund" && d=0 || d=1
  [ $rc -eq 0 ] && [ "$plan" = 1 ] && [ $d = 0 ] && ok=0 || ok=1
  verdikt "s09 Vorvergabe: slice-002 im Wellen-Plan, anderswo vergeben — STILL" "Merge rc=0, beide Bedeutungen, 0 Befunde" "rc=$rc, Plan-Nennung=$plan, $(echo "$out"|tail -1)" $ok
}

# s10 — Rolleninhaber-Feld (TA-1; Modul 5 §Lifecycle: Verantwortlich wird
# beim Uebergang gesetzt). Laut nur, wenn beide dieselbe Zeile anfassen.
s10_inhaber_feld() {
  topo
  cd "$WORK/sim/alice"; schritt git switch -qc a/own || return 1
  sed -i 's/^\*\*Verantwortlich:\*\* alice\.$/**Verantwortlich:** alice (bestaetigt 2026-08-22)./' docs/plan/planning/in-progress/slice-001-kern.md
  schritt git add -A && schritt git commit -qm "Inhaber bestaetigt (alice)" && schritt git push -q origin a/own || return 1
  cd "$WORK/sim/bob"; schritt git switch -qc b/own || return 1
  sed -i 's/^\*\*Verantwortlich:\*\* alice\.$/**Verantwortlich:** bob./' docs/plan/planning/in-progress/slice-001-kern.md
  schritt git add -A && schritt git commit -qm "Inhaber uebernommen (bob)" && schritt git push -q origin b/own || return 1
  cd "$WORK/sim/seedclone" && git fetch -q && git merge -q --no-edit origin/a/own >/dev/null 2>&1
  git merge --no-edit origin/b/own >/dev/null 2>&1; rc=$?
  konflikt=$([ $rc -ne 0 ] && git ls-files -u | grep -q slice-001 && echo ja || echo nein)
  [ "$konflikt" = ja ] && ok=0 || ok=1
  verdikt "s10a beide setzen das Inhaber-Feld: Konflikt (LAUT)" "Merge-Konflikt in der Slice-Datei" "rc=$rc, Konflikt=$konflikt" $ok
  git merge --abort 2>/dev/null || true
  # zweite Probe vom Seed-Stand aus, nicht vom halb gemergten
  schritt git reset -q --hard origin/main || return 1
  # Uebernahme ohne Gegenwehr: bob setzt das Feld, alice aendert nur den Rumpf
  cd "$WORK/sim/alice"; schritt git switch -q main || return 1; git pull -q origin main 2>/dev/null; schritt git switch -qc a/body || return 1
  sed -i 's/^Offen\.$/In Arbeit: Kern-Modul./' docs/plan/planning/in-progress/slice-001-kern.md
  schritt git add -A && schritt git commit -qm "Rumpf (alice)" && schritt git push -q origin a/body || return 1
  cd "$WORK/sim/seedclone" && git fetch -q && git merge -q --no-edit origin/a/body >/dev/null 2>&1 && git merge -q --no-edit origin/b/own >/dev/null 2>&1; rc=$?
  inhaber=$(grep -o "Verantwortlich:\*\* [a-z]*" docs/plan/planning/in-progress/slice-001-kern.md | head -1)
  [ $rc -eq 0 ] && [ "$inhaber" = "Verantwortlich:** bob" ] && ok=0 || ok=1
  verdikt "s10b Uebernahme des Feldes, alice aendert nur den Rumpf: STILL" "rc=0, Inhaber=bob" "rc=$rc, $inhaber" $ok
}

# s11 — doc-immutable im Team (Modul 4: Accepted-ADR ist immutabel; Modul vcs
# braucht eine Commit-Range — der PR-Job). Geschichte-Zeile erlaubt, Kern nicht.
s11_adr_immutabel_im_team() {
  topo
  base=$(git -C "$WORK/sim/seedclone" rev-parse HEAD)
  cd "$WORK/sim/bob"; schritt git switch -qc b/geschichte || return 1
  printf -- '- 2026-08-22: im Team gesichtet.\n' >> docs/plan/adr/0001-kern.md
  schritt git add -A && schritt git commit -qm "ADR-0001 Geschichte" && schritt git push -q origin b/geschichte || return 1
  cd "$WORK/sim/alice"; schritt git switch -qc a/kern || return 1
  sed -i 's/^Der Kern ist ein eigenes Modul mit eigener Schnittstelle;/Der Kern ist ein Paket ohne eigene Schnittstelle;/' docs/plan/adr/0001-kern.md
  schritt git add -A && schritt git commit -qm "ADR-0001 Entscheidung geaendert" && schritt git push -q origin a/kern || return 1
  vcs() { docker run --rm --network none -v "$1:/repo:ro" "$IMG" --enable vcs --disable links --disable anchors --disable planning --range "$2" 2>&1; }
  cd "$WORK/sim/seedclone" && git fetch -q && git merge -q --no-edit origin/b/geschichte >/dev/null 2>&1
  out=$(vcs "$WORK/sim/seedclone" "$base..HEAD"); echo "$out" | grep -q "0 Befund" && ok=0 || ok=1
  verdikt "s11a Geschichte-Zeile per PR gelandet: kein Befund" "0 Befunde (Geschichte ist ausgenommen)" "$(echo "$out"|tail -1)" $ok
  git merge -q --no-edit origin/a/kern >/dev/null 2>&1
  out=$(vcs "$WORK/sim/seedclone" "$base..HEAD"); befund "$out" "docs/plan/adr/0001-kern.md" "core-drift-vcs" && ok=0 || ok=1
  verdikt "s11b Entscheidung einer Accepted-ADR per PR gelandet: core-drift-vcs" "core-drift-vcs auf der Range" "$(echo "$out"|tail -1)" $ok
}

# ---------------------------------------------------------------------------
# s12-s18 — die Verzeichnisform des Beobachtungs-Registers (ENTWURF).
# Gegenstand ist NICHT die gelehrte Form: Der Seed traegt weiter die flache
# observations.md aus Modul 6 (s03/s07 messen sie). Die Verzeichnisform steht
# in docs/steering-loop-team.md als Diskussionsstand; ihr §Naechster
# belastbarer Schritt nennt genau die sieben Faelle, die hier laufen. Sie
# gehoert darum in die Szenarien, nicht in den Seed.
#
# Die drei Dateiklassen der Zielstruktur:
#   observation.md      Kennung + Herkunfts-Sub-Area   (immutabel)
#   state.md            Zustand, Ausgang               (veraenderlich)
#   evidence/<slice>.md genau ein belegtes Auftreten   (immutabel)
# `**Kennung:**` steht in beiden immutablen Klassen und in state.md nicht —
# damit traegt EIN `vcs.immutable-when` genau die Klassen, die es soll.
BEOWURZEL="docs/plan/planning/observations"

beleg() { # $1 clone  $2 kennung(NS/slug)  $3 slice-kennung
  printf '# Beleg %s\n\n**Kennung:** %s\n\n**Slice:** %s\n' "$3" "$2" "$3" \
    > "$1/$BEOWURZEL/$2/evidence/$3.md"
}
beo() { # $1 clone  $2 kennung(NS/slug)  $3.. slice-kennungen
  local w="$1" k="$2" s; shift 2
  mkdir -p "$w/$BEOWURZEL/$k/evidence"
  printf '# Beobachtung %s\n\n**Kennung:** %s\n\n**Herkunfts-Sub-Area:** %s\n' "$k" "$k" "${k%%/*}" \
    > "$w/$BEOWURZEL/$k/observation.md"
  printf '# Stand\n\n**Zustand:** offen\n' > "$w/$BEOWURZEL/$k/state.md"
  for s in "$@"; do beleg "$w" "$k" "$s"; done
}
belege() { ls "$1/$BEOWURZEL/$2/evidence" 2>/dev/null | wc -l; }   # abgeleiteter Zaehler
# vcs fokussiert wie in s11: nur das Modul, das die Aussage traegt.
vcslauf() { docker run --rm --network none -v "$1:/repo:ro" "$IMG" \
  --enable vcs --disable links --disable anchors --disable planning --range "$2" 2>&1; }
# derselbe Lauf ueber den zweiten dokumentierten Eingabe-Modus: HEAD gegen Index.
vcsstaged() { docker run --rm --network none -v "$1:/repo:ro" "$IMG" \
  --enable vcs --disable links --disable anchors --disable planning --staged 2>&1; }
# Config-Variante fuer die Pfadidentitaet: dieselbe vcs-Mechanik wie beim
# ADR-Kern (s11), nur auf die Beobachtungs-Klasse gerichtet.
beo_vcs_config() { cat > "$1/.d-check.yml" <<'YML'
scan:
  roots: ["."]
modules: [links, anchors, planning]
vcs:
  paths: ["docs/plan/planning/observations/**/*.md"]
  immutable-when: '^\*\*Kennung:\*\*'
planning:
  roadmap: docs/plan/planning/in-progress/roadmap.md
  heading: '## Offene Wellen'
  marker: 'Nichts in Arbeit'
YML
}

# s12 — Fall 1: zwei Evidence-Dateien fuer dieselbe BEO mergen und korrekt
# zaehlen. Die Gegenprobe zu s03: dort kollidiert oder verdoppelt sich die
# gemeinsame Zeile, hier addieren sich getrennte Dateien ohne Zutun.
s12_belege_mergen() {
  topo
  beo "$WORK/sim/alice" "BEO-REPLAY/golden-set-ohne-boundary" slice-001
  cd "$WORK/sim/alice"
  schritt git add -A && schritt git commit -qm "BEO-REPLAY/golden-set-ohne-boundary (1 Beleg)" && schritt git push -q origin main || return 1
  schritt git switch -qc a/beleg || return 1
  beleg "$WORK/sim/alice" "BEO-REPLAY/golden-set-ohne-boundary" slice-003
  schritt git add -A && schritt git commit -qm "Beleg slice-003" && schritt git push -q origin a/beleg || return 1
  cd "$WORK/sim/bob"; schritt git pull -q origin main || return 1; schritt git switch -qc b/beleg || return 1
  beleg "$WORK/sim/bob" "BEO-REPLAY/golden-set-ohne-boundary" slice-004
  schritt git add -A && schritt git commit -qm "Beleg slice-004" && schritt git push -q origin b/beleg || return 1
  cd "$WORK/sim/seedclone"; schritt git pull -q --no-rebase origin main || return 1
  git fetch -q origin && git merge -q --no-edit origin/a/beleg >/dev/null 2>&1 && git merge -q --no-edit origin/b/beleg >/dev/null 2>&1; rc=$?
  n=$(belege "$WORK/sim/seedclone" "BEO-REPLAY/golden-set-ohne-boundary")
  [ $rc -eq 0 ] && [ "$n" = 3 ] && ok=0 || ok=1
  verdikt "s12 zwei Belege aus zwei PRs: Merge glatt, abgeleiteter Zaehler 3" "rc=0, 3 Evidence-Dateien" "rc=$rc, $n Dateien" $ok
}

# s13 — Fall 2: gleichzeitige Neuanlage desselben Namespace/Slug-Pfads wird
# laut. Der Pfad IST die Kennung; zwei Formulierungen desselben Phaenomens
# treffen sich in derselben Datei. (Wortgleich angelegt bliebe es still —
# deshalb formulieren beide eigenstaendig, wie im echten Fall.)
s13_gleicher_pfad_laut() {
  topo
  cd "$WORK/sim/alice"; schritt git switch -qc a/neu || return 1
  beo "$WORK/sim/alice" "BEO-REPLAY/golden-set-ohne-boundary" slice-003
  printf '\nGolden Set nimmt keinen Boundary-Fall auf (alice).\n' >> "$WORK/sim/alice/$BEOWURZEL/BEO-REPLAY/golden-set-ohne-boundary/observation.md"
  schritt git add -A && schritt git commit -qm "BEO angelegt (alice)" && schritt git push -q origin a/neu || return 1
  cd "$WORK/sim/bob"; schritt git switch -qc b/neu || return 1
  beo "$WORK/sim/bob" "BEO-REPLAY/golden-set-ohne-boundary" slice-004
  printf '\nDer Grenzfall fehlt im Golden Set (bob).\n' >> "$WORK/sim/bob/$BEOWURZEL/BEO-REPLAY/golden-set-ohne-boundary/observation.md"
  schritt git add -A && schritt git commit -qm "BEO angelegt (bob)" && schritt git push -q origin b/neu || return 1
  cd "$WORK/sim/seedclone" && git fetch -q origin && git merge -q --no-edit origin/a/neu >/dev/null 2>&1
  git merge --no-edit origin/b/neu >/dev/null 2>&1; rc=$?
  konflikt=$([ $rc -ne 0 ] && git ls-files -u | grep -q "BEO-REPLAY/golden-set-ohne-boundary/observation.md" && echo ja || echo nein)
  [ "$konflikt" = ja ] && ok=0 || ok=1
  verdikt "s13 derselbe Namespace/Slug in zwei PRs: add/add-Konflikt auf observation.md" "Konflikt auf observation.md (laut)" "rc=$rc, Konflikt=$konflikt" $ok
}

# s14 — Fall 3: paralleler Uebergang von 1x auf zusammen 3x. Der Zaehler ist
# nach dem Merge richtig (das leistet die Form); dass der Uebertritt einen
# Ausgang verlangt, leistet heute niemand — genau dafuer liegt der CR.
s14_schwelle_im_merge() {
  topo
  beo "$WORK/sim/alice" "BEO-REPLAY/golden-set-ohne-boundary" slice-001
  cd "$WORK/sim/alice"
  schritt git add -A && schritt git commit -qm "BEO mit einem Beleg" && schritt git push -q origin main || return 1
  schritt git switch -qc a/zwei || return 1
  beleg "$WORK/sim/alice" "BEO-REPLAY/golden-set-ohne-boundary" slice-003
  schritt git add -A && schritt git commit -qm "zweiter Beleg (alice)" && schritt git push -q origin a/zwei || return 1
  cd "$WORK/sim/bob"; schritt git pull -q origin main || return 1; schritt git switch -qc b/zwei || return 1
  beleg "$WORK/sim/bob" "BEO-REPLAY/golden-set-ohne-boundary" slice-004
  schritt git add -A && schritt git commit -qm "zweiter Beleg (bob)" && schritt git push -q origin b/zwei || return 1
  na=$(belege "$WORK/sim/alice" "BEO-REPLAY/golden-set-ohne-boundary")
  nb=$(belege "$WORK/sim/bob" "BEO-REPLAY/golden-set-ohne-boundary")
  [ "$na" = 2 ] && [ "$nb" = 2 ] && ok=0 || ok=1
  verdikt "s14a beide Branches zaehlen lokal 2 (unter der Schwelle)" "alice=2, bob=2" "alice=$na, bob=$nb" $ok
  cd "$WORK/sim/seedclone"; schritt git pull -q --no-rebase origin main || return 1
  git fetch -q origin && git merge -q --no-edit origin/a/zwei >/dev/null 2>&1 && git merge -q --no-edit origin/b/zwei >/dev/null 2>&1; rc=$?
  n=$(belege "$WORK/sim/seedclone" "BEO-REPLAY/golden-set-ohne-boundary")
  zustand=$(grep -o "Zustand:\*\* [a-z]*" "$BEOWURZEL/BEO-REPLAY/golden-set-ohne-boundary/state.md")
  out=$(dcheck "$WORK/sim/seedclone")
  [ $rc -eq 0 ] && [ "$n" = 3 ] && echo "$out" | grep -q "0 Befund" && ok=0 || ok=1
  verdikt "s14b Merge-Stand 3x mit Zustand offen ohne Ausgang: STILL" "3 Belege, kein Befund (kein Sensor haelt die Schwelle)" "$n Belege, $zustand, $(echo "$out"|tail -1)" $ok
}

# s15 — Fall 4: Rename von Namespace oder Slug. Der Antrag stuetzte die
# Pfadidentitaet auf DC-FA-VCS-001 ("geloeschte oder umbenannte immutable
# Datei"). Unter v0.67.0 hielt die Zusage nur ueber `--staged`; ueber `--range`
# — den CI-Pfad — blieb derselbe Rename still, weil go-gits Tree-Diff ihn als
# Rename erkannte und d-check ihn auf dem NEUEN Pfad buchte, wo BASE nichts
# hat. Das war ein WERKZEUG-Befund dieses Repos; d-check hat ihn bestaetigt
# und in v0.71.1 behoben (Range-Diff ohne Rename-Erkennung). Seit dem
# Pin-Bump misst s15b den FIX: beide Eingabe-Modi antworten gleich.
# PIN-GEBUNDEN bleibt es trotzdem — wer auf < v0.71.1 zurueckgeht, dreht
# s15b und s16c wieder auf "still".
s15_pfadidentitaet() {
  topo
  beo_vcs_config "$WORK/sim/alice"
  beo "$WORK/sim/alice" "BEO-REPLAY/golden-set-ohne-boundary" slice-001 slice-003
  cd "$WORK/sim/alice"
  schritt git add -A && schritt git commit -qm "BEO angelegt (vcs auf die Beobachtungs-Klasse)" || return 1
  base=$(git rev-parse HEAD)
  alt="$BEOWURZEL/BEO-REPLAY/golden-set-ohne-boundary/observation.md"
  # Ein und derselbe Rename, zweimal gemessen: erst gestaged, dann committet.
  schritt git mv "$BEOWURZEL/BEO-REPLAY/golden-set-ohne-boundary" "$BEOWURZEL/BEO-REPLAY/golden-set-luecke" || return 1
  out=$(vcsstaged "$WORK/sim/alice"); befund "$out" "$alt" "core-drift-vcs" && ok=0 || ok=1
  verdikt "s15a Slug umbenannt, --staged: core-drift-vcs" "core-drift-vcs (target: alter Pfad)" "$(echo "$out"|tail -1)" $ok
  schritt git commit -qm "Slug umbenannt, Inhalt unveraendert" || return 1
  out=$(vcslauf "$WORK/sim/alice" "$base..HEAD"); befund "$out" "$alt" "core-drift-vcs" && ok=0 || ok=1
  verdikt "s15b derselbe Rename, --range: core-drift-vcs (Fix in v0.71.1)" "core-drift-vcs (target: alter Pfad) — beide Eingabe-Modi antworten gleich" "$(echo "$out"|tail -1)" $ok
  # Die Grenze des stillen Falls: faellt die Aehnlichkeit, greift die Delete-Haelfte.
  schritt git reset -q --hard "$base" || return 1
  schritt git mv "$BEOWURZEL/BEO-REPLAY" "$BEOWURZEL/BEO-TEST" || return 1
  printf '# Beobachtung\n\n**Kennung:** BEO-TEST/golden-set-ohne-boundary\n\n**Herkunfts-Sub-Area:** BEO-TEST\n\nVollstaendig neu formuliert, kein Satz des alten Textes bleibt stehen.\n' \
    > "$BEOWURZEL/BEO-TEST/golden-set-ohne-boundary/observation.md"
  schritt git add -A && schritt git commit -qm "Namespace umbenannt und neu formuliert" || return 1
  out=$(vcslauf "$WORK/sim/alice" "$base..HEAD"); befund "$out" "$alt" "core-drift-vcs" && ok=0 || ok=1
  verdikt "s15c Namespace umbenannt UND umformuliert, --range: core-drift-vcs" "core-drift-vcs (target: alter Pfad) — ohne Rename-Aehnlichkeit greift die Delete-Haelfte" "$(echo "$out"|tail -1)" $ok
}

# s16 — Fall 5: Aenderung oder Loeschung eines bestehenden Belegs wird
# gemeldet. Das ist die append-only-Zusage des Entwurfs: Ein falscher Beleg
# wird invalidiert (s18), nicht editiert und nicht geloescht.
s16_beleg_immutabel() {
  topo
  beo_vcs_config "$WORK/sim/alice"
  beo "$WORK/sim/alice" "BEO-REPLAY/golden-set-ohne-boundary" slice-001 slice-003
  cd "$WORK/sim/alice"
  schritt git add -A && schritt git commit -qm "BEO mit zwei Belegen" || return 1
  base=$(git rev-parse HEAD)
  bel="$BEOWURZEL/BEO-REPLAY/golden-set-ohne-boundary/evidence/slice-001.md"
  printf '\nNachtraeglich umformuliert.\n' >> "$bel"
  schritt git add -A && schritt git commit -qm "Beleg nachtraeglich geaendert" || return 1
  out=$(vcslauf "$WORK/sim/alice" "$base..HEAD"); befund "$out" "$bel" "core-drift-vcs" && ok=0 || ok=1
  verdikt "s16a bestehenden Beleg geaendert: core-drift-vcs" "core-drift-vcs (target: Evidence-Datei)" "$(echo "$out"|tail -1)" $ok
  schritt git reset -q --hard "$base" || return 1
  schritt git rm -q "$bel" || return 1
  schritt git commit -qm "Beleg geloescht" || return 1
  out=$(vcslauf "$WORK/sim/alice" "$base..HEAD"); befund "$out" "$bel" "core-drift-vcs" && ok=0 || ok=1
  verdikt "s16b bestehenden Beleg geloescht: core-drift-vcs" "core-drift-vcs (target: Evidence-Datei)" "$(echo "$out"|tail -1)" $ok
  # Die schaerfste Folge des s15-Befunds, jetzt die schaerfste Deckung: Der
  # Dateiname IST die Slice-Kennung. Vor v0.71.1 liess ein reiner Rename den
  # Zaehler richtig und machte den Beleg falsch — dieselbe Datei behauptete
  # danach einen anderen Slice, ohne Befund. Seit dem Fix meldet es.
  schritt git reset -q --hard "$base" || return 1
  schritt git mv "$bel" "$BEOWURZEL/BEO-REPLAY/golden-set-ohne-boundary/evidence/slice-009.md" || return 1
  schritt git commit -qm "Beleg auf eine andere Slice-Kennung umbenannt" || return 1
  n=$(belege "$WORK/sim/alice" "BEO-REPLAY/golden-set-ohne-boundary")
  out=$(vcslauf "$WORK/sim/alice" "$base..HEAD")
  [ "$n" = 2 ] && befund "$out" "$bel" "core-drift-vcs" && ok=0 || ok=1
  verdikt "s16c Beleg auf andere Slice-Kennung umbenannt, --range: core-drift-vcs" "Zaehler bleibt 2, core-drift-vcs (target: alter Beleg-Pfad)" "$n Belege, $(echo "$out"|tail -1)" $ok
}

# s17 — Fall 6: zwei verschiedene Slugs fuer dasselbe Phaenomen bleiben als
# bewusst erwartete Grenze sichtbar. Das Beispielpaar stammt aus dem Entwurf
# selbst. Still ist hier die ERWARTUNG, nicht das Versaeumnis: semantische
# Gleichheit entscheidet ein Mensch, und das ist der Punkt.
s17_zwei_slugs_still() {
  topo
  cd "$WORK/sim/alice"; schritt git switch -qc a/replay || return 1
  beo "$WORK/sim/alice" "BEO-REPLAY/golden-set-ohne-boundary" slice-003
  schritt git add -A && schritt git commit -qm "BEO-REPLAY/golden-set-ohne-boundary" && schritt git push -q origin a/replay || return 1
  cd "$WORK/sim/bob"; schritt git switch -qc b/test || return 1
  beo "$WORK/sim/bob" "BEO-TEST/grenzfall-fehlt-im-golden-set" slice-004
  schritt git add -A && schritt git commit -qm "BEO-TEST/grenzfall-fehlt-im-golden-set" && schritt git push -q origin b/test || return 1
  cd "$WORK/sim/seedclone" && git fetch -q origin && git merge -q --no-edit origin/a/replay >/dev/null 2>&1 && git merge -q --no-edit origin/b/test >/dev/null 2>&1; rc=$?
  n=$(ls -d "$BEOWURZEL"/*/*/ 2>/dev/null | wc -l)
  out=$(dcheck "$WORK/sim/seedclone")
  [ $rc -eq 0 ] && [ "$n" = 2 ] && echo "$out" | grep -q "0 Befund" && ok=0 || ok=1
  verdikt "s17 dasselbe Phaenomen unter zwei Slugs: STILL (bewusste Grenze)" "rc=0, 2 BEO-Verzeichnisse, 0 Befunde" "rc=$rc, $n Verzeichnisse, $(echo "$out"|tail -1)" $ok
}

# s18 — Fall 7: Invalidierung und Alias-Aufloesung. Der Merge legt alle
# Eingaben der Ableitung vor — Alias-Ziel, doppelte Slice-Kennung ueber die
# Gruppe, Invalidierung, Zyklus. Gelesen wird davon heute nichts. Die
# Ableitung ist genau das, was der CR beantragt; hier steht, was ohne ihn
# uebrig bleibt.
s18_alias_und_invalidierung() {
  topo
  kan="BEO-REPLAY/golden-set-ohne-boundary"; ali="BEO-TEST/grenzfall-fehlt-im-golden-set"
  beo "$WORK/sim/alice" "$kan" slice-001 slice-003
  beo "$WORK/sim/alice" "$ali" slice-003 slice-004
  cd "$WORK/sim/alice"
  printf '# Stand\n\n**Zustand:** alias\n\n**Alias-von:** %s\n' "$kan" > "$BEOWURZEL/$ali/state.md"
  mkdir -p "$BEOWURZEL/$kan/invalidations"
  printf '# Invalidierung slice-001\n\n**Nimmt zurueck:** slice-001\n\n**Grund:** falsch zugeordnet.\n' > "$BEOWURZEL/$kan/invalidations/slice-001.md"
  schritt git add -A && schritt git commit -qm "Alias-Gruppe mit Invalidierung" && schritt git push -q origin main || return 1
  dat=$( { ls "$BEOWURZEL/$kan/evidence"; ls "$BEOWURZEL/$ali/evidence"; } | wc -l )
  eind=$( { ls "$BEOWURZEL/$kan/evidence"; ls "$BEOWURZEL/$ali/evidence"; } | sort -u | wc -l )
  inv=$(ls "$BEOWURZEL/$kan/invalidations" | wc -l)
  out=$(dcheck "$WORK/sim/alice")
  [ "$dat" = 4 ] && [ "$eind" = 3 ] && [ "$inv" = 1 ] && echo "$out" | grep -q "0 Befund" && ok=0 || ok=1
  verdikt "s18a Alias-Gruppe: Beleg unter dem Alias, Kennung doppelt, eine Invalidierung: STILL" "4 Dateien / 3 eindeutige Kennungen, 1 Invalidierung, 0 Befunde" "$dat/$eind Dateien, $inv Invalidierung, $(echo "$out"|tail -1)" $ok
  printf '# Stand\n\n**Zustand:** alias\n\n**Alias-von:** %s\n' "$ali" > "$BEOWURZEL/$kan/state.md"
  schritt git add -A && schritt git commit -qm "Alias-Zyklus A -> B -> A" && schritt git push -q origin main || return 1
  out=$(dcheck "$WORK/sim/alice"); echo "$out" | grep -q "0 Befund" && ok=0 || ok=1
  verdikt "s18b Alias-Zyklus A -> B -> A: STILL" "0 Befunde (kein Sensor folgt der Kette)" "$(echo "$out"|tail -1)" $ok
}

# ---------------------------------------------------------------------------
# s19 — Zeitdokumente archivieren (ENTWURF, docs/zeitdokument-archiv.md).
# ERSTE Szenarien dieses Harness, die KEINE Nebenlaeufigkeit pruefen: Gegenstand
# ist eine Operation und ihr Sensor. Die Topologie bleibt trotzdem die des
# Harness — sie kostet nichts und haelt die Bauform gleich.
#
# Zielform nach Probe 2 (die den Entwurf geaendert hat): Der Geltungsbereich
# steht im PFAD, weil require-pattern ihn nicht ausdruecken kann.
#
#   done/welle-<NN>/archiv.zip + die Stubs der Welle
#   done/welle-<NN>-results.md   bleibt vollstaendig, bleibt flach
#   done/slice-<NNN>-*.md        Slices der noch OFFENEN Welle, unberuehrt
ARCHIVSENSOR='structure:
  - files: "docs/plan/planning/done/welle-*/slice-*.md"
    section-pattern: "^# slice-"
    require-pattern: "\\*\\*Archiviert mit:\\*\\*"
'
# Der Volltext eines Vorgangs: lang genug, dass die Kuerzung messbar ist.
volltext() { # $1 datei  $2 titel  $3 welle-feld
  printf '# %s\n\n**Welle:** %s\n\n## 7. Lerneintrag\n\nBeobachtung: die Zusage traegt den Sensor nicht, das Gate blieb still.\nDas Regelwerk nennt den Anker, der Beleg fehlt.\n\n## 8. Abnahme\n\nDoD erfuellt, Gate gruen, Zusage belegt.\n' "$2" "$3" > "$1"
}
stub() { # $1 datei  $2 titel  $3 welle-feld  $4 archiviert-mit  $5 innen-pfad
  printf '# %s\n\n> **ARCHIVIERT** — Volltext:\n> `unzip -p done/%s/archiv.zip %s`\n\n**Welle:** %s\n**Archiviert mit:** %s · **Geschlossen:** 2026-08-31\n**Hervorgegangen:** BEO-001\n' \
    "$2" "$4" "$5" "$3" "$4" > "$1"
}
# Die AUSWAHL — der Teil, an dem die Operation falsch liegen kann. Der Entwurf
# verlangt hier zweierlei: Slices der geschlossenen Welle UND wellenlose Slices,
# die diese Closure einsammelt; NICHT die Slices einer anderen, offenen Welle.
# Sie steht bewusst in der Operation und nicht im Szenario: Waehlt das Szenario
# aus, kann kein Verdikt je eine Auswahl-Luecke finden.
waehle() { # $1 clone  $2 welle  ->  Zeilen: Pfade relativ zur Repo-Wurzel
  local w="$1" welle="$2" f b
  for f in "$w"/docs/plan/planning/done/slice-*.md; do
    [ -e "$f" ] || continue
    if grep -q "^\*\*Welle:\*\* $welle\$" "$f" || grep -q '^\*\*Welle:\*\* ohne Welle$' "$f"; then
      echo "docs/plan/planning/done/$(basename "$f")"
    fi
  done
  [ -e "$w/docs/plan/planning/done/$welle.md" ] && echo "docs/plan/planning/done/$welle.md"
  # Reviews reisen mit dem Slice, den sie pruefen.
  for f in "$w"/docs/reviews/*.md; do
    [ -e "$f" ] || continue
    b=$(basename "$f")
    case "$b" in *slice-*) local sl; sl=$(echo "$b" | grep -o 'slice-[0-9]*')
      ls "$w"/docs/plan/planning/done/"$sl"-*.md >/dev/null 2>&1 && \
        grep -q "^\*\*Welle:\*\* $welle\$\|^\*\*Welle:\*\* ohne Welle\$" "$w"/docs/plan/planning/done/"$sl"-*.md 2>/dev/null && \
        echo "docs/reviews/$b" ;;
    esac
  done
}
# Die Operation selbst: auswaehlen, zippen, kuerzen, Verweise nachziehen. Sie
# gehoert laut Entwurf in ein Werkzeug — hier ist sie die Probe dieses Werkzeugs.
archiviere() { # $1 clone  $2 welle   (die Auswahl trifft die Operation, nicht der Aufrufer)
  local w="$1" welle="$2"; shift 2
  set -- $(waehle "$w" "$welle")
  [ $# -gt 0 ] || return 1
  ARCHIVZAHL="$(printf '%s\n' "$@" | grep -c '/slice-') Slices, $(printf '%s\n' "$@" | grep -c '/2026-') Reviews"
  local P="$w/docs/plan/planning" d="$w/docs/plan/planning/done/$welle"
  mkdir -p "$d"
  ( cd "$w" && zip -qrX "docs/plan/planning/done/$welle/archiv.zip" "$@" ) || return 1
  local f
  for f in "$@"; do
    local base; base="$(basename "$f")"
    case "$base" in
      slice-*) local wf="$welle"; grep -q '^\*\*Welle:\*\* ohne Welle' "$w/$f" && wf="ohne Welle"
               stub "$d/$base" "${base%.md}" "$wf" "$welle" "$f" ;;
      welle-*) # eigene Form: Zeiger auf die Ergebnisnotiz + Zahl der Vorgaenge
               printf '# %s\n\n> **ARCHIVIERT** — Volltext:\n> `unzip -p done/%s/archiv.zip %s`\n\n**Geschlossen:** 2026-08-31 · **Ergebnisnotiz:** %s-results.md\n**Archivierte Vorgaenge:** %s\n' \
                 "${base%.md}" "$welle" "$f" "$welle" "$ARCHIVZAHL" > "$d/$base" ;;
      *)       ;;   # Reviews bekommen KEINEN Stub — sie haben keine eigene Identitaet
    esac
    rm -f "$w/$f"
  done
  # Verweis-Nachzug — und er braucht ZWEI Formen, nicht eine:
  #  (a) mit done/-Praefix, wie das Register sie schreibt,
  #  (b) geschwister-relativ, wie die Ergebnisnotiz sie schreibt, die selbst in
  #      done/ liegt und dort BLEIBT, waehrend ihre Slices wegwandern.
  # Form (b) ist der garantierte Fall dieses Entwurfs, nicht der Sonderfall.
  ( cd "$w" && grep -rl "done/slice-" --include=*.md . 2>/dev/null | while read -r t; do
      sed -i "s|done/\(slice-[0-9A-Za-z._-]*\.md\)|done/$welle/\1|g" "$t"; done ) || true
  local b2
  for f in "$@"; do
    b2="$(basename "$f")"
    case "$b2" in slice-*|welle-*) ;; *) continue;; esac
    ( cd "$w/docs/plan/planning/done" && grep -rl "]($b2)" --include=*.md . 2>/dev/null | while read -r t; do
        sed -i "s|]($b2)|]($welle/$b2)|g" "$t"; done ) || true
  done
}

s19_archivierung() {
  topo
  cd "$WORK/sim/alice"
  P=docs/plan/planning
  mkdir -p docs/reviews
  volltext "$P/done/slice-003-cache.md"   "slice-003 — Cache"        "welle-2-ausbau"
  volltext "$P/done/slice-004-fixture.md" "slice-004 — Fixture"      "welle-2-ausbau"
  volltext "$P/done/slice-005-wartung.md" "slice-005 — Wartung"      "ohne Welle"
  volltext "$P/done/slice-051-laufend.md" "slice-051 — Laufend"      "welle-3-offen"
  volltext "$P/done/welle-2-ausbau.md"    "welle-2-ausbau — Ausbau"  "welle-2-ausbau"
  printf '# Review slice-003\n\nHIGH-1: die Zusage traegt den Sensor nicht.\n' > docs/reviews/2026-08-30-slice-003-review.md
  printf '# Review slice-004\n\nMEDIUM-2: das Gate blieb still.\n' > docs/reviews/2026-08-30-slice-004-review.md
  # Zwei ECHTE Verweis-Formen auf die Slices: aus dem Register (mit done/-Praefix)
  # und aus der Ergebnisnotiz, die selbst in done/ liegt (geschwister-relativ).
  printf '# Welle 2 — Ergebnisnotiz\n\nGeliefert: Cache und Fixture.\nSlices: [slice-003](slice-003-cache.md), [slice-004](slice-004-fixture.md).\n' > "$P/done/welle-2-results.md"
  printf '| BEO-009 | Zusage ohne Sensor | Kern | 1× | [slice-003](done/slice-003-cache.md) | offen |\n' >> "$P/observations.md"
  printf '%s' "$ARCHIVSENSOR" >> .d-check.yml
  sed -i 's/^modules: \[links, anchors, planning\]$/modules: [links, anchors, planning, structure]/' .d-check.yml
  schritt git add -A && schritt git commit -qm "welle-2 geschlossen, Volltexte liegen" || return 1
  base=$(git rev-parse HEAD)
  vorher=$(grep -rc "Zusage\|Gate\|Anker" $P/done docs/reviews 2>/dev/null | awk -F: '{s+=$2} END{print s+0}')

  archiviere "$WORK/sim/alice" welle-2-ausbau || { echo "  KAPUTT ($CUR): archiviere fehlgeschlagen"; return 1; }
  schritt git add -A && schritt git commit -qm "welle-2 archiviert" && schritt git push -q origin main || return 1

  imzip=$(unzip -Z1 "$P/done/welle-2-ausbau/archiv.zip" | grep -c '\.md$')
  stubs=$(ls "$P/done/welle-2-ausbau"/*.md 2>/dev/null | wc -l)
  [ "$imzip" = 6 ] && [ "$stubs" = 4 ] && ok=0 || ok=1
  verdikt "s19a Archivierungs-Lauf: 6 Volltexte im Zip, 4 Stubs (Reviews ohne)" "Zip 6, Stubs 4" "Zip $imzip, Stubs $stubs" $ok

  # Die Zahl allein traegt die Aussage NICHT: Loeschen senkt sie genauso wie
  # Kuerzen. Gemessen an einer Mutation (Stubs faellt aus) blieb dieses Verdikt
  # gruen — deshalb haengt es jetzt zusaetzlich an den vier Stubs.
  nachher=$(grep -rc "Zusage\|Gate\|Anker" $P/done docs/reviews 2>/dev/null | awk -F: '{s+=$2} END{print s+0}')
  n_stubs=$(ls "$P/done/welle-2-ausbau"/*.md 2>/dev/null | wc -l)
  [ "$vorher" -gt 0 ] && [ "$nachher" -lt "$vorher" ] && [ "$n_stubs" = 4 ] && ok=0 || ok=1
  verdikt "s19b Trefferzeilen fallen, UND die vier Stubs stehen (gekuerzt, nicht geloescht)" "nachher < vorher > 0, 4 Stubs" "vorher=$vorher, nachher=$nachher, Stubs=$n_stubs" $ok

  wf=$(grep -m1 '^\*\*Welle:\*\*' "$P/done/welle-2-ausbau/slice-005-wartung.md" | sed 's/\*\*//g')
  am=$(grep -m1 -o 'Archiviert mit:\*\* [a-z0-9-]*' "$P/done/welle-2-ausbau/slice-005-wartung.md" | sed 's/\*\*//')
  [ "$wf" = "Welle: ohne Welle" ] && [ "$am" = "Archiviert mit: welle-2-ausbau" ] && ok=0 || ok=1
  verdikt "s19c wellenloser Slice: Welle bleibt 'ohne Welle', Archiviert mit nennt die einsammelnde" "beide Felder getrennt" "$wf / $am" $ok

  ez=$(grep -c 'Ergebnisnotiz:\*\* welle-2-ausbau-results.md' "$P/done/welle-2-ausbau/welle-2-ausbau.md")
  vz=$(grep -o 'Archivierte Vorgaenge:\*\* [0-9]* Slices, [0-9]* Reviews' "$P/done/welle-2-ausbau/welle-2-ausbau.md" | sed 's/.*\*\* //')
  [ "$ez" = 1 ] && [ "$vz" = "3 Slices, 2 Reviews" ] && ok=0 || ok=1
  verdikt "s19i Welle-Stub traegt seine EIGENE Form (Ergebnisnotiz + Vorgangszahl)" "Zeiger auf results.md, '3 Slices, 2 Reviews'" "Zeiger=$ez, Zahl='$vz'" $ok

  out=$(dcheck "$WORK/sim/alice"); echo "$out" | grep -q "0 Befund" && ok=0 || ok=1
  verdikt "s19d beide Verweis-Formen loesen nach dem Umzug auf" "0 Befunde" "$(echo "$out"|tail -1)" $ok

  sed -i 's|(welle-2-ausbau/slice-003-cache.md)|(slice-003-cache.md)|' "$P/done/welle-2-results.md"
  # Vorbedingung: der injizierte Defekt muss wirklich drinstehen — sonst pruefte
  # die Gegenprobe ein No-op und bliebe aus dem falschen Grund gruen.
  grep -q '](slice-003-cache.md)' "$P/done/welle-2-results.md" || { echo "  KAPUTT ($CUR): Defekt-Injektion griff nicht"; return 1; }
  out=$(dcheck "$WORK/sim/alice"); befund "$out" "slice-003-cache.md" "target-missing" && ok=0 || ok=1
  verdikt "s19e Gegenprobe: ohne Verweis-Nachzug meldet links target-missing" "target-missing auf dem alten Pfad" "$(echo "$out"|tail -1)" $ok
  sed -i 's|(slice-003-cache.md)|(welle-2-ausbau/slice-003-cache.md)|' "$P/done/welle-2-results.md"

  volltext "$P/done/welle-2-ausbau/slice-006-vergessen.md" "slice-006 — Vergessen" "welle-2-ausbau"
  out=$(dcheck "$WORK/sim/alice")
  printf '%s' "$out" | grep -qF "slice-006-vergessen.md:1" && printf '%s' "$out" | grep -qF "section-pattern-missing" && ok=0 || ok=1
  verdikt "s19f Deckungs-Sensor: nicht gekuerzter Slice im Wellen-Verzeichnis wird gemeldet" "section-pattern-missing auf slice-006" "$(echo "$out"|tail -1)" $ok
  # s19g prueft die AUSWAHL: Der Slice der offenen Welle darf weder im Archiv
  # landen noch aus done/ verschwinden — und der Sensor darf ihn nicht melden.
  imarchiv=$(unzip -Z1 "$P/done/welle-2-ausbau/archiv.zip" | grep -c 'slice-051' || true)
  flach=$([ -f "$P/done/slice-051-laufend.md" ] && echo ja || echo nein)
  gemeldet=$(printf '%s' "$out" | grep -cF 'slice-051')
  [ "$imarchiv" = 0 ] && [ "$flach" = ja ] && [ "$gemeldet" = 0 ] && ok=0 || ok=1
  verdikt "s19g Slice der offenen Welle: nicht eingesammelt, nicht gemeldet" "nicht im Archiv, liegt flach, 0 Meldungen" "Archiv=$imarchiv, flach=$flach, gemeldet=$gemeldet" $ok
  rm -f "$P/done/welle-2-ausbau/slice-006-vergessen.md"

  rm -rf "$WORK/sim/flach"
  git clone -q --depth 1 "file://$WORK/sim/origin.git" "$WORK/sim/flach" 2>/dev/null
  aus=$(cd "$WORK/sim/flach" && unzip -p "$P/done/welle-2-ausbau/archiv.zip" docs/plan/planning/done/slice-003-cache.md 2>/dev/null | head -1)
  hist=$(cd "$WORK/sim/flach" && git show "$base:docs/plan/planning/done/slice-003-cache.md" 2>&1 | head -1)
  echo "$aus" | grep -q "slice-003" && echo "$hist" | grep -qi "objektname\|object name\|fatal" && ok=0 || ok=1
  verdikt "s19h flacher Klon: Archiv liefert den Volltext, die git-Historie nicht" "unzip ok, git show scheitert" "unzip='${aus:0:22}' git='${hist:0:34}'" $ok
}

echo "Team-Sim — Image: $IMG"; echo "Arbeitsverzeichnis: $WORK"; [ -n "$SELECT" ] && echo "Auswahl: $SELECT"; echo
lauf s01 s01_doppel_anspruch
lauf s02 s02_stille_nummer
lauf s03 s03_register_doppelzeile
lauf s04 s04_zwei_wellen_und_waves
lauf s04 s04g_eroeffnet_unter_waves
lauf s04 s04c_leerer_anspruch
lauf s05 s05_mr_hybrid
lauf s06 s06_branch_protection
lauf s07 s07_sichtung_liest_alt
lauf s08 s08_closure_unter_anspruch
lauf s09 s09_vorvergabe
lauf s10 s10_inhaber_feld
lauf s11 s11_adr_immutabel_im_team
lauf s12 s12_belege_mergen
lauf s13 s13_gleicher_pfad_laut
lauf s14 s14_schwelle_im_merge
lauf s15 s15_pfadidentitaet
lauf s16 s16_beleg_immutabel
lauf s17 s17_zwei_slugs_still
lauf s18 s18_alias_und_invalidierung
lauf s19 s19_archivierung
echo; echo "Ergebnis: $PASS PASS, $FAIL FAIL, $KAPUTT KAPUTT — Ergebnisdatei: $TSV"
if [ "${SIM_CLEAN:-0}" = 1 ]; then cat "$TSV"; rm -rf "$WORK"; fi
[ $FAIL -eq 0 ] && [ $KAPUTT -eq 0 ]
