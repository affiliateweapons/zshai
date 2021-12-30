chpwd() {
  local store="$ZSHAI_DATA/pwd"
  local dir="$PWD"

  [[ ! -z "$PWD_SKIP_ONCE" ]] && unset PWD_SKIP_ONCE && return
  [[ -z "$PWD" ]] && \
  echo "$PWD" > "$ZSHAI_DATA/pwd"
  [[ ! -z "$CHPWD_VERBOSE" ]] && echo "written $PWD to $store"
}
