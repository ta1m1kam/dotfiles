# CLAUDE.md

@AGENTS.md

## settings.json

- 原則として、プロジェクトレベルの settings.json ではなくグローバルな ~/.claude/settings.json に追加する

## Subagent

- 複数ファイルにまたがる調査・探索は subagent に任せてメインの context を温存する。単一ファイル・単一検索で済むものは直接行う
