import fs from 'fs/promises';

// this function to calculate change in quarters, dimes, nickels, and pennies
export function change(amount) {
  if (!Number.isInteger(amount)) {
    throw new TypeError("Amount must be an integer");
  }
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative");
  }
  const counts = {};
  let remaining = amount;
  for (const denomination of [25, 10, 5, 1]) {
    counts[denomination] = Math.floor(remaining / denomination);
    remaining %= denomination;
  }
  return counts;
}

// this function is to find the first string matching the predicate, then return it in lowercase
export function firstThenLowerCase(strings, predicate) {
  const first = strings.find(predicate);
  return first ? first.toLowerCase() : undefined;
}

// this generator function is to yield powers of a base up to a given limit
export function* powersGenerator({ ofBase, upTo }) {
  let exponent = 0;
  while (true) {
    const power = ofBase ** exponent;
    if (power > upTo) return;
    yield power;
    exponent++;
  }
}

// this function to create a chainable sentence builder
export function say(...words) {
  if (words.length === 0) return "";

  const result = words.join(" ");
  const innerSay = (...newWords) => {
    if (newWords.length === 0) return result;
    return say(...words, ...newWords);
  };
  innerSay.toString = () => result;
  return innerSay;
}

// this function to count meaningful lines in a file
export async function meaningfulLineCount(filePath) {
  try {
    const text = await fs.readFile(filePath, 'utf-8');
    return text
      .split("\n")
      .map((line) => line.trim())
      .filter((line) => line !== "" && !line.startsWith("#")).length;
  } catch (error) {
    console.error(`Failed to open the file: ${filePath}`, error);
    throw new Error("Failed to open the file");
  }
}

// Quaternion class implementation
export class Quaternion {
  constructor(r = 0, i = 0, j = 0, k = 0) {
    this.r = r;
    this.i = i;
    this.j = j;
    this.k = k;
    Object.freeze(this);
  }

  add(q) {
    return new Quaternion(
      this.r + q.r,
      this.i + q.i,
      this.j + q.j,
      this.k + q.k
    );
  }

  multiply(q) {
    return new Quaternion(
      this.r * q.r - this.i * q.i - this.j * q.j - this.k * q.k,
      this.r * q.i + this.i * q.r + this.j * q.k - this.k * q.j,
      this.r * q.j - this.i * q.k + this.j * q.r + this.k * q.i,
      this.r * q.k + this.i * q.j - this.j * q.i + this.k * q.r
    );
  }

  get conjugate() {
    return new Quaternion(this.r, -this.i, -this.j, -this.k);
  }

  get coefficients() {
    return [this.r, this.i, this.j, this.k];
  }

  equals(q) {
    return this.r === q.r && this.i === q.i && this.j === q.j && this.k === q.k;
  }

  toString() {
    const components = [];
    if (this.r !== 0) components.push(`${this.r}`);
    if (this.i !== 0) components.push(`${this.i === 1 ? '' : this.i === -1 ? '-' : this.i}i`);
    if (this.j !== 0) components.push(`${this.j >= 0 && components.length > 0 ? '+' : ''}${this.j === 1 ? '' : this.j === -1 ? '-' : this.j}j`);
    if (this.k !== 0) components.push(`${this.k >= 0 && components.length > 0 ? '+' : ''}${this.k === 1 ? '' : this.k === -1 ? '-' : this.k}k`);
    return components.length > 0 ? components.join('') : '0';
  }

  plus(q) {
    return this.add(q);
  }

  times(q) {
    return this.multiply(q);
  }
}
