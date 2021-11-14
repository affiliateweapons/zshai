#!/bin/bash
# usage: ~/zshai/setup.sh
env=$(cat .zshai.env)
echo $env

core_tools=( git zsh net-tools xclip )

linuxdistro() {
  [[ ! -z "$(fgrep centos /etc/os-release)" ]] && echo "centos"
  [[ ! -z "$(fgrep ubuntu /etc/os-release)" ]] && echo "ubuntu"
  [[ ! -z "$(fgrep debian /etc/os-release)" ]] && echo "debian"
}

# check if distro is Ubuntu or CentOs
distro="$(linuxdistro)"

case $distro in
ubuntu)
    sudo apt install git zsh net-tools xclip  -y
  ;;
debian)
    sudo apt install git zsh net-tools xclip  -y
  ;;
centos)
    sudo yum install git zsh net-tools xclip -y
  ;;

*)
  echo "Unsupported OS: "
  cat /etc/*release
  exit
  ;;
esac


# install core tools
chsh -s $(which zsh)

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# create zshai local data folders
[[ ! -e ~/.zshai/servers ]] && {
  dirs=( servers logs db api list config domains sitemaps )

  for i in $dirs; do
    mkdir -p ~/.zshai/$i
  done
}

