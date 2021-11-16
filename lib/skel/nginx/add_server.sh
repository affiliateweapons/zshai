#!/bin/bash
domain=$1
[[ -z $domain ]] && echo "No domain specified" && return
webroot=/usr/share/nginx
$config=/etc/nginx/conf.d
skel=$ZSHAI/lib/skel/nginx/server.conf
cp ./server.conf /etc/nginx/conf.d/$domain.conf

mkdir webroot/$domain
cat $skel | sed 's/{DOMAIN}/$domain/g' > $config
