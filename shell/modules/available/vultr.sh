export VULTR_DIR=~/.zshai/vultr

vul() {
  apikey=$(decrypt $ZSHAI_DATA/gpg/apikeys/vultr.gpg)
  sudo docker run -ti --rm --env=VULTR_API_KEY="$apikey" vultr-cli $@
}

vil() {
  local cache=${VULTR_DIR}/instance-list

  [[ -e ${cache} && -z $1 ]] && cat ${cache} || {
    mkdir -p ${VULTR_DIR}
    touch ${cache}
    vul instance list > ${cache}
  }
}
