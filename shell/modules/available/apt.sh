alias sai="sudo apt install"

apt_upgrade() {
  local upgrades=$(mktemp /tmp/upgrades.XXXXX)
  apt list --upgradeable > $upgrades
  for i in $(cat $upgrades | sed 's/\/.*//g'); apt-get install $i -y 

  rm "$upgrades"

}
