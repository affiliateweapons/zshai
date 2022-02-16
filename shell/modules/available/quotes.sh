remove_quotes() {

  local f="$1"

  [[ -f "$1" ]] && {
    echho "opening file"
    cat "$1" | sed 's/"//g'
  } || {
    cat /dev/stdin  | command 'grep' -E '"(.*)"' -o | sed 's/"//g'
  }

}
escape_quotes() {

  local f="$1"

  [[ -f "$1" ]] && {
    local input=$(cat "$1")
  } || {
    local input=$(cat /dev/stdin)
  }

  echo "$input" | sed 's/"/\\"/g'
}


strings() {
  local method="extract"
  _strings::$method() {
    grep -o '"[^"]\+"'|  sed 's/"//g'  | sort | uniq | sort
  }

  [[ -f "$1" ]] && {
    cat $1  | _strings::$method && return
  }

  _strings::$method
}

quote() {
  grep -E '"(.*)"' -o | sed 's/"//g'
}
