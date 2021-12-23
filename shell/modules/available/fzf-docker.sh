
alias fzd="fzf_docker"
alias emd="em fzf-docker"
cursor_off(){tput civis}
cursor_on(){tput norm}
export PREVIEW_RIGHT_50="right,50%:wrap"
export PREVIEW_RIGHT_60="right,60%:wrap"
export PREVIEW_RIGHT_70="right,70%:wrap"
export PREVIEW_RIGHT_80="right,80%:wrap"
export PREVIEW_TOP_80="top,80%:wrap"
man_color() {
  bat --color=always -l man -p
}
zshai_banner() {
  cat $ZSHAI/plugins/fzf-docker/banner.txt
}

zshai_docker_init() {
  export REAL_USER=${SUDO_USER:-$USER}
  export ZSHRC=/home/$REAL_USER.zshrc

  sudo docker
  prompt off
  clear

  export FZF_SHELL=1
  export TOGGLE_GREP=""
  INIT="source $ZSHAI_MODULES_DIR/available/fzf-docker.sh"
  MOD_SSH="source $ZSHAI_MODULES_DIR/available/ssh.sh"
  DOCKER_IMAGES_CACHE_FILE="$ZSHAI_DATA/docker/cache/image-list"
  DOCKER_CMD="sudo docker"
  BAT="bat --color=always -l sh --decorations=never"
  export INIT
  typeset -Ag VIEWERS=()
  VIEWERS=(
    [jq]="jq -C"
    [gron]="gron"
    [bat]="bat --color=always -l sh --decorations=never"
  )
  export VIEWERS
  VIEWER="$VIEWERS[gron]"
}

docker_rm() {
  sudo docker stop $1
  sudo docker rm $1
}

dockerformat() {
    typeset -A viewers=()
  viewers=(
    [jq]="jq -C"
    [gron]="gron"
  )

  VIEWER=$viewers[gron]

  local cmds=$(cat /dev/stdin)
  echo $cmds |  sed 's/ --/ \n\t--/g' \
  | sed 's/\&\&/\n\&\&/g' \
  | sed 's/\&\&/\n\&\&/g' \
  | sed 's/\\(/\n\\(/g'
}


export DEFAULT_VIEW="INSPECT"
export ACTIVE_PREVIEW_CMD="INSPECT"
export DOCKER_CMD="sudo docker"

docker_remote_cmd() {
  local server=$1
  local cmd=$@
  local hash="$@"
  
  export REMOTE_DOCKER="$1"
  shift

  sha=$(echo $hash | shasum | sed 's/ .*//')
  local cachefile=~/.zshai/docker/cache/reqest/$sha

  [[ ! -f "$cachefile" ]] && {    
    local result=$(ssh -t $server $@ 2>/dev/null)
    echo $result > $cachefile
  }
  
  cat $cachefile
}
docker_local_cmd() {
  local context=$1
  local resource=$2
  local cmd=$3
  local id=$4
  local q=$5
  echo "1=$1"
  echo "2=$2"
  echo "3=$3"
  echo "4=$4"
  echo "5=$5"
  echo "@=$@"
  shift
  shift
  shift
  cmdline="$context $resource $cmd $id"
  query=${q:-'""'}
  echo "query=$query"

  case $cmd in
    image)
      
      echo "$cmd"
      eval sudo $cmdline $@ --help | man_color;;
    diff|top|port)
      eval sudo $cmdline ;;
    inspect|history)  
      eval sudo $cmdline | ((gron -c | sed 's/json[^.]*//g' | grep -i -e  $query ) 2>/dev/null  || jq -c $query );;
    logs)
      eval sudo $cmdline;;
    commit)
      eval sudo $cmdline $@;;
    cp)
      echo sudo $cmd $id $q;;
    run)    
      echo $context $cmd $id $@;;
    exec)
      shift
      container=$2      
      shift
      shift
      eval sudo $cmdline $q;;
      #eval sudo docker exec -t $3 ${q//\"/};;
    stats)
      eval sudo $cmdline --no-stream;;
    info|version)
      eval sudo $cmd;;
    *) sudo docker $cmd --help ;;
  esac
  
    
  # sha=$(echo $hash | shasum | sed 's/ .*//')
  # local cachefile=~/.zshai/docker/cache/reqest/$sha

  # [[ ! -f "$cachefile" ]] && {    
  #   local result=$(docker $@ 2>/dev/null)
  #   echo $result > $cachefile
  # }
  
  # cat $cachefile
}

