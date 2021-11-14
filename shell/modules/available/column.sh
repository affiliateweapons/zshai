
clm() {
  local input
  local column="${1}"


  [[ -f $PWD/$1 ]] && {
    input="$(cat $PWD/$1)"
    echo ${input} |  sed 's/\s.*//g'
  } || {
    input="$(cat /dev/stdin)"
    [[ -z $column ]] && {
      echo ${input} | sed 's/\s.*//g'
    }
  }

}
