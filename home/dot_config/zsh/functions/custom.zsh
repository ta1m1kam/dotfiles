# Custom functions

function yo() {
  local model_flag=""
  if [ -n "$CLAUDE_CODE_MODEL" ]; then
    model_flag="--model $CLAUDE_CODE_MODEL"
  fi
  local cmd="claude --add-dir=$HOME/workspace/layerx/memo-tiger/obsidian $model_flag $@"
  echo "$cmd"
  eval "$cmd"
}

function oo() {
  cd "$HOME/workspace/layerx/memo-tiger/obsidian"
}
