.zshai-dirlevel-previous() {
  dirlevel "previous"
  zle-end
}

.zshai-dirlevel-next() {
  dirlevel "next"
  zle-end
}

dirlevel() {
  local direction="${1:-'previous'}"
  export CUR_DIR="${$(pwd):t}"
  leveldirs=( $('ls' -1 ../ -p | grep "/" | sed 's/\///g' ) )

  local current_index=$leveldirs[(i)$CUR_DIR*]
  [[ "$direction" == "previous" ]] && {
    [[ "$current_index" -le 1 ]] && {
      change_dir=$leveldirs[-1]
    } || {
      change_dir=$leveldirs[$current_index-1]
    }
  } || {
    [[ "$current_index" -ge $#leveldirs ]] && {
      change_dir=$leveldirs[1]
    } || {
      change_dir=$leveldirs[$current_index+1]
    }
  }
  cd "../$change_dir"
}

zle -N .zshai-dirlevel-previous
zshai_bindkey '^[[1;3D' .zshai-dirlevel-previous

zle -N .zshai-dirlevel-next
zshai_bindkey '^[[1;3C' .zshai-dirlevel-next
