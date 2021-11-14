# list  aliases and optionally filter using grep
ali() {
  [[ -z $1 ]] && alias || {
    alias | grep $1 --color=auto
  }
}

# edit local aliases and source them right aftere so that any new aliases
# are immediately available
alias eal="nano ~/.zshai/aliases.sh;source ~/.zshai/aliases.sh"
