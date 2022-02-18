#!/usr/bin/env zsh
typeset -g ZSHAI="${HOME}/zshai" 
typeset -g ZSHAI_DATA="${HOME}/.zshai"
typeset -g LS_CMD="$commands[ls]"
typeset -Ag ZSHAI_DIRS=()

typeset -ag enabled=()


enable_colors() {
setup_colors() {
  typeset -g RESET="\u001b[0m"
  typeset -a colors=(
    BLACK
    RED
    GREEN
    YELLOW
    BLUE
    MAGENTA
    CYAN
  )

  for i in {1..7}
  do
    (( c=i-1 ))
    export BB_${colors[$i]}="\u001b[4$c;1m" 
    export BG_${colors[$i]}="\u001b[4$c""m" 
    export B_${colors[$i]}="\u001b[3$c;1m" 
    export ${colors[$i]}="\u001b[3$c""m"

    eval  "B_${colors[$i]}() {"'echo "\u001b[3'$c';1m"$1"'"$RESET"'"}'
    eval  "_${colors[$i]}() {"'echo "\u001b[3'$c'm"$1"'"$RESET"'"}'
    eval  "BG_${colors[$i]}() {"'echo "\u001b[4'$c'm"$1"'"$RESET"'"}'
    eval  "BB_${colors[$i]}() {"'echo "\u001b[4'$c';1m"$1"'"$RESET"'"}'
  done
  ZSHAI_ENABLED+=( colors )
}

(( ! ZSHAI_ENABLED[(I)colors] ))&& setup_colors

}
zdir() {
  local q="${1:-BASE}"
  ZSHAI_DIRS=(
    [base]="$ZSHAI"
    [user]="$ZSHAI_DATA"
    [shell]="$ZSHAI/shell"
    [plugins]="$ZSHAI/plugins"
    [modules]="$ZSHAI/shell/modules"
    [completion]="$ZSHAI/shell/completion"
    [alias]="$ZSHAI/shell/alias"
  )

  echo "$ZSHAI_DIRS[${q:l}]"
}

enabled=(
"$(d=$(zdir user)/enabled;[[ -f $d ]] && cat $d || touch $d)"
)


# this the entry file that will be sourced by .zshrc
eval $(cat "$ZSHAI/.zshai.env")
typeset -g ZSHAI_LOADED_COMPLETIONS=(doctl)

# load core aliases and functions
'source' "$ZSHAI/core.sh"

# looad local specific aliases
[[ -f "$ZSHAI_DATA/aliases.sh" ]] && 'source' "$ZSHAI_DATA/aliases.sh"

# load completion
((enabled[(I)LOAD_COMPLETION_FUNCTIONS])) && {
  for i in $("$LS_CMD" "$(zdir completion)"); {
    'source' "$(zdir completion)/$i"
  }
}

# load plugins
# first  load the module
load_module plugins
plugins load

# mark loaded
typeset -g ZSHAI_LOAD_COMPLETED=true
