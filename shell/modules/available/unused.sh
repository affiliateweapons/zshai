# move unused files
unused() {
  local folder=~/unused
  # create folder to dump unused files
  [[ ! -d "$folder" ]] && mkdir "$folder"
  [[ -e "$1" ]] && {
    mv "$1" "$folder" 
    echo "$1 moved to $folder"
  } || {
    echo "$1 does not exist"
  }
}
