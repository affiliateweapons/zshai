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

ls_symbolic_links() {
local q="$1"
[[ -z $2 ]]  && {
'ls' -lR $2 | 'grep' ^l | grep "$q"
} || {
  'ls' -lR | 'grep' ^l | grep "$q"
}


}



alias lsl="ls_symbolic_links"
