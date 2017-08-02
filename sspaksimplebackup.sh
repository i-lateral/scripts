#!/bin/bash

# Simple script that uses SSPAK to backup a silverstripe site
# for 7 days (clearing all backups older than 7 days)
datestring=$(date +%Y-%m-%d);
dirname=${1%/};
backupdir=backup;

cd ~;

# Make backups dir is not existing
if [ ! -d "$backupdir" ]; then
    mkdir $backupdir;
fi

# Clearing existing backups
echo "Clearing existing backups";
find "$backupdir" -mtime +5 -type f -delete;

# Save the selected directory
echo "Running SSPAK on $dirname";
./bin/sspak save $dirname $backupdir/$datestring.sspak

