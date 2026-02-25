#!/bin/bash
INPUT=$(cat)
PROJECT=$(echo "$INPUT" | jq -r '.cwd' | xargs basename)
osascript -e "display notification \"👋 確認\" with title \"Claude Code: ${PROJECT}\" sound name \"Ping\""
exit 0
