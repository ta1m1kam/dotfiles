# yazi functions

# yy: yaziを起動し、終了時にそのディレクトリへ移動
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# yz: zoxideの履歴からyaziで開く
function yz() {
  local dir
  dir=$(zoxide query --list | fzf --preview 'ls -la --color=always {}')
  if [[ -n "$dir" ]]; then
    yazi "$dir"
  fi
}

# yg: ghqリポジトリをyaziで開く
function yg() {
  local dir
  dir=$(ghq list -p | fzf --preview 'ls -la {}')
  if [[ -n "$dir" ]]; then
    yazi "$dir"
  fi
}
