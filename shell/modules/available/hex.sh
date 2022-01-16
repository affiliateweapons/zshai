unhex () {
  local input="$1" 
  [[ -z $input ]] && {
    input=$(cat /dev/stdin) 
  }
  echo "$input" | xxd -r -p
  echo
}

hex() {

  local input="$1" 
  [[ -z $input ]] && {
    input=$(cat /dev/stdin) 
  }

  local hex="0x$(echo "$input" |  od -A n -t x1 | sed 's/ //g')"
  echo $hex
}
hexnr() {
  local options="$2"

  result=$(printf "0x%x\n" $((10#$1)))
  [[ ! -z $options ]] && [[ "$options"="q" ]] && {
   echo "\"$result\""
  } || echo $result
}

dehex32() {
  local input="$1" 
  local convert_cmd="xxd -c 32 -p"
  [[ -z $input ]] && {
    cat /dev/stdin | eval $convert_cmd
  } || {
    [[ -f "$input" ]] && {
      cat "$input" | eval $convert_cmd
    } || {
      echo "$input" | eval $convert_cmd
    }
  }
}


hex2dec() {
  local input="$1"
  [[ -z $input ]] && {
    input=$(cat /dev/stdin)
  }
  input="${input//\"}"

  [[ "$input[1,2]" = "0x" ]] && {
    input=$input[3,-1]
  }
  echo $((16#$input))
}

d2h() {
  echo $(([##16]$1))
}
h2d() {
  hex2dec $@
}
