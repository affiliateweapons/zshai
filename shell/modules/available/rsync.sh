sync_site() {
  rsync -av $1 $2:$3
}
