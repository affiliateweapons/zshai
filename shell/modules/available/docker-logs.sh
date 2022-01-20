docker-logs() {
  local container="${1:-$CURRENT_CONTAINER_ID}"
  [[ -z "$container" ]] && {
    container="$(select_container)"
  }
  tailc  /var/lib/docker/containers/$CURRENT_CONTAINER_ID-json.log
}

select_container() {
  local select="$(docker container ls -a --no-trunc | fzf )"
  echo "select"
}
set_current_container() {
  export CURRENT_CONTAINER_ID="$1"
}
