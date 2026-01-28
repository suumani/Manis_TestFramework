# __Manis_TestFramework__/README.ja.md

# Manis Test Framework

Factorio 2.0 Mod開発者向けの、**軽量・手動実行型・決定論的テストフレームワーク**です。

このModは、重厚なインフラやCI環境、非決定的な挙動を持ち込むことなく、**稼働中のFactorioゲーム内**で自動テストを記述・実行するためのシンプルな手段を提供します。

---

## コンセプト (Concept)

Manis Test Framework は、完全なCIシステムでは**ありません**。
また、常駐型の自動テストランナーでも**ありません**。

代わりに、以下のような設計思想で作られています：

- Mod作者のための **開発者ツール** である
- コンソールコマンド経由で **手動実行** される
- **決定論的（Deterministic）** であり、マルチプレイでも安全である
- 既存のMod構造を変えることなく、簡単に組み込める

フレームワーク自体は、デフォルトでは何もテスト**しません**。
実行エンジンとユーティリティを提供するだけです。

---

## 主な機能 (Key Features)

- シンプルなテストランナー (`TestRunner`)
- 基本的なアサーション:
  - `assert(condition, message)`
  - `assert_eq(actual, expected, message)`
- コンソールコマンドによる手動実行
- 実行結果の出力先:
  - ゲーム内チャット
  - `factorio-current.log`
  - 任意のファイル出力（`helpers.write_file` 利用）
- 決定論的実行（Lua標準の `math.random` を使用しない）
- グローバルフックや自動スキャンを行わない

---

## 使い方（クイックスタート）

### 1. 依存関係の追加

`info.json` の依存関係リストにこのModを追加してください：

```json
"dependencies": [
  "Manis_TestFramework >= 0.0.1"
]
```

### 2. Mod内で TestRunner を読み込む

```lua
local TestRunner = require("__Manis_TestFramework__/scripts/test/TestRunner")
```

### 3. Mod内にテストスイートを定義する

```lua
-- scripts/tests/my_suite.lua
return {
  ["example: 1 + 1"] = function(T)
    T.assert_eq(1 + 1, 2, "math broken")
  end,

  ["example: boolean check"] = function(T)
    T.assert(true, "this should never fail")
  end,
}
```

### 4. コマンドを登録する（推奨）

```lua
local TestRunner = require("__Manis_TestFramework__/scripts/test/TestRunner")
local suite = require("scripts.tests.my_suite")

commands.add_command("my-mod-test", "Run my mod tests", function()
  TestRunner.run_suite("my-mod", suite)
end)
```

### ゲーム内で実行する：

```
/my-mod-test
```

## サンプルスイートについて (About Sample Suites)

このModには **デモンストレーションのみを目的とした** サンプルテストスイート（例: `cap_suite.lua`）が含まれている場合があります。

これらのファイルは以下の点を示すためにのみ存在します：

- テストスイートの構造
- アサーションの書き方
- ランナーによる実行方法

これらをこのMod内で直接拡張することは**想定していません**。

### 重要な注意点

- `Manis_TestFramework` の内部にあなた独自のテストを追加することは **期待されていません**。
- 通常の推奨ワークフローは以下の通りです：
  - 各Modが **独自のテストスイート** を定義する
  - 各Modが、テストを **いつ・どのように** 実行するかを決定する
- このフレームワークは **テストの自動検出や自動実行を行いません**。

この設計は意図的なものです。

これにより以下を回避します：
- 隠れた、あるいは予期しないテスト実行
- ゲームプレイ中のパフォーマンスへの影響
- マルチプレイでの同期ズレ（Desync）リスク

---

## なぜ手動実行なのか？ (Why Manual Execution?)

FactorioのModは **ライブシミュレーション環境** の中で動作します。

バックグラウンドでテストを自動実行すると、以下の問題を引き起こす可能性があります：
- ゲームプレイへの干渉
- 予期しないゲーム状態の変更
- マルチプレイでの同期ズレ
- 誤解を招くテスト結果

これらの理由から、Manis Test Framework はテスト実行に **明示的なユーザーコマンド** を要求します。

これにより以下が保証されます：
- 開発者が意図した時のみテストが走る
- ゲーム状態が意識的に準備されている
- 結果の再現性とデバッグのしやすさ

---

## 決定論ポリシー (Determinism Policy)

- すべてのテスト実行は決定論的（Deterministic）でなければなりません
- ランダム性が必要な場合は、Factorioの `LuaRandomGenerator` を使用してください
- Lua標準の `math.random` は **使用しないでください**
- 非決定的な挙動はすべて **バグ** として扱われます

---

## ログと出力 (Logging and Output)

デフォルトでは、テスト結果は以下に出力されます：

- ゲーム内チャット (`game.print`)
- ログファイル (`factorio-current.log` への `log()` 出力)

Factorioの公式APIを使用して、任意のファイル出力を追加することも可能です：

```lua
helpers.write_file("manis_test.log", "message\n", true)
```

これにより以下が可能になります：

- テストログの永続化
- 実行ごとの結果比較
- クラッシュ後の外部からの調査

---

## 目指さないこと (Non-goals)

このフレームワークは以下を目指していません：

- CIパイプラインの代替
- セーブ/ロード時のテスト自動実行
- Mod間でのテスト構造の強制
- Factorio内部システムのMock化やシミュレーション

意図的に最小限かつ透明性の高い設計としています。

---

## 想定読者 (Intended Audience)

- Factorio Mod開発者
- 複雑で決定論的なロジックを保守する開発者
- リファクタリングや最適化の際に確信を持ちたいMod作者

---

## ステータスとロードマップ (Status and Roadmap)

- 初回パブリックリリース: v0.0.1

### 今後の計画
- 明らかに必要な場合に限り、小さなヘルパーユーティリティを追加
- 大規模な機能拡張の予定なし

このフレームワークは、小さく、安定しており、予測可能であることを維持します。

---

Happy testing.
もしあなたのテストでゲームが壊れたとしても、少なくともそれは「意図通りに」壊れたということです :)