fzf_docker_run_history() {
  #local cmds="$(history  | grep -o 'docker run.*')"
  #echo $cmds

  
  
  #  | sort | uniq  | grep -v "sort\|uniq\|%\|\\\\\n")"

  echo "$cmds" | fzf
}

fzf_docker_inspect() {
  json="$(sudo docker inspect $1)"
  
  [[ -z $2 ]] && {
    echo  $json | gron -c | sed 's/json[^.]*//g' 
    return
  }
  query=${2// /.*}
  jq_paths_cmd=$(which jq-paths)
  gron_cmd=$(which gron)
  paths="$(echo $json | ${jq_paths_cmd} |  sed 's/.\[\]\.//g'  | grep --color=always -i $query.)"
  gron="$(echo $json  | ${gron_cmd} | sed 's/json[^.]*.//g'  | grep -i .$query.\* | grep --color=always  '".*"' )"

  f1=$(mktemp /tmp/inspect-paths.XXXXX)
  f2=$(mktemp /tmp/inspect-gron.XXXXX)
  echo $paths > $f1
  echo $gron > $f2
  
  paste $f1 $f2 | awk -F'\t' '{ printf("%-80s %s\n", $1, $2) }'
  
}
fzf_docker() {
sudo docker 2>/dev/null


  ORIGINAL_FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"

  zshai_docker_init
  export FZF_SHELL=1
  PLUGIN_DIR="$ZSHAI/plugins/fzf-docker"

#dive     [HISTORY]="$INIT;$DOCKER_CMD history --format="{{.CreatedBy}}" --no-trunc {1} | dockerformat"

  typeset -Ag DOCKER_COMMANDS=()
  typeset -Ag CMDS=()
  INIT="source $ZSHAI_MODULES_DIR/available/fzf-docker.sh"
  export CMDS=()
  export DOCKER_CMD="sudo docker"
  CMDS=(
   [RUN]="$ZSHAI/docker/commands/run"
  )

  DOCKER_COMMANDS=(
    [HISTORY]="$INIT;echo {n};$DOCKER_CMD history {3} --no-trunc --format={{.CreatedBy}} | dockerformat | ${BAT}"
    [INSPECT]="$INIT;fzf_docker_inspect {1} "
    [RM]="$INIT;docker_rm {1}"
    [CONTAINER_START]="docker_container_list"
    [RENAME]="$INIT;docker_container_rename {2}" 
  )
  COLUMN_IMAGE_ID='{3}'
  COLUMN_CONTAINER_ID='{1}'

  export DELETE_CMD=$DOCKER_COMMANDS[RM]
  export DOCKER_COMMANDS
  export DOCKER_CONTAINER_FORMAT="table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Command}}\t{{.Status}}\t{{.Size}}"
#  [[ ! -z  $1 ]] && docker rm $1 && return
  export START_CMD="sudo docker container ls -a   --format=\"$DOCKER_CONTAINER_FORMAT\"  "
  CYCLE_COMMANDS=(
    INSPECT
    HISTORY
    LOG
  )

  [[ -z "$REMOTE_DOCKER" ]] && {
    typeset -A prompts
    prompts=(
      [ARROW]="➤ "
      [BRACKET]="【 "
    )  
    FZF_PROMPT=$prompts[ARROW]
    DOCKER_CMD="sudo docker"
    local list=$(docker container ls -a --format="$DOCKER_CONTAINER_FORMAT" )
    export PREVIEW_CMD=$DOCKER_COMMANDS[$DEFAULT_VIEW]
  } || {
    FZF_PROMPT=" $REMOTE_DOCKER> "
    DOCKER_CMD="docker_remote_cmd $REMOTE_DOCKER docker"
    local list="$(docker_remote_cmd $REMOTE_DOCKER docker container ls -a)"
    PREVIEW_CMD="$INIT;docker_remote_cmd $REMOTE_DOCKER  docker history {2} --no-trunc --format={{.CreatedBy}} | dockerformat | ${BAT}"
  }
  QUERY="$1"

  export FZF_DEFAULT_OPTS=$FZF_THEME_OPTS$(cat <<EOF
  -e
  --multi \
  --ansi \
  --disabled \
  --header-lines=1 \
  --prompt "$FZF_PROMPT" \
  --query "$QUERY" \
  --preview="$PREVIEW_CMD" \
  --preview-window='up,24:wrap,border-sharp'
  --bind "change:preview^$PREVIEW_CMD {q}^"
  --info "hidden"
  --bind "alt-up:preview-page-up" \
  --bind "alt-down:preview-page-down" \
  --bind "home:preview-top" \
  --bind "end:preview-bottom" \
  --bind 'del:execute^$DELETE_CMD^+preview^echo {1};PREVIEW_CMD=ls^+reload($START_CMD)' \
  --bind 'esc:preview:$PREVIEW_CMD' \
  --bind '?:execute^dimr {1}^' \
  --bind '1:preview:cat $ZSHAI/plugins/fzf-docker/commands/container' \
  --bind "f1:preview:cat $ZSHAI/plugins/fzf-docker/commands/global" \
  --bind "ctrl-i:preview:$DOCKER_COMMANDS[INSPECT];" \
  --bind "f2:execute:$DOCKER_COMMANDS[RENAME];" \
  --bind 'alt-2:execute^source ~/.zshrc;fzf_docker_image_list {1}^' \
  --bind 'alt-4:execute^source ~/.zshrc;fzf_docker_volume_list {1}^' \
  --bind 'f3:preview:$DOCKER_COMMANDS[HISTORY];export F3_CMD="history"' \
  --bind 'f4:execute^source ~/.zshrc;dimr {1}^' \
  --bind 'f5:execute^NO_CACHE=true;$PREVIEW_CMD^' \
  --bind 'f7:preview:sudo docker logs {1}  --tail 10 ' \
  --bind 'f8:preview:sudo docker stats --no-stream' \
  --bind 'f9:execute^source ~/.zshrc;fzf_grep_dockerfiles {q} {3}^' \
  --bind 'f12:execute^sudo docker exec -it {1} sh^' \
  --bind 'ctrl-f:toggle-search' \
  --bind "ctrl-r:execute^$INIT;fzf_docker_run_history^" \
  --bind 'ctrl-s:execute^sudo docker start {1}^+reload($START_CMD)' \
  --bind 'ctrl-t:execute^sudo docker top {1} -aux;k='';vared -p "press a key" -e k^' \
  --bind 'ctrl-/:execute^sudo docker stop {1}^+reload($START_CMD)' \
  --bind 'backward-eof:execute-silent^sudo docker stop {1}^+reload($START_CMD)' \
  --bind 'alt-f:toggle-search+preview:sudo docker search {q}' \
  --bind 'enter:execute^tput civis;source ~/.zshrc;fzf_docker_container {1} {2}^' \
  --bind 'alt-right:execute^source ~/.zshrc;fzf_docker_container {1} {2}^' \
  --bind 'alt-q:execute^source ~/.zshrc;fzf_docker_remote 1^' \
  --bind 'alt-w:execute^source ~/.zshrc;fzf_docker_remote 2^' \
  --bind 'alt-e:execute^source ~/.zshrc;fzf_docker_remote 3^' \
  --bind 'alt-r:execute^source ~/.zshrc;fzf_docker_remote 7^' \
  --bind '7:execute^source ~/.zshrc;fzf_docker_remote 7^' \
  --bind 'alt-a:execute^source ~/.zshrc;fzf_docker_remote 4^' \
  --bind 'alt-s:execute^source ~/.zshrc;fzf_docker_remote 5^' \
  --bind 'alt-d:execute^source ~/.zshrc;fzf_docker_remote 6^' \
  --bind 'alt-z:execute^source ~/.zshrc;fzf_docker_local 0^' \
  --bind 'alt-f:preview^man fzf | bat --color=always -l man --style=plain^' \
  --bind 'shift-right:execute^source ~/.zshrc;fzf_docker_image "\$(docker_image_hash {2})"^' \
  --bind "alt-v:preview^$PREVIEW_CMD^" \
  --bind 'alt-enter:execute^sudo docker exec -it {1} sh^' \
  --bind 'insert:execute^sudo docker exec -it {1} sh^' \
  --bind 'alt-x:execute^source ~/.zshrc;edit_module fzf-docker^' \
  --bind 'alt-p:preview:ps aux' 
EOF
)



  
  tput cnorm;echo $list | fzf 
  FZF_DEFAULT_OPTS="$ORIGINAL_FZF_DEFAULT_OPTS"

  prompt fade blue
}

docker_container_list() {
  echo $REMOTE_DOCKER
}

fzf_docker_container_info() {

  sudo docker container inspect $2 -f "$(cat $1/plugins/fzf-docker/formats/container)" | bat --color=always -l ini
}
fzf_docker_container() {
  ORIGINAL_FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"
  zshai_docker_init
  
  local container=$1
  local namespace=$2
  
  [[ -z "$REMOTE_DOCKER" ]] && {
    typeset -A prompts
    prompts=(
      [ARROW]="➤"
      [BRACKET]="【 "
    )
    FZF_PROMPT=$prompts[BRACKET]
    DOCKER_CMD="docker_local_cmd docker container"
    local list="$(docker container ls -a)"
    export PREVIEW_CMD=$DOCKER_COMMANDS[$DEFAULT_VIEW]
  } || {
    FZF_PROMPT=" $REMOTE_DOCKER> "
    DOCKER_CMD="docker_remote_cmd $REMOTE_DOCKER docker"
    local list="$(docker_remote_cmd $REMOTE_DOCKER docker container ls -a)"
    PREVIEW_CMD="$INIT;docker_remote_cmd $REMOTE_DOCKER  docker history {2}  --no-trunc --format={{.CreatedBy}} | dockerformat | ${BAT}"
  }

  export FZF_DEFAULT_OPTS=$FZF_THEME_OPTS$(cat <<EOF
  -d '\t'
  --ansi
  --disabled
  --info "hidden" 
  --header-lines 1
  --with-nth=1..
  --header="CONTAINER: $DOCKER_CMD $container - $namespace"
  --preview "$INIT;fzf_docker_container_info $ZSHAI $container;docker {1} --help | $VIEWERS[bat]"
  --preview-window='up,23:wrap'
  --bind "alt-up:preview-page-up"
  --bind "alt-down:preview-page-down"
  --bind "home:preview-top"
  --bind "end:preview-bottom"
  --bind "alt-left:abort"
  --bind "alt-right:preview:$INIT;fzf_docker_command $container {1} {q}"
  --bind "ctrl-g:execute:$INIT;echo 'grep enabled';toggle_grep {q}"
  --bind "backward-eof:abort"
  --bind "enter:preview:$INIT;$DOCKER_CMD {1} $container {q} {2}  {3} "
EOF
)
 
  tput cnorm; cat  $ZSHAI/plugins/fzf-docker/commands/container  | fzf
  
  FZF_DEFAULT_OPTS="$ORIGINAL_FZF_DEFAULT_OPTS"

}

usage() {
  local usage="$1"
  shift
  local parm="$2"
  local required_parameters=$#@

  for i in {1..$required_parameters}
  do
    [[ -z $$i ]] && echo "$usage" && return
  done
}

docker_container_rename() {
  local container="$1"
  local rename_to="$2"
  usage "docker_container_rename [container] [new-name]" $1 $2 && return || {  
      echo "Renaming container $RED$container$RESET to $GREEN$2$RESET"    
      docker container rename $container $rename_to
      dcl
  }


}
fzf_grep_dockerfiles() {
  grp $@
}

# for container
fzf_docker_command() {
  local id=$1
  local cmd=$2
  local q=$3

  echo "deprecated"
  echo $@
  return
  case $cmd in
    inspect|diff|top|port)        
      #eval $DOCKER_CMD $cmd $id;; 
      eval $DOCKER_CMD $@ $id;;
    logs)
      eval $DOCKER_CMD $cmd $id ;;
    cp)
      echo $cmd $id $q;;
    exec)
      eval $DOCKER_CMD exec -t $id ${q//\"/};;
    stats)
      eval $DOCKER_CMD $cmd $id --no-stream;;
    info|version)
      eval $DOCKER_CMD $cmd;;
    *) sudo docker $cmd --help ;;
  esac
}
fzf_docker_image() {
  zshai_docker_init
  local image=$1
  local namespace=$2
  DOCKER_CMD="docker_local_cmd docker image"
  export FZF_DEFAULT_OPTS=$FZF_THEME_OPTS$(cat <<EOF
  --disabled \
  --reverse \
  --header-first \
  --info="default" \
  --header="IMAGE: $image - $namespace" \
  --bind "alt-up:preview-page-up" \
  --bind "alt-down:preview-page-down" \
  --bind "home:preview-top" \
  --bind "end:preview-bottom" \
  --bind "alt-left:abort" \
  --preview "echo \"\$(sudo docker inspect $image | gron)\"" \
  --preview-window=right,60%:wrap \
  --bind "enter:preview:$INIT;$DOCKER_CMD {1} $image {q}"
EOF
)
  cat  $ZSHAI/plugins/fzf-docker/commands/image  | fzf
}

