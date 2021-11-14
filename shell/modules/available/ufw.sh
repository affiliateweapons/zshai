ufw_open() {
  local port="${1:-689}"
  sudo ufw allow $port/tcp comment "Open port ssh tcp port $port"
}
