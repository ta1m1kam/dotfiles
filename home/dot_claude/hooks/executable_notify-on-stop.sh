#!/bin/bash
INPUT=$(cat)
PROJECT=$(echo "$INPUT" | jq -r '.cwd' | xargs basename)
osascript -e "display notification \"✅ 完了\" with title \"Claude Code: ${PROJECT}\" sound name \"Glass\""
exit 0
