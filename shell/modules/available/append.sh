append() {

  local text=( $(cat /dev/stdin) )
  local append="$1"
  local append_tex="$1"
  for i in $(seq $#text)
  do
    [[ "$append" = "numbered" ]] &&  {
      append_text=" $i" || append_text="$append"
    }
    [[ "$append" = "linecount" ]] &&  {
      append_text=" $(a=$text[$i];cat  ${a/*\ } | wc -l)" || append_text="$append"
    }
    echo "$text[$i]"$append_text
  done
}
