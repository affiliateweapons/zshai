# for fsindex
alias getc="cd /etc/;sudo git status"
alias gco="git checkout"
alias gdiff="cd /etc/;git diff;cd -"
alias gcom="cd /etc/;sudo git commit"
alias gadd="cd /etc;sudo git add ."

alias gs="git status --column=auto"
alias gic="git clone"
alias sgs="sudo git status"
alias gtc="git commit -m"
alias ga="git add ."
alias gp="git pull"
alias sgp="sudo git pull"
alias gpush="git push"
alias gpu="git push"
alias sgit="sudo git"
alias sginit="sudo git init"
alias sga="sudo git add ."
#alias sgc="sudo git commit -m"

gac() {
  sgs
  local answer="y"
  vared -p "Add all? [y/n]: " -e answer

  [[ $answer != "y" ]] && echo "Aborting" && return
  local msg
  vared -p "Commit message: " -e msg


  [[ -z $msg ]] && echo "No commit message, aborting" && return

  sudo git add .
  sudo git commit -m $msg
}


gitrepos() {
  find * $1 2>/dev/null  | grep .git$  2>/dev/null
}


find_gitclones() {
 history | grep  " git clone http.*github" > git_repos.csv
}

git_repo_list() {
  for d in ` command 'find' . -name .git -type d 2>/dev/null`
  do
    echo $d
  done
}

zle -N .git-pull
# ALT + DOWN
bindkey "^[[1;3B" .git-pull
function .git-pull() {
  [[ -d ".git" ]] && {
    git pull
  } || {
    echo "no git directory"
  }
	emulate -L zsh
	printf '%s' ${terminfo[smkx]}

}

function .git-push() {
  [[ -d ".git" ]] && {
    git push
  } || {
    echo "no git directory"
  }
  zle-end
}
zle -N .git-push
# ALT + UP
bindkey "^[[1;3B" .git-push




gitignore() {
  [[ -f ".gitignore" ]] && nano ".gitignore"
}
