ramdisk() {

  CLS="ramdisk"
  local size_gb="${1:-2}"
  local disk_name="ramdisk"
  local mount="/mnt/ramdisk"


  $CLS::setup() {
    shift
    local size_gb="${1:-2}"
    local mount="/mnt/ramdisk"
    let size=2048
    size=$(( size=size_gb*1024 ))
    echo "setup ramdisk of:  $size $size_gb MB"
    sudo mount -t tmpfs -o size="$size"M  "$disk_name"  "$mount"
  }
  $CLS::speedtest() {
    local target="/mnt/ramdisk/zero"
    sudo dd if=/dev/zero of="$target" bs=4k count=100000
  }

  subcommands $CLS $@

}
