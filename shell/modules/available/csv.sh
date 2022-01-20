csv() {

  CLS="csv"
  local file="$file"
  shift
  delimiter="${delimiter:-,}"

  shift shift
  local columns="$@"
while IFS=$delimiter read -r $colums
do
done < $file

}
