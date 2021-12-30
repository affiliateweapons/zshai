alias ipf="ip a"
alias ip="ip a | grep global"



ips(){
grep -a -E "([0-9]{1,3}\.){3}[0-9]{1,3}\b" $@
}
