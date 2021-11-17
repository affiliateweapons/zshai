# docker aliaes anad functions
# docker
alias docker="sudo docker"
alias docker-compose="sudo docker-compose"
alias dcb="docker-compose build"
alias dm="docker images"
alias dma="docker images -a --no-trunc"
alias drmi="docker rmi"
alias dim="docker images"
alias di="docker image"
alias dis="docker inspect"
alias dc="docker container"
alias dcl="docker container ls -a"
alias dlc="docker container ls -a"
alias dli="docker images -a"
alias dps="docker ps -a"
alias d="docker"
alias dx="docker exec -it"
alias dxr="docker --rm exec -it"
alias dpra="docker prune -a"
alias db="docker_build"
alias dp="docker pull"
alias dks="docker stop"
alias dl="docker log"
alias dlt="docker log tail"
#alias drum="docker run --rm"
# docker-compose
alias dcu="docker-compose up"
alias dcd="docker-compose down"
# docker cd
alias dv="cd /var/lib/docker/volumes/"
alias dk="cd ~/docker"

# docker exec
alias alpine="dx alpine sh"
alias dubu="dx ubuntu sh"

# docker stop and remove
docker_rm() {
docker stop $1
docker rm  $1

echo "$1 has been removed"
}
alias drm="docker_rm"
# docker pull ${image}latest
dpl() {
  req1 $1 && return 
  local version=$1':latest'
  docker pull  $version
}

# inspect images
docker_inspector() {
local  docker_images=$(docker images -qa)
echo $docker_images
#  sudo docker inspect $(docker images -qa)  | gron  | fzf -e -i --ansi --no-sort
}
alias dis="docker_inspector"


docker_build() {
  [[ -z $DOCKER_IMAGE_NAMESPACE ]] && \
    docker build -t $1 . \
  || docker build -t $DOCKER_IMAGE_NAMESPACE/$1 .
}

dockerfile() {
echo "New Dockerfile"
ls $ZSHAI/containers/dockerfiles;
}

docker_volume_create() {
  docker volume create $1
}
alias dvc="docker_volume_create"

docker_run_rm() {
docker run --rm $@
}
alias drum="docker_run_rm"

dockerbash() {
  docker exec -it $1 bash
}

dockerzsh() {
  docker exec -it $1 zsh
}
dockersh() {
  docker exec -it $1 sh
}
