doctl() {
  apikey=$(decrypt $ZSHAI_DATA/gpg/apikeys/doctl.gpg)
  docker run --rm --interactive --tty --env=DIGITALOCEAN_ACCESS_TOKEN="$apikey" doctl $@
}

alias dpg="doctl projects get"
alias dopr="doctl projects resources"
alias dol="doctl compute droplet list"
