random_name() {
  local prefix="$(shuf -n  1 $ZSHAI/list/prefix)"
  local suffix="$(shuf -n 1 $ZSHAI/list/suffix)"

  echo $prefix$suffix | sed 's/ //g'
}
alias rn="random_name"
alias sfx="cat $ZSHAI/list/suffix"
alias pfx="cat $ZSHAI/list/prefix"


random_quote() {

  repeat 3; echo 
  local quote="$(random_from_list quote)"
  echo $quote
  repeat 3;echo
}

random_from_list() {
  local count="${2:-1}"
  local list="${1}"
  local item="$(shuf -n $count $ZSHAI_DATA/list/$list)"
  echo $item
}
