#!/usr/bin/env node
// docs-check — Rest-Sensor des ai-harness-course: Modul-Nummern-Checks.
//
// Seit der Pilot-Migration auf d-check (ghcr.io/pt9912/d-check,
// konfiguriert in .d-check.yml) prüft dieses Tool NUR noch die
// repo-spezifische Semantik, die ein generischer Referenz-Checker
// nicht kennen kann:
//   A (ERROR): Linktext "Modul N" / "[N]" vs. Nummer im Linkziel
//              modul-MM-*.md (Off-by-one-Drift, deterministisch).
//   B (WARN):  Prosa "Modul N (Titel)" vs. kanonischer Dateinamens-
//              Slug von Modul N (heuristisch).
// Links, Anker, Bild-Referenzen und explizite Inline-Code-Pfade
// prüft d-check (`make docs-check` führt beide aus).
// Exit-Code 1 bei Fehlern, 0 sonst.

import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, resolve, relative, basename } from "node:path";

// ---- CLI-Parser ----
const args = process.argv.slice(2);
const options = {
  verbose: false,
  noWarn: false,
  help: false,
  ignore: [],
};
const targets = [];

for (let i = 0; i < args.length; i++) {
  const a = args[i];
  if (a === "-v" || a === "--verbose") { options.verbose = true; continue; }
  if (a === "--no-warn") { options.noWarn = true; continue; }
  if (a === "-h" || a === "--help") { options.help = true; continue; }
  if (a === "--ignore") {
    if (i + 1 >= args.length) {
      process.stderr.write("docs-check: --ignore braucht ein Argument.\n");
      process.exit(2);
    }
    options.ignore.push(args[++i]);
    continue;
  }
  if (a.startsWith("--ignore=")) {
    options.ignore.push(a.slice("--ignore=".length));
    continue;
  }
  if (a.startsWith("-")) {
    process.stderr.write(`docs-check: unbekannte Option ${a} (--help für Hilfe).\n`);
    process.exit(2);
  }
  targets.push(a);
}

if (options.ignore.length === 0) {
  // Default: Templates sind by-design symbolisch (Pfade im Ziel-Repo).
  options.ignore.push("lab/templates");
  options.ignore.push(".tmp");
}

if (options.help) {
  process.stdout.write(`docs-check — Modul-Nummern-Sensor (Rest-Sensor)

Links, Anker und Inline-Code-Pfade prüft d-check (.d-check.yml);
dieses Tool prüft nur die Modul-Nummern-Semantik des Kurses.

USAGE:
  docs-check [OPTIONS] [TARGET ...]

OPTIONS:
  -v, --verbose          OK-Items auch ausgeben (an stdout)
      --no-warn          Warnungen unterdrücken (Exit-Code unverändert)
      --ignore PATH      Pfad ausnehmen (mehrfach erlaubt, --ignore=PATH ok)
                         Default: lab/templates
  -h, --help             Diese Hilfe

PRÜFUNGEN:
  A (ERROR): Linktext "Modul N" vs. Nummer im Linkziel modul-MM-*.md.
  B (WARN):  Prosa "Modul N (Titel)" vs. Dateinamens-Slug von Modul N.
  Opt-out pro Zeile: <!-- docs-check:ignore -->
`);
  process.exit(0);
}

const ROOT = process.cwd();
const startPaths = targets.length > 0 ? targets : ["."];

// ---- Markdown-Datei-Liste ermitteln ----
const ignoreAbs = options.ignore.map((i) => resolve(i));
const SKIP_DIRS = new Set([
  "node_modules", ".git", "target", "build", ".gradle",
  "dist", ".next", ".venv", "__pycache__", "vendor", "bin", "obj",
]);

function isIgnored(absPath) {
  for (const ig of ignoreAbs) {
    if (absPath === ig || absPath.startsWith(ig + "/")) return true;
  }
  return false;
}

function collectMarkdown(start) {
  const out = [];
  function walk(p) {
    const absP = resolve(p);
    if (isIgnored(absP)) return;
    let st;
    try {
      st = statSync(p);
    } catch (e) {
      if (e.code !== "ENOENT") {
        process.stderr.write(`WARN  Filesystem-Fehler bei ${p}: ${e.code || e.message}\n`);
      }
      return;
    }
    if (st.isFile()) {
      if (p.endsWith(".md")) out.push(p);
      return;
    }
    if (st.isDirectory()) {
      if (SKIP_DIRS.has(basename(p))) return;
      let children;
      try {
        children = readdirSync(p, { withFileTypes: true });
      } catch (e) {
        process.stderr.write(`WARN  readdir fehlgeschlagen ${p}: ${e.code || e.message}\n`);
        return;
      }
      for (const child of children) walk(join(p, child.name));
    }
  }
  walk(start);
  return out;
}

