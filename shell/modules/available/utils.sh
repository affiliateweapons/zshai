strip_ansi() {
  cat /dev/stdin | sed 's/\x1b\[[0-9;]*m//g' 
}
remove_newlines() {
  cat /dev/stdin | tr -d '\n'
}
