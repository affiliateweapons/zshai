alias ipf="ip a"
alias ip="ip a | grep global"

ips(){
  grep -a -E "([0-9]{1,3}\.){3}[0-9]{1,3}\b" $@
}

ipthis() {
  #  curl -s https://ip2.sh
  curl icanhazip.com
}

myip() {
  curl icanhazip.com
}
