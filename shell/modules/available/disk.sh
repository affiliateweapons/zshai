dfs() {
  case $1 in
  p)
    df -h | grep -v "tmpf" | sort -k5 -h
   ;;
  u)
    df -h | grep -v "tmpf" | sort -k3 -h
    ;;
  *)
    df -h | grep -v "tmpf" | sort -k4 -h
    ;;
  esac
}

alias fdl="sudo fdisk -l"
