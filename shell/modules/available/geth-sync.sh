geth-sync() {

  mkdir -p /root/geth/js/
  mkdir -p /root/geth/nodes/
  ln -s /usr/local/bin/geth-1.15.20211226 /usr/local/bin/geth

  rsync -avr eth2:/mnt/disks/eth/geth/nodes/ /root/geth
  rsync -avr eth2:/root/.ethereum/snapshot-light /root/.ethereum/
  rsync -avr eth2:/mnt/disks/eth/geth/js/lib.js /root/geth/js/lib.js
  rsync -avr eth2:/usr/local/bin/geth-1.15.20211226 /usr/local/bin
}

export DATADIR="/root/.ethereum/snapshot-light"

geth_bg() {
  nohup geth-1.15.20211226 --pcscdpath= --datadir=$DATADIR --syncmode=light --preload=/root/geth/js/lib.js \
  |& cat > /root/.ethereum/snapshot-light.log & disown
}
geth_logs() {
  tail -f  $DATADIR.log
}
geth_attach() {
  geth-1.15.20211226 --datadir=$DATADIR attach $@  
}
