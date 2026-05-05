#!/bin/zsh
# launchd で 4 時間毎に実行される @tom_doerr X 収集バッチ
# 詳細プロンプトは scheduler_prompt.md
set -u

export HOME="${HOME:-/Users/$(id -un)}"
export AQUA_GLOBAL_CONFIG="$HOME/.config/aqua/aqua.yaml"

AQUA_NODE_DIR="$HOME/.local/share/aquaproj-aqua/pkgs/http/nodejs.org/dist/v22.11.0/node-v22.11.0-darwin-arm64.tar.gz/node-v22.11.0-darwin-arm64/bin"
AQUA_BIN="$HOME/.local/share/aquaproj-aqua/bin"
export PATH="$AQUA_NODE_DIR:$AQUA_BIN:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

SCRIPT_DIR="$HOME/.claude/schedules/tom-doerr-url-to-x-post"
STATE_DIR="$HOME/.local/state/claude-schedules/tom-doerr-url-to-x-post"
LOG_DIR="$HOME/.claude/logs"
LOG="$LOG_DIR/tom-doerr-url-to-x-post.log"
TIMEOUT=1800

mkdir -p "$STATE_DIR" "$LOG_DIR"

cd "$SCRIPT_DIR"

# scheduler_prompt.md には STATE_DIR/processed_urls.txt のフルパスを書いてある
claude -p "$(cat scheduler_prompt.md)" --dangerously-skip-permissions \
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
