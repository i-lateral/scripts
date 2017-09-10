# Server Scripts 

The scripts in this repo are usefull for repetative server tasks (such as backups,
setting up a new hosting account, etc).

Some of these scripts are single use, others are designed to be run via cron.

## Scripts in this repo

The following scripts are located here:

### db-backup.sh (cron script)

Generic backup script for MySQL databases

### hostingsetup.sh

Single use script that can be uploaded to a new hosting environment and used
to install required commands and perform some "pre-flight checks".

### remove-old.sh (cron script)

Simple script design to remove old (over 30 days) backup files 

### sspakrunner.sh (cron script)

Call this with a location (eg /var/www) and it will backup all SS sites
using SSPAK

### sspaksimplebackup.sh (cron script)

Simple backup script that:

* Creates a "backup" folder in the user's home folder.
* Removes all files in the "backup" folder after 7 days.
* Generates a new backup file (SSPAK) with today's datestamp as a name.

### deployment.sh

Simple script that can be called after SS automated deployment, this script:

* Runs composer install (no dev dependencies)
* Runs a dev/build
* Runs a call the the root URL of the site and clears cache

### mysql-export.sh

A simple script that exports every database on the local mysql server as a
seperate gz file.

Usefull transfering all DB's from one server to another or backing up a DB
server.

Thanks to https://mensfeld.pl/2013/04/backup-mysql-dump-all-your-mysql-databases-in-separate-files/

## Cron Usage

Some scripts are intended to be run via cron (identified above as cron scripts).
You can add these entries to your crontab, EG:

01 03 * * * /opt/backup-scripts/db-backup.sh

