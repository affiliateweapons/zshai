alias mfz="man fzf"

# toggle preview of files
fzp() {
  FZF_DEFAULT_OPTS='--preview="f={}; [[ -f $f ]] && fold -w 120 -s  {} " --preview-window=top,20 --height 100%' 
}
