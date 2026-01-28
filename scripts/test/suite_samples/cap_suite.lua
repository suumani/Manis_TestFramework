-- scripts/test/suite_samples/cap_suite.lua

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

return {
  ["example: 1+1"] = function(T)
    T.assert_eq(1 + 1, 2, "math broken")
  end,
}