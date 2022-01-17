quote() {
cat /dev/stdin | grep -E '"(.*)"' -o | sed 's/"//g' 

}