fzf_cmd() {
  tput cnorm
  fzf $@
}

cycle_cmd() {
  echo "echo"
}

fzf_docker_dive() {
  echo "Executing: docker dive $@"

  dive $@
}
fzf_docker_volume_list() {

  zshai_docker_init
  BAT="bat --color=always -l sh --decorations=never"

  typeset -Ag FORMATS=()
  FORMATS=(
    [IMAGE_HISTORY]="{{.CreatedBy}}"
    [IMAGE_HISTORY_TRUNC]="{{.ID}}"
  )
  typeset -g doptions
  export doptions="$1"
  DELETE_CMD="$DOCKER_CMD volume rm {2} 2>/dev/null"
  export START_CMD="source $ZSHAI/shell/modules/available/fzf-docker.sh;docker_images_cache_reset"
  export VOLUME_PREVIEW_CMD="tree -Cdlxs --filelimit 10000 --du -h -L 5"

  export FZF_DEFAULT_OPTS=$FZF_THEME_OPTS$(cat <<EOF
  --multi \
  --ansi \
  --with-nth=1.. \
  --header-lines=1 \
  --preview "sudo $VOLUME_PREVIEW_CMD /var/lib/docker/volumes/{2}/_data" \
  --preview-window=top,20:wrap \
  --bind "alt-down:preview-page-down" \
  --bind "alt-up:preview-page-up" \
  --bind "shift-up:preview-top" \
  --bind "shift-down:preview-bottom" \
  --bind 'del:execute-silent^$DELETE_CMD^+abort+execute^source ~/.zshrc;fzf_docker_volume_list^' \
  --bind 'enter:execute^source ~/.zshrc;fzf_docker_image {1} {2}^' \
  --bind 'alt-3:execute^source ~/.zshrc;fzf_docker_dive {3}^' \
  --bind 'alt-right:execute^source ~/.zshrc;fzf_docker_image {1} {2}^' \
  --bind 'alt-left:abort' \
  --bind 'f1:execute^source ~/.zshrc;fzf_docker {1}^' \
  --bind "ctrl-j:disable-search+execute^$INIT;export VIEWER='jq'^+reload(docker_images_cache_reset)" \
  --bind "ctrl-g:disable-search+execute^$INIT;export VIEWER='gron'^+reload(docker_images_cache_reset)" \
  --bind "ctrl-b:disable-search+execute^$INIT;export VIEWER='bat'^+reload(docker_images_cache_reset)" \
  --bind 'ctrl-f:toggle-search' \
  --bind "ctrl-r:execute-silent^$INIT;echo 234^+reload($START_CMD)" \
  --bind "ctrl-a:execute^DISPLAY_ALL="-a"^+reload($START_CMD)" \
  --bind 'ctrl-e:execute^fzf_docker^'

EOF
)

  echo "$(sudo du -h /var/lib/docker/volumes -d 1 | sed 's,\t.*volumes/,\t,g'  |  sort -hr)" | fzf
  unset FZF_DEFAULT_OPTS

}

