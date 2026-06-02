#!/usr/bin/env node
// docs-check — Markdown-Link-Validator für den ai-harness-course.
// Prüft:
//   1. Interne Markdown-Links [text](pfad.md#anker)
//   2. Bild-Referenzen ![alt](pfad.png|jpg|svg|gif|webp)
//   3. Code-/Config-Referenzen [text](pfad.go|.py|...)
// Exit-Code 1 bei Fehlern, 0 sonst.

import { readFileSync, readdirSync, statSync, existsSync } from "node:fs";
import { join, dirname, resolve, relative, basename } from "node:path";

const args = process.argv.slice(2);
const options = {
  verbose: args.includes("--verbose") || args.includes("-v"),
  noWarn: args.includes("--no-warn"),
  help: args.includes("--help") || args.includes("-h"),
  ignore: [],
};

// --ignore <pfad> kann mehrfach vorkommen. Default: lab/templates ist
// symbolisch (Pfade sind Platzhalter im Ziel-Repo des Lerners).
for (let i = 0; i < args.length; i++) {
  if (args[i] === "--ignore" && args[i + 1]) {
    options.ignore.push(args[i + 1]);
    i++;
  }
}
if (options.ignore.length === 0) {
  options.ignore.push("lab/templates");
}

const targets = [];
{
  let skipNext = false;
  for (const a of args) {
    if (skipNext) { skipNext = false; continue; }
    if (a === "--ignore") { skipNext = true; continue; }
    if (!a.startsWith("-")) targets.push(a);
  }
}

if (options.help) {
  process.stdout.write(`docs-check — Markdown-Link-Validator

USAGE:
  docs-check [OPTIONS] [TARGET ...]

OPTIONS:
  -v, --verbose      OK-Items auch ausgeben
      --no-warn      Warnungen unterdrücken (Exit-Code unverändert)
      --ignore PATH  Pfad ausnehmen (mehrfach erlaubt). Default: lab/templates.
  -h, --help         Diese Hilfe

TARGETS:
  Pfade oder Glob-Wildcards. Ohne Argumente: rekursiv ab CWD.

EXAMPLES:
  docs-check                              # alles ab CWD
  docs-check kurs/de/                     # nur Kurs-Verzeichnis
  docs-check --verbose lab/example/       # mit OK-Meldungen
`);
  process.exit(0);
}

const ROOT = process.cwd();
const startPaths = targets.length > 0 ? targets : ["."];

// ---- Markdown-Datei-Liste ermitteln ----
const ignoreAbs = options.ignore.map((i) => resolve(i));

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
    } catch {
      return;
    }
    if (st.isFile()) {
      if (p.endsWith(".md")) out.push(p);
      return;
    }
    if (st.isDirectory()) {
      const base = basename(p);
      if (base === "node_modules" || base === ".git" || base === "target" || base === "build" || base === ".gradle") return;
      for (const child of readdirSync(p)) walk(join(p, child));
    }
  }
  walk(start);
  return out;
}

const mdFiles = new Set();
for (const t of startPaths) {
  for (const f of collectMarkdown(t)) mdFiles.add(resolve(f));
}

if (mdFiles.size === 0) {
  process.stderr.write("docs-check: keine Markdown-Dateien gefunden.\n");
  process.exit(0);
}

