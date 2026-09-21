#!/bin/bash

PORT=4649

# Count Claude Code processes (the current session that triggered Stop is still running)
SESSIONS=$(pgrep -x claude 2>/dev/null | wc -l | tr -d ' ')

if [ "$SESSIONS" -le 1 ]; then
  PID=$(lsof -Pi :"$PORT" -sTCP:LISTEN -t 2>/dev/null)
  if [ -n "$PID" ]; then
    kill "$PID" 2>/dev/null
    echo "Stopped dev server on port $PORT"
  else
    echo "Dev server not running on port $PORT"
  fi
else
  echo "Other Claude Code sessions still active ($SESSIONS), keeping dev server"
fi
