# checksum of files
sha1() {
  req1 $1 && return

  [[ ! -f "$1" ]] && echo "file does not exist: $1" && return

  local shafile=${2:-$1.sha1}

  [[ ! -e "$shafile" ]] && echo "no sha file $shafile" && return

  sha_source="$(cat $shafile)"
  sha_target="$(cat $1 | shasum)"

  echo "Source: $sha_source"
  echo "Target: $sha_target"

  if [[ ${sha_source//\ */}  =  ${sha_target//\ */} ]] && echo "The downloaded file is genuine" || echo "The file: $1\nis corrupt or has been tampered with."
}
alias sha="sha1"
