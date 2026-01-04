# Modern CLI tool functions

# -----------------------------------------------------------------------------
# dust (disk usage)
# -----------------------------------------------------------------------------

# duf: dustでディレクトリを選択して詳細表示
function duf() {
  local dir
  dir=$(find . -maxdepth 3 -type d 2>/dev/null | fzf --preview 'dust -d 1 {}')
  if [[ -n "$dir" ]]; then
    dust "$dir"
  fi
}

# -----------------------------------------------------------------------------
# hyperfine (benchmark)
# -----------------------------------------------------------------------------

# bench: 2つのコマンドをベンチマーク比較
function bench() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: bench 'command1' 'command2' [options]"
    echo "Example: bench 'fd . -e js' 'find . -name \"*.js\"'"
    return 1
  fi
  hyperfine --warmup 3 "$@"
}

# bench-export: ベンチマーク結果をMarkdownで出力
function bench-export() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: bench-export 'command1' 'command2'"
    return 1
  fi
  hyperfine --warmup 3 --export-markdown benchmark.md "$@"
  echo "Results saved to benchmark.md"
  bat benchmark.md
}

# -----------------------------------------------------------------------------
# sd (search & replace)
# -----------------------------------------------------------------------------

# sdr: ファイル内の文字列を再帰的に置換（dry-run付き）
function sdr() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: sdr 'old' 'new' [file_pattern]"
    echo "Example: sdr 'foo' 'bar' '*.js'"
    return 1
  fi
  local old="$1"
  local new="$2"
  local pattern="${3:-*}"

  echo "Preview (first 10 files):"
  rg -l "$old" --glob "$pattern" | head -10 | while read -r file; do
    echo "--- $file ---"
    sd "$old" "$new" "$file" --preview 2>/dev/null || cat "$file" | sd "$old" "$new"
  done

  echo ""
  echo "Apply changes? (y/n)"
  read -r answer
  if [[ "$answer" == "y" ]]; then
    rg -l "$old" --glob "$pattern" | xargs -I {} sd -i "$old" "$new" {}
    echo "Done!"
  fi
}

# -----------------------------------------------------------------------------
# xh (HTTP client)
# -----------------------------------------------------------------------------

# GET/POST/PUT/DELETE shortcuts
alias GET='xh GET'
alias POST='xh POST'
alias PUT='xh PUT'
alias DELETE='xh DELETE'

# xj: JSON形式でPOST
function xj() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: xj URL key=value ..."
    echo "Example: xj httpbin.org/post name=test"
    return 1
  fi
  xh POST "$@"
}

# -----------------------------------------------------------------------------
# gitui
# -----------------------------------------------------------------------------

alias gu='gitui'

# -----------------------------------------------------------------------------
# bottom
# -----------------------------------------------------------------------------

alias btm='btm --theme gruvbox'

# -----------------------------------------------------------------------------
# topgrade
# -----------------------------------------------------------------------------

alias tg='topgrade'
