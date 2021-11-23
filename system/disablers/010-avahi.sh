#sudo update-rc.d -f avahi-daemon remove
systemctl disable avahi-daemon.socket
systemctl disable avahi-daemon.service

