#!/usr/bin/env zsh

install_openvpn() {
  OVPN_SERVER="ghost.eternal.sh"
  vared -p  "Open VPN server domain:  "  -e OVPN_SERVER
  [[ ! -z $OVPN_SERVER ]] && {
    docker volume create --name $OVPN_DATA
    docker run --name $OVPN_DATA -v /etc/openvpn busybox
    docker run --volumes-from $OVPN_DATA --rm kylemanna/openvpn ovpn_genconfig -u udp://$OVPN_SERVER:1194
    docker run --volumes-from $OVPN_DATA --rm -it kylemanna/openvpn ovpn_initpki
  }
}

generate_cert() {
  local CLIENT="${1:-home}"
  docker run --volumes-from $OVPN_DATA --rm -it kylemanna/openvpn easyrsa build-client-full $CLIENT nopass
  docker run --volumes-from $OVPN_DATA --rm kylemanna/openvpn ovpn_getclient $CLIENT > $CLIENT.ovpn
  install_openvpn $CLIENT
}

install_cert() {
  local CLIENT="${1:-home}"
  sudo apt-get install openvpn
  sudo install -o root -m 400 $CLIENT.ovpn /etc/openvpn/$CLIENT.conf
  sudo /etc/init.d/openvpn restart
}

handshake() {
  docker run -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
}

OVPN_DATA="ovpn-data"
vared -p  "Choose data folder:  " -e OVPN_DATA

[[ -e $OVPN_DATA ]] && {
  echo "$OVPN_DATA not empty"
  return
} || {
  install_openvpn \
  && handshake \
  && generate_cert \
  && install_cert
}