const mdFiles = new Set();
for (const t of startPaths) {
  for (const f of collectMarkdown(t)) mdFiles.add(resolve(f));
}

// ---- Modul-Nummern-Karte (Sensor gegen Off-by-one-Drift) ----
// Kanonische Zuordnung Modul-Nummer → Dateinamens-Slug, aus den
// gescannten Modul-Dateien abgeleitet (modul-NN-<slug>.md, ohne
// Lösungs-Dateien).
const moduleSlugs = new Map(); // Nummer → Slug-Tokens
for (const f of mdFiles) {
  const m = basename(f).match(/^modul-(\d{2})-(.+)\.md$/);
  if (!m || m[2] === "loesung") continue;
  moduleSlugs.set(parseInt(m[1], 10), normTokens(m[2]));
}

function normTokens(s) {
  return s
    .toLowerCase()
    .replace(/ä/g, "ae").replace(/ö/g, "oe").replace(/ü/g, "ue").replace(/ß/g, "ss")
    .split(/[^a-z0-9]+/)
    .filter((t) => t.length >= 4);
}

// Prefix-Vergleich (5 Zeichen bzw. kürzeres Token) — fängt
// Flexionsformen ("Produktion" ↔ "produktiver"), bleibt eng genug.
function tokensOverlap(a, b) {
  for (const t of a) {
    for (const s of b) {
      const n = Math.min(5, t.length, s.length);
      if (t.slice(0, n) === s.slice(0, n)) return true;
    }
  }
  return false;
}

if (mdFiles.size === 0) {
  process.stderr.write("docs-check: keine Markdown-Dateien gefunden.\n");
  process.exit(0);
}

// ---- Inline-Code-Spans entfernen (Multi-Backtick-aware) ----
function stripInlineCode(line) {
  // Multi-Backtick: ` `, `` `` etc. Match das gleiche Backtick-Count
  // am Anfang und am Ende. CommonMark-konform.
  return line.replace(/(`+)[^`]*?\1/g, "");
}

