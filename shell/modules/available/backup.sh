backup() {
  local suffix=${2:-bak}
  cp $1 $1.bak
}

remove_backup() {
  rm $1.bak
}

alias bku="backup"
alias rmb="remove_backup"
