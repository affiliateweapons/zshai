mine_xmr() {
  cmd=$(where xmrig)
  $cmd -c $ZSHAI_DATA/miner/xmr/config.json -o sg.minexmr.com:4444 -u 43BJAw9m9qiaxix1SoYXixCtR5PHntABqEKBJY3948EHDcXdLp37W4zMbRjo9TwJ4QiZnno1FPBsQBxyG6c7dujY1TRFzq8 -k --coin monero
}

deploy_xmr_config() {
  local walletfile=$ZSHAI_DATA/miner/xmr/wallet
  local tmp=$(mktemp)
  cat $ZSHAI_DATA/miner/xmr/config.json | sed 's/rig-id.*/rig-id": \"'$1'\",/' > $tmp
  echo "Deploying config file: ~/.zshai/miner/xmr/config.json"
  echo "to server: $1:/root/.zshai/miner/xmr/config.json"
  echo "wallet file: $walletfile"
  echo "wallet address: $(cat $walletfile)"
  sshx $1 mkdir -p /root/.zshai/miner/xmr 2>/dev/null
  rsync -r $tmp  $1:/root/.zshai/miner/xmr/config.json
  scp $walletfile $1:/root/.zshai/miner/xmr/wallet
  sshx $1 ls /root/.zshai/miner --recursive 2>/dev/null
}

xmr_wallet() {
  cat $ZSHAI_DATA/miner/xmr/wallet
}
alias dxc="deploy_xmr_config"


xmr_hashrate() {
  [[ ! -f $ZSHAI_DATA/miner/xmr/wallet ]] && echo "no wallet file found" && return

  local wallet=$(cat $ZSHAI_DATA/miner/xmr/wallet)
  echo "Wallet: $wallet"

  curl  "https://minexmr.com/api/main/user/workers?address=$wallet"
}

xmr_rigid() {
  cat $ZSHAI_DATA/miner/xmr/config.json  | grep rig-id
}