// ---- Link-Parser mit Klammer-Balancing ----
function extractLinks(text) {
  const links = [];
  const lines = text.split("\n");
  let inFence = false;
  let fenceMarker = "";
  for (let i = 0; i < lines.length; i++) {
    const rawLine = lines[i];
    const indented = rawLine.replace(/^ {0,3}/, "");
    const fm = indented.match(/^(```+|~~~+)/);
    if (fm) {
      if (!inFence) { inFence = true; fenceMarker = fm[1][0]; }
      else if (indented.startsWith(fenceMarker)) { inFence = false; fenceMarker = ""; }
      continue;
    }
    if (inFence) continue;
    const stripped = stripInlineCode(rawLine);

    // Token-basiertes Link-Parsing: [text](target ggf. "title")
    // mit Klammer-Balancing in target.
    let idx = 0;
    while (idx < stripped.length) {
      let openBracket = stripped.indexOf("[", idx);
      if (openBracket === -1) break;

      // Bracket-Balance für link text
      let depth = 1;
      let textEnd = openBracket + 1;
      while (textEnd < stripped.length && depth > 0) {
        const ch = stripped[textEnd];
        if (ch === "[") depth++;
        else if (ch === "]") depth--;
        if (depth > 0) textEnd++;
      }
      if (depth !== 0 || textEnd >= stripped.length || stripped[textEnd + 1] !== "(") {
        idx = openBracket + 1;
        continue;
      }

      // Parse target with paren balancing
      const linkText = stripped.slice(openBracket + 1, textEnd);
      let p = textEnd + 2;
      let parenDepth = 1;
      let target = "";
      let inTitle = false;
      while (p < stripped.length && parenDepth > 0) {
        const ch = stripped[p];
        if (!inTitle && ch === "(") parenDepth++;
        else if (!inTitle && ch === ")") parenDepth--;
        else if (ch === '"' && !inTitle && /\s/.test(stripped[p - 1] || " ")) {
          inTitle = true;
        } else if (ch === '"' && inTitle) {
          inTitle = false;
        }
        if (parenDepth > 0) {
          if (!inTitle && /\s/.test(ch) && target.length > 0) {
            // Whitespace + Titel beginnt
            inTitle = false;
            while (p < stripped.length && stripped[p] !== ")") p++;
            break;
          }
          if (!inTitle) target += ch;
        }
        p++;
      }
      if (parenDepth === 0 || (parenDepth > 0 && stripped[p] === ")")) {
        if (target) {
          links.push({ text: linkText, target, line: i + 1 });
        }
      }
      idx = p + 1;
    }
  }
  return links;
}

function isExternal(target) {
  return /^[a-z][a-z0-9+.-]*:/i.test(target);
}

// ---- Hauptlauf ----
let errors = 0;
let warnings = 0;
let okCount = 0;

const collator = new Intl.Collator("en", { sensitivity: "variant" });
const sorted = [...mdFiles].sort(collator.compare);
for (const absMd of sorted) {
  const rel = relative(ROOT, absMd);
  let text;
  try {
    text = readFileSync(absMd, "utf8");
  } catch (e) {
    process.stderr.write(`ERROR ${rel}: lesen fehlgeschlagen (${e.code || e.message})\n`);
    errors++;
    continue;
  }
  const links = extractLinks(text);
  const rawLines = text.split("\n");

  // Prüfung A: Modul-Nummer im Linktext vs. Nummer im Linkziel.
  // Deterministisch (beide Nummern explizit) → ERROR. Opt-out pro
  // Zeile via docs-check:ignore.
  for (const link of links) {
    const { target, line } = link;
    if (isExternal(target)) continue;
    const tm = (target.split("#")[0].match(/(?:^|\/)modul-(\d{2})-[^/]*\.md$/) || [])[1];
    if (tm !== undefined && !(rawLines[line - 1] || "").includes("docs-check:ignore")) {
      const mention =
        /\bModul (\d{1,2})\b/.exec(link.text) || /^\s*(\d{1,2})\s*$/.exec(link.text);
      if (mention && parseInt(mention[1], 10) !== parseInt(tm, 10)) {
        process.stderr.write(`ERROR ${rel}:${line}: Linktext nennt Modul ${mention[1]}, Ziel ist modul-${tm} ("${target}")\n`);
        errors++;
      } else if (mention && options.verbose) {
        process.stdout.write(`OK    ${rel}:${line}: Modul ${mention[1]} → ${target}\n`);
        okCount++;
      }
    }
  }

  // Prüfung B: Prosa-Erwähnung "Modul N (Titel)" gegen den kanonischen
  // Dateinamens-Slug von Modul N. Heuristisch → WARN. Warnt NUR, wenn
  // die Klammer-Tokens auf ein *anderes* Modul passen (Off-by-one-
  // Signatur); Nicht-Titel-Klammern ("Bericht A", "FV1") passen auf
  // kein Modul und bleiben stumm.
  if (moduleSlugs.size > 0 && !options.noWarn) {
    let inFence = false;
    let fenceMarker = "";
    for (let i = 0; i < rawLines.length; i++) {
      const indented = rawLines[i].replace(/^ {0,3}/, "");
      const fm = indented.match(/^(```+|~~~+)/);
      if (fm) {
        if (!inFence) { inFence = true; fenceMarker = fm[1][0]; }
        else if (indented.startsWith(fenceMarker)) { inFence = false; fenceMarker = ""; }
        continue;
      }
      if (inFence) continue;
      if (rawLines[i].includes("docs-check:ignore")) continue;
      const lineText = stripInlineCode(rawLines[i]);
      const re = /\bModul (\d{1,2}) \(([^()\n]{1,60})\)/g;
      let m;
      while ((m = re.exec(lineText)) !== null) {
        const num = parseInt(m[1], 10);
        const tokens = normTokens(m[2]);
        if (tokens.length === 0) continue;
        const matches = [];
        for (const [n, slugTokens] of moduleSlugs) {
          if (tokensOverlap(tokens, slugTokens)) matches.push(n);
        }
        if (matches.length === 0 || matches.includes(num)) continue;
        process.stderr.write(`WARN  ${rel}:${i + 1}: "Modul ${m[1]} (${m[2]})" — Titel passt zu Modul ${matches.sort((a, b) => a - b).join("/")}, nicht zu ${m[1]} (Off-by-one?)\n`);
        warnings++;
      }
    }
  }
}

// ---- Zusammenfassung ----
// Immer auf stderr — Diagnostik-Stream, konsistent für CI.
const summary = `\ndocs-check: ${mdFiles.size} Datei(en) geprüft, ${errors} ERROR, ${warnings} WARN${options.verbose ? `, ${okCount} OK` : ""}.\n`;
process.stderr.write(summary);

process.exit(errors > 0 ? 1 : 0);
