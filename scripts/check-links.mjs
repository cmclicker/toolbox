#!/usr/bin/env node
// Validates internal Markdown links across the toolbox.
// Zero dependencies — plain Node. Exits non-zero if any internal link
// (relative path or #anchor-to-a-file) points at something that doesn't exist.
//
// Usage:  node scripts/check-links.mjs
// CI runs this on every push; run it locally before committing.

import { readdir, readFile, stat } from "node:fs/promises";
import { existsSync } from "node:fs";
import { join, dirname, resolve, relative } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), "..");

/** Recursively collect every .md file, skipping .git and node_modules. */
async function collectMarkdown(dir) {
  const out = [];
  for (const entry of await readdir(dir, { withFileTypes: true })) {
    if (entry.name === ".git" || entry.name === "node_modules" || entry.name === "site") continue;
    const full = join(dir, entry.name);
    if (entry.isDirectory()) out.push(...(await collectMarkdown(full)));
    else if (entry.name.endsWith(".md")) out.push(full);
  }
  return out;
}

// Matches [text](target) — captures the target.
const LINK_RE = /\[[^\]]*\]\(([^)]+)\)/g;

// Markdown does not render links inside code, so neither do we. Strip fenced
// code blocks and inline code spans before scanning, so docs that show link
// *syntax* (e.g. `[Title](url)`) aren't mistaken for real links.
function stripCode(md) {
  return md
    .replace(/```[\s\S]*?```/g, "")
    .replace(/`[^`\n]*`/g, "");
}

function isExternal(target) {
  return /^(https?:|mailto:|tel:|#)/.test(target);
}

async function pathExists(p) {
  try {
    await stat(p);
    return true;
  } catch {
    return false;
  }
}

const files = await collectMarkdown(ROOT);
const problems = [];

for (const file of files) {
  const content = stripCode(await readFile(file, "utf8"));
  for (const match of content.matchAll(LINK_RE)) {
    let target = match[1].trim();
    if (!target || isExternal(target)) continue;
    // Strip any in-file anchor; we verify the file exists, not the anchor.
    const filePart = target.split("#")[0];
    if (!filePart) continue; // pure same-file anchor
    const resolved = resolve(dirname(file), filePart);
    if (!(await pathExists(resolved))) {
      problems.push(`${relative(ROOT, file)}  ->  ${target}`);
    }
  }
}

if (problems.length) {
  console.error(`\n✖ ${problems.length} broken internal link(s):\n`);
  for (const p of problems) console.error("  " + p);
  console.error("");
  process.exit(1);
}

console.log(`✓ Checked ${files.length} Markdown file(s); all internal links resolve.`);
