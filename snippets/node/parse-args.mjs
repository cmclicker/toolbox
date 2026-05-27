// CLI argument parsing with the BUILT-IN node:util parseArgs — no yargs/commander
// needed for typical cases. Reference: ../../references/node/built-in-modules.md
// Requires Node 18.3+ (stable in 20+). You're on Node 24.

import { parseArgs } from "node:util";

const { values, positionals } = parseArgs({
  allowPositionals: true,
  options: {
    // type: 'string' | 'boolean'; short: single-char alias; multiple: collect into array
    output: { type: "string", short: "o" },
    name: { type: "string", short: "n", default: "world" },
    verbose: { type: "boolean", short: "v", default: false },
    help: { type: "boolean", short: "h", default: false },
  },
});

if (values.help) {
  console.log(`Usage: ${process.argv[1].split(/[\\/]/).pop()} [-v] [-o FILE] [-n NAME] ARG...`);
  process.exit(0);
}

if (values.verbose) {
  console.error(`name=${values.name} output=${values.output ?? "<stdout>"} args=${positionals.join(",")}`);
}

if (positionals.length === 0) {
  console.error("error: need at least one positional ARG");
  process.exit(2);
}

for (const arg of positionals) {
  console.log(`hello ${values.name}, processing ${arg}`);
}
