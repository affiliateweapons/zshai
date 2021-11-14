export GPG_SERVER=keyserver.gnukey.net

[[ -d $ZSHAI_DATA/gpg ]] && {
  export GPG_NAME=$(cat $ZSHAI_DATA/gpg/name)
  export GPG_EMAIL=$(cat $ZSHAI_DATA/gpg/email)
}

alias gpgg="gpg --gen-key"
alias gpggf="gpg --full-generate-key"
alias gpl="gpg --list-secret-keys"

# display GPG email
gpg_email() {
  cat ~/.zshai/gpg/email
}

# export GPG public key to file
gpg_export() {
  gpg --output $GPG_NAME.gpg --export $GPG_EMAIL
}

# send GPG public key to server
alias gpss="gpg --send-keys $GPG_SERVER"

# GPG encrypt file/folder
gpg_encrypt() {

  [[ ! -e $PWD/$1 ]] && echo "Target $PWD/$1 does not exist" && return

  #if  target is a folder, tar it first
  [[ -d $1 ]] && {
    tarc $1
    gpg --output $1.sig --sign $1.tar.gz
  } || {
    gpg --output $1.sig --sign $1
  }

}

# GPG decrypt file
gpg_decrypt() {

  [[ -f $1.sig ]] && gpg --output $1.sig --decrypt || {
    [[ -f $1 ]] && gpg --output $1 --decrypt $1.sig
  } || {
    echo "could not find $1"
  }
}

alias gpe="gpg_encrypt"
alias gpd="gpg_decrypt"

# GPG sign
gps() {
  gpg --clearsign $1
  cat $1.asc | xclip
  cat $1.asc
}



encrypt() {
  [[ ! -f $1 ]] && nano
  gpg -c $1
  rm $1
}

decrypt() {
  [[ -f $1 ]] && file=$1 || {
    [[ -f $1.gpg ]] && file=$1.gpg || echo "file not found $1" && return
  }


  [[ ! -z $2 ]] && {
    gpg $file
  } || {
    TXT=$(gpg --decrypt $file 2>/dev/null)
    echo $TXT
  }
}
alias dcr="decrypt"
alias enc="encrypt"
