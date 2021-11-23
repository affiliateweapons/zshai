# remote port scan 
# scan a port  through a remote ssh server
rps() {
  local SERVER="$(cat $ZSHAI_DATA/last/rc-host)"
  vared -p "Server: " -e SERVER
  local TARGET_HOST="${$(cat $ZSHAI_DATA/last/target-host):-localhost}"
  vared -p "Target host: " -e TARGET_HOST

  local PORTS="${$(cat $ZSHAI_DATA/last/ports):-80}"
  vared -p "Scan ports: " -e  PORTS
  sshx $SERVER nc -w 1 -zv $TARGET_HOST $PORTS
}
