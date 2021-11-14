# copy path of file to clipboard
cpath() {
  echo $PWD
  realpath $PWD/$1 | xclip
}
