# core aliases and functions
export ZSHAI_MODULES_DIR="$ZSHAI/shell/modules"
export ZSHAI_MODULES_AVAILABLE="$ZSHAI_MODULES_DIR/available"
alias h="cd /home/$USER"
alias zdr="cd $ZSHAI_DATA;ls"
alias restart="source $ZSHAI/init.sh"

# hosts
alias ehf="sudo nano /etc/hosts"
alias edh="sudo nano /etc/hosts"
alias shc="sudo nano /etc/ssh/ssh_config.d/empire.conf"

# edit and source core aliases and functions
alias ea="nano $ZSHAI/core.sh;source $ZSHAI/core.sh"

# edit and source zshrc
alias ezc="nano ~/.zshrc;source ~/.zshrc"

# grep
alias gr="grep --color=auto"
alias fgr="fgrep --color=auto"
alias egr="egrep --color=auto"


# rm
alias srm="sudo rm -R"

# filesystem
alias ds="sudo du -h -d 1"
function td() {
  mkdir -p $1
  cd $1
}


# we use an alias function so that we can 
# capture the aliases for later use when you want to disable certain aliases
zshai_alias() {
  alias "$1"
  [[ ! -z $ZSHAI_DEBUG_LOG_ALIAS_SETUP ]] && echo "Setting alias: $1" | zshai_log aliases
}

zshai_log() {
  local type="$1"
  local message=$(cat /dev/stdinput)
  [[ ! -z "$type" ]] && {
    logfile="$ZSHAI_DATA/log/$type"
    [[ ! -e $logfile ]] && { 
      touch $logfile
      echo $message >> $ZSHAI_DATA/log/$type
    }
  }

}

# helper function validating required parameters
req1() {
  [[ -z "$1" ]] && {
    echo "No params" &&  return  0
  } || return 1
}

# modules
load_module() {
  local module=${1}
  local module_file=$ZSHAI_MODULES_DIR/enabled/$1.sh
  [[ ! -f ${module_file} ]] && echo "${module_file} not found"
}

load_modules() {
  for i in $('ls' $ZSHAI_MODULES_DIR/enabled);source  $ZSHAI_MODULES_DIR/enabled/$i
}

# edit-module
edit_module() {
  [[ -z "$1" ]] && echo  "Usage: edit_module [module]" && return

  local f="$ZSHAI_MODULES_DIR/available/$1.sh"
  nano "$f"
  [[ -e "$f" ]] && {
    source  "$f"
    echo $1 enabled
    enable_module $1
  } || {
    echo "aborted creating $1"
  }
}

# alias for edit_module
alias em="edit_module"


# modules are enabled by symlinking from the modules/available folder
enable_module() {
  local module=${1}
  local module_file_source=$ZSHAI_MODULES_DIR/available/$1.sh
  local module_file_target=$ZSHAI_MODULES_DIR/enabled/$1.sh

  [[ ! -e ${module_file_source} ]] && echo ${module_file_source} "not found" || {
    [[ -e ${module_file_target} ]] && return
    ln -s ../available/$1.sh ${module_file_target}
    echo "$1 module enabled"
  }
}

# modules are disable by removing the symlink
disable_module() {
  local module=${1}
  local module_file_source=$ZSHAI_MODULES_DIR/available/$1.sh
  local module_file_target=$ZSHAI_MODULES_DIR/enabled/$1.sh
  [[ ! -e ${module_file_target} ]] && echo "${module_file_target} not found "  \
  ||  rm ${module_file_target}
}

# list the available/enabled modules
list_modules() {
  [[ -z "$1" ]] && 'ls' $ZSHAI_MODULES_DIR/available \
  || 'ls' $ZSHAI_MODULES_DIR/enabled
}

alias cdm="cd $ZSHAI_MODULES_DIR/available;ls"
alias cdme="cd $ZSHAI_MODULES_DIR/enabled;ls"
alias lma="list_modules "
alias lme="list_modules enabled"
alias emo="enable_module"
alias dmo="disable_module"

# this loads all enabled modules in  $HOME/zshai/modules/enabled
load_modules


# server empire
alias ehc="sudo nano /etc/ssh/ssh_config.d/empire.conf"

# ssh
alias sk="cat ~/.ssh/id_rsa.pub | xclip"

# source a script file
alias src="source"

# cllipboard
alias xclip="xclip -selection c"

# nano
alias lnr="ls /usr/share/nano"

#@todo combine with GPG encryption
alias ep="nano ~/.zshai/creds/.passwords"

# exit
alias x="exit"



# ls
alias lsh="'ls' --help"
alias l="'ls' -1"
alias l="ls"
alias lsn="'ls' -1"
alias ls="'ls' -lsAtrhp --color=auto --group-directories-first"
alias lsr="'ls' --recursive"
alias lls="l -p --color=auto"
alias ll="ls"
alias cl="clear"
