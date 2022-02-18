#!/bin/bash
# usage: ~/zshai/setup.sh
ZSHAI="$HOME/zshai"
ZSHAI_DATA="$HOME/.zshai"

env=$(cat .zshai.env)
echo $env

core_tools=( git zsh net-tools nano jq xclip )

linuxdistro() {
  [[ ! -z "$(fgrep centos /etc/os-release)" ]] && echo "centos" && return
  [[ ! -z "$(fgrep ubuntu /etc/os-release)" ]] && echo "ubuntu" && return
  [[ ! -z "$(fgrep debian /etc/os-release)" ]] && echo "debian" && return
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
[[ ! -e "$ZSHAI_DATA/servers" ]] && {
  dirs=( servers logs db api list config domains sitemaps gpg secrets plugins last ds )

  for i in $dirs; do
    mkdir -p "$ZSHAI_DATA/$i"
  done

  files=( enabled aliases.sh )
  for i in $files; do
    touch "$ZSHAI_DATA/$i"
  done
}

