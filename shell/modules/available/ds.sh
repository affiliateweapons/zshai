ds() {
  CLS="ds"

  ds::list() {
    sudo ls 1>/dev/null
    local cache="$(ds settings | jq ".[] | .[\"$(pwd | base64 -w 0)\"]" -r)"

    [[ ! "$cache" = "null" ]] && [[ ! -z "$cache" ]]  && echo "$GREEN Cached $RESET:" && echo "$(echo $cache | base64 -d)"  && return


    local result=$(sudo du -h -d 1 | sort -h)
    local dir="$(pwd)"
    echo "current folder: $dir"
    local result_b64=$(echo "$result" | base64 -w 0)
    local dirkey="\"$(pwd | base64 -w 0)\""
    local new_settings=$(ds settings | jqa settings  "$dirkey" "$result_b64")
    [[ ! -z $new_settings ]] && echo $new_setings | ds save-settings
    echo $result
  }

  ds::save-settings() {
    local settings_file="$(ds settings f)"
    local settings_backup="$settings_file.bak"
    echo "Saving settings to: $settings_file"
    #echo "Backing up settings to: $settings_backup"
    local newsettings=$(cat /dev/stdin)
    echo "new settings: $newsettings"
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

  subcommands "ds" $@
}
