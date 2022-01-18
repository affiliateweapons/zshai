export FORMAT_FULL="table{{.ID}}\t{{.Image}}\t{{.Command}}\t{{.Status}}\t{{.Size}}"

alias docs="docker search"
alias drunrm="docker run --network host --rm -it"
didep() {
  [[ -z "$1" ]] && return
  for i in $(docker images -q)
  do
      docker history $i | grep -q $1 && {
          docker images | grep  $i
      }
  done | sort -u
}
docker_stop() {
  systemctl {stop,mask} docker.socket
  systemctl {stop,disable,mask} docker.service
  systemctl {stop,disable,mask} containerd.service
  systemctl {stop,disable,mask} docker.{socket,service}
}
docker_enable() {
  systemctl enable docker{.socket,.service}
  systemctl start docker{.socket,.service}
  systemctl enable containerd.service
  systemctl start containerd.service
}
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
#alias docker-compose="sudo docker-compose"
alias dcm="docker-compose"
alias dcb="docker-compose build"
alias dm="docker images"
alias dma="docker images -a --no-trunc"
alias dima='docker images --format="table {{.ID}}\t{{.Repository}}:{{.Tag}}\t{{.CreatedAt}}\t{{.Size}}" -a'
alias drm="docker rm"
alias dim="docker images --format=\"table {{.CreatedAt}}\t{{.Repository}}\t{{.Tag}}\t{{.ID}}\t\t{{.CreatedSince}}\t{{.Size}}\" | (sed -u 1q; sort -k 1 )"
alias di="docker image"
alias dis="docker inspect"
alias dc="docker container"
alias dcl="docker container ls -a  --format \"table{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Command}}\t{{.Status}}\t{{.Size}}\" "
alias dclp="docker container ls -a  --format \"table{{.ID}}\t{{.Names}}\t{{.Ports}}\" "
alias dlc="docker container ls -a"
alias dli="docker images -a"
alias dins="docker inspect "
alias dcls="dlc --format=\"{{.Size}} {{.Image}}\" -a"
alias dps="docker ps -a"
alias d="docker"
alias dri="docker run -it"
alias dx="docker exec -it"
alias dxs="docker exec --user 0 -it"
alias dxr="docker run -it --rm"
alias ddri="docker run -d -it"
alias dpra="docker prune -a"
alias dbuild="docker_build"
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
  sudo ls 2>/dev/null
  local  docker_images=$(docker images -qa)
  # echo $docker_images
  sudo docker inspect $($docker_images)  | gron  | fzf -e -i --ansi --no-sort
}
alias dis="docker_inspector"

docker_build() {
  local name="$1"
  vared -p "container name: $1 "  -e name
  [[ -z $DOCKER_IMAGE_NAMESPACE ]] && \
    docker build -t $name  . $DOCKER_OPTS \
  || docker build -t $DOCKER_IMAGE_NAMESPACE/$name .
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
alias dbsh="dockerbash"
alias dzsh="dockerzsh"
alias dsh="dockersh"


docker_format() {
  docker container ls --format='{{json .}}' | jq
}

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

dxz() {
  docker exec -it $1 /bin/zsh $2
}
