// Grouping a list by a key — the built-in Object.groupBy / Map.groupBy (Node 21+,
// modern browsers) replace lodash.groupBy for most cases. A portable reduce-based
// fallback is included for older runtimes. Concepts:
//   ../../references/javascript/iterables-and-generators.md (Map vs object)

const people = [
  { name: "Ada", dept: "eng" },
  { name: "Bo", dept: "sales" },
  { name: "Cy", dept: "eng" },
];

// Built-in: keys become OBJECT keys (strings/symbols) → good for static/string keys.
const byDept = Object.groupBy(people, (p) => p.dept);
// { eng: [{Ada}, {Cy}], sales: [{Bo}] }

// Built-in Map variant: keys can be ANY type (objects, numbers) and order is kept.
const byDeptMap = Map.groupBy(people, (p) => p.dept);
// Map(2) { 'eng' => [...], 'sales' => [...] }

/** Portable fallback (any runtime): group into a Map by a key function. */
export function groupBy(items, keyFn) {
  const out = new Map();
  for (const item of items) {
    const key = keyFn(item);
    const bucket = out.get(key);
    if (bucket) bucket.push(item);
    else out.set(key, [item]);
  }
  return out;
}

// --- demo (run: node group-by.mjs) ---
if (import.meta.url === `file://${process.argv[1]}`) {
  console.log("Object.groupBy:", byDept);
  console.log("Map.groupBy:", byDeptMap);
  console.log("fallback:", groupBy(people, (p) => p.dept));
}
