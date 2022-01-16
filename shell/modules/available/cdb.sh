cdb() {
  CLS="cdb"


  $CLS::query() {
    local param1="$1"
    shift

    [[ -f "$param1" ]] && {
      $CLS connect "-d @$param1"
    } || {
      $CLS connect
    }
  }
  $CLS::get() {
    CDB_REQUEST_METHOD="GET"
    $CLS connect $@
  }
  $CLS::default() {
    # $CLS::query $@
    echo $1
  }
  $CLS::connect() {
    local CDB_ENDPOINT="${CDB_ENDPOINT:-$1}"
    local CBD_DATA="${2}"
 #    local CDB_SERVER="${CDB_SERVER:-$2}"
 #   local CDB_DATABASE="$${CDB_DATABASE:-$3}"
    local CDB_BUILD_URL="$CDB_SERVER/$CDB_DATABASE$CDB_ENDPOINT"
    local CDB_CONNECT_URL="${CDB_CONNECT_URL/:-$CDB_BUILD_URL}/$CDB_ENDPOINT"
    local CDB_REQUEST_METHOD="${CDB_REQUEST_METHOD:-POST}"
    echo "Connecting to: $CDB_CONNECT_URL"
    echo "Request method: $CDB_REQUEST_METHOD"
    echo "Endpoint: $CDB_ENDPOINT"
    echo "Params: $2"
    local api_request="$(echo curl -X \"$CDB_REQUEST_METHOD\" -H \"Content-Type: application/json\" \"$CDB_CONNECT_URL\" $CDB_DATA)"
    [[ ! -z "CDB_VERBOSE" ]] && echo "$api_request"

    eval $api_request
  }

  $CLS::cleanup() {
    unset $SERVER_URL
  }

  subcommands $CLS $@
}
