alias snr="sudo service nginx restart"
alias cdngx="cd /usr/share/nginx/;ls"


addnginx() {
  domain="$1"
  [[ -z "$domain" ]] && echo "No domain specified" && return

  local webroot="/usr/share/nginx"
  local config="/etc/nginx/conf.d"
  local skel="$ZSHAI/lib/skel/nginx/server.conf"
  local domainconfig="/etc/nginx/conf.d/$domain.conf"
  mkdir $webroot/$domain \
  && cat $skel | sed 's/{DOMAIN}/$domain/g' > $domainconfig \
  && sudo service nginx restart \
  && cd /usr/share/nginx/$domain
  
}
