# scan your servers for open ports
netcat_port() {
  local host="$1"
  local port="$2"
  nc -w 1 -zv $host $port   2>&1 | grep succeeded
}

netcat_portscan() {
  local ports=${2:-22,80,443}
  nc -w 1 -zv $ports   2>&1 | grep succeeded
}
