#!/usr/bin/env zsh
list() {

  list::modules() {
    echo "options: $1"
    case $1 in
      enabled)
        find -type f -type l  $ZSHAI_MODULES_DIR/enabled | fzf_preview
        ;;
      available)
        find  -type f -type l $ZSHAI_MODULES_DIR/available | fzf_preview
        ;;
      *)
        find  $ZSHAI_MODULES_DIR --recursive
        ;;
      esac
  }

  list::new() {
    #local name="$1"
    #vared -p "Name: " -e name
    nano ~/.zshai/list/$1
  }

  local action="${1:-all}"
  echo "action: $action"

  case $1 in
  modules)
    shift
    list::modules $@
    ;;
  new)
    list::new $@
    shift
    ;;
  *)
    list::new $@
    ;;
  esac

}
