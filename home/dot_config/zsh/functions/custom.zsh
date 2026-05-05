# Custom functions

# Obsidian vault directory (set OBSIDIAN_VAULT_DIR in your local env)
: "${OBSIDIAN_VAULT_DIR:=$HOME/Documents/obsidian}"

function yo() {
  local model_flag=""
  if [ -n "$CLAUDE_CODE_MODEL" ]; then
    model_flag="--model $CLAUDE_CODE_MODEL"
  fi
  local cmd="claude --add-dir=$OBSIDIAN_VAULT_DIR $model_flag $@"
  echo "$cmd"
  eval "$cmd"
}

function oo() {
  cd "$OBSIDIAN_VAULT_DIR"
}
