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
