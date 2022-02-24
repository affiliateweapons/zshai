remove_quotes() {
  cat /dev/stdin | sed 's/"//g'
}

remove_single_quotes() {
  cat /dev/stdin | sed "s/'//g"
}

remove_all_quotes() {
  cat /dev/stdin | sed "s/'//g" | sed 's/"//g'
}

surround_keys_brackets() {
  sed 's,\(.*\)=,[\1]=,'
}

remove_ansi() {
  sed 's/\[^[[0-9;]*[a-zA-Z]//gi'
}

trim() {
  sed 's/  */ /g'
}

extract_domain() {
  sed -e 's/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/'
}
