ds() {
  CLS="ds"

  ds::force() {
   export DS_FORCE="true"
   sudo ls 1>/dev/null
   ds
  }
  ds::list() {
    sudo ls 1>/dev/null
    local current_hash="$('ls' -1sAhtn | md5)"
    local curdate="$(date +'%y%M%d')"
    local pwd_b64="$(pwd | base64 -w 0)"
    local pwd_md5="$(pwd | md5)"
    local cache_result="$(ds settings | jq ".[\"$(pwd | base64 -w 0)\"].result" -r )"
    local cache_hash="$(ds settings | jq ".[\"$pwd_b64\"].hash" -r )"

    [[ ! -z "$DS_VERBOSE" ]] && {
      echo "cache_result = $cache_result"
      echo "cache_hash = $cache_hash"
      echo "current_hash = $current_hash"
    }

    [[ -z "$DS_FORCE" ]] && [[ "$cache_hash" == "$current_hash" ]] && {
      [[ ! "$cache_result" = "null" ]] && [[ ! -z "$cache_result" ]]  && echo $GREEN"Cached $RESET:" && echo "$(echo $cache_result | base64 -d)"  && return
    }

    [[ "$cache_hash" != "$current_hash" ]] && {
      echo $RED"Hash change!"$RESET
      echo "cache_hash = $cache_hash"
      echo "current_hash = $current_hash"

    }

    [[ ! -z "$DS_FORCE" ]] && echo "Cache busting active"
    local result=$(sudo du -h -d 1 | sort -h)
    local dir="$(pwd)"
    [[ ! -z "$DS_VERBOSE" ]] && {
      echo "current folder: $dir"
      echo "current hash: $current_hash"
    }
    local result_b64=$(echo "$result" | base64 -w 0)
    local dirkey="\"$(pwd | base64 -w 0)\""
    local new_settings=$(ds settings | jqa "$dirkey" "$result_b64" "$current_hash")
    [[ ! -z $new_settings ]] && echo $new_setings | ds save-settings
    unset DS_FORCE
    echo $result

  }
  ds::fzf() {

export FZF_THEME_OPTS=$FZF_THEME_OPTS$(cat<<EOF
  --ansie
  --width "100%"

EOF
)
    ds | fzf

  }
  ds::reset() {
    echo "{}" > $(ds settings f)
  }
  ds::save-settings() {
    local settings_file="$(ds settings f)"
    local settings_backup="$settings_file.bak"
    #echo "Saving settings to: $settings_file"
    #echo "Backing up settings to: $settings_backup"
    local newsettings=$(cat /dev/stdin)
    #echo "new settings: $newsettings"
    echo "$new_settings" > $settings_file
  }

  ds::settings() {
    local settings_file="$ZSHAI_DATA/$CLS/settings.json"
    [[ "$1" = "f" ]] && echo $settings_file \
      || {
        local settings=$(cat $settings_file)
        [[ -z "$settings" ]] && echo '{}' || echo "$settings"
       }
  }

  ds::manual-settings() {
    nano  $(ds settings f) -l
  }
  zshai_alias dsf="ds force"

  subcommands "ds" $@
}
