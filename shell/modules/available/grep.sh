alias grepc="grep --color=auto"

find_files() {
  grep -rnw  $1 
}

#grepfind
gf() {
  grep "$1"
}

fzf_file_ext_contains() {
  local ext=${1:-php}
  local query="${2:-eval}"
  grep -riL  "$query" | grep $ext | fzf --preview="cat {}"
}

grp_dyml() {

#list=$(find 2>/dev/null | grep docker-compose.yml$)
#echo $list

  [[ ! -z "$1" ]] && cd $1
  export FZF_DEFAULT_OPTS=$FZF_THEME_OPTS$(cat <<EOF
  --ansi
  --preview='folder={};bat \$folder/docker-compose.yml --color=always --style=plain'
  --preview-window "+{2}-5,top,60%:wrap"
  --bind "alt-up:preview-page-up"
  --bind "alt-down:preview-page-down"
  --bind "f2:execute^$INIT;echo \$(grep_change_pattern)^+reload($GREP_CMD)"
  --bind "enter:execute^folder={};bat \$folder/docker-compose.yml --color=always --style=plain^+abort"
EOF
)

find 2>/dev/null | grep docker-compose.yml$  | sed 's/docker-compose.yml//g' | fzf



}
grp() {  
  cd /opt
  FILE_PATTERN=${FILE_PATTERN:-Dockerfile}
  local q="$1"
  BAT="bat -l Dockerfile  --paging=auto --style=full --color=always --highlight-line {2} {1}"
  echo ${0:A:h}/bin
  export ZSHAI_MODULES_DIR
  INIT="source $ZSHAI_MODULES_DIR/available/grep.sh"
  GREP_CMD="$INIT; echo 234"
#\${f//:*/}
  export FZF_DEFAULT_OPTS=$FZF_THEME_OPTS$(cat <<EOF
  --ansi
  --delimiter :
  --preview "echo {2};echo {1};f={1};${BAT} {1}"
  --preview-window "+{2}-5,top,60%:wrap"
  --bind "alt-up:preview-page-up"
  --bind "alt-down:preview-page-down"
  --bind "f2:execute^$INIT;echo \$(grep_change_pattern)^+reload($GREP_CMD)"
EOF
)
  grepper |  fzf
  unset FZF_DEFAULT_OPTS
  cd -
}

grepper() {
  echo "searching in $FILE_PATTERN for $1"
  grep -rn  "$1" \
   --include "$FILE_PATTERN" \
   --exclude-dir="*containerd*" \
   --color=always
#2>/dev/null
}
grep_change_pattern() {
  export FZF_DEFAULT_OPTS=$(cat <<EOF
EOF
)
  select=$(cat  ~/.zshai/grep/patterns/file | fzf)
  echo $select
  export FILE_PATTERN="$select"
}
