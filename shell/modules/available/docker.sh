# docker aliaes anad functions
rlc() {
  for i in  $(docker  ps -qn $i ); drm $i  
}
drd() {
  local name=${1}
  local image=${2:-$1}
  sudo docker run --name $name -d -it $image

}
drmi() {
  sudo docker rmi $1
  #dim
}
drmf() {
  sudo docker rm -f $1
#  dcl
}
# docker
build() {
[[ -d "build" ]] && cd build && return 

[[ -f "build.sh" ]] &&  . ./build.sh
}
#alias build=". ./build.sh"
alias run=". ./run.sh"
alias remove=". ./remove.sh"
alias dh='docker history --format="{{.CreatedBy}}" --no-trunc'
alias docker="sudo docker"
alias docker-compose="sudo docker-compose"
alias dcm="docker-compose"
alias dcb="docker-compose build"
alias dm="docker images"
alias dma="docker images -a --no-trunc"
alias drm="docker rm"
alias dim="docker images --format=\"table {{.CreatedAt}}\t{{.Repository}}\t{{.Tag}}\t{{.ID}}\t\t{{.CreatedSince}}\t{{.Size}}\" | (sed -u 1q; sort -k 1 )"
alias di="docker image"
alias dis="docker inspect"
alias dc="docker container"
alias dcl="docker container ls -a"
alias dlc="docker container ls -a"
alias dli="docker images -a"
alias dins="docker inspect "
alias dcls="dlc --format=\"{{.Size}} {{.Image}}\" -a"
alias dps="docker ps -a"
alias d="docker"
alias dx="docker exec -it"
alias dxr="docker run -it --rm"
alias dpra="docker prune -a"
alias db="docker_build"
alias dp="docker pull"
alias dks="docker stop"
alias dl="docker logs"
alias dlt="docker logs tail"
alias di="docker inspect"
alias drs="docker search"
#alias drum="docker run --rm"
alias dsp="docker stop  portainer"
# docker-compose
alias dcu="docker-compose up -d"
alias dcd="docker-compose down"
# docker cd
alias dv="cd /var/lib/docker/volumes/"
alias dk="cd ~/docker"
# docker exec
alias alpine="dx alpine sh"
alias dubu="dx ubuntu sh"
alias pu="docker start portainer"
# docker stop and remove


docker_rm() {
docker stop $1
docker rm  $1

echo "$1 has been removed"
}

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
alias dbsh="dockerbash"
alias dzsh="dockerzsh"
alias dsh="dockersh"

docker_containers_json() {
  docker ps -a --format "{{.ID}}\t{{.Names}}\t{{.Image}}" | column -t -J --table-columns "id,names,image"  
}
export_image_inspect(){ 
  for i in $(docker images -a -q);docker inspect $i > /tmp/inspect$i.json 

  cd /tmp/inspect
  cat $('ls') > all.json 

# list all layers
#cat $('ls') | gron | grep Layers
}
list_overlay_hashes() {
  sudo find /var/lib/docker/overlay2 -maxdepth 1 -type d  
}
