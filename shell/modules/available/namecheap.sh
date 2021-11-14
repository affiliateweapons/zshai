domains() {
  local domains="$ZSHAI_DATA/domains/namecheap.csv"
  column -s, -t < ${domains} | fzf --header-lines=1
}
alias dom="domains"
