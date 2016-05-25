# Server Backup Scripts 

The scripts in this repo are used for standard server backups. By default they backup everything
to the /srv/backups directory and remove any files in that directory older than 60 days.

## Usage

These scripts should be run via cron. You can add these entries to your crontab (preferably as
root).

01 03 * * * /opt/backup-scripts/db-backup.sh
01 04 * * * /opt/backup-scripts/remove-old.sh

