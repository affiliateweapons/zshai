#!/usr/bin/env zsh
list() {
  local action=${1:-all}
  case $1 in
  new)
    list::new
    shift
    ;;
  *)
    list::new $1
    ;;
  esac

  list::new() {
    local name="$1"

    
    #vared -p "Name: " -e name
    nano ~/.zshai/list/$name
  }

}
