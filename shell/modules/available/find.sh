find() {
  CLS="find"
  INIT="source ~/.zshrc;$CLS "

  $CLS::list() {
    typeset -Ag FIND_CMDS
    FIND_CMDS=(
    [empty]='find empty files'
    [ls]="find with ls output"
    [in_files]="find files that contain [text]"
    [by_extension]="find files by extension"
    )
    export FZF_DEFAULT_OPTS="$FZF_THEME_OPTS"$(cat<<EOF
    --prompt "$(pwd) ➤"
    --delimiter :
    --with-nth 2
    --bind "enter:execute^echo {1};$INIT {1}^+abort"
    --preview="$INIT source {1}"
EOF
)
    print -l $(for i in  ${(k)FIND_CMDS};echo $i":"$FIND_CMDS[$i]) \
    | fzf
    unset FZF_DEFAULT_OPTS
  }

  $CLS::source() {
    echo "Command: $CLS $2"
    echo $functions[find::$2]
  }
  $CLS::empty() {
    'find' * -type f -empty -print
    return
  }

  $CLS::cmd() {
    # using */* will follow symbolic links
    command 'find' * ! -path "**/.git*"  ! -path "**/enabled/*" "$@"
  }


  # find broken symbolic links
  $CLS::broken_symlinks() {
    alias broken_sym="find . -xtype l"
  }

  #find by file extension
  $CLS::by_extension() {
    find * ! -path "**/.git" ! -path "**/**/.git"   -type f -ls | grep .$1$
  }

  # find with ls output
  $CLS::ls() {
    local query="$1"
    local opts="$2"
    (( $# )) && shift
    local opts=$@
    [[ -z $2 ]] && command find * | grep $query \
      || command find *  $opts | grep $query
  }
  alias fls="find_ls"


  # find files that contain text $1
  $CLS::in_files() {
    grep -rnw  ./ -e "${1}"
  }

  $CLS::grep() {
    command 'find' * | grep $1
  }

  $CLS::dir() {
    shift
    export TITLE="find dir matching [text]"
    local results=$(command find *   -type d \
  ! -path "**/node_modules/**" \
  ! -path "**/**/.git"  \
  ! -path  "**/.git/**" \
  2>/dev/null  | grep $1)
    [[ ! -z $results ]] && {
      unset select
      FZF_DEFAULT_OPTS="$FZF_THEME_OPTS --header '$TITLE'"
      local select=$(echo $results | fzf --preview="ls -lsAtrh --color=auto {}")
      [[ ! -z "$select" ]] && {
#        echo "$select"
        #cd "$select"
      }

    }
    return
  }

  $CLS::find_file() {
    local results=$(command find *   -type f  2>/dev/null  | grep $1)

    [[ ! -z $results ]] && {
      echo $results
#      local select=$(echo $results | fzf --preview='echo {};echo;echo ---;cat {}' --preview-window=right,80%)
 #     cdf $select
    }
  }
  $CLS::aliases() {
    alias fd="find_dir"
    alias ff="find_file"
  }

  $CLS::find_sh_files() {
    find * -type f | grep .sh$
  }

  subcommands $CLS $@
}
