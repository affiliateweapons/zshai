export GPG_SERVER=keyserver.gnukey.net

[[ -d "$ZSHAI_DATA/gpg" ]] && [[ -f "$ZSHAI_DATA/gpg/name" ]] && {
  export GPG_NAME=$(cat "$ZSHAI_DATA/gpg/name")
  export GPG_EMAIL=$(cat "$ZSHAI_DATA/gpg/email")
}

enable_gpg_aliases() {
  alias gpgg="gpg --gen-key"
  alias gpggf="gpg --full-generate-key"
  alias gpl="gpg --list-secret-keys"
  alias gpss="gpg --send-keys $GPG_SERVER"
  alias gpe="gpg_encrypt"
  alias gpd="gpg_decrypt"
}

# display GPG email
gpg_email() {
  local f="$HOME/.zshai/gpg/email"
  [[ -f "$f" ]] && cat "$f"
}

# export GPG public key to file
gpg_export() {
  gpg --output $GPG_NAME.gpg --export $GPG_EMAIL
}

gpg_dir() {
  cd "$ZSHAI_DATA/gpg"
}

# GPG encrypt file/folder
gpg_encrypt() {

  [[ ! -e "$PWD/$1" ]] && echo "Target $PWD/$1 does not exist" && return

  #if  target is a folder, tar it first
  [[ -d "$1" ]] && {
    tarc "$1"
    gpg --output $1.sig --sign $1.tar.gz
  } || {
    gpg --output $1.sig --sign $1
  }

}

# GPG decrypt file
gpg_decrypt() {
  [[ -f "$ZSHAI_DATA/encrypt/$1.gpg" ]] && {
    gpg --output $1.gpg --decrypt
  } || \
  [[ -f $1.sig ]] && gpg --output $1.sig --decrypt || {
    [[ -f $1 ]] && gpg --output $1 --decrypt $1.sig | { 
      [[ ! -z "$DISPLAY" ]] && xclip -selection c
    }
  } || {
    echo "could not find $1"
  }
}

# GPG sign
gps() {
  gpg --clearsign $1
  cat $1.asc | xclip
  cat $1.asc
}

gpg_list_unencrypted() {
  'ls' "$ZSHAI_DATA/secrets/" | grep -v gpg
}

encrypt() {
  [[ ! -f $1 ]] && nano
  gpg -c $1
  rm $1
}

decrypt() {
  local CLS="decrypt"
  local INIT="source ~/.zshrc;source $ZSHAI_MODULES_DIR/available/gpg.sh;$CLS"

  $CLS::decrypt() {
    [[ -f $ZSHAI_DATA/secrets/$1.gpg ]] && file=$ZSHAI_DATA/secrets/$1.gpg || {
      [[ -f $1 ]] && file=$1 || {
        [[ -f $1.gpg ]] && file=$1.gpg || echo "file not found $1" && return
      }
    }

    [[ ! -z $2 ]] && {
      gpg $file
    } || {
      TXT=$(gpg --decrypt $file 2>/dev/null)
      [[ ! -z "$DISPLAY" ]] && {
        echo $TXT | xclip 2>/dev/null
      }
      echo $TXT
      sleep 1;
      [[ ! -z "$DISPLAY" ]] && pkill xclip 2>/dev/null
    }

  }

  $CLS::list() {
    'ls' -1 $ZSHAI_DATA/secrets/
  }

  $CLS::cleanUp() {
    tput cnorm
    unset FZF_DEFAULT_OPTS
  }


  case $1 in
  "")
    $CLS::list
    ;;
  *)
    [[ $functions[$CLS::$1] ]] && {
      cmd=$1
      shift
      $CLS::$cmd $@
      return
    } || {
      $CLS::decrypt $@
    }
    ;;
  esac

}
