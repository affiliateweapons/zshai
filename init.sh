#!/usr/bin/env zsh
typeset -g ZSHAI="${HOME}/zshai" 
typeset -g ZSHAI_DATA="${HOME}/.zshai"
typeset -g LS_CMD="$commands[ls]"
typeset -Ag ZSHAI_DIRS=()

typeset -ag enabled=()


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
"$(cat $(zdir user)/enabled)"
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
