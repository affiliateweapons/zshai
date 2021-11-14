ncrl(){
    if [[ "$1" -lt "254" ]] then 
      local ip="172.16.89.$1"
    fi
  local start=${3:-1}
  local end=${2:-1000}
  nc -vz $ip  ${start}-${end} 2>&1 | grep -v refused
}

ncr(){
  local ip=$1
  local start=${3:-1}
  local end=${2:-1000}
  nc -vz $ip  ${start}-${end} 2>&1 | grep -v refused
}
