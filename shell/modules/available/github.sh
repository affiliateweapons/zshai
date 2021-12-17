alias gh="cd ~/gh;ls"


download_repo() {
  [[ -z $i ]] && return || wget $i -O ${${a//${a:h2}\/}//\//_}.zip
}

# extract repo urls from md files
extract_urls() {
  local repos="${1:-README.md}"
  local save_as="${2:-repos.csv}"
  vared -p "File: " -e repos
  [[ -z "${repos}" ]] && return
  vared -p "Save as: " -e save_as
  cat $repos | grep -Eo "http.?* -" | sed 's/ -//g' > $save_as
}



fzf_convert_csv() {
  local file=$1

  [[ -f "$file.csv" ]] &&  file="$file.sv" || {
    [[ -f "$file" ]]  && {
      for i in $(cat $file);
      do
        echo $i  \
        | sed 's/,/\//g' \
        | sed 's/refs\/heads\///g' \
        |  prepend "http://raw.githubusercontent.com"
      done
    }

  }
}

user_repos() {
  local user=${1:-pixura}
  local endpoint="https://api.github.com/users/$user/repos"
  local view=${2:-default}

  local response=$(curl -s $endpoint | gron)

  case view in
    *)
      echo $response | grep "]\.svn_url" | quotes  
    ;;
  esac


}

multi_clone() {

  c=0
  for i in $(cat /dev/stdin)

  do
  (( c++ ))
    targit $i
  done


}
alias gh="cd ~/gh;ls"


download_repo() {
  [[ -z $i ]] && return || wget $i -O ${${a//${a:h2}\/}//\//_}.zip
}

# extract repo urls from md files
extract_urls() {
  local repos="${1:-README.md}"
  local save_as="${2:-repos.csv}"
  vared -p "File: " -e repos
  [[ -z "${repos}" ]] && return
  vared -p "Save as: " -e save_as
  cat $repos | grep -Eo "http.?* -" | sed 's/ -//g' > $save_as
}



fzf_convert_csv() {
  local file=$1

  [[ -f "$file.csv" ]] &&  file="$file.sv" || {
    [[ -f "$file" ]]  && {
      for i in $(cat $file);
      do
        echo $i  \
        | sed 's/,/\//g' \
        | sed 's/refs\/heads\///g' \
        |  prepend "http://raw.githubusercontent.com"
      done
    }

  }
}

user_repos() {
  local user=${1:-pixura}
  local endpoint="https://api.github.com/users/$user/repos"
  local view=${2:-default}

  local response=$(curl -s $endpoint | gron)

  case view in
    *)
      echo $response | grep "]\.svn_url" | quotes  
    ;;
  esac


}

multi_clone() {

  c=0
  for i in $(cat /dev/stdin)

  do
  (( c++ ))
    targit $i
  done


}
