fzf_bindkey() {
  export FZF_DEFAULT_OPTS="$FZF_THEME_OPTS$(cat <<EOF
  --preview="$INIT;echo {2}; {2}"
EOF
)"
  bindkey | fzf
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
  ([[ -z $1 ]] || [[ -z $2 ]]) && {
    echo "Usage: zshai_bindkey [keycode] [function]"
    return
  }

  #	bindkey "$1" "$2"
	[[ ! -z $ZSHAI_DEBUG_LOG_BINDKEY_SETUP ]] && zshai_log bindkey "Setting bindkey: $1"
  bindkey $1 $2
}
alias bk="fzf_bindkey"


find_bindkey() {
  #bindkey | grep "\^\[?" 
  echo "find bindkey"
  a=$(cat -n)

}
zle -N find_bindkey
zshai_bindkey '^[^K' find_bindkey

zle -N fzf-bindkey
zshai_bindkey '^[ek' .fzf_bindkey


.edit-commander() {
  edit-commander
}

zle -N .edit-commander
zshai_bindkey '^[u' .edit-commander


zle -N .edit-commander
zshai_bindkey '^[?' .edit-commander
