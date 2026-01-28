-- __Manis_TestFramework__/MODPORTAL_DESCRIPTION.md

(en)
Manis Test Framework is a lightweight **runtime verification framework** for Factorio mods.

This is NOT a gameplay mod.
It provides a simple way to run deterministic, repeatable checks inside the game runtime and export results.

■ Features
- Run test suites via commands
- Output results to:
  - in-game chat
  - factorio-current.log
  - script-output (file output)
- Minimal assertions (assert / assert_eq)
- Suite-based structure (multiple named tests)

■ How to use
1) Enable this mod
2) Start or load a save
3) Run:
   - /manis-test list
   - /manis-test run <suite>
   - /manis-test run-all
4) Check outputs:
   - Chat log
   - factorio-current.log
   - script-output/manis_test_results.log

■ Notes
- This framework is designed for **command-driven tests** (manual trigger).
- It does not run automatically in the background.

A small sample suite is included as a reference.

------

(ja)
Manis Test Framework は、Factorio Mod向けの **実行時検証（Runtime Verification）フレームワーク**です。

これはゲーム内容を追加するModではありません。
ゲーム内で再現可能なチェックを実行し、結果を保存するためのツールです。

■ 機能
- コマンドでテストスイートを実行
- 結果を以下へ出力：
  - ゲーム内チャット
  - factorio-current.log
  - script-output（ファイル出力）
- 最小限のアサーション（assert / assert_eq）
- スイート形式（複数テストをまとめて実行）

■ 使い方（How to use）
1) 本Modを有効化
2) セーブを開始またはロード
3) 以下のコマンドを実行：
   - /manis-test list
   - /manis-test run <suite>
   - /manis-test run-all
4) 出力を確認：
   - チャットログ
   - factorio-current.log
   - script-output/manis_test_results.log

■ 注意
- 本フレームワークは **コマンド実行型**です（手動トリガー）。
- 自動で常時テストを走らせる設計ではありません。

参考として、サンプルのテストスイートを同梱しています。