# list  aliases and optionally filter using grep
find_alias() {
  [[ -z $1 ]] && alias || {
    alias | grep $1 --color=auto
  }
}
zshai_alias fa="find_alias"

# edit local aliases and source them right aftere so that any new aliases
# are immediately available
alias eal="nano ~/.zshai/aliases.sh;source ~/.zshai/aliases.sh"
