remove_quotes() {

cat /dev/stdin | sed 's/"//g'
}


remove_single_quotes() {
cat /dev/stdin | sed "s/'//g"
}

remove_all_quotes() {
cat /dev/stdin | sed "s/'//g" | sed 's/"//g'

}
