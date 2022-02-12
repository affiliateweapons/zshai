undo-command() {
  [[ -z "$1" ]] && { [[ -z "$UNDO_COMMAND" ]] && echo "No undo command in buffer" }  || {
    echo "$UNDO_COMMAND";
    echo "-"
    local answer="y"
    vared -p "Confirm undo? y/n " answer
    [[ ! "$answer" = "y" ]] && echo "Aborted" || { eval "$UNDO_COMMAND"; unset UNDO_COMMAND }

  } || {
    export UNDO_COMMAND="$1"
  }
}
zshai_alias 'undo="undo-command"'

.undo-command() {
  undo-command
  zle accept-line
}

zle -N .undo-command
bindkey '^Z' .undo-command
