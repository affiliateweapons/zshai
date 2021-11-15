#!/usr/bin/env zsh
ZSHAI=~/zshai
ZSHAI_DATA=~/.zshai
# this the entry file that will be sourced by .zshrc
eval $(cat $ZSHAI/.zshai.env)
export ZSHAI_LOADED_COMPLETIONS=()
# load core aliases and functions
'source' $ZSHAI/core.sh

# looad local specific aliases
[ -f $ZSHAI_DATA/aliases.sh ] && 'source' $ZSHAI_DATA/aliases.sh

# load completion
for i in $('ls' $ZSHAI/shell/completion);'source' $ZSHAI/shell/completion/$i; 


# mark loaded
export ZSHAI_LOAD_COMPLETED=true