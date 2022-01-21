count() {
  [[ -f /var/log/$1.log ]] && {
    cat /var/log/$1.log | wc -l
  } || {
    [[ -f $1 ]]  &&  {
      cat $1 | wc -l
    } || {

      data=$(cat /dev/stdin) 
echo $data | wc -l
#      echo "file $1 does not exist"
    }
  }
}


list_count_words() {
local ignorefile="$ZSHAI_DATA/wordlist/stopwords"
local input="$(cat /dev/stdin)"
echo "${input:l}" \
| strip_ansi \
| sed 's,\t,,g' \
| sed 's,[/-], ,g' \
| grep -v "^\s*$" \
| sed 's/\b\w\b \?//g' \
| tr '[:space:]' '[\n*]' \
| sed '/^[[:space:]]*$/d' \
| grep -v "[^a-z]" \
| sort \
| uniq -c \
| sort -bnr \
| grep -vwf $ZSHAI_DATA/wordlist/stopwords \
#tr '[:space:]' '[\n*]' \
#| grep -v "[^a-z]" \
#| sed 's/\b\w\b \?//g' \
#| sed '/^[[:space:]]*$/d' \
#| sort \
#| uniq -c \
#| sort -bnr \
#| grep -vF "$ZSHAI_DATA/wordlist/stopwords" \
#| tr '[:space:]' '[\n*]' \
#| grep -v "abc"

}

#| grep -vF "$ZSHAI_DATA/wordlist/stopwords" \
#| grep -vF "$ZSHAI_DATA/wordlist/xac" \
#| grep -vF "$ZSHAI_DATA/wordlist/xaa" \
#| grep -vF "$ignorefile" \
