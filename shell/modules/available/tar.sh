# short functions for commonly used tar options
# especially useful for system backup/rescue/recovery.
# instead of fixing a compromised server, just tar compress everything to a
# new server
tardm() {
  [[ ! -e "$1" ]] && echo "$1 not found" && return
  tardir $1
  [[ -z $2 ]] && sudo rm -R $1
}

tardir() {
  tar czvf $1.tar.gz $1
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

tarcf() {
  req1 $1 && return
  tar zxvf $1.tar.gz $1
}

targit() {
  local list_files="$2"
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
  [[ ! -z $list_files ]] && {
    tarl $name.tar.gz | fzf_preview
  }
}

# list files in a .tar.gz archive
tarl() {
  tar -tvf $1
}

# just acrhive, dont compress
tarchive() {
  tar -cf $1.tar  $1
}

# and then restore with this
tarchive_x() {
  tar -xf $1 -C /
}

tarviewer() {
  'ls' | grep gz  | fzf --preview="tar -tvf {}" --preview-window=right,80%
}


.targit() {
  [[ ! -z "$1" ]] && targit $@
}

zle -N .targit
bindkey '^[^G'  .targit
