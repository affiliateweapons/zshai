new() {
  CLS="new"
  datadir="$HOME/zshai/lib/skel"
  $CLS::hotkey() {
    local template="$HOME/zshai/lib/skel/hotkey"
    [[ "$1" = "t" ]] && {
      cat "$template" | xclip -selection c
      echo  "Copied template "$(echo $BLUE)$template$RESET" to clipboard"
    }
  }
  $CLS-bk,hk,hotkey,bindkey() {
    $CLS::hotkey $@
  }
  $CLS::widget() {
    color=129
    local object="widget"
    local template="$HOME/zshai/lib/skel/$object"
    [[ "$1" = "t" ]] && {
      cat "$template" | xclip -selection c
      echo  "Copied template "$(echo $CYAN)$template$RESET" to clipboard"
      return
    }
    [[ "$1" = "o" ]] && {
      cat "$template" | sed "s/{name}/$widget/g"
      return
    }
    local name="$1"
    local group="${$(last-value  widget-group):-workspace}"
    local prefix="${$(last-value prefix):-alt}"
    local key
#    group="$(last-value widget-group $group)"
#    prefix="$(last-value prefix $prefix)"
    [[ -z "$ZSHAI_MODULES_DIR" ]] && echo "ZSHAI_MODULES_DIR not defined" && return

    echo "Current widget groups:"
    'ls' -1 $ZSHAI_MODULES_DIR/widgets/
    vared -p "Widget group: " -e group
    title="Widget name: %F{$color}$group-"
    vared -p "$title" -e name

    title="Key prefix %F{$color}"
    vared -p "$title" -e prefix

    title="Key: %F{$color}"
    vared -p "$title" -e key
    echo "$RESET"
    fullname="$group-$name"
    mkdir -p "$ZSHAI_MODULES_DIR/widgets/$group"
    local file="$ZSHAI_MODULES_DIR/widgets/$group/$group-$name.sh"
    [[ -f "$file" ]] && {
      echo "Widget already exist"
      $commands[nano] "$file"
      return
    } || {
      echo $RESET"Created $group module: $name"
      echo "Skel file: $template"
      [[ $2 != "-c" ]] && cat "$template" | sed "s,{name},$fullname,g" | xclip -selection c
      cat "$template" \
      | sed "s/{name}/$fullname/g" \
      | sed "s/{prefix}/$prefix/g" \
      | sed "s/{key}/$key/g" \
       > "$file"
      echo $(_GREEN "Created widget module: $file")
      edit_module "$group-$name" "widgets/$group"
    }
  }
  $CLS::module() {
    local template="$HOME/zshai/lib/skel/fzf"
    [[ "$1" = "t" ]] && {
      cat "$template" | xclip -selection c
      echo  "Copied template "$(echo $BLUE)$template$RESET" to clipboard"
      return
    }
    [[ "$1" = "o" ]] && {
      cat "$template" | sed "s/{name}/$module/g"
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
      [[ $2 != "-c" ]] && cat "$template" | sed "s/{name}/$module/g" | xclip -selection c
      cat "$template" | sed "s/{name}/$module/g"  > "$file"
      echo $(_GREEN "Created module: $file")
      edit_module  "$module"
    }
  }

  $CLS::default() {
      [[ ! -z "$1" ]] && {
      $1 2>/dev/null
      (( $+functions[$1::new] )) && {
        #echo "$1::new function exist"
        $1 new
        return
       }
     }
    'ls' -1 $datadir
  }
  $CLS::fl() {
    [[ -z "$1" ]] && result=(${(@f)$(fl)}) || result=(${(@f)$(fl | grep $1)})
    for i in $result
    do
      echo "$i=$functions_source[$i]"
    done
  }
  subcommands $CLS $@

}
