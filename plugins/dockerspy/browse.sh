#!/usr/bin/env zsh
bat="bat --color=always -l sh --terminal-width 140"
cat data/list.csv | fzf --preview="echo {};$bat data/cmd/{1} --color=always" --preview-window=right,60%

