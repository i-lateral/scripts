#!/bin/bash

export savepath="/srv/backups/dbase/`date +%Y`-`date +%m`-`date +%d`/"
export usr='backups'
export pwd='p2LhdZGPH7XsFadT'
if [ ! -d $savepath ]; then
    mkdir -p $savepath
fi
chmod 700 $savepath
rm -rf $savepath/*
echo 'mySQL Backup Script'
echo 'Dumping individual tables..'
for a in `echo 'show databases' | mysql -u$usr -p$pwd | grep -v Database | grep -v information_schema`;
do
echo $a
  mkdir -p $savepath/$a
  chmod 700 $savepath/$a
  echo "Dumping database: $a"
  for i in `echo 'show tables' | mysql -u$usr -p$pwd $a| grep -v Tables_in_ |sed -e 's/ /_/g'`;
  do
   echo " * Dumping table: $i"
   mysqldump --compact --allow-keywords --add-drop-table --allow-keywords --skip-dump-date -q -a -c -u$usr -p$pwd $a $i$
   gzip -f $savepath/$a/$i.sql
   chmod 600 $savepath/$a/$i.sql.gz
  done
done
