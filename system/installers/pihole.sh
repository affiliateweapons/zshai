#!/bin/bash

# https://github.com/pi-hole/docker-pi-hole/blob/master/README.md
DEFAULT_IP="172.17.0.3"

read -p "Specify pi-hole data dir: " -i "/data/pihole/" -e installdir
read -p "Specify pi-hole server IP: " -i "${DEFAULT_IP}" -e IP

[[ ! -e "$installdir" ]] && echo "$installdir does not exist" && exit
[[ -z "$installdir" ]] && echo "empty data dir " && exit

echo "Setting up in: $installdir"

PIHOLE_BASE="${PIHOLE_BASE:-$installdir}"

[[ -d "$PIHOLE_BASE" ]] || mkdir -p "$PIHOLE_BASE" || { echo "Couldn't create storage directory: $PIHOLE_BASE"; exit 1; }

# Note: ServerIP should be replaced with your external ip.
sudo docker run -d \
    --name pihole \
    -p 53:53/tcp \
    -p 53:53/udp \
    -p 67:67/udp \
    -p 80:80 \
    -p 443:443 \
    -e TZ="Asia/Bangkok" \
    -v "${PIHOLE_BASE}/etc-pihole/:/etc/pihole/" \
    -v "${PIHOLE_BASE}/etc-dnsmasq.d/:/etc/dnsmasq.d/" \
    --dns="${IP}" --dns=1.1.1.1 \
    --restart=unless-stopped \
    --hostname pi.hole \
    -e VIRTUAL_HOST="pi.hole" \
    -e PROXY_LOCATION="pi.hole" \
    -e ServerIP="${IP}" \
    pihole/pihole:latest

printf 'Starting up pihole container '
for i in $(seq 1 20); do
    if [ "$(sudo docker inspect -f "{{.State.Health.Status}}" pihole)" == "healthy" ] ; then
        printf ' OK'
        echo -e "\n$(sudo docker logs pihole 2> /dev/null | grep 'password:') for your pi-hole: https://${IP}/admin/"
        exit 0
    else
        sleep 3
        printf '.'
    fi

    if [ $i -eq 20 ] ; then
        echo -e "\nTimed out waiting for Pi-hole start, consult your container logs for more info (\`docker logs pihole\`)"
        exit 1
    fi
done;
