ls_find() {

  case $1 in
  -r)
    shift
    ls --recursive  | grep $1

    ;;
  *)
    echo $1
   ;;
  esac

  #ls | grep $1

}
alias lsf="ls_find"
alias lsfr="ls_find -r"

ls_symbolic_links() {
  local q="$1"
  [[ -z $2 ]]  && {
  'ls' -lR $2 | 'grep' ^l | grep "$q"
  } || {
    'ls' -lR | 'grep' ^l | grep "$q"
  }
}



alias lsl="ls_symbolic_links"

ls_cmd() {
  echo "--"
  ls $@
  echo "--"
}

alias lsh="'ls' --help"
alias l="'ls' -1"
alias l="ls"
alias lsn="'ls' -1"
alias ls="'ls' -lsAtrhp --color=auto --group-directories-first"
alias lsr="'ls' --recursive"
alias lls="l -p --color=auto"
alias ll="ls"
alias cl="clear"
alias lss="ls -lSh"

lsc() {

  [[ -d "$1" ]] && {
    'ls' -1l "$1" | wc -l
  } || {
  ls | wc -l
  }


}


lsg() {
  local keyword="$1"
  shift
  ls | grep --color=always "$keyword" $@
}
