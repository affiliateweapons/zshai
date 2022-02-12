
fzf_zle() {


export FZF_DEFAULT_OPTS=$FZF_THEME_OPTS$(cat<<EOF
    --preview="zsh -t;source ~/.zshrc;a={};where {};echo \$a 2>/dev/null;echo \${(k)functions} 2>/dev/null;print -l \$functions[\$a]"
EOF
)
zle -l | fzf

unset FZF_DEFAULT_OPTS
}

zle-end() {
  zle accept-line
  zle  redisplay
}

TRAPWINCH() {
  zle && {zle -R ; zle reset-prompt}
}


buffer_region() {
  BUFFER="true word2 word3";
  region_highlight=( "0 4 fg=196" );
}


zle-test() {
echo "ZLE TEST"
echo "$ZLE_CMD"

eval $ZLE_CMD
unset ZLE_CMD
}
zle -N zle-test
bindkey '^[T' zle-test


zshai-redraw-prompt() {
  local precmd
  for precmd in $precmd_functions; do
    $precmd
  done
  zle reset-prompt
}
