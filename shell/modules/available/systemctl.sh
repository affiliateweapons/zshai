# shortcut to stop+disable+mask a service
sysdis() {
  sudo systemctl mask $1
  sudo systemctl disable $1
  sudo systemctl stop $1
}

syslist() {
  systemctl list-unit-files --type=service | grep enabled

  #sudo systemctl > /tmp/systemctl.out
  #cat /tmp/systemctl.out
}
sysres="sudo systemctl restart"


sysf() {
  systemctl list-unit-files --type=service  | grep $1
}