fzf_docker_image_list() {
  zshai_docker_init
  BAT="bat --color=always -l sh --decorations=never"

  typeset -Ag FORMATS=()
  FORMATS=(
    [IMAGE_HISTORY]="{{.CreatedBy}}"
    [IMAGE_HISTORY_TRUNC]="{{.ID}}"
  )
  typeset -g doptions
  export doptions="$1"
  echo "$doptions"
  DELETE_CMD="$DOCKER_CMD rmi {3} 2>/dev/null"
  export START_CMD="source $ZSHAI/shell/modules/available/fzf-docker.sh;docker_images_cache_reset"

  export FZF_DEFAULT_OPTS=$FZF_THEME_OPTS$(cat <<EOF
  --multi \
  --ansi \
  --with-nth=1.. \
  --header-lines=1 \
  --preview "$INIT;echo $DOCKER_CMD;echo $VIEWER;$DOCKER_CMD image  history {1} --no-trunc --format=$FORMATS[IMAGE_HISTORY] | dockerformat | ${BAT}" \
  --preview-window=top,20:wrap \
  --bind "alt-down:preview-page-down" \
  --bind "alt-up:preview-page-up" \
  --bind "shift-up:preview-top" \
  --bind "shift-down:preview-bottom" \
  --bind 'del:execute-silent^$DELETE_CMD^+execute^source ~/.zshrc;fzf_docker_image_list^' \
  --bind 'enter:execute^source ~/.zshrc;fzf_docker_image {1} {2}^' \
  --bind 'alt-3:execute^source ~/.zshrc;fzf_docker_dive {3}^' \
  --bind 'alt-right:execute^source ~/.zshrc;fzf_docker_image {1} {2}^' \
  --bind 'alt-left:abort' \
  --bind 'f1:execute^source ~/.zshrc;fzf_docker {1}^' \
  --bind "ctrl-j:disable-search+execute^$INIT;export VIEWER='jq'^+reload(docker_images_cache_reset)" \
  --bind "ctrl-g:disable-search+execute^$INIT;export VIEWER='gron'^+reload(docker_images_cache_reset)" \
  --bind "ctrl-b:disable-search+execute^$INIT;export VIEWER='bat'^+reload(docker_images_cache_reset)" \
  --bind 'ctrl-f:toggle-search' \
  --bind "ctrl-r:execute-silent^$INIT;echo 234^+reload($START_CMD)" \
  --bind "ctrl-a:execute^DISPLAY_ALL="-a"^+reload($START_CMD)" \
  --bind 'ctrl-e:execute^fzf_docker^'

EOF
)

  echo "$(docker_images_cache)" | fzf
  unset FZF_DEFAULT_OPTS

}

