new() {
  CLS="new"
  $CLS::module() {
    local template="$HOME/zshai/lib/skel/fzf-class"
    [[ "$1" = "t" ]] && {
      cat "$template" | xclip -selection c
      echo  "Copied template "$(echo $BLUE)$template$RESET" to clipboard"
      return
    }

    local module="$1"
    local type="available"
    [[ -z "$ZSHAI_MODULES_DIR" ]] && echo "ZSHAI_MODULES_DIR not defined" && return
    vared -p "Create module name: " -e module
    local file="$ZSHAI_MODULES_DIR/$type/$module.sh"
    [[ -f "$file" ]] && {
      echo "Module already exist"
      $commands[nano] "$file"
      return
    } || {
      local template="$HOME/zshai/lib/skel/fzf-class"
      echo "Create module: $module"
      echo "Skel file: $template" 
      cat "$template" | sed 's/{name}/blockexplorer/g' | xclip -selection c
      cat "$template" | sed 's/{name}/blockexplorer/g'  > "$file"
      echo $(_GREEN "Created module: $file")
      edit_module  "$module"
    }
  }

  subcommands $CLS $@

}
