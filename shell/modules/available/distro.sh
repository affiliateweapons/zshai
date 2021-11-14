linuxdistro() {
  [[ ! -z "$(fgrep centos /etc/os-release)" ]] && echo "centos"
  [[ ! -z "$(fgrep ubuntu /etc/os-release)" ]] && echo "ubuntu"
}

