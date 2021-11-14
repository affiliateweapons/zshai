ls_find() {

case $1 in
-r)
  shift
  ls --recursive  | grep $1

;;
*)
echo $1
;;
esac

#ls | grep $1

}
alias lsf="ls_find"
alias lsfr="ls_find -r"
