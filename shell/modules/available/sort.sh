# sort a file from a to z
sortaz() {
  OUT="$(mktemp)"
  cat $1 | sort > $OUT
  cp $OUT $1
  rm $OUT
  cat $1
}

functions_sort() {
  grep -shoEr "function .?*\(" 
}

cutsort() {
  local start="${1:-1}"
  local end="${2:-2}"
  [[ -z "$2" ]] && {
    opts="$start"
  } || {
    opts="$start-$end"
  }
  cat /dev/stdin | cut -c$opts | sort -h  | uniq -c | sort
}
zshai_alias "csort=cutsort"
