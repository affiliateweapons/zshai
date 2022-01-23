cdf() {
  local f=$1
  [[ -f $1 ]] && {
    cd ${f//${f:t}}
  } || {
    parent=${f//${f:t}}
    [[ -d $parent ]] && cd $parent || {
    parent=${parent//${parent:t}}
      [[ -d $parent ]] && cd $parent || {
        echo "could not cd into $parent"
      }
    }
  }

}


function md() {
    mkdir -p "$@" && cd "$@"
}
last_cd() {
  PWD_SKIP_ONCE=true
  [[ -f "$ZSHAI_DATA/pwd" ]] && cd $(cat "$ZSHAI_DATA/pwd")
}
alias lcd="last_cd"


for i in `seq 10`;-$i(){a="${funcstack//*-}";b=$(printf ':h%.0s' {1..$a});eval $(eval echo "$\{\$\(pwd\)$b\}")} 
