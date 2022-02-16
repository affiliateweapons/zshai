newsecret() {
  nano $ZSHAI_DATA/secrets/$1
  encrypt  $ZSHAI_DATA/secrets/$1
}


opensecret() {
  tput civis
  local pw
  vared -p "password" -e pw
  echo "File:  $1"
  decrypt $ZSHAI_DATA/secrets/$1
  tput cnorm
}


list_secrets() {
  export FZF_DEFAULT_CMD=$(cat <<EOF
  --bind  "enter:execute^decrypt {}^"
EOF
)

  'ls' -1  $ZSHAI_DATA/secrets | fzf
}

cd_secrets() {
  cd $ZSHAI_DATA/secrets/
  ls
}

realpath_secret() {
  echo $ZSHAI_DATA/secrets/$1
}
alias secrets_list=list_secrets
