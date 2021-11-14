create_install() {
  nano $ZSHAI/installs/$1.sh
  cx $ZSHAI/installs/$1.sh
}

alias cif="create_install"
alias is="cat $ZSHAI_DATA/installs"
