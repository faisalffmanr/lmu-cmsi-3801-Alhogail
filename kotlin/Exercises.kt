import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException

// this is a function to calculate change for a given amount using denominations 25, 10, 5, and 1
// this will return a map of denomination to the number of coins used
fun change(amount: Long): Map<Int, Long> {
    require(amount >= 0) { "Amount cannot be negative" }

    val counts = mutableMapOf<Int, Long>()
    var remaining = amount

    // this is a loop to calculate the number of coins for each denomination
    for (denomination in listOf(25, 10, 5, 1)) {
        counts[denomination] = remaining / denomination
        remaining %= denomination
    }
    return counts
}

// this is a function to return the first string from a list that satisfies a predicate and convert it to lowercase
fun firstThenLowerCase(strings: List<String>, predicate: (String) -> Boolean): String? {
    return strings.firstOrNull(predicate)?.lowercase()
}

// this is a data class to build phrases by appending words
data class Say(val phrase: String) {
    
    // this function is to append a new phrase to the current one and return a new Say object
    fun and(nextPhrase: String): Say {
        return Say("$phrase $nextPhrase")
    }
}

// this is a function to initialize a Say object with an optional starting phrase
fun say(phrase: String = ""): Say {
    return Say(phrase)
}

// this is a function to count the number of meaningful lines (non-empty, non-comment) in a file
// this will return the count of meaningful lines as a Long
fun meaningfulLineCount(filename: String): Long {
    BufferedReader(FileReader(filename)).useLines { lines ->
        return lines.count { line ->
            line.trim().isNotEmpty() && !line.trim().startsWith("#")
        }.toLong() // this will convert the count result to Long
    }
}

// this is a data class to represent a quaternion, which is a four-dimensional number
data class Quaternion(val a: Double, val b: Double, val c: Double, val d: Double) {

    // here is a companion object to define standard quaternions
    companion object {
        val ZERO = Quaternion(0.0, 0.0, 0.0, 0.0)
        val I = Quaternion(0.0, 1.0, 0.0, 0.0)
        val J = Quaternion(0.0, 0.0, 1.0, 0.0)
        val K = Quaternion(0.0, 0.0, 0.0, 1.0)
    }

    // this is an operator overload to add two quaternions
    operator fun plus(other: Quaternion): Quaternion {
        return Quaternion(a + other.a, b + other.b, c + other.c, d + other.d)
    }

    // this is an operator overload to multiply two quaternions
    operator fun times(other: Quaternion): Quaternion {
        return Quaternion(
            a * other.a - b * other.b - c * other.c - d * other.d,
            a * other.b + b * other.a + c * other.d - d * other.c,
            a * other.c - b * other.d + c * other.a + d * other.b,
            a * other.d + b * other.c - c * other.b + d * other.a
        )
    }

    // this is a function to return the coefficients of the quaternion as a list
    fun coefficients(): List<Double> = listOf(a, b, c, d)

    // this is a function to return the conjugate of the quaternion
    fun conjugate(): Quaternion = Quaternion(a, -b, -c, -d)

    // this is a function to override the toString method to provide a string representation of the quaternion
    override fun toString(): String {
        val parts = mutableListOf<String>()

        if (a != 0.0) parts.add(a.toString())
        if (b != 0.0) parts.add(if (b == 1.0) "i" else if (b == -1.0) "-i" else "${b}i")
        if (c != 0.0) parts.add(if (c == 1.0) "j" else if (c == -1.0) "-j" else "${c}j")
        if (d != 0.0) parts.add(if (d == 1.0) "k" else if (d == -1.0) "-k" else "${d}k")

        // hrer we handle signs and return the string
        return if (parts.isEmpty()) "0" else parts.joinToString(separator = "") {
            if (it.startsWith("-") || parts.first() == it) it else "+$it"
        }
    }
}

// this is a sealed interface for the Binary Search Tree Interface
sealed interface BinarySearchTree {
    // this is a function to return the size of the tree (number of nodes)
    fun size(): Int

    // this is a function to check if the tree contains a value
    fun contains(value: String): Boolean

    // this is a function to insert a value into the tree and return the new tree
    fun insert(value: String): BinarySearchTree

    // this is an empty tree case object, implementing the BinarySearchTree interface
    object Empty : BinarySearchTree {
        override fun size(): Int = 0
        override fun contains(value: String): Boolean = false
        override fun insert(value: String): BinarySearchTree = Node(value, Empty, Empty)
        override fun toString(): String = "()"
    }

    // here is a node class representing a non-empty tree with a value and left and right subtrees
    data class Node(private val value: String, val left: BinarySearchTree, val right: BinarySearchTree) : BinarySearchTree {

        // this will calculate the size of the tree recursively
        override fun size(): Int = 1 + left.size() + right.size()

        // this will check if the tree contains a value, navigating recursively
        override fun contains(value: String): Boolean = when {
            value < this.value -> left.contains(value)
            value > this.value -> right.contains(value)
            else -> true
        }

        // this will insert a new value into the tree recursively
        override fun insert(value: String): BinarySearchTree = when {
            value == this.value -> this
            value < this.value -> Node(this.value, left.insert(value), right)
            else -> Node(this.value, left, right.insert(value))
        }

        // here is a function to override the toString method to provide a string representation of the tree
        override fun toString(): String {
            return when {
                left is BinarySearchTree.Empty && right is BinarySearchTree.Empty -> "($value)"
                left is BinarySearchTree.Empty -> "($value${right})"
                right is BinarySearchTree.Empty -> "($left$value)"
                else -> "($left$value$right)"
            }
        }
    }
}

