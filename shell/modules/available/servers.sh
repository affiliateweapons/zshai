servers() {  
  local list="${1:-list}"
  local serverlist="$ZSHAI_DATA/servers/$list"
  local switch="$2"

  [[ ! -e ${serverlist} ]] && {
    mkdir -p $ZSHAI_DATA/servers
    touch $ZSHAI_DATA/servers/list
  } || {

    case "$switch" in
    list)
      cat ${serverlist}
      ;;
    edit)
      nano $serverlist
      ;;
    *)
      server="$(cat ${serverlist} | fzf)"
      echo "Connecting to: $server"
      ssh "$server"
    esac;

  }
}

alias srvs="servers"

# multi run command on each server
mrun() {
  local cmd="$@"

  echo "Running command: $@"
  for i in "$(servers names list)"; do
  echo "Response from server: $i"
  ssh -t $i $@
  echo "================"
  #  ssh -t $i
  done
}

alias sd="servers deploy"
alias sde="servers deploy edit"
