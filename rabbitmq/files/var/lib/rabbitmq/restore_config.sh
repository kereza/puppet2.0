#!/bin/bash

#restore config. from a  backup file
#needs a parameter (name  of the backup file)

if [ "x$1" == "x" ]; then
  echo "Usage: $0 /path/to/config_file"
  echo "       where config_file is the name of the file you wish to restore"
  exit 1
fi

echo $USER
if [ "$USER" != "rabbitmq" -a "$USER" != "root" ]; then
  echo "This script must be run as either the rabbitmq user, or root"
  exit 2
fi

/usr/sbin/rabbitmqctl -q add_user backup b4ckup03
/usr/sbin/rabbitmqctl -q set_user_tags backup "administrator"
/usr/sbin/rabbitmqctl -q set_permissions backup ".*" ".*" ".*"
cd /var/lib/rabbitmq/backups
backup_file=$1
/usr/sbin/rabbitmqadmin -s --port=15671 --username=backup --password=b4ckup03 import $backup_file
/usr/sbin/rabbitmqctl -q delete_user backup
