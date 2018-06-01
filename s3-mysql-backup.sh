#!/bin/bash

# Simple script that compresses and copies all databases into tarballs
# and uploads them to the provided s3 bucket
#
# Thanks to: http://www.vps2.me/automatic-backup-script-linux-mysql-files-amazon-s3/
# for the basics of this script

# This script expects three arguments:
#
# - username: The database username
# - password: the database password
# - bucket: name of the S3 bucket
#
# You can also provide an optional forth argument:
#
# - backupdir: location to place backups
#
# Example usage:
#
#   ./s3-folder-backup.sh /path/to/folder bucket-name [/path/to/backups]

datestring=$(date +%Y-%m-%d);
backupdir="/tmp/backups/db/";

if [ -z "$1" ]; then
  echo "No username provided";
  exit;
else
  uname=$1;
fi

if [ -z "$2" ]; then
  pword="";
else
  pword=$2;
fi

if [ -z "$3" ]; then
  echo "No s3 bucket name provided";
  exit;
else
  bucket=$3;
fi

if [ "$4" ]; then
  backupdir=$4;
fi

# Make backups dir is not existing
if [ ! -d "$backupdir" ]; then
    mkdir $backupdir
fi

for a in `echo 'show databases' | mysql -u${uname} -p${pword} | grep -v Database | grep -v information_schema`; do
  echo "Dumping database: $a"
  if [ -z "$pword" ]; then
    # Password not set
    mysqldump -u${uname} --compact --complete-insert --single-transaction "${a}" > "${backupdir}${a}-${datestring}".sql;
  else
    # Password set
    mysqldump -u${uname} -p${pword} --compact --complete-insert --single-transaction "${a}" > "${backupdir}${a}-${datestring}".sql;
  fi
done

# remove backups older than 1 days
find ${backupdir} -mtime +1 -exec rm {} \;

# sync to amazon
s3cmd sync ${backupdir} s3://${bucket}

