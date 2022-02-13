unescape() {
  local input=${1:-$(cat /dev/stdin)}
  echo $input | sed 's#\\\"#\"#g' | sed 's#\\\\#\\#g'
#  printf '%s\n' "$input" | sed -e 's/\\//g'
}

function flc {
  print -l ${(k)functions} | wc -l
}

fl() {
  local CLS="fl"
  local list="$(print -l ${(k)functions} | sort)"
  [[ ! -z  "$1" ]] && echo "$list" | grep "$1" \
  || echo "$list"

  fl::list() {

  }

  case $1 in
  "")
    $CLS::list
    ;;
  *)
    [[ $functions[$CLS::$1] ]] && {
      cmd=$1
      shift
      $CLS::$cmd $@
    } || $CLS::list $1
    ;;
  esac
}

what() {

  local q="$1"
  [[ ! -z $aliases[$1] ]] && q="$aliases[$1]" && echo "$1 is aliased to $q"
  echo $functions_source[$q]

  (( $+functions_source[$q] )) && {
    cat $functions_source[$q] | bat -l zsh --style=numbers --color=always 
  } || {

    [[ -z $2 ]]  && {
      which $q
    }

  }
}

fs() {
  local q="$1"
  [[ -z $functions[$1] ]] && {
    echo "There is no function named $RED$1$RESET"
    echo "Did you mean:"
    fl $1
  }
  [[ "$2" = "raw" ]] && {
    echo $functions[$1]
  } || {
    echo $functions[$1] | batcat -l zsh
  }
}

copy_source() {
  fs $@ | xclip -selection c
}
zshai_alias 'cs="copy_source"'

fsline() {
  grep --color=always -Pzo -rn '(?s)edit_function\(.*?{.*?}\n' $ZSHAI_MODULES_DIR/available/*.sh
}

edit_function() {
  local last="$(last-value function)"
  local q="${1:-$last}"

  #fis -E "#'PS2.*?#"
  [[ -z "$q" ]] && fl && return
  [[ ! -z "$aliases[$q]" ]] && q="$aliases[$q]"
  local file=$(what $q | head -1)

  [[ ! -d "${file:h}" ]] && echo "${file:h} folder does not exist anymore" && return

  lineno="${$(grep -Fn "$q() {" $file)//:*}"
  (( lineno++ ))
  nano +$lineno $file
  LAST_FUNCTION=$(last-value "function" "$q")
  LAST_FILE=$(last-value "file" "$file")
  source $file
  prompt-info "Sourced" "$file"
}

zshai_alias 'ef="edit_function"'

search_in_functions() {
  local keyword=${1:-print}
  export INIT="source ~/.zshrc;source $ZSHAI/shell/modules/available/functions.sh"
  # check if query is a function

  do_search() {
    [[ ! -z $functions[$keyword] ]] && {
      grep -rnw "$keyword()" $functions_source
    } || {
      grep -rnw "$keyword" $functions_source
    }
  }
   # do_search $keyword

  #RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  RG_PREFIX="$INIT;do_search"
    INITIAL_QUERY="$keyword"
  FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \
  fzf --bind "change:reload:$RG_PREFIX {q} || true" \
  --ansi \
  --disabled --query "$INITIAL_QUERY" \
  --bind '?:preview:cat {}' --preview-window hidden
}


# check if query is a function
do_search() {
local keyword=${1:-print}

  [[ ! -z $functions[$keyword] ]] && {
    command grep --color=always -rnw "$keyword()" $functions_source
  } || {
    command grep --color=always -rnw "$keyword" $functions_source
  }
}

list_function_sources() {
  echo "$(for i in ${(k)functions};echo $i)" | sort > $ZSHAI_DATA/functions/list  
}

export_function_source() {
    grep -shoEr "function .?*\("
}

find_in_source() {
  functions | grep -r -I  --color=always $@
}

zshai_alias 'fis="find_in_source"'


find_functions() {
  # finds functions in source files within CWD
  grep -Po '(?s)[a-bz].*?\(\) {'  -orn | sed 's,:, ,g' | sed 's,() {,,g'  | sort | uniq -c | sort -h
}

find_function_line() {
  local q="$1"
#grep -rnw $q'() {' 
#  grep -Pzo -rn '(?s)'$q'\(.*?{.*?}\n' **/*.sh
}


find_zle_functions() {

  [[ "$1" = "raw" ]] && nocolor="--color=never" && shift
  [[ "$1" = "-h" ]] && echo "Usage: find_zle_functions [., /usr/share/zsh]" &&  return
  local dir="${1:-$ZSHAI}"
  cd $dir
  [[ -z "$1" ]] && {
    result="$(fis '[^"a-z{]zle [^\n&][. a-zA-N#-]*' -o $nocolor)"
    print -l $result
  } || {
    result="$(fis '[^"a-z{]zle [^\n&][. a-zA-N#-]*' -o $nocolorr)"
    print -l $result | sed 's/.*[ :\#]//g' | sort  | uniq -c | sort -h
  }
}
