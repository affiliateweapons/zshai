tools() {
  local tools=$( cat $ZSHAI/list/tools/cloud )
  repo=$(cat $ZSHAI/list/tools/cloud | fzf)

  [[ -z "$repo" ]] && echo "nothing selected" || {
    git clone https://github.com/$repo
  }
}
