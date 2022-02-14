fd() {
   #$opts=${@:-=}
  for i in $@
  do
    [[ "${i//\/}" != "$i" ]] && {
      $commands[fd] --full-path "$@"
      return
    }
  done
  $commands[fd] $@
}
