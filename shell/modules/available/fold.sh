
fld() {
  [[ -f $1 ]] && {
  file=$1
  width=${2:-120}
  }
  'fold' -w $width -s $file
}
