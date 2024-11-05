import { open } from "node:fs/promises";

export function change(amount: bigint): Map<bigint, bigint> {
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative");
  }
  let counts: Map<bigint, bigint> = new Map();
  let remaining = amount;
  for (const denomination of [25n, 10n, 5n, 1n]) {
    counts.set(denomination, remaining / denomination);
    remaining %= denomination;
  }
  return counts;
}


export function firstThenApply<T, U>(
  items: T[],
  predicate: (item: T) => boolean,
  consumer: (item: T) => U
): U | undefined {
  for (const item of items) {
    if (predicate(item)) {
      return consumer(item);
    }
  }
  return undefined;
}

// Infinite Powers Generator
export function* powersGenerator(base: bigint): Generator<bigint> {
  for (let power = 1n; ; power *= base) {
    yield power;
  }
}

// Line Count Function with Filters
export async function meaningfulLineCount(filename: string): Promise<number> {
  const fileHandle = await open(filename, 'r');
  try {
    const fileContent = await fileHandle.readFile({ encoding: 'utf8' });
    return fileContent
      .split('\n')
      .map(line => line.trim())
      .filter(line => line.length > 0 && !line.startsWith('#'))
      .length;
  } finally {
    await fileHandle.close();
  }
}

// Deep Equality Function
export function deepEqual<T>(a: T, b: T): boolean {
  if (a === b) {
    return true;
  }
  if (a === null || b === null || typeof a !== "object" || typeof b !== "object") {
    return false;
  }

  const keysA = Object.keys(a as Record<string, unknown>);
  const keysB = Object.keys(b as Record<string, unknown>);

  if (keysA.length !== keysB.length) {
    return false;
  }

  for (const key of keysA) {
    if (!keysB.includes(key) || !deepEqual((a as Record<string, unknown>)[key], (b as Record<string, unknown>)[key])) {
      return false;
    }
  }

  return true;
}

// Shape Types and Functions
interface Sphere {
  kind: "Sphere";
  radius: number;
}

interface Box {
  kind: "Box";
  width: number;
  length: number;
  depth: number;
}

export type Shape = Sphere | Box;

export function surfaceArea(shape: Shape): number {
  switch (shape.kind) {
    case "Sphere":
      return 4 * Math.PI * Math.pow(shape.radius, 2);
    case "Box":
      return 2 * (shape.width * shape.length + shape.width * shape.depth + shape.length * shape.depth);
  }
  throw new Error("Invalid shape type"); // Fallback for TypeScript
}

export function volume(shape: Shape): number {
  switch (shape.kind) {
    case "Sphere":
      return (4 / 3) * Math.PI * Math.pow(shape.radius, 3);
    case "Box":
      return shape.width * shape.length * shape.depth;
  }
  throw new Error("Invalid shape type"); // Fallback for TypeScript
}

// Binary Search Tree (BinarySearchTree) Implementation
export interface BinarySearchTree<T> {
  size(): number;
  insert(value: T): BinarySearchTree<T>;
  contains(value: T): boolean;
  inorder(): Iterable<T>;
}

export class Empty<T> implements BinarySearchTree<T> {
  size(): number {
    return 0;
  }

  insert(value: T): BinarySearchTree<T> {
    return new NonEmpty<T>(value, this, this);
  }

  contains(value: T): boolean {
    return false;
  }

  inorder(): Iterable<T> {
    return [];
  }

  toString(): string {
    return "()";
  }

  *[Symbol.iterator](): Iterator<T> {
    return [].values();
  }
}

export class NonEmpty<T> implements BinarySearchTree<T> {
  constructor(
    public data: T,
    public left: BinarySearchTree<T> = new Empty<T>(),
    public right: BinarySearchTree<T> = new Empty<T>()
  ) {}

  size(): number {
    return this.left.size() + this.right.size() + 1;
  }

  insert(value: T): BinarySearchTree<T> {
    if (value < this.data) {
      return new NonEmpty(this.data, this.left.insert(value), this.right);
    } else if (value > this.data) {
      return new NonEmpty(this.data, this.left, this.right.insert(value));
    } else {
      return this; 
    }
  }

  contains(value: T): boolean {
    if (value < this.data) {
      return this.left.contains(value);
    } else if (value > this.data) {
      return this.right.contains(value);
    } else {
      return true;
    }
  }

  inorder(): Iterable<T> {
    return [...this.left.inorder(), this.data, ...this.right.inorder()];
  }

  toString(): string {
    const leftStr = this.left.toString();
    const rightStr = this.right.toString();
    return `(${leftStr === '()' ? '' : leftStr}${this.data}${rightStr === '()' ? '' : rightStr})`;
  }

  *[Symbol.iterator](): Iterator<T> {
    yield* this.inorder();
  }
}
