ramdisk() {

  local CLS="ramdisk"

  ramdisk::list() {
    ramdisk::default
  }
  $CLS::default() {
    cd "$mount_folder"
    mount | grep ram
    ls
  }


  ramdisk::help() {
    echo $(cat<<EOF
Usage: todo [command] [subcommand]
  Current datadir:
    $current
  Available commands:
    setup
    speedtest
EOF
)

  }

  ramdisk::setup() {
    ramsize="$1"

    vared -p "Choose RAM size (gb): " -e ramsize
    local mountfolder="/mnt/ramdisk"
    local disk_name="ramdisk"
    let size="$(( ramsize * 1024 ))"
    echo "setup ramdisk of:  $size m"


    
    vared -p "Mount folder: " -e mountfolder
    [[ ! -e "$mountfolder" ]] && {
      sudo mkdir -p "$mountfolder"
      echo "created folder: $mountfolder"
    }
    sudo mount -t tmpfs -o size="$size"m  "$disk_name"  "$mountfolder"
  }

  ramdisk::speedtest() {
    local target="/mnt/ramdisk/zero"
    sudo dd if=/dev/zero of="$target" bs=4k count=100000
  }

  subcommands $CLS $@

}
