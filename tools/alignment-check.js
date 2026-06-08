#!/usr/bin/env node
// alignment-check — heuristischer Prüfschritt-Wächter für den ai-harness-course.
//
// Operationalisiert den Alignment-Prüfschritt aus
// kurs/de/grundlagen/README.md §1 ("zähle pro Lernziel die alignment-
// geprobten Stellen in Übung *und* Selbstcheck") auf Lernziel-Granularität:
//
//   Für jedes Modul wird jedes Lernziel (LZ) daraufhin geprüft, ob es im
//   Übungs-Block UND im Selbstcheck-Block einen expliziten Aktivierungs-
//   Marker `LZ <N>` hat. Fehlt der Marker in einem Block, ist das ein
//   Hinweis (kein Beweis), dass das LZ-Verb dort nicht alignment-geprobt
//   ist — genau das Muster, das Befund 1 des Didaktik-Reviews beschreibt.
//
// Ein Lernziel gilt in einem Block als alignment-geprobt, wenn der Block
// ENTWEDER einen expliziten Marker `LZ <N>` trägt ODER den Wortstamm eines
// der kursiven LZ-Verben enthält (Übungen formulieren typischerweise mit
// demselben Verb: LZ "*abwägen*" ↔ Übung "Entscheide … und wäge ab").
//
// Bewusste Einschränkungen (das Werkzeug ist ein Frühwarner, kein Gate):
//   - Verbstamm-Matching ist heuristisch. Deutscher Ablaut (entwerfen →
//     entwirf, zeichnen → zeichne) kann einen Treffer verfehlen; dann
//     erscheint ein '–', obwohl das LZ in Prosa geprobt ist. '–' heißt
//     darum: "weder LZ-Marker noch Verbstamm gefunden — manuell prüfen",
//     nicht "garantierte Lücke".
//   - Fokus liegt auf dem Befund-1-Muster: Höher-Bloom-LZ (Analysieren/
//     Bewerten/Erschaffen/Überwachen) OHNE Aktivierung im ÜBUNGS-Block
//     werden als WARN gemeldet (Assessment ohne Aktivität). Fehlende
//     Selbstcheck-Aktivierung ist INFO — der Selbstcheck ist bewusst
//     konzept-knapp (siehe grundlagen/selbstcheck-rubrik.md).
//
// Exit-Code: 0 (advisory). Mit --strict: 1, sobald ein Höher-Bloom-LZ
// keine Übungs-Aktivierung hat.

import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, basename } from "node:path";

// ---- CLI-Parser ----
const args = process.argv.slice(2);
const options = { strict: false, help: false, verbose: false };
const targets = [];
for (const a of args) {
  if (a === "-h" || a === "--help") { options.help = true; continue; }
  if (a === "--strict") { options.strict = true; continue; }
  if (a === "-v" || a === "--verbose") { options.verbose = true; continue; }
  if (a.startsWith("-")) {
    process.stderr.write(`alignment-check: unbekannte Option ${a}\n`);
    process.exit(2);
  }
  targets.push(a);
}

if (options.help) {
  process.stdout.write(`alignment-check — Alignment-Prüfschritt-Wächter (heuristisch)

Verwendung:
  node tools/alignment-check.js [Pfad ...]        # Default: kurs/de
  node tools/alignment-check.js --strict          # Exit 1 bei Höher-Bloom-Lücke
  node tools/alignment-check.js --verbose         # auch vollständig abgedeckte LZ zeigen

Prüft pro Modul, ob jedes Lernziel einen expliziten 'LZ <N>'-Marker im
Übungs- und im Selbstcheck-Block trägt. Siehe Kopf der Datei für die
bewussten Einschränkungen — das Werkzeug ist ein Frühwarner, kein Gate.
`);
  process.exit(0);
}

if (targets.length === 0) targets.push("kurs/de");

