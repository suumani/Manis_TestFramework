-- __Manis_TestFramework__/scripts/test/register_commands.lua
-- NOTE:
-- The sample suites included in this mod (e.g. cap_suite.lua) exist ONLY
-- as reference examples for how to write a test suite.
--
-- In normal usage, developers are NOT expected to add their own tests here.
-- Instead, each mod should:
--   - require("Manis_TestFramework/scripts/test/TestRunner")
--   - define its own test suites inside that mod
--   - register its own commands or hooks to run those suites
--
-- This file is intentionally minimal and does not auto-discover suites.
--
-- 注意:
-- このModに同梱されているサンプルスイート（例: cap_suite.lua）は、
-- 「テストスイートの書き方」を示すためだけの参考実装です。
--
-- 通常の利用では、開発者がこのMod内にテストを追加することは想定していません。
-- 各Mod側で以下を行ってください：
--   - Manis_TestFramework/scripts/test/TestRunner を require する
--   - 各Mod内でテストスイートを定義する
--   - そのMod自身でコマンド登録や実行トリガーを用意する
--
-- このファイルは意図的に「自動検出」を行わない設計になっています。


local TestRunner = require("scripts.test.TestRunner")

-- Load suites (you can split by file)
local suites = {
  -- Example suite module:
  -- cap = require("scripts.test.suites.cap_suite"),
  -- virtual = require("scripts.test.suites.virtual_suite"),
}

local function list_suites()
  local names = {}
  for k, _ in pairs(suites) do
    names[#names + 1] = k
  end
  table.sort(names)
  return names
end

local function print_usage()
  local names = list_suites()
  local msg = "[ManisTest] Usage:\n" ..
              "/manis-test list\n" ..
              "/manis-test run <suite>\n" ..
              "/manis-test run-all\n" ..
              "Available suites: " .. (#names > 0 and table.concat(names, ", ") or "(none)")
  game.print(msg)
end

commands.add_command("manis-test", "Run Manis test suites", function(cmd)
  if not game or not game.print then return end

  local param = (cmd and cmd.parameter) and cmd.parameter or ""
  param = param:gsub("^%s+", ""):gsub("%s+$", "")

  if param == "" then
    print_usage()
    return
  end

  if param == "list" then
    local names = list_suites()
    game.print("[ManisTest] Suites: " .. (#names > 0 and table.concat(names, ", ") or "(none)"))
    return
  end

  if param == "run-all" then
    local names = list_suites()
    if #names == 0 then
      game.print("[ManisTest] No suites registered.")
      return
    end

    for _, suite_name in ipairs(names) do
      local suite = suites[suite_name]
      TestRunner.run_suite(suite_name, suite)
    end
    return
  end

  -- "run <suite>"
  local action, suite_name = param:match("^(%S+)%s+(%S+)$")
  if action == "run" and suite_name then
    local suite = suites[suite_name]
    if not suite then
      game.print("[ManisTest] Unknown suite: " .. suite_name)
      print_usage()
      return
    end

    TestRunner.run_suite(suite_name, suite)
    return
  end

  print_usage()
end)