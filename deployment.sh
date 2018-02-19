#!/bin/bash

# Simple script to auto build and deploy SS websites
# using composer.
#
# This script expects 3 arguments:
#   - WEBROOT (the path of the directory the site is installed in)
#   - LOGDIR (the directory the deployment logs are to be saved)
#   - SAKE (the location of the SAKE binary)
#   - COMPOSER (the location of the composer executable)
#
# Example usage of this script:
#   ./deployment.sh ~/httpdocs ~/logs ~/scripts/sake "/path/to/php /path/to/composer.phar"
#

if [ -z "$1" ]; then
  WEBROOT="~/httpdocs";
else
  WEBROOT=$1;
fi

if [ -z "$2" ]; then
  LOGDIR="~/logs";
else
  LOGDIR=$2;
fi

if [ -z "$3" ]; then
  SAKE="~/scripts/sake";
else
  SAKE=$3;
fi

if [ -z "$4" ]; then
  COMPOSER="composer";
else
  COMPOSER=$4;
fi

DATE=$(date +%Y-%m-%d);

cd $WEBROOT;

echo  "[$DATE] Running composer and sake" > $LOGDIR/deployment.log;
$COMPOSER install --no-dev 2>&1 | tee -a $LOGDIR/deployment.log;
$SAKE dev/build flush=1 >> $LOGDIR/deployment.log;
$SAKE / flush=1;

## If cache dir is present, clear it
echo "[$DATE] Clearing Cache" >> $LOGDIR/deployment.log;
if [ ! -d "silverstripe-cache" ]; then
    rm -fR silverstripe-cache/*
fi

## Ensure correct permissions are set on assets
echo "[$DATE] Setting Assets Permissions" >> $LOGDIR/deployment.log;
chmod -R 777 assets;
