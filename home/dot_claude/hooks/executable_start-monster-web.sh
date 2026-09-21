#!/bin/bash

MONSTER_DIR="$HOME/ghq/github.com/ta1m1kam/claude-code-monster"
PORT=4649

if lsof -Pi :"$PORT" -sTCP:LISTEN -t >/dev/null 2>&1; then
  echo "Next.js dev server already running on port $PORT"
  exit 0
fi

if [ ! -d "$MONSTER_DIR/packages/web" ]; then
  echo "Monster web package not found at $MONSTER_DIR/packages/web"
  exit 1
fi

cd "$MONSTER_DIR/packages/web" || exit 1
nohup npm run dev -- --port "$PORT" > /tmp/claude-monster-dev.log 2>&1 &
disown

echo "Next.js dev server started on http://localhost:$PORT"
