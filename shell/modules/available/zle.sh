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
  zle && { zle reset-prompt; zle -R }
}
