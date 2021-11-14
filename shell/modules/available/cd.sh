cdf() {

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
