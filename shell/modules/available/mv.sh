
# move all files in current directory to a folder within that directory
mvd() {
  local dir="$1"
  [[ -z "$dir" ]] && echo "Usage: mv [target-folder]" && return
  # create target folder if it does't exist
  [[ -f "$dir" ]] && echo "There is already a file named $dir" && return

  [[ ! -d  "$dir" ]] && mkdir -p  "$dir"

  # only files , not dirs
  $commands[find] * -maxdepth 0 -mindepth 0  ! -name "$dir" -type f -exec mv -t "$dir" {}  +
}

# move files by extension within that directory
# for each extension there will be created a folder
mvext() {
  local workdir="${1:-$PWD}"
  for i in $('ls' -1p | grep -v '/');{

    ext=${i:e:l};
    [[ ! -d "$workdir/$ext" ]] && mkdir -p "$workdir/$ext" && echo "created dir $workdir/$ext" && mv $i "$workdir/$ext"
  }
}
