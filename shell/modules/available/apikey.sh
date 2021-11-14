# store and encrypt api keys
apikey() {
  local service=$1
  local secret=""

  vared -p "API Key Name: " -e service
  vared -p "API Secret: " -e secret


  encrypted_file=$ZSHAI_DATA/gpg/apikeys/$service
  echo $secret > $encrypted_file
  encrypt $encrypted_file
  echo "Encrypted secret in:  $encrypted_file.gpg"
}

get_apikey_file() {
  echo $ZSHAI_DATA/gpg/apikeys/$1.gpg
}
