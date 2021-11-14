## functions to build sitemap urls from wordpress sitemap xml files
## use this to pre-built cache files to serve as static html
download_sitemap() {
  for i in $(clm sitemap.list); do
    wget $i
  done

}

cachegen() {
  echo > cache.index
  for i in $('ls' *.list); do
    clm $i >> cache.index
  done


  count cache.index

}

build_cache() {
  local cachedir=$PWD/cache
  for i in $(cat cache.index); do
    md5=$(echo $i | md5);
    wget $i -O $cachedir/$md5
  done

  ls cache | wc -l
  ds
}
