# create a crypto wallet
#@todo bitcoin wallet
#@todo ethereum wallet
wallet() {
  local storage=$ZSHAI_DATA/wallets/monero

  wallets=( Monero Bitcoin Ethereum )
  cat <<EOF
1) Monero
2) Bitcoin
3) Ethereum
EOF

  local wallet=1

  vared -p "Choose wallet: " -e wallet


  [[ -z $wallet ]] && echo "Aborting" && return

  echo "Creating new wallet for: $wallets[$wallet]"
  mkdir -p $storage


  local name=$USER
  vared -p "Name of your wallet: " -e name

  name=$(echo $name | tr -cd '[:alnum:]._-')

  local file=$storage/$name
  [[ -f $file.gpg ]] && echo "Wallet already exists: $file" && return

  local seed=""
  vared -p "Enter 25 words seed key: " -e seed



  # store seed
  echo $seed > $storage/$name
  echo "Stored seed in: $file"
  encrypt  $file
  echo "Encrypted with GPG: $file.gpg"
}


alias cdwallets="cd $ZSHAI_DATA/wallets"
alias cmuw="cd $ZSHAI_DATA/wallets/monero/$USER"
