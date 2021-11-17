
download() {
wget  "https://api.wordpress.org/plugins/info/1.1/?action=query_plugins" -O plugins.json
}

extract() {


for i in $(gron plugins.json | grep versions.trunk | grep -E "(http.*)\"" -o | sed 's/"//')                                                                       5:44PM
do
zip="${i:t}"
[[ ! -f zip/$zip ]] && {

[[ $zip != "5:44PM"  ]]  && {
  wget $i
}

}

[[ $zip != "5:44PM"  ]]  && {
#echo $zip
file="${zip:t}"
#echo  $file
unzip zip/$zip
}



done

}