// ---- Bloom-Prozessdimensionen ----
const PROCESS_DIMS = ["Erinnern", "Verstehen", "Anwenden", "Analysieren", "Bewerten", "Erschaffen", "Überwachen"];
const HIGH_BLOOM = new Set(["Analysieren", "Bewerten", "Erschaffen", "Überwachen"]);

// ---- Markdown-Helfer ----

// Code-Fences entfernen, damit Beispiel-Code keine falschen LZ-Treffer erzeugt.
function stripFences(text) {
  const out = [];
  let inFence = false;
  let fence = "";
  for (const line of text.split("\n")) {
    const m = line.match(/^\s{0,3}(```+|~~~+)/);
    if (m) {
      if (!inFence) { inFence = true; fence = m[1][0]; }
      else if (line.includes(fence.repeat(3))) { inFence = false; }
      out.push("");
      continue;
    }
    out.push(inFence ? "" : line);
  }
  return out.join("\n");
}

// Block zwischen einer "## <Name>"-Überschrift und der nächsten "## "
// (Unterüberschriften "### " gehören zum Block).
function sectionBody(text, headingRegex) {
  const lines = text.split("\n");
  let start = -1;
  for (let i = 0; i < lines.length; i++) {
    if (/^##\s/.test(lines[i]) && headingRegex.test(lines[i])) { start = i + 1; break; }
  }
  if (start === -1) return null;
  const body = [];
  for (let i = start; i < lines.length; i++) {
    if (/^##\s/.test(lines[i])) break;
    body.push(lines[i]);
  }
  return body.join("\n");
}

// Wortstamm eines deutschen Verbs (heuristisch): lowercase, Infinitiv-
// Endung -en/-n abtrennen, auf max. 6 Zeichen kürzen. "abwägen" → "abwäg",
// "formulieren" → "formul", "zeichnen" → "zeichn". Mindestlänge 4, um
// triviale Teilstring-Treffer zu vermeiden.
function verbStem(verb) {
  let v = verb.toLowerCase().replace(/[*_`]/g, "").trim();
  v = v.replace(/en$/, "").replace(/n$/, "");
  if (v.length < 4) return null;
  return v.slice(0, 6);
}

// Lernziele extrahieren: Bullet-Zeilen im Lernziele-Block, je mit
// Prozessdimension aus dem (… · …)-Tag und den kursiven Verben *verb*.
// Reihenfolge = LZ-Nummer.
function extractLernziele(lzBody) {
  if (!lzBody) return [];
  const out = [];
  for (const line of lzBody.split("\n")) {
    if (!/^\s*\*\s/.test(line)) continue;
    // Tag-Klammer mit Bloom-Trennzeichen "·" suchen.
    const tag = line.match(/\(([^()]*·[^()]*)\)/);
    let dims = [];
    if (tag) {
      for (const d of PROCESS_DIMS) {
        if (tag[1].includes(d)) dims.push(d);
      }
    }
    // Kursive Verben *verb* einsammeln (ohne den Tag-Teil).
    const head = tag ? line.slice(0, line.indexOf(tag[0])) : line;
    const stems = [];
    for (const m of head.matchAll(/\*([\p{L}]+)\*/gu)) {
      const s = verbStem(m[1]);
      if (s) stems.push(s);
    }
    out.push({ num: out.length + 1, dims, stems, text: line.trim() });
  }
  return out;
}

// Welche LZ-Nummern werden in einem Block explizit über `LZ <N>` markiert?
function referencedLZ(body) {
  const set = new Set();
  if (!body) return set;
  for (const m of body.matchAll(/\bLZ\s*(\d+)/g)) {
    set.add(Number(m[1]));
  }
  return set;
}

// Ist das LZ im Block aktiviert? Digit-Marker ODER ein Verbstamm-Treffer.
function activatedIn(body, lz, digitRefs) {
  if (digitRefs.has(lz.num)) return true;
  if (!body) return false;
  const hay = body.toLowerCase();
  return lz.stems.some((s) => hay.includes(s));
}

// ---- Datei-Walk ----
function collectModuleFiles(target) {
  const files = [];
  let st;
  try { st = statSync(target); } catch { return files; }
  if (st.isFile()) {
    if (/modul-\d+.*\.md$/.test(basename(target))) files.push(target);
    return files;
  }
  for (const entry of readdirSync(target)) {
    if (entry.startsWith(".")) continue;
    files.push(...collectModuleFiles(join(target, entry)));
  }
  return files;
}

// ---- Analyse pro Modul ----
function analyze(file) {
  const raw = readFileSync(file, "utf8");
  const text = stripFences(raw);
  const lz = extractLernziele(sectionBody(text, /Lernziele/));
  if (lz.length === 0) return null;
  const uebBody = sectionBody(text, /Übungen/);
  const selBody = sectionBody(text, /Selbstcheck/);
  const uebRefs = referencedLZ(uebBody);
  const selRefs = referencedLZ(selBody);
  const findings = [];
  for (const z of lz) {
    const inUeb = activatedIn(uebBody, z, uebRefs);
    const inSel = activatedIn(selBody, z, selRefs);
    if (inUeb && inSel) continue;
    const high = z.dims.some((d) => HIGH_BLOOM.has(d));
    // WARN nur für das stärkste, rauschärmste Muster: ein Höher-Bloom-LZ,
    // das in BEIDEN Blöcken keine Aktivierung trägt (weder Marker noch
    // Verbstamm) — der heißeste Kandidat für eine echte Alignment-Lücke.
    // Partielle Fälle (nur Übung ODER nur Selbstcheck fehlt) sind INFO:
    // dort greift oft der konzept-knappe Selbstcheck (selbstcheck-rubrik.md)
    // oder ein Verbstamm-Falsch-Negativ (deutscher Ablaut).
    const severity = high && !inUeb && !inSel ? "WARN" : "INFO";
    findings.push({ num: z.num, dims: z.dims, inUeb, inSel, severity });
  }
  return { file, count: lz.length, findings };
}

// ---- Hauptlauf ----
const files = [];
for (const t of targets) files.push(...collectModuleFiles(t));
files.sort((a, b) => new Intl.Collator("de").compare(a, b));

let warnCount = 0;
let infoCount = 0;
let okCount = 0;

for (const file of files) {
  const res = analyze(file);
  if (!res) continue;
  const rel = file.replace(/^\.\//, "");
  if (res.findings.length === 0) {
    okCount++;
    if (options.verbose) {
      process.stdout.write(`OK   ${rel} — alle ${res.count} LZ in Übung und Selbstcheck markiert\n`);
    }
    continue;
  }
  process.stderr.write(`\n${rel} (${res.count} LZ)\n`);
  for (const f of res.findings) {
    if (f.severity === "WARN") warnCount++; else infoCount++;
    const miss = [];
    if (!f.inUeb) miss.push("Übung");
    if (!f.inSel) miss.push("Selbstcheck");
    const dimStr = f.dims.length ? f.dims.join("+") : "ohne Tag";
    process.stderr.write(`  ${f.severity}  LZ ${f.num} (${dimStr}) — keine Aktivierung (Marker/Verbstamm) in: ${miss.join(" + ")}\n`);
  }
}

process.stderr.write(`\nalignment-check: ${okCount} Module ohne Hinweis · ${warnCount} WARN (Höher-Bloom-LZ ohne jede Aktivierung) · ${infoCount} INFO (partiell)\n`);
process.stderr.write(`Triage: WARN sind Kandidaten, keine Urteile — gegen kurs/de/grundlagen/selbstcheck-rubrik.md\n`);
process.stderr.write(`prüfen (konzept-knapper Selbstcheck ist Absicht) und auf Verbstamm-Falsch-Negative (Ablaut) achten.\n`);

if (options.strict && warnCount > 0) process.exit(1);
process.exit(0);
