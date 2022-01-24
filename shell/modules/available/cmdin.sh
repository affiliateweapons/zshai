cmdin() {
  local dir="$1"
  shift
  local curdir="$(pwd)"


  cd $dir
  $@

  cd $curdir

}
