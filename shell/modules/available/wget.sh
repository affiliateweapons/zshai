
download_list() {
local dir="$PWD/build"
for q in $(cat $1);
do
wget ${q/*=/} -O $dir/${q/=*/}.png

done
}
# echo ${q/*=/}
#echo ${q/=*/}
