:new() {
  local name="${1:-file}"
  value="${2}"
  vared -p "New $name: " value
}

dirbookmark() {
  CLS="dirbookmark"
  LIST_BASE="$ZSHAI_DATA/list"
  LIST_TYPE="bookmarks"
  LIST_TYPE_BASE="$LIST_BASE/$LIST_TYPE"
  LIST_CURRENT="$LIST_BASE/$LIST_TYPE/.current"
  [[ ! -f "$LIST_CURRENT" ]] && {
    mkdir -p "$LIST_TYPE"
    echo "default" >  "$LIST_CURRENT"
    touch "$LIST_TYPE/default"
    :info "created initial .current file in" "$LIST_CURRENT"
  }

  LIST="$LIST_CURRENT"
  LIST_FILE="$LIST_BASE/$LIST"
#  LIST_DIR="$LIST_BASE/$LIST_TYPE/$LIST_CURRENT"
#--bind "alt-1:execute^echo {1}^+abort"
  ORIGINAL_FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"
  export FZF_DEFAULT_OPTS="$FZF_THEME_OPTS$(cat<<EOF
EOF
)"

  $CLS::set_current() {
    :info "current list" "$LIST_CURRENT"
    :info "set current list to " "$1"
    echo "$1" > "$LIST_CURRENT"

    cat $LIST_TYPE_BASE/$(cat "$LIST_CURRENT")
  }
  $CLS::list() {
    [[ -f "$LIST_FILE" ]] && cat $LIST_FILE | nl
  }

  $CLS::change_list() {
    cd $LIST_TYPE_BASE
    local choice="$(ls | fzf --ansi)"
    [[ -z "$choice" ]] && return
    :info "your choice is" "$choice"
    $CLS::set_current "$choice"
  }

  $CLS::change() {
    $CLS::change_list $@
  }
  zshai_alias 'dbc="$CLS change"'

  $CLS::new() {
   echo "$LIST_TYPE_BASE"
   local current=$(cat $LIST)
   :info "Current bookmark list" "$current"
    local value
    :new bookmark
    [[ -z "$value" ]] && return || {
      cp  "$LIST_TYPE_BASE/$current" "$LIST_TYPE_BASE/$value"
      :info "Succesfully cloned to" "$value"
      echo "$value" > "$LIST_TYPE_BASE/.current"
      ls
    }
    return
  }

  $CLS::add() {
    echo "Choose slot 1-9"
    local key="$(
    [[ $ZSH_VERSION ]] && read  -krE
      print '\n'
    )"
    echo $key
  }

  $CLS::map() {
    echo "Choose slot 1-9"
    local key="$(
    [[ $ZSH_VERSION ]] && read  -krE
      print '\n'
    )"
    echo $key
  }

  $CLS::replace() {
    nr=${1:-${$(printf '%q'  $KEYS)//*\'}}
    # BUFFER="Replacing slot #$nr"
    # echo $LIST
   echo "LIST_TYPE=$LIST_TYPE_BASE"
   local current=$(cat $LIST)
   :info "Current bookmark list" "$current"
    list=$(cat $LIST)
    eval $zle_pre
    BUFFER="list replace bookmarks/$list $nr"
    zle accept-line
    eval $zle_post
  }

  $CLS::cleanup() {
    FZF_DEFAULT_OPTS="$ORIGINAL_FZF_DEFAULT_OPTS"
  }

  $CLS::default() {
    cd "$LIST_TYPE_BASE"
    lsa
  }

  $CLS::open() {
    LIST_BASE="$ZSHAI_DATA/list"
    LIST_TYPE="bookmarks"
    LIST_CURRENT="$(cat $LIST_BASE/$LIST_TYPE/.current)"
    LIST="$LIST_TYPE/$LIST_CURRENT"
    LIST_DIR="$LIST_BASE/$LIST_TYPE/$LIST_CURRENT"
#    LN_PREFIX=1
#    LN_SUFFIX=1
    DISPLAY_WIDGET_VERBOSE=""
    WIDGET_LABEL='%b%F{6}%K{0}[widget]%F%K'

    #$CLS _push-prompt

    nr=${$(printf '%q'  $KEYS)//*\'}
    (( ! $nr )) && return
    item="$(list cat $LIST $nr)"
    [[ -z "$item" ]] && echo "empty"
    #(( LN_PREFIX )) && whiterows $LN_PREFIX

    [[  -d "$item" ]] && {
      WIDGET_CMD="cd ${item}"
      (( DISPLAY_WIDGET_VERBOSE )) && print -P  "${WIDGET_LABEL}%F{240}${WIDGET_CMD}"
      eval $WIDGET_CMD
      widget_output="$(zshai-prompt dirlisting)"
      zle-output-prompt "$widget_output"
    }

    #(( LN_SUFFIX )) && whiterows $LN_SUFFIX
  }

  $CLS::widget_label() {
    WIDGET_CMD="cd ${item}"
    (( DISPLAY_WIDGET_VERBOSE )) && print -P  "${WIDGET_LABEL}%F{240}${WIDGET_CMD}"
    eval $WIDGET_CMD
  }

  $CLS::_push_prompt() {
  #tput invis cnorm civis
    typeset -g SAVEPROMPT="$PROMPT"
    PROMPT=""
    zle_post="PROMPT=\"$SAVEPROMPT\""
 #   zle_pre="tput invis"
    zle_post="zle accept-line"
  }

  $CLS::bindkey() {
    local hotkey="$1"
    local dir="$2"
    line="Bind $CYAN$PWD$RESET to hotkey $CYAN$hotkey$RESET? "
    vared -p "$line" dir
    [[ ! -z "$dir" ]] &&  list append "$dir" $LIST || { echo "aborting" ;break }
  }

  $CLS::_aliases() {
    alias dbm="dirbookmark"
    unfunction $CLS::_aliases
  }
  
  subcommands $CLS $@
}

(){
  dirbookmark _aliases
}
zle-output-prompt() {
  local widget_output="$1"
#  (( LN_PREFIX )) && whiterows $LN_PREFIX
# tput cnorm
# tput invis
  #zle -R
  NL=$'\n'
  echo -n $NL$widget_output
  #zshai-zle accept-line
  zshai-zle-end
}

.zshai-dirbookmark() { dirbookmark open }
.zshai-dirbookmark-pwd() { dirbookmark add $@ }
.zshai-bookmark-map() { dirbookmark map }
.zshai-dirbookmark-pwd-replace() {
  nr=${$(printf '%q'  $KEYS)//*\'};
  echo "slot $nr"
  dirbookmark replace $nr
}

zle -N .zshai-dirbookmark
zle -N .zshai-dirbookmark-pwd-replace
zle -N .zshai-bookmark-map
zle -N .zshai-bookmark-pwd
zshai_bindkey '^[^B' .zshai-bookmark-pwd

#zle -N .zshai-bookmark-map
#zshai_bindkey '^[^B^[^B' .zshai-bookmark-map

for i in `seq 9`
do
  zshai_bindkey "$i" .zshai-dirlevel-enter
  zshai_bindkey "^[$i" .zshai-dirbookmark
done

zle -N .zshai-bookmark-pwd-replace
for i in `seq 9`
do
  zshai_bindkey "^[b^[$i" .zshai-dirbookmark-pwd-replace
done
