#!/bin/bash

DIR="../";
DATE=$(date +%Y-%m-%d);

cd $DIR/httpdocs;

echo  "[$DATE] Running composer and sake" > $DIR/logs/deployment.log;
composer install --no-dev 2>&1 | tee -a $DIR/logs/deployment.log;
php framework/cli-script.php dev/build flush=1 >> $DIR/logs/deployment.log;
php framework/cli-script.php / flush=1;

## If cache dir is present, clear it
echo "[$DATE] Clearing Cache";
if [ ! -d "silverstripe-cache" ]; then
    rm -fR silverstripe-cache/*
fi

## Ensure correct permissions are set on assets
echo "[$DATE] Setting Assets Permissions";
chmod -R 777 assets;
