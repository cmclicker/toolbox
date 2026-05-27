// Exhaustiveness checking for discriminated unions: the compiler errors if a new
// union member is added and not handled. Reference:
//   ../../references/typescript/narrowing-and-guards.md

/** Call in the `default` branch. Reaching it with a non-`never` value is a compile error. */
export function assertNever(value: never): never {
  throw new Error(`Unhandled case: ${JSON.stringify(value)}`);
}

// --- Example ---------------------------------------------------------------
type Shape =
  | { kind: "circle"; radius: number }
  | { kind: "rect"; width: number; height: number };

export function area(shape: Shape): number {
  switch (shape.kind) {
    case "circle":
      return Math.PI * shape.radius ** 2;
    case "rect":
      return shape.width * shape.height;
    default:
      // If a third Shape variant is added later, `shape` is no longer `never`
      // here and this line fails to compile until the new case is handled.
      return assertNever(shape);
  }
}
