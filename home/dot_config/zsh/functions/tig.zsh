# tig + fzf functions

function tb() {
  local file
  file=$(fzf --preview 'bat --color=always --style=numbers --line-range :500 {}')
  if [[ -n "$file" ]]; then
    tig blame "$file"
  fi
}

function tl() {
  local file
  file=$(fzf --preview 'bat --color=always --style=numbers --line-range :500 {}')
  if [[ -n "$file" ]]; then
    tig log "$file"
  fi
}

function ts() {
  tig stash
}

function tr() {
  tig refs
}
