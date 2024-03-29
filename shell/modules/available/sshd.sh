# short cut to change default ssh port to 689
sshsec() {
  local NEW_SSH_PORT=689

  [[ ! -f /etc/resolv.conf ]] && {
    echo "ERROR: no /etc/resolv.conf file found. Aborting."
    return
  }
  
  eval $(cat /etc/*release);
  [[ $NAME != "Ubuntu" ]] && echo "Only Ubuntu supported" && return

  confirm=y;vared -p "Are you you want to change SSH port to $NEW_SSH_PORT? y/n: " confirm

  [[ $confirm != "y" ]] && return

  echo "Open port $NEW_SSH_PORT"
  echo "Changing SSH port to $NEW_SSH_PORT"
  cp /etc/ssh/sshd_config /etc/ssh/sshd_config.old
  echo > /etc/ssh/sshd_config

  # include configs  from ubuntu 20.04
  eval $(cat /etc/*release);[[ $VERSION_ID -ge "20.04" ]] &&  {
    echo 'Include /etc/ssh/sshd_config.d/*.conf' > /etc/ssh/sshd_config
  }

  cat  $ZSHAI/lib/skel/etc/ssh/sshd_config >> /etc/ssh/sshd_config

  echo "Restarting SSH daemon"
  ufw enable
  sudo systemctl restart sshd
  echo "Confirm that SSH is listening to port 689"
  nsl | grep sshd 



}
