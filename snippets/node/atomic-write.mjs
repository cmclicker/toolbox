// Atomically write a file: write to a temp file in the same directory, then
// rename over the target. rename(2) is atomic on the same filesystem, so a
// reader never sees a half-written file and a crash mid-write can't corrupt the
// original. Use for config/state files that must never be partially written.
// Reference: ../../references/node/built-in-modules.md

import { writeFile, rename } from "node:fs/promises";
import { dirname, join, basename } from "node:path";
import { pathToFileURL } from "node:url";

/**
 * Write `data` to `filePath` atomically.
 * The temp file is in the same directory so the rename stays on one filesystem
 * (a cross-device rename is not atomic and will fail with EXDEV).
 */
export async function writeFileAtomic(filePath, data) {
  const tmp = join(dirname(filePath), `.${basename(filePath)}.${process.pid}.tmp`);
  await writeFile(tmp, data);
  await rename(tmp, filePath); // atomic replace on the same filesystem
}

// Demo when run directly: node snippets/node/atomic-write.mjs
// (pathToFileURL handles Windows drive paths correctly; a raw `file://` + path does not.)
if (import.meta.url === pathToFileURL(process.argv[1]).href) {
  const target = join(process.cwd(), "atomic-demo.txt");
  await writeFileAtomic(target, `written atomically at ${new Date().toISOString()}\n`);
  const { readFile, rm } = await import("node:fs/promises");
  process.stdout.write(await readFile(target, "utf8"));
  await rm(target);
}
