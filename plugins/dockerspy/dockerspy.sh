#!/usr/bin/env zsh
FORMAT1='{{.ID}} {{.CreatedSince}} {{.CreatedAt}} {{.Comment}} {{.Size}} +++ {{.CreatedBy}}'
FORMAT2='{{.CreatedBy}}'
FORMAT_IMG='{{.ID}} {{.Repository}} {{.CreatedAt}}  {{.Size}}'

img_dir=$PWD/data
mkdir -p $img_dir
mkdir -p $img_dir/short
mkdir -p $img_dir/cmd

docker images -a --format="$FORMAT_IMG" > $img_dir/list.csv
return
for i in $(docker images -a -q)
do
  docker history $i \
  --no-trunc \
  --format "$FORMAT1" \
  > $img_dir/short/$i

  docker history $i \
  --no-trunc \
  --format "$FORMAT2" \
  > $img_dir/cmd/$i
done
