alias getc="cd /etc/;sudo git status"
alias gs="git status"
alias sgs="sudo git status"
alias gc="git commit -m"
alias ga="git add ."
alias gp="git pull"
alias sgp="sudo git pull"
alias gpush="git push"
alias sgit="sudo git"
alias sginit="sudo git init"
alias sga="sudo git add ."
#alias sgc="sudo git commit -m"

gac() {
  gs
  local answer="y"
  vared -p "Add all? [y/n]: " -e answer

  [[ $answer != "y" ]] && echo "Aborting" && return
  local msg
  vared -p "Commit message: " -e msg


  [[ -z $msg ]] && echo "No commit message, aborting" && return

  sudo git add .
  sudo git commit -m $msg
}
