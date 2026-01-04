# ghq + fzf functions

function grepo() {
  local dir
  dir=$(ghq list -p | fzf --preview 'bat --color=always --style=header,grid --line-range :80 {}/README.md 2>/dev/null || ls -la {}')
  if [[ -n "$dir" ]]; then
    cd "$dir"
  fi
}

function repo-browse() {
  local repo
  repo=$(ghq list | fzf --preview 'ghq list -p | grep {} | xargs ls -la')
  if [[ -n "$repo" ]]; then
    gh browse -R "$repo"
  fi
}

function get() {
  ghq get "$1" && grepo
}
