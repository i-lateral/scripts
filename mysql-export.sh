#! /bin/bash

TIMESTAMP=$(date +"%F")
BACKUP_DIR="/home/backup/db/$TIMESTAMP"
MYSQL_USER="root"
MYSQL=/usr/bin/mysql
MYSQL_PASSWORD="2VdazKkpN7ntHcBL4vCd"
MYSQLDUMP=/usr/bin/mysqldump

mkdir -p "$BACKUP_DIR"

databases=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|pe$

for db in $databases; do
  if [ -f "$BACKUP_DIR/$db.gz" ]
  then
    echo "Skipping existing file: $BACKUP_DIR/$db.gz"
  else
    $MYSQLDUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db | gzip > "$BACKUP_DIR/$db.gz"
    echo "Exported $db"
  fi
done
