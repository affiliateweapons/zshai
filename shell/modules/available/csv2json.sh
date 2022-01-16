csv2json() {
jq -Rsn '
  {"contracts":
    [inputs
     | . / "\n"
     | (.[] | select(length > 0) | . / ";") as $input
     | {"txhash": $input[0], "addres": $input[1], "token": $input[2] } 

' <$1
}
