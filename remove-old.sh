#!/bin/bash

# Remove all files older than 60 days
find /srv/backups/dbase -mtime +60 -exec rm {} \;
