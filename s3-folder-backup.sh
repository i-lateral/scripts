#!/bin/bash

# Simple script that compresses and copies all files from a foler into a provided
# S3 bucket name

# Thanks to: http://www.vps2.me/automatic-backup-script-linux-mysql-files-amazon-s3/
# for the basics of this script

# This script expects two arguments:
#
# - dirname: The path to the directory to backup
# - bucket: name of the S3 bucket
#
# You can also provide an optional third argument:
#
# - backupdir: location to place backups
#
# Example usage:
#
#   ./s3-folder-backup.sh /path/to/folder bucket-name [/path/to/backups]

datestring=$(date +%Y-%m-%d);
backupdir="/tmp/backups/";

if [ -z "$1" ]; then
  echo "No dir name provided";
  exit;
else
  dirname=$1;
fi

if [ -z "$2" ]; then
  echo "No s3 bucket name provided";
  exit;
else
  bucket=$2;
fi

if [ "$3" ]; then
  backupdir=$3;
fi

filename="${dirname//\//-}";

# Make backups dir is not existing
if [ ! -d "$backupdir" ]; then
    mkdir $backupdir
fi

# export files
echo "Creating backup $filename at $backupdir";
tar -cpzf ${backupdir}${filename}-${datestring}.tar.gz -C / ${dirname};

# remove backups older than 1 days
find ${backupdir} -mtime +1 -exec rm {} \;

# sync to amazon
echo "Syncing with $bucket";
s3cmd sync ${backupdir} s3://${bucket} --delete-after

