#!/bin/bash
INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ "$FILE" == *.md ]]; then
  /opt/homebrew/bin/mo "$FILE" 2>/dev/null &
fi

exit 0
