
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
rm_module() {
  local module="$1"
  local module_path="$ZSHAI/shell/modules/available/$module.sh"

  [[ -f "$module_path" ]] && {
  local answer
  vared -p "Delete module $module? y/n" -e answer

    [[ "$answer" = "y" ]] && {
      rm "$ZSHAI/shell/modules/enabled/$module.sh"
      rm "$module_path"
    }
  } || echo "No module given"
}

subcommands() {
  local CLS="$1"
  local cmd="$2"
  [[ -z "$CLS" ]] && echo "no CLS defined" && return

  case $cmd in
  e)
      edit_module $CLS
      return ;;
  "")
    (( $+functions[$CLS::default] )) && $CLS::default \
      || $CLS::list
      return
    ;;
  *)
    (( $+functions[$CLS::$cmd] )) && {
      shift
      [[ ! -z "$SUB_VERBOSE" ]] && echo $CLS $cmd
      shift 
      $CLS::$cmd $@
    } || {
      (( $+functions[$CLS::default] )) \
      && {shift;$CLS::default $@} \
      || echo "Unknown command: $@"
    }
    ;;
  esac
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
