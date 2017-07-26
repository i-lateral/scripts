# Server Scripts 

The scripts in this repo are usefull for repetative server tasks (such as backups,
setting up a new hosting account, etc).

Some of these scripts are single use, others are designed to be run via cron.

## Scripts in this repo

The following scripts are located here:

### db-backup.sh (cron script)

Generic backup script for MySQL databases

### hostingsetup.sh

Setup a new hosting environment ready for SS site

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

## Cron Usage

Some scripts are intended to be run via cron. You can add these entries to your
crontab (preferably as root), EG:

01 03 * * * /opt/backup-scripts/db-backup.sh

