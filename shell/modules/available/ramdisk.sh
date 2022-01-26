ramdisk() {

  local CLS="ramdisk"

  ramdisk::list() {
    ramdisk::default
  }

  ramdisk::default() {
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

  ramdisk::persist() {
    local source="/mnt/ramdisk/"
    local target="/mnt/disks/eth/ramdisk-persistance/"
    vared -p "RAM disk source folder to persist: " -e source
    vared -p "Target folder: " -e target

    [[ ! -d "$target" ]] && {
      local answer
      vared -p "Create folder?: " -e answer
    }

    [[ $answer != "y" ]] && echo "aborted" || {
      mkdir -p "$target" \
      && rsync -av $source $target
    }

  }

  ramdisk::restore() {
    local target="/mnt/ramdisk/"
    local source="/mnt/disks/eth/ramdisk-persistance/"
    vared -p "RAM disk restore from: " -e source
    vared -p "Target folder: " -e target

    [[ ! -d "$target" ]] && echo "$target is not a folder" || {
      rsync -av $source $target
    }
  }

  subcommands $CLS $@

}
