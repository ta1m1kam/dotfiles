# procs functions

# pk: procsでプロセスを選択してkill
function pk() {
  local pid
  pid=$(procs --no-header | fzf --preview 'echo {}' | awk '{print $1}')
  if [[ -n "$pid" ]]; then
    echo "Killing PID: $pid"
    kill "${1:--15}" "$pid"
  fi
}

# pk9: procsでプロセスを選択してkill -9
function pk9() {
  pk -9
}

# pw: procsでプロセスをwatch
function pw() {
  procs --watch --interval 1000 "$@"
}

# pt: procsでツリー表示
function pt() {
  procs --tree "$@"
}
