# docker aliaes anad functions
# docker
alias docker="sudo docker"
alias docker-compose="sudo docker-compose"
alias dcb="docker-compose build"
alias dm="docker images"
alias dma="docker images -a --no-trunc"
alias drm="docker rm"
alias drmi="docker rmi"
alias dim="docker images"
alias di="docker image"
alias dis="docker inspect"
alias dcl="docker container ls -a"
alias dlc="docker container ls -a"
alias dli="docker ps -a"
alias dps="docker ps -a"
alias d="docker"
alias dx="docker exec -it"
alias dxr="docker exec -it -rm"
alias dpra="docker prune -a"
alias db="docker build -t"
alias dp="docker pull"
alias dks="docker stop"

# docker-compose
alias dcu="docker-compose up"
alias dcd="docker-compose down"
# docker cd
alias dv="cd /var/lib/docker/volumes/"
alias dk="cd ~/docker"

# docker exec
alias alpine="dx alpine sh"
alias dubu="dx ubuntu sh"

# docker pull ${image}latest
dpl() {
  req1 $1 && return 
  local version=$1':latest'
  docker pull  $version
}


# inspect images
docker_inspector() {
local  docker_images=$(docker images -qa)
echo $images
#  sudo docker inspect $(docker images -qa)  | gron  | fzf -e -i --ansi --no-sort
}
alias dis="docker_inspector"
