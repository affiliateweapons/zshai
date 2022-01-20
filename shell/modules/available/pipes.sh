pipe2log() {
  cat /dev/stdin  2>| err.log >> out.log
}

stderr2log() {
  cat /dev/sterr  2>| err.log >> out.log
}
#print -l $(git pull 2>&1 ) > 1.log 
