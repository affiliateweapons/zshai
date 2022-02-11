DISABLE_PARENT_DIRS=1
whiterows() {
  rows="${1:-5}"
  echo "white rows"$rows
  printf '\n%.0s' {1..$rows}
}
#zshai-cursor-off
dirlevel() {
  local direction="${1:-'previous'}"
  CLS="dirlevel"
  export CUR_DIR="${$(pwd):t}"
  leveldirs=( $('ls' -1 ../ -p 2>/dev/null | grep "/" | sed 's/\///g' ) )
  folders=( $(eval $ZLS_CMD 2>/dev/null | grep '/'  | sed 's/ ->.*/\//' | sed 's/.* //g') )


   $CLS::default() {
     # ALLOWED_ROOT=( home opt mnt data media )
   }

  $CLS::previous(){
    local current_index=$leveldirs[(i)$CUR_DIR*]

    [[ "$current_index" -le 1 ]] && {
      $CLS::change_dir "../$leveldirs[-1]"
    } || {
      $CLS::change_dir "../$leveldirs[$current_index-1]"
    }
  }
  $CLS::next() {
    local current_index=$leveldirs[(i)$CUR_DIR*]

    [[ "$current_index" -ge $#leveldirs ]] && {
      $CLS::change_dir "../$leveldirs[1]"
    } || {
      $CLS::change_dir "../$leveldirs[$current_index+1]"
    }
  }

  $CLS::up() {
    $CLS::change_dir "${$(pwd)//$CUR_DIR}"
  }

  $CLS::down() {
    [[ ${disabled_dirs//$change_dir} != ${disabled_dirs} ]] && return
    [[ -z "$DIRLEVEL_DOWN_ACTION" ]] \
      && $CLS::change_dir $folders[-1] \
      || $CLS::change_dir $dirstack[1]
  }

  $CLS::file-up() {

#    echo "upn"
    show_folders "up"
  }

  $CLS::file-down() {

#    echo "up"
    show_folders "down"
  }

  $CLS::execute() {
#    echo $KEYS
#    echo "Exute"
#    show_folders "execute"
     local nr="${funcstack%%[^0-9]*}"
#     local nr="${funcstack}"
#     echo $nr
  }


  $CLS::toggle-folders() {
    [[ -z "$DISABLE_PARENT_DIRS" ]] && DISABLE_PARENT_DIRS=1 \
      || {
    unset DISABLE_PARENT_DIRS
    show_folders
    }
  }




 $CLS::enter() {
    $CLS::change_dir $folders[-1]
 }
    #-x -m -x -l -1 -l -c

  # change dir
  $CLS::change_dir() {
    local change_dir="$1"
#    echo "changedir"
    disabled_dirs=( "proc" )
    [[ ${disabled_dirs//$change_dir} != ${disabled_dirs} ]] && return
    [[ "$change_dir" == "/usr" ]] && echo $(B_RED "WARNING") && return
    [[ -d "$change_dir" ]] && {
      cd "$change_dir" 2>/dev/null && previous_dir=$changed_dir
      folders=( $(cd ../;'ls' -p1g | grep '/' | sed 's/.* //g' ) )
      #enable_colors
      #fg=red
      #color="RED"
      #marked_dir="$B_RED$CUR_DIR$RESET/"
      #BUFFER="true word2 word3";
      #region_highlight=( "0 4 fg=196" );
      #folders="${folders//\/}"
      changed_dir="$change_dir"
      #$CLS::show_folders
      [[ ! -z "$changed_dir" ]] && previous_dir="$changed_dir"
#      prompt_bottom
#      show_folders
#      echo a

      #echo "\n"📁"${$(print -l $folders  | column -s ' ')//$CUR_DIR\//$marked_dir}"
    } || {
       [[ ! -z "$changed_dir" ]]  && {
      #$CLS::change_dir $previous_dir
      }
    }
    echo "$(ls --color=never 2>/dev/null)$(repeat 10 echo '' )"
  }

  $CLS::show_folders() {
    return
    #enable_colors
    #folders=( $('ls' -p1g | grep '/' | sed 's/.* //g' | tail -n +2) )
    folders=( $(cd ../;'ls' -pA1g | grep '/' | sed 's/.* //g' ) )
    folders="$(
    for i in $folders
    do
      [[ "$i" = "$CUR_DIR/" ]] && {
        echo "📁$RED$i|$RESET"
      } || {
        echo "📁$RESET$i|"
      }
    done | column -x)"
    echo "${folders//|}"
    echo $RESET
  }
  (( $+functions[subcommands] )) && subcommands $CLS $@
}



(){

  #  zle_post="zle clear-prompt"
  #CLEAR=";clear"
  #TPUT_CIVIS=";zshai-cursor-off"
  #TPUT_CNORM=";tput cnorm"
  #PROMPT_OFF=";prompt off"
  #ZLE_RESET_PROMPT="zle .reset-prompt"
  #  ACCEPT_LINE="zshai-accept-line"
  #ZLE_RESET_PROMPT="zle reset-prompt"
  #  export zle_pre="$ACCEPT_LINE $TPUT_CIVIS $PROMPT_OFF  $CLEAR"
  #export zle_pre=`printf '\n%.0s' {1..10}`
  #  export zle_pre=`printf '\n%.0s' {1}`
  #export zle_post="$ZLE_RESET_PROMPT $TPUT_CNORM"



  .zshai-dirlevel-previous() {
    [[ -z $BUFFER ]] && {
      eval $zle_pre
      dirlevel previous
      zshai-accept-line
      return
    } || {
      LBUFFER="$LBUFFER$KEYS" RBUFFER="$RBUFFER"
    }

  }

  .zshai-dirlevel-next() {
    eval $zle_pre
    dirlevel next
    zshai-accept-line
    return
    
    eval $zle_post
  }


  .zshai-dirlevel-down() {
    [[ -z $BUFFER ]] && {
      eval $zle_pre
      dirlevel down
      zshai-accept-line
      # eval $zle_post
    } || {
      [[ "$KEYS" = '-' ]] && {
        LBUFFER="$LBUFFER$KEYS" RBUFFER="$RBUFFER"
      }
    }
  }

  .zshai-dirlevel-file-up() {
    eval $zle_pre
    dirlevel file-up
    eval $zle_post
  }

  .zshai-dirlevel-file-down() {
    eval $zle_pre
    dirlevel file-down
    eval $zle_post
  }


  .zshai-dirlevel-toggle-folders() {
    eval $zle_pre
    dirlevel toggle-folders
    eval $zle_post
  }

  {
    typeset -Ag KEY=( )
    KEY=(
      [LEFT]='D'
      [RIGHT]='C'
      [UP]='A'
      [DOWN]='B'
      [HOME]='H'
      [END]='F'
      [F1]='P'
      [F2]='Q'
      [F3]='R'
      [F4]='S'
      [PLUS]='+'
    )
    typeset -Ag MODIFIERS=( )
    MODIFIERS=(
      [CTRL]='^[[1;5'
      [ALT]='^[[1;3'
      [ALT_SHIFT]='^[[1;4'
      [CTRL_SHIFT]='^[[1;6'
      [SHIFT]='^[[1;2'
      [ARROW]='^[0'
    )

 #   ALT='^['
 #   ALT_BACKSPACE='^H'

      for i in  ${(k)MODIFIERS};
      do
        for k in ${(k)KEY}
        do
            eval $i"_$k='$MODIFIERS[$i]$KEY[$k]'";
        done
      done

#    local CTRL=$KEY[CTRL]
#    local ALT_SHIFT=$KEY[ALT_SHIFT]
#    local SHIFT=$KEY[SHIFT]
#    local ALT=$KEY[ALT]
     .complete-clear() {
      unset  EMPTY_DIR
      clear
      zle reset-prompt
    }

    zle -N  .complete-clear
    zshai_bindkey "^[^H" .complete-clear

 #   zle -N .zshai-dirlevel-file-up
 #   zshai_bindkey "$CTRL_UP" .zshai-dirlevel-file-up

#    zle -N .zshai-dirlevel-file-down
#    zshai_bindkey "$CTRL_DOWN" .zshai-dirlevel-file-down

    zle -N .zshai-dirlevel-previous
    zshai_bindkey "$ALT_LEFT" .zshai-dirlevel-previous
    zshai_bindkey "$CTRL_LEFT" .zshai-dirlevel-previous
#    zshai_bindkey "\`" .zshai-dirlevel-previous

    zle -N .zshai-dirlevel-next
    zshai_bindkey "$ALT_RIGHT" .zshai-dirlevel-next
    zshai_bindkey "$ALT_PLUS" .zshai-dirlevel-next

    zle -N .zshai-dirlevel-next
    zshai_bindkey "$CTRL_RIGHT" .zshai-dirlevel-next


    zle -N .zshai-dirlevel-up
    zle -N .zshai-dirlevel-arrow-up
    zshai_bindkey "$ALT_UP" .zshai-dirlevel-up 
    #.zshai-dirlevel-arrow-up
    zshai_bindkey "\`" .zshai-dirlevel-up

    zle -N .zshai-dirlevel-down
    zshai_bindkey "$ALT_DOWN" .zshai-dirlevel-down
    zshai_bindkey '\-' .zshai-dirlevel-down

    zle -N .zshai-dirlevel-toggle-folders
    zshai_bindkey "$CTRL_F1" .zshai-dirlevel-toggle-folders

    zle -N .zshai-dirlevel-enter
#    zshai_bindkey '1' .zshai-dirlevel-enter 1

  }
}
