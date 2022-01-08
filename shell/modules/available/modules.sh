copy_module() {
  local module="$1"
  local module_path="$ZSHAI/shell/modules/available/$module.sh"

  [[ -f "$module_path" ]] && {
    cat "$module_path" | xclip
  } || echo "$module doesn't exist"
}


subcommands() {
  local CLS="$1"
  local cmd="$2"
  [[ -z "$CLS" ]] && echo "no CLS defined" && return

  case $cmd in
  "")
    [[ $functions[$CLS::default] ]] && $CLS::default \
      || $CLS::list
      return
    ;;
  *)
    [[ $functions[$CLS::$cmd] ]] && {
      shift
      [[ ! -z "$SUB_VERBOSE" ]] && echo $CLS $cmd
      $CLS::$cmd $@
    } || {
      [[ $functions[$CLS::default] ]] \
      && {shift;$CLS::default $@} \
      || echo "Unknown command: $@"
    }
    ;;
  esac
}
