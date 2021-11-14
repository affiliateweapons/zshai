alias broken_sym="find . -xtype l"


find_ls() {
  local query=$1
  shift
  local opts=$@
  find *  $opts | grep $query
}
alias fls="find_ls"
