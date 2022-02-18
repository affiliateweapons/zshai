  # this is the zshai plugin system v1

plugins() {
  CLS="plugins"
  typeset -g ZSHAI_PLUGINS
  typeset -g ZSHAI_PLUGINS_PATH="$(zdir plugins)" 

  ORIGINAL_FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"
  export FZF_DEFAULT_OPTS="$FZF_THEME_OPTS$(cat<<EOF
EOF
)"

  $CLS::load() {
    [[ -d "$PWD/plugins"  ]] && [[ -z "$1" ]] && zshai-prompt cdls "plugins" && return
    [[ -z $ZSHAI_PLUGINS ]] && return
    for i in $ZSHAI_PLUGINS
    do
      pluginfile="$ZSHAI_PLUGINS_PATH/$i/$i.plugin.zsh"
      [[ -f ${pluginfile} ]] && {
        'source' "$pluginfile"
      }
    done
  }

  $CLS::list() {
    [[ -d "plugins"  ]] && [[ -z "$1" ]] && {
      cd  plugins
      zshai-prompt dirlisting && return
    }
    
    $LS_CMD $ZSHAI_PLUGINS_PATH
  }
#
#  $CLS::default() {
#  }
#
#  $CLS::usage() {
#  }
#
#  $CLS::widgets() {
#  }
#
#  $CLS::options() {
#  }
#
#  $CLS::arguments() {
#  }
#
#  $CLS::bindkeys() {
#  }
#
#  $CLS::alias() {
#  }
#
#  $CLS::config() {}

  $CLS::_cleanup() {
    FZF_DEFAULT_OPTS="$ORIGINAL_FZF_DEFAULT_OPTS"
  }

  subcommands $CLS $@  

}
