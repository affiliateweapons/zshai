cdb() {
  CLS="cdb"


  $CLS::query() {
    local param1="$1"
    curl -X POST -H "Content-Type: application/json" \
      $($CLS connect) -d @$param1
  }
  $CLS::default() {
    # $CLS::query $@
  }
  $CLS::connect() {
    local SERVER_URL="${COUCHDB_URL:-1}"
    echo $SERVER_URL
    unset $SERVER_URL
  }

  subcommands $CLS $@
}
