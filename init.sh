#!/bin/sh

service sshd start

#Redis Config
#
service redis start
if [ -z "$REDIS_MASTER_PORT_6379_TCP_ADDR" ]; then
  echo "REDIS_MASTER_PORT_6379_TCP_ADDR not defined. Did you run with -link?";
else
  redis-cli slaveof $REDIS_MASTER_PORT_6379_TCP_ADDR 6379
fi

#Sentinel Config
#
if [ -z "$REDIS_MASTER_PORT_6379_TCP_ADDR" ]; then
  echo "REDIS_MASTER_PORT_6379_TCP_ADDR not defined. Did you run with -link?";
  sed -i -e "s/^sentinel monitor.*/sentinel monitor mymaster `ip -f inet addr show eth0 | awk '/inet/{ print $2}' | cut -d'/' -f1` 6379 1/g" /etc/redis-sentinel.conf
else
  sed -i -e "s/^sentinel monitor.*/sentinel monitor mymaster $REDIS_MASTER_PORT_6379_TCP_ADDR 6379 1/g" /etc/redis-sentinel.conf
fi
service redis-sentinel start

while [[ true ]]; do
  /bin/bash
done
