export_hex() {
  gex "reload();blockTransactions(10000000,1).raw()" | sed 's/0x//g' | remove_quotes
}

block2bin() {
  local block="$1"
  local index="${2:-0}"
  gex "blockTransactions($block,$index).raw()" | sed 's/0x//g' | remove_quotes | xxd -r -p > $block-$index.bin
}

export_mil() {
  local start="${1:-10}"
  local rounds=10
  local batch_size=10000
  local mil=1000000
  (( startnr=start*1000000))
  (( end=start+100 ))
  for i in {1..$rounds}
  do
    (( seq=(i-1)*batch_size ))
    ((nr=startnr+seq))
    echo "exporting $nr 10000"

  done

}

export_blocks() {
  local start="${1:-10000000}"
  local limit="${2:-100}"
  mkdir -p raw
  gex "blockTransactions($start,$limit)" >  raw/$start-$limit
  ls raw/$start-$limit
}


gex() {
  GETH_DATADIR="${GETH_DATADIR:-$(geth_get_datadir)}"
  local instance="${1:-1}"
  local script="$2"
  local instances=( $(cat $ZSHAI_DATA/gth/instances ) )
#  echo $instances[$instance]
  GETH_DATA_DIR=$instances[$instance]

  [[ -z "$GETH_DATADIR" ]] && echo "no primary datadir configured" && return

  [[ -z "$script" ]] && {
    geth \
    --datadir $GETH_DATADIR \
    --jspath /root/geth/js \
    --preload lib.js,contracts.js \
    attach
  } || {
    geth \
    --datadir $GETH_DATADIR \
    --jspath /root/geth/js \
    --preload lib.js \
    attach \
    --exec "$script"
  }
}


geth_get_datadir() {
  [[ -f "$ZSHAI_DATA/gth/current-datadir" ]]&& {
    cat $ZSHAI_DATA/gth/current-datadir
  } || {
    [[ ! -z $GETH_DATADIR ]] && echo $GETH_DATADIR || {
      echo "/root/.ethereum/default"
    }
  }
}

geth_set_datadir() {

  export GETH_DATADIR="$1"
  echo $1 > $ZSHAI_DATA/gth/current-datadir
  echo "Primary geth datadir set to: $1"
}
