# short functions for commonly used tar options
# especially useful for system backup/rescue/recovery.
# instead of fixing a compromised server, just tar compress everything to a 
# new server
tardm() {
  [[ ! -e "$1" ]] && echo "$1 not found" && return
  tar czvf $1.tar.gz $1
  sudo rm -R $1
}

tardirs() {
  for i in $('ls' -p | grep \/ );tardm ${i//\//}
}

tarc() {
  local archive="$1"
  local target="$2"
  [[ -z "$2" ]] && {
    target=$1
    archive=$1
  }

  [[ ! -e "$target" ]] && echo "$target not found" && return 

  sudo tar czvf $archive.tar.gz $target
}

tarx() {
  req1 $1 && return

  tar zxvf $1
}

targit() {
  if [[ "$1" == '*https*' ]]; then
     METHOD="https"
  else
     METHOD="ssh"
  fi
  echo "Method: $METHOD"

  local name=${1:l:t:r}
  echo "Cloning to $name"
  git clone $1 $name
  echo "Creating archive $name.tar.gz"
  tardm $name
  tarl $name.tar.gz | fzf_preview
}

# list files in a .tar.gz archive
alias tarl="tar -tvf"
