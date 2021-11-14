random_name() {
  local prefix="$(shuf -n  1 $ZSHAI/list/prefix)"
  local suffix="$(shuf -n 1 $ZSHAI/list/suffix)"

  echo $prefix$suffix | sed 's/ //g'
}
alias rn="random_name"
alias sfx="cat $ZSHAI/list/suffix"
alias pfx="cat $ZSHAI/list/prefix"
