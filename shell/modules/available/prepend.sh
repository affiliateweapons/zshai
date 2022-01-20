prepend() {

  local text=( $(cat /dev/stdin) )
  local prepend="$1"
  local prepend_text="$1"

  for i in $(seq $#text)
  do
    [[ "$prepend" = "numbered" ]] &&  {
      prepend_text="$i " || prepend_text="$prepend"
    }
    [[ "$prepend" = "linecount" ]] &&  {
      prepend_text="$(a=$text[$i];cat  ${a/*\ } | wc -l) " || prepend_text="$prepend"
    }

    echo $prepend_text"$text[$i]"
  done
}
prepend_dashes() {
  local input="$1"
  [[ -z "$input" ]] && {
    input="$(cat /dev/stdin)"
  }
  array=( $(echo $input) )

  print -lr -- -\ ${^input}
}
