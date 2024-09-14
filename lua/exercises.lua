local exercises = {}

-- this function is to calculate the absolute value
local function abs(x)
  return x < 0 and -x or x
end

-- Implement change function
function exercises.change(amount)
  if math.type(amount) ~= "integer" then
    error("Amount must be an integer")
  elseif amount < 0 then
    error("Amount cannot be negative")
  end
  local counts, remaining = {}, amount
  for _, denomination in ipairs({25, 10, 5, 1}) do
    counts[denomination], remaining = remaining // denomination, remaining % denomination
  end
  return counts
end

-- Implement firstThenLowerCase function
function exercises.firstThenLowerCase(strings, predicate)
  for _, s in ipairs(strings) do
    if predicate(s) then
      return s:lower()
    end
  end
  return nil
end

-- Implement powersGenerator coroutine
function exercises.powersGenerator(base, limit)
  return coroutine.create(function()
    local exponent = 0
    while true do
      local power = base ^ exponent
      if power > limit then break end
      coroutine.yield(power)
      exponent = exponent + 1
    end
  end)
end

-- Implement say function
function exercises.say(word)
  local words = {}
  local function innerSay(newWord)
    if not newWord then
      return table.concat(words, " ")
    end
    table.insert(words, newWord)
    return innerSay
  end
  return innerSay(word)
end

-- Implement meaningfulLineCount function
function exercises.meaningful_line_count(filename)
  local file = io.open(filename, "r")
  if not file then error("No such file") end
  local count = 0
  for line in file:lines() do
    if line:match("%S") then count = count + 1 end
  end
  file:close()
  return count
end

-- Implement Quaternion class
exercises.Quaternion = {}
exercises.Quaternion.__index = exercises.Quaternion

function exercises.Quaternion.new(a, b, c, d)
  return setmetatable({a = a, b = b, c = c, d = d}, exercises.Quaternion)
end

function exercises.Quaternion:coefficients()
  return {self.a, self.b, self.c, self.d}
end

function exercises.Quaternion:__add(q)
  return exercises.Quaternion.new(
    self.a + q.a, self.b + q.b, self.c + q.c, self.d + q.d
  )
end

function exercises.Quaternion:__mul(q)
  return exercises.Quaternion.new(
    self.a * q.a - self.b * q.b - self.c * q.c - self.d * q.d,
    self.a * q.b + self.b * q.a + self.c * q.d - self.d * q.c,
    self.a * q.c - self.b * q.d + self.c * q.a + self.d * q.b,
    self.a * q.d + self.b * q.c - self.c * q.b + self.d * q.a
  )
end

function exercises.Quaternion:conjugate()
  return exercises.Quaternion.new(self.a, -self.b, -self.c, -self.d)
end

function exercises.Quaternion:__tostring()
  return string.format("%g+%gi+%gj+%gk", self.a, self.b, self.c, self.d)
end

function exercises.Quaternion:__eq(q)
  return abs(self.a - q.a) < 1e-9 and
         abs(self.b - q.b) < 1e-9 and
         abs(self.c - q.c) < 1e-9 and
         abs(self.d - q.d) < 1e-9
end

return exercises
