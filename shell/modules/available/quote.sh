quote() {
  grep -E '"(.*)"' -o | sed 's/"//g' 
}
