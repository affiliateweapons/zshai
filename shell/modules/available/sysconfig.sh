state_log_systemctl_inactive() {
  systemctl --all | grep inactive > $ZSHAI_DATA/systemctl-inactive.out
}
