sysinfo() {
 list=$(cat <<EOF
lsusb
lscpu
lsinitramfs
lsipc
lsmod
lsmem
lsns
lsus
EOF
)

echo $list  | fzf --preview "{}" --height=40


}
