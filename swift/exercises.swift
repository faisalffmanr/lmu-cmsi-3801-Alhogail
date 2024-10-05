import Foundation

// this is a custom error type to handle negative amounts in the change function
struct NegativeAmountError: Error {}

// this function is to calculate the change for a given amount using coins of denominations 25, 10, 5, and 1
// this will return a dictionary mapping each denomination to the number of coins used
func change(_ amount: Int) -> Result<[Int: Int], NegativeAmountError> {
    // here i'm ensuring the amount is non-negative
    guard amount >= 0 else {
        return .failure(NegativeAmountError())
    }

    var counts = [Int: Int]()  // this is a dictionary to store the count of each denomination
    var remaining = amount  // this is a variable to track the remaining amount to be changed

    // this is a loop to calculate the number of coins for each denomination
    for denomination in [25, 10, 5, 1] {
        counts[denomination] = remaining / denomination
        remaining %= denomination
    }
    return .success(counts)
}

// this function is to return the first string from a list that satisfies a predicate and convert it to lowercase
func firstThenLowerCase(of strings: [String], satisfying predicate: (String) -> Bool) -> String? {
    return strings.first(where: predicate)?.lowercased()
}

// this struct is used to construct phrases by appending words
struct Sayer {
    let phrase: String

    // this is a function to append a word to the existing phrase and return a new Sayer instance
    func and(_ word: String) -> Sayer {
        return Sayer(phrase: phrase + " " + word)
    }
}

// this is a function to initialize a Sayer with an optional starting word
func say(_ word: String = "") -> Sayer {
    return Sayer(phrase: word)
}

// this is a custom error type for handling missing files in the meaningfulLineCount function
struct NoSuchFileError: Error {}

// this is an asynchronous function to count the number of meaningful lines in a file (non-empty, non-comment lines)
// this should return the count or an error if the file doesn't exist or another issue occurs
func meaningfulLineCount(_ filename: String) async -> Result<Int, Error> {
    // here I'm ensuring that the file exists at the given path
    guard FileManager.default.fileExists(atPath: filename) else {
        return .failure(NoSuchFileError())
    }

    do {
        let contents = try String(contentsOfFile: filename, encoding: .utf8)
        let lines = contents.components(separatedBy: .newlines)
        // here is a filter lines to remove empty lines or those starting with a comment
        let meaningfulLines = lines.filter { line in
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            return !trimmed.isEmpty && !trimmed.hasPrefix("#")
        }
        return .success(meaningfulLines.count)
    } catch {
        return .failure(NoSuchFileError())
    }
}

// this struct representing a quaternion, which is a four-dimensional number
struct Quaternion: CustomStringConvertible, Equatable {
    let a, b, c, d: Double  // these are the coefficients for the quaternion

    // this static instances for special quaternions
    static let ZERO = Quaternion(a: 0, b: 0, c: 0, d: 0)
    static let I = Quaternion(a: 0, b: 1, c: 0, d: 0)
    static let J = Quaternion(a: 0, b: 0, c: 1, d: 0)
    static let K = Quaternion(a: 0, b: 0, c: 0, d: 1)

    // this is a computed property to return the coefficients as an array
    var coefficients: [Double] {
        return [a, b, c, d]
    }

    // this is a computed property to return the conjugate of the quaternion
    var conjugate: Quaternion {
        return Quaternion(a: a, b: -b, c: -c, d: -d)
    }

    // here i'm overloading the + operator to add two quaternions
    static func +(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(
            a: lhs.a + rhs.a,
            b: lhs.b + rhs.b,
            c: lhs.c + rhs.c,
            d: lhs.d + rhs.d
        )
    }

    // here im overloading the * operator to multiply two quaternions
    static func *(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        let a = lhs.a * rhs.a - lhs.b * rhs.b - lhs.c * rhs.c - lhs.d * rhs.d
        let b = lhs.a * rhs.b + lhs.b * rhs.a + lhs.c * rhs.d - lhs.d * rhs.c
        let c = lhs.a * rhs.c - lhs.b * rhs.d + lhs.c * rhs.a + lhs.d * rhs.b
        let d = lhs.a * rhs.d + lhs.b * rhs.c - lhs.c * rhs.b + lhs.d * rhs.a
        return Quaternion(a: a, b: b, c: c, d: d)
    }

    // this is a computed property to return a string representation of the quaternion
    var description: String {
        var parts = [String]()

        if a != 0 { parts.append("\(a)") }
        if b != 0 { parts.append(b == 1 ? "i" : b == -1 ? "-i" : "\(b)i") }
        if c != 0 { parts.append(c == 1 ? "j" : c == -1 ? "-j" : "\(c)j") }
        if d != 0 { parts.append(d == 1 ? "k" : d == -1 ? "-k" : "\(d)k") }

        if parts.isEmpty { return "0" }

        return parts.joined(separator: "+").replacingOccurrences(of: "+-", with: "-")
    }

    // this is a custom Equatable conformance for comparing two quaternions
    static func ==(lhs: Quaternion, rhs: Quaternion) -> Bool {
        return lhs.a == rhs.a && lhs.b == rhs.b && lhs.c == rhs.c && lhs.d == rhs.d
    }
}

// this is a binary search tree implementation with support for insertion and size calculation
indirect enum BinarySearchTree: CustomStringConvertible, Equatable {
    case empty
    case node(BinarySearchTree, String, BinarySearchTree)

    // here is a computed property to return the size of the tree (number of nodes)
    var size: Int {
        switch self {
        case .empty:
            return 0
        case let .node(left, _, right):
            return left.size + 1 + right.size
        }
    }

    // this is a function to check if a value is contained within the tree
    func contains(_ value: String) -> Bool {
        switch self {
        case .empty:
            return false
        case let .node(left, v, right):
            if value < v {
                return left.contains(value)
            } else if value > v {
                return right.contains(value)
            } else {
                return true
            }
        }
    }

    // this is a function to insert a new value into the binary search tree
    func insert(_ value: String) -> BinarySearchTree {
        switch self {
        case .empty:
            return .node(.empty, value, .empty)
        case let .node(left, v, right):
            if value < v {
                return .node(left.insert(value), v, right)
            } else if value > v {
                return .node(left, v, right.insert(value))
            } else {
                return self
            }
        }
    }

    // this is a computed property to return a string representation of the tree
    var description: String {
        switch self {
        case .empty:
            return "()"
        case let .node(left, v, right):
            if left == .empty && right == .empty {
                return "(\(v))"
            } else if left == .empty {
                return "(\(v)\(right))"
            } else if right == .empty {
                return "(\(left)\(v))"
            } else {
                return "(\(left)\(v)\(right))"
            }
        }
    }

    // this is a custom Equatable conformance for comparing two binary search trees
    static func ==(lhs: BinarySearchTree, rhs: BinarySearchTree) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case let (.node(left1, v1, right1), .node(left2, v2, right2)):
            return v1 == v2 && left1 == left2 && right1 == right2
        default:
            return false
        }
    }
}
