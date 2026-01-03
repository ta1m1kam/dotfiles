# just functions

# jf: Justfileのレシピをfzfで選択して実行
function jf() {
  if [[ ! -f "Justfile" && ! -f "justfile" ]]; then
    echo "Justfile not found"
    return 1
  fi
  local recipe
  recipe=$(just --list --unsorted 2>/dev/null | tail -n +2 | \
    fzf --preview 'just --show {1}' | \
    awk '{print $1}')
  if [[ -n "$recipe" ]]; then
    echo "Running: just $recipe"
    just "$recipe"
  fi
}

# je: Justfileのレシピを編集
function je() {
  if [[ -f "Justfile" ]]; then
    vim Justfile
  elif [[ -f "justfile" ]]; then
    vim justfile
  else
    echo "Justfile not found. Create one? (y/n)"
    read -r answer
    if [[ "$answer" == "y" ]]; then
      vim Justfile
    fi
  fi
}
