typeset -g ZSHAI_MODULES_LOADED

edit_private_module() {

}

alias epm="edit_private_module"

copy_module() {
  local module="$1"
  local module_path="$ZSHAI/shell/modules/available/$module.sh"

  [[ -f "$module_path" ]] && {
    cat "$module_path" | xclip
  } || echo "$module doesn't exist"
}
copy_function() {
  echo $functions[$i] 2>&1 | command 'xclip' -select c
}

rm_module() {
  enable_colors
  local module="$1"
  local type="${2:-available}"
  local module_path="$ZSHAI/shell/modules/$type/$module.sh"

  [[ ! -f "$module_path" ]] && list_modules && return
  () {

  local lines="$(cat $module_path | wc -l)"
  echo
  bat -l zsh "$module_path" --style=numbers,header
  echo
  local answer

  echo $(B_RED 'WARNING PLUGIN FILES WILL BE DELETED')
  printf "%s"  $module_path
  vared -p "Delete module $module? y/n: "$'\t' -e answer

    [[ "$answer" = "y" ]] && {
      rm "$ZSHAI/shell/modules/enabled/$module.sh"
      rm "$module_path"
    }
  }
}

subcommands() {
  local CLS="$1"
  local cmd="$2"
  ZSHAI_SUBCOMMANDS_TRIGGERED=( $CLS )
  [[ -z "$CLS" ]] && echo "no CLS defined" && return

  case $cmd in
  e)  edit_module $CLS
      return ;;
  "") (( $+functions[$CLS::default] )) && $CLS::default || $CLS::list
      return ;;
  *)  (( $+functions[$CLS::$cmd] )) && {
        [[ ! -z $@ ]] && shift
        [[ ! -z "$SUB_VERBOSE" ]] && echo $CLS $cmd
        shift
        $CLS::$cmd $@
      } || {
        (( $+functions[$CLS::default] )) && {
          [[ ! -z $@ ]] && shift && $CLS::default $@
        } ||  {
          echo "Did you mean: $cmd "
          ##   fl "$CLS::$cmd" || echo "Unknown command: $@"
        }
      }
      ;;
  esac
}

module_init() {
 export ORIGINAL_FZF_DEFAULT_OPTS="$$FZF_DEFAULT_OPTS"
}

module_clean() {
  local CLS="$1"
  local cmd="$2"
#  $CLS::$cmd $@
  FZF_DEFAULT_OPTS="$ORIGINAL_FZF_DEFAULT_OPTS"
  unset ORIGINAL_FZF_DEFAULT_OPTS
}
fzf_modules() {

  export FZF_DEFAULT_OPTS="$FZF_THEME_OPTS"$(cat<<EOF
      --preview "batc -l zsh--color=always $ZSHAI_MODULES_DIR/available/{}"
EOF
)
  list_modules | fzf

}

verbose_log() {
  echo $@ > /tmp/verbose.log
}
mods() {
  cd $ZSHAI_MODULES_DIR
  zshai-prompt dirlisting
}

most_accessed_modules() {
  history_find "em " | sed 's/.*em /em /g' | sort -h | uniq -c | sort -h
}
recent_modules() {
  history_find "em " | sed 's/[ ].*em/ em/g' | grep -v "\/\|'\|\"" | tail -1000 | sort -k2 | uniq -c --skip-fields=1  | sort -h
}
top_x_modules() {
  local top="${1:-9}"
  local history_count="${2:-1000}"
  history_find "em " | sed 's/[ ].*em/ em/g' | grep -v "\/\|'\|\"" | tail -$history_count | sort -k2 | uniq -c --skip-fields=1  | sort -hr | tail -$top |  nl
}
