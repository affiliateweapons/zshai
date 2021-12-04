function flc {
  print -l ${(k)functions} | wc -l
}


function fl() {
  print -l ${(k)functions} | sort
}

what() {
  echo $functions_source[$1]
}

edit_function() {
  local file=$(what $1)

  [[ -f "$file" ]] && nano $file
}
zshai_alias "ef=edit_function"
