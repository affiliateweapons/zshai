count() {
  [[ -f /var/log/$1.log ]] && {
    cat /var/log/$1.log | wc -l
  } || {
    [[ -f $1 ]]  &&  {
      cat $1 | wc -l
    } || {

      data=$(cat /dev/stdin) 
      echo $data | wc -l
      #echo "file $1 does not exist"
    }
  }
}


