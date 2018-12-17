#!/bin/bash

# Simple script that runs SSPAK on SS projects in a folder
# and moves them to a backup location
#
# This scripts accepts two arguments:
#
# 1. Required: The location on the filesystem of the projects
# 2. Optional: a custom location of sspak (if not /usr/local/bin/sspak)
#
datestring="`date +%Y`-`date +%m`-`date +%d`"
rootdir=${1%/}
backupdir="$rootdir"/backups

# If we have not had a path set, exit
if [ -z "$rootdir" ]; then
    echo "You need to proved a path to scan"
    exit
fi

# check if we are using a custom location for SSPAK
if [ -z "$2" ]; then
  sspakloc="/usr/local/bin/sspak";
else
  sspakloc=$2;
fi

# Make backups dir is not existing
if [ ! -d "$backupdir" ]; then
    mkdir $backupdir
fi

echo "Clearing existing backups and running SSPAK on $rootdir"

# Clearing existing backups
rm "$backupdir"/*

# Loop through all directories and backup where appropriate
for dir in $rootdir/*/; do
    dirname=${dir/"$rootdir"/""}
    dirname=${dirname/"/"/""}
    dirname=${dirname%/}
    if [ "$dirname" != "weblite" ] && [ "$dirname" != "backups" ] && [ "$dirname" != "scripts" ]; then
        echo "Packing $dirname"
        ${sspakloc} save "$rootdir"/"$dirname" "$backupdir"/"$dirname"-"$datestring".sspak
    fi
done

