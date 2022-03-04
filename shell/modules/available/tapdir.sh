THIS_FOLDER_IS_EMPTY="This folder is empty"

zshai-zle() {
  zle $1
  RP1="$1"
  RPROMPT=$RP1
}

zshai-accept-line() {
#  zshai-zle accept-line
#  zle redisplay
  zshai-zle-end
}

zshai-zle-end() {
  echo $'\n'
  prompt=$ZSHAI_PROMPT
  zle reset-prompt
}

.zshai-dirlevel-arrow-up() {
  [[ -z $BUFFER ]] && {

  zle reset-prompt
  return
  } || {
    [[ "$KEYS" =  '-' ]] && {
      #LBUFFER="$LBUFFER$KEYS" RBUFFER="$RBUFFER"
    }
  }
}


.zshai-dirlevel-up() {
  [[ -z $BUFFER ]] && {
   # eval $zle_pre
  # widget_output="$(dirlevel up)"
  # zle-output-prompt "$widget_output"
  #SAVEPROMPT=$PROMPT PROMPT=$'\n\n'
   #echo "${$(zshai-prompt dirlisting): :-3}"

   cd ..
   zshai-prompt dirlisting
   zshai-accept-line

  } || {
    [[ "$KEYS" = '`' ]] && {
      LBUFFER="$LBUFFER$KEYS" RBUFFER="$RBUFFER"
    }
  }

}

# widget that allows to enter a folder by pressing the num keys 0-9
.zshai-dirlevel-enter() {
  [[  -z $BUFFER ]] && {
    export TAPKEY="$KEYS"
    export INDICATOR_STATUS="-"

    [[ -z $EMPTY_DIR ]]&& {
      local ls="$(zshai-prompt cdls $KEYS)"
      [[ ! -z "$ls" ]] && {
        zshai-prompt cdls $KEYS
        zshai-accept-line
      } || {
        #  entering empty dir
        zshai-prompt cdls $KEYS no-listing
      }
    } || {
      # trying to enter empty dir
      echo "\n$THIS_FOLDER_IS_EMPTY"
      zshai-accept-line
    }

  } || {
    LBUFFER="$LBUFFER$KEYS" RBUFFER="$RBUFFER"
  }
}

