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

fgrep() {

find * | grep $1
}


zshai_alias fif=find_in_files
