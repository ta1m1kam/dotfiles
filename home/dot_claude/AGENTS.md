# AGENTS.md

このファイルはコーディングエージェント全体に共通する指示をまとめたものです。
Claude Code, Codex CLI, その他エージェントから参照されることを想定しています。

## Conversation Guidelines

- 常に日本語で会話する

## Protected Branch Warning

- **セッション開始時に「保護されたブランチで作業中」という警告がコンテキストに含まれている場合、最初の応答で必ずユーザーに警告すること**
- main, develop, master ブランチで直接作業することは推奨されない
- 警告を検知したら、以下のようにユーザーに提案すること：
  - 「⚠️ 保護されたブランチで作業中です。worktreeで別ブランチを作成しますか？」
  - `gwta` コマンドで新規worktree作成を提案
  - `gwt` コマンドで既存worktree選択を提案

## Editorconfig

- **必ず** insert_final_newline = true を守る（すべてのファイルの最終行には必ず改行を入れる）
- trim_trailing_whitespace = true
- これらのルールは例外なく全てのファイル編集時に適用すること

## Git Commit

- 日本語でコミットしてください
- コミットメッセージの下に利用したプロンプトを `prompt: ` から始めて書いてください

## Development Philosophy

### Coding Guidelines

- 余計な自明なコードコメントは残さない

### Test-Driven Development (TDD)

- 原則としてテスト駆動開発（TDD）で進める
- 期待される入出力に基づき、まずテストを作成する
- 実装コードは書かず、テストのみを用意する
- テストを実行し、失敗を確認する
- テストが正しいことを確認できた段階でコミットする
- その後、テストをパスさせる実装を進める
- 実装中はテストを変更せず、コードを修正し続ける
- すべてのテストが通過するまで繰り返す

## Decision Making

- 不明点があれば実装する前に質問してください。計画や実装で迷うときはユーザーに質問しなさい
  - 積極的に `confirm_details` ツールを利用して
