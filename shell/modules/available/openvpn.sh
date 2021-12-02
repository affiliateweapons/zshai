show_ip() {
  curl icanhazip.com
}

stop_vpn() {
  systemctl stop openvpn@$VPN_PROFILE
}

start_vpn() {
  echo "Start VPN profile: $VPN_PROFILE"
  systemctl start openvpn@$VPN_PROFILE
}

set_vpn() {
  export VPN_PROFILE=$1
}

vpn_status() {
  echo $VPN_PROFILE
}
alias vps="vpn_status"


vp() {

items=$(cat <<EOF
Start VPN


EOF
)

echo $items | fzf


}


start_openvpn() {
  local profile=${1:-home}
  sudo openvpn $profile.ovpn
}
