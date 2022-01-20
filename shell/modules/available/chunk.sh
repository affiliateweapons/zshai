chunk() {
  local start="${1:-1}"
  local limit="${2:-10}"

  cat /dev/stdin | tail -n +$start | head -$limit
}
