# sort a file from a to z
sortaz() {
  OUT="$(mktemp)"
  cat $1 | sort > $OUT
  cp $OUT $1
  rm $OUT
  cat $1
}
