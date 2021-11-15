# disable error reporting service in the background
sudo systemctl mask whoopsie.service
sudo systemctl disable whoopsie.service
sudo systemctl stop whoopsie.service
