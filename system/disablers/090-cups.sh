# disable printer services if you don't use them
sudo systemctl disable cups-browsed
sudo systemctl stop cups-browsed
sudo systemctl mask cups-browsed
sudo systemctl disable cups
sudo systemctl stop cups
sudo systemctl mask cups
