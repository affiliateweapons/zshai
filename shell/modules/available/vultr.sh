
vultr() {
  CLS="vultr"
  typeset -g VULTR_DIR="$HOME/.zshai/vultr"

  ORIGINAL_FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"
  export FZF_DEFAULT_OPTS="$FZF_THEME_OPTS$(cat<<EOF

EOF
)"


  $CLS::list() {
    local cache="${VULTR_DIR}/instance-list"

    [[ -e "${cache}" && -z $1 ]] && cat "${cache}" || {
      mkdir -p "${VULTR_DIR}"
      touch "${cache}"
      vul instance list > ${cache}
    }
  }

  $CLS::default() {
    [[ "$1" = "-c" ]] && VULTR_CLI_CACHE_DISABLED=true && shift
    [[ "$1" = "+c" ]] && unset VULTR_CLI_CACHE_DISABLED && shift
    [[ -z "$VULTR_CLI_CACHE_DISABLED" ]] && $CLS::_cache $@ || $CLS::_cmd $@
  }

  $CLS::_cache() {
    local md5="$(echo $@ | md5)"
    local cache_file="$(:dir cache)/$md5"
    [[ -f "$cache_file" ]] && {
      :info "${RED}HOT CACHE" "$cache_file"
      cat "$cache_file"
     } || {
      :info "${BLUE}COLD CACHE${RESET}" ""
      local response="$(vultr::_cmd $@)"
      echo "$response" > "$cache_file"
      cat "$cache_file"
    }
  }

  $CLS::_cmd() {
    apikey=$(decrypt $ZSHAI_DATA/gpg/apikeys/vultr.gpg)
    'docker' run -ti --rm --env=VULTR_API_KEY="$apikey" vultr-cli $@
  }

  $CLS::_cleanup() {
    FZF_DEFAULT_OPTS="$ORIGINAL_FZF_DEFAULT_OPTS"
  }

  subcommands $CLS $@  

}
zshai_alias 'vul="vultr"'
