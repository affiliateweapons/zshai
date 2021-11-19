cap_up() {
  docker service scale captain-captain=1
}
cap_down() {
  docker service scale captain-captain=0
}
