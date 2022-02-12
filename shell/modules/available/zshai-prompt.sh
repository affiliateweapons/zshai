typeset -g zshai_log_lines
THIS_FOLDER_IS_EMPTY="${YELLOW}$THIS_FOLDER_IS_EMPTY${RESET}"


zshai-log() {
  zshai_log_lines+=($1)
  # echo $1 >> /tmp/zshai.log
}

typeset -Ag extlist=()
typeset -Ag dirhash=()
typeset -Ag DIR_HASH=()
typeset -Ag TAP_CD_HIST=()
typeset -g TAP_CD_TARGET
autoload -U add-zsh-hook
enable_colors
#[[ -z $LS_CMD ]] && typeset -gr LS_CMD="$commands[ls] -1pAcFL --group-directories-first --color=never"

zshai-prompt() {
  CLS="zshai-prompt"
  [[ -z $ZLS_CMD ]] && typeset -gr ZLS_CMD="$commands[ls] -1pAcFL --group-directories-first --color=never"
  zshai-prompt::filetype() {
    extlist=(
      [sh]="$YELLOW$icons[SSH_ICON] "
      [php]="$BLUE$icons[PHP_ICON] "
      [git]="$RED$icons[VCS_GIT_GITHUB_ICON]$RESET "
      [gz]="$BLACK$icons[DISK_ICON] "
      [gitignore]="$GRAY"
      [json]="$YELLOW$icons[NODEJS_ICON] "
      [js]="$YELLOW$icons[NODEJS_ICON] "
      [env]="$YELLOW"
      [md]="$BROWN"
      [default]="$WHITE $icons[DISK_ICON] "
    )
    local dir="$1"
    local file="$2"
    local ext="${file:e}"
    [[ "$extlist[(I)$ext]" ]] && {
      echo "$extlist[$extlist[(I)$ext]]$file$RESET"
    } || {
      #echo $(file "$dir/$file")
      echo "$file"
    }
  }
  zshai-prompt::git-status() {
    git_status=$(git status -s 2> /dev/null); [[ -z $git_status ]] && echo "no git" || echo $git_status
  }

  zshai-prompt::cwd_line() {
    DIR="${PWD//\// $CHR[SEP] }$RESET"
    echo "$C[FRAME]$C[ROOT_ICON]$ROOT_ICON$RESET$BB_WHITE${${DIR//^home/$HOME_ICON}}"
  }

  zshai-prompt::dirlisting() {
     #local Wcached_render="$1"
    # [[ -f "$cached_render" ]] && cat "$cached_render" && return
     export dirlist=( $(eval $ZLS_CMD $@) )

     #calculate padding
     #local lines=$#dirlist
      #nrlen=$(echo $lines | wc -L)
      #nrlen=$(( $nrlen > 3 ? $nrlen : 3 ))
      for i in `seq $#dirlist`
      do
        d="${dirlist[i]}"
         ext=${d:t}
        [[ "${d//\/}" != "$d" ]] && {
         dirlist[$i]="$ICN[FOLDER]$C[FOLDER] ${dirlist[$i]:t}$RESET"
         } || {
         dirlist[$i]="$extlist[${d:e}]$d$RESET"
         #$(zshai-prompt filetype "${PWD}"  "${dirlist[$i]}")"
        }
      done
      #printf '\n'"$(printf '%b\n' ${(@f)dirlist//})"
      list="$(printf '%b\n' ${(@f)dirlist//})"

      [[ -z "$list" ]] && {
        list="${YELLOW}$THIS_FOLDER_IS_EMPTY${RESET}"
        typeset -g EMPTY_DIR=1
      } || {
        unset EMPTY_DIR
      }

      print '\n'$list'\n'
  }

  ##'CDLS'##
  zshai-prompt::cdls() {
    #echo "DISABLED"
    nr="${TAP_KEY:-$1}"
    local dirs=( $(eval $ZLS_CMD) )
    local selection=$dirs[$nr]
    [[ ! -z "$selection" ]] && local selection_path=$(realpath $selection)
    [[ -d "$selection_path" ]] && {
      #print -l
      cd $selection_path
      [[ -z "$2" ]] && zshai-prompt dirlisting
    }
    TAP_CD_KEY="$nr"
    TAP_CD_TARGET="$selection_path"
    TAP_CD_HIST[$selection_path]="$selection"
  }

  zshai-prompt::cache() {
    local TYPE="$1"
    local CACHE_KEY="$2"

    echo "CACHE"
    return
    # HOT_CACHE=1
    [[ ! -d "$CACHE_DIR/$TYPE" ]] && {
      mkdir -p $CACHE_DIR/{1,2,3,rendered}
    }
    #local -a cache_types
    #DIR_HASH[$CACHE_KEY]=
    cache_filepath="$CACHE_DIR/$TYPE/$CACHE_KEY"
    #[[ -f "$cache_filepath" ]] && {
    #  cat "$cache_filepath" \
    #}
    [[ -z $HOT_CACHE ]] && (( $+DIR_HASH[$HOT_CACHE-$TYPE-$CACHE_KEY]  )) && {
        cat "$cache_filepath"
    } || {
      [[ -f "$HOT_CACHE$cache_filepath" ]] && {
        cat "$cache_filepath"
      } || {
          [[ ! -z $HOT_CACHE ]] && zshai-log "HOT CACHE" && zshai-prompt::$cache_types[$TYPE] {
          zshai-prompt::$cache_types[$TYPE] > "$cache_filepath"
          DIR_HASH+=( [$TYPE-$CACHE_KEY]="$cache_filepath" )
          cat "$cache_filepath"
     }
   }
  }

  zshai-prompt::purge() {
    echo "purge cache"
    rm $CACHE_DIR/{1,2,3,rendered} 2>/dev/null
    rm $CACHE_DIR//* 2>/dev/null
    ls $CACHE_DIR/$1
  }

  zshai-prompt::show() {
    DIRLISTING=1
    TOPBAR=2
    PARENT_DIRS=3
    #  topbar=\n$(printf '%s\n' ${$(_cache $TOPBAR $PWD_B64)///$(_cwd_line)})
    #  PS1=${topbar}
    #   PS1='~/%b%k%f'
    #  PS2=''
      #~/%b%k%f
    #  printf '%s\n' $(zshai-prompt::cache 1 $PWD_B64)
  }

  zshai-prompt::prompt() {
  }

  zshai-prompt::build-prompt() {
    setopt prompt_subst
    setopt promptpercent
    #echo "${PS_VAR1//PW/$PS_VAR2}"
  }

  zshai-prompt::save() {
    ## SAVE RPOMPT METHOD
    SAVEPROMPT=$PROMPT
    PROMPT=$BLANK_PROMPT
    zshai-prompt cdls $KEYS
    PROMPT=$SAVEPROMPT
  }

  zshai-prompt::uptime() {
    ((upSeconds = $(print -P "%D{%s}") - $(sysctl -n kern.boottime)))
    ((secs = upSeconds % 60))
  	((mins = upSeconds / 60 % 60))
  	((hours = upSeconds / 3600 % 24))
  	((days = upSeconds / 86400))
  	if (( days > 0 )); then
  		echo -n "${days}d"
    	printf '%.2d:%.2d' $hours $mins
    fi
  }

  zshai-prompt::ps2() {
    #    cat /dev/random | head -c 10 | hex
  }

  zshai-prompt::list() {
    #     PS2=/'~/%b%k%f'
    #     echo 2134;
  }

  subcommands zshai-prompt $@
}

_zshai_prompt_setup() {
  enable_colors
  typeset -g CACHE_DIR="/mnt/ramdisk/cache/dirlevel"
  typeset -Ag DIR_HASH=()
  typeset -ag dirlist=()
  typeset -ag cache_types=( dirlisting topbar parent_dirs typeset )
  typeset -Ag ICN=()
  ICN=(
    [FOLDER]="\U0001f4c1"
  )
  NODE_ICON='\ue617'
  HOME_ICON="\uf015"
  ROOT_ICON="$HOME_ICON"
  typeset -Ag C=()
  C=(
  [FRAME]='\u001b[34;1m'
  [FOLDER]="$B_BLUE"
  [MF]="$BB_BLUE"
  )
  typeset -Ag CHR=()
  CHR=(
    [MF]='\u251c'
    [TM]='\u2500'
    [TL]='\u256d'
    [SEP]='\ue0b1'
    [VF]=' \ue0b2 '
  )
  typeset -Ag extlist=()
  extlist=(
    [sh]="$YELLOW$icons[SSH_ICON] "
    [php]="$BLUE$icons[PHP_ICON] "
    [git]="$RED$icons[VCS_GIT_GITHUB_ICON] "
    [gitattributes]="$RED$icons[VCS_GIT_GITHUB_ICON]$RESET "
    [gitignore]="$RED$icons[VCS_GIT_GITHUB_ICON] "
    [gitpod.yml]="$RED$icons[VCS_GIT_GITHUB_ICON] "
    [gz]="$BLACK$icons[DISK_ICON] "
    [gitignore]="$BLACK$icons[VCS_GIT_GITHUB_ICON]"
    [json]="$YELLOW$icons[NODEJS_ICON] "
    [js]="$YELLOW$icons[NODEJS_ICON] "
    [gitignore]="$GRAY"
    [env]="$YELLOW"
    [md]="$BROWN"
    [default]="$WHITE $icons[DISK_ICON] "
  )
  unfunction _zshai_prompt_setup
}

trunc-prompt() {
  local pwdmaxlen=10
  local trunc_symbol="..."
  if [ ${#PWD} -gt $pwdmaxlen ]
  then
    local pwdoffset=$(( ${#PWD} - $pwdmaxlen ))
    newPWD="${trunc_symbol}${PWD:$pwdoffset:$pwdmaxlen}"
  else
    newPWD=${PWD}
  fi
  echo $newPWD
}

alias ze="zshai_env"

