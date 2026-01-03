# atuin + fzf functions

function hd() {
  local cmd
  cmd=$(atuin search --cwd "$(pwd)" --cmd-only --limit 50 | fzf)
  if [[ -n "$cmd" ]]; then
    print -z "$cmd"
  fi
}

function hs() {
  local cmd
  cmd=$(atuin search --exit 0 --cmd-only --limit 50 | fzf)
  if [[ -n "$cmd" ]]; then
    print -z "$cmd"
  fi
}

function hstats() {
  atuin stats
}