docker_images_cache() {
  cachefolder="$ZSHAI_DATA/docker/cache"
  export DOCKER_IMAGES_CACHE_FILE="$ZSHAI_DATA/docker/cache/image-list"
  DOCKER_IMAGES_FORMAT="table {{.ID}}\t{{.Size}}\t{{.Repository}}:{{.Tag}}\t{{.CreatedSince}}"
  [[ ! -f $DOCKER_IMAGES_CACHE_FILE ]] && {
  }
  [[ ! -d "$cachefolder" ]] && mkdir -p "$cachefolder"

    sudo docker image ls --format="$DOCKER_IMAGES_FORMAT" > $DOCKER_IMAGES_CACHE_FILE

  cat $DOCKER_IMAGES_CACHE_FILE
}
docker_images_cache_reset() {
  cachefolder="$ZSHAI_DATA/docker/cache"

  [[ ! -d "$cachefolder" ]] && mkdir -p "$cachefolder"
  export DOCKER_IMAGES_CACHE_FILE="$ZSHAI_DATA/docker/cache/image-list"
  [[ -f $DOCKER_IMAGES_CACHE_FILE ]] && rm  $DOCKER_IMAGES_CACHE_FILE
  docker_images_cache
}
docker_search() {
  local search="$(sudo docker search $1)"

  echo $search
return
  local select=$(echo $search | fzf \
  --header-lines=1 \
  --preview="curl -s 'https://hub.docker.com/v2/repositories/{1}/'  2>/dev/null | jq;echo '{1}'" \
  --preview-window="right,40%" )

}

