ee_backup() {

  ee="/opt/easyengine/sites"
  backup="/home/backup"
  sites=$('ls' $ee)
  year=`date +%Y`
  month=`date +%m`
  day=`date +%d`
  date=`date +%Y-%m-%d`

  mkdir -p $backup/$year/$month/$day

  for i in $sites
  do
  #       ee shell $i --command="wp db export $i.sql"
          cd $ee/$i/app && tar czvf $i.tar.gz htdocs
  #       rm $ee/$i/app/htdocs/$i.sql
          mv $ee/$i/app/$i.tar.gz $backup/$year/$month/$day
  done

}

ee_sites() {
'ls' /opt/easyengine/sites
}

eelogs() {
    find /var/lib/docker/volumes/*_log_*/_data -type f | \
    fzf --preview="tac {}" --preview-window=top,70%
}
