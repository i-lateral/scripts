#!/bin/bash

# Simple script that gets a list of sql files from a location and then restores them
# to the target db
#
# This script requires mysql to be installed on the command line and expects these arguments
#
# - location: path/string of the sql files to find
# - username: The database username
# - password: the database password
# - host: hostname of DB server (defaults to localhost)
# - port: DB port
#
# Example Usage:
#     ./db-restore.sh /path/to/location/*.sql root root localhost 3306

location=$1;
datestring=$(date +%Y-%m-%d);

if [ -z "$2" ]; then
  echo "No username provided";
  exit;
else
  uname=$2;
fi

if [ -z "$3" ]; then
  pword="";
else
  pword=$3;
fi

if [ -z "$4" ]; then
  echo "No host provided, using localhost";
  host="localhost";
else
  host=$4;
fi

if [ -z "$5" ]; then
  echo "No port provided, using 3306";
  port="3306";
else
  port=$5;
fi

echo "Importing files";

## Loop through all required files
i=0;

for f in $location; do
  # Get the base filename of this file
  filename="$(basename -- $f)";
  
  # Get the DB name from the file
  dbname=${filename%"-$datestring.sql"};
  
  echo "Importing $dbname";

  # Create DB
  mysqladmin --user=${uname} --password=${pword} --host=${host} --port=${port} create ${dbname};

  # Import db file into new DB
  mysql --user=${uname} --password=${pword} --host=${host} --port=${port} ${dbname} < ${f};

  i=$((i+1));
done

echo "Processed ${i} databases";
