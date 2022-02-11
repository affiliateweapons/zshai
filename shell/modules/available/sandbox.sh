sandbox() {
  CLS="sandbox"
  local SANDBOX_DIR="${SANDBOX_DIR:-/opt/sandbox}"
  local project="$1"
  local project_path="$SANDBOX_DIR/$1"

  $CLS::list() {
    [[ -d "$project_path" ]] && cd "$project_path"  \
    || {
      mkdir -p "$project_path"
      prompt-info "Created new project folder" $project
      cd "$project_path"
      new-script "$project.sh"

      last-value sandbox "$project"
      last-value file "$project_path/$project.sh"
      undo-command "rm -R $project_path"

    }
  }

  $CLS::default() {
    $CLS::list $@
  }

  $CLS::aliases() {
    zshai_alias 'sb="sandbox"'
    zshai_alias 'sb2="cd /opt/www/sandbox"'
  }

  subcommands $CLS $@
}

() {
  sandbox aliases
}
