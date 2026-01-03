# Docker functions

function dex() {
  local container
  container=$(docker ps --format "{{.Names}}" | peco)
  if [[ -n "$container" ]]; then
    docker exec -it "$container" "${1:-sh}"
  fi
}

function drmi() {
  local images
  images=$(docker images | tail -n +2 | peco | awk '{print $3}')
  if [[ -n "$images" ]]; then
    echo "$images" | xargs docker rmi
  fi
}
