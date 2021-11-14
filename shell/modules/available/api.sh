new_api() {
  services=( GitHub DigitalOcean Vultr )
  for service in services;do
    (( i=i++ ))
    echo $service
  done
  services=""
  vared -p "Choose service (1-3): " -e service
}
