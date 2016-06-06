#!/bin/bash

# this script should be run as a cron job of rabbitmq

if [ "$USER" != "rabbitmq" -a "$USER" != "root" ]; then
  echo "This script must be run as either the rabbitmq user or root"
  exit 1
fi

today=$(date +"%m_%d_%Y")
echo "Backup proccess for: " $today

#create the backups directory
BACKUP_DIR=/var/lib/rabbitmq/backups
if [ ! -d $BACKUP_DIR ]; then
   mkdir -p  $BACKUP_DIR
fi

#create daily backup
/usr/sbin/rabbitmqctl -q add_user backup b4ckup03
/usr/sbin/rabbitmqctl -q set_user_tags backup "administrator"
/usr/sbin/rabbitmqctl -q set_permissions backup ".*" ".*" ".*"
cd /var/lib/rabbitmq/backups
/var/lib/rabbitmq/bin/rabbitmqadmin -s --port=15671 --username=backup --password=b4ckup03 export `hostname`-$today.config
/usr/sbin/rabbitmqctl -q delete_user backup

#keep the 7 last backups
ls -1tr /var/lib/rabbitmq/backups/* | head -n -7 | xargs -d '\n' rm -f

echo "End - Backup proccess for: " $today

