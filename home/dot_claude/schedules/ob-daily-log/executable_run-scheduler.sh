#!/bin/zsh
# launchd で毎日 23:55 JST に実行される ob-daily-log スケジューラ
set -u

export HOME="${HOME:-/Users/$(id -un)}"
export AQUA_GLOBAL_CONFIG="$HOME/.config/aqua/aqua.yaml"

AQUA_NODE_DIR="$HOME/.local/share/aquaproj-aqua/pkgs/http/nodejs.org/dist/v22.11.0/node-v22.11.0-darwin-arm64.tar.gz/node-v22.11.0-darwin-arm64/bin"
AQUA_BIN="$HOME/.local/share/aquaproj-aqua/bin"
export PATH="$AQUA_NODE_DIR:$AQUA_BIN:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

LOG_DIR="$HOME/.claude/logs"
LOG="$LOG_DIR/ob-daily-log.log"
TIMEOUT=1800

mkdir -p "$LOG_DIR"

# Records vault は当日 (JST) 分を生成。skill 側で日付は date +%Y-%m-%d を使う
claude -p "/ob-daily-log を実行して、今日の日誌を Obsidian Records vault に作成してください" \
  --dangerously-skip-permissions \
  >> "$LOG" 2>&1 &
CLAUDE_PID=$!

(
  sleep $TIMEOUT
  if kill -0 $CLAUDE_PID 2>/dev/null; then
    echo "[$(date)] TIMEOUT: process $CLAUDE_PID exceeded ${TIMEOUT}s, killing" >> "$LOG"
    kill $CLAUDE_PID 2>/dev/null
    sleep 5
    kill -9 $CLAUDE_PID 2>/dev/null
  fi
) &
WATCHDOG_PID=$!

wait $CLAUDE_PID 2>/dev/null
kill $WATCHDOG_PID 2>/dev/null
wait $WATCHDOG_PID 2>/dev/null
