dnode() {
  local node_modules="node_modules:/usr/src/node_modules"
  local cmd="$1"
#  -p "0.0.0.0:3000/tcp" -p "0.0.0.0:35729" \

  shift
  [[ ! -z $DOCKER_NO_RM ]] && RM="" || RM="--rm"
  echo "$cmd $@"
  docker run \
  -p "3000/tcp" -p "35729" \
  -v yarn_cache:/root/.yarn \
  -v yarn_cache:/usr/src/app/.yarn \
  -v npm_cache:/root/.npm \
  -v "$PWD"/$node_modules \
  -v "$PWD":/usr/src/app \
  -w /usr/src/app \
  --name="$PROJECT" \
  $RM -it node:14-alpine \
  sh -c "$cmd $@"
}

npm() {
  dnode npm "$@"
}
npx() {
  dnode npx "$@"
}

node(){
  dnode node "$@"
}

yarn(){
  dnode yarn "$@"
}
