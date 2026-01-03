# fzf + ripgrep functions

function rgf() {
  local file line
  read -r file line <<<"$(rg --line-number --no-heading "$@" | \
    fzf --delimiter ':' \
        --preview 'bat --color=always --highlight-line {2} {1}' \
        --preview-window 'right:60%:+{2}-10' | \
    awk -F: '{print $1, $2}')"
  if [[ -n "$file" ]]; then
    vim "$file" +"$line"
  fi
}

function vf() {
  local file
  file=$(fzf --preview 'bat --color=always --style=numbers --line-range :500 {}')
  if [[ -n "$file" ]]; then
    vim "$file"
  fi
}

function cdf() {
  local dir
  dir=$(find . -type d 2>/dev/null | fzf --preview 'ls -la {}')
  if [[ -n "$dir" ]]; then
    cd "$dir"
  fi
}
