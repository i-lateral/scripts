#!/bin/bash

datestring="`date +%Y`-`date +%m`-`date +%d`"
rootdir=${1%/}
backupdir="$rootdir"/backups

# If we have not had a path set, exit
if [ -z "$rootdir" ]; then
    echo "You need to proved a path to scan"
    exit
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
        /usr/local/bin/sspak save "$rootdir"/"$dirname" "$backupdir"/"$dirname"-"$datestring".sspak
    fi
done

