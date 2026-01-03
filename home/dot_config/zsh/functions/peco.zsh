# peco functions

function peco-kill() {
  local pid
  pid=$(ps aux | peco | awk '{print $2}')
  if [[ -n "$pid" ]]; then
    echo "Killing process $pid"
    kill "$pid"
  fi
}

function peco-ip() {
  ifconfig | grep 'inet ' | peco | awk '{print $2}'
}
