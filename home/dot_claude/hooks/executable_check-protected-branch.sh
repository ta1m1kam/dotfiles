#!/bin/bash
# 保護されたブランチ（main/develop/master）で作業中の場合に警告を出す
# SessionStart hookで実行され、Claudeのコンテキストに追加される

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || exit 0)

case "$BRANCH" in
  main|develop|master)
    cat << EOF
⚠️ 保護されたブランチ '$BRANCH' で作業中です。

worktreeで別ブランチでの作業を推奨します：
  gwta  # 新規worktree作成
  gwt   # 既存worktree選択
EOF
    ;;
esac
