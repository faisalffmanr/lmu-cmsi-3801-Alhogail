import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.Predicate;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class Exercises {

    // This function returns a map containing the count of each coin denomination (quarters, dimes, nickels, pennies).
    static Map<Integer, Long> change(long amount) {
        if (amount < 0) {
            throw new IllegalArgumentException("Amount cannot be negative");
        }
        var counts = new HashMap<Integer, Long>();
        // Calculate the number of coins for each denomination: quarters (25c), dimes (10c), nickels (5c), pennies (1c)
        for (var denomination : List.of(25, 10, 5, 1)) {
            counts.put(denomination, amount / denomination);
            amount %= denomination;
        }
        return counts;
    }

    // This function finds the first string that matches the given predicate, converts it to lowercase, and returns it.
    public static Optional<String> firstThenLowerCase(List<String> strings, Predicate<String> p) {
        return strings.stream()
            .filter(p)
            .findFirst()
            .map(String::toLowerCase);
    }

    // This Sayer record holds a phrase and allows chaining words with spaces in between.
    static record Sayer(String phrase) {
        // Append a word (with appropriate spacing) to the current phrase.
        Sayer and(String word) {
            if (word.isEmpty()) {
                return new Sayer(phrase + " ");
            }
            if (!phrase.isEmpty()) {
                return new Sayer(phrase + " " + word);
            }
            return new Sayer(phrase + word);
        }
    }

    // Create a new Sayer instance with an empty phrase.
    public static Sayer say() {
        return new Sayer("");
    }

    // Create a new Sayer instance initialized with the given phrase.
    public static Sayer say(String phrase) {
        return new Sayer(phrase);
    }

    // Function to count the number of meaningful lines in a file (non-empty, non-comment lines).
    public static int meaningfulLineCount(String filename) throws IOException {
        try (var reader = new BufferedReader(new FileReader(filename))) {
            return (int) reader.lines()
                    .filter(line -> !line.trim().isEmpty() && !line.trim().startsWith("#"))
                    .count();
        }
    }
}

// Quaternion class representing a quaternion and providing basic operations.
class Quaternion {

    public static final Quaternion ZERO = new Quaternion(0, 0, 0, 0);
    public static final Quaternion I = new Quaternion(0, 1, 0, 0);
    public static final Quaternion J = new Quaternion(0, 0, 1, 0);
    public static final Quaternion K = new Quaternion(0, 0, 0, 1);

    public final double a;  
    public final double b;  
    public final double c;  
    public final double d;  

    // Constructor to initialize a quaternion with given components.
    public Quaternion(double a, double b, double c, double d) {
        this.a = a;
        this.b = b;
        this.c = c;
        this.d = d;
    }

    // Methods to satisfy the expected test calls
    public double a() {
        return a;
    }

    public double b() {
        return b;
    }

    public double c() {
        return c;
    }

    public double d() {
        return d;
    }

    // Add this quaternion to another quaternion.
    public Quaternion plus(Quaternion other) {
        return new Quaternion(
            this.a + other.a,
            this.b + other.b,
            this.c + other.c,
            this.d + other.d
        );
    }

    // Multiply this quaternion with another quaternion.
    public Quaternion times(Quaternion other) {
        return new Quaternion(
            a * other.a - b * other.b - c * other.c - d * other.d,
            a * other.b + b * other.a + c * other.d - d * other.c,
            a * other.c - b * other.d + c * other.a + d * other.b,
            a * other.d + b * other.c - c * other.b + d * other.a
        );
    }

    // Return the conjugate of this quaternion.
    public Quaternion conjugate() {
        return new Quaternion(a, -b, -c, -d);
    }

    // Return a list of coefficients for the quaternion.
    public List<Double> coefficients() {
        return List.of(a, b, c, d);
    }

    // Custom string representation for the quaternion.
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        if (a != 0) sb.append(a);
        if (b != 0) sb.append(b > 0 && sb.length() > 0 ? "+" : "").append(b).append("i");
        if (c != 0) sb.append(c > 0 && sb.length() > 0 ? "+" : "").append(c).append("j");
        if (d != 0) sb.append(d > 0 && sb.length() > 0 ? "+" : "").append(d).append("k");
        return sb.length() > 0 ? sb.toString() : "0";
    }

    // Check if two quaternions are equal.
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (!(obj instanceof Quaternion)) return false;
        Quaternion other = (Quaternion) obj;
        return Double.compare(a, other.a) == 0 &&
               Double.compare(b, other.b) == 0 &&
               Double.compare(c, other.c) == 0 &&
               Double.compare(d, other.d) == 0;
    }

    @Override
    public int hashCode() {
        return Double.hashCode(a) ^ Double.hashCode(b) ^ Double.hashCode(c) ^ Double.hashCode(d);
    }
}

// Sealed interface for a binary search tree.
sealed interface BinarySearchTree permits Empty, Node {
    int size();  // Returns the size of the tree
    boolean contains(String value);  
    BinarySearchTree insert(String value);  
}

// Represents an empty binary search tree.
final class Empty implements BinarySearchTree {
    @Override
    public int size() {
        return 0;  
    }

    @Override
    public boolean contains(String value) {
        return false;  
    }

    @Override
    public BinarySearchTree insert(String value) {
        return new Node(value, new Empty(), new Empty());  // Insert value and create a new Node
    }

    @Override
    public String toString() {
        return "()";  // Represents an empty tree as "()"
    }

    @Override
    public boolean equals(Object obj) {
        return obj instanceof Empty;  // Two empty trees are always equal
    }

    @Override
    public int hashCode() {
        return 0;  // Hash code for an empty tree
    }
}

// Represents a node in a binary search tree.
final class Node implements BinarySearchTree {
    public final String value;
    public final BinarySearchTree left;
    public final BinarySearchTree right;

    // Constructor to create a node with a value, left, and right subtree.
    public Node(String value, BinarySearchTree left, BinarySearchTree right) {
        this.value = value;
        this.left = left;
        this.right = right;
    }

    @Override
    public int size() {
        return 1 + left.size() + right.size();  
    }

    @Override
    public boolean contains(String value) {
        if (this.value.equals(value)) return true;
        if (value.compareTo(this.value) < 0) return left.contains(value);  
        return right.contains(value);  
    }

    @Override
    public BinarySearchTree insert(String value) {
        if (value.equals(this.value)) return this;  
        if (value.compareTo(this.value) < 0) {
            return new Node(this.value, left.insert(value), right);  
        } else {
            return new Node(this.value, left, right.insert(value));  
        }
    }

    @Override
    public String toString() {
        return String.format("(%s%s%s)", left.toString(), value, right.toString());  
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (!(obj instanceof Node)) return false;
        Node other = (Node) obj;
        return value.equals(other.value) && left.equals(other.left) && right.equals(other.right);
    }

    @Override
    public int hashCode() {
        return value.hashCode() ^ left.hashCode() ^ right.hashCode();
    }
}
