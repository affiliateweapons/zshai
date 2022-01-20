# core aliases and functions\
#echo "ZSHAI=$ZSHAI"
export ZSHAI_MODULES_DIR="$ZSHAI/shell/modules"
export ZSHAI_MODULES_AVAILABLE="$ZSHAI_MODULES_DIR/available"
alias h="cd /home/$USER"
alias zdr="cd $ZSHAI_DATA;ls"
alias restart="source $ZSHAI/init.sh"
alias zs="cd ~/zshai;ls"
alias zsu="cd ~/zshai;git pull"
# hosts
alias ehf="sudo nano /etc/hosts"
alias edh="sudo nano /etc/hosts"
alias shc="sudo nano /etc/ssh/ssh_config.d/empire.conf"

# edit and source core aliases and functions
alias ea="nano $ZSHAI/core.sh;source $ZSHAI/core.sh"

# edit and source zshrc
alias ezc="nano ~/.zshrc;source ~/.zshrc"
alias ezn="nano ~/.zshenv;source ~/.zshenv"
# grep
alias gr="grep --color=auto --exlude-dir='/opt/containerd*/' --exclud-dir='*.git*' "
alias fgr="fgrep --color=auto"
alias egr="egrep --color=auto"


# rm
alias srm="sudo rm -R"

function td() {
  mkdir -p $1
  cd $1
}

restore-ifs() {
  IFS=$'\n'
}

# we use an alias function so that we can 
# capture the aliases for later use when you want to disable certain aliases
zshai_alias() {
  alias "$1"
  [[ ! -z $ZSHAI_DEBUG_LOG_ALIAS_SETUP ]] &&  zshai_log aliases "Setting alias: $1"
}

zshai_log() {

  [[ -z "$ZSHAI_DEBUG_LOG_ALIAS_SETUP" ]] && return
  local type="$1"
#  local message="$(cat /dev/stdin)"
  local message="${2}"
  is_interactive=$(printenv IT)
  [[  -z is_interactive ]] && return
  echo "funcfiletrace: $funcfiletrace"
  echo "Log: $type"
  echo "Message: $message"
  [[ ! -z "$type" ]] && {
    local logfile="$ZSHAI_DATA/log/$type"
    echo "Adding to logfile: $logfile"
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
  local module="${1}"
  local module_file="$ZSHAI_MODULES_DIR/enabled/$1.sh"
  [[ ! -f "${module_file}" ]] && echo "${module_file} not found"
}

load_modules() {
  restore-ifs
  local c=( enabled private );
  for i in $c
  do
    local d="$ZSHAI_MODULES_DIR/$i"
    [[ -d "$d" ]] && {
      for i in $('ls' "$d")
      do
        source "$d/$i"
      done
    }
  done
}

# edit-module
edit_module() {
#  echo "param ="$ZSHAI_MODULES_DIR
#  return
  local module="$1"
  export type="${2:-available}"
  [[ -z "$1" ]] && [[ -z "$LAST_MODULE" ]] && echo  "Usage: edit_module [module]" && return
  [[ -z "$1" ]] && [[ ! -z "$LAST_MODULE" ]] && echo "$LAST_MODULE" && module="$LAST_MODULE"

  local f="$ZSHAI_MODULES_DIR/$type/$module.sh"
  $commands[nano] "$f"

  [[ -f "$f" ]] && {
    export LAST_MODULE="$module"
    echo "$f"
    source  "$f"

    [[ ! "$type" = "private" ]] && {
      echo "✔️  module $module  [enabled]"
      enable_module "$module" "$type"
    }
  } || {
    echo "aborted creating $1"
  }
}

# alias for edit_module
alias em="edit_module"
lm() {
  clear
  local script="$ZSHAI_MODULES_DIR/available/$1.sh"

  [[ -f "$script" ]] && source "$script"
  $1
}


# modules are enabled by symlinking from the modules/available folder
enable_module() {
  local module="${1}"
  local type="$2"
  local module_file_source="$ZSHAI_MODULES_DIR/$type/$1.sh"
  local module_file_target="$ZSHAI_MODULES_DIR/enabled/$1.sh"

  [[ ! -e "${module_file_source}" ]] && echo "${module_file_source}" "not found" || {
    [[ -e "${module_file_target}" ]] && return

    ln -s "${module_file_source}" "${module_file_target}"
    echo "Creating symbolic link ${module_file_source} ${module_file_target}"
    echo "$1 module enabled"
  }
}

# modules are disable by removing the symlink
disable_module() {
  local module=${1}
  local module_file_source=$ZSHAI_MODULES_DIR/available/$1.sh
  local module_file_target=$ZSHAI_MODULES_DIR/enabled/$1.sh
  [[ ! -e ${module_file_target} ]] && echo "${module_file_target} not found "  \
  ||  rm ${module_file_target} && echo "symbolic link removed: ${module_file_target}"
}

commit_module() {

  local module_file_source=$ZSHAI_MODULES_DIR/available/$1.sh
  local module_file_target=$ZSHAI_MODULES_DIR/enabled/$1.sh
  local opts="$2"
  [[ "$opts" = "-p" ]] && echo "push after=true" && push_after="true" 

  [[ ! -f $module_file_source ]] &&  echo "$1 does not exist" && return
  echo "git diff $module_file_source"
  cd $ZSHAI;git diff $module_file_source
  local answer="y"
  vared -p "Commit $1? [y/n] " -e answer
  [[ $answer != "y" ]] && return
  local message="update function $1"
  vared -p "git commit message: $1 ?  (ctrl-c to abort):  " -e message
  [[ ! -z $message ]]  && {
    cmd="git add $module_file_source"
    echo $cmd;eval $cmd
    git add $module_file_source 
    git commit -m "$message"
  } || { echo "Aborted. Nothing was d" }


    [[ ! -z "$push_after" ]] && git push
#    git add $module_file_target && \
}

alias cm="commit_module"

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