// ---- Heading-Slugs pro Datei extrahieren (GitHub-Konvention) ----
function slugify(text) {
  // GitHub-Slug: lowercase, Whitespace → "-", interpunktion entfernt
  // (Bindestrich und Unterstrich bleiben).
  return text
    .toLowerCase()
    .replace(/<[^>]+>/g, "")            // HTML-Tags weg
    .replace(/[`*_~]/g, "")             // Markdown-Inline weg
    .replace(/[^\p{Letter}\p{Number}\s-]/gu, "")
    .trim()
    .replace(/\s+/g, "-");
}

const headingsCache = new Map(); // absPath → Set<slug>
function getHeadings(absPath) {
  if (headingsCache.has(absPath)) return headingsCache.get(absPath);
  if (!existsSync(absPath)) {
    headingsCache.set(absPath, null);
    return null;
  }
  let text;
  try {
    text = readFileSync(absPath, "utf8");
  } catch {
    headingsCache.set(absPath, null);
    return null;
  }
  const slugs = new Set();
  const counter = new Map();
  let inCodeFence = false;
  for (const line of text.split("\n")) {
    if (line.startsWith("```")) {
      inCodeFence = !inCodeFence;
      continue;
    }
    if (inCodeFence) continue;
    const m = line.match(/^(#{1,6})\s+(.+?)\s*$/);
    if (m) {
      let s = slugify(m[2]);
      if (counter.has(s)) {
        const n = counter.get(s) + 1;
        counter.set(s, n);
        s = `${s}-${n}`;
      } else {
        counter.set(s, 0);
      }
      slugs.add(s);
    }
  }
  headingsCache.set(absPath, slugs);
  return slugs;
}

// ---- Links pro Datei parsen ----
// [text](target)  oder  ![alt](target)
// Hinweis: Wir ignorieren Code-Fences und Inline-Code.
function extractLinks(text) {
  const links = [];
  const lines = text.split("\n");
  let inFence = false;
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    if (line.startsWith("```")) {
      inFence = !inFence;
      continue;
    }
    if (inFence) continue;
    // Inline-Code-Spans aus der Zeile entfernen.
    const stripped = line.replace(/`[^`]*`/g, "");
    // Markdown-Link: [text](target) oder ![alt](target)
    const re = /(!?)\[([^\]]*)\]\(([^)\s]+)(?:\s+"[^"]*")?\)/g;
    let m;
    while ((m = re.exec(stripped)) !== null) {
      links.push({ image: m[1] === "!", text: m[2], target: m[3], line: i + 1 });
    }
  }
  return links;
}

// ---- Externer Link? Mailto? Anker-only? ----
function isExternal(target) {
  return /^[a-z][a-z0-9+.-]*:/i.test(target);
}
function isAnchorOnly(target) {
  return target.startsWith("#");
}

// ---- Hauptlauf ----
let errors = 0;
let warnings = 0;
let okCount = 0;

const sorted = [...mdFiles].sort();
for (const absMd of sorted) {
  const rel = relative(ROOT, absMd);
  let text;
  try {
    text = readFileSync(absMd, "utf8");
  } catch (e) {
    process.stderr.write(`ERROR ${rel}: lesen fehlgeschlagen (${e.message})\n`);
    errors++;
    continue;
  }
  const links = extractLinks(text);
  const fileDir = dirname(absMd);

  for (const link of links) {
    const { target, line } = link;
    if (isExternal(target)) continue;
    if (isAnchorOnly(target)) {
      // In-Datei-Anker
      const ownHeadings = getHeadings(absMd) || new Set();
      const anchor = target.slice(1);
      if (!ownHeadings.has(anchor)) {
        process.stderr.write(`ERROR ${rel}:${line}: Anker "#${anchor}" existiert nicht in dieser Datei\n`);
        errors++;
      } else if (options.verbose) {
        process.stdout.write(`OK    ${rel}:${line}: in-file anchor #${anchor}\n`);
        okCount++;
      }
      continue;
    }

    // Datei-Link, ggf. mit Anker.
    const [pathPart, anchor] = target.split("#");
    const targetAbs = resolve(fileDir, pathPart);

    // Sicherheitsnetz: Pfad darf nicht aus dem Repo führen.
    const relFromRoot = relative(ROOT, targetAbs);
    if (relFromRoot.startsWith("..")) {
      process.stderr.write(`ERROR ${rel}:${line}: Ziel "${target}" zeigt aus dem Repo heraus\n`);
      errors++;
      continue;
    }

    if (!existsSync(targetAbs)) {
      process.stderr.write(`ERROR ${rel}:${line}: Ziel "${target}" existiert nicht (resolved: ${relative(ROOT, targetAbs)})\n`);
      errors++;
      continue;
    }

    // Wenn Anker und Markdown-Ziel: prüfen.
    if (anchor && targetAbs.endsWith(".md")) {
      const headings = getHeadings(targetAbs);
      if (headings === null) {
        if (!options.noWarn) {
          process.stderr.write(`WARN  ${rel}:${line}: Ziel "${target}" lesbar, aber Heading-Index nicht ermittelbar\n`);
          warnings++;
        }
      } else if (!headings.has(anchor)) {
        process.stderr.write(`ERROR ${rel}:${line}: Anker "#${anchor}" existiert nicht in ${relative(ROOT, targetAbs)}\n`);
        errors++;
      } else if (options.verbose) {
        process.stdout.write(`OK    ${rel}:${line}: ${target}\n`);
        okCount++;
      }
      continue;
    }

    if (options.verbose) {
      process.stdout.write(`OK    ${rel}:${line}: ${target}\n`);
      okCount++;
    }
  }
}

// ---- Zusammenfassung ----
const summary = `\ndocs-check: ${mdFiles.size} Datei(en) geprüft, ${errors} ERROR, ${warnings} WARN${options.verbose ? `, ${okCount} OK` : ""}.\n`;
if (errors > 0) process.stderr.write(summary);
else process.stdout.write(summary);

process.exit(errors > 0 ? 1 : 0);
