# shortcut for runit.sh
ri() {
  local script="$(curl -sS https://runit.sh/$1)"
  local answer="y"
  echo "Contents of script:"
  echo $script
  echo "--------------------"
  vared -p "Run it? y/n: " -e answer
  [[ $answer = "y" ]] && {
    echo "Gonna run it:" 
    eval $script
  } || echo "aborting"
}
