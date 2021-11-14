state_log_dir=~/.zshai/config/ubuntu/21.10/

state_log_open_ports() {
  nsl > $state_log_dir/open-ports.out
}
