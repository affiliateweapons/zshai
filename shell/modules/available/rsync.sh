sync_site() {
  rsync -av $1 $2:$3
}
alias rs="rsync -av"
