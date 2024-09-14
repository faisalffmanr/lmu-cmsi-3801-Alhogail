local exercises = require("exercises")

--------------------------------------------------------------------------------
passed, failed = 0, 0

function suite(name)
  io.write("\nTesting " .. name)
end

function expect(condition)
  if condition then passed = passed + 1 else failed = failed + 1 end
  io.write(condition and " ." or " F")
end

function expect_array_equals(a1, a2)
  if #a1 ~= #a2 then expect(false); return end
  for i = 1, #a1 do
    if a1[i] ~= a2[i] then expect(false); return end
  end
  expect(true)
end

function expect_hash_equals(h1, h2)
  for k, v in pairs(h1) do
    if h2[k] ~= v then expect(false); return end
  end
  for k, v in pairs(h2) do
    if h1[k] ~= v then expect(false); return end
  end
  expect(true)
end

function expect_error(text, fun, arg)
  local success, err = pcall(fun, arg)
  expect(not success and string.match(err, text) ~= nil)
end
--------------------------------------------------------------------------------

suite("change")
expect_error("Amount must be an integer", exercises.change, 33.375)
expect_error("Amount cannot be negative", exercises.change, -50)   
expect_hash_equals(exercises.change(0), {[25]=0, [10]=0, [5]=0, [1]=0})
expect_hash_equals(exercises.change(1), {[25]=0, [10]=0, [5]=0, [1]=1})
expect_hash_equals(exercises.change(8), {[25]=0, [10]=0, [5]=1, [1]=3})
expect_hash_equals(exercises.change(42), {[25]=1, [10]=1, [5]=1, [1]=2})
expect_hash_equals(exercises.change(99), {[25]=3, [10]=2, [5]=0, [1]=4})
expect_hash_equals(exercises.change(144), {[25]=5, [10]=1, [5]=1, [1]=4})
expect_hash_equals(exercises.change(250), {[25]=10, [10]=0, [5]=0, [1]=0})
expect_hash_equals(exercises.change(100000000037), {[25]=4000000001, [10]=1, [5]=0, [1]=2})
expect_hash_equals(exercises.change(10000000000005), {[25]=400000000000, [10]=0, [5]=1, [1]=0})

suite("first_then_lower_case")
function nonEmpty(s) return s ~= "" end
function lengthGreaterThan3(s) return #s > 3 end
expect(exercises.firstThenLowerCase({}, nonEmpty) == nil)
expect(exercises.firstThenLowerCase({"", "A", "B"}, nonEmpty) == "a")
expect(exercises.firstThenLowerCase({"", "A", "ABC"}, lengthGreaterThan3) == nil)
expect(exercises.firstThenLowerCase({"ABC", "ABCD", "ABCDE"}, lengthGreaterThan3) == "abcd")

suite("powers_generator")
gen = exercises.powersGenerator(3, 100)
status = coroutine.status(gen)
success, power = coroutine.resume(gen)
expect(status == "suspended" and success and power == 1)
status = coroutine.status(gen)
success, power = coroutine.resume(gen)
expect(status == "suspended" and success and power == 3)
status = coroutine.status(gen)
success, power = coroutine.resume(gen)
expect(status == "suspended" and success and power == 9)
status = coroutine.status(gen)
success, power = coroutine.resume(gen)
expect(status == "suspended" and success and power == 27)
status = coroutine.status(gen)
success, power = coroutine.resume(gen)
expect(status == "suspended" and success and power == 81)
status = coroutine.status(gen)
success, power = coroutine.resume(gen)
expect(status == "suspended" and success and power == nil)
status = coroutine.status(gen)
success, power = coroutine.resume(gen)
expect(status == "dead" and not success)

suite("say")
expect(exercises.say() == "")
expect(exercises.say("hi")() == "hi")
expect(exercises.say("hi")("there")() == "hi there")
expect(exercises.say("hello")("my")("name")("is")("Colette")() == "hello my name is Colette")
expect(exercises.say("h i")() == "h i")
expect(exercises.say("hi ")("   there")() == "hi     there")
expect(exercises.say("")("")("dog")("")("go")() == "  dog  go")
expect(exercises.say("😄🤗")("💀👊🏾")() == "😄🤗 💀👊🏾")

suite("meaningful_line_count")
expect_error("No such file", exercises.meaningful_line_count, "no-such-file.txt")
expect(exercises.meaningful_line_count("./test-for-line-count.txt") == 7)

suite("Quaternion")
q = exercises.Quaternion.new(3.5, 2.25, -100.0, -1.25)
expect(q.a == 3.5)
expect(q.b == 2.25)
expect(q.c == -100.0)
expect(q.d == -1.25)
q1 = exercises.Quaternion.new(1.0, 3.0, 5.0, 2.0)
q2 = exercises.Quaternion.new(-2.0, 2.0, 8.0, -1.0)
q3 = exercises.Quaternion.new(-1.0, 5.0, 13.0, 1.0)
q4 = exercises.Quaternion.new(-46.0, -25.0, 5.0, 9.0)
zero = exercises.Quaternion.new(0, 0, 0, 0)
i = exercises.Quaternion.new(0, 1, 0, 0)
j = exercises.Quaternion.new(0, 0, 1, 0)
k = exercises.Quaternion.new(0, 0, 0, 1)
expect_array_equals(zero:coefficients(), {0.0, 0.0, 0.0, 0.0})
expect_array_equals(k:coefficients(), {0.0, 0.0, 0.0, 1.0})
expect_array_equals(q2:coefficients(), {-2.0, 2.0, 8.0, -1.0})
expect(q1 + q2 == q3)
expect(q1 * q2 == q4)
expect(q1 + zero == q1)
expect(q1 * zero == zero)
expect(i * j == k)
expect(j * k == i)
expect(j + i == exercises.Quaternion.new(0.0, 1.0, 1.0, 0.0))
expect(tostring(zero) == "0")
expect(tostring(j) == "j")
expect(tostring(k:conjugate()) == "-k")
expect(tostring(j:conjugate() * exercises.Quaternion.new(2.0, 0.0, 0.0, 0.0)) == "-2.0j")
expect(tostring(j + k) == "j+k")
expect(tostring(exercises.Quaternion.new(0.0, -1.0, 0.0, 2.25)) == "-i+2.25k")
expect(tostring(exercises.Quaternion.new(-20.0, -1.75, 13.0, -2.25)) == "-20.0-1.75i+13.0j-2.25k")
expect(tostring(exercises.Quaternion.new(-1.0, -2.0, 0.0, 0.0)) == "-1.0-2.0i")
expect(tostring(exercises.Quaternion.new(1.0, 0.0, -2.0, 5.0)) == "1.0-2.0j+5.0k")

print(string.format("\n%d passed, %d failed", passed, failed))
