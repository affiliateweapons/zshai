function flc {
  print -l ${(k)functions} | wc -l
}


function fl() {
  print -l ${(k)functions} | sort
}
