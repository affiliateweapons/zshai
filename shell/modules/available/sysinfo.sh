alias distro="cat /etc/*release"

distro_vars(){
  eval "$(cat /etc/*release)"
  echo $UBUNTU_CODENAME
}

state_log_systemctl_inactive() {
  distro_vars
  local state_dir=$ZSHAI_DATA/state/ubuntu/$VERSION_ID
  echo $state_dir
}
