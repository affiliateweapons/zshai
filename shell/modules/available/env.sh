get_val() {
  local q=$1
  echo ${q/*=/}
}
