jqa() {
  local key="$1"
  local val="\"$2\""
  local hash="\"$3\""
  local curdate="$(date +'%y%M%d')"
  [[ '{' = $val[1] ]] &&  [[ '}' = $val[-1] ]] && {
    jq ".$key += $val"
  } || {
  jq ".$key += {date: $curdate, hash: $hash, result: $val}"
  }
}

jqr() {
  jq -r $@
}

jq-paths() {

  export JQ_OPTS=$(cat <<EOF
  [
    path(..) | map(select(type == "string") // "[]")
    | join(".")
  ] | sort | unique | .[] | split(".[]") | join("[]") | "." + .
EOF
)

  cat /dev/stdin | jq -r  "$JQ_OPTS"
  unset JQ_OPTS
}
