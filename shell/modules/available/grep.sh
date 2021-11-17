alias grep="grep --color=auto"



fzf_file_ext_contains() {
  local ext=${1:-php}
  local query="${2:-eval}"
  grep -riL  "$query" | grep $ext | fzf --preview="cat {}"
}
