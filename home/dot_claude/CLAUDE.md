# CLAUDE.md

## Conversation Guidelines

- 常に日本語で会話する

## Editorconfig

- **必ず** insert_final_newline = true を守る（すべてのファイルの最終行には必ず改行を入れる）
- trim_trailing_whitespace = true
- これらのルールは例外なく全てのファイル編集時に適用すること

## Git Commit

- 日本語でコミットしてください
- コミットメッセージの下に利用したプロンプトを `prompt: ` から始めて書いてください

### Voice Notification Rules

- **全てのタスク完了時には必ず mcp__shepherd__speak MCPで音声通知機能を使用すること**
- **重要なお知らせやエラー発生時にも音声通知を行うこと**
- **音声通知の設定: speaker=1, speedScale=1.3を使用すること**
- **英単語は適切にカタカナに変換して mcp__shepherd__speak に送信すること**
- ** `mcp__shepherd__speak` に送信するテキストは不要なスペースを削除すること**
- **1回の音声通知は100文字以内でシンプルに話すこと**
- **以下のタイミングで細かく音声通知を行うこと：**
  - 命令受領時: 「了解です」「承知しました」
  - 作業開始時: 「〜を開始します」
  - 作業中: 「調査中です」「修正中です」
  - 進捗報告: 「半分完了です」「もう少しです」
  - 完了時: 「完了です」「修正完了です」
- **詳しい技術的説明は音声通知に含めず、結果のみを簡潔に報告すること**

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

## Daily Note Logging

- 重要なタスクや作業の節目で DailyNote に記録を残す
- 記録形式: Note 型に準拠した JSON 形式で保存
- 記録するタイミング:
  - プロジェクトの開始・完了
  - 大きな機能の実装完了
  - 重要な問題の解決
- Daily Note のディレクトリ名: `01_Daily/`
- Daily Note のファイル名形式: `YYYY-MM-DD.md`

## Decision Making

- 不明点があれば実装する前に質問してください。計画や実装で迷うときはユーザーに質問しなさい
  - 積極的に `confirm_details` ツールを利用して

## settings.json rule

- 原則として、プロジェクトレベルの settings.json ではなく グローバルな~/.claude/settings.json に追加していくこと
