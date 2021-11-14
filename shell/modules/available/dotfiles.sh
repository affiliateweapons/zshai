dotfn() {
  local dir=~/dotfiles
  local app="$1"

  [[ -e $dir/$1 ]] && echo "$dir/$1 already exists" && return
}

dotfiles_edit() {
  nano ~/.$1"rc"
}

alias dfe="dotfiles_edit"
alias dotf="cd ~/dotfiles;ls"
alias dotflink="~/dotfiles/symbolic_links.sh"
