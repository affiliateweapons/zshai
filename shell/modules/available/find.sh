# find broken symbolic links
alias broken_sym="find . -xtype l"


# find with ls output
find_ls() {
  local query=$1
  shift
  local opts=$@
  find *  $opts | grep $query
}
alias fls="find_ls"


# find files that contain text $1
find_in_files() {
  grep -rnw  ./ -e "${1}"
}


# we use an alias function so that we can 
# capture the aliases for later use when you want to disable certain aliases
zshai_alias() {
  alias "$1"
  [[ -z $ZSHAI_DEBUG_LOG_ALIAS_SETUP ]] && echo "Setting alias: $1" >>  zshai_log aliases
}

zshai_log() {
  local type=$1

  message=$(cat /dev/stdinput)

  echo $message > zshai
}


zshai_alias fif=find_in_files
