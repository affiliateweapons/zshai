filer() {

export FZF_DEFAULT_OPTS="$FZF_THEME_OPTS"$(cat<<EOF
  -m
  --margin 0 \
  --preview-window "right,50%" \
  --header-lines 1 \
  --preview="print -l {+}" \
  --bind "del:execute^print -l {+}^+abort"
  --bind "tab:select+up,esc:deselect-all"
EOF
)

  list=( $('ls' -1 -s | fzf ) )
  local size=$#list

  local answer="y"
  vared -p "$list

  Delete $size items? [y/n] > " -e answer

  if [[ "$answer" = "y" ]] then
    let a=0
    for i in $list
    do
      (( a++ ))
      file="${i//[0-9]* }"
      echo  "deleting #$a $RED $file $RESET"
      rm $file
      ls
    done
  fi

}
