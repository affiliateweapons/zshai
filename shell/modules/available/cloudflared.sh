# you need to build cloudflared first
cloudflared() {
  docker run --rm -it cloudflared $@
}
zshai_alias cf="cloudflared"
