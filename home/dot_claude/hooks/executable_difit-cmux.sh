#!/bin/bash

CMUX="/Applications/cmux.app/Contents/Resources/bin/cmux"
DIFIT="$HOME/.local/share/mise/shims/difit"

[ ! -x "$CMUX" ] && exit 0
[ ! -x "$DIFIT" ] && exit 0
"$CMUX" sidebar-state >/dev/null 2>&1 || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

# セッションごとにランダムなポートを使う（複数セッション対応）
DIFIT_PORT=$((49152 + RANDOM % 16384))

LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/difit-cmux"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/$(basename "$PWD")-$(date -u '+%Y%m%dT%H%M%SZ').log"

currentBranch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
defaultBranch=$(git symbolic-ref refs/remotes/origin/HEAD --short 2>/dev/null)
[ -z "$defaultBranch" ] && git rev-parse --verify origin/main >/dev/null 2>&1 && defaultBranch="origin/main"
[ -z "$defaultBranch" ] && git rev-parse --verify origin/master >/dev/null 2>&1 && defaultBranch="origin/master"

difitArgs=(--mode unified --no-open --clean --include-untracked --port $DIFIT_PORT)

if [ -z "${defaultBranch:-}" ] || [ "$currentBranch" = "${defaultBranch#origin/}" ]; then
  "$DIFIT" working "${difitArgs[@]}" >>"$LOG_FILE" 2>&1 &
else
  mergeBase=$(git merge-base HEAD "$defaultBranch" 2>/dev/null)
  if [ -n "$mergeBase" ]; then
    "$DIFIT" "$mergeBase" . "${difitArgs[@]}" >>"$LOG_FILE" 2>&1 &
  else
    "$DIFIT" working "${difitArgs[@]}" >>"$LOG_FILE" 2>&1 &
  fi
fi

for _ in $(seq 1 20); do
  curl -s "http://localhost:$DIFIT_PORT/" >/dev/null 2>&1 && break
  sleep 0.5
done

if ! curl -s "http://localhost:$DIFIT_PORT/" >/dev/null 2>&1; then
  lsof -ti:$DIFIT_PORT | xargs kill 2>/dev/null || true
  exit 1
fi

"$CMUX" browser open-split "http://localhost:$DIFIT_PORT/" >>"$LOG_FILE" 2>&1

exit 0
