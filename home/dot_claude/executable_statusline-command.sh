#!/bin/bash

input=$(cat)

# --- Monster ---
MONSTER_PATH="$HOME/ghq/github.com/ta1m1kam/claude-code-monster"
monster_info=$(echo "$input" | bun run "$MONSTER_PATH/packages/cli/src/index.ts" 2>/dev/null || echo "")

# --- Colors ---
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
CYAN='\033[38;5;87m'
GREEN='\033[38;5;114m'
YELLOW='\033[38;5;221m'
RED='\033[38;5;203m'
MAGENTA='\033[38;5;183m'
BLUE='\033[38;5;111m'
WHITE='\033[38;5;252m'

# --- Parse JSON ---
model=$(echo "$input" | jq -r '.model.display_name // "?"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // "?"')
pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
exceeds_200k=$(echo "$input" | jq -r '.exceeds_200k_tokens // false')

# --- Directory (shorten home) ---
cwd_display=$(echo "$cwd" | sed "s|^$HOME|~|")

# --- Git info (cached for performance) ---
CACHE_FILE="/tmp/claude-statusline-git-cache"
CACHE_MAX_AGE=5

cache_is_stale() {
  [ ! -f "$CACHE_FILE" ] || \
  [ $(($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0))) -gt $CACHE_MAX_AGE ]
}

git_info=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  if cache_is_stale; then
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
    staged=$(git -C "$cwd" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    modified=$(git -C "$cwd" diff --numstat 2>/dev/null | wc -l | tr -d ' ')
    untracked=$(git -C "$cwd" ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
    echo "${branch}|${staged}|${modified}|${untracked}" > "$CACHE_FILE"
  fi
  IFS='|' read -r branch staged modified untracked < "$CACHE_FILE"

  git_status=""
  [ "$staged" -gt 0 ] 2>/dev/null && git_status="${GREEN}+${staged}${RESET}"
  [ "$modified" -gt 0 ] 2>/dev/null && git_status="${git_status} ${YELLOW}~${modified}${RESET}"
  [ "$untracked" -gt 0 ] 2>/dev/null && git_status="${git_status} ${RED}?${untracked}${RESET}"
  [ -z "$git_status" ] && git_status="${GREEN}✓${RESET}"

  git_info=" ${DIM}│${RESET} ${MAGENTA}${branch}${RESET} ${git_status}"
fi

# --- Context bar ---
if [ -n "$pct" ]; then
  pct_int=$(printf "%.0f" "$pct")
  bar_width=10
  filled=$((pct_int * bar_width / 100))
  [ "$filled" -gt "$bar_width" ] && filled=$bar_width
  empty=$((bar_width - filled))

  if [ "$pct_int" -ge 90 ]; then
    bar_color="$RED"
  elif [ "$pct_int" -ge 70 ]; then
    bar_color="$YELLOW"
  else
    bar_color="$GREEN"
  fi

  bar=""
  [ "$filled" -gt 0 ] && bar=$(printf "%${filled}s" | tr ' ' '█')
  [ "$empty" -gt 0 ] && bar="${bar}$(printf "%${empty}s" | tr ' ' '░')"

  ctx_display="${bar_color}${bar}${RESET} ${pct_int}%"
  [ "$exceeds_200k" = "true" ] && ctx_display="${ctx_display} ${RED}⚠200k+${RESET}"
else
  ctx_display="${DIM}░░░░░░░░░░ --%${RESET}"
fi

# --- Context window size label ---
if [ "$ctx_size" -ge 1000000 ]; then
  ctx_label="1M"
elif [ "$ctx_size" -ge 200000 ]; then
  ctx_label="200k"
else
  ctx_label="${ctx_size}"
fi

# --- Cost ---
cost_fmt=$(printf '$%.2f' "$cost")

# --- Duration ---
duration_sec=$((duration_ms / 1000))
mins=$((duration_sec / 60))
secs=$((duration_sec % 60))
if [ "$mins" -ge 60 ]; then
  hours=$((mins / 60))
  mins=$((mins % 60))
  time_display="${hours}h${mins}m"
else
  time_display="${mins}m${secs}s"
fi

# --- Code changes ---
code_changes=""
if [ "$lines_added" -gt 0 ] || [ "$lines_removed" -gt 0 ]; then
  code_changes=" ${DIM}│${RESET} ${GREEN}+${lines_added}${RESET} ${RED}-${lines_removed}${RESET}"
fi

# --- Project-local extension ---
project_extra=""
PROJECT_EXTRA_SCRIPT="${cwd}/.claude/statusline-extra.sh"
if [ -x "$PROJECT_EXTRA_SCRIPT" ]; then
  project_extra=$(echo "$input" | "$PROJECT_EXTRA_SCRIPT" 2>/dev/null || true)
fi

# --- Output (2 lines) ---
# Line 1: Status info
echo -e "${BOLD}${CYAN}◆ ${model}${RESET} ${DIM}│${RESET} ${BLUE}${cwd_display}${RESET}${git_info} ${DIM}│${RESET} ${ctx_display} ${DIM}(${ctx_label})${RESET} ${DIM}│${RESET} ${YELLOW}${cost_fmt}${RESET} ${DIM}│${RESET} ${WHITE}${time_display}${RESET}${code_changes}${project_extra}"
# Line 2: Monster
if [ -n "$monster_info" ]; then
  echo -e "${monster_info}"
fi
