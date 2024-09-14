from dataclasses import dataclass
from collections.abc import Callable

# this function to calculate change 
def change(amount: int) -> dict[int, int]:
    if not isinstance(amount, int):
        raise TypeError('Amount must be an integer')
    if amount < 0:
        raise ValueError('Amount cannot be negative')
    counts, remaining = {}, amount
    for denomination in (25, 10, 5, 1):
        counts[denomination], remaining = divmod(remaining, denomination)
    return counts

# this function is to find the first string matching the predicate, then return it in lowercase
def first_then_lower_case(strings, predicate, /):
    for string in strings:
        if predicate(string):
            return string.lower()
    return None

# this generator function is to yield powers of a base up to a given limit
def powers_generator(base: int, limit: int):
    power = 0
    while base ** power <= limit:
        yield base ** power
        power += 1

# this function is to create a chainable sentence builder
def say(word=None):
    if not hasattr(say, "words"):
        say.words = []

    def inner(word=None):
        if word is None:
            result = ' '.join(say.words)
            say.words = []  # Reset list after getting the result
            return result
        else:
            say.words.append(word)  # directly add the word
            return inner

    return inner(word)

# this function is to count meaningful lines in a file 
def meaningful_line_count(filename: str) -> int:
    try:
        with open(filename, 'r') as file:
            count = 0
            for line in file:
                line = line.strip()
                if line and not line.startswith('#'):
                    count += 1
        return count
    except FileNotFoundError:
        raise

@dataclass(frozen=True)
class Quaternion:
    a: float
    b: float
    c: float
    d: float

    def __add__(self, other):
        return Quaternion(self.a + other.a, self.b + other.b, self.c + other.c, self.d + other.d)

    def __mul__(self, other):
        return Quaternion(
            self.a * other.a - self.b * other.b - self.c * other.c - self.d * other.d,
            self.a * other.b + self.b * other.a + self.c * other.d - self.d * other.c,
            self.a * other.c - self.b * other.d + self.c * other.a + self.d * other.b,
            self.a * other.d + self.b * other.c - self.c * other.b + self.d * other.a
        )

    @property
    def coefficients(self):
        return [self.a, self.b, self.c, self.d]

    @property
    def conjugate(self):
        return Quaternion(self.a, -self.b, -self.c, -self.d)

    def __eq__(self, other):
        return isinstance(other, Quaternion) and self.coefficients == other.coefficients

    def __str__(self):
        parts = []

        # this to format the real section
        if self.a != 0:
            real_part = f"{self.a:.6g}"
            parts.append(real_part)

        # this to format the unreal section
        for value, symbol in [(self.b, 'i'), (self.c, 'j'), (self.d, 'k')]:
            if value != 0:
                abs_value = abs(value)
                part = symbol if abs_value == 1 else f"{abs_value:.6g}{symbol}"
                sign = '-' if value < 0 else '+' if parts else ''
                parts.append(f"{sign}{part}")

        # to combine parts and handle special cases
        result = "".join(parts)
        if result == "1":
            result = "1.0"
        elif result == "-1":
            result = "-1.0"
        if result.startswith('+'):
            result = result[1:]
        result = result.replace('+-', '-').replace(' ', '')

        return result if result else "0"
