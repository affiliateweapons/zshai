
fzf_bindkey() {
  export FZF_DEFAULT_OPTS="$FZF_THEME_OPTS$(cat <<EOF
  --query="'"
  -e
  --prompt="CTRL"
  --preview="zshai_env echo  234234 \$functions_source[{2}] "
EOF
)"
  local choice="$(bindkey | fzf)"
  widget="${choice#* }"
  [[ ! -z $choice ]] && {
    zle && { zshai-zle accept-line }
    echo $choice
    echo $widget
    #edit_function $widget
  }
  unset FZF_DEFAULT_OPTS
}

new_bindkey() {
local skel="$(cat<<EOF
zle -N .function-name
zshai_bindkey '^[u' .functiona-name
EOF
)"
  echo $skel
}

zshai_bindkey() {
  #ZSHAI_DEBUG_LOG_BINDKEY_SETUP=1
  [[ ! -z $ZSHAI_DEBUG_LOG_BINDKEY_SETUP ]] && zshai_log bindkey "Setting bindkey: $1"
  ([[ -z $1 ]] || [[ -z $2 ]]) && {
    echo "Usage: zshai_bindkey [keycode] [function]"
    return
  }
  #	bindkey "$1" "$2"
  bindkey $1 $2
}
alias bk="fzf_bindkey"


find_bindkey() {
  # [[ $ZSH_VERSION ]] && read  -krE 
  #   print '\n'
  # return
  #bindkey | grep "\^\[?"
  echo "Find bindkey using REPL/hex"
  zle -I
  echo -n "Type a key: "

  local keys=$(read  -E < /dev/tty )
  
  #read -rE < /dev/tty 
  #echo 1
  #echo $REPLY | hex > /tmp/key.txt
  #key=$REPLY"\n"
  #print '\n'
  #echo "$REPLY" > /tmp/reply.txt

  :info "REPLY | hex = " $(cat /tmp/key.txt)
  :info "REPLY  = " $(cat /tmp/reply.txt)
  
}
zle -N find_bindkey
zshai_bindkey '^[^K' find_bindkey

# this one also executes the bindkeys
zle -N fzf-bindkey
zshai_bindkey '^[ek' .fzf_bindkey

.edit-commander() {
  edit-commander
}

zle -N .edit-commander
zshai_bindkey '^[u' .edit-commander


zle -N .edit-commander
zshai_bindkey '^[?' .edit-commander

/k() {
sed -n l
}

read_bindkey() {
  local key="$(
  [[ $ZSH_VERSION ]] && read  -krE 
     print '\n'
  )"

  #printf '%q' $(echo $(echo $key | base64) | base64 -d)
  echo "$key" > test2\
  #other method
}
sed_readkey() {
  local keycode=$(sed -n l)
  echo "keycode=$keycode"
}

#CTRL_ALT='^[^'
.backward-delete-char-clear-screen() {
  [[ -z "$BUFFER" ]] && {
    zle clear-screen
    zle reset-prompt
  } || {
    zle backward-delete-char
  }
}

#zle -N  .backward-delete-char-clear-screen
#bindkey '^[H' .backward-delete-char-clear-screen
#bindkey $CTRL_ALT'H' clear-screen

zshai-bindkey-show-code() {
 LBUFFER="showkey -a"
 zle .accept-line
 return 0
}

.bindkey() {
builtins 'bindkey'
}
bindkey_list() {
  bindkey | column -x
}
