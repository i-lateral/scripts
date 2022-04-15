#!/bin/bash

# Sometimes we have a site that fails to close connections to MySQL
# corrently, which leaves sleeping processes open and can cause
# connection issues to the DB. While diagnosing the issue (and
# implementing a fix), it can help to run a script to kill these
# sleeping processes. Thanks to the following site for the code:
# https://github.com/bobbyiliev/kill-sleeping-mysql-processes
# https://www.bobbyiliev.com/blog/killing-mysql-queries-sleeping-long-period-time
#

#
# This script expects that the current server user can login to
# mysql server, either because the account is given permission to
# mysql or because the user has ~/.my.cnf configured
# 
# Optionally, you can pass the following argument:
#
# - allowedsleep: how long the queery has been sleeping (defaults to 60)
#
# Example usage:
#
#   ./killsleepingquerys.sh [allowedsleep]

if [ -z "$1"]; then
  allowedsleep=60;
else
  allowedsleep=$1;
fi

sleepingProc=$(mysqladmin proc | grep Sleep);
prockilled=0;

for i in $(mysql -e 'show processlist' | grep 'Sleep' | awk '{print $1}'); do
	sleeptime=$(mysqladmin proc | grep "\<$i\>" | grep -v '\-\-' | grep -v 'Time' | awk -F'|' '{ print $7 }' | sed 's/ //g' | tail -1);
	sleeptime=$((sleeptime + 1));

    echo "${i} has been sleeping for ${sleeptime} seconds";

	if [ "$sleeptime" -gt "$allowedsleep" ]; then
        echo "Killed proccess: ${i} sleeping for more than ${allowedsleep} seconds";
        mysql -e "kill ${i}";
        prockilled=$((prockilled+1));
	fi
done
