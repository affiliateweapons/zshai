zrip() {
  local domain="$(echo $1 | extract_domain)"
  vared -p "Save as: " -e domain

  rwget $1 $domain
  #[[ ! -z "$2" ]] && tardir $2
  tardir "$domain"
  ls "$domain"
}

rwget() {

  local url="${1}"
  local target="${2:-lander}"
  :info "Current PWD" "$PWD"

  [[  ! -d "$target" ]] && mkdir -p "$target"
  wget \
  -e robots=off -nd \
  -k -p -H -E -K \
  --no-parent \
  --no-check-certificate \
  --no-verbose \
  --progress=bar:force:noscroll \
  "$url" \
  -P "$target"

}

download_list() {
  local dir="$PWD/build"
  for q in $(cat $1);
  do
    wget ${q/*=/} -O $dir/${q/=*/}.png
  done
}
