# ghq + roots + fzf functions

# ghq list --full-path | roots | fzf → cd
# モノレポのサブパッケージにも直接移動できる
function grepo() {
  local dir
  dir=$({ ghq list --full-path | roots; gwq list -g 2>/dev/null } | sort -u | \
    fzf --height 40% \
        --preview 'bat --color=always --style=header,grid --line-range :80 {}/README.md 2>/dev/null || ls -la {}')
  [[ -n "$dir" ]] && cd "$dir"
}

function repo-browse() {
  local r
  r=$(ghq list | fzf --preview 'ghq list -p | grep {} | xargs ls -la')
  if [[ -n "$r" ]]; then
    gh browse -R "$r"
  fi
}

function get() {
  ghq get "$1" && grepo
}
