alias auth1k="tail -1000 /var/log/auth.log"
alias auth5k="tail -5000 /var/log/auth.log"


auth_ips() {
  cat /var/log/auth.log | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}\b"  | grep -v "$(cat $ZSHAI_DATA/exclusion/local-ips)"
}


ipgrep() {
  local text=$(cat /dev/stdin)
  echo $text | grep -E $1 "([0-9]{1,3}\.){3}[0-9]{1,3}\b" 
}
