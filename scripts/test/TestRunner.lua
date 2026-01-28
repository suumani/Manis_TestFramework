-- __Manis_TestFramework__/scripts/test/TestRunner.lua
-- ------------------------------------------------------------
-- Responsibility:
--   Lightweight runtime test runner for Factorio mods.
--   - Run test suites deterministically inside the game runtime
--   - Report results to chat + log + script-output file
-- Notes:
--   - Designed for manual/command-driven execution (not automatic).
-- ------------------------------------------------------------

local TestRunner = {}

local OUTPUT_FILE = "manis_test_results.log"  -- written under script-output/
local PREFIX = "[ManisTest] "

-- ----------------------------
-- helpers
-- ----------------------------

local function safe_tostring(v)
  if v == nil then return "nil" end
  return tostring(v)
end

local function to_log_string(data)
  if type(data) == "string" then
    return data
  end

  if type(data) ~= "table" then
    return safe_tostring(data)
  end

  -- Minimal table stringify (stable enough for logs)
  local parts = {}
  for k, v in pairs(data) do
    parts[#parts + 1] = safe_tostring(k) .. "=" .. safe_tostring(v)
  end
  return "{" .. table.concat(parts, ", ") .. "}"
end

local function write_line(data)
  local line = to_log_string(data)

  -- File output (official Factorio helper)
  if helpers and helpers.write_file then
    helpers.write_file(OUTPUT_FILE, line .. "\n", true)
  end

  -- Factorio runtime output
  log(PREFIX .. line)
  if game and game.print then
    game.print(PREFIX .. line)
  end
end

local function fail(msg)
  error("FAIL: " .. (msg or "Assertion failed"))
end

-- ----------------------------
-- assertions
-- ----------------------------

function TestRunner.assert(condition, msg)
  if not condition then
    fail(msg)
  end
end

function TestRunner.assert_eq(actual, expected, msg)
  if actual ~= expected then
    fail(string.format("%s | Expected '%s', got '%s'", msg or "assert_eq", safe_tostring(expected), safe_tostring(actual)))
  end
end

-- convenience: numeric close
function TestRunner.assert_near(actual, expected, eps, msg)
  eps = eps or 1e-6
  if type(actual) ~= "number" or type(expected) ~= "number" then
    fail((msg or "assert_near") .. " | actual/expected must be numbers")
  end
  if math.abs(actual - expected) > eps then
    fail(string.format("%s | Expected near %s (+/-%s), got %s", msg or "assert_near", actual, eps, expected))
  end
end

-- ----------------------------
-- suite runner
-- ----------------------------

-- @param suite_name string
-- @param test_functions table<string, function(TestRunner)>
function TestRunner.run_suite(suite_name, test_functions)
  -- per-suite stats (no accumulation)
  local stats = { passed = 0, failed = 0 }

  write_line("=== START SUITE: " .. suite_name .. " ===")

  -- deterministic order (optional but recommended)
  local names = {}
  for name, _ in pairs(test_functions) do
    names[#names + 1] = name
  end
  table.sort(names)

  for _, name in ipairs(names) do
    local func = test_functions[name]

    local ok, err = pcall(func, TestRunner)
    if ok then
      stats.passed = stats.passed + 1
      write_line("  [PASS] " .. name)
    else
      stats.failed = stats.failed + 1
      write_line("  [FAIL] " .. name .. " :: " .. safe_tostring(err))
    end
  end

  write_line(string.format("=== END SUITE: %s (Pass: %d, Fail: %d) ===", suite_name, stats.passed, stats.failed))
  return stats
end

return TestRunner