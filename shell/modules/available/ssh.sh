# copy ssh key to server

alias sci="ssh-copy-id"

# deploy Zsh.AI folder to remote server
deploy_zshai() {
  local server="$1"
  [[ -z "$1" ]] && echo "Usage: deploy_zshai [server]" && return
  # use rsync to only copy new files and create folders if needed
  rsync -rzvl $ZSHAI $1:/root
}
alias dz="deploy_zshai"


# deploy zshai to all servers in the "deploy" list .
# you can also specify a different list, for example:
# - dza vultr
# - dza digitalocean
# make sure you the server list files in $ZSHAI_DATA/servers
dza() {
  local server_list=${1:-deploy}
  local servers=( $(cat $ZSHAI_DATA/servers/$server_list) )
  for i in ${servers}; do
    echo  "deploying to: $i"
    deploy_zshai $i
  done
}

# deploy .zshrc to remote server
dzshrc() {
  scp ~/.zshrc $1:/root
}

# remote ssh execute 
sshx() {
  ssh -t $@
}
alias rsx="sshx"

# multi ssh execute command
msx() {
  local servers=( $(cat $ZSHAI_DATA/servers/deploy) )

  [[ -z $1 ]] && {
    cmd="ls --color=auto"
    vared -p "Command: " -e  cmd
  } || cmd=$@

  for i in ${servers}; do
    echo "Connecting to: $i"
    echo "Executing command: $cmd"
    ssh -t $i $cmd 2>/dev/null
    echo "--"
  done
}

# deploy your server empire to a remote server so that you can connect to your empire from a remote server
teleport_empire() {
  scp /etc/ssh/ssh_config.d/empire.conf $1:/etc/ssh/ssh_config.d/empire.conf
}
alias te="teleport_empire"


#  switch ssh profile
set_ssh_profile() {
  # drwx------ 700 folder
  # -rw------- 600 id_rsa
  # -rw-r--r-- 644 id_rsa.pub

  [[ -z "$1" ]] && echo "Usage: set_ssh_profile [profile]" && return

  local profile=~/.ssh/profiles/$1
  cp $profile/id_rsa ~/.ssh/
  cp $profile/id_rsa.pub ~/.ssh
  echo "$1" > ~/.ssh/current_profile
  current_ssh_profile
}

# display current active ssh profile
current_ssh_profile() {
  echo "current profile is"
  cat ~/.ssh/current_profile
}

# aliases to switch ssh profiles
# @todo move this to local zshai data folder
alias ssp="set_ssh_profile"
alias sp1="set_ssh_profile soulforce"
alias sp2="set_ssh_profile vulnevasion"
alias sp3="set_ssh_profile mongodb"

alias csp="current_ssh_profile"

# connnect to remote deploy servers
# download the ssh profiles
download_profiles() {
  for i in $(servers deploy list); do
    echo $i
    mkdir $i
    rsync  -r $i:/root/.ssh/ $i
  done
}

# list the private keys after downloading the ssh profiles
# recommended to encrypt it afterwards using the "encrypt" command, otherwise delete the private keys.
find_private_keys() {
  find | grep id_rsa | grep -v "pub\|gpg"
}

# list the prublic keys after downloading the ssh profiles
find_public_keys() {
  find * | 'grep' id_rsa.pub
}


find_pub_keys() {
  for i in $(find * | grep pub)
  do
    echo "Pub Key File: $i"
    cat $i
  done
}

display_all() {
  for i in $(find *  -type f ! -type d )
  do
    echo "File: $i"
    cat $i
  done
}

alias spk="cat ~/.ssh/id_rsa.pub"



numbered() {
i=0
choices=( $(echo $1) )
for choice in $choices
do
  (( i++ ))
  echo "$i) $choice"
done
}

add_key() {
local profiles=$('ls' ~/.ssh/profiles -p | grep '/')

numbered $profiles

local key=""

vared  -p "Which SSH key profile would you like to deploy? " -e key

local servers="$(servers deploy list)"

local server=""
echo  $servers
vared  -p "Which server? " -e server


local answer="y"
vared -p  "Deploy profile $select to $server ? y/n "  -e answer

[[ $answer = "y" ]] && {

  echo $profiles[$
  echo "SSH key deployment complete"
} && echo "Aborting"

}


ssh_keygen() {

[[ -z $1 ]] && echo "No profile name given" && return


local profile=~/.ssh/profiles/$1
[[ -e $profile ]] && {
  echo "profile $1 is taken" && return  
} || {

  mkdir -p $profile
}

ssh-keygen -f $profile/id_rsa

}
