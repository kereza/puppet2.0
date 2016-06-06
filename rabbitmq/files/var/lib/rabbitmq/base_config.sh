#!/bin/bash

# this script should be run as root or the rabbitmq user, prefereably as a cron entry once a day

# This script sets some base configuration for rabbitmq.
# 1) it will check that the /var/lib/rabbitmq/.erlang.cookie is not zero length.  If it is, it will set a value (based on the hostname)
# 2) it will check if the base plugins are enabled.  If not, it will enable them
# 3) it will test if the netscaler user exists.  If not, it will create it and set its user tag
# 4) it will test if the netscaler vhost exists.  If not, it will create it
# 5) it will test if the netscaler user has .* .* .* access to the netscaler vhost.  If not, it will set the permissions.

# erlang cookie
ERLANG_COOKIE=/var/lib/rabbitmq/.erlang.cookie
if [ ! -f $ERLANG_COOKIE ]; then  # does file exist
  touch $ERLANG_COOKIE
fi

# If this is zero length, then we'll set it to the servername without the number at the end
# that way, it will be the same on similarly named servers (and thus will be good for clustering)
# Puppet sometimes writes this file, so we aren't concerned with the value in the file if it's different, we only want to ensure that something is there.
if [ ! -s $ERLANG_COOKIE ]; then  # does file exist and has size > 0
  chmod 700 $ERLANG_COOKIE   # puppet will make the file read only...
  hostname | sed "s/[0-9]*$//" > $ERLANG_COOKIE
  chmod 400 $ERLANG_COOKIE   # put it back to read only again
fi

# put rabbitmqadmin into the /var/lib/rabbitmq/bin/ folder.  We'll do this every time so that we always have the latest version
mkdir -p /var/lib/rabbitmq/bin
chmod 775 /var/lib/rabbitmq/bin
pushd /var/lib/rabbitmq/bin >/dev/null 2>&1
wget --no-check-certificate -N https://localhost:15671/cli/rabbitmqadmin -O /var/lib/rabbitmq/bin/rabbitmqadmin >/dev/null 2>&1
rm /var/lib/rabbitmq/bin/rabbitmqadmin.* >/dev/null 2>&1  # remove duplicate downloads when -N and -O weren't specified above
chmod 775 rabbitmqadmin
popd >/dev/null 2>&1


# for the rest of the script, rabbitmq needs to be running, so we'll exit here if it's not running
if ! /usr/sbin/rabbitmqctl status 2>&1 >/dev/null ; then
  echo "RabbitMQ is not running on this node - exiting"
  exit 1
fi


# plugins - list in the array any plugins we want to ensure are enabled by default on all rabbitmq instances.
# dependant plugins will be enabled automatically
# adding plugins requires a restart of rabbitmq for them to take effect - this script will not handle that!
plugins=(rabbitmq_management)

function is_plugin_enabled {
    /usr/sbin/rabbitmq-plugins list | grep $1 | grep -i "^\[e\]" 2>&1 >/dev/null
}

function enable_plugin {
    /usr/sbin/rabbitmq-plugins enable $1
}

for p in ${plugins[@]}; do
  if ! is_plugin_enabled $p ; then
    enable_plugin $p
  fi
done

# netscaler user
# yes, the password is listed here.
# however, this user will have access only to the netscaler vhost in rabbit, so won't be able to access anything else.
# The user also only has monitoring access
if ! /usr/sbin/rabbitmqctl -q list_users | grep netscaler 2>&1 >/dev/null ; then
  /usr/sbin/rabbitmqctl add_user netscaler hwNCKJ2KcryLRjPfpFxwvnZyv
fi

# check if the monitoring role is set, and set it if it isn't.
if ! /usr/sbin/rabbitmqctl -q list_users | grep netscaler | grep monitoring 2>&1 >/dev/null ; then
  /usr/sbin/rabbitmqctl set_user_tags netscaler monitoring
fi


# netscaler vhost
if ! /usr/sbin/rabbitmqctl -q list_vhosts | grep netscaler 2>&1 >/dev/null ; then
  /usr/sbin/rabbitmqctl add_vhost netscaler
fi


# netscaler user permissions
count=`/usr/sbin/rabbitmqctl -q list_user_permissions netscaler | grep netscaler | sed "s/\.\*/\n/g" | wc -l`
if [ $count != 4 ]; then
  /usr/sbin/rabbitmqctl set_permissions -p netscaler netscaler ".*" ".*" ".*"
fi


