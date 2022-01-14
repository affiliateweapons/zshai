jqa() {
  local key="$1"
  local val="$2"
  [[ '{' = $val[1] ]] &&  [[ '}' = $val[-1] ]] && {
    jq ".$key += $val"
  } || {
  jq ".$key += {$val: \"$3\"}"
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