fzf_docker_search() {
  local query=$1
  export FZF_DEFAULT_OPTS=$(cat <<EOF
  --disabled \
  --reverse \
  --info="default" \
  --header-lines=1 \
  --bind "alt-up:preview-page-up" \
  --bind "alt-down:preview-page-down" \
  --bind "home:preview-top" \
  --bind "end:preview-bottom" \
  --preview "echo {}" \
  --bind "enter:preview:echo 'sudo docker image {1} $image';echo '--';sudo docker {1} $image"
EOF
)
  sudo docker search $query| fzf
  unset FZF_DEFAULT_OPTS
}

toggle_grep() {
  export TOGGLE_GREP="| grep $1"
  cat /dev/stdin
}


reset_entrypoint() {
  docker run -it --entrypoint=""  $1
}

dps_all(){
  for i in $(docker ps -q); do; docker top $i; done
}


scan_images() {
  docker images -a
}

docker_context() {
  local remote_command="$1"
  zshai_docker_init

  RUN_CMD="echo $remote_command;server={1};cmd='$remote_command'; ssh -t \$server \$cmd 2>/dev/null"

  export FZF_DEFAULT_OPTS=$(cat <<EOF
  --ansi \
  --disabled \
  --preview "$RUN_CMD" \
  --preview-window "$PREVIEW_TOP_80" \
  --bind "enter:preview:$INIT;docker_remote_cmd {1} {q}"
EOF
)
  servers docker list | fzf
  unset FZF_DEFAULT_OPTS

}
fzf_docker_local() {
  unset REMOTE_DOCKER

  export REMOTE_DOCKER
  fzf_docker

}
fzf_docker_remote() {
  local server=$1
  local cmd=$@
  servers=( $(cat $ZSHAI_DATA/servers/docker) )
  export REMOTE_DOCKER="$servers[$1]"
  fzf_docker 
}

docker_format_fields() {
  docker container ls --format='{{json .}}' | jq
}

docker_image_hash() {
  docker image ls $1  --format="{{.ID}}" 
}

alias dockd="cd /opt/docker"

# zle functions
.fzf_docker() {
  tput civis
  fzf_docker
  zle accept-line
  zle  redisplay
}

.fzf_docker_images() {
  tput civis
  fzf_docker_image_list
  zle accept-line
  zle  redisplay
}

## KEYBINDS
zle -N .fzf_docker
bindkey  '^[d' .fzf_docker

zle -N .fzf_docker_images
bindkey  '^[i' .fzf_docker_images