# disable local default dns server
# it is better to run pi-hole as dns server
sudo systemctl stop systemd-resolved.service
sudo systemctl disable systemd-resolved.service
sudo systemctl mask systemd-resolved.service

echo "
nameserver 1.1.1.1
options edns0 trust-ad
search .
" > /tmp/resolv.conf
sudo cp /tmp/resolv.conf /etc/resolv.conf
rm /tmp/resolv.conf
