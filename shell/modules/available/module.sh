:dir() {
  local basedir="$ZSHAI_DATA/$CLS"
  local dir="$basedir/$1"
  [[ ! -d "$dir" ]] && mkdir -p "$dir"
  echo $dir
}


module() {
  CLS="module"
  $CLS::list() {

  }

  $CLS::list-modules() {
    [[ -z "$1" ]] && {
      list=$(command 'ls' -Ap "$ZSHAI_MODULES_DIR/available"  | sed 's/.sh//g'  )
    } || {
      list=$(command 'ls' "$ZSHAI_MODULES_DIR/enabled" | grepc $1 | sed 's/.sh//g')
    }
    echo "$list"
  }

  $CLS::fzf() {
    echo "$($CLS::list-modules)"
  }
  $CLS::find_alias() {
    [[ -z "$1" ]] || [[ "$1" = '*' ]] && {
      curdir=$(pwd)
      cd "$ZSHAI_MODULES_DIR/available"
      grepc -rnT  "alias .*=.*\""
      cd "$curdir"
    } || {
      cat "$ZSHAI_MODULES_DIR/available/$1.sh" | grepc "alias .*=.*\""
    }
  }

  $CLS::init() {
   export ORIGINAL_FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"
  }

  $CLS::clean() {
    local CLS="$1"
    local cmd="$2"
    [[ ! -z "$ORIGINAL_FZF_DEFAULT_OPTS" ]] && {
#      echo "$ORIGINAL_FZF_DEFAULT_OPTS"
      FZF_DEFAULT_OPTS="$ORIGINAL_FZF_DEFAULT_OPTS"
      unset ORIGINAL_FZF_DEFAULT_OPTS
    }
  }

  subcommands $CLS $@
}
alias mfa="module find_alias"
alias rmm="rm_module"
