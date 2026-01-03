# zoxide + fzf functions

function zf() {
  local dir
  dir=$(zoxide query --list | fzf \
    --preview 'ls -la --color=always {}' \
    --preview-window 'right:50%')
  if [[ -n "$dir" ]]; then
    cd "$dir"
  fi
}

function zrm() {
  local dirs
  dirs=$(zoxide query --list | fzf -m --preview 'ls -la {}')
  if [[ -n "$dirs" ]]; then
    echo "$dirs" | while read -r dir; do
      zoxide remove "$dir"
      echo "Removed: $dir"
    done
  fi
}

function zs() {
  zoxide query --list --score | fzf \
    --preview 'echo {} | awk "{print \$NF}" | xargs ls -la --color=always' \
    --preview-window 'right:50%'
}

function zcd() {
  local dir
  dir=$(zoxide query --list | fzf --preview 'ls -la --color=always {}')
  if [[ -n "$dir" ]]; then
    cd "$dir"
    echo "Recent commands in this directory:"
    atuin search --cwd "$dir" --cmd-only --limit 5 2>/dev/null || echo "(no history)"
  fi
}
