#alias figlet='docker run -i --rm zshai/figlet'

figlet() {
local font="$1"
[[ -z $2 ]] && {
    drum  -it -v figlet_data:/data figlet -f "/data/figlet-fonts/3d.flf" $@
} || {
    shift
    drum  -it -v figlet_data:/data figlet -f "/data/figlet-fonts/$font.flf" $@
  }
}

#@todo cache results
fzfiglet() {
  local default_text="Powered by Zsh.Ai"
  local text="${1:-$default_text}"
  local fonts_dir=$ZSHAI_DATA/figlet/fonts/available
  local fonts=$('ls' $fonts_dir)

  #  echo $fonts | fzf 
  for i in $(echo $fonts)
  do
    local file=$fonts_dir/$i
    drum  -it -v $(readlink -f $file):/tmp/figlet_$file figlet -f /tmp/figlet_$file $text
  done
}